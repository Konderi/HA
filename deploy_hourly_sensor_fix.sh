#!/bin/bash
# Automated Fix for sensor.talon_kokonaiskulutus_tunti_kwh
# This script deploys the total energy sensor to Home Assistant
# Date: 2026-02-14

set -e  # Exit on error

echo "=========================================="
echo "🔧 Hourly Consumption Sensor Fix"
echo "=========================================="
echo ""

# Configuration
HA_HOST="${HA_HOST:-homeassistant}"
HA_USER="${HA_USER:-root}"
SENSOR_FILE="config/sensors/total_energy_sensor.yaml"
CONFIG_FILE="/config/configuration.yaml"

echo "📋 Deployment Settings:"
echo "   Host: $HA_USER@$HA_HOST"
echo "   Sensor File: $SENSOR_FILE"
echo ""

# Check if sensor file exists
if [ ! -f "$SENSOR_FILE" ]; then
    echo "❌ Error: $SENSOR_FILE not found!"
    echo "   Make sure you're running this from the Git repository root."
    exit 1
fi

echo "✅ Sensor file found"
echo ""

# Step 1: Create sensors directory on Home Assistant
echo "📁 Step 1: Creating sensors directory..."
ssh "$HA_USER@$HA_HOST" "mkdir -p /config/sensors" 2>/dev/null || true
echo "✅ Directory ready"
echo ""

# Step 2: Copy sensor file
echo "📤 Step 2: Copying sensor file to Home Assistant..."
scp "$SENSOR_FILE" "$HA_USER@$HA_HOST:/config/sensors/"
echo "✅ Sensor file copied"
echo ""

# Step 3: Backup configuration.yaml
echo "💾 Step 3: Backing up configuration.yaml..."
ssh "$HA_USER@$HA_HOST" "cp $CONFIG_FILE ${CONFIG_FILE}.backup-$(date +%Y%m%d-%H%M%S)"
echo "✅ Backup created"
echo ""

# Step 4: Check if template section exists
echo "🔍 Step 4: Checking configuration.yaml..."
HAS_TEMPLATE=$(ssh "$HA_USER@$HA_HOST" "grep -c '^template:' $CONFIG_FILE" || echo "0")

if [ "$HAS_TEMPLATE" -gt 0 ]; then
    echo "⚠️  Found existing 'template:' section in configuration.yaml"
    echo ""
    echo "You need to manually merge the template sensor."
    echo ""
    echo "Option 1 - Change to include directory:"
    echo "  Change: template: !include templates.yaml"
    echo "  To:     template: !include_dir_merge_list sensors/"
    echo ""
    echo "Option 2 - Add to existing templates file:"
    echo "  Copy content from /config/sensors/total_energy_sensor.yaml"
    echo "  Into your existing templates file"
    echo ""
    echo "Would you like to view your current template section? (y/n)"
    read -r RESPONSE
    if [ "$RESPONSE" = "y" ]; then
        ssh "$HA_USER@$HA_HOST" "grep -A 5 '^template:' $CONFIG_FILE"
    fi
    echo ""
    echo "After updating, run:"
    echo "  ssh $HA_USER@$HA_HOST 'ha core check && ha core restart'"
else
    echo "✅ No existing template section found"
    echo "📝 Adding template include to configuration.yaml..."
    
    # Add template include
    ssh "$HA_USER@$HA_HOST" "echo '' >> $CONFIG_FILE && echo '# Total energy sensor (sum of 3 phases from ShellyEM3)' >> $CONFIG_FILE && echo 'template: !include sensors/total_energy_sensor.yaml' >> $CONFIG_FILE"
    
    echo "✅ Configuration updated"
    echo ""
    
    # Step 5: Validate configuration
    echo "🔍 Step 5: Validating configuration..."
    if ssh "$HA_USER@$HA_HOST" "ha core check" 2>&1 | grep -q "valid"; then
        echo "✅ Configuration is valid!"
        echo ""
        
        # Step 6: Offer to restart
        echo "🔄 Step 6: Restart Home Assistant?"
        echo "   This will apply the changes."
        echo ""
        echo "   Restart now? (y/n)"
        read -r RESTART_RESPONSE
        
        if [ "$RESTART_RESPONSE" = "y" ]; then
            echo "🔄 Restarting Home Assistant..."
            ssh "$HA_USER@$HA_HOST" "ha core restart"
            echo "✅ Restart initiated"
            echo ""
            echo "⏳ Wait 2-3 minutes, then verify:"
            echo "   1. Go to Developer Tools → States"
            echo "   2. Search for: sahkon_kokonaisenergia"
            echo "   3. Should show ~64,645 kWh"
            echo ""
            echo "📊 Wait 1-2 hours for utility meters to accumulate data:"
            echo "   - sensor.talon_kokonaiskulutus_tunti_kwh should show > 0"
        else
            echo "⏭️  Skipped restart"
            echo ""
            echo "To restart manually:"
            echo "   ssh $HA_USER@$HA_HOST 'ha core restart'"
        fi
    else
        echo "❌ Configuration validation failed!"
        echo ""
        echo "Errors:"
        ssh "$HA_USER@$HA_HOST" "ha core check" 2>&1
        echo ""
        echo "💾 Configuration backup available:"
        echo "   ssh $HA_USER@$HA_HOST 'ls -la $CONFIG_FILE.backup-*'"
        echo ""
        echo "To restore:"
        echo "   ssh $HA_USER@$HA_HOST 'cp \$(ls -t ${CONFIG_FILE}.backup-* | head -1) $CONFIG_FILE'"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "🎉 Deployment Complete!"
echo "=========================================="
echo ""
echo "📚 Next Steps:"
echo "   1. Verify sensor exists (Developer Tools → States)"
echo "   2. Wait 1 hour for hourly meter data"
echo "   3. Check dashboard charts"
echo ""
echo "📖 Full guide: FIX_HOURLY_CONSUMPTION_SENSOR.md"
echo ""
