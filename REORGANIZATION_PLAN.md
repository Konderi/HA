# 🏗️ Repository Reorganization Plan

**Date:** 2026-02-09  
**Purpose:** Clean up and organize the Home Assistant configuration repository

---

## 📂 New Repository Structure

```
HomeAssistant/
├── 📋 README.md                          # Main project documentation
├── 📋 CHANGELOG.md                       # Version history and changes
├── 📋 QUICK_START.md                     # Quick deployment guide
│
├── 📁 docs/                              # 📚 All Documentation
│   ├── 📁 deployment/                    # Deployment guides
│   │   ├── DEPLOYMENT_GUIDE.md
│   │   ├── PHASE1_DEPLOYMENT.md
│   │   ├── PHASE2_DEPLOYMENT.md
│   │   ├── QUICK_DEPLOY.md
│   │   └── SETTINGS_DEPLOYMENT_SUMMARY.md
│   │
│   ├── 📁 configuration/                 # Configuration guides
│   │   ├── ILP_PRICE_BASED_CLIMATE.md
│   │   ├── ELECTRICITY_PRICING_OVERVIEW.md
│   │   ├── SENSOR_REFERENCE.md
│   │   └── CONFIGURATION_YAML_UPDATE.md
│   │
│   ├── 📁 troubleshooting/               # Fix guides and validation
│   │   ├── NODERED_REPAIR_COMPLETE.md
│   │   ├── NODERED_VALIDATION_REPORT.md
│   │   ├── FLOWS_FIXED_SUMMARY.md
│   │   ├── VALIDATION_REPORT.md
│   │   └── MISSING_ENTITIES_REPORT.md
│   │
│   └── 📁 status/                        # Project status files
│       ├── PROJECT_STATUS.md
│       ├── STATUS.md
│       ├── SETTINGS_PAGE_COMPLETE.md
│       └── DASHBOARD_SENSOR_FIX.md
│
├── 📁 config/                            # 🏠 Home Assistant Configuration
│   ├── 📁 sensors/                       # Sensor configurations
│   │   ├── electricity_pricing.yaml
│   │   ├── electricity_pricing_constants.yaml
│   │   └── README.md
│   │
│   ├── 📁 input_helpers/                 # Input helpers
│   │   ├── input_booleans.yaml
│   │   ├── input_numbers.yaml
│   │   ├── input_datetimes.yaml
│   │   └── README.md
│   │
│   ├── 📁 automations/                   # HA automations
│   │   ├── power_management_automations.yaml
│   │   ├── notifications.yaml          # NEW!
│   │   └── README.md
│   │
│   └── 📁 notify/                        # NEW! Notification configs
│       ├── ios_notify.yaml
│       └── README.md
│
├── 📁 dashboards/                        # 📊 Lovelace Dashboards
│   ├── power-management-professional.yaml
│   ├── power-management-mobile.yaml
│   ├── settings-page.yaml
│   └── README.md
│
├── 📁 nodered/                           # 🔀 Node-RED Flows
│   ├── 📁 flows/                         # Flow files
│   │   ├── advanced-heating-automation.json
│   │   ├── basic-heating-schedule.json
│   │   ├── eco-mode.json
│   │   ├── peak-power-limiter.json
│   │   ├── phase-monitor-alerts.json
│   │   ├── price-based-optimizer.json  # Will update
│   │   ├── priority-load-balancer.json
│   │   ├── room-temperature-control.json
│   │   ├── temperature-radiator-control.json
│   │   └── notifications.json          # NEW!
│   │
│   └── 📁 docs/                          # Flow documentation
│       ├── FLOW_INTEGRATION_ANALYSIS.md
│       ├── NODERED_VS_HA.md
│       └── README.md
│
├── 📁 scripts/                           # 🐍 Python Scripts & Tools
│   ├── fix_nodered_entities.py
│   ├── fix_nodered_flows_all.py
│   ├── fix_nodered_state_type.py
│   ├── validate_nodered_flows.py
│   └── README.md
│
├── 📁 archive/                           # 📦 Old/Deprecated Files
│   ├── old_configs/
│   ├── current_config_phase2/
│   └── README.md
│
└── 📁 ai/                                # 🤖 NEW! AI Integration
    ├── conversation_config.yaml
    ├── prompts/
    │   ├── power_report.yaml
    │   ├── energy_analysis.yaml
    │   └── heating_optimization.yaml
    └── README.md
```

---

## 🔄 File Migration Map

### Documentation Files (Move to docs/)

