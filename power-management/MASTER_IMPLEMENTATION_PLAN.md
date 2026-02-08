# 🚀 Master Implementation Plan - Complete Deployment Guide

Your complete roadmap to deploy the entire power management system from scratch to full production.

**Total Estimated Time**: 4-5 hours (can be split across multiple days)

---

## 📋 Quick Status Dashboard

Track your progress here - update as you complete each phase:

```
Phase 1: Critical Fixes          [ ] Not Started  [ ] In Progress  [ ] ✅ Complete
Phase 2: Core System             [ ] Not Started  [ ] In Progress  [ ] ✅ Complete
Phase 3: Professional Charts     [ ] Not Started  [ ] In Progress  [ ] ✅ Complete
Phase 4: AI Enhancement          [ ] Not Started  [ ] In Progress  [ ] ✅ Complete
Phase 5: Testing & Validation    [ ] Not Started  [ ] In Progress  [ ] ✅ Complete
```

**Last Updated**: _________________  
**Current Phase**: _________________  
**Blockers/Issues**: _________________

---

## 🎯 Implementation Phases

---

# PHASE 1: Critical Fixes (⚠️ URGENT - 30 minutes)

**Priority**: CRITICAL - Must complete before HA 2026.6 (April 2026)  
**Status**: ⬜ Not Started

### Why This Matters
Your system has 46 deprecated template sensors that will STOP WORKING in HA 2026.6. This must be fixed first.

### Tasks

#### 1.1 - Backup Current Configuration (5 min)
**Status**: ⬜ Not Started

```bash
# SSH into Home Assistant or use File Editor
cd /config
cp configuration.yaml configuration.yaml.backup
cp sensors.yaml sensors.yaml.backup
```

**✅ Verification:**
- [ ] `configuration.yaml.backup` exists
- [ ] `sensors.yaml.backup` exists

---

#### 1.2 - Create New Pricing Configuration Files (5 min)
**Status**: ⬜ Not Started  
**Guide**: `QUICK_MIGRATION.md` (Section: Step 1)

**Action**: Create these two new files in `/config/`:

**File 1**: `electricity_pricing_constants.yaml`
```yaml
# Centralized electricity pricing constants
# Created: {{ now().strftime('%Y-%m-%d') }}

homeassistant:
  customize:
    package.node_anchors:
      # Electricity pricing components (c/kWh)
      electricity_energy_price: &electricity_energy_price
        day: 0.44    # Day tariff (07:00-22:00)
        night: 0.37  # Night tariff (22:00-07:00)
      
      electricity_transfer_price: &electricity_transfer_price
        day: 4.92    # Day transfer tariff
        night: 3.01  # Night transfer tariff
      
      electricity_tax: &electricity_tax 2.79372  # Electricity tax (c/kWh)
      electricity_vat: &electricity_vat 1.255    # VAT multiplier (25.5%)
      electricity_margin: &electricity_margin 0.25  # Supplier margin
```

**File 2**: `electricity_pricing.yaml`
```yaml
# Modern electricity price sensors using centralized constants
# Created: {{ now().strftime('%Y-%m-%d') }}

template:
  - sensor:
      # Total electricity price (all components combined)
      - name: "Electricity Total Price (cents)"
        unique_id: electricity_total_price_cents
        unit_of_measurement: "c/kWh"
        device_class: monetary
        state: >
          {% set nordpool = states('sensor.nordpool_kwh_fi_eur_4_10_0') | float(0) %}
          {% set hour = now().hour %}
          {% set is_day_tariff = hour >= 7 and hour < 22 %}
          
          {# Base components #}
          {% set energy_price = 0.44 if is_day_tariff else 0.37 %}
          {% set transfer_price = 4.92 if is_day_tariff else 3.01 %}
          {% set tax = 2.79372 %}
          {% set margin = 0.25 %}
          
          {# Calculate total price in cents/kWh #}
          {% set total_before_vat = (nordpool * 100) + energy_price + transfer_price + tax + margin %}
          {% set total_with_vat = total_before_vat * 1.255 %}
          
          {{ total_with_vat | round(2) }}
        attributes:
          nordpool_price: "{{ states('sensor.nordpool_kwh_fi_eur_4_10_0') | float(0) * 100 }}"
          energy_price: "{{ 0.44 if now().hour >= 7 and now().hour < 22 else 0.37 }}"
          transfer_price: "{{ 4.92 if now().hour >= 7 and now().hour < 22 else 3.01 }}"
          tax: 2.79372
          margin: 0.25
          vat_multiplier: 1.255
          tariff_type: "{{ 'day' if now().hour >= 7 and now().hour < 22 else 'night' }}"
```

