#!/bin/bash
# =================================================================
# Fix Consumption Chart - Complete Deployment
# =================================================================
# This script fixes the "Kulutus vs. Hinta 7 päivää" chart
# that currently shows 64,937 kWh (cumulative) instead of 
# hourly consumption (2-6 kWh per hour)
#
# ROOT CAUSE: Utility meters pointing to unavailable sensor
# FIX: Update source to sensor.sahkon_kokonaisenergia_2
# =================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
HA_HOST="${HA_HOST:-homeassistant}"
HA_USER="${HA_USER:-root}"

echo -e "${BLUE}=================================================${NC}"
echo -e "${BLUE}  Fix Consumption vs Price Chart${NC}"
echo -e "${BLUE}=================================================${NC}"
echo ""

# =================================================================
# STEP 1: Copy Energy Sensor
# =================================================================
echo -e "${YELLOW}[1/4]${NC} Copying total energy sensor (with kWh conversion)..."
scp config/sensors/total_energy_sensor.yaml ${HA_USER}@${HA_HOST}:/config/sensors/
echo -e "${GREEN}✓ Energy sensor uploaded${NC}"
echo ""

# =================================================================
# STEP 2: Copy Utility Meters Configuration
# =================================================================
echo -e "${YELLOW}[2/4]${NC} Copying utility meters configuration..."
scp config/sensors/utility_meters.yaml ${HA_USER}@${HA_HOST}:/config/sensors/
echo -e "${GREEN}✓ Utility meters configuration uploaded${NC}"
echo ""

# =================================================================
# STEP 3: Update configuration.yaml
# =================================================================
echo -e "${YELLOW}[3/4]${NC} Checking configuration.yaml..."
ssh ${HA_USER}@${HA_HOST} << 'ENDSSH'

CONFIG_FILE="/config/configuration.yaml"

# Check if template include exists
if grep -q "template:.*!include.*total_energy_sensor.yaml" "$CONFIG_FILE"; then
    echo "✓ Template sensor already included"
else
    echo "Adding template sensor include..."
    cat >> "$CONFIG_FILE" << 'EOF'

# Total energy sensor (sum of 3 ShellyEM3 phases)
template: !include sensors/total_energy_sensor.yaml
EOF
    echo "✓ Added template sensor include"
fi

# Check if utility_meter include exists
if grep -q "utility_meter:.*!include.*utility_meters.yaml" "$CONFIG_FILE"; then
    echo "✓ Utility meters already included"
else
    echo "Adding utility meters include..."
    cat >> "$CONFIG_FILE" << 'EOF'

# Utility meters for consumption tracking
utility_meter: !include sensors/utility_meters.yaml
EOF
    echo "✓ Added utility meters include"
fi

# Search for old utility meter definitions (might be in packages or main config)
echo ""
echo "Searching for old utility meter definitions..."
if grep -rn "talon_kokonaiskulutus_tunti" /config/configuration.yaml /config/packages/*.yaml 2>/dev/null | grep -v "^Binary"; then
    echo ""
    echo "⚠️  WARNING: Found existing utility meter definitions!"
    echo "   These might conflict with the new configuration."
    echo "   Please review and remove old definitions if they exist."
fi

ENDSSH

echo -e "${GREEN}✓ Configuration updated${NC}"
echo ""

# =================================================================
# STEP 4: Validate and Restart
# =================================================================
echo -e "${YELLOW}[4/4]${NC} Validating configuration and restarting Home Assistant..."
ssh ${HA_USER}@${HA_HOST} << 'ENDSSH'

echo "Checking configuration..."
if ha core check; then
    echo "✓ Configuration valid"
    echo ""
    echo "Restarting Home Assistant..."
    ha core restart
    echo "✓ Restart initiated"
else
    echo "❌ Configuration check failed!"
    echo "   Please fix errors before restarting"
    exit 1
fi

ENDSSH

echo ""
echo -e "${BLUE}=================================================${NC}"
echo -e "${GREEN}✓ Deployment Complete!${NC}"
echo -e "${BLUE}=================================================${NC}"
echo ""
echo -e "${YELLOW}What to expect:${NC}"
echo ""
echo "1. Wait 2-3 minutes for Home Assistant to restart"
echo ""
echo "2. Check Developer Tools → States:"
echo "   - sensor.sahkon_kokonaisenergia_2 = ~64.6 kWh (cumulative total) ✓"
echo "   - sensor.talon_kokonaiskulutus_tunti_kwh = 0 kWh (will update in 1 hour)"
echo ""
echo "3. After 1 hour, hourly sensor should show: 2-6 kWh"
echo ""
echo "4. Chart will show proper hourly consumption instead of 64,937 kWh"
echo ""
echo -e "${YELLOW}Chart location:${NC}"
echo "   Magic Mirror dashboard → 'Kulutus vs. Hinta 7 päivää'"
echo "   Expected: Orange bars showing 2-6 kWh per hour"
echo "   Expected: Red line showing price variations"
echo ""
echo -e "${YELLOW}Troubleshooting:${NC}"
echo "   If chart still shows wrong data after 1 hour:"
echo "   1. Check sensor.talon_kokonaiskulutus_tunti_kwh > 0"
echo "   2. Refresh dashboard (Ctrl+F5)"
echo "   3. Check Home Assistant logs for errors"
echo ""
