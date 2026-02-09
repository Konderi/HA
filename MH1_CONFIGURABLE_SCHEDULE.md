# MH1 Radiator - Configurable Schedule Implementation

## Overview
Updated MH1 radiator control to use **configurable input_datetime helpers** instead of hardcoded schedule times. You can now adjust heating schedule times from the UI without editing Node-RED flows.

**Default Schedule:** 22:00 - 07:00 (night heating)

---

## Changes Made

### 1. Input DateTime Helper Configuration
**File:** `config/input_helpers/input_datetimes.yaml`

**Added:**
```yaml
mh1_start_time:
  name: "MH1 Heating Start Time"
  has_date: false
  has_time: true
  initial: "22:00:00"
  icon: mdi:clock-start

mh1_end_time:
  name: "MH1 Heating End Time"
  has_date: false
  has_time: true
  initial: "07:00:00"
  icon: mdi:clock-end
```

**Entity IDs:**
- `input_datetime.mh1_start_time` - Heating start time (default: 22:00)
- `input_datetime.mh1_end_time` - Heating end time (default: 07:00)

---

### 2. Node-RED Flow Updates
**Files:** 
- `nodered/flows/temperature-radiator-control.json`
- `power-management/flows/temperature-radiator-control.json`

**Changed from:**
```javascript
// FIXED SCHEDULE: 22:00 - 07:00 ONLY
const FIXED_START_HOUR = 22;
const FIXED_END_HOUR = 7;
```

**Changed to:**
```javascript
// Get configurable schedule times from input_datetime helpers
const startTimeStr = global.get('homeassistant.homeAssistant.states["input_datetime.mh1_start_time"].state') || "22:00:00";
const endTimeStr = global.get('homeassistant.homeAssistant.states["input_datetime.mh1_end_time"].state') || "07:00:00";

// Parse schedule times (format: "HH:MM:SS")
const startHour = parseInt(startTimeStr.split(':')[0]);
const endHour = parseInt(endTimeStr.split(':')[0]);

// Check if within STRICT schedule (supports overnight ranges)
const withinSchedule = startHour > endHour 
    ? (currentHour >= startHour || currentHour < endHour)  // Overnight: 22:00-07:00
    : (currentHour >= startHour && currentHour < endHour); // Same day: 08:00-16:00
```

**Key Features:**
- ✅ Reads schedule times from input_datetime helpers
- ✅ Supports overnight ranges (22:00-07:00)
- ✅ Supports same-day ranges (08:00-16:00)
- ✅ Falls back to 22:00-07:00 if helpers unavailable
- ✅ Shows actual schedule in error messages
- ✅ Maintains strict schedule enforcement (no safety overrides)

---

## Deployment Steps

### Step 1: Deploy Input DateTime Helpers to Home Assistant

Home Assistant needs to load the new helper configuration.

**Option A - Restart Home Assistant (Recommended):**
```bash
# Via HA UI:
Settings → System → Restart
```

**Option B - Reload Input DateTime Helpers Only:**
```bash
# Via HA UI:
Developer Tools → YAML → INPUT DATETIME
```

**Expected Result:**
After restart/reload, these entities should be available:
- `input_datetime.mh1_start_time` = 22:00:00
- `input_datetime.mh1_end_time` = 07:00:00

---

### Step 2: Verify Input Datetime Helpers

Check that the helpers are now available:

**Via Home Assistant UI:**
```
Settings → Devices & Services → Helpers
Search: "MH1"

Should see:
✅ MH1 Heating Start Time = 22:00:00
✅ MH1 Heating End Time = 07:00:00
```

**Via MCP (from VS Code):**
```javascript
// Query helper states
ha_get_states({
  domain: "input_datetime",
  search: "mh1"
})

// Expected result:
// - input_datetime.mh1_start_time: "22:00:00"
// - input_datetime.mh1_end_time: "07:00:00"
```

**If helpers still unavailable:**
1. Check `configuration.yaml` includes the file:
   ```yaml
   input_datetime: !include config/input_helpers/input_datetimes.yaml
   ```
