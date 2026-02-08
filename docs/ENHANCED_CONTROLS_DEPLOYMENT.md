# 🎛️ Enhanced Control System - Deployment Guide

## 📋 Overview

This document covers the deployment of enhanced adjustable controls for:
- **Boiler:** Max rank slider, daily runtime limit, Luxus mode
- **Tesla:** Priority charging override
- **Radiators:** Per-room outside temp threshold, min/max room temps

---

## 🔧 Step 1: Create Helper Entities in Home Assistant

### Option A: Using UI (Recommended)

1. Navigate to **Settings** → **Devices & Services** → **Helpers**
2. Click **+ CREATE HELPER** for each entity below

#### Boiler Helpers

**Boiler Max Price Rank**
- Type: Number
- Name: `Boiler Max Price Rank`
- Entity ID: `input_number.boiler_max_rank`
- Min: 1, Max: 24, Step: 1
- Initial: 8
- Unit: rank
- Icon: `mdi:numeric`

**Boiler Max Hours Per Day**
- Type: Number
- Name: `Boiler Max Hours Per Day`
- Entity ID: `input_number.boiler_max_hours_daily`
- Min: 1, Max: 8, Step: 0.5
- Initial: 3
- Unit: h
- Icon: `mdi:clock-outline`

**Boiler Luxus Mode**
- Type: Toggle
- Name: `Boiler Luxus Mode (2h)`
- Entity ID: `input_boolean.boiler_luxus_mode`
- Icon: `mdi:water-boiler-alert`

**Boiler Luxus Activated Time**
- Type: Date and Time
- Name: `Boiler Luxus Activated Time`
- Entity ID: `input_datetime.boiler_luxus_activated`
- Enable date: Yes
- Enable time: Yes

#### Tesla Helpers

**Tesla Priority Charging**
- Type: Toggle
- Name: `Tesla Priority Charging`
- Entity ID: `input_boolean.tesla_priority_charging`
- Icon: `mdi:car-electric-outline`

#### MH1 (Master Bedroom) Radiator Helpers

**Outside Temperature Threshold**
- Type: Number
- Name: `MH1 Outside Temp Threshold`
- Entity ID: `input_number.mh1_outside_temp_threshold`
- Min: -30, Max: 20, Step: 1
- Initial: 10
- Unit: °C
- Icon: `mdi:thermometer-low`

**Min Room Temperature**
- Type: Number
- Name: `MH1 Min Room Temperature`
- Entity ID: `input_number.mh1_min_room_temp`
- Min: 15, Max: 25, Step: 0.5
- Initial: 19
- Unit: °C
- Icon: `mdi:thermometer-chevron-down`

**Max Room Temperature**
- Type: Number
- Name: `MH1 Max Room Temperature`
- Entity ID: `input_number.mh1_max_room_temp`
- Min: 18, Max: 28, Step: 0.5
- Initial: 21
- Unit: °C
- Icon: `mdi:thermometer-chevron-up`

#### Tuomas Room Radiator Helpers

**Outside Temperature Threshold**
- Type: Number
- Name: `Tuomas Outside Temp Threshold`
- Entity ID: `input_number.tuomas_outside_temp_threshold`
- Min: -30, Max: 20, Step: 1
- Initial: 12
- Unit: °C
- Icon: `mdi:thermometer-low`

**Min Room Temperature**
- Type: Number
- Name: `Tuomas Min Room Temperature`
- Entity ID: `input_number.tuomas_min_room_temp`
- Min: 15, Max: 25, Step: 0.5
- Initial: 20
- Unit: °C
- Icon: `mdi:thermometer-chevron-down`

**Max Room Temperature**
- Type: Number
- Name: `Tuomas Max Room Temperature`
- Entity ID: `input_number.tuomas_max_room_temp`
- Min: 18, Max: 28, Step: 0.5
- Initial: 22
- Unit: °C
- Icon: `mdi:thermometer-chevron-up`

#### Sara Room Radiator Helpers

**Outside Temperature Threshold**
- Type: Number
- Name: `Sara Outside Temp Threshold`
- Entity ID: `input_number.sara_outside_temp_threshold`
- Min: -30, Max: 20, Step: 1
- Initial: 12
- Unit: °C
- Icon: `mdi:thermometer-low`

**Min Room Temperature**
- Type: Number
- Name: `Sara Min Room Temperature`
- Entity ID: `input_number.sara_min_room_temp`
- Min: 15, Max: 25, Step: 0.5
- Initial: 20
- Unit: °C
- Icon: `mdi:thermometer-chevron-down`