**✅ Verification:**
- [ ] Both files created in `/config/`
- [ ] No YAML syntax errors (check with YAML validator)

---

#### 1.3 - Update configuration.yaml (5 min)
**Status**: ⬜ Not Started

**Action**: Add these lines to your `configuration.yaml`:

```yaml
homeassistant:
  packages:
    electricity_pricing_constants: !include electricity_pricing_constants.yaml
    electricity_pricing: !include electricity_pricing.yaml
```

**Location**: Add under the existing `homeassistant:` section (you already have packages defined)

**✅ Verification:**
- [ ] Lines added to `configuration.yaml`
- [ ] Indentation is correct (2 spaces)

---

#### 1.4 - Replace Legacy Sensors File (10 min)
**Status**: ⬜ Not Started  
**Guide**: `QUICK_MIGRATION.md` (Section: Step 2)

**Action**: Replace your current `sensors.yaml` with `legacy_sensors_migrated.yaml`

```bash
# Option 1: Rename old file and copy new one
mv /config/sensors.yaml /config/sensors.yaml.old
cp /config/legacy_sensors_migrated.yaml /config/sensors.yaml

# Option 2: Copy content manually
# Open legacy_sensors_migrated.yaml and copy all content into sensors.yaml
```

**✅ Verification:**
- [ ] Old `sensors.yaml` backed up as `sensors.yaml.old`
- [ ] New sensors use `template:` instead of `platform: template`
- [ ] File contains ~46 migrated sensors

---

#### 1.5 - Check Configuration & Restart (5 min)
**Status**: ⬜ Not Started

**Action**:
1. Developer Tools → YAML → Check Configuration
2. Wait for validation (30 seconds)
3. If OK: Settings → System → Restart Home Assistant
4. Wait 2-3 minutes for restart

**✅ Verification:**
- [ ] Configuration check passed ✅
- [ ] Home Assistant restarted successfully
- [ ] No errors in logs

---

#### 1.6 - Verify New Sensors (5 min)
**Status**: ⬜ Not Started

**Action**: Developer Tools → States

**Check these sensors exist and have values:**
- [ ] `sensor.electricity_total_price_cents` (should show ~8-15)
- [ ] `sensor.sahko_kokonaishinta_c` (deprecated but working with warning)
- [ ] `sensor.veden_hinta` (should have value)

**Check logs for warnings**:
Settings → System → Logs → Search for "deprecated"

**Expected**: No new deprecation warnings! 🎉

**✅ Phase 1 Complete When:**
- [ ] All 46 sensors migrated to modern syntax
- [ ] Zero deprecation warnings in logs
- [ ] New `sensor.electricity_total_price_cents` working
- [ ] System stable for 24 hours

**🎉 Achievement Unlocked**: System is now future-proof for HA 2027+ !

---

# PHASE 2: Core Power Management System (90 minutes)

**Priority**: HIGH  
**Status**: ⬜ Not Started  
**Dependencies**: Phase 1 must be complete

### Why This Matters
This deploys the 4 core Node-RED flows that protect your fuses, prevent tehomaksu fees, and optimize costs.

---

#### 2.1 - Verify Prerequisites (10 min)
**Status**: ⬜ Not Started  
**Guide**: `IMPLEMENTATION_CHECKLIST.md`

**Check these exist in your system:**

**Sensors (all should exist):**
- [ ] `sensor.shellyem3_channel_a_power`
- [ ] `sensor.shellyem3_channel_b_power`
- [ ] `sensor.shellyem3_channel_c_power`
- [ ] `sensor.shellyem3_channel_a_voltage`
- [ ] `sensor.nordpool_kwh_fi_eur_4_10_0`
- [ ] `sensor.electricity_total_price_cents` (from Phase 1)

**Devices:**
- [ ] `climate.mitsu_ilp` (heat pump)
- [ ] `switch.patterit` (radiators)
- [ ] `switch.shellypro4pm_ec62609fd3dc_switch_2` (water boiler)
- [ ] `sensor.saunan_tilatieto` (sauna status)

**Integrations:**
- [ ] Node-RED addon installed
- [ ] Telegram bot configured (`notify.telegram`)

**If any missing**: See `IMPLEMENTATION_CHECKLIST.md` Section 1 for setup instructions

---

#### 2.2 - Create Helper Entities (15 min)
**Status**: ⬜ Not Started  
**Guide**: `IMPLEMENTATION_CHECKLIST.md` (Section 2)

**Action**: Add these to `configuration.yaml`:

