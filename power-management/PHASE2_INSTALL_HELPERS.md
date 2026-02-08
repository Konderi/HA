# 🔧 Phase 2 Helper Installation Guide

## Overview

Phase 2 requires **7 helper entities** for intelligent power management. This guide shows you how to add them to your existing configuration.

---

## ⚠️ Important: You Have Existing input_datetime Helpers

Your `configuration.yaml` already has this section:
```yaml
input_datetime:
  device_start_time:
    name: Start Time
    has_date: false
    has_time: true
    initial: "02:00"
  
  device_end_time:
    name: End Time
    has_date: false
    has_time: true
    initial: "06:00"
  
  electric_trigger_point:
    name: electric_trigger_point
    has_date: false
    has_time: true
```

You need to **ADD** 2 new entries (mh1_start_time, mh1_end_time) to this existing section.

---

## 📝 Method 1: Edit configuration.yaml Directly (Recommended)

### Step 1: Backup Configuration
```bash
# In VS Code Server terminal
cp /config/configuration.yaml /config/configuration.yaml.backup
```

### Step 2: Add Helper Entities

Open `/config/configuration.yaml` in VS Code Server and add these sections:

#### A) ADD to existing input_datetime section:

Find this section (around line 46):
```yaml
input_datetime:
  device_start_time:
    name: Start Time
    has_date: false
    has_time: true
    initial: "02:00"
  
  device_end_time:
    name: End Time
    has_date: false
    has_time: true
    initial: "06:00"
  
  electric_trigger_point:
    name: electric_trigger_point
    has_date: false
    has_time: true
```

Add these TWO entries at the end:
```yaml
  # PHASE 2: Master bedroom heating schedule
  mh1_start_time:
    name: MH1 Heating Start Time
    has_date: false
    has_time: true
    initial: "22:00:00"
    icon: mdi:clock-start
  
  mh1_end_time:
    name: MH1 Heating End Time
    has_date: false
    has_time: true
    initial: "07:00:00"
    icon: mdi:clock-end
```

**Final result should look like:**
```yaml
input_datetime:
  device_start_time:
    name: Start Time
    has_date: false
    has_time: true
    initial: "02:00"
  
  device_end_time:
    name: End Time
    has_date: false
    has_time: true
    initial: "06:00"
  
  electric_trigger_point:
    name: electric_trigger_point
    has_date: false
    has_time: true
  
  # PHASE 2: Master bedroom heating schedule
  mh1_start_time:
    name: MH1 Heating Start Time
    has_date: false
    has_time: true
    initial: "22:00:00"
    icon: mdi:clock-start
  
  mh1_end_time:
    name: MH1 Heating End Time
    has_date: false
    has_time: true
    initial: "07:00:00"
    icon: mdi:clock-end
```

#### B) ADD new input_boolean section:

Add this **new section** anywhere in configuration.yaml (after input_datetime is good):
```yaml
# ============================================================================
# PHASE 2: TOGGLE HELPERS
# ============================================================================
input_boolean:
  kids_home:
    name: Kids at Home
    initial: true
    icon: mdi:home-account
  
  mh1_manual_override:
    name: MH1 Manual Override
    initial: false
    icon: mdi:radiator
```

#### C) ADD new input_number section:

Add this **new section** after input_boolean:
```yaml
# ============================================================================
# PHASE 2: TEMPERATURE HELPERS
# ============================================================================
input_number:
  mh1_target_temp:
    name: MH1 Target Temperature
    min: 18
    max: 24
    step: 0.5
    initial: 20
    unit_of_measurement: "°C"
    icon: mdi:thermometer
  
  kids_rooms_min_temp:
    name: Kids Rooms Minimum Temperature
    min: 16
    max: 20
    step: 0.5
    initial: 18
    unit_of_measurement: "°C"
    icon: mdi:thermometer-low
  
  kids_rooms_target_temp:
    name: Kids Rooms Target Temperature
    min: 18
    max: 22
    step: 0.5
    initial: 19
    unit_of_measurement: "°C"
    icon: mdi:thermometer
```

### Step 3: Check Configuration
1. Developer Tools → YAML tab
2. Click "Check Configuration"
3. Should show: ✅ "Configuration valid!"

### Step 4: Restart Home Assistant
Settings → System → Restart

