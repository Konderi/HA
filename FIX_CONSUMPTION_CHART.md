# 📊 Fix: Consumption vs Price Chart Showing Wrong Values

## 🔴 The Problem

Your chart "Kulutus vs. Hinta 7 päivää" shows:
- **64,937.59 kWh** - This is the LIFETIME TOTAL (wrong!)
- Should show: **2-6 kWh per hour** (hourly consumption)

### Why This Happens

The chart uses `sensor.talon_kokonaiskulutus_tunti_kwh` (hourly consumption), but this sensor is **broken** because:
1. It's a utility meter that calculates consumption from a source sensor
2. The source sensor (`sensor.sahkon_kokonaisenergia`) is unavailable
3. Without a working source, the utility meter shows incorrect data

---

## ✅ The Solution

### What Needs to Happen

```
Step 1: Fix energy sensor (convert Wh → kWh) ✅ Done
Step 2: Create utility meters pointing to new sensor ✅ Done  
Step 3: Deploy to Home Assistant ⏳ You need to do this
Step 4: Wait 1 hour for data to accumulate ⏳
```

### Expected Result

**Before (Wrong):**
```
Chart shows: 64,937 kWh (cumulative lifetime total)
Y-axis: 0 - 64,937
Orange area: Flat line at 64,937
```

**After (Correct):**
```
Chart shows: 2-6 kWh per hour
Y-axis: 0 - 10 kWh
Orange bars: Varying hourly consumption
Red line: Price variations (0-60 c/kWh)
```

---

## 🚀 Quick Deploy

### Option 1: Automated Script (Recommended)

```bash
chmod +x deploy_chart_fix.sh
./deploy_chart_fix.sh
```

### Option 2: Manual Steps

```bash
# 1. Copy files
scp config/sensors/total_energy_sensor.yaml root@homeassistant:/config/sensors/
scp config/sensors/utility_meters.yaml root@homeassistant:/config/sensors/

# 2. SSH to Home Assistant
ssh root@homeassistant

# 3. Edit configuration.yaml
nano /config/configuration.yaml

# Add these lines:
template: !include sensors/total_energy_sensor.yaml
utility_meter: !include sensors/utility_meters.yaml

# 4. Restart
ha core check
ha core restart
```

---

## 🔍 Verification

### After Restart (Immediately)

Check Developer Tools → States:

```yaml
sensor.sahkon_kokonaisenergia_2: "64.6"  # Cumulative total (kWh) ✅
sensor.talon_kokonaiskulutus_tunti_kwh: "0"  # Hourly (will update) ⏳
```

### After 1 Hour

```yaml
sensor.talon_kokonaiskulutus_tunti_kwh: "3.2"  # Hourly consumption ✅
```

### Chart Should Show

Open Magic Mirror dashboard → Scroll to "Kulutus vs. Hinta 7 päivää":

```
✅ Orange bars: 2-6 kWh varying by hour
✅ Red line: Price 10-50 c/kWh varying
✅ Y-axis left: 0-10 kWh (not 0-64,937!)
✅ Y-axis right: 0-60 c/kWh
```

---

## 📁 Files Created

| File | Purpose | Status |
|------|---------|--------|
| `config/sensors/total_energy_sensor.yaml` | Sum 3 phases, convert Wh→kWh | ✅ Ready |
| `config/sensors/utility_meters.yaml` | Hourly/daily/weekly/monthly/yearly meters | ✅ Ready |
| `deploy_chart_fix.sh` | Automated deployment script | ✅ Ready |

---

## 💡 Understanding the Fix

### How Utility Meters Work

```
Source sensor (cumulative):
  10:00 → 64.5 kWh
  11:00 → 66.8 kWh
  12:00 → 69.1 kWh

Hourly utility meter (consumption):
  10:00-11:00 → 2.3 kWh ✅
  11:00-12:00 → 2.3 kWh ✅
```

### Why Chart Was Broken

```
Old setup:
  Utility meter source → sensor.sahkon_kokonaisenergia (unavailable)
  Chart tries to show → Falls back to cumulative total (64,937 kWh)
  Result: Massive flat orange area (wrong!)

New setup:
  Utility meter source → sensor.sahkon_kokonaisenergia_2 (working)
  Chart shows → Hourly consumption (2-6 kWh)
  Result: Varying orange bars showing real consumption ✅
```

---

## 🎯 Expected Hourly Values

Based on typical home consumption:

| Time | Expected kWh | Reason |
|------|--------------|--------|
| 00:00-06:00 | 1-3 kWh | Low (sleeping, base load) |
| 06:00-09:00 | 3-6 kWh | Medium (morning routine) |
| 09:00-16:00 | 2-4 kWh | Low-medium (daytime) |
| 16:00-22:00 | 4-8 kWh | High (cooking, heating) |
| 22:00-24:00 | 2-4 kWh | Medium (evening wind-down) |

**Daily total:** 40-100 kWh (depending on heating, EV charging, etc.)

---

## 🆘 Troubleshooting

### Chart Still Shows 64,937 kWh After 2 Hours

1. **Check utility meter:**
   ```bash
   Developer Tools → States → sensor.talon_kokonaiskulutus_tunti_kwh
   Should show: 2-6 kWh (not 0, not 64,937)
   ```

2. **Check source sensor:**
   ```bash
   Developer Tools → States → sensor.sahkon_kokonaisenergia_2
   Should show: ~64.6 kWh
   State: available (not unavailable!)
   ```

3. **Force dashboard refresh:**
   ```
   Ctrl + F5 (or Cmd + Shift + R on Mac)
   ```

4. **Check logs:**
   ```bash
   ssh root@homeassistant
   ha core logs | grep "talon_kokonaiskulutus"
   ```

### Utility Meter Shows 0 After 2 Hours

The utility meter might need a full hourly cycle:
- Started at 10:30 → Will update at 11:00
- Wait until the next full hour starts

### Chart Shows Wrong Scale

The ApexCharts component auto-scales based on data:
- First hour: Might show 0-1 kWh
- After several hours: Will show proper 0-10 kWh scale
- After 24 hours: Full daily pattern visible

---

## 📞 Need Help?

**Check these in order:**

1. ✅ Files deployed correctly?
   ```bash
   ssh root@homeassistant "ls -la /config/sensors/"
   # Should show: total_energy_sensor.yaml, utility_meters.yaml
   ```

2. ✅ Configuration includes added?
   ```bash
   ssh root@homeassistant "grep -E 'template:|utility_meter:' /config/configuration.yaml"
   ```

3. ✅ No configuration errors?
   ```bash
   ssh root@homeassistant "ha core check"
   ```

4. ✅ Sensors available?
   ```bash
   Developer Tools → States
   Search: sahkon_kokonaisenergia
   Search: talon_kokonaiskulutus_tunti
   ```

---

## 🎯 Success Criteria

You'll know it's working when:

- ✅ Chart title: "Kulutus vs. Hinta 7 päivää"
- ✅ Left Y-axis: 0-10 kWh (not 0-64,937!)
- ✅ Orange area: Varying bars (not flat line)
- ✅ Bars show: 2-6 kWh per hour
- ✅ Red line: Price variations (working)
- ✅ Total in header: ~300-700 kWh for 7 days (not 64,937!)

**The chart should look like a bar graph showing consumption patterns throughout the day, not a giant flat orange block!**
