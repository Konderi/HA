# ⚡ Energy Sensor Unit Conversion Fix

**Issue:** `sensor.sahkon_kokonaisenergia_2` was showing very large numbers  
**Cause:** ShellyEM3 sensors report in **Wh (watt-hours)**, not kWh  
**Fix:** Added `/1000` conversion to display in **kWh** for dashboards

---

## 🔧 What Changed

### Before (Incorrect)
```yaml
state: >
  {{ (a + b + c) | round(2) }}
```
**Result:** 64,645 (showing Wh as-is)

### After (Correct) ✅
```yaml
state: >
  {{ ((a + b + c) / 1000) | round(2) }}
```
**Result:** 64.6 kWh (properly converted)

---

## 📊 Example Values

| Phase | Raw Value (Wh) | Converted (kWh) |
|-------|----------------|-----------------|
| Channel A | 28,199 | 28.2 |
| Channel B | 18,297 | 18.3 |
| Channel C | 18,149 | 18.1 |
| **Total** | **64,645** | **64.6** |

---

## ✅ What Works Now

- ✅ Sensor shows proper kWh values in dashboards
- ✅ Historical data will accumulate correctly
- ✅ Utility meters will calculate proper consumption
- ✅ Attributes also converted to kWh

---

## 🚀 Deploy

```bash
# Copy updated sensor
scp config/sensors/total_energy_sensor.yaml root@homeassistant:/config/sensors/

# Restart Home Assistant
ssh root@homeassistant "ha core restart"
```

**Verify:** Check Developer Tools → States → `sensor.sahkon_kokonaisenergia_2`  
Should show: **~64.6 kWh** (not 64,645)

---

## 📁 Files Updated

- ✅ `config/sensors/total_energy_sensor.yaml` - Added `/1000` conversion
- ✅ `HOURLY_SENSOR_FIX_SUMMARY.md` - Updated expected values

---

## 💡 Why This Matters

**Dashboards need kWh:**
- Gauge cards show proper range (0-100 kWh)
- Charts display readable values
- Cost calculations work correctly
- Matches other energy sensors

**Without conversion:**
```
❌ Daily consumption: 64,645 (meaningless)
❌ Cost: 64,645 × price (way too high)
```

**With conversion:**
```
✅ Daily consumption: 64.6 kWh (correct)
✅ Cost: 64.6 × 0.14 € = 9.04 € (accurate)
```