### Step 5: Verify Helpers
After restart:
1. Settings → Devices & Services → Helpers
2. Search for "kids" → Should see `Kids at Home`
3. Search for "mh1" → Should see 4 MH1 helpers
4. Should see total **7 new helpers**

---

## 📝 Method 2: Use Separate File (Alternative)

If you prefer to keep helpers in a separate file:

### Step 1: Create Helper File

In VS Code Server, create new file:
`/config/power-management/phase2_helpers.yaml`

Copy contents from `phase2_helpers_include.yaml` (the file I just created).

### Step 2: Modify Configuration.yaml

Open `/config/configuration.yaml` and change:

**FROM:**
```yaml
input_datetime:
  device_start_time:
    name: Start Time
    has_date: false
    has_time: true
    initial: "02:00"
  
  device_end_time:
    name: End Time
    has_date: false
    has_time: true
    initial: "06:00"
  
  electric_trigger_point:
    name: electric_trigger_point
    has_date: false
    has_time: true
```

**TO:**
```yaml
input_datetime: !include_dir_merge_named power-management/phase2_helpers/
```

But this requires restructuring your existing helpers to separate files too, which is more complex.

**Recommendation: Use Method 1** (edit configuration.yaml directly)

---

## ✅ Verification Checklist

After deployment, verify these 7 helpers exist:

### Schedule Helpers (2):
- [ ] `input_datetime.mh1_start_time` - "MH1 Heating Start Time"
- [ ] `input_datetime.mh1_end_time` - "MH1 Heating End Time"

### Toggle Helpers (2):
- [ ] `input_boolean.kids_home` - "Kids at Home"
- [ ] `input_boolean.mh1_manual_override` - "MH1 Manual Override"

### Temperature Helpers (3):
- [ ] `input_number.mh1_target_temp` - "MH1 Target Temperature"
- [ ] `input_number.kids_rooms_min_temp` - "Kids Rooms Minimum Temperature"
- [ ] `input_number.kids_rooms_target_temp` - "Kids Rooms Target Temperature"

**Check in:** Settings → Devices & Services → Helpers

---

## 🚨 Troubleshooting

### "Configuration invalid" error?
- Check YAML indentation (use spaces, not tabs)
- Verify all colons have space after them
- Make sure input_boolean and input_number are NEW sections (not nested inside something else)

### Helpers not appearing?
- Clear browser cache (Cmd+Shift+R)
- Wait 2-3 minutes after restart
- Check Developer Tools → States for entities starting with "input_"

### Duplicate key error?
- You may have input_boolean or input_number defined elsewhere
- Search configuration.yaml for these keywords
- Merge the sections together

---

## ⏭️ What's Next?

Once helpers are installed and verified:

1. ✅ Continue to **PHASE2_DEPLOY_NOW.md**
2. Import Node-RED flows (Step 2)
3. Add dashboard card (Step 4)
4. Test everything (Step 5)

---

## 📋 Quick Copy-Paste Reference

### Add to input_datetime (after electric_trigger_point):
```yaml
  mh1_start_time:
    name: MH1 Heating Start Time
    has_date: false
    has_time: true
    initial: "22:00:00"
    icon: mdi:clock-start
  
  mh1_end_time:
    name: MH1 Heating End Time
    has_date: false
    has_time: true
    initial: "07:00:00"
    icon: mdi:clock-end
```

### Add as new section (input_boolean):
```yaml
input_boolean:
  kids_home:
    name: Kids at Home
    initial: true
    icon: mdi:home-account
  
  mh1_manual_override:
    name: MH1 Manual Override
    initial: false
    icon: mdi:radiator
```

### Add as new section (input_number):
```yaml
input_number:
  mh1_target_temp:
    name: MH1 Target Temperature
    min: 18
    max: 24
    step: 0.5
    initial: 20
    unit_of_measurement: "°C"
    icon: mdi:thermometer
  
  kids_rooms_min_temp:
    name: Kids Rooms Minimum Temperature
    min: 16
    max: 20
    step: 0.5
    initial: 18
    unit_of_measurement: "°C"
    icon: mdi:thermometer-low
  
  kids_rooms_target_temp:
    name: Kids Rooms Target Temperature
    min: 18
    max: 22
    step: 0.5
    initial: 19
    unit_of_measurement: "°C"
    icon: mdi:thermometer
```

**Remember to check indentation carefully!** Each section should align properly with existing sections in your configuration.yaml.
