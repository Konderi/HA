# ✅ Hourly Consumption Sensor - Deployment Checklist

Use this checklist to track your deployment progress.

---

## 📋 Pre-Deployment Checks

- [ ] Git repository is up to date
- [ ] Can SSH to Home Assistant: `ssh root@homeassistant`
- [ ] Have access to Home Assistant UI
- [ ] Know your current electricity consumption (to verify fix)

**Current Status Check:**
```
Developer Tools → States → Search for these:
```

- [ ] `sensor.shellyem3_channel_a_energy` = ______ kWh (should show value)
- [ ] `sensor.shellyem3_channel_b_energy` = ______ kWh (should show value)
- [ ] `sensor.shellyem3_channel_c_energy` = ______ kWh (should show value)
- [ ] `sensor.sahkon_kokonaisenergia` = ______ (probably "unavailable")
- [ ] `sensor.talon_kokonaiskulutus_tunti_kwh` = ______ (probably "0")

---

## 🚀 Deployment Steps

### Method 1: Automated Script (Recommended)

- [ ] Make script executable: `chmod +x deploy_hourly_sensor_fix.sh`
- [ ] Run script: `./deploy_hourly_sensor_fix.sh`
- [ ] Script completed without errors
- [ ] Configuration validation passed
- [ ] Home Assistant restarted

**If script found existing template section:**
- [ ] Reviewed current template configuration
- [ ] Decided on merge approach:
  - [ ] Option A: Change to `!include_dir_merge_list sensors/`
  - [ ] Option B: Merge manually into existing templates file
- [ ] Made the changes manually
- [ ] Ran `ha core check` - passed
- [ ] Ran `ha core restart`

### Method 2: Manual Deployment

**Step 1: Copy Sensor File**
- [ ] Created directory: `ssh root@homeassistant 'mkdir -p /config/sensors'`
- [ ] Copied file: `scp config/sensors/total_energy_sensor.yaml root@homeassistant:/config/sensors/`
- [ ] Verified file exists: `ssh root@homeassistant 'ls -la /config/sensors/total_energy_sensor.yaml'`

**Step 2: Backup Configuration**
- [ ] Created backup: `ssh root@homeassistant 'cp /config/configuration.yaml /config/configuration.yaml.backup'`
- [ ] Verified backup exists: `ssh root@homeassistant 'ls -la /config/configuration.yaml.backup'`

**Step 3: Update configuration.yaml**
- [ ] SSH to Home Assistant: `ssh root@homeassistant`
- [ ] Edited file: `nano /config/configuration.yaml`
- [ ] Added line: `template: !include sensors/total_energy_sensor.yaml`
  - [ ] OR merged with existing template section
- [ ] Saved file (Ctrl+X, Y, Enter)
- [ ] Exit SSH: `exit`

**Step 4: Validate Configuration**
- [ ] Ran: `ssh root@homeassistant 'ha core check'`
- [ ] Output showed: "Configuration valid!"

**Step 5: Restart Home Assistant**
- [ ] Ran: `ssh root@homeassistant 'ha core restart'`
- [ ] OR restarted via UI: Settings → System → Restart
- [ ] Waited 2-3 minutes for restart to complete

---

## ✅ Post-Deployment Verification

### Immediate Checks (Right After Restart)

**Check 1: Source Sensor Available**
- [ ] Opened: Developer Tools → States
- [ ] Searched for: `sahkon_kokonaisenergia`
- [ ] Status: Available (not "unavailable")
- [ ] Value: ______ kWh (should be ~64,000-65,000 kWh)
- [ ] **Expected:** ~64,645 kWh

**Check 2: Sensor Attributes**
- [ ] Click on `sensor.sahkon_kokonaisenergia`
- [ ] Verify attributes show:
  - [ ] `phase_a_kwh`: ______ kWh
  - [ ] `phase_b_kwh`: ______ kWh
  - [ ] `phase_c_kwh`: ______ kWh
  - [ ] `last_updated`: Recent timestamp

**Check 3: Utility Meter Status**
- [ ] Searched for: `talon_kokonaiskulutus_tunti_kwh`
- [ ] Status: Available (not "unavailable")
- [ ] Value: ______ kWh (may still be "0" - this is OK)
- [ ] Attributes → `status`: "collecting" or "paused"
- [ ] Attributes → `source`: "sensor.sahkon_kokonaisenergia"

**Check 4: No Errors in Logs**
- [ ] Settings → System → Logs
- [ ] Filter for: "sahkon_kokonaisenergia"
- [ ] No ERROR level messages
- [ ] No WARNING about unavailable sensor

### 1-Hour Checks

**Wait at least 1 hour after restart**, then check:

- [ ] `sensor.talon_kokonaiskulutus_tunti_kwh` = ______ kWh
- [ ] **Expected:** 1-5 kWh (should be > 0)
- [ ] If still showing "0", check:
  - [ ] Utility meter `next_reset` time has passed
  - [ ] Source sensor is still available
  - [ ] ShellyEM3 is reporting consumption (channels changing)