2. Restart Home Assistant (not just reload)
3. Check logs for errors: `Developer Tools → Logs`

---

### Step 3: Deploy Updated Node-RED Flow

Import the updated flow that reads from the input helpers.

**Via Node-RED UI:**
1. Open Node-RED: `http://homeassistant.local:1880`
2. Click hamburger menu (☰) → Import
3. Select file: `nodered/flows/temperature-radiator-control.json`
4. Choose "Replace existing flows"
5. Click **Deploy** button (top right)

**Expected Result:**
- MH1 Control Logic node updated
- Status should show: `OUT schedule` (if outside 22:00-07:00)
- Reason should include actual schedule times

---

### Step 4: Test Schedule Configuration

Verify the schedule is working with the configured times.

**Test 1: Verify Schedule Reading**
```bash
# Check Node-RED logs (via UI):
# Should see schedule times in status/debug messages
# Example: "Outside schedule (09:45 not in 22:00-07:00)"
```

**Test 2: Change Schedule Times (Optional)**
```bash
# Via HA UI:
Settings → Devices & Services → Helpers
Click: "MH1 Heating Start Time"
Change: 21:00:00 (test earlier start)
Click: Save

# Via MCP:
ha_call_service({
  domain: "input_datetime",
  service: "set_datetime",
  target: {entity_id: "input_datetime.mh1_start_time"},
  service_data: {time: "21:00:00"}
})
```

**Test 3: Verify Schedule Change Takes Effect**
```bash
# Check Node-RED status
# Should now show: "Outside schedule (09:45 not in 21:00-07:00)"
# Schedule window should reflect new times
```

**Test 4: Tonight at Configured Start Time**
```bash
# Default: 22:00
# MH1 should turn ON if:
# ✅ Room temp < target temp
# ✅ Outside temp < 10°C
# ✅ Within schedule (22:00-07:00)
# ✅ Not manual override

# Check switch state:
ha_get_state({entity_id: "switch.mh1"})
# Expected: "on" (if conditions met)
```

**Test 5: Tomorrow at Configured End Time**
```bash
# Default: 07:00
# MH1 should turn OFF regardless of temperature
# Schedule enforcement takes priority

# Check switch state:
ha_get_state({entity_id: "switch.mh1"})
# Expected: "off"
```

---

## Usage Guide

### How to Change Heating Schedule

**Via Home Assistant UI:**
```
Settings → Devices & Services → Helpers
Search: "MH1"

Adjust times:
- MH1 Heating Start Time (default: 22:00)
- MH1 Heating End Time (default: 07:00)
```

**Via Dashboard:**
Your dashboards already have these helpers configured:
- `dashboards/power-management-professional.yaml` - Lines 370, 1050
- `dashboards/power-management-mobile.yaml` - Line 374
- `dashboards/settings-page.yaml` - Line 230

**Via Scripts/Automations:**
```yaml
# Example: Change schedule for weekend
service: input_datetime.set_datetime
target:
  entity_id: input_datetime.mh1_start_time
data:
  time: "20:00:00"  # Start 2 hours earlier on Friday
```

---

### Schedule Examples

**Night Heating (Default):**
```yaml
Start: 22:00
End: 07:00
→ Heats overnight, OFF during day
```

**All Day Heating:**
```yaml
Start: 00:00
End: 23:59
→ Heats 24/7 (based on temp thresholds)
```

**Evening Only:**
```yaml
Start: 18:00
End: 23:00
→ Heats 18:00-23:00, OFF rest of day
```

**Disabled (Never Heat):**
```yaml
Start: 00:00
End: 00:00
→ Never within schedule (always OFF)
```

**Note:** Schedule logic supports overnight ranges automatically!

---

## Schedule Logic Explained

### Priority Order (Top to Bottom)

1. **Manual Override** = ON
   - `input_boolean.mh1_manual_override` = ON
   - → Heat if `room_temp < target_temp`
   - → Ignores schedule and outside temp

