# 🔄 Legacy Sensor Migration Guide

## ⚠️ CRITICAL: Action Required by HA 2026.6

You have **46 legacy template sensors** using deprecated `platform: template` syntax that **will stop working in Home Assistant 2026.6**.

**Current HA Version:** 2026.2.x ✅  
**Deadline:** HA 2026.6 ⏰  
**Status:** Migration required

---

## 📊 Migration Summary

| Category | Count | Action Required |
|----------|-------|----------------|
| **Replaced by new pricing system** | 7 sensors | ✅ Remove - Already replaced |
| **Kept with modern syntax** | 5 sensors | 🔄 Use migrated file |
| **Total deprecated sensors** | 46+ | 🔧 Full migration needed |

---

## 🎯 Quick Start - 3 Steps to Fix

### Step 1: Add New Configuration Files

These files use **modern syntax** and replace most legacy sensors:

```yaml
# In your configuration.yaml, add:
template: !include power-management/electricity_pricing.yaml
input_number: !include power-management/electricity_pricing_constants.yaml
```

### Step 2: Replace Legacy Sensors File

**Option A - Clean Start (Recommended):**
```bash
# Backup old sensors
mv old_configs/sensors.yaml old_configs/sensors.yaml.backup

# Use new migrated file
cp power-management/legacy_sensors_migrated.yaml old_configs/sensors.yaml
```

**Option B - Keep Both During Testing:**
```yaml
# In configuration.yaml:
template: !include old_configs/sensors.yaml          # Old (will be removed)
template: !include power-management/legacy_sensors_migrated.yaml  # New
```

### Step 3: Update Dashboard References

Replace old sensor names with new ones in your Lovelace dashboards.

---

## 🔄 Sensor Replacement Map

### Electricity Pricing Sensors (7 deprecated → 5 new)

| ❌ Old Sensor (Remove) | ✅ New Sensor (Use) | Notes |
|------------------------|---------------------|-------|
| `sensor.sahkon_hinta_energydashboard` | `sensor.electricity_total_price_now` | Total price EUR/kWh |
| `sensor.sahkon_myyntihinta_c_kwh` | `sensor.shf_electricity_price_now` × 100 | Spot price only |
| `sensor.sahko_siirtohinta` | `sensor.transfer_tariff_now` | Day/night aware |
| `sensor.sahko_kokonaishinta` | `sensor.electricity_total_price_now` | Duplicate |
| `sensor.sahko_kokonaishinta_c` | `sensor.electricity_total_price_cents` | Price in cents |
| `sensor.shf_electricity_full_price_charts` | `sensor.electricity_total_price_cents` | For charts |
| `sensor.shf_electricity_full_price_now` | `sensor.electricity_total_price_cents` | Current price |

**Why these are better:**
- ✅ Modern syntax (no deprecation warnings)
- ✅ Centralized pricing constants (one place to update)
- ✅ Day/night tariff auto-detection
- ✅ More accurate calculations
- ✅ Better attributes for debugging

### Power Monitoring Sensors (Kept, migrated to modern syntax)

| Sensor | Status | Notes |
|--------|--------|-------|
| `sensor.sahko_kokonaiskulutus_energia` | ✅ Migrated | Total energy (kWh) from 3 phases |
| `sensor.sahko_kokonaiskulutus_teho` | ✅ Migrated | Total power (W) from 3 phases |
| `sensor.sahkon_kokonaiskulutus_kwh` | ⚠️ Deprecated | Use `sensor.total_power_consumption` |

### Other Sensors (Kept, migrated to modern syntax)

| Sensor | Status | Purpose |
|--------|--------|---------|
| `sensor.vedenkulutuksen_hinta` | ✅ Migrated | Water consumption cost |
| `sensor.cheapest_hours_energy_tomorrow` | ✅ Migrated | Best 5-hour window tomorrow |

---

## 📝 Detailed Migration Steps

### 1. Backup Your Current Configuration

```bash
# Create backup folder
mkdir -p ~/ha-backup-$(date +%Y%m%d)

# Backup critical files
cp old_configs/sensors.yaml ~/ha-backup-$(date +%Y%m%d)/
cp configuration.yaml ~/ha-backup-$(date +%Y%m%d)/
```

### 2. Add New Pricing System

**File: `configuration.yaml`**

