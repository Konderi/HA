#!/bin/bash
# Diagnostic script for sensor.talon_kokonaiskulutus_tunti_kwh issue
# Run this to gather troubleshooting information

echo "=========================================="
echo "🔍 Sensor Diagnostic Report"
echo "=========================================="
echo ""

HA_HOST="${HA_HOST:-homeassistant}"
HA_USER="${HA_USER:-root}"

echo "Connecting to: $HA_USER@$HA_HOST"
echo ""

# Check 1: Does the sensor file exist on HA?
echo "1️⃣ Checking if sensor file exists on Home Assistant..."
if ssh "$HA_USER@$HA_HOST" "test -f /config/sensors/total_energy_sensor.yaml" 2>/dev/null; then
    echo "✅ File exists: /config/sensors/total_energy_sensor.yaml"
    echo ""
    echo "File contents:"
    ssh "$HA_USER@$HA_HOST" "head -30 /config/sensors/total_energy_sensor.yaml"
else
    echo "❌ File NOT found: /config/sensors/total_energy_sensor.yaml"
    echo "   ACTION: Run deployment script or copy file manually"
fi
echo ""
echo "─────────────────────────────────────────"
echo ""

# Check 2: Is it included in configuration.yaml?
echo "2️⃣ Checking configuration.yaml for template includes..."
echo ""
ssh "$HA_USER@$HA_HOST" "grep -n 'template:' /config/configuration.yaml" 2>/dev/null || echo "❌ No 'template:' line found in configuration.yaml"
echo ""
echo "─────────────────────────────────────────"
echo ""

# Check 3: Check for configuration errors
echo "3️⃣ Checking for configuration errors..."
ssh "$HA_USER@$HA_HOST" "ha core check" 2>&1
echo ""
echo "─────────────────────────────────────────"
echo ""

# Check 4: Check ShellyEM3 source sensors
echo "4️⃣ Checking ShellyEM3 source sensors..."
echo ""
echo "Run this in Home Assistant Developer Tools → Template:"
echo ""
cat <<'EOF'
Channel A: {{ states('sensor.shellyem3_channel_a_energy') }}
Channel B: {{ states('sensor.shellyem3_channel_b_energy') }}
Channel C: {{ states('sensor.shellyem3_channel_c_energy') }}
Total calculated: {{ (states('sensor.shellyem3_channel_a_energy')|float(0) + states('sensor.shellyem3_channel_b_energy')|float(0) + states('sensor.shellyem3_channel_c_energy')|float(0)) | round(2) }}
EOF
echo ""
echo "─────────────────────────────────────────"
echo ""

# Check 5: Look for errors in logs
echo "5️⃣ Checking recent logs for sensor errors..."
ssh "$HA_USER@$HA_HOST" "ha core logs | grep -i 'sahkon_kokonaisenergia\|total_energy_sensor\|template' | tail -20" 2>/dev/null || echo "No recent errors found"
echo ""
echo "─────────────────────────────────────────"
echo ""

# Check 6: Check if template sensors are loaded
echo "6️⃣ Checking Home Assistant states..."
echo ""
echo "To check sensor states, go to:"
echo "Home Assistant → Developer Tools → States"
echo ""
echo "Search for:"
echo "  - sahkon_kokonaisenergia (should exist)"
echo "  - talon_kokonaiskulutus_tunti_kwh (should exist)"
echo ""
echo "─────────────────────────────────────────"
echo ""

# Check 7: Check for duplicate template sections
echo "7️⃣ Checking for duplicate template sections..."
TEMPLATE_COUNT=$(ssh "$HA_USER@$HA_HOST" "grep -c '^template:' /config/configuration.yaml" 2>/dev/null || echo "0")
echo "Number of 'template:' lines in configuration.yaml: $TEMPLATE_COUNT"
if [ "$TEMPLATE_COUNT" -gt 1 ]; then
    echo "⚠️  WARNING: Multiple template sections found!"
    echo "   You need to merge them into one section."
    echo ""
    echo "   All template: lines:"
    ssh "$HA_USER@$HA_HOST" "grep -n '^template:' /config/configuration.yaml"
else
    echo "✅ Only one template section (good)"
fi
echo ""
echo "─────────────────────────────────────────"
echo ""

# Summary
echo "=========================================="
echo "📋 SUMMARY & NEXT STEPS"
echo "=========================================="
echo ""
echo "Common Issues & Solutions:"
echo ""
echo "❌ File doesn't exist on HA:"
echo "   → Run: scp config/sensors/total_energy_sensor.yaml root@homeassistant:/config/sensors/"
echo ""
echo "❌ Not included in configuration.yaml:"
echo "   → Add line: template: !include sensors/total_energy_sensor.yaml"
echo ""
echo "❌ Configuration errors:"
echo "   → Check YAML indentation (use 2 spaces, not tabs)"
echo "   → Look for duplicate template: sections"
echo ""
echo "❌ ShellyEM3 sensors unavailable:"
echo "   → Check ShellyEM3 device is online"
echo "   → Restart ShellyEM3 integration"
echo ""
echo "❌ Multiple template sections:"
echo "   → Merge into one or use: template: !include_dir_merge_list sensors/"
echo ""
echo "✅ Everything looks good but still showing 0:"
echo "   → Wait 1-2 hours for utility_meter to collect data"
echo "   → Utility meters need a full cycle to accumulate"
echo ""
echo "=========================================="
echo "Need to SSH manually? Run:"
echo "  ssh $HA_USER@$HA_HOST"
echo "=========================================="