2. **Outside Schedule Window**
   - Current time NOT in start-end range
   - → **ALWAYS OFF** (strict enforcement)
   - → No exceptions for low temperature

3. **Within Schedule - Outside Temp Check**
   - `outside_temp >= threshold` (default: 10°C)
   - → OFF (no heating needed)

4. **Within Schedule - Room Too Warm**
   - `room_temp >= max_temp` (default: 21°C)
   - → OFF

5. **Within Schedule - Room Too Cold**
   - `room_temp < min_temp` (default: 19°C)
   - → ON (priority heating)

6. **Within Schedule - Below Target**
   - `room_temp < target_temp - 0.5°C`
   - → ON (normal heating)

7. **Within Schedule - At Target**
   - `room_temp >= target_temp`
   - → OFF

8. **Within Schedule - Hysteresis Band**
   - `target_temp - 0.5°C < room_temp < target_temp`
   - → Maintain current state (prevent oscillation)

---

## Configuration Summary

### Input Helpers

| Entity | Type | Default | Description |
|--------|------|---------|-------------|
| `input_datetime.mh1_start_time` | Time | 22:00:00 | Schedule start |
| `input_datetime.mh1_end_time` | Time | 07:00:00 | Schedule end |
| `input_number.mh1_target_temp` | Number | 20°C | Target temperature |
| `input_number.mh1_min_room_temp` | Number | 19°C | Minimum room temp |
| `input_number.mh1_max_room_temp` | Number | 21°C | Maximum room temp |
| `input_number.mh1_outside_temp_threshold` | Number | 10°C | Outside temp limit |
| `input_boolean.mh1_manual_override` | Boolean | OFF | Manual control |

### Sensors Used

| Entity | Description |
|--------|-------------|
| `sensor.aqara_makuuhuone_temperature` | MH1 room temperature |
| `sensor.outside_temperature` | Outside temperature |

### Switch Controlled

| Entity | Description |
|--------|-------------|
| `switch.mh1` | Shelly 1PM Mini (radiator control) |

---

## Troubleshooting

### Input Datetime Helpers Show "unavailable"

**Symptoms:**
- `input_datetime.mh1_start_time` = unavailable
- `input_datetime.mh1_end_time` = unavailable
- Node-RED uses fallback times (22:00-07:00)

**Solutions:**
1. Check configuration file exists:
   ```bash
   cat config/input_helpers/input_datetimes.yaml | grep mh1
   ```
2. Verify `configuration.yaml` includes the file:
   ```yaml
   input_datetime: !include config/input_helpers/input_datetimes.yaml
   ```
3. Restart Home Assistant (not just reload)
4. Check logs: `Developer Tools → Logs`

---

### MH1 Heats Outside Configured Schedule

**Symptoms:**
- Schedule shows 22:00-07:00
- MH1 turns ON at 14:30

**Check:**
1. Manual override state:
   ```javascript
   ha_get_state({entity_id: "input_boolean.mh1_manual_override"})
   // Should be: "off"
   ```
2. Node-RED flow deployed?
   - Check flow timestamp in Node-RED UI
   - Should match latest git commit

3. Input datetime helpers available?
   ```javascript
   ha_get_states({domain: "input_datetime", search: "mh1"})
   // Both should show valid times, not "unavailable"
   ```

**Fix:**
- Turn off manual override
- Redeploy Node-RED flow
- Restart HA if helpers unavailable

---

### Schedule Times Don't Update in Node-RED

**Symptoms:**
- Changed `input_datetime.mh1_start_time` to 21:00
- Node-RED still shows 22:00 in logs

**Cause:**
Node-RED reads helper values on every temperature change trigger.

**Solutions:**
1. Wait for next temperature update (every few minutes)
2. Force temperature update:
   ```bash
   # Toggle another input to trigger flow
   ha_call_service({
     domain: "input_number",
     service: "set_value",
     target: {entity_id: "input_number.mh1_target_temp"},
     service_data: {value: 20}
   })
   ```
3. Restart Node-RED flow:
   - Node-RED UI → Deploy button → "Restart Flows"

---