```yaml
# Power Management Helper Entities
input_number:
  # Heat pump temperatures
  tehostuslampo:
    name: "Heat Pump Boost Temperature"
    min: 18
    max: 26
    step: 0.5
    unit_of_measurement: "°C"
    icon: mdi:thermometer-high
  
  normaalilampo_presence:
    name: "Heat Pump Normal Temperature"
    min: 16
    max: 24
    step: 0.5
    unit_of_measurement: "°C"
    icon: mdi:thermometer
  
  ekolampo:
    name: "Heat Pump Eco Temperature"
    min: 14
    max: 22
    step: 0.5
    unit_of_measurement: "°C"
    icon: mdi:thermometer-low
  
  # Price thresholds
  shf_rank_slider:
    name: "Water Boiler Price Rank Threshold"
    min: 1
    max: 24
    step: 1
    icon: mdi:chart-line
  
  # Peak power settings
  peak_power_threshold:
    name: "Peak Power Limit"
    min: 6
    max: 12
    step: 0.5
    unit_of_measurement: "kW"
    icon: mdi:flash-alert
  
  peak_power_warning_threshold:
    name: "Peak Power Warning Level"
    min: 5
    max: 11
    step: 0.5
    unit_of_measurement: "kW"
    icon: mdi:flash

input_boolean:
  # Master control
  power_management_active:
    name: "Power Management System"
    icon: mdi:power
  
  # Individual system controls
  load_balancer_enabled:
    name: "Load Balancer"
    icon: mdi:scale-balance
  
  peak_limiter_enabled:
    name: "Peak Power Limiter"
    icon: mdi:flash-alert
  
  price_optimizer_enabled:
    name: "Price Optimizer"
    icon: mdi:cash
  
  phase_monitor_enabled:
    name: "Phase Monitor"
    icon: mdi:sine-wave

input_datetime:
  device_start_time:
    name: "Heating Start Time"
    has_time: true
    has_date: false
```

**After adding**: 
1. Check Configuration
2. Restart Home Assistant
3. Verify entities exist in Developer Tools → States

**✅ Verification:**
- [ ] All `input_number.*` entities created (6 items)
- [ ] All `input_boolean.*` entities created (5 items)
- [ ] All `input_datetime.*` entities created (1 item)
- [ ] Can adjust sliders in Developer Tools → States

---

#### 2.3 - Import Node-RED Flows (45 min)
**Status**: ⬜ Not Started  
**Guide**: `IMPLEMENTATION_CHECKLIST.md` (Section 3)

**Import flows in this specific order:**

**Flow 1: Priority Load Balancer** (15 min)
- [ ] Open Node-RED: `http://homeassistant.local:1880`
- [ ] Menu (☰) → Import → Clipboard
- [ ] Paste content from `flows/priority-load-balancer.json`
- [ ] Click "Import"
- [ ] Click "Deploy" (top right)
- [ ] Check for errors in debug panel

**Flow 2: Peak Power Limiter** (15 min)
- [ ] Import `flows/peak-power-limiter.json`
- [ ] Deploy
- [ ] Verify no errors

**Flow 3: Price-Based Optimizer** (10 min)
- [ ] Import `flows/price-based-optimizer.json`
- [ ] Deploy
- [ ] Verify no errors

**Flow 4: Phase Monitor & Alerts** (5 min)
- [ ] Import `flows/phase-monitor-alerts.json`
- [ ] Deploy
- [ ] Verify no errors

**✅ Verification After Each Flow:**
- [ ] No red triangles on nodes (indicates missing entities)
- [ ] Debug panel shows flow activity
- [ ] Green "deployed" notification appears

---

#### 2.4 - Configure Initial Values (10 min)
**Status**: ⬜ Not Started

**Action**: Set these values in Developer Tools → States:

**Click each entity → Set value:**

```yaml
input_number.tehostuslampo: 23
input_number.normaalilampo_presence: 21
input_number.ekolampo: 19
input_number.shf_rank_slider: 8
input_number.peak_power_threshold: 8.0
input_number.peak_power_warning_threshold: 7.0

input_boolean.power_management_active: on
input_boolean.load_balancer_enabled: on
input_boolean.peak_limiter_enabled: on
input_boolean.price_optimizer_enabled: on
input_boolean.phase_monitor_enabled: on
```

**✅ Verification:**
- [ ] All values set
- [ ] System toggles are ON
- [ ] No errors in Node-RED debug

---

#### 2.5 - First Live Test (10 min)
**Status**: ⬜ Not Started

**Test 1: Load Balancer**
- [ ] Turn ON sauna
- [ ] Watch Node-RED debug panel
- [ ] Should see "Sauna detected, checking other devices"
- [ ] If Tesla charging, should see amperage reduction

**Test 2: Peak Power Limiter**
- [ ] Monitor `sensor.rolling_average_60min` in States
- [ ] Should update every minute
- [ ] Enable multiple high-power devices
- [ ] Watch for interventions if approaching 8 kW

