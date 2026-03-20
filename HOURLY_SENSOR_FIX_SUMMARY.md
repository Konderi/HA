# ⚡ Hourly Consumption Sensor - Quick Fix Summary

**Status:** 🔴 BROKEN  
**Sensor:** `sensor.talon_kokonaiskulutus_tunti_kwh`  
**Impact:** Hourly and daily consumption charts showing "0"

---

## 🎯 What's Wrong

The **source sensor** is missing:
```
sensor.sahkon_kokonaisenergia = "unavailable"
```

This sensor sums all 3 phases from your ShellyEM3 and converts Wh → kWh:
- Channel A: ~28,199 Wh = 28.2 kWh ✅
- Channel B: ~18,297 Wh = 18.3 kWh ✅
- Channel C: ~18,149 Wh = 18.1 kWh ✅
- **Total:** Should be ~64.6 kWh ❌ (not calculated)

Without this sensor, the utility meters can't track consumption:
- ❌ `sensor.talon_kokonaiskulutus_tunti_kwh` = 0 (hourly)
- ❌ `sensor.talon_kokonaiskulutus_paiva_kwh` = 0 (daily)
- ✅ Monthly/yearly meters still work (they collected data before)

---

## 🔧 The Fix

### The file already exists!
✅ `config/sensors/total_energy_sensor.yaml`

### It just needs to be loaded:
Add to `/config/configuration.yaml` on Home Assistant:
```yaml
template: !include sensors/total_energy_sensor.yaml
```

---

## 🚀 Quick Deployment

### Option 1: Automated Script (Recommended)
```bash
chmod +x deploy_hourly_sensor_fix.sh
./deploy_hourly_sensor_fix.sh
```

### Option 2: Manual (2 minutes)
```bash
# 1. Copy file
scp config/sensors/total_energy_sensor.yaml root@homeassistant:/config/sensors/

# 2. Add include to configuration.yaml
ssh root@homeassistant
nano /config/configuration.yaml
# Add: template: !include sensors/total_energy_sensor.yaml

# 3. Restart
ha core check
ha core restart
```

---

## ✅ Verification

**Immediately after restart:**
```
Developer Tools → States → search "sahkon_kokonaisenergia"
Should show: ~64.6 kWh (converted from Wh)
```

**After 1 hour:**
```
sensor.talon_kokonaiskulutus_tunti_kwh > 0
```

**After 24 hours:**
```
sensor.talon_kokonaiskulutus_paiva_kwh = 40-80 kWh
```

---

## 📊 What Gets Fixed

### Dashboards
- ✅ Professional Dashboard (line 107) - Hourly chart
- ✅ Mobile Dashboard (lines 225, 497) - Hourly displays
- ✅ Magic Mirror (line 183) - Hourly consumption
- ✅ All daily consumption gauges

### Sensors
- ✅ `sensor.talon_kokonaiskulutus_tunti_kwh`
- ✅ `sensor.talon_kokonaiskulutus_paiva_kwh`
- ✅ `sensor.talon_kokonaiskulutus_viikko_kwh`

---

## 📚 Documentation

**Full Guide:** [FIX_HOURLY_CONSUMPTION_SENSOR.md](FIX_HOURLY_CONSUMPTION_SENSOR.md)  
**Deployment Script:** [deploy_hourly_sensor_fix.sh](deploy_hourly_sensor_fix.sh)  
**Original Issue:** [SENSOR_FIX_REQUIRED.md](SENSOR_FIX_REQUIRED.md)

---

## 🆘 Need Help?

**Check logs:**
```bash
ssh root@homeassistant
ha core logs | grep sahkon_kokonaisenergia
```

**Verify ShellyEM3 sensors:**
```
Developer Tools → States
Search: shellyem3_channel
All 3 channels should show kWh values
```

**Still broken?**
- Check ShellyEM3 device is online
- Verify integration is working
- Read full troubleshooting guide in FIX_HOURLY_CONSUMPTION_SENSOR.md