**Max Room Temperature**
- Type: Number
- Name: `Sara Max Room Temperature`
- Entity ID: `input_number.sara_max_room_temp`
- Min: 18, Max: 28, Step: 0.5
- Initial: 22
- Unit: °C
- Icon: `mdi:thermometer-chevron-up`

### Option B: Using YAML Configuration

Copy the contents of `power-management/enhanced_helpers.yaml` to your `configuration.yaml` or include it:

```yaml
# In configuration.yaml
input_number: !include power-management/enhanced_helpers.yaml
input_boolean: !include power-management/enhanced_helpers.yaml
input_datetime: !include power-management/enhanced_helpers.yaml
```

Then restart Home Assistant.

---

## 📥 Step 2: Import Updated Node-RED Flows

### Update Existing Flows

1. **Open Node-RED** (usually at `http://homeassistant.local:1880`)

2. **Import Priority Load Balancer:**
   - Click hamburger menu (☰) → Import
   - Click "select a file to import"
   - Choose: `power-management/flows/priority-load-balancer.json`
   - **IMPORTANT:** Select "Update existing flow"
   - Click Import

3. **Import Price-Based Optimizer:**
   - Click hamburger menu (☰) → Import
   - Choose: `power-management/flows/price-based-optimizer.json`
   - Select "Update existing flow"
   - Click Import

4. **Import Temperature-Radiator Control:**
   - Click hamburger menu (☰) → Import
   - Choose: `power-management/flows/temperature-radiator-control.json`
   - Select "Update existing flow"
   - Click Import

5. **Deploy Changes:**
   - Click the red **Deploy** button (top right)
   - Confirm any warnings

---

## 🔍 Step 3: Verify Configuration

### Check Helper Entities

In Home Assistant:
1. Go to **Developer Tools** → **States**
2. Search for entities starting with:
   - `input_number.boiler_`
   - `input_boolean.boiler_luxus_mode`
   - `input_boolean.tesla_priority_charging`
   - `input_number.mh1_`
   - `input_number.tuomas_`
   - `input_number.sara_`

All should be present and have default values.

### Check Node-RED Flow Status

In Node-RED:
1. Open the **Priority Load Balancer** tab
2. Open the **Price-Based Optimizer** tab
3. Open the **Temperature-Based Radiator Control** tab
4. All nodes should show green "connected" status
5. No red error triangles should be visible

---

## 🎮 Step 4: Test New Features

### Test 1: Boiler Max Rank Control

**Before:** Boiler runs when rank ≤ 8 (slider default)

1. Set `input_number.boiler_max_rank` to **5**
2. Wait for next price check (15 minutes max)
3. Verify boiler only runs when rank ≤ 5
4. Check Node-RED debug panel for status messages

**Expected Result:** Boiler respects new rank limit

### Test 2: Boiler Daily Runtime Limit

**Before:** Boiler could run 8+ hours if all hours are cheap

1. Set `input_number.boiler_max_hours_daily` to **2.0**
2. Manually turn on boiler
3. Wait 2 hours (or simulate by adjusting flow context)
4. Verify boiler automatically turns off after 2 hours

**Expected Result:** 
- Boiler stops at 2-hour limit
- Status message: "Daily 2h limit reached"
- Resets at midnight

### Test 3: Boiler Luxus Mode (Sauna Party Mode)

**Scenario:** Many people using sauna, need hot water ASAP

1. Turn on `input_boolean.boiler_luxus_mode`
2. Boiler should immediately turn ON (regardless of price rank)
3. Verify status shows: "🌟 LUXUS MODE - Xh remaining"
4. After 2 hours, Luxus mode automatically disables
5. Receive notification: "Luxus mode ended"

**Expected Result:**
- Boiler runs immediately
- Ignores price rank
- Still respects daily runtime limit
- Auto-disables after 2 hours

### Test 4: Tesla Priority Charging

**Scenario:** Need car charged ASAP (e.g., unexpected trip)

1. Plug in Tesla
2. Turn on `input_boolean.tesla_priority_charging`
3. Verify:
   - Sauna turns OFF if currently on
   - Boiler turns OFF if currently on
   - Tesla charges at maximum rate
4. When battery reaches 80%, priority mode auto-disables

**Expected Result:**
- Tesla gets maximum power
- All other loads disabled
- Auto-disables when charged
- Notification sent

### Test 5: Radiator Outside Temperature Threshold

**Scenario:** It's getting warm outside, no need for heating

**MH1 Test:**
1. Current outside temp: 15°C
2. Set `input_number.mh1_outside_temp_threshold` to **12°C**
3. Verify MH1 radiator turns OFF
4. Status: "Outside 15°C ≥ threshold 12°C"

