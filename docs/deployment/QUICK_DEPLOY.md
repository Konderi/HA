# 🚀 Quick Deployment Steps
**Updated:** 2026-02-09  

---

## Step 1: Deploy Input Helpers (2 minutes)

**Copy updated files to Home Assistant:**
```bash
scp power-management/input_booleans.yaml root@homeassistant:/config/power-management/
scp power-management/input_numbers.yaml root@homeassistant:/config/power-management/
```

**Then reload:**
- Developer Tools → YAML → "Input helpers"

**Verify:** Settings → Helpers - should see 5 new entities

---

## Step 2: Import Node-RED Flows (10 minutes)

1. Open Node-RED: `http://homeassistant.local:1880`
2. Menu → Import
3. Import all 9 files from `power-management/flows/`
4. Choose "Replace existing flows" for each
5. Click "Deploy"

**Verify:** No red triangles, debug panel shows no errors

---

## Step 3: Done! ✅

All flows should be working immediately!

**Notes:**
- Tesla sensors may show "unavailable" when car sleeps - **normal**
- Sauna sensor shows "unknown" when off - **normal**
- Both will update when devices become active

---

**Files updated in this commit:**
- ✅ `input_booleans.yaml` - Added kids_home, mh1_manual_override
- ✅ `input_numbers.yaml` - Added mh1_target_temp, kids_rooms_min/target_temp
- ✅ All 9 Node-RED flows validated and ready
