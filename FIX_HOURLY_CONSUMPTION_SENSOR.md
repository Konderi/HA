# 🔧 Fix Hourly Consumption Sensor - Deployment Guide

**Date:** 2026-02-14  
**Issue:** `sensor.talon_kokonaiskulutus_tunti_kwh` showing "0" - hourly consumption not working  
**Root Cause:** Source sensor `sensor.sahkon_kokonaisenergia` not loaded in configuration

---

## 🎯 Quick Summary

The template sensor file **already exists** but is not being included in your Home Assistant configuration.

**File location:** `config/sensors/total_energy_sensor.yaml`  
**Action needed:** Add it to your `/config/configuration.yaml` on Home Assistant server

---

## 📋 Deployment Steps

### Step 1: Copy Sensor File to Home Assistant

```bash
# SSH to Home Assistant
ssh root@homeassistant

# Create sensors directory if it doesn't exist
mkdir -p /config/sensors

# Exit SSH
exit
```

```bash
# Copy the sensor file from your Git repo to Home Assistant
scp config/sensors/total_energy_sensor.yaml root@homeassistant:/config/sensors/
```

### Step 2: Update configuration.yaml

**SSH back to Home Assistant:**
```bash
ssh root@homeassistant
```

**Edit configuration.yaml:**
```bash
nano /config/configuration.yaml
```

