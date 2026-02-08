# 🚨 Node-RED Errors - Quick Fix
**Created:** 2026-02-08

---

## 🎯 The Problem

You're seeing **25+ deprecation warnings** and **missing entity errors** in Node-RED because:

1. **Your flows in Node-RED are OLD** (not the ones in git)
2. **They use deprecated `state_type`** (will break in v1.0)
3. **They reference old sensor names** that were renamed
4. **They reference entities that don't exist** in your setup

---

## ⚡ Quick Fix (5 minutes)

### Step 1: Export Your Current Flows

1. Open **Node-RED** in Home Assistant
2. Click **Menu (☰)** → **Export**
3. Select **"All flows"**
4. Click **"Download to clipboard"** or **"Export to file"**
5. Save as `my_flows_backup.json`

### Step 2: Copy File to Mac

Transfer `my_flows_backup.json` to this directory:
```
/Users/tonijoronen/Library/Mobile Documents/com~apple~CloudDocs/Git/HomeAssistant/
```

### Step 3: Run Fix Script

```bash
cd "/Users/tonijoronen/Library/Mobile Documents/com~apple~CloudDocs/Git/HomeAssistant"
python3 fix_nodered_flows_all.py my_flows_backup.json
```

This creates: `my_flows_backup_FIXED.json`

### Step 4: Import Fixed Flows

1. Open `my_flows_backup_FIXED.json`
2. Copy **ALL contents** (Cmd+A, Cmd+C)
3. In **Node-RED**: Menu → Import → Paste
4. Select **"Replace existing flows"**
5. Click **"Import"**
6. Review nodes with **⚠️ warnings**
7. Click **"Deploy"**

---

## 🔍 What Gets Fixed

### Automatically Fixed:
✅ All `state_type` deprecations removed (25+ fixes)  
✅ `sensor.electricity_price` → `sensor.electricity_total_price_cents`  
✅ `sensor.sahko_kokonaishinta_c` → `sensor.electricity_total_price_cents`  
✅ Other deprecated electricity sensors updated  

### Needs Manual Update:
⚠️ `person.user` → Update to `person.your_name`  
⚠️ `climate.living_room` → Update to your climate entity  
⚠️ `sensor.sahko_kokonaiskulutus_teho` → Update to your power sensor  
⚠️ `weather.home` → Update to your weather integration  
⚠️ `sensor.solar_power` → Update or disable if no solar  
⚠️ `notify.telegram` → Configure or disable Telegram nodes  

---

## 📋 Manual Entity Updates

If you can't export/import, update manually in Node-RED:

### Find Your Real Entity IDs:

**Home Assistant:**
- Developer Tools → States → Search

### Common Mappings:

| **Error** | **Fix** |
|-----------|---------|
| `sensor.electricity_price` | `sensor.electricity_total_price_cents` |
| `sensor.sahko_kokonaiskulutus_teho` | Search "power" in States |
| `climate.living_room` | Search "climate" in States |
| `person.user` | Search "person" in States |
| `weather.home` | Search "weather" in States |

### Update in Node-RED:

1. Double-click **red triangle node**
2. Change **"Entity"** field to correct ID
3. Click **"Done"**
4. **Deploy**

---

## 🔕 Disable Unused Features

### Telegram Notifications:
- If you don't use Telegram, disable those nodes:
  - Double-click node
  - Check ☑️ "Disable"
  - Deploy

### Solar Monitoring:
- If you don't have solar panels:
  - Disable `Solar Production` nodes

### Motion Sensors:
- If not installed:
  - Disable `Living Room Motion` nodes

---

## ✅ Verification

After fixing, you should see:

✅ **Node-RED Debug Panel:** No red warnings  
✅ **Home Assistant Logs:** No "entity not found"  
✅ **Flows:** All nodes green (no red triangles)  

---

## 📚 Full Documentation

- **Complete Guide:** `NODE_RED_FIX_GUIDE.md`
- **Fix Script:** `fix_nodered_flows_all.py`
- **State Type Only:** `fix_nodered_state_type.py`

---

## 🆘 Still Having Issues?

### Can't export flows?
→ Check Node-RED is running in HA

### Script errors?
→ Make sure Python 3 is installed

### Entity not found after fix?
→ Check entity exists: Developer Tools → States

### Telegram errors persist?
→ Disable Telegram nodes or configure integration

---

**Status:** Tools ready ✅  
**Action:** Export your flows and run the fix script