### MH1 Doesn't Turn ON at Start Time

**Symptoms:**
- Time reaches 22:00
- All conditions met
- MH1 stays OFF

**Check Conditions:**
```javascript
// 1. Schedule active?
ha_get_state({entity_id: "input_datetime.mh1_start_time"})
// Should be: "22:00:00"

// 2. Room temperature?
ha_get_state({entity_id: "sensor.aqara_makuuhuone_temperature"})
// Should be: < target_temp (default: 20°C)

// 3. Outside temperature?
ha_get_state({entity_id: "sensor.outside_temperature"})
// Should be: < 10°C

// 4. Manual override?
ha_get_state({entity_id: "input_boolean.mh1_manual_override"})
// Should be: "off"

// 5. Switch available?
ha_get_state({entity_id: "switch.mh1"})
// Should be: "off" (not "unavailable")
```

**Node-RED Debug:**
1. Enable debug nodes in flow
2. Check Node-RED debug panel
3. Look for: `shouldHeat`, `withinSchedule`, `reason`

---

## Related Files

### Configuration Files
- `config/input_helpers/input_datetimes.yaml` - Input datetime helpers
- `config/input_helpers/input_numbers.yaml` - Temperature thresholds
- `config/input_helpers/input_booleans.yaml` - Manual override

### Node-RED Flows
- `nodered/flows/temperature-radiator-control.json` - Active flow
- `power-management/flows/temperature-radiator-control.json` - Backup

### Documentation
- `MH1_SCHEDULE_FIX.md` - Previous fix (hardcoded schedule)
- `MH1_CONFIGURABLE_SCHEDULE.md` - This document (configurable)

### Dashboards (Already Configured)
- `dashboards/power-management-professional.yaml`
- `dashboards/power-management-mobile.yaml`
- `dashboards/settings-page.yaml`
- `dashboards/magic-mirror-fullhd.yaml`
- `dashboards/nodered-flow-monitor.yaml`

---

## Benefits of Configurable Schedule

### Before (Hardcoded)
```javascript
const FIXED_START_HOUR = 22;
const FIXED_END_HOUR = 7;
// ❌ Required editing Node-RED flow
// ❌ Required redeploying flow
// ❌ No UI control
```

### After (Configurable)
```javascript
const startTimeStr = global.get('...mh1_start_time').state') || "22:00:00";
const endTimeStr = global.get('...mh1_end_time').state') || "07:00:00";
// ✅ Change from HA UI
// ✅ Change from dashboard
// ✅ Change from automations
// ✅ No Node-RED editing needed
// ✅ Fallback to safe defaults
```

---

## Next Steps

1. ✅ Input datetime helpers configured
2. ✅ Node-RED flow updated
3. ⏳ **Deploy to Home Assistant** (restart/reload)
4. ⏳ **Import updated Node-RED flow**
5. ⏳ **Verify helpers available**
6. ⏳ **Test schedule changes**
7. ⏳ **Monitor overnight (22:00-07:00)**

---

## Testing Checklist

- [ ] Input datetime helpers show valid times (not unavailable)
- [ ] `mh1_start_time` = 22:00:00
- [ ] `mh1_end_time` = 07:00:00
- [ ] Node-RED flow deployed successfully
- [ ] Node-RED status shows current schedule times
- [ ] Changed start time to 21:00 (test)
- [ ] Node-RED reflects new schedule (21:00-07:00)
- [ ] Reverted to 22:00 (default)
- [ ] MH1 stays OFF outside schedule (regardless of temp)
- [ ] MH1 turns ON tonight at 22:00 (if conditions met)
- [ ] MH1 turns OFF tomorrow at 07:00

---

## Summary

**Problem:** Schedule times hardcoded in Node-RED (22:00-07:00)
**Solution:** Read schedule from configurable input_datetime helpers
**Benefit:** Change schedule times from UI without editing flows

**Status:** Configuration ready, awaiting deployment!

**Created:** 2025-01-XX
**Last Updated:** 2025-01-XX
**Author:** GitHub Copilot + Toni Joronen
