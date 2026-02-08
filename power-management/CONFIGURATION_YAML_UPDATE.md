# 📝 Configuration.yaml Update Instructions

## ✅ What We Did

We split the `enhanced_helpers.yaml` into **modular files** that integrate with your existing configuration:

1. ✅ **`input_numbers.yaml`** - Merged water meter + 11 power management sliders
2. ✅ **`input_booleans.yaml`** - 2 override toggles (Tesla priority, Luxus mode)
3. ✅ **`input_datetimes.yaml`** - Combined existing 3 timers + 1 Luxus tracker
4. ✅ **`power_management_automations.yaml`** - 3 auto-disable automations

---

## 🔧 Update Your configuration.yaml

**Location:** `/config/configuration.yaml` (in Home Assistant)

### Option A: Add New Includes (If Not Present)

Find the section with `automation: !include automations.yaml` and add these lines:

```yaml
automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml
sensor: !include sensors.yaml
group: !include groups.yaml
template: !include templates.yaml

# ADD THESE NEW LINES:
input_number: !include power-management/input_numbers.yaml
input_boolean: !include power-management/input_booleans.yaml
```

### Option B: Replace Existing input_datetime Section

**FIND THIS (around line 27-37):**
```yaml
input_datetime:
  device_start_time:
    name: Device Start Time
    has_time: true
    has_date: false
  device_end_time:
    name: Device End Time
    has_time: true
    has_date: false
  electric_trigger_point:
    name: Electric price trigger
    has_time: true
    has_date: false
```

**REPLACE WITH:**
```yaml
input_datetime: !include power-management/input_datetimes.yaml
```

### Option C: Add Automations to Existing File

**Option C1 - If using automations.yaml (single file):**
Copy content from `power_management_automations.yaml` and paste at the END of your `automations.yaml` file.

**Option C2 - If using directory mode:**
Already works! The file `power_management_automations.yaml` will be auto-loaded.

---

## 📋 Complete Example Configuration.yaml

Here's how your file should look after changes:

```yaml
# Loads default set of integrations. Do not remove.
default_config:

frontend:
  themes: !include_dir_merge_named themes

automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml
sensor: !include sensors.yaml
group: !include groups.yaml
template: !include templates.yaml

# NEW: Power Management Helpers
input_number: !include power-management/input_numbers.yaml
input_boolean: !include power-management/input_booleans.yaml
input_datetime: !include power-management/input_datetimes.yaml

# Example configuration.yaml entry for the Telegram Bot
telegram_bot:
  allowed_chat_ids:
    - 6566689927

# ... rest of your config stays the same ...
```

---

## ✅ What to Do Now

### Step 1: Edit Configuration.yaml (5 min)
1. Open Home Assistant
2. Go to **Settings** → **Add-ons** → **File Editor** (or use Studio Code Server)
3. Open `/config/configuration.yaml`
4. Add the 3 new `!include` lines (see Option A above)
5. Replace `input_datetime:` section (see Option B above)
6. Save file

### Step 2: Check Configuration (1 min)
1. Go to **Developer Tools** → **YAML** tab
2. Click **"Check Configuration"**
3. Should see: ✅ "Configuration valid!"

### Step 3: Restart Home Assistant (2 min)
1. Go to **Settings** → **System** → **Restart**
2. Click **"Restart Home Assistant"**
3. Wait ~1 minute for restart

### Step 4: Verify Helpers Created (2 min)
1. Go to **Settings** → **Devices & Services** → **Helpers** tab
2. Search for "Boiler" - should see:
   - ✅ Boiler Max Price Rank
   - ✅ Boiler Max Hours Per Day
   - ✅ Boiler Luxus Mode (2h)
3. Search for "Tesla" - should see:
   - ✅ Tesla Priority Charging
4. Search for "MH1/Tuomas/Sara" - should see 9 temperature controls

---

## 🚨 Troubleshooting

### Error: "Duplicate key: input_datetime"
**Problem:** You already have `input_datetime:` somewhere else in config
**Solution:** Use Option B above - replace your existing section with the include

### Error: "File not found: power-management/input_numbers.yaml"
**Problem:** Files are in wrong location
**Solution:** Make sure files are in `/config/power-management/` directory

### Helpers Not Showing Up
**Problem:** Configuration not reloaded properly
**Solution:** 
1. Check configuration is valid
2. Do a **full restart** (not just reload)
3. Clear browser cache (Ctrl+F5)

### Automations Not Working
**Problem:** Automations didn't load from new file
**Solution:** 
- If using single `automations.yaml`: Copy content manually
- If using directory mode: Files should auto-load

---

## 📊 After Setup - Verify Everything

Run this checklist after restart:

- [ ] 11 input_number sliders visible in Helpers
- [ ] 2 input_boolean toggles visible in Helpers  
- [ ] 4 input_datetime entities visible in Helpers
- [ ] 3 automations visible in Settings → Automations
- [ ] Water meter reading still works (existing functionality)
- [ ] No errors in Home Assistant logs

---

## 💡 Benefits of This Approach

✅ **Modular** - Each helper type in separate file
✅ **Maintainable** - Easy to find and edit
✅ **Organized** - All power management in one folder
✅ **Compatible** - Works with existing water meter helper
✅ **Future-proof** - Easy to add more helpers later
✅ **Git-friendly** - Clean diffs when making changes

---

## 🎯 What's Next?

After helpers are created:
1. Import Node-RED flows
2. Add dashboard card
3. Test controls

See **ENHANCED_CONTROLS_DEPLOYMENT.md** for complete deployment guide!