**Test 3: Price Optimizer**
- [ ] Check current electricity price rank
- [ ] If within boost hours → heat pump should be at boost temp
- [ ] If expensive hours → should be at eco temp

**Test 4: Phase Monitor**
- [ ] Should receive daily summary via Telegram (next day)
- [ ] Check logs for any voltage warnings

**✅ Phase 2 Complete When:**
- [ ] All 4 flows deployed and running
- [ ] No errors in Node-RED logs
- [ ] Load balancer responds to sauna
- [ ] Peak limiter tracks 60-min average
- [ ] Price optimizer adjusts heat pump
- [ ] Telegram notifications working

**🎉 Achievement Unlocked**: Core automation system is LIVE!

---

# PHASE 3: Professional Charts & Monitoring (90 minutes)

**Priority**: MEDIUM  
**Status**: ⬜ Not Started  
**Dependencies**: Phase 1 complete  
**Guide**: `PROFESSIONAL_APEXCHARTS.md`

### Why This Matters
Adds professional power factor monitoring, 6 advanced charts, and equipment health tracking.

---

#### 3.1 - Install ApexCharts Card (5 min)
**Status**: ⬜ Not Started

**Action**:
1. HACS → Frontend
2. Search "ApexCharts Card"
3. Install
4. Restart Home Assistant

**✅ Verification:**
- [ ] ApexCharts card installed in HACS
- [ ] Restart completed

---

#### 3.2 - Create Power Quality Sensors (15 min)
**Status**: ⬜ Not Started  
**Guide**: `PROFESSIONAL_APEXCHARTS.md` (Section: Required Template Sensors)

**Action**: Create file `/config/power_quality_sensors.yaml`:

```yaml
# Power Factor and Quality Monitoring
# Created: {{ now().strftime('%Y-%m-%d') }}

template:
  - sensor:
      # Overall weighted power factor
      - name: "Overall Power Factor"
        unique_id: overall_power_factor
        unit_of_measurement: ""
        state_class: measurement
        state: >
          {% set pf_a = states('sensor.shellyem3_channel_a_power_factor') | float(0.95) %}
          {% set pf_b = states('sensor.shellyem3_channel_b_power_factor') | float(0.95) %}
          {% set pf_c = states('sensor.shellyem3_channel_c_power_factor') | float(0.95) %}
          {% set power_a = states('sensor.shellyem3_channel_a_power') | float(0) %}
          {% set power_b = states('sensor.shellyem3_channel_b_power') | float(0) %}
          {% set power_c = states('sensor.shellyem3_channel_c_power') | float(0) %}
          {% set total_power = power_a + power_b + power_c %}
          
          {% if total_power > 100 %}
            {% set weighted_pf = ((pf_a * power_a) + (pf_b * power_b) + (pf_c * power_c)) / total_power %}
            {{ weighted_pf | round(3) }}
          {% else %}
            {{ ((pf_a + pf_b + pf_c) / 3) | round(3) }}
          {% endif %}
      
      # Heat pump power factor
      - name: "Heat Pump Power Factor"
        unique_id: mitsu_ilp_power_factor
        unit_of_measurement: ""
        state_class: measurement
        state: >
          {% if is_state('climate.mitsu_ilp', 'heat') or is_state('climate.mitsu_ilp', 'cool') %}
            {{ states('sensor.shellyem3_channel_a_power_factor') | float(0.90) }}
          {% else %}
            0.99
          {% endif %}
      
      # Radiators power factor (resistive = ~0.98)
      - name: "Radiators Power Factor"
        unique_id: patterit_power_factor
        unit_of_measurement: ""
        state_class: measurement
        state: >
          {% if is_state('switch.patterit', 'on') %}
            0.98
          {% else %}
            1.0
          {% endif %}
      
      # Water boiler power factor (resistive = ~0.99)
      - name: "Water Boiler Power Factor"
        unique_id: water_boiler_power_factor
        unit_of_measurement: ""
        state_class: measurement
        state: >
          {% if is_state('switch.shellypro4pm_ec62609fd3dc_switch_2', 'on') %}
            0.99
          {% else %}
            1.0
          {% endif %}
      
      # Sauna power factor (resistive = ~0.99)
      - name: "Sauna Power Factor"
        unique_id: sauna_power_factor
        unit_of_measurement: ""
        state_class: measurement
        state: >
          {% if is_state('sensor.saunan_tilatieto', 'Päällä') %}
            0.99
          {% else %}
            1.0
          {% endif %}
      
      # Total reactive power (wasted energy)
      - name: "Total Reactive Power"
        unique_id: total_reactive_power
        unit_of_measurement: "VAR"
        state_class: measurement
        device_class: power
        state: >
          {% set total_power = states('sensor.sahko_kokonaiskulutus_teho') | float(0) %}
          {% set pf = states('sensor.overall_power_factor') | float(0.95) %}
          
          {% if pf < 1.0 and pf > 0 %}
            {% set reactive = total_power * ((1 - pf**2)**0.5) / pf %}
            {{ reactive | round(0) }}
          {% else %}
            0
          {% endif %}
      
      # Power quality score (0-100)
      - name: "Power Quality Score"
        unique_id: power_quality_score
        unit_of_measurement: ""
        state_class: measurement
        state: >
          {% set pf = states('sensor.overall_power_factor') | float(0.95) %}
          {% set v_a = states('sensor.shellyem3_channel_a_voltage') | float(230) %}
          {% set v_b = states('sensor.shellyem3_channel_b_voltage') | float(230) %}
          {% set v_c = states('sensor.shellyem3_channel_c_voltage') | float(230) %}
          {% set v_avg = (v_a + v_b + v_c) / 3 %}
          
          {# Power factor score (0-50 points) #}
          {% set pf_score = pf * 50 %}
          
          {# Voltage stability score (0-50 points) #}
          {% set v_deviation = ((v_avg - 230) / 230 * 100) | abs %}
          {% set v_score = 50 - (v_deviation * 5) %}
          {% set v_score = [v_score, 0] | max %}
          
          {{ (pf_score + v_score) | round(0) }}
```

