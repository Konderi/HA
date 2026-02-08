# 🚨 Urgent Tesla Charging Location Fix

**Date:** February 8, 2026  
**Issue:** Node-RED flow was controlling Tesla charging regardless of car location  
**Status:** ✅ FIXED  
**Git Commit:** fc54097

---

## Problem Description

The Priority Load Balancer flow was preventing/reducing Tesla charging even when the car was charging away from home. This happened because the emergency and warning reduction functions only checked if the charger was "on" but didn't verify the car's location.

### Impact
- Car couldn't charge properly when away from home
- Flow would reduce or stop charging at public chargers/friend's house
- Created inconvenience when traveling

---

## Root Cause

Two functions in `priority-load-balancer.json` were missing location checks:

### 1. Emergency Load Reduction (Line ~222)
```javascript
// BEFORE (Wrong)
if (carCharging === 'on') {
    // Would stop/reduce charging regardless of location!
}
```

### 2. Warning Reduction (Line ~283)
```javascript
// BEFORE (Wrong)
if (carCharging === 'on' && currentAmps > 8) {
    // Would reduce charging regardless of location!
}
```

---

## Solution Applied

Added `carLocation` check to both functions using the device tracker:

```javascript
const carLocation = global.get('homeassistant.homeAssistant.states["device_tracker.tesla_model_3_location_tracker"].state');
```

### 1. Emergency Reduction - Fixed
```javascript
// AFTER (Correct)
if (carCharging === 'on' && carLocation === 'home') {
    // Only controls charging when car is AT HOME
    messages.push({ ... reduce charging ... });
}
```

### 2. Warning Reduction - Fixed
```javascript
// AFTER (Correct)
if (carCharging === 'on' && carLocation === 'home' && currentAmps > 8) {
    // Only reduces charging when car is AT HOME
    messages.push({ ... reduce charging ... });
}
```

---

## Files Modified

**File:** `power-management/flows/priority-load-balancer.json`

**Changes:**
- Line ~224: Added `carLocation` variable
- Line ~228: Added `&& carLocation === 'home'` check (emergency reduction)
- Line ~243: Added `&& carLocation === 'home'` check (sauna conflict)
- Line ~285: Added `carLocation` variable  
- Line ~290: Added `&& carLocation === 'home'` check (warning reduction)

**Total:** 2 insertions, 2 deletions

---

## How It Works Now

### Flow Logic with Location Check

```
┌─────────────────────────────────────────────┐
│  Power Capacity Check                      │
│  (Every 30 seconds)                        │
└────────────┬────────────────────────────────┘
             │
             ├─> >95% Critical
             │   └─> Emergency Reduction
             │       ├─> Check: Is car AT HOME? 
             │       │   ├─> YES: Reduce to 6A or OFF
             │       │   └─> NO: Don't touch!
             │       └─> Turn off boiler (always)
             │
             ├─> >85% Warning
             │   └─> Warning Reduction
             │       ├─> Check: Is car AT HOME?
             │       │   ├─> YES: Reduce by 2A
             │       │   └─> NO: Don't touch!
             │       └─> Monitor only
             │
             └─> <85% Normal
                 └─> Can increase charging (if home)
```

### Location States Recognized

The `device_tracker.tesla_model_3_location_tracker` entity returns:
- **`home`** - Car is at home → Flow CAN control charging
- **`not_home`** - Car is away → Flow WON'T touch charging
- **Other zones** - Specific location → Flow WON'T touch charging

---

## Testing Required

### ✅ Immediate Test (Do this now!)
1. Check device tracker state:
   ```
   device_tracker.tesla_model_3_location_tracker
   ```
   - Should show "not_home" if car is currently away
   
2. Start charging at current location
   
3. Monitor for 5 minutes:
   - Charging should NOT be interrupted
   - No "reducing charging" notifications
   - Amps should stay at set level

### 🏠 Test When Back Home
1. Plug in car at home
2. Wait for device tracker to update to "home"
3. Verify flow CAN control charging:
   - Load balancing works
   - Emergency reduction works if >95%
   - Warning reduction works if >85%

---

## Verification Checklist

- [x] Code changes committed and pushed
- [x] Both emergency and warning functions updated
- [x] Location check uses correct entity ID
- [x] Comments updated to reflect change
- [ ] Import updated flow to Node-RED
- [ ] Test charging away from home
- [ ] Test charging at home with load balancing
- [ ] Confirm no phantom notifications

---

## Deployment Steps

### 1. Import Updated Flow
```bash
# In Node-RED UI:
1. Open Hamburger menu → Import
2. Select file: priority-load-balancer.json
3. Choose "Overwrite existing nodes"
4. Click "Deploy"
```

### 2. Verify Import
Check that both functions show updated code:
- **Emergency Load Reduction** node: Open and verify `carLocation` check
- **Warning Reduction** node: Open and verify `carLocation` check

### 3. Monitor Flow
Watch Node-RED debug for next 30 minutes while charging away from home:
- Should see NO car-related actions
- Should see status: "Car not ready" or similar

---

## Related Entities

**Required Entities:**
- `device_tracker.tesla_model_3_location_tracker` - Car location
- `switch.tesla_model_3_charger` - Charger on/off
- `number.tesla_model_3_charging_amps` - Charging current
- `sensor.tesla_model_3_battery` - Battery level

**Location Logic:**
- Smart Car Charging Decision (line 356) - Already checks location ✅
- Normal Operation (line 262) - Doesn't need check (only increases) ✅
- Emergency Reduction (line 222) - NOW checks location ✅
- Warning Reduction (line 283) - NOW checks location ✅

---

## Git History

```bash
fc54097 - URGENT FIX: Only control Tesla charging when car is at home
e08668c - Improve gauge coloring in magic mirror dashboard
3ea8b87 - Improve gauge coloring in mobile dashboard
8317fd1 - Improve gauge coloring in professional dashboard
```

---

## Summary

**Problem:** Flow controlled Tesla charging even when car was away from home  
**Fix:** Added location checks to emergency and warning reduction functions  
**Result:** Flow now ONLY controls charging when `device_tracker` shows `home`  
**Action Required:** Import updated flow to Node-RED and deploy  

⚠️ **CRITICAL:** Import this flow immediately if car is currently charging away from home!

---

## Support

If you experience continued issues:
1. Check device tracker state in Home Assistant
2. Verify entity ID matches: `device_tracker.tesla_model_3_location_tracker`
3. Check Node-RED debug logs for location checks
4. Ensure flow was properly deployed after import

**Expected behavior now:**
- ✅ Car charges normally when away from home
- ✅ Flow controls charging when car is at home
- ✅ Load balancing works properly at home
- ✅ No interference with away-from-home charging