Add these includes:
```yaml
# Modern template sensors (NEW)
template: !include power-management/electricity_pricing.yaml

# Centralized pricing constants (NEW)
input_number: !include power-management/electricity_pricing_constants.yaml
```

### 3. Replace Legacy Sensors

**Option A - Clean Migration:**
```bash
# Remove old sensors file
rm old_configs/sensors.yaml

# Create new sensors file
cp power-management/legacy_sensors_migrated.yaml configuration/templates/sensors.yaml
```

**Option B - Keep for Reference:**
```bash
# Rename old file
mv old_configs/sensors.yaml old_configs/sensors.yaml.deprecated

# Use new file
cp power-management/legacy_sensors_migrated.yaml old_configs/sensors.yaml
```

### 4. Update Dashboard References

**Find and Replace in your Lovelace configuration:**

```yaml
# Old → New replacements
sensor.sahkon_hinta_energydashboard → sensor.electricity_total_price_now
sensor.sahko_kokonaishinta_c → sensor.electricity_total_price_cents
sensor.shf_electricity_full_price_now → sensor.electricity_total_price_cents
sensor.sahko_siirtohinta → sensor.transfer_tariff_now
```

**Example Before:**
```yaml
- type: entity
  entity: sensor.sahkon_hinta_energydashboard
  name: Electricity Price
```

**Example After:**
```yaml
- type: entity
  entity: sensor.electricity_total_price_now
  name: Electricity Price
```

### 5. Restart Home Assistant

```bash
# Developer Tools → YAML → Check Configuration
# If OK:
# Developer Tools → Restart Home Assistant
```

### 6. Verify Migration

**Check these in Developer Tools → States:**

✅ New sensors should appear:
- `sensor.electricity_total_price_now`
- `sensor.electricity_total_price_cents`
- `sensor.transfer_tariff_now`

✅ Old sensors should still work (with modern syntax):
- `sensor.sahko_kokonaiskulutus_energia`
- `sensor.sahko_kokonaiskulutus_teho`

✅ No more deprecation warnings in Settings → System → Repairs

---

## 🔍 Troubleshooting

### Issue: Sensors not appearing after restart

**Solution:**
```bash
# Check Home Assistant logs
# Settings → System → Logs
# Look for template errors
```

**Common errors:**
- Missing `!include` in `configuration.yaml`
- File path wrong (check folder names)
- YAML syntax errors (indentation)

### Issue: Dashboard shows "Entity not available"

**Solution:**
1. Check Developer Tools → States for new sensor names
2. Update Lovelace YAML to use new sensor names
3. Clear browser cache (Ctrl+Shift+R)

### Issue: Prices are wrong

**Solution:**
1. Verify `electricity_pricing_constants.yaml` values
2. Check Settings → Devices & Services → Spot-hinta.fi integration
3. Ensure `sensor.shf_electricity_price_now` has data

### Issue: Still getting deprecation warnings

**Solution:**
1. Check Settings → System → Repairs
2. Click on warning to see which sensor
3. Verify that sensor is using new file
4. May need to remove old `old_configs/sensors.yaml` entirely

---

## 📊 Comparison: Old vs New Syntax

### ❌ OLD SYNTAX (Deprecated - Breaks in 2026.6)

```yaml
sensor:
  - platform: template
    sensors:
      sahkon_hinta_energydashboard:
        friendly_name: "Sähkön hinta"
        unit_of_measurement: "EUR/kWh"
        value_template: >
          {% set spotprice = states('sensor.shf_electricity_price_now') | float(0) %}
          {% set tax = 0.02827515 %}
          {% set margin = 0.0059 %}
          {{ spotprice + tax + margin }}
```

**Problems:**
- ❌ `platform: template` is deprecated
- ❌ Uses `value_template` (old)
- ❌ Hardcoded prices (hard to maintain)
- ❌ Will break in HA 2026.6

### ✅ NEW SYNTAX (Modern - Works Forever)

```yaml
template:
  - sensor:
      - name: "Electricity Total Price Now"
        unique_id: electricity_total_price_now
        unit_of_measurement: "EUR/kWh"
        device_class: monetary
        state: >
          {% set spot = states('sensor.shf_electricity_price_now') | float(0) %}
          {% set tax = states('input_number.electricity_tax_eur') | float(0) %}
          {% set margin = states('input_number.electricity_margin_eur') | float(0) %}
          {% set transfer = states('sensor.transfer_tariff_now') | float(0) %}
          {{ (spot + tax + margin + transfer) | round(4) }}
```

