# 🚀 Quick Start: Complete System Migration

**3 migrations to complete your professional power management system**

---

## ⚡ Migration Priority

### 1. Legacy Sensors (URGENT - 15 min) ⚠️
**Deadline:** HA 2026.6  
**Risk:** System will break if not completed

```bash
# Quick fix
1. Add new pricing files to configuration.yaml
2. Replace old sensors.yaml
3. Update dashboard references
4. Restart HA
```

👉 **[QUICK_MIGRATION.md](./QUICK_MIGRATION.md)** - Start here!

---

### 2. Heating Automations (30-45 min) 🔥
**Replace:** 6 YAML automations → Node-RED flows  
**Benefit:** Better control, power management integration

```bash
# Migration steps
1. Verify Node-RED flows installed
2. Test Node-RED in parallel (30 min)
3. Disable YAML automations
4. Monitor for 24h
```

👉 **[HEATING_MIGRATION_GUIDE.md](./HEATING_MIGRATION_GUIDE.md)** - Complete guide

**Automations to disable:**
- ✅ Lämmityksen automaatio - Pois
- ✅ Lämmityksen automaation - Päälle
- ✅ Set device start time
- ✅ Set device end time
- ✅ Lämmitys automaatiot - päälle/pois

**Keep enabled:**
- ⚠️ Presence: Somebody arrives home (keep!)
- ⚠️ Presence: Everybody leaves home (keep!)

---

### 3. ApexCharts Dashboard (15 min) 📊
**Update:** 2 electricity charts  
**Benefit:** Modern sensors, simpler config, accurate prices

```bash
# Chart upgrades
1. Chart 1: 24h electricity price → Use electricity_total_price_cents
2. Chart 2: 7-day price & consumption → Remove deprecated sensors
```

👉 **[APEXCHARTS_UPGRADE_GUIDE.md](./APEXCHARTS_UPGRADE_GUIDE.md)** - New configs

**Charts to update:**
- Chart 1: Sähkön kokonaishinta 24h (remove hardcoded arrays)
- Chart 2: Sähkön kokonaishinta ja -kulutus 7d (use modern sensors)

---

## ✅ Quick Checklist

### Before Starting
- [ ] Backup all configurations
- [ ] Screenshot current states
- [ ] Document current temperature settings
- [ ] Note which automations are enabled

### Migration 1: Sensors (15 min)
- [ ] Add `electricity_pricing.yaml` to configuration.yaml
- [ ] Add `electricity_pricing_constants.yaml` to configuration.yaml
- [ ] Replace `old_configs/sensors.yaml` with migrated version
- [ ] Update dashboard sensor references
- [ ] Restart Home Assistant
- [ ] Verify: Settings → System → Repairs (should be empty)

### Migration 2: Heating (45 min)
- [ ] Verify Node-RED flows deployed
- [ ] Enable `input_boolean.power_management_active`
- [ ] Monitor both systems for 30 min
- [ ] Disable YAML heating automations (5 total)
- [ ] Keep presence automations enabled (2 total)
- [ ] Test heat pump responds to price changes
- [ ] Monitor for 24 hours

### Migration 3: Charts (15 min)
- [ ] Replace Chart 1 YAML (24h price)
- [ ] Replace Chart 2 YAML (7-day consumption)
- [ ] Verify charts show data
- [ ] Check prices match sensor values
- [ ] Test day/night tariff switching

---

## 🎯 Success Criteria

### You're Done When:
- ✅ **Zero deprecation warnings** in Settings → System → Repairs
- ✅ **All 5 heating automations disabled** (presence ones still enabled)
- ✅ **Node-RED controlling heating** based on price rank
- ✅ **Charts showing accurate prices** with modern sensors
- ✅ **System stable for 24 hours** with no errors

---

## 📊 Expected Results

### Migration 1: Sensors
- **Before:** 46 deprecation warnings ❌
- **After:** 0 warnings ✅
- **Time:** 15 minutes
- **Risk:** High (system breaks in 2026.6)

### Migration 2: Heating
- **Before:** 6 separate YAML automations ❌
- **After:** 1 integrated Node-RED system ✅
- **Time:** 30-45 minutes
- **Benefit:** Better optimization, load balancing, tehomaksu protection

### Migration 3: Charts
- **Before:** Hardcoded prices, deprecated sensors ❌
- **After:** Centralized constants, modern sensors ✅
- **Time:** 15 minutes
- **Benefit:** Easier maintenance, accurate calculations

---