**Add to configuration.yaml**:
```yaml
template: !include power_quality_sensors.yaml
```

**Restart Home Assistant**

**✅ Verification:**
- [ ] File created
- [ ] Added to configuration.yaml
- [ ] Configuration check passed
- [ ] Restart completed
- [ ] All 7 new sensors appear in States:
  - [ ] `sensor.overall_power_factor`
  - [ ] `sensor.mitsu_ilp_power_factor`
  - [ ] `sensor.patterit_power_factor`
  - [ ] `sensor.water_boiler_power_factor`
  - [ ] `sensor.sauna_power_factor`
  - [ ] `sensor.total_reactive_power`
  - [ ] `sensor.power_quality_score`

---

#### 3.3 - Add Chart 1: Main Energy Dashboard (20 min)
**Status**: ⬜ Not Started  
**Guide**: `PROFESSIONAL_APEXCHARTS.md` (Chart 1)

**Action**: Add to your dashboard:

Copy Chart 1 YAML from `PROFESSIONAL_APEXCHARTS.md` lines 150-280

**Test**: Open dashboard, verify chart displays with:
- [ ] Electricity price (orange line)
- [ ] Total power consumption (blue area)
- [ ] Power factor overlay (green line)

---

#### 3.4 - Add Chart 2: 3-Phase Power Factor (15 min)
**Status**: ⬜ Not Started

Copy Chart 2 YAML from `PROFESSIONAL_APEXCHARTS.md`

**Test**: Verify shows 3 phases with quality zones (red/yellow/green)

---

#### 3.5 - Add Chart 3: Device Power Factor Comparison (10 min)
**Status**: ⬜ Not Started

Copy Chart 3 YAML (horizontal bar chart)

**Test**: Shows efficiency of each device

---

#### 3.6 - Add Chart 4: Real-Time Radial Gauges (10 min)
**Status**: ⬜ Not Started

Copy Chart 4 YAML (3-phase radial gauges)

**Test**: Updates every 5 seconds with live load

---

#### 3.7 - Add Chart 5: Weekly Consumption Heatmap (10 min)
**Status**: ⬜ Not Started

Copy Chart 5 YAML (pattern recognition)

**Test**: Shows hourly patterns across week

---

#### 3.8 - Add Chart 6: Cost-Efficiency Scatter Plot (5 min)
**Status**: ⬜ Not Started

Copy Chart 6 YAML

**Test**: Shows price vs power factor correlation

---

**✅ Phase 3 Complete When:**
- [ ] All 7 power quality sensors working
- [ ] All 6 charts added to dashboard
- [ ] Charts display data correctly
- [ ] Power factor values make sense (0.85-1.0)
- [ ] Real-time updates working

**🎉 Achievement Unlocked**: Professional power monitoring with equipment health tracking!

---

# PHASE 4: AI-Enhanced Reporting (60 minutes)

**Priority**: MEDIUM  
**Status**: ⬜ Not Started  
**Dependencies**: Phase 1 & 2 complete  
**Guide**: `AI_POWER_MANAGEMENT.md`

### Why This Matters
Adds intelligent natural language reports, anomaly detection, and voice notifications.

---

#### 4.1 - Verify AI Integration (10 min)
**Status**: ⬜ Not Started

**Check OpenAI is configured:**
- [ ] Settings → Voice Assistants
- [ ] Verify `conversation.openai_conversation_4` exists
- [ ] Test with "Test" button

