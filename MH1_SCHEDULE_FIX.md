# 🔧 MH1 Radiator Schedule Fix

**Date:** 2026-02-09  
**Issue:** MH1 radiator was heating outside of scheduled hours

---

## 🔍 Problem Identified

**MH1 radiator (switch.mh1) was ON at 09:18** when it should only heat during **22:00 - 07:00**.

### Root Cause
The Node-RED flow logic had a **"safety heating" clause** that allowed heating below minimum temperature **regardless of schedule**:

```javascript
// OLD LOGIC (WRONG):
else if (currentTemp < minRoomTemp) {
    // Below minimum - heat regardless of schedule (safety)  ← THIS WAS THE PROBLEM
    shouldHeat = true;
    reason = `Room ${currentTemp}°C < min ${minRoomTemp}°C - safety heating`;
}
```

This meant if the room dropped below the minimum temperature, it would heat **even outside the 22:00-07:00 window**.

### Additional Issues
- Input datetimes (`input_datetime.mh1_start_time`, `input_datetime.mh1_end_time`) were unavailable
- The flow was trying to read unavailable datetime helpers, causing logic errors

---

## ✅ Solution Applied

### 1. Fixed Node-RED Logic
Updated **TWO files** (both need to stay in sync):
- `nodered/flows/temperature-radiator-control.json`
- `power-management/flows/temperature-radiator-control.json`

### Key Changes

**Removed dependencies on input_datetime helpers:**
```javascript
// BEFORE:
const startTime = global.get('homeassistant.homeAssistant.states["input_datetime.mh1_start_time"].state');
const endTime = global.get('homeassistant.homeAssistant.states["input_datetime.mh1_end_time"].state');

// AFTER:
// FIXED SCHEDULE: 22:00 - 07:00 ONLY
const FIXED_START_HOUR = 22;
const FIXED_END_HOUR = 7;
```

**Enforced STRICT schedule checking:**
```javascript
// NEW LOGIC - Schedule check is FIRST priority (after manual override)
if (manualOverride) {
    // Manual override bypasses all checks
    shouldHeat = currentTemp < targetTemp;
} else if (!withinSchedule) {
    // ALWAYS OFF outside 22:00-07:00 window
    shouldHeat = false;
    reason = `Outside schedule (${currentHour}:${currentMinute} not in 22:00-07:00)`;
} else if (currentTemp < minRoomTemp) {
    // Within schedule AND below minimum - heat
    shouldHeat = true;
    reason = `Room ${currentTemp}°C < min ${minRoomTemp}°C`;
}
// ... other checks
```

**Added schedule status to debug output:**
```javascript
node.status({
    fill: shouldHeat ? 'green' : 'grey',
    shape: 'dot',
    text: `${currentTemp}°C | ${reason} | ${withinSchedule ? 'IN' : 'OUT'} schedule`
});
```

### 2. Immediately Turned Off MH1
Used Home Assistant MCP to turn off the radiator:
```
switch.turn_off(entity_id: "switch.mh1")
```
✅ **Status:** MH1 is now OFF

---

## 📋 How It Works Now

### Heating Logic Priority (in order):

1. **Manual Override** - If enabled, heats to target temp (bypasses all other checks)
2. **Schedule Check** - If outside 22:00-07:00, **ALWAYS OFF** (no exceptions)
3. **Within Schedule:**
   - Check outside temp threshold (if too warm outside, no heating)
   - Check max room temp (if room too warm, no heating)
   - Check min room temp (if below min, heat)
   - Check target temp with hysteresis (heat if below target -0.5°C)

### Schedule Definition
- **Start:** 22:00 (10 PM)
- **End:** 07:00 (7 AM)
- **Logic:** `(currentHour >= 22 || currentHour < 7)`
- **Covers:** 22:00, 23:00, 00:00, 01:00, 02:00, 03:00, 04:00, 05:00, 06:00

### Temperature Thresholds
These still apply **within schedule**:
- **Min Room Temp:** 19°C (from `input_number.mh1_min_room_temp`)
- **Max Room Temp:** 21°C (from `input_number.mh1_max_room_temp`)
- **Target Temp:** Adjustable (from `input_number.mh1_target_temp`)
- **Outside Temp Threshold:** 10°C (from `input_number.mh1_outside_temp_threshold`)

---

## 🚀 Deployment Steps

