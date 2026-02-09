#!/bin/bash
# Quick Fix Script for sensor.talon_kokonaiskulutus_tunti_kwh
# This deploys the missing template sensor that utility_meters need

echo "🔧 Deploying Total Energy Sensor Fix..."
echo ""

# Configuration
HA_HOST="homeassistant"
HA_USER="root"
CONFIG_FILE="config/sensors/total_energy_sensor.yaml"

# Check if file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Error: $CONFIG_FILE not found!"
    exit 1
fi

echo "📤 Uploading sensor configuration to Home Assistant..."
scp "$CONFIG_FILE" ${HA_USER}@${HA_HOST}:/config/total_energy_sensor.yaml

if [ $? -ne 0 ]; then
    echo "❌ Error: Failed to upload file!"
    exit 1
fi

echo "✅ File uploaded successfully!"
echo ""
echo "📋 Next steps:"
echo ""
echo "1. SSH to Home Assistant:"
echo "   ssh root@homeassistant"
echo ""
echo "2. Add to configuration.yaml:"
echo "   nano /config/configuration.yaml"
echo ""
echo "   Add this line (or merge if template: already exists):"
echo "   template: !include total_energy_sensor.yaml"
echo ""
echo "3. Check configuration:"
echo "   ha core check"
echo ""
echo "4. Restart Home Assistant:"
echo "   ha core restart"
echo ""
echo "5. Wait 2-3 minutes, then verify:"
echo "   Developer Tools → States → search for 'sahkon_kokonaisenergia'"
echo "   Should show ~64,646 kWh (sum of all 3 phases)"
echo ""
echo "6. Wait 1-2 hours for utility_meter sensors to start collecting data:"
echo "   sensor.talon_kokonaiskulutus_tunti_kwh should start showing values > 0"
echo ""
echo "📊 Expected Results:"
echo "  - sensor.sahkon_kokonaisenergia: ~64,646 kWh (immediately)"
echo "  - sensor.talon_kokonaiskulutus_tunti_kwh: 1-5 kWh (after 1 hour)"
echo "  - sensor.talon_kokonaiskulutus_paiva_kwh: 40-80 kWh (after 24 hours)"
echo ""
echo "🎉 Fix complete! Your dashboards and AI prompts will work once data accumulates."