**Benefits:**
- ✅ Modern `template:` syntax
- ✅ Uses `state` (current standard)
- ✅ References centralized constants
- ✅ Future-proof for HA 2027+
- ✅ Better attributes and debugging

---

## 🎯 Testing Checklist

After migration, verify these work:

### Core Pricing ✓
- [ ] `sensor.electricity_total_price_now` shows correct price
- [ ] `sensor.electricity_total_price_cents` matches (×100)
- [ ] `sensor.transfer_tariff_now` changes at 07:00 and 22:00
- [ ] `binary_sensor.night_tariff_active` correct (on 22:00-07:00)

### Power Monitoring ✓
- [ ] `sensor.sahko_kokonaiskulutus_energia` shows total kWh
- [ ] `sensor.sahko_kokonaiskulutus_teho` shows total watts
- [ ] Attributes show individual phase values

### Dashboard ✓
- [ ] All cards show data (no "unavailable")
- [ ] Price history charts work
- [ ] Current price displays correctly
- [ ] No deprecation warnings in Repairs

### Node-RED Flows ✓
- [ ] Priority Load Balancer flow works
- [ ] Peak Power Limiter flow works
- [ ] Price-based optimization uses new sensors
- [ ] No errors in Node-RED debug

---

## 🚀 Benefits After Migration

### Immediate Benefits
- ✅ No more deprecation warnings (46 → 0)
- ✅ System won't break in HA 2026.6
- ✅ Better sensor organization

### Long-term Benefits
- ✅ Centralized pricing (one place to update)
- ✅ More accurate price calculations
- ✅ Day/night tariff automation
- ✅ Better debugging with attributes
- ✅ Future-proof for HA 2027+

### Cost Savings
- ✅ More accurate electricity cost tracking
- ✅ Better optimization decisions
- ✅ Tehomaksu protection still works
- ✅ Price-based device scheduling improved

---

## 📞 Need Help?

### Quick Checks
1. **Configuration valid?** Settings → System → Check Configuration
2. **Logs clean?** Settings → System → Logs (filter: "template")
3. **Sensors exist?** Developer Tools → States (search "electricity")
4. **Repairs empty?** Settings → System → Repairs

### Common Questions

**Q: Can I keep old and new sensors during testing?**  
A: Yes! Use different `!include` paths for both files. Remove old one when testing complete.

**Q: Will my Node-RED flows break?**  
A: No, if using new sensor names. Check flows and update any references to old sensor names.

**Q: Do I need to reconfigure my dashboard?**  
A: Only if using old sensor names. Replace with new sensor names from mapping table above.

**Q: What if I have custom automations?**  
A: Check automations for references to old sensor names and update them.

---

## 📅 Migration Timeline

**Week 1:** Test new pricing system
- Add new configuration files
- Verify sensors work alongside old ones
- Test dashboard with new sensors

**Week 2:** Update references
- Update Lovelace dashboard
- Update Node-RED flows
- Update automations

**Week 3:** Remove legacy
- Remove old sensors file
- Verify no errors
- Monitor for 1 week

**Week 4:** Cleanup
- Delete backup files
- Update documentation
- Celebrate! 🎉

---

## ✅ Final Checklist

Before considering migration complete:

- [ ] New pricing files added to `configuration.yaml`
- [ ] Legacy sensors replaced with migrated file
- [ ] All dashboard references updated
- [ ] All Node-RED flows tested
- [ ] All automations checked
- [ ] Home Assistant restarted successfully
- [ ] Zero deprecation warnings in Repairs
- [ ] All sensors showing data (not "unavailable")
- [ ] Price calculations verified correct
- [ ] Power monitoring sensors working
- [ ] Tehomaksu protection still active
- [ ] Backups created of old configuration
- [ ] Documentation updated

---

## 📚 Related Documentation

- **[PRICING_MANAGEMENT.md](./PRICING_MANAGEMENT.md)** - How to update centralized pricing constants
- **[PRICING_GUIDE.md](./PRICING_GUIDE.md)** - Complete electricity pricing documentation
- **[COMPATIBILITY.md](./COMPATIBILITY.md)** - HA 2026.2.x compatibility details
- **[DASHBOARD.md](./DASHBOARD.md)** - Dashboard configuration guide

---

**Last Updated:** January 2025  
**HA Version:** 2026.2.x  
**Status:** Migration Required Before 2026.6 ⚠️