### 24-Hour Checks

**Wait at least 24 hours**, then check:

- [ ] `sensor.talon_kokonaiskulutus_paiva_kwh` = ______ kWh
- [ ] **Expected:** 40-80 kWh (typical daily consumption)
- [ ] Value matches your expected daily use

### Dashboard Verification

**Professional Dashboard:**
- [ ] Opened: dashboards/power-management-professional.yaml
- [ ] Line 107: Hourly consumption chart shows data
- [ ] Line 39: Daily consumption gauge works
- [ ] Line 729: Monthly consumption still displays correctly

**Mobile Dashboard:**
- [ ] Opened: dashboards/power-management-mobile.yaml
- [ ] Lines 225, 497: Hourly displays show values > 0
- [ ] Lines 438, 813: Daily displays show expected values

**Magic Mirror Dashboard:**
- [ ] Opened: dashboards/magic-mirror-fullhd.yaml
- [ ] Line 183: Hourly consumption populated

---

## 🔍 Troubleshooting Checklist

**Problem: sensor.sahkon_kokonaisenergia still "unavailable"**

- [ ] Verified all 3 ShellyEM3 channel sensors are available:
  - [ ] `sensor.shellyem3_channel_a_energy` = Available
  - [ ] `sensor.shellyem3_channel_b_energy` = Available
  - [ ] `sensor.shellyem3_channel_c_energy` = Available
- [ ] If any unavailable:
  - [ ] Checked ShellyEM3 device is online
  - [ ] Restarted ShellyEM3 device
  - [ ] Checked Home Assistant ShellyEM3 integration

**Problem: Configuration check failed**

- [ ] Checked YAML indentation (must use 2 spaces, not tabs)
- [ ] Verified file path: `/config/sensors/total_energy_sensor.yaml` exists
- [ ] Checked for duplicate `template:` sections in configuration.yaml
- [ ] Viewed error details: `ssh root@homeassistant 'ha core info'`
- [ ] If needed, restored backup: `ssh root@homeassistant 'cp /config/configuration.yaml.backup /config/configuration.yaml'`

**Problem: Utility meter still showing "0" after 1+ hours**

- [ ] Verified source sensor has valid data
- [ ] Checked utility meter reset schedule:
  - [ ] Developer Tools → States → `sensor.talon_kokonaiskulutus_tunti_kwh`
  - [ ] Attributes → `last_reset`
  - [ ] Attributes → `next_reset`
- [ ] Waited for next reset time to pass
- [ ] Verified ShellyEM3 values are actually changing (consumption happening)

**Problem: Dashboard charts still empty**

- [ ] Waited full reset cycle (1 hour for hourly, 24 hours for daily)
- [ ] Cleared browser cache
- [ ] Force-refreshed dashboard (Ctrl+Shift+R)
- [ ] Checked ApexCharts card configuration uses correct entity IDs

---

## 📊 Success Criteria

All must be checked for complete success:

**Immediate (after restart):**
- [ ] ✅ `sensor.sahkon_kokonaisenergia` = ~64,645 kWh
- [ ] ✅ No errors in Home Assistant logs
- [ ] ✅ Utility meters status = "collecting"

**After 1 hour:**
- [ ] ✅ `sensor.talon_kokonaiskulutus_tunti_kwh` > 0 kWh

**After 24 hours:**
- [ ] ✅ `sensor.talon_kokonaiskulutus_paiva_kwh` = 40-80 kWh (typical)
- [ ] ✅ Dashboard hourly charts show data
- [ ] ✅ Dashboard daily gauges work

**Long-term:**
- [ ] ✅ Weekly consumption accumulates correctly
- [ ] ✅ Monthly totals match previous month patterns
- [ ] ✅ AI prompts return accurate consumption data

---

## 📝 Notes & Observations

**Deployment Date:** ________________

**Deployed By:** ________________

**Issues Encountered:**
- 
- 
- 

**Verification Times:**
- Restart completed: __________ (time)
- 1-hour check: __________ (time)
- 24-hour check: __________ (time)

**Final Values After Fix:**
- `sensor.sahkon_kokonaisenergia`: __________ kWh
- `sensor.talon_kokonaiskulutus_tunti_kwh`: __________ kWh (after 1 hour)
- `sensor.talon_kokonaiskulutus_paiva_kwh`: __________ kWh (after 24 hours)

**Additional Comments:**
- 
- 
- 

---

## 📚 Reference Documents

- [ ] Read: [FIX_HOURLY_CONSUMPTION_SENSOR.md](FIX_HOURLY_CONSUMPTION_SENSOR.md)
- [ ] Have access to: [deploy_hourly_sensor_fix.sh](deploy_hourly_sensor_fix.sh)
- [ ] Reviewed: [HOURLY_SENSOR_FIX_SUMMARY.md](HOURLY_SENSOR_FIX_SUMMARY.md)

---

**Checklist Complete:** ☐ YES  ☐ NO  ☐ PARTIAL

**Status:** ☐ FIXED  ☐ IN PROGRESS  ☐ BLOCKED