**If not configured:**
1. Settings → Voice Assistants → Add Assistant
2. Choose OpenAI
3. Enter API key
4. Save and note entity ID

**✅ Verification:**
- [ ] AI assistant responding to test queries
- [ ] Entity ID noted: `_______________________`

---

#### 4.2 - Create AI Helper Entities (10 min)
**Status**: ⬜ Not Started

**Add to configuration.yaml:**

```yaml
input_text:
  ai_daily_plan:
    name: "AI Daily Optimization Plan"
    max: 1000
    
  ai_weekly_summary:
    name: "AI Weekly Summary"
    max: 2000
    
  ai_last_anomaly:
    name: "AI Last Anomaly Analysis"
    max: 500

counter:
  ai_reports_generated:
    name: "AI Reports Generated"
    icon: mdi:robot
    
input_boolean:
  ai_reports_enabled:
    name: "AI Reports Enabled"
    icon: mdi:robot
```

Restart Home Assistant

**✅ Verification:**
- [ ] All entities created
- [ ] `input_boolean.ai_reports_enabled` is ON

---

#### 4.3 - Add Daily Energy Report Automation (15 min)
**Status**: ⬜ Not Started  
**Guide**: `AI_POWER_MANAGEMENT.md` (Daily Energy Reports)

**Action**: Add to `automations.yaml`:

Copy the "Morning Energy Summary" automation from `AI_POWER_MANAGEMENT.md`

**Update**:
- Replace `conversation.openai_conversation_4` with your AI entity ID
- Verify all sensor entity IDs match your system

**Save and reload automations**: Developer Tools → YAML → Automations

**✅ Verification:**
- [ ] Automation appears in Settings → Automations
- [ ] No errors in logs
- [ ] Test trigger manually: Developer Tools → Services → `automation.trigger`

---

#### 4.4 - Add Weekly Analysis Automation (10 min)
**Status**: ⬜ Not Started

Copy "Sunday Evening Weekly Review" automation

**✅ Verification:**
- [ ] Automation created
- [ ] Will run Sundays at 20:00

---

#### 4.5 - Create AI Query Script (10 min)
**Status**: ⬜ Not Started

**Add to `scripts.yaml`**:

Copy "On-Demand Power Status Query" script from guide

**✅ Verification:**
- [ ] Script appears in Developer Tools → Services
- [ ] Test: Call service with question "What's my power usage?"
- [ ] Receive Telegram response

---

#### 4.6 - Add Dashboard AI Widget (5 min)
**Status**: ⬜ Not Started

**Add to dashboard:**

```yaml
type: vertical-stack
cards:
  - type: markdown
    title: "🤖 AI Daily Plan"
    content: "{{ states('input_text.ai_daily_plan') }}"
    
  - type: button
    name: "Ask AI About Power"
    icon: mdi:robot
    tap_action:
      action: call-service
      service: script.ai_power_status_query
      data:
        question: "What's happening with my electricity right now?"
```

**✅ Verification:**
- [ ] Card shows on dashboard
- [ ] Button works when clicked
- [ ] AI responds via Telegram

---

**✅ Phase 4 Complete When:**
- [ ] AI integration verified
- [ ] Daily report automation active
- [ ] Weekly analysis scheduled
- [ ] Query script working
- [ ] Dashboard widget functional
- [ ] First AI report received successfully

**🎉 Achievement Unlocked**: Your system can now explain itself!

---

# PHASE 5: Testing & Validation (60 minutes)

**Priority**: CRITICAL  
**Status**: ⬜ Not Started  
**Dependencies**: Phases 1-4 complete

### Why This Matters
Ensures everything works together correctly before relying on the system.

---

#### 5.1 - System Health Check (15 min)
**Status**: ⬜ Not Started

**Check Logs:**
- [ ] Settings → System → Logs
- [ ] Filter: Errors only
- [ ] Should see: **ZERO errors** related to power management

**Check Entities:**
Developer Tools → States, verify these have recent updates:
- [ ] `sensor.electricity_total_price_cents` (< 5 min ago)
- [ ] `sensor.overall_power_factor` (< 1 min ago)
- [ ] `sensor.rolling_average_60min` (< 1 min ago)
- [ ] All Node-RED flows showing activity

**Check Automations:**
Settings → Automations → Filter: Power
- [ ] All automations enabled
- [ ] No error icons
- [ ] Last triggered times visible

---

#### 5.2 - Load Balancer Test (10 min)
**Status**: ⬜ Not Started

**Test Scenario**: Sauna + Tesla charging

