# 🚀 PHASE 1: Critical Fixes - Deployment Instructions

**Created**: 2026-02-08  
**Status**: Ready for deployment  
**Time Required**: 30 minutes

---

## 📦 Files Ready for Deployment

The following files have been created and are ready to copy to your Home Assistant `/config` directory:

1. ✅ `electricity_pricing_constants.yaml` - Centralized pricing constants
2. ✅ `electricity_pricing.yaml` - Modern price calculation sensors  
3. ✅ `power-management/legacy_sensors_migrated.yaml` - Migrated legacy sensors

---

## 🎯 Deployment Steps

### Step 1: Access Your Home Assistant Configuration

**Option A: SSH/Terminal**
```bash
ssh username@homeassistant.local
cd /config
```

**Option B: File Editor Add-on**
- Open Home Assistant
- Settings → Add-ons → File Editor
- Navigate to `/config`

**Option C: Samba Share**
- Connect to `\\homeassistant.local\config`
- Or use VS Code with Remote - SSH extension

---

### Step 2: Backup Current Files (CRITICAL!)

```bash
# Create backup directory
mkdir -p /config/backups/phase1_$(date +%Y%m%d)

# Backup existing files
cp /config/configuration.yaml /config/backups/phase1_$(date +%Y%m%d)/
cp /config/sensors.yaml /config/backups/phase1_$(date +%Y%m%d)/ 2>/dev/null || echo "sensors.yaml not found"

# Verify backups
ls -la /config/backups/phase1_$(date +%Y%m%d)/
```

✅ **Verification**: You should see both files backed up with today's date

---

### Step 3: Copy New Files to Home Assistant

**Copy these files from your Git repo to `/config/`:**

1. **electricity_pricing_constants.yaml**
   - Source: `[Your Git Repo]/electricity_pricing_constants.yaml`
   - Destination: `/config/electricity_pricing_constants.yaml`

2. **electricity_pricing.yaml**
   - Source: `[Your Git Repo]/electricity_pricing.yaml`
   - Destination: `/config/electricity_pricing.yaml`

3. **sensors.yaml** (migrated version)
   - Source: `[Your Git Repo]/power-management/legacy_sensors_migrated.yaml`
   - Destination: `/config/sensors.yaml` (overwrites existing)

**Using SCP (if you have SSH):**
```bash
# From your Mac terminal (in the Git repo directory)
scp electricity_pricing_constants.yaml username@homeassistant.local:/config/
scp electricity_pricing.yaml username@homeassistant.local:/config/
scp power-management/legacy_sensors_migrated.yaml username@homeassistant.local:/config/sensors.yaml
```

---

### Step 4: Update configuration.yaml

Open `/config/configuration.yaml` and add these lines:

**Find the existing `homeassistant:` section and add:**

```yaml
homeassistant:
  # ... your existing config ...
  
  packages:
    # Add these two new lines:
    electricity_pricing_constants: !include electricity_pricing_constants.yaml
    electricity_pricing: !include electricity_pricing.yaml
```

**Full example if you don't have packages yet:**
```yaml
homeassistant:
  name: Home
  latitude: !secret latitude
  longitude: !secret longitude
  elevation: 0
  unit_system: metric
  time_zone: Europe/Helsinki
  
  # Add this entire packages section
  packages:
    electricity_pricing_constants: !include electricity_pricing_constants.yaml
    electricity_pricing: !include electricity_pricing.yaml
```

**Save the file!**

---

### Step 5: Check Configuration

**In Home Assistant UI:**
1. Go to **Developer Tools** → **YAML**
2. Click **"Check Configuration"**
3. Wait 30 seconds
4. Look for ✅ **"Configuration is valid!"**

**If you see errors:**
- Check YAML indentation (must use 2 spaces, not tabs)
- Verify file paths are correct
- Check for typos in filenames

**Expected output:**
```
✅ Configuration valid!
```

---

### Step 6: Restart Home Assistant

**Method 1: Via UI**
1. Go to **Settings** → **System**
2. Click **"Restart"** (top right corner)
3. Confirm restart
4. Wait 2-3 minutes

**Method 2: Via Terminal**
```bash
ha core restart
```