**Deployment Guides → docs/deployment/**
- DEPLOYMENT_GUIDE.md
- PHASE1_DEPLOYMENT.md
- QUICK_DEPLOY.md
- SETTINGS_DEPLOYMENT_SUMMARY.md

**Configuration Guides → docs/configuration/**
- ILP_PRICE_BASED_CLIMATE.md
- ELECTRICITY_PRICING_OVERVIEW.md
- SENSOR_REFERENCE.md

**Troubleshooting → docs/troubleshooting/**
- NODERED_REPAIR_COMPLETE.md
- NODERED_VALIDATION_REPORT.md
- FLOWS_FIXED_SUMMARY.md
- VALIDATION_REPORT.md
- MISSING_ENTITIES_REPORT.md
- NODE_RED_FIX_GUIDE.md
- NODERED_QUICK_FIX.md
- DASHBOARD_SENSOR_FIX.md

**Status Reports → docs/status/**
- PROJECT_STATUS.md
- STATUS.md
- SETTINGS_PAGE_COMPLETE.md

### Configuration Files (Reorganize)

**Sensors → config/sensors/**
- electricity_pricing.yaml
- electricity_pricing_constants.yaml

**Input Helpers → config/input_helpers/**
- power-management/input_booleans.yaml
- power-management/input_numbers.yaml
- power-management/input_datetimes.yaml

**Node-RED Flows → nodered/flows/**
- power-management/flows/*.json

### Scripts (Already organized)
- Keep in root/scripts/

### Archives (Move old stuff)
- old_configs/ → archive/old_configs/
- current_config_phase2/ → archive/current_config_phase2/

---

## 🆕 New Files to Create

### 1. Notification Configuration
**File:** `config/automations/notifications.yaml`
- iPhone notification service configuration
- Power alerts, price alerts, heating status

### 2. iOS Notify Config
**File:** `config/notify/ios_notify.yaml`
- Mobile app notification setup

### 3. Node-RED Notification Flow
**File:** `nodered/flows/notifications.json`
- Centralized notification handling
- Power alerts, price changes, heating mode changes
- Integration with HA notify service

### 4. AI Integration
**File:** `ai/conversation_config.yaml`
- Home Assistant AI (conversation agent) configuration
- Power management assistant prompts

**File:** `ai/prompts/power_report.yaml`
- AI prompt for generating power consumption reports

**File:** `ai/prompts/energy_analysis.yaml`
- AI prompt for energy analysis and recommendations

**File:** `ai/prompts/heating_optimization.yaml`
- AI prompt for heating optimization suggestions

### 5. Updated Documentation
**File:** `README.md` (root)
- Complete project overview
- Quick links to all documentation
- Architecture diagram

**File:** `QUICK_START.md`
- Step-by-step deployment guide
- Prerequisites and requirements

**File:** `CHANGELOG.md`
- Version history
- Recent changes and updates

---

## 📝 Implementation Steps

### Step 1: Create New Directory Structure
```bash
mkdir -p docs/{deployment,configuration,troubleshooting,status}
mkdir -p config/{sensors,input_helpers,automations,notify}
mkdir -p nodered/{flows,docs}
mkdir -p scripts
mkdir -p archive
mkdir -p ai/prompts
```

### Step 2: Move Documentation Files
```bash
# Move deployment docs
mv *DEPLOYMENT*.md docs/deployment/
mv QUICK_DEPLOY.md docs/deployment/
mv SETTINGS_DEPLOYMENT_SUMMARY.md docs/deployment/

# Move configuration docs
mv ILP_PRICE_BASED_CLIMATE.md docs/configuration/
mv ELECTRICITY_PRICING_OVERVIEW.md docs/configuration/
mv SENSOR_REFERENCE.md docs/configuration/

# Move troubleshooting docs
mv NODERED_*.md docs/troubleshooting/
mv FLOWS_FIXED_SUMMARY.md docs/troubleshooting/
mv VALIDATION_REPORT.md docs/troubleshooting/
mv MISSING_ENTITIES_REPORT.md docs/troubleshooting/
mv NODE_RED_FIX_GUIDE.md docs/troubleshooting/
mv DASHBOARD_SENSOR_FIX.md docs/troubleshooting/

# Move status docs
mv PROJECT_STATUS.md docs/status/
mv STATUS.md docs/status/
mv SETTINGS_PAGE_COMPLETE.md docs/status/
```

### Step 3: Reorganize Config Files
```bash
# Move sensor configs
mv electricity_pricing*.yaml config/sensors/

# Move input helpers
mv power-management/input_*.yaml config/input_helpers/

# Move Node-RED flows
mv power-management/flows nodered/

# Move power management docs to nodered/docs
mv power-management/*NODERED*.md nodered/docs/
mv power-management/FLOW_*.md nodered/docs/
```

### Step 4: Archive Old Files
```bash
mv old_configs archive/
mv current_config_phase2 archive/
```

### Step 5: Create New Files
- iPhone notification configuration
- Node-RED notification flow
- AI integration files
- Updated README files

---

## ✅ Benefits of New Structure

### 🎯 Clarity
- Clear separation of concerns
- Easy to find specific documentation
- Logical grouping by purpose

### 📚 Documentation
- All docs in one place
- Organized by category
- Easy navigation

### 🔧 Configuration
- HA configs separated from Node-RED
- Input helpers clearly organized
- Sensor configs grouped together

### 🤖 Maintainability
- Easier to update
- Clear file purposes
- Better git organization

### 🚀 Deployment
- Clear deployment path
- Prerequisites documented
- Step-by-step guides

---

## 📋 Post-Reorganization Tasks

1. **Update all internal documentation links**
   - Fix relative paths in markdown files
   - Update README references

2. **Update Node-RED flow references**
   - If any flows reference file paths

3. **Create new README.md files**
   - One for each major directory
   - Explains contents and purpose

4. **Test configuration paths**
   - Verify HA can find new paths
   - Test include statements

5. **Update git ignore**
   - Exclude temporary files
   - Keep structure clean

---

This reorganization will make the repository much more professional and easier to maintain! 🎉
