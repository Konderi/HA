#!/bin/bash
# Script to find and fix utility meter source sensor
# Changes sensor.sahkon_kokonaisenergia to sensor.sahkon_kokonaisenergia_2

HA_HOST="${HA_HOST:-homeassistant}"
HA_USER="${HA_USER:-root}"

echo "=========================================="
echo "🔍 Finding Utility Meter Configuration"
echo "=========================================="
echo ""

# Step 1: Find where utility meters are configured
echo "1️⃣ Searching for utility meter configuration..."
echo ""

ssh "$HA_USER@$HA_HOST" "grep -rn 'talon_kokonaiskulutus_tunti' /config/*.yaml /config/packages/*.yaml 2>/dev/null || grep -rn 'talon_kokonaiskulutus_tunti' /config/*.yaml 2>/dev/null"

echo ""
echo "─────────────────────────────────────────"
echo ""
echo "📝 Found the file(s) above."
echo ""
echo "Now we need to edit them to change:"
echo "  source: sensor.sahkon_kokonaisenergia"
echo "  ↓"
echo "  source: sensor.sahkon_kokonaisenergia_2"
echo ""
echo "─────────────────────────────────────────"
echo ""

# Step 2: Show current utility meter config
echo "2️⃣ Current utility meter configuration:"
echo ""
ssh "$HA_USER@$HA_HOST" "grep -A 3 'talon_kokonaiskulutus_tunti' /config/configuration.yaml 2>/dev/null" || echo "Not found in configuration.yaml, check packages/"

echo ""
echo "─────────────────────────────────────────"
echo ""

# Ask user which file to fix
echo "Which file contains the utility meters?"
echo "  1) /config/configuration.yaml (most common)"
echo "  2) /config/spot-price.yaml (package)"
echo "  3) Other file (you'll specify)"
echo ""
read -p "Enter choice (1-3): " CHOICE

case $CHOICE in
  1)
    FILE_TO_EDIT="/config/configuration.yaml"
    ;;
  2)
    FILE_TO_EDIT="/config/spot-price.yaml"
    ;;
  3)
    read -p "Enter full path to file: " FILE_TO_EDIT
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

echo ""
echo "─────────────────────────────────────────"
echo ""
echo "3️⃣ Backing up $FILE_TO_EDIT..."

ssh "$HA_USER@$HA_HOST" "cp $FILE_TO_EDIT ${FILE_TO_EDIT}.backup-$(date +%Y%m%d-%H%M%S)"

echo "✅ Backup created"
echo ""

# Step 4: Replace the sensor name
echo "4️⃣ Updating sensor name..."
echo ""

ssh "$HA_USER@$HA_HOST" "sed -i 's/source: sensor.sahkon_kokonaisenergia$/source: sensor.sahkon_kokonaisenergia_2/g' $FILE_TO_EDIT"

echo "✅ Updated!"
echo ""

# Step 5: Show the changes
echo "5️⃣ Verifying changes..."
echo ""
ssh "$HA_USER@$HA_HOST" "grep -A 3 'talon_kokonaiskulutus' $FILE_TO_EDIT | head -20"

echo ""
echo "─────────────────────────────────────────"
echo ""

# Step 6: Check configuration
echo "6️⃣ Checking configuration..."
if ssh "$HA_USER@$HA_HOST" "ha core check" 2>&1 | grep -q "valid"; then
    echo "✅ Configuration is valid!"
    echo ""
    
    read -p "Restart Home Assistant now? (y/n): " RESTART
    if [ "$RESTART" = "y" ]; then
        echo "🔄 Restarting..."
        ssh "$HA_USER@$HA_HOST" "ha core restart"
        echo ""
        echo "✅ Restart initiated!"
        echo ""
        echo "⏳ Wait 2-3 minutes, then check:"
        echo "   Developer Tools → States → talon_kokonaiskulutus_tunti_kwh"
        echo "   Wait 1 hour for it to start accumulating data"
    fi
else
    echo "❌ Configuration error!"
    echo ""
    echo "Restoring backup..."
    ssh "$HA_USER@$HA_HOST" "cp ${FILE_TO_EDIT}.backup-* $FILE_TO_EDIT"
    echo "✅ Backup restored"
fi

echo ""
echo "=========================================="
echo "🎉 Done!"
echo "=========================================="