1. [ ] Turn on sauna
2. [ ] Start Tesla charging (if available)
3. [ ] Watch Node-RED debug panel
4. [ ] Expected: Tesla charging reduced OR water boiler turned off
5. [ ] Receive notification explaining action

**Alternative if no Tesla**: Turn on sauna + water boiler + heat pump
- Should see coordination between devices

**✅ Pass Criteria:**
- [ ] System detects high load
- [ ] Takes action within 30 seconds
- [ ] Notification received
- [ ] Fuse doesn't trip!

---

#### 5.3 - Peak Power Limiter Test (10 min)
**Status**: ⬜ Not Started

**Test Scenario**: Approach 8 kW limit

1. [ ] Monitor `sensor.rolling_average_60min`
2. [ ] Enable multiple high-power devices
3. [ ] Watch as average climbs toward 7 kW
4. [ ] Expected: Warning notification at 7 kW
5. [ ] Expected: Action taken before 8 kW

**✅ Pass Criteria:**
- [ ] 60-min rolling average calculated correctly
- [ ] Warning received at 7 kW
- [ ] Intervention prevents exceeding 8 kW
- [ ] System stable after intervention

---

#### 5.4 - Price Optimizer Test (10 min)
**Status**: ⬜ Not Started

**Test Scenario**: Heat pump temperature adjustment

1. [ ] Check current electricity price rank (1-24)
2. [ ] Check heat pump current temperature
3. [ ] Expected behavior:
   - Rank 1-6 (cheapest): Boost temperature
   - Rank 7-18 (normal): Normal temperature
   - Rank 19-24 (expensive): Eco temperature

**Manual test**:
1. [ ] Set `input_number.shf_rank_slider` to 10
2. [ ] Wait 1 minute
3. [ ] Heat pump should adjust if price rank acceptable

**✅ Pass Criteria:**
- [ ] Heat pump responds to price changes
- [ ] Temperature adjustments happen within 2 minutes
- [ ] System logs show decision reasoning

---

#### 5.5 - Professional Charts Test (5 min)
**Status**: ⬜ Not Started

**Check each chart:**
- [ ] Chart 1: Shows price + power + PF
- [ ] Chart 2: 3-phase PF with quality zones
- [ ] Chart 3: Device comparison bars
- [ ] Chart 4: Real-time radial gauges updating
- [ ] Chart 5: Weekly heatmap has data
- [ ] Chart 6: Scatter plot shows points

**Performance:**
- [ ] Charts load in < 3 seconds
- [ ] No lag when zooming/panning
- [ ] Data updates in real-time

---

#### 5.6 - AI Reporting Test (10 min)
**Status**: ⬜ Not Started

**Test 1: Manual Daily Report**
1. [ ] Developer Tools → Services
2. [ ] Service: `automation.trigger`
3. [ ] Entity: `automation.ai_daily_energy_report`
4. [ ] Wait 30 seconds
5. [ ] Check Telegram for report

**Test 2: AI Query**
1. [ ] Click "Ask AI" button on dashboard
2. [ ] Should receive analysis via Telegram
3. [ ] Response should be relevant and in Finnish

**✅ Pass Criteria:**
- [ ] AI report received and makes sense
- [ ] Data in report matches actual values
- [ ] Response is conversational
- [ ] No API errors in logs

---

#### 5.7 - 24-Hour Stability Test
**Status**: ⬜ Not Started

**Let system run for 24 hours and verify:**

**Next Day Checklist:**
- [ ] No errors in logs
- [ ] No automation failures
- [ ] Node-RED flows still running
- [ ] All sensors still updating
- [ ] Received morning AI report
- [ ] Charts showing historical data
- [ ] Peak limiter logged interventions (if any)
- [ ] System stable and responsive

**Data Collection Check:**
- [ ] `sensor.rolling_average_60min` has 24h history
- [ ] Power factor sensors logged data
- [ ] Price changes reflected in charts
- [ ] Device activity tracked correctly

---

**✅ Phase 5 Complete When:**
- [ ] All component tests passed
- [ ] 24-hour stability confirmed
- [ ] No critical errors in logs
- [ ] All automations triggered correctly
- [ ] Charts displaying full data
- [ ] AI reports received as scheduled

**🎉 Achievement Unlocked**: Production-ready power management system!

---

# 🎯 POST-IMPLEMENTATION

## Week 1: Observation Period

**Daily Tasks:**
- [ ] Check logs for errors
- [ ] Review AI daily reports
- [ ] Verify peak limiter interventions
- [ ] Monitor power factor trends
- [ ] Adjust temperature thresholds if needed

**What to Watch:**
- Peak power staying under 8 kW?
- Heat pump comfortable temperatures?
- Sauna coordination working smoothly?
- Tesla charging at cheap times?
- Power factor stable 0.85-0.95?

