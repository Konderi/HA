# 🔥 Heating Automation Migration Guide
## From Home Assistant YAML to Node-RED

**Complete step-by-step guide for migrating all heating automations to Node-RED**

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [What Will Be Migrated](#what-will-be-migrated)
3. [Prerequisites](#prerequisites)
4. [Backup & Safety](#backup--safety)
5. [Migration Steps](#migration-steps)
6. [Testing & Verification](#testing--verification)
7. [Troubleshooting](#troubleshooting)
8. [Rollback Plan](#rollback-plan)

---

## 🎯 Overview

### Current State
You have **6 heating-related automations** in Home Assistant YAML that will be **disabled and replaced** with Node-RED flows.

### Goal
Replace all YAML heating automations with the existing Node-RED power management system that provides:
- ✅ Better priority-based load balancing
- ✅ Tehomaksu protection
- ✅ Price-based optimization
- ✅ Real-time power monitoring
- ✅ More flexible control logic

### Duration
**30-45 minutes** (including testing)

---

## 📦 What Will Be Migrated

### Automations to Disable

| ID | Name | Function | Node-RED Replacement |
|----|------|----------|---------------------|
| `1666961541365` | Lämmityksen automaatio - Pois | Heating OFF logic | ✅ Price-Based Optimizer flow |
| `1666961714981` | Lämmityksen automaation - Päälle | Heating ON logic | ✅ Price-Based Optimizer flow |
| `3b383a06f71143e883221608f2ff9d86` | Set device start time | Cheapest hours start | ✅ Price-Based Optimizer flow |
| `a0f877d06c1d47c89a0e1bf2d7ab9505` | Set device end time | Cheapest hours end | ✅ Price-Based Optimizer flow |
| `1693767733108` | Lämmitys automaatiot - päälle/pois | Master heating switch | ✅ Priority Load Balancer flow |
| `1672842981754` | Presence: Somebody arrives home | Temperature on arrival | 🔄 Keep (presence logic) |
| `1672843062348` | Presence: Everybody leaves home | Temperature when away | 🔄 Keep (presence logic) |

### What Each Automation Does

#### 1. **Lämmityksen automaatio - Pois** (ID: 1666961541365)
**Current Logic:**
```yaml
Trigger: When electricity rank becomes unacceptable
Actions:
  - Turn OFF patterit (radiators)
  - If home: Set heat pump to normal temp (input_number.normaalilampo_presence)
  - If away: Set heat pump to reduced temp (input_number.lammonpudotus_presence)
  - Turn OFF water boiler
```

**Node-RED Replacement:**
✅ **Price-Based Optimizer flow** already handles this:
- Monitors Nordpool rank sensor
- Adjusts heat pump temperature based on price rank
- Controls water boiler during cheap hours
- Priority Load Balancer ensures patterit don't overload system

#### 2. **Lämmityksen automaation - Päälle** (ID: 1666961714981)
**Current Logic:**
```yaml
Trigger: When electricity price/rank becomes acceptable
Actions:
  - Set heat pump to boost temp (input_number.tehostuslampo)
  - If outdoor temp < trigger: Turn ON patterit
  - Turn ON water boiler
```

**Node-RED Replacement:**
✅ **Price-Based Optimizer flow** already handles this:
- Monitors price rank for cheap hours
- Boosts heat pump temperature during 6 cheapest hours
- Controls water boiler automatically
- Patterit controlled by Priority Load Balancer

#### 3. **Set device start time** (ID: 3b383a06f71143e883221608f2ff9d86)
**Current Logic:**
```yaml
Trigger: Daily at 23:10
Action: Set input_datetime.device_start_time to cheapest hours
```

**Node-RED Replacement:**
✅ **Price-Based Optimizer flow** already handles this:
- Continuously monitors Nordpool rank (1-24)
- No need for preset start times
- Dynamic adjustment every hour

#### 4. **Set device end time** (ID: a0f877d06c1d47c89a0e1bf2d7ab9505)
**Current Logic:**
```yaml
Trigger: Daily at 23:15
Action: Set input_datetime.device_end_time based on heating hours
```

**Node-RED Replacement:**
✅ **Price-Based Optimizer flow** already handles this:
- Uses rank-based thresholds instead of fixed windows
- More flexible than time-based approach

#### 5. **Lämmitys automaatiot - päälle/pois** (ID: 1693767733108)
**Current Logic:**
```yaml
Trigger: input_boolean.lvv_heating toggle
Actions:
  - Enable/disable other heating automations
```

**Node-RED Replacement:**
✅ **Priority Load Balancer flow** has master controls:
- Uses `input_boolean.power_management_active`
- Individual device toggles available
- Better integration with power management

#### 6. **Presence Automations** (Keep Both)
**Why Keep:**
- These handle presence-based temperature adjustments
- Not directly related to power management
- Work alongside Node-RED flows
- Handle lighting control too

---

## ✅ Prerequisites

### Required Node-RED Flows (Already Installed)
- ✅ Priority Load Balancer
- ✅ Peak Power Limiter
- ✅ Price-Based Optimizer
- ✅ Phase Monitor & Alerts

### Required Entities

**Input Numbers (Verify these exist):**
```yaml
input_number:
  # Temperature settings
  normaalilampo_presence:      # Normal temperature when home
  lammonpudotus_presence:      # Reduced temperature when away
  tehostuslampo:               # Boost temperature during cheap hours
  ulkolampo_trigger:           # Outdoor temp trigger for radiators
  
  # Heating schedule
  lammitystunnit:              # Number of heating hours
  
  # Price thresholds
  auton_lataus:                # Car charging price threshold
```

**Input Booleans (Verify these exist):**
```yaml
input_boolean:
  lvv_heating:                 # Master heating automation toggle
  power_management_active:     # Node-RED master switch (NEW)
```

**Sensors (Verify these exist):**
```yaml
sensor:
  cheapest_hours_energy_tomorrow   # Cheapest hours calculator
  shf_electricity_price_now        # Current electricity price
  nordpool_rank                    # Nordpool price rank (1-24)
  
binary_sensor:
  shf_rank_acceptable              # Price rank acceptable binary
  shf_price_or_rank_acceptable     # Combined price/rank check
```

**Devices:**
```yaml
switch:
  patterit                          # Radiators
  shellypro4pm_ec62609fd3dc_switch_2  # Water boiler (LVV)
  
climate:
  mitsu_ilp                         # Mitsubishi heat pump
  mitsubishi_rw25                   # Mitsubishi heat pump (alternative name)
```

---

## 🛡️ Backup & Safety

### Step 1: Backup Current Configuration

```bash
# Create backup folder
mkdir -p ~/ha-heating-backup-$(date +%Y%m%d)

# Backup automations
cp /config/automations.yaml ~/ha-heating-backup-$(date +%Y%m%d)/

# Backup Node-RED flows
cp ~/.node-red/flows.json ~/ha-heating-backup-$(date +%Y%m%d)/

# Backup input configurations
cp /config/input_boolean.yaml ~/ha-heating-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp /config/input_number.yaml ~/ha-heating-backup-$(date +%Y%m%d)/ 2>/dev/null || true
cp /config/input_datetime.yaml ~/ha-heating-backup-$(date +%Y%m%d)/ 2>/dev/null || true
```

### Step 2: Document Current State

**Take screenshots of:**
1. Current automation states (Settings → Automations)
2. Current heating temperatures
3. Current device states (radiators, heat pump, water boiler)
4. Node-RED flows

**Note current values:**
```yaml
# Document these values for reference
normaalilampo_presence: _____°C
lammonpudotus_presence: _____°C
tehostuslampo: _____°C
ulkolampo_trigger: _____°C
lammitystunnit: _____ hours
```

---

## 🚀 Migration Steps

### Phase 1: Prepare Node-RED (5 minutes)

#### Step 1.1: Verify Node-RED Flows Are Imported

1. Open Node-RED: `http://homeassistant.local:1880`
2. Check these tabs exist:
   - ✅ `Priority Load Balancer`
   - ✅ `Peak Power Limiter`
   - ✅ `Price-Based Optimizer`
   - ✅ `Phase Monitor`

If any are missing, import them from `power-management/flows/` folder.

#### Step 1.2: Configure Price-Based Optimizer for Heating

The flow already controls heating devices. Verify these nodes:

**Heat Pump Temperature Control:**
- Node: "Set Heat Pump Temp"
- Entity: `climate.mitsu_ilp` (or `climate.mitsubishi_rw25`)
- Temperatures:
  - Cheap hours (rank 1-6): High temp from `input_number.tehostuslampo`
  - Normal hours (rank 7-12): Normal temp from `input_number.normaalilampo_presence`
  - Expensive hours (rank 13-24): Reduced temp from `input_number.lamponpudotus_presence`

**Radiator Control:**
- Node: "Control Radiators"
- Entity: `switch.patterit`
- Logic: Only ON during 6 cheapest hours + outdoor temp check

**Water Boiler Control:**
- Node: "Control Water Boiler"
- Entity: `switch.shellypro4pm_ec62609fd3dc_switch_2`
- Logic: ON during cheap hours, OFF when sauna is on

#### Step 1.3: Add Outdoor Temperature Logic (If Not Present)

If your Node-RED flow doesn't have outdoor temperature checking for radiators:

1. In Price-Based Optimizer flow, find the radiator control section
2. Add a "current state" node before turning ON radiators:
   - Entity: `weather.forecast_koti`
   - Check if: `msg.data.attributes.temperature < states('input_number.ulkolampo_trigger')`
3. Only turn ON radiators if temperature check passes

**Example Flow Addition:**
```
[Rank 1-6 Trigger] → [Check Outdoor Temp] → [Turn ON Radiators if cold enough]
                                           → [Skip if warm]
```

#### Step 1.4: Enable All Node-RED Flows

1. In Node-RED, click **Deploy** (top right)
2. Verify deployment successful (green "deployed" message)
3. Check Node-RED debug panel for any errors

---

### Phase 2: Test Node-RED in Parallel (10 minutes)

**⚠️ Important: Don't disable YAML automations yet!**

#### Step 2.1: Enable Node-RED Master Switch

In Home Assistant:
1. Go to **Settings → Devices & Services → Helpers**
2. Find `input_boolean.power_management_active`
3. **Turn it ON**

#### Step 2.2: Monitor Both Systems

Watch for **30 minutes** to see both systems working:

**What to Monitor:**
- Heat pump temperature changes
- Radiator state (should both systems try to control it?)
- Water boiler state
- Electricity price rank changes
- Node-RED debug messages

**Expected Behavior:**
- Both systems may fight for control (this is OK during testing)
- Node-RED should respond faster to price changes
- YAML automations have fixed time triggers

#### Step 2.3: Verify Node-RED Responds Correctly

Test these scenarios:

**Test 1: Price Rank Change**
```
1. Check current rank: sensor.nordpool_rank
2. Wait for rank to change (happens every hour)
3. Verify Node-RED flow triggers
4. Check heat pump temperature adjusts
```

**Test 2: Outdoor Temperature**
```
1. Check current outdoor temp: weather.forecast_koti
2. If temp < trigger: Radiators should turn ON during cheap hours
3. If temp > trigger: Radiators should stay OFF
```

**Test 3: Water Boiler**
```
1. During cheap hours: Water boiler should turn ON
2. If sauna ON: Water boiler should turn OFF (priority)
3. During expensive hours: Water boiler should turn OFF
```

**Test 4: Manual Override**
```
1. Manually turn OFF input_boolean.power_management_active
2. All Node-RED control should stop
3. Turn back ON: Control should resume
```

---

### Phase 3: Disable YAML Automations (5 minutes)

**✅ Only proceed if Phase 2 testing was successful!**

#### Step 3.1: Disable Heating Time Automations

In Home Assistant:
1. Go to **Settings → Automations & Scenes**
2. Find and **disable** these:

   ✅ **Set device start time** (ID: 3b383a06f71143e883221608f2ff9d86)
   - Click the automation
   - Toggle switch to **OFF** (grey)
   - ✅ Disabled

   ✅ **Set device end time** (ID: a0f877d06c1d47c89a0e1bf2d7ab9505)
   - Click the automation
   - Toggle switch to **OFF** (grey)
   - ✅ Disabled

#### Step 3.2: Disable Main Heating Automations

   ✅ **Lämmityksen automaatio - Pois** (ID: 1666961541365)
   - Toggle switch to **OFF**
   - ✅ Disabled

   ✅ **Lämmityksen automaation - Päälle** (ID: 1666961714981)
   - Toggle switch to **OFF**
   - ✅ Disabled

#### Step 3.3: Disable Master Heating Switch

   ✅ **Lämmitys automaatiot - päälle/pois** (ID: 1693767733108)
   - Toggle switch to **OFF**
   - ✅ Disabled

#### Step 3.4: Keep Presence Automations Enabled

   ⚠️ **DO NOT DISABLE THESE:**
   - ✅ **Presence: Somebody arrives home** (ID: 1672842981754) - KEEP ENABLED
   - ✅ **Presence: Everybody leaves home** (ID: 1672843062348) - KEEP ENABLED

**Why?** These handle presence-based temperature adjustments and lighting, which work alongside Node-RED.

---

### Phase 4: Update Helper Naming (5 minutes)

#### Step 4.1: Rename/Add Input Booleans

You may want to keep the old `input_boolean.lvv_heating` for compatibility:

**Option A: Keep Both (Recommended)**
```yaml
# In input_boolean.yaml or configuration.yaml
input_boolean:
  lvv_heating:
    name: "LVV Heating (Legacy)"
    icon: mdi:water-boiler
    
  power_management_active:
    name: "Power Management Active"
    icon: mdi:power
```

**Option B: Link Old to New**

Create an automation to sync them:
```yaml
# In automations.yaml
- id: sync_heating_switches
  alias: "Sync Legacy Heating Switch"
  trigger:
    - platform: state
      entity_id: input_boolean.lvv_heating
  action:
    - service: input_boolean.turn_{{ trigger.to_state.state }}
      target:
        entity_id: input_boolean.power_management_active
```

#### Step 4.2: Verify Temperature Input Numbers

Make sure these are properly configured:

```yaml
# In input_number.yaml
input_number:
  normaalilampo_presence:
    name: "Normal Temperature (Home)"
    min: 18
    max: 25
    step: 0.5
    unit_of_measurement: "°C"
    icon: mdi:thermometer
    
  lammonpudotus_presence:
    name: "Reduced Temperature (Away)"
    min: 15
    max: 22
    step: 0.5
    unit_of_measurement: "°C"
    icon: mdi:thermometer-low
    
  tehostuslampo:
    name: "Boost Temperature (Cheap Hours)"
    min: 20
    max: 28
    step: 0.5
    unit_of_measurement: "°C"
    icon: mdi:thermometer-high
    
  ulkolampo_trigger:
    name: "Outdoor Temperature Trigger (Radiators)"
    min: -20
    max: 10
    step: 1
    unit_of_measurement: "°C"
    icon: mdi:snowflake-thermometer
```

---

### Phase 5: Configure Dashboard Controls (5 minutes)

#### Step 5.1: Add Power Management Card

Add this to your Lovelace dashboard:

```yaml
type: vertical-stack
cards:
  - type: custom:mushroom-title-card
    title: 🔥 Heating Control (Node-RED)
    subtitle: Professional Power Management System
    
  - type: custom:mushroom-select-card
    entity: input_boolean.power_management_active
    name: Power Management
    icon: mdi:power
    tap_action:
      action: toggle
      
  - type: horizontal-stack
    cards:
      - type: custom:mushroom-number-card
        entity: input_number.normaalilampo_presence
        name: Normal Temp
        icon: mdi:thermometer
        display_mode: buttons
        
      - type: custom:mushroom-number-card
        entity: input_number.tehostuslampo
        name: Boost Temp
        icon: mdi:thermometer-high
        display_mode: buttons
        
      - type: custom:mushroom-number-card
        entity: input_number.lammonpudotus_presence
        name: Away Temp
        icon: mdi:thermometer-low
        display_mode: buttons
        
  - type: custom:mushroom-number-card
    entity: input_number.ulkolampo_trigger
    name: Radiator Trigger (Outdoor Temp)
    icon: mdi:snowflake-thermometer
    display_mode: slider
    
  - type: entities
    title: Current Status
    entities:
      - entity: climate.mitsu_ilp
        name: Heat Pump
      - entity: switch.patterit
        name: Radiators
      - entity: switch.shellypro4pm_ec62609fd3dc_switch_2
        name: Water Boiler
      - entity: sensor.nordpool_rank
        name: Current Price Rank
      - entity: weather.forecast_koti
        name: Outdoor Temperature
```

#### Step 5.2: Add to Existing Power Management Dashboard

If you already have the power management dashboard (from DASHBOARD.md), add a new view:

```yaml
# Add as new view in dashboard
- title: Heating Control
  icon: mdi:fire
  path: heating
  badges: []
  cards:
    # Paste the vertical-stack card from Step 5.1 here
```

---

## ✅ Testing & Verification

### Test Checklist

#### Immediate Tests (After Disabling YAML)

- [ ] **Heat Pump responds to price changes**
  - Current rank < 6: Should boost to `tehostuslampo`
  - Current rank 7-12: Should be at `normaalilampo_presence`
  - Current rank > 12: Should reduce to `lammonpudotus_presence`

- [ ] **Radiators only ON when cold**
  - Outdoor temp < trigger: ON during cheap hours
  - Outdoor temp > trigger: Always OFF

- [ ] **Water boiler during cheap hours**
  - Rank 1-6: Should be ON (unless sauna is on)
  - Rank > 6: Should be OFF

- [ ] **Priority Load Balancer prevents overload**
  - If sauna ON: Car charger reduces/stops
  - If sauna ON: Water boiler OFF
  - Total power < 17,250W

- [ ] **Manual override works**
  - Toggle `input_boolean.power_management_active` OFF
  - All automation stops
  - Toggle ON: Automation resumes

#### 24-Hour Monitoring

Monitor these for a full day:

- [ ] **Temperature comfort maintained**
  - Home temperature stays within acceptable range
  - No unexpected cold/hot periods

- [ ] **Energy usage optimized**
  - High-power devices run during cheap hours
  - Electricity costs reduced

- [ ] **No fuse trips**
  - Priority Load Balancer prevents overload
  - Peak Power Limiter prevents tehomaksu

- [ ] **Presence detection still works**
  - Away temperature when nobody home
  - Normal temperature when someone arrives

#### Weekly Monitoring

After 1 week, check:

- [ ] **Cost savings**
  - Compare electricity costs to previous weeks
  - Should see 10-15% reduction

- [ ] **System stability**
  - No unexpected shutdowns
  - No comfort issues

- [ ] **Tehomaksu prevention**
  - Check monthly peak usage
  - Should stay under 8 kW threshold

---

## 🔍 Troubleshooting

### Issue: Heat Pump Not Responding

**Symptoms:**
- Temperature doesn't change
- No temperature commands in Node-RED debug

**Solutions:**

1. **Check Entity ID:**
   ```
   - Verify correct entity in Node-RED flow
   - Try: climate.mitsu_ilp OR climate.mitsubishi_rw25
   - Check Developer Tools → States for correct name
   ```

2. **Check Node-RED Flow:**
   ```
   - Open Node-RED debug panel
   - Deploy flows again
   - Check for error messages
   ```

3. **Check Heat Pump Availability:**
   ```
   - Is heat pump online?
   - Check climate entity state (not "unavailable")
   ```

### Issue: Radiators Won't Turn ON

**Symptoms:**
- Radiators stay OFF even during cheap hours
- Cold indoor temperature

**Solutions:**

1. **Check Outdoor Temperature:**
   ```
   - Is outdoor temp < trigger value?
   - Check weather.forecast_koti temperature
   - Adjust input_number.ulkolampo_trigger if needed
   ```

2. **Check Price Rank:**
   ```
   - Is current rank in cheap hours (1-6)?
   - Check sensor.nordpool_rank
   ```

3. **Check Priority Load Balancer:**
   ```
   - Is sauna ON? (Radiators get lower priority)
   - Check total power consumption
   - May be temporarily disabled to prevent overload
   ```

### Issue: Water Boiler Runs Too Much

**Symptoms:**
- Water boiler ON during expensive hours
- High electricity costs

**Solutions:**

1. **Check Price-Based Optimizer:**
   ```
   - Verify rank threshold (should be 1-6)
   - Check Node-RED flow logic
   ```

2. **Check Sauna Priority:**
   ```
   - Sauna should force water boiler OFF
   - Verify Priority Load Balancer working
   ```

### Issue: Old Automations Interfering

**Symptoms:**
- Devices turning ON/OFF unexpectedly
- Fighting between Node-RED and YAML

**Solutions:**

1. **Double-check all automations disabled:**
   ```
   Settings → Automations & Scenes
   Filter: "lämmitys" or "heating"
   Verify all are disabled (grey toggle)
   ```

2. **Check for duplicate automations:**
   ```
   Some automations may have similar names
   Disable ALL heating-related automations except presence
   ```

### Issue: Node-RED Not Triggering

**Symptoms:**
- No actions happening
- Debug panel empty

**Solutions:**

1. **Check Node-RED service:**
   ```bash
   # Restart Node-RED
   Settings → Add-ons → Node-RED → Restart
   ```

2. **Check flows deployed:**
   ```
   - Open Node-RED
   - Click "Deploy" button (even if no changes)
   - Should see green "deployed" message
   ```

3. **Check input_boolean.power_management_active:**
   ```
   - Must be ON for Node-RED to control devices
   - Check in Developer Tools → States
   ```

---

## 🔄 Rollback Plan

### If Something Goes Wrong

**Quick Rollback (5 minutes):**

1. **Disable Node-RED:**
   ```
   - Turn OFF input_boolean.power_management_active
   ```

2. **Re-enable YAML automations:**
   ```
   Settings → Automations & Scenes
   - Enable: Lämmityksen automaatio - Pois
   - Enable: Lämmityksen automaation - Päälle
   - Enable: Set device start time
   - Enable: Set device end time
   - Enable: Lämmitys automaatiot - päälle/pois
   ```

3. **Enable master switch:**
   ```
   - Turn ON input_boolean.lvv_heating
   ```

**Full Rollback (If needed):**

```bash
# Restore from backup
cd ~/ha-heating-backup-YYYYMMDD/

# Restore automations
cp automations.yaml /config/

# Restart Home Assistant
# Settings → System → Restart
```

---

## 📊 Comparison: Before vs After

### Before (YAML Automations)

**Pros:**
- ✅ Simple time-based scheduling
- ✅ Familiar YAML format

**Cons:**
- ❌ Fixed time windows (not flexible)
- ❌ No load balancing
- ❌ No tehomaksu protection
- ❌ No real-time power monitoring
- ❌ Multiple separate automations (hard to manage)
- ❌ Limited priority logic

### After (Node-RED)

**Pros:**
- ✅ Dynamic rank-based scheduling (better optimization)
- ✅ Priority Load Balancer (prevents fuse overload)
- ✅ Tehomaksu protection (saves 50-150€/year)
- ✅ Real-time power monitoring
- ✅ Integrated system (easier to manage)
- ✅ Visual flow editor (easier to understand/modify)
- ✅ Better logging and debugging

**Cons:**
- ⚠️ Requires Node-RED knowledge to modify
- ⚠️ More complex initial setup

---

## ✅ Success Criteria

### You've Successfully Migrated When:

- [ ] All 5 heating YAML automations are disabled
- [ ] Node-RED flows are running and deployed
- [ ] Heat pump responds to price rank changes
- [ ] Radiators only ON when outdoor temp is cold
- [ ] Water boiler runs during cheap hours
- [ ] Priority Load Balancer prevents overload
- [ ] No fuse trips for 24 hours
- [ ] Temperature comfort maintained
- [ ] `input_boolean.power_management_active` controls all devices
- [ ] Dashboard shows real-time status
- [ ] No errors in Node-RED debug panel

---

## 📚 Related Documentation

- **[POWER_MANAGEMENT_GUIDE.md](./POWER_MANAGEMENT_GUIDE.md)** - Complete system overview
- **[TEHOMAKSU_GUIDE.md](./TEHOMAKSU_GUIDE.md)** - Peak power protection details
- **[DASHBOARD.md](./DASHBOARD.md)** - Dashboard configuration
- **[PRICING_GUIDE.md](./PRICING_GUIDE.md)** - Electricity pricing details

---

## 🎉 Post-Migration Optimization

### After 1 Week of Stable Operation

1. **Fine-tune temperature settings:**
   - Adjust `tehostuslampo` if too hot/cold during cheap hours
   - Adjust `normaalilampo_presence` for comfort
   - Adjust `ulkolampo_trigger` based on indoor comfort

2. **Monitor cost savings:**
   - Compare electricity costs week-over-week
   - Should see 10-15% reduction

3. **Adjust rank thresholds:**
   - Currently set to rank 1-6 for cheap hours
   - Can adjust in Node-RED flow if needed

4. **Remove old YAML automations:**
   - After 2-3 weeks of stable operation
   - Delete disabled automations from automations.yaml
   - Keep presence automations!

---

**Migration created:** February 2026  
**HA Version:** 2026.2.x  
**Node-RED Version:** 21.0.0  
**Status:** ✅ Ready to execute