**Expected Result:** Radiator stays off until outside temp drops below threshold

### Test 6: Radiator Min/Max Room Temperature

**Tuomas Room Test:**
1. Set `input_number.tuomas_min_room_temp` to **20.0°C**
2. Set `input_number.tuomas_max_room_temp` to **22.0°C**
3. When room temp < 20°C → radiator ON
4. When room temp ≥ 22°C → radiator OFF
5. Between 20-22°C → maintains current state (hysteresis)

**Expected Result:**
- Room maintains comfortable temperature range
- No rapid on/off cycling
- Works even when kids not home (safety minimum = min - 2°C)

---

## 📊 Step 5: Dashboard Integration

### Add New Controls to Dashboard

Create a new dashboard card or add to existing:

```yaml
type: entities
title: 🎛️ Enhanced Power Controls
entities:
  # Boiler Controls
  - type: section
    label: Water Boiler
  - entity: input_number.boiler_max_rank
    name: Max Price Rank
  - entity: input_number.boiler_max_hours_daily
    name: Max Hours Per Day
  - entity: input_boolean.boiler_luxus_mode
    name: Luxus Mode (2h)
  - entity: sensor.boiler_runtime_today
    name: Runtime Today
  - entity: sensor.boiler_remaining_hours
    name: Remaining Hours
  
  # Tesla Controls
  - type: section
    label: Tesla Charging
  - entity: input_boolean.tesla_priority_charging
    name: Priority Charging
  - entity: sensor.tesla_model_3_battery
    name: Battery Level
  
  # MH1 Radiator Controls
  - type: section
    label: MH1 Radiator
  - entity: input_number.mh1_outside_temp_threshold
    name: Outside Temp Threshold
  - entity: input_number.mh1_min_room_temp
    name: Min Room Temp
  - entity: input_number.mh1_max_room_temp
    name: Max Room Temp
  
  # Tuomas Radiator Controls
  - type: section
    label: Tuomas Room
  - entity: input_number.tuomas_outside_temp_threshold
    name: Outside Temp Threshold
  - entity: input_number.tuomas_min_room_temp
    name: Min Room Temp
  - entity: input_number.tuomas_max_room_temp
    name: Max Room Temp
  
  # Sara Radiator Controls
  - type: section
    label: Sara Room
  - entity: input_number.sara_outside_temp_threshold
    name: Outside Temp Threshold
  - entity: input_number.sara_min_room_temp
    name: Min Room Temp
  - entity: input_number.sara_max_room_temp
    name: Max Room Temp
```

---

## 🚨 Troubleshooting

### Issue: Helpers Not Appearing

**Solution:**
1. Check `configuration.yaml` syntax: Developer Tools → YAML → Check Configuration
2. Restart Home Assistant: Developer Tools → Restart
3. Clear browser cache
4. Check Home Assistant logs for errors

### Issue: Node-RED Shows "entity not found"

**Solution:**
1. Verify all helper entities exist in HA
2. Check entity IDs match exactly (case-sensitive)
3. Restart Node-RED: Supervisor → Node-RED → Restart
4. Re-deploy flows: Node-RED → Deploy button

### Issue: Boiler Runtime Not Tracking

**Solution:**
1. Check Node-RED debug panel for errors
2. Verify `switch.shellypro4pm_ec62609fd3dc_switch_2` is correct entity
3. Manually reset: Developer Tools → Services
   ```yaml
   service: input_number.set_value
   target:
     entity_id: sensor.boiler_runtime_today
   data:
     value: 0
   ```

### Issue: Luxus Mode Not Auto-Disabling

**Solution:**
1. Check automation: Developer Tools → Automations
2. Search for "Boiler Luxus Mode Auto Disable"
3. Verify it's enabled (toggle on)
4. Check `input_datetime.boiler_luxus_activated` has a value

### Issue: Tesla Priority Not Turning Off Sauna

**Solution:**
1. Check sauna entity ID in Node-RED flow
2. Update line in `priority-load-balancer.json`:
   ```javascript
   entity_id: 'switch.sauna'  // CHANGE THIS TO YOUR ACTUAL SAUNA SWITCH
   ```
3. Common entity IDs:
   - `switch.kiuas`
   - `switch.sauna_heater`
   - `binary_sensor.kiuas_tilatieto` (this is status, not control!)

### Issue: Radiators Not Respecting Outside Temp