### Option 1: Update Node-RED Flow via UI
1. Open Node-RED: `http://homeassistant.local:1880`
2. Click **Menu (☰)** → **Import**
3. Select file: `nodered/flows/temperature-radiator-control.json`
4. **Replace existing flow** when prompted
5. Click **Deploy**

### Option 2: Copy File to Home Assistant
```bash
# Copy updated flow to Home Assistant
scp nodered/flows/temperature-radiator-control.json root@homeassistant:/config/node-red/flows/

# Restart Node-RED
# In HA: Settings → Add-ons → Node-RED → Restart
```

### Option 3: Manual Edit in Node-RED
1. Open Node-RED
2. Find **"MH1 Control Logic"** function node
3. Double-click to edit
4. Replace the function code with the new logic
5. Click **Done** → **Deploy**

---

## ✅ Verification

### Immediate Check
1. **Current time:** 09:18 (outside schedule)
2. **Expected:** MH1 should be OFF ✅ (Done manually)
3. **Node-RED status:** Should show "OUT schedule"

### Tonight at 22:00
1. MH1 should turn ON (if room temp < target)
2. Node-RED status should show "IN schedule"

### Tomorrow at 07:00
1. MH1 should turn OFF automatically
2. Node-RED status should show "OUT schedule"

### Debug in Node-RED
1. Open flow
2. Check "MH1 Control Logic" node status text
3. Should show: `[Temp]°C | [Reason] | OUT schedule`

---

## 🛡️ Manual Override

The manual override still works:
- Enable: `input_boolean.mh1_manual_override` = ON
- When active: MH1 will heat to target temperature **regardless of schedule**
- Use case: Cold night, need extra heating outside normal hours

---

## 🔍 Other Rooms

You may want to check if **Tuomas and Sara** rooms have similar issues:

### Search for similar patterns:
```bash
grep -n "safety heating" nodered/flows/temperature-radiator-control.json
```

If found, they need the same fix (schedule enforcement before min temp check).

---

## 📊 Expected Behavior

### Example Timeline for Tonight:

| Time | Status | Reason |
|------|--------|--------|
| 09:00-22:00 | OFF | Outside schedule |
| 22:00 | ON | In schedule, temp < target |
| 23:30 | ON | In schedule, heating to target |
| 02:00 | OFF | In schedule, reached target |
| 04:00 | ON | In schedule, temp dropped |
| 07:00 | OFF | Outside schedule (automatic) |
| 07:00-22:00 | OFF | Outside schedule |

---

## 🐛 Troubleshooting

### MH1 Still Heating Outside Schedule
1. Check Node-RED is deployed (red "Deploy" button = not deployed)
2. Check manual override is OFF: `input_boolean.mh1_manual_override`
3. Check Node-RED logs for errors
4. Verify flow is running (inject timestamp manually)

### MH1 Not Heating During Schedule
1. Check room temp vs target temp
2. Check outside temp threshold
3. Check max room temp setting
4. Enable manual override to test radiator

### Flow Not Triggering
1. Check temperature sensor is updating
2. Verify flow has temperature sensor configured correctly
3. Check Home Assistant connection in Node-RED

---

## 📝 Files Modified

1. ✅ `nodered/flows/temperature-radiator-control.json` - Deployed version
2. ✅ `power-management/flows/temperature-radiator-control.json` - Backup copy
3. ✅ Turned off `switch.mh1` immediately via HA API

---

## 🎯 Next Steps

1. **Deploy the updated flow** to Node-RED (see options above)
2. **Monitor tonight** (22:00) - verify MH1 turns ON
3. **Monitor tomorrow morning** (07:00) - verify MH1 turns OFF
4. **Check other rooms** (Tuomas, Sara) for similar issues
5. **Consider removing** unavailable `input_datetime` helpers if not needed

---

**Status:** 🟢 **Fixed and Ready for Deployment**  
**Priority:** 🔥 **HIGH** - Deploy before tonight's heating cycle  
**Complexity:** ⭐⭐ **MEDIUM** - Requires Node-RED update

**Estimated Deployment Time:** 5 minutes

---

## 💡 Lessons Learned

1. **Safety overrides** should respect schedules
2. **Fixed schedules** more reliable than datetime helpers
3. **Schedule enforcement** must be a top priority in logic
4. **Debug status text** should show schedule status

This fix ensures MH1 **ONLY** heats during 22:00-07:00, with no exceptions (except manual override).
