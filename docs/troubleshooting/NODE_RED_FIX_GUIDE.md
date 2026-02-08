# 🔧 Node-RED Error Fix Guide
**Date:** 2026-02-08  
**Issues:** state_type deprecation + missing entities + missing services

---

## 📋 Summary of Errors

### 1. **state_type deprecation** (25+ nodes)
- Cause: Old Node-RED HA WebSocket plugin syntax
- Fix: Remove `state_type` property from all nodes
- Impact: Will break in Node-RED v1.0

### 2. **Missing entities** (8+ sensors)
- `sensor.electricity_price` → Use `sensor.electricity_total_price_cents`
- `sensor.sahko_kokonaiskulutus_teho` → Use your actual power sensor
- `climate.living_room` → Use your actual climate entity
- `person.user` → Use your actual person entity
- `weather.home` → Use your actual weather entity
- etc.

### 3. **Missing services** (4 nodes)
- `notify.telegram` → Not configured (optional)

---

## 🎯 Quick Fix Option 1: Export & Fix Current Flows

### Step 1: Export Your Current Flows from Node-RED

1. **Open Node-RED** in your Home Assistant
2. **Menu** (☰) → **Export**
3. Select **"All flows"**
4. **Download to clipboard** or **Save as file**
5. Save as `my_flows_backup.json`

### Step 2: Run the Fix Script

Copy your exported flows to this Mac:

```bash
# Copy to HomeAssistant workspace
cd "/Users/tonijoronen/Library/Mobile Documents/com~apple~CloudDocs/Git/HomeAssistant"

# Save your exported flows as:
nano my_flows_backup.json
# Paste your flows, Ctrl+O to save, Ctrl+X to exit

# Run the fix script
python3 fix_nodered_flows_all.py my_flows_backup.json
```

### Step 3: Re-import Fixed Flows

1. **Open fixed file:** `my_flows_backup_FIXED.json`
2. **Copy entire contents** (Cmd+A, Cmd+C)
3. **In Node-RED:** Menu → Import → Paste
4. **Select:** "Replace existing flows"
5. **Deploy**

---

## 🎯 Quick Fix Option 2: Manual Entity Updates

If you can't export flows, update entities manually in Node-RED:

### Missing Entity Fixes:

```yaml
# OLD → NEW mapping
sensor.electricity_price → sensor.electricity_total_price_cents
sensor.sahko_kokonaiskulutus_teho → sensor.<your_power_sensor>
climate.living_room → climate.<your_actual_climate>
person.user → person.<your_name>
weather.home → weather.<your_weather_integration>
sensor.solar_power → sensor.<your_solar_sensor>
input_boolean.eco_mode → input_boolean.<check_if_exists>
binary_sensor.living_room_motion → binary_sensor.<your_motion>
```

### How to Update in Node-RED:

1. **Open each flow** with errors
2. **Double-click the node** with red triangle
3. **Update the entity ID** in the "Entity" field
4. **Click "Done"**
5. **Repeat for all red nodes**
6. **Deploy**

---

## 🔧 Comprehensive Fix: Create New Script

Let me create a comprehensive fix script that handles ALL issues:

```python
# Script will:
# 1. Remove all state_type properties
# 2. Update deprecated sensor names
# 3. Comment out missing Telegram nodes
# 4. Add placeholder comments for missing entities
```

---

## 📝 Entity Mapping Reference

### Electricity Sensors:

| **OLD (Deprecated)** | **NEW (Current)** |
|---------------------|------------------|
| `sensor.electricity_price` | `sensor.electricity_total_price_cents` |
| `sensor.sahko_kokonaishinta_c` | `sensor.electricity_total_price_cents` |
| `sensor.current_electricity_cost_rate` | `sensor.electricity_total_price_cents` |
| `sensor.shf_electricity_full_price_charts` | `sensor.electricity_total_price_cents` |

### Power Monitoring:

| **OLD** | **CHECK YOUR HA FOR** |
|---------|----------------------|
| `sensor.sahko_kokonaiskulutus_teho` | `sensor.power_total` or similar |
| `sensor.solar_power` | Your solar integration sensor |

### Climate/Heating:

| **Placeholder** | **Your Actual Entity** |
|----------------|----------------------|
| `climate.living_room` | Check Settings → Devices → Climate |
| `input_boolean.eco_mode` | Check Developer Tools → States |

### Personal:

| **Placeholder** | **Your Setup** |
|----------------|----------------|
| `person.user` | `person.tuomas` or similar |
| `weather.home` | Your weather integration |
| `binary_sensor.living_room_motion` | Your motion sensors |

---

## 🚨 Telegram Notifications (Optional)

The Telegram errors are because you haven't configured Telegram integration:

### Option 1: Disable Telegram Nodes
1. In Node-RED, find nodes named "Send to Telegram"
2. Double-click → Check "Disable"
3. Deploy

### Option 2: Configure Telegram (Advanced)
1. Create Telegram bot: @BotFather
2. Home Assistant → Integrations → Add Integration → Telegram
3. Configure with bot token and chat ID
4. Restart HA
5. `notify.telegram` service will appear

---

## ✅ Verification Steps

After fixing:

### 1. Check Node-RED Debug Panel
- Should see NO red "deprecated" warnings
- Should see NO "entity not found" errors
- Should see NO "action not found" for services you use

### 2. Test Each Flow
- **Phase Monitor:** Disable if you don't have phase voltage sensors
- **Temperature Control:** Update with your actual room sensors
- **Peak Power Limiter:** Needs your power meter sensor
- **Price Optimizer:** Should work (uses electricity_total_price_cents)
- **Telegram alerts:** Disable or configure Telegram

### 3. Check Home Assistant Logs
```bash
# In HA, check for Node-RED errors:
Developer Tools → Logs → Filter: "node-red"
```

---

## 🎯 Priority Actions

### HIGH PRIORITY (breaks in v1.0):
- ✅ Remove ALL `state_type` properties

### MEDIUM PRIORITY (causes errors):
- ⚠️ Update `sensor.electricity_price` → `sensor.electricity_total_price_cents`
- ⚠️ Update power sensor to your actual sensor
- ⚠️ Update climate entities to your actual climate devices

### LOW PRIORITY (optional features):
- ℹ️ Disable Telegram nodes if not using
- ℹ️ Disable solar nodes if you don't have solar
- ℹ️ Disable motion sensors if not installed

---

## 📞 Need Help?

**Can't export flows?**
- Node-RED UI → Hamburger menu → Export → All flows

**Don't know your entity IDs?**
- Home Assistant → Developer Tools → States
- Search for your devices

**Script errors?**
- Share your `my_flows_backup.json` (remove sensitive data first)

---

## 🔗 Related Files

- `fix_nodered_state_type.py` - Removes state_type deprecations
- `power-management/flows/*.json` - Clean template flows (examples)
- Your actual flows: Stored in Node-RED (need to export)

---

**Last Updated:** 2026-02-08  
**Status:** Comprehensive fix guide created ✅