**Add this line** (if you DON'T already have a `template:` section):
```yaml
# Total energy sensor (sum of 3 phases)
template: !include sensors/total_energy_sensor.yaml
```

**OR, if you ALREADY have a `template:` section**, you need to merge the files:

**Option A - Include directory (recommended if you have multiple template files):**
```yaml
template: !include_dir_merge_list sensors/
```

**Option B - Merge manually:**
Keep your existing template section and add the sensor definition from `total_energy_sensor.yaml` into it.

**Save the file:**
- Press `Ctrl+X`
- Press `Y` to confirm
- Press `Enter` to save

### Step 3: Validate Configuration

```bash
ha core check
```

**Expected output:**
```
Configuration valid!
```

**If you get errors:**
- Check indentation (YAML is space-sensitive, use 2 spaces)
- Make sure the file path is correct
- Verify the template sensor file was copied correctly

### Step 4: Restart Home Assistant

**From SSH:**
```bash
ha core restart
```

**OR from the UI:**
- Settings → System → Restart

**Wait 2-3 minutes** for Home Assistant to fully restart.

---

## ✅ Verification

### Immediate (After Restart)

**1. Check Developer Tools → States:**
```
Search for: sahkon_kokonaisenergia
```

**Expected result:**
```
sensor.sahkon_kokonaisenergia = 64,645.95 kWh (or similar large number)
```

If it shows "unavailable", check that these sensors exist:
- `sensor.shellyem3_channel_a_energy`
- `sensor.shellyem3_channel_b_energy`
- `sensor.shellyem3_channel_c_energy`

### After 1 Hour

**Check utility meter sensors:**
```
sensor.talon_kokonaiskulutus_tunti_kwh = 1-5 kWh (should be > 0)
```

### After 24 Hours

```
sensor.talon_kokonaiskulutus_paiva_kwh = 40-80 kWh (typical daily consumption)
```

---

## 📊 What Gets Fixed

Once deployed, these sensors will start working:

✅ **Hourly:** `sensor.talon_kokonaiskulutus_tunti_kwh`  
✅ **Daily:** `sensor.talon_kokonaiskulutus_paiva_kwh`  
✅ **Weekly:** `sensor.talon_kokonaiskulutus_viikko_kwh`  
✅ **Monthly:** `sensor.talon_kokonaiskulutus_kuukausi_kwh` (already working)  
✅ **Yearly:** `sensor.talon_kokonaiskulutus_vuosi_kwh` (already working)

### Dashboard Impact

✅ **Professional Dashboard:**
- Line 107: Hourly consumption chart will show data
- Line 39: Daily consumption gauge will work

✅ **Mobile Dashboard:**
- Lines 225, 497: Hourly consumption displays fixed
- Lines 438, 813: Daily consumption displays fixed

✅ **Magic Mirror Dashboard:**
- Line 183: Hourly data will populate

---

## 🔍 Technical Details

### The Source Sensor

**Name:** `sensor.sahkon_kokonaisenergia`  
**Purpose:** Sums all 3 phases from ShellyEM3 power meter  
**Formula:** `Channel A + Channel B + Channel C`

**Example calculation:**
```
Channel A: 28,199.00 kWh
Channel B: 18,297.55 kWh
Channel C: 18,149.39 kWh
─────────────────────
Total:     64,645.94 kWh
```

### Utility Meter Configuration

The utility meters are configured in your `/config/configuration.yaml` or `utility_meter.yaml`:

```yaml
utility_meter:
  talon_kokonaiskulutus_tunti:
    source: sensor.sahkon_kokonaisenergia  # ← This sensor must exist!
    cycle: hourly
    name: "Talon kokonaiskulutus, tunti"
```

**How it works:**
1. Utility meter tracks the SOURCE sensor value
2. Resets every hour/day/week/month/year (based on cycle)
3. Shows the DIFFERENCE (consumption) during that period

**Why it was broken:**
- Source sensor (`sensor.sahkon_kokonaisenergia`) was "unavailable"
- Utility meter had no valid data to track
- All derived sensors showed "0"

---

## 🚨 Troubleshooting

### Problem: sensor.sahkon_kokonaisenergia shows "unavailable"

**Check ShellyEM3 sensors:**
```bash
# In Developer Tools → Template, paste this:
{{ states('sensor.shellyem3_channel_a_energy') }}
{{ states('sensor.shellyem3_channel_b_energy') }}
{{ states('sensor.shellyem3_channel_c_energy') }}
```

All three should show kWh values. If any show "unavailable":
- Check ShellyEM3 device is online
- Check integration is working
- Restart ShellyEM3 device if needed

### Problem: Configuration check fails

**Common issues:**
1. **Indentation errors** - YAML requires exact spacing
2. **File path wrong** - Make sure file is in `/config/sensors/`
3. **Duplicate `template:` sections** - Merge them into one

**View errors:**
```bash
ha core info
# Look for configuration errors in the log
```

### Problem: Still showing "0" after restart

**Wait 1-2 hours** - utility meters collect data over time:
- Hourly meter: Updates every hour
- Daily meter: Updates every day

**Force update:**
```bash
# In Developer Tools → States, find the utility_meter entity
# Click on it and check "Last Reset" time
# If it hasn't reset since restart, wait for the next cycle
```

---

## 💡 Prevention

### Monitor Sensor Health

Add this automation to get notified if the sensor breaks again:

```yaml
automation:
  - alias: "Alert: Total Energy Sensor Unavailable"
    trigger:
      - platform: state
        entity_id: sensor.sahkon_kokonaisenergia
        to: 'unavailable'
        for: "00:05:00"
    action:
      - service: notify.mobile_app_iphone17
        data:
          title: "⚠️ Energy Sensor Unavailable"
          message: "sensor.sahkon_kokonaisenergia is unavailable. Utility meters will stop working!"
```

### Regular Checks

Every month, verify these sensors show expected values:
- `sensor.sahkon_kokonaisenergia` - Should be ~64k+ kWh (always increasing)
- `sensor.talon_kokonaiskulutus_paiva_kwh` - Should be 40-80 kWh daily
- `sensor.talon_kokonaiskulutus_kuukausi_kwh` - Should be 600-2000 kWh monthly

---

## 📚 Related Files

- **Sensor definition:** `config/sensors/total_energy_sensor.yaml`
- **Previous fix guide:** `SENSOR_FIX_REQUIRED.md`
- **Utility meter config:** Check your `configuration.yaml` or `utility_meter.yaml`
- **Deployment script:** `fix_sensor.sh` (automated version)

---

## 🎉 Success Criteria

✅ `sensor.sahkon_kokonaisenergia` shows ~64,645 kWh  
✅ `sensor.talon_kokonaiskulutus_tunti_kwh` > 0 (after 1 hour)  
✅ `sensor.talon_kokonaiskulutus_paiva_kwh` > 0 (after 24 hours)  
✅ Dashboard charts show consumption data  
✅ No errors in Home Assistant logs

---

**Need help? Check the error logs:**
```bash
ha core logs
```

**Or view in UI:**
Settings → System → Logs → Filter for "sensor.sahkon_kokonaisenergia"