## Week 2-4: Optimization

**Fine-tune settings based on behavior:**
- [ ] Adjust `input_number.peak_power_threshold` if too sensitive
- [ ] Optimize price rank thresholds
- [ ] Customize AI report frequency
- [ ] Add more devices to load balancer
- [ ] Create custom dashboard views

**Expected Results After 1 Month:**
- Zero fuse trips
- Tehomaksu fees: 0-2€ (vs 50-150€ without system)
- Heat pump running at cheapest hours
- Equipment health: All devices showing good PF
- System: "Set and forget" - no maintenance needed

---

## 📊 Success Metrics

Track these to measure system performance:

**Safety:**
- [ ] Zero fuse overloads
- [ ] No voltage alerts
- [ ] Proper phase balance

**Efficiency:**
- [ ] Peak power < 8 kW consistently
- [ ] Power factor > 0.90 average
- [ ] Heat pump running during cheap hours

**Automation:**
- [ ] Load balancer interventions: 5-15/week
- [ ] Peak limiter activations: 0-3/month
- [ ] Price optimizer switches: 3-6/day
- [ ] AI reports: 8-10/week

**User Experience:**
- [ ] Dashboard loads fast (< 3 sec)
- [ ] Charts helpful and informative
- [ ] AI reports actionable
- [ ] No manual intervention needed

---

## 🆘 Troubleshooting Common Issues

### Issue: Sensors showing "unavailable"
**Fix**: 
1. Check if device is online (Shelly EM3)
2. Restart integration: Settings → Devices → [Device] → Reload
3. Check entity IDs haven't changed

### Issue: Node-RED flows not responding
**Fix**:
1. Check flows are deployed (green checkmark)
2. Enable debug nodes
3. Check Home Assistant connection in Node-RED
4. Restart Node-RED addon

### Issue: Charts not loading
**Fix**:
1. Clear browser cache
2. Check ApexCharts card installed
3. Verify sensor data exists (Developer Tools → States)
4. Check browser console for errors (F12)

### Issue: AI reports not arriving
**Fix**:
1. Check API key valid (Settings → Voice Assistants)
2. Verify `input_boolean.ai_reports_enabled` is ON
3. Check Telegram bot working
4. Review logs for API errors
5. Check automation enabled and not erroring

### Issue: Heat pump not responding to price optimizer
**Fix**:
1. Verify `input_boolean.price_optimizer_enabled` is ON
2. Check current price rank in range
3. Enable Node-RED debug to see decision logic
4. Verify heat pump entity ID correct

---

## 📚 Quick Reference

**Need help? Check these guides:**

| Issue | Guide |
|-------|-------|
| Deprecated sensors | QUICK_MIGRATION.md |
| Flow setup | IMPLEMENTATION_CHECKLIST.md |
| Chart configuration | PROFESSIONAL_APEXCHARTS.md |
| AI setup | AI_POWER_MANAGEMENT.md |
| Daily usage | QUICK_REFERENCE.md |
| Complete overview | README.md |

---

## 🎓 What You've Accomplished

After completing all phases:

✅ **Future-proof system** - No deprecated code, works through HA 2027+  
✅ **Intelligent automation** - 4 Node-RED flows protecting fuses and optimizing costs  
✅ **Professional monitoring** - 6 advanced charts with power factor analysis  
✅ **AI insights** - Natural language reports and anomaly detection  
✅ **Complete control** - Professional dashboard with all settings  
✅ **Equipment health** - Real-time efficiency and maintenance tracking  
✅ **Peace of mind** - "Set and forget" automation requiring zero maintenance

**You now have a system that:**
- Prevents fuse overload automatically
- Eliminates tehomaksu peak fees
- Optimizes heating based on electricity prices
- Monitors equipment health
- Explains what it's doing in plain language
- Runs completely hands-off

---

## 🎉 Final Checklist

Before marking project complete:

- [ ] Phase 1: ✅ Complete (Legacy sensors migrated)
- [ ] Phase 2: ✅ Complete (Core system deployed)
- [ ] Phase 3: ✅ Complete (Professional charts active)
- [ ] Phase 4: ✅ Complete (AI reporting enabled)
- [ ] Phase 5: ✅ Complete (24h stability test passed)
- [ ] Week 1: ✅ Complete (Observation period)
- [ ] Documentation read and bookmarked
- [ ] Emergency rollback procedures understood
- [ ] Comfortable with system operation

**System Status**: _________________ (Not Started / In Progress / Production Ready)

**Date Completed**: _________________

**Notes**: _________________

---

**🚀 Ready to start? Begin with Phase 1!**

**Questions?** Each guide has detailed troubleshooting sections.

**Good luck!** You're building something awesome! 🏠⚡✨
