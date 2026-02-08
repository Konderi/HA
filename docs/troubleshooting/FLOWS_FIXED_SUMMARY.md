# ✅ Node-RED Flows - FIXED
**Date:** 2026-02-08  
**Status:** All flow files repaired and ready to import

---

## 📋 What Was Fixed

### ✅ Automatically Fixed:
1. **sensor.electricity_price** → `sensor.electricity_total_price_cents` (eco-mode.json)

### ⚠️ Marked for Manual Update:
These entities need to be updated with YOUR actual entity IDs:

| **Flow File** | **Node Name** | **What to Update** |
|--------------|---------------|-------------------|
| eco-mode.json | Solar Production | `sensor.solar_power` → your solar sensor |
| eco-mode.json | Set Eco Temperature | `climate.living_room` → your climate entity |
| priority-load-balancer.json | Total Power Monitor | `sensor.sahko_kokonaiskulutus_teho` → your power meter |
| room-temperature-control.json | Living Room Schedule | `climate.living_room` → your climate entity |
| basic-heating-schedule.json | Set Temperature | `climate.living_room` → your climate entity |
| advanced-heating-automation.json | Home Presence | `person.user` → your person entity |
| advanced-heating-automation.json | Get Outdoor Temp | `weather.home` → your weather integration |
| advanced-heating-automation.json | Set Temperature | `climate.living_room` → your climate entity |
| advanced-heating-automation.json | Manual Temperature Change | `climate.living_room` → your climate entity |

---

## 🚀 How to Import Fixed Flows

### Step 1: Copy Flow Files to Home Assistant

From **this Mac**:
```bash
# Copy all fixed flows to a USB drive or use scp/rsync
cp power-management/flows/*.json /path/to/usb/

# Or if you have SSH access to Home Assistant:
scp power-management/flows/*.json root@homeassistant:/config/node-red/
```

### Step 2: Import in Node-RED

For **each flow file**:

1. **Open Node-RED** in Home Assistant
2. **Menu (☰)** → **Import**
3. Click **"Select a file to import"**
4. Choose the flow file (e.g., `eco-mode.json`)
5. Select **"Replace existing flows"** (important!)
6. Click **"Import"**

Repeat for all 9 flow files:
- ✅ peak-power-limiter.json
- ✅ price-based-optimizer.json
- ✅ advanced-heating-automation.json
- ✅ temperature-radiator-control.json
- ✅ priority-load-balancer.json
- ✅ basic-heating-schedule.json
- ✅ eco-mode.json
- ✅ room-temperature-control.json
- ✅ phase-monitor-alerts.json

### Step 3: Update Placeholder Entities

After importing, you'll see nodes with **⚠️ UPDATE** in their names:

1. **Double-click** the node with warning
2. **Change the entity ID** to your actual entity
3. **Click "Done"**
4. Repeat for all warning nodes
5. **Deploy**

---

## 🔍 Finding Your Entity IDs

### In Home Assistant:

**Developer Tools → States**

Search for:
- **Person:** Type "person" → e.g., `person.tuomas`
- **Climate:** Type "climate" → e.g., `climate.thermostat_living_room`
- **Weather:** Type "weather" → e.g., `weather.forecast_home`
- **Power:** Type "power" → e.g., `sensor.power_consumption_total`
- **Solar:** Type "solar" → e.g., `sensor.solar_production_power`

Copy the exact entity ID and paste it into the Node-RED node.

---

## ⚠️ Nodes That May Not Work (Disable if Unused)

### Telegram Notifications:
If you see "notify.telegram not found":
- **Option 1:** Configure Telegram integration in HA
- **Option 2:** Disable these nodes in Node-RED

### Solar Production:
If you don't have solar panels:
- Disable the "Solar Production" node in eco-mode.json

### Motion Sensors:
If `binary_sensor.living_room_motion` doesn't exist:
- Disable or update to your actual motion sensor

---

## ✅ What Should Work Immediately

These flows use **only** the fixed sensors and should work without changes:

✅ **price-based-optimizer.json**
- Uses `sensor.electricity_total_price_cents` ✅
- Uses `sensor.shf_rank_now` ✅
- Should work perfectly!

✅ **temperature-radiator-control.json**
- Uses room temperature sensors you defined
- Should work if sensors exist

✅ **phase-monitor-alerts.json**
- Monitors voltage phases
- Works if you have phase monitoring

---

## 🔧 After Import Checklist

- [ ] All 9 flows imported to Node-RED
- [ ] Updated `person.user` to your person entity
- [ ] Updated `climate.living_room` to your climate entities
- [ ] Updated `weather.home` to your weather integration
- [ ] Updated `sensor.sahko_kokonaiskulutus_teho` to your power meter
- [ ] Updated or disabled `sensor.solar_power`
- [ ] Disabled or configured Telegram nodes
- [ ] Clicked "Deploy" in Node-RED
- [ ] No red triangles visible in flows
- [ ] No errors in Node-RED debug panel

---

## 📊 Expected Results

After fixing and deploying:

✅ **No "state_type deprecated" warnings**  
✅ **No "sensor.electricity_price not found"**  
✅ **Price-based flows work immediately**  
⚠️ **Placeholder entities show warnings until updated**  

---

## 🆘 Still See Errors?

### "Entity not found" after updating:
→ Double-check entity ID spelling in Developer Tools → States

### "Action notify.telegram not found":
→ Disable Telegram nodes or configure integration

### Flows not updating:
→ Make sure you clicked "Deploy" after changes

### Old errors still showing:
→ Clear Node-RED cache: Settings → View → Clear logs

---

**Last Updated:** 2026-02-08  
**Commit:** a05f1af  
**Status:** ✅ All flows fixed and committed to git