**What to expect:**
- Home Assistant will be unavailable for 2-3 minutes
- When it comes back, dashboard may look the same (that's OK!)
- Sensors will start populating with data

---

### Step 7: Verify New Sensors Are Working

**Go to: Developer Tools → States**

Search for these NEW sensors and verify they exist with values:

```
sensor.electricity_total_price_cents
  - Should show a value like: 8.5 or 12.3
  - Unit: c/kWh
  - ✅ This is your new main price sensor!

sensor.overall_power_factor (will be added in Phase 3)
sensor.rolling_average_60min (will be added in Phase 2)
```

**Check attributes:**
```yaml
sensor.electricity_total_price_cents:
  state: 10.45
  attributes:
    nordpool_price_cents: 3.21
    energy_price: 0.44
    transfer_price: 4.92
    tax: 2.79372
    margin: 0.25
    vat_multiplier: 1.255
    tariff_type: day
```

---

### Step 8: Check for Deprecation Warnings

**Go to: Settings → System → Logs**

**Filter by: Warnings**

**Before Phase 1:**
```
⚠️ Template sensor 'sahkon_hinta_energydashboard' uses deprecated platform: template
⚠️ Template sensor 'sahko_kokonaishinta_c' uses deprecated platform: template
... (46 warnings) ...
```

**After Phase 1 (Expected):**
```
✅ No deprecation warnings! (or very few)
```

If you still see warnings, they're from OTHER components (not the sensors we just fixed).

---

### Step 9: Update Dashboard (Optional Now, Required Later)

Your OLD sensors still work (for backward compatibility), but you should eventually update references:

**Replace in your dashboard YAML:**
```yaml
# OLD (still works but deprecated)
entity: sensor.sahko_kokonaishinta_c

# NEW (use this instead)
entity: sensor.electricity_total_price_cents
```

**You can do this later** - the old sensors will keep working until you're ready to update dashboards.

---

## ✅ Phase 1 Success Criteria

Check these off as you verify:

- [ ] All new files copied to `/config/`
- [ ] `configuration.yaml` updated with packages
- [ ] Configuration check passed ✅
- [ ] Home Assistant restarted successfully
- [ ] `sensor.electricity_total_price_cents` exists and has a value
- [ ] Deprecation warnings reduced or eliminated
- [ ] Dashboard still shows electricity prices (even if using old sensors)
- [ ] No errors in logs related to electricity sensors

---

## 🆘 Troubleshooting

### Issue: "Configuration invalid - electricity_pricing.yaml not found"

**Fix:**
```bash
# Verify file exists
ls -la /config/electricity_pricing.yaml

# Check permissions
chmod 644 /config/electricity_pricing.yaml

# Verify YAML syntax
cat /config/electricity_pricing.yaml | yaml-lint
```

### Issue: "Sensor not available"

**Fix:**
```bash
# Check if Nordpool integration is working
# Developer Tools → States → search for: sensor.nordpool_kwh_fi_eur_4_10_0

# If Nordpool sensor missing, the new price sensor can't calculate
# Restart Nordpool integration:
# Settings → Devices & Services → Nordpool → Reload
```

### Issue: "Template error"

**Fix:**
- Check that `sensor.nordpool_kwh_fi_eur_4_10_0` exists
- Verify it has a numeric value (not "unknown" or "unavailable")
- Wait 5 minutes for Nordpool to update

### Issue: "Prices seem wrong"

**Check your constants:**
Open `electricity_pricing_constants.yaml` and verify:
- Day tariff: 0.44 c/kWh (your actual day tariff)
- Night tariff: 0.37 c/kWh (your actual night tariff)
- Transfer day: 4.92 c/kWh (your actual transfer tariff)
- Transfer night: 3.01 c/kWh (your actual night transfer)
- Tax: 2.79372 c/kWh (Finnish electricity tax 2026)
- VAT: 1.255 (25.5%)

**Adjust values to match your electricity contract!**

---

## 📊 What You've Accomplished

✅ **Future-proofed** - No more deprecation warnings  
✅ **Centralized** - All pricing in one place  
✅ **Accurate** - Auto day/night tariff detection  
✅ **Compatible** - Works with HA 2026.6+  
✅ **Backward compatible** - Old sensors still work during transition  

---

## 🎯 Next Steps

Once Phase 1 is complete and stable for 24 hours:

**Phase 2: Core Power Management** (90 minutes)
- Import 4 Node-RED flows
- Set up load balancer
- Configure peak power limiter
- Enable price-based optimizer

See: `MASTER_IMPLEMENTATION_PLAN.md` → Phase 2

---

## 📝 Notes

**Date Deployed**: _______________  
**Time Spent**: _______________  
**Issues Encountered**: 
```
_______________________________________________________
_______________________________________________________
```

**Sensor Values After Deployment**:
```
sensor.electricity_total_price_cents: _____ c/kWh
sensor.nordpool_kwh_fi_eur_4_10_0: _____ €/kWh
Deprecation warnings: _____ (before) → _____ (after)
```

---

**🎉 When everything is working, mark Phase 1 as COMPLETE in IMPLEMENTATION_PROGRESS.md!**
