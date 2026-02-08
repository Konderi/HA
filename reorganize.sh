#!/bin/bash

echo "🏗️  Starting Repository Reorganization..."
echo ""

# Create new directory structure
echo "📁 Creating new directory structure..."
mkdir -p docs/{deployment,configuration,troubleshooting,status}
mkdir -p config/{sensors,input_helpers,automations,notify}
mkdir -p nodered/{flows,docs}
mkdir -p scripts
mkdir -p archive
mkdir -p ai/prompts

echo "✅ Directory structure created"
echo ""

# Move documentation files
echo "📚 Moving documentation files..."

# Deployment docs
mv DEPLOYMENT_GUIDE.md PHASE1_DEPLOYMENT.md QUICK_DEPLOY.md SETTINGS_DEPLOYMENT_SUMMARY.md docs/deployment/ 2>/dev/null

# Configuration docs  
mv ILP_PRICE_BASED_CLIMATE.md ELECTRICITY_PRICING_OVERVIEW.md SENSOR_REFERENCE.md docs/configuration/ 2>/dev/null

# Troubleshooting docs
mv NODERED_*.md FLOWS_FIXED_SUMMARY.md VALIDATION_REPORT.md MISSING_ENTITIES_REPORT.md NODE_RED_FIX_GUIDE.md DASHBOARD_SENSOR_FIX.md docs/troubleshooting/ 2>/dev/null

# Status docs
mv PROJECT_STATUS.md STATUS.md SETTINGS_PAGE_COMPLETE.md docs/status/ 2>/dev/null

echo "✅ Documentation organized"
echo ""

# Move configuration files
echo "⚙️  Moving configuration files..."

# Sensors
mv electricity_pricing*.yaml config/sensors/ 2>/dev/null

# Input helpers
cp power-management/input_*.yaml config/input_helpers/ 2>/dev/null

# Node-RED flows
cp -r power-management/flows nodered/ 2>/dev/null

# Node-RED docs
cp power-management/*NODERED*.md power-management/FLOW_*.md nodered/docs/ 2>/dev/null

echo "✅ Configuration files organized"
echo ""

# Move scripts
echo "🐍 Moving Python scripts..."
mv fix_*.py validate_*.py scripts/ 2>/dev/null

echo "✅ Scripts organized"
echo ""

# Archive old files
echo "�� Archiving old configurations..."
mv old_configs archive/ 2>/dev/null
mv current_config_phase2 archive/ 2>/dev/null

echo "✅ Old files archived"
echo ""

echo "🎉 Repository reorganization complete!"
echo ""
echo "Next steps:"
echo "1. Review the new structure"
echo "2. Update configuration.yaml paths if needed"
echo "3. Create README files for each directory"
echo "4. Test the new setup"

