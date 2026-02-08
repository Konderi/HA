# ⚡ Quick Migration Cheat Sheet

## 🚨 URGENT: Fix 46 Deprecation Warnings

**Your legacy sensors will BREAK in HA 2026.6!**

---

## 🎯 3-Step Fix (15 minutes)

### Step 1: Add to `configuration.yaml`

```yaml
template: !include power-management/electricity_pricing.yaml
input_number: !include power-management/electricity_pricing_constants.yaml
```

### Step 2: Replace sensors file

```bash
mv old_configs/sensors.yaml old_configs/sensors.yaml.backup
cp power-management/legacy_sensors_migrated.yaml old_configs/sensors.yaml
```

### Step 3: Update dashboard references

Replace these in your Lovelace YAML:

```
sahkon_hinta_energydashboard → electricity_total_price_now
sahko_kokonaishinta_c → electricity_total_price_cents
shf_electricity_full_price_now → electricity_total_price_cents
sahko_siirtohinta → transfer_tariff_now
```

**Then restart Home Assistant!**

---

## 📊 Sensor Quick Reference

| Old Name (Remove) | New Name (Use) |
|-------------------|----------------|
| `sahkon_hinta_energydashboard` | `electricity_total_price_now` |
| `sahko_kokonaishinta_c` | `electricity_total_price_cents` |
| `sahko_siirtohinta` | `transfer_tariff_now` |
| `shf_electricity_full_price_charts` | `electricity_total_price_cents` |
| `shf_electricity_full_price_now` | `electricity_total_price_cents` |

---

## ✅ Quick Test

After restart, check these exist (Developer Tools → States):

- ✅ `sensor.electricity_total_price_now`
- ✅ `sensor.electricity_total_price_cents`  
- ✅ `sensor.transfer_tariff_now`
- ✅ No warnings in Settings → System → Repairs

---

## 🆘 Something Broke?

1. **Check configuration:** Settings → System → Check Configuration
2. **View logs:** Settings → System → Logs (search "template")
3. **Restore backup:** `mv old_configs/sensors.yaml.backup old_configs/sensors.yaml`
4. **Read full guide:** [LEGACY_SENSOR_MIGRATION.md](./LEGACY_SENSOR_MIGRATION.md)

---

## 🎉 Benefits

- ✅ No more deprecation warnings (46 → 0)
- ✅ Won't break in HA 2026.6
- ✅ Centralized pricing (easier to update)
- ✅ More accurate calculations
- ✅ Day/night tariff auto-detection

---

**Need detailed instructions?** Read [LEGACY_SENSOR_MIGRATION.md](./LEGACY_SENSOR_MIGRATION.md)