**Solution:**
1. Verify `sensor.outside_temperature` exists
2. If different entity name, update in flows:
   ```javascript
   const outsideTemp = parseFloat(global.get('homeassistant.homeAssistant.states["sensor.YOUR_OUTSIDE_TEMP"].state'));
   ```
3. Common alternatives:
   - `sensor.outdoor_temperature`
   - `sensor.weather_temperature`
   - `weather.home` (use `.attributes.temperature`)

---

## 📈 Monitoring and Optimization

### Daily Monitoring Checklist

**Morning (check yesterday's performance):**
- [ ] Boiler runtime < daily limit?
- [ ] Tesla charged successfully?
- [ ] Radiators maintained target temps?
- [ ] No overload events?

**Evening (adjust for tonight):**
- [ ] Check tomorrow's Nordpool prices
- [ ] Adjust `boiler_max_rank` if needed (lower = cheaper hours only)
- [ ] Set Tesla priority if travel tomorrow
- [ ] Adjust radiator thresholds for weather forecast

### Optimization Tips

**Boiler Optimization:**
- **Winter:** Set max rank to 10-12 (more running time)
- **Spring/Fall:** Set max rank to 6-8 (balanced)
- **Summer:** Set max rank to 4-6 (only cheapest hours)
- **Daily hours:** Start at 3h, increase if not enough hot water

**Radiator Optimization:**
- **Cold spell coming:** Lower outside threshold (e.g., 8°C)
- **Mild weather:** Raise outside threshold (e.g., 15°C)
- **Kids at home:** Use normal min/max (20-22°C)
- **Kids away:** Lower to 18°C minimum (safety only)

**Tesla Optimization:**
- **Daily commute:** Let normal priority handle it
- **Long trip tomorrow:** Use priority mode evening before
- **Sauna night:** Disable priority, let sauna have priority

---

## 🎯 Success Criteria

### After 1 Week

- [ ] Boiler runs only during cheap hours (rank ≤ threshold)
- [ ] Boiler respects daily runtime limit
- [ ] No manual boiler interventions needed
- [ ] Tesla charges reliably when plugged in
- [ ] Radiators maintain comfortable temperatures
- [ ] No fuse trips or overload events
- [ ] Energy costs tracking as expected

### After 1 Month

- [ ] Optimized boiler rank threshold for your usage
- [ ] Optimized daily runtime for family size
- [ ] Radiator thresholds set for comfort
- [ ] Luxus mode used successfully for sauna parties
- [ ] Tesla priority mode used when needed
- [ ] Monthly energy bill reduced compared to pre-automation

---

## 📞 Support

### If Issues Persist

1. **Check Logs:**
   - Home Assistant: Settings → System → Logs
   - Node-RED: Debug panel (right sidebar)

2. **Export Flow for Review:**
   - Node-RED → Select problem flow → Export → Copy to clipboard
   - Share in support channel

3. **Common Entity IDs to Verify:**
   ```yaml
   # Boiler
   switch.shellypro4pm_ec62609fd3dc_switch_2
   
   # Tesla
   switch.tesla_model_3_charger
   number.tesla_model_3_charging_amps
   sensor.tesla_model_3_battery
   device_tracker.tesla_model_3_location_tracker
   
   # Sauna
   binary_sensor.kiuas_tilatieto
   switch.sauna  # ← VERIFY THIS EXISTS OR UPDATE
   
   # Radiators
   switch.mh1
   switch.shellypro4pm_ec62609fd3dc_switch_1  # Tuomas
   switch.shellypro4pm_ec62609fd3dc_switch_0  # Sara
   
   # Sensors
   sensor.aqara_makuuhuone_temperature  # MH1
   sensor.aqara_tuomas_temperature
   sensor.aqara_sara_temperature
   sensor.outside_temperature  # ← VERIFY THIS EXISTS
   ```

4. **Documentation Reference:**
   - [FLOW_COMMUNICATION_GUIDE.md](./FLOW_COMMUNICATION_GUIDE.md)
   - [COMPLETE_SOLUTION_SUMMARY.md](./COMPLETE_SOLUTION_SUMMARY.md)
   - [URGENT_TESLA_LOCATION_FIX.md](./URGENT_TESLA_LOCATION_FIX.md)

---

## 🎉 Congratulations!

You now have a fully adjustable, intelligent power management system that:

✅ Optimizes boiler operation (rank + runtime limits)  
✅ Provides Luxus mode for special occasions  
✅ Allows Tesla priority charging when needed  
✅ Maintains comfortable room temperatures  
✅ Prevents heating when outside temp is mild  
✅ Prevents fuse overload  
✅ Minimizes electricity costs  

**Enjoy your smart home! 🏠⚡💡**