## 🆘 Quick Troubleshooting

### Sensors Not Appearing
```
1. Check configuration.yaml includes
2. Check YAML syntax (Check Configuration)
3. Restart Home Assistant
4. Check logs for errors
```

### Heating Not Working
```
1. Verify input_boolean.power_management_active is ON
2. Check Node-RED deployed (green "deployed" message)
3. Check Node-RED debug panel for errors
4. Verify entity IDs correct
```

### Charts Show "No Data"
```
1. Check sensors exist (Developer Tools → States)
2. Verify sensor history enabled
3. Wait 5 minutes for data to populate
4. Check sensor has values (not "unavailable")
```

---

## 📚 Full Documentation

| Guide | Purpose | Time | Priority |
|-------|---------|------|----------|
| **[QUICK_MIGRATION.md](./QUICK_MIGRATION.md)** | Fix 46 sensor warnings | 15 min | 🚨 URGENT |
| **[LEGACY_SENSOR_MIGRATION.md](./LEGACY_SENSOR_MIGRATION.md)** | Detailed sensor migration | 30 min | 🚨 URGENT |
| **[HEATING_MIGRATION_GUIDE.md](./HEATING_MIGRATION_GUIDE.md)** | Replace YAML automations | 45 min | 🔥 HIGH |
| **[APEXCHARTS_UPGRADE_GUIDE.md](./APEXCHARTS_UPGRADE_GUIDE.md)** | Upgrade dashboard charts | 15 min | 📊 MEDIUM |
| **[PRICING_MANAGEMENT.md](./PRICING_MANAGEMENT.md)** | Update pricing constants | 5 min | ℹ️ INFO |
| **[DASHBOARD.md](./DASHBOARD.md)** | Complete dashboard setup | 30 min | ℹ️ INFO |

---

## 🎉 Benefits Summary

### Cost Savings
- ✅ **Tehomaksu protection:** 50-150€/year
- ✅ **Price optimization:** 100-200€/year
- ✅ **Load balancing:** Prevents fuse upgrades
- ✅ **Total estimated savings:** 150-350€/year

### System Improvements
- ✅ **Future-proof:** Works with HA 2026.6, 2027+
- ✅ **Centralized:** Single source for pricing
- ✅ **Professional:** Integrated power management
- ✅ **Maintainable:** Easier to update and modify

### User Experience
- ✅ **Visual flows:** Node-RED easier to understand
- ✅ **Real-time monitoring:** Live power tracking
- ✅ **Predictive:** Forecasts peaks and costs
- ✅ **Automated:** Less manual intervention

---

## ⏱️ Total Time Investment

| Migration | Time | Can Skip? | Risk if Skipped |
|-----------|------|-----------|-----------------|
| Sensors | 15 min | ❌ NO | System breaks HA 2026.6 |
| Heating | 45 min | ⚠️ Maybe | Miss optimization benefits |
| Charts | 15 min | ⚠️ Maybe | Charts break HA 2026.6 |
| **Total** | **75 min** | - | - |

**Recommended:** Complete all 3 migrations in one session (90 min total with testing)

---

## 🔄 Rollback Plan

If something goes wrong:

### Quick Rollback (5 min each)
```bash
# 1. Sensors
mv old_configs/sensors.yaml.backup old_configs/sensors.yaml
# Restart HA

# 2. Heating
# Re-enable disabled automations in HA UI
# Turn OFF input_boolean.power_management_active

# 3. Charts
# Restore old chart YAML from backup
```

### Full Restore
```bash
# All backups in: ~/ha-backup-YYYYMMDD/
cp ~/ha-backup-YYYYMMDD/* /config/
# Restart HA
```

---

## 📞 Need Help?

### Quick Checks
1. **Configuration valid?** Settings → System → Check Configuration
2. **Logs clean?** Settings → System → Logs
3. **Sensors exist?** Developer Tools → States
4. **Repairs empty?** Settings → System → Repairs

### Read Detailed Guides
- Sensor issues → [LEGACY_SENSOR_MIGRATION.md](./LEGACY_SENSOR_MIGRATION.md)
- Heating issues → [HEATING_MIGRATION_GUIDE.md](./HEATING_MIGRATION_GUIDE.md)
- Chart issues → [APEXCHARTS_UPGRADE_GUIDE.md](./APEXCHARTS_UPGRADE_GUIDE.md)

---

**Created:** February 2026  
**HA Version:** 2026.2.x  
**Status:** ✅ Ready to start migration
