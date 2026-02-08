# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-02-09

### 🎉 Major Release - System Enhancement & Reorganization

### Added

#### 📁 Repository Reorganization
- **New directory structure** with logical organization:
  - `docs/` - All documentation (deployment, configuration, troubleshooting, status)
  - `config/` - HA configurations (sensors, input_helpers, automations, notify)
  - `nodered/` - Node-RED flows and documentation
  - `dashboards/` - Lovelace dashboards
  - `ai/` - AI conversation configuration and prompts
  - `scripts/` - Python validation tools
  - `archive/` - Old configuration files
- **Comprehensive README files** for each directory
- **REORGANIZATION_PLAN.md** - Complete reorganization documentation
- **reorganize.sh** - Automated file migration script
- Moved 30+ files to organized locations

#### 📲 iPhone Notifications
- **config/notify/ios_notify.yaml** - iPhone 17 notification service
- **config/automations/notifications.yaml** - 12+ notification automations:
  - High power consumption alerts (> 12 kW)
  - Approaching peak limit warnings (> 13.5 kW)
  - Cheap electricity notifications (Rank 1-3)
  - Expensive electricity alerts (Rank 22-24)
  - Heating mode changes (Boost/Eco)
  - Tesla charging status
  - Daily energy summaries (22:00)
  - Phase imbalance warnings
  - Sauna ready notifications
  - Holiday mode toggles
- Action buttons for interactive notifications
- Critical alerts for urgent situations

#### 🤖 HA AI Integration
- **ai/conversation_config.yaml** - Conversation agent configuration
- **ai/prompts/power_report.yaml** - Power consumption report template (80 lines)
  - Current power status, price rank, heating mode
  - Daily consumption and costs
  - Tesla charging status
  - Personalized recommendations
- **ai/prompts/energy_analysis.yaml** - Energy analysis template (150 lines)
  - Consumption patterns with day-over-day comparison
  - Cost efficiency analysis
  - Heating efficiency metrics
  - 5 personalized recommendations
  - Optimization score (0-100)
- **ai/prompts/heating_optimization.yaml** - Heating optimization template (350+ lines)
  - Current heating configuration
  - Temperature settings for all modes
  - Efficiency analysis (COP, heat loss)
  - 6 optimization recommendations
  - Room-by-room analysis
  - Seasonal recommendations
  - Heating performance score (0-100)
- Local AI processing (no cloud/external APIs)

#### ⚙️ Dashboard Enhancements
- **Settings pages** in both dashboards:
  - Professional dashboard: Full settings page (line 831-1380)
  - Mobile dashboard: Settings view (line 876-1007)
- **ILP Climate sections** updated with price-based mode labels:
  - Boost mode (Rank 1-6, 24°C)
  - Normal mode (Rank 7-18, 21°C)
  - Eco mode (Rank 19-24, 19°C)
- All 90+ input helpers accessible from Settings pages

#### 🌡️ ILP Climate Control
- **7 input number helpers** for ILP climate:
  - `tehostuslampo` - Boost temp (20-28°C, default 24°C) for Rank 1-6
  - `normaalilampo_presence` - Normal temp (18-26°C, default 21°C) for Rank 7-18
  - `lamponpudotus_presence` - Eco temp (16-22°C, default 19°C) for Rank 19-24
  - Plus 4 additional ILP settings (maintenance, request, max_rank, outside trigger)
- Clear descriptions with price rank ranges
- Proper icons (mdi:fire, mdi:home-thermometer-outline, mdi:leaf)

### Changed

#### 🔀 Node-RED Updates
- **price-based-optimizer.json** - Fixed helper variable names:
  - Line ~64: Changed temperature variable initialization
  - `tempExpensive` → `tempBoost` (now correctly references `tehostuslampo`)
  - `tempNormal` → unchanged (correctly references `normaalilampo_presence`)
  - `tempCheap` → `tempEco` (now correctly references `lamponpudotus_presence`)
  - Updated logic section to use new variable names
  - Added comments clarifying rank ranges (1-6, 7-18, 19-24)
- All flows validated against live HA entities

#### 📝 Documentation
- **README.md** - Complete rewrite with:
  - Project overview and key features
  - Quick start guide
  - Repository structure diagram
  - ILP climate control table
  - Dashboard descriptions
  - Node-RED flow list
  - AI integration examples
  - iPhone notifications list
  - Expected cost savings breakdown
  - Version history
- **README files** for all major directories (config/, nodered/, dashboards/, ai/)
- **CHANGELOG.md** - This file

### Fixed
- Node-RED flow using wrong helper for eco temperature
- Incorrect helper variable names in price-based optimizer
- Repository disorganization - files now logically grouped
- Missing comprehensive documentation
- No notification system for power events

### Security
- All AI processing is local (no external APIs)
- No data sent to cloud services
- iPhone notifications use HA Companion App (secure)

## [1.0.0] - 2025-12-XX

### Added - Phase 2 Initial Implementation

#### Power Management
- Real-time 3-phase power monitoring (ShellyEM3)
- Peak power limiting (15 kW) with Node-RED
- Automatic load balancing
- Priority device management

#### Heating Automation
- Basic price-based ILP temperature control
- Room-by-room radiator control
- Thermal mass optimization
- Time-based heating schedules

#### Dashboards
- Professional dashboard (5 pages)
- Mobile dashboard (7 views)
- ApexCharts integration
- Real-time monitoring

#### Integrations
- Nordpool electricity pricing
- Spot-hinta.fi price ranking
- Tesla integration
- Mitsubishi ILP integration

#### Node-RED Flows
- 9 automation flows:
  - advanced-heating-automation
  - price-based-optimizer (initial version)
  - priority-load-balancer
  - peak-power-limiter
  - basic-heating-schedule
  - eco-mode
  - room-temperature-control
  - temperature-radiator-control
  - phase-monitor-alerts

#### Configuration
- 90+ input helpers (sliders, toggles, dates)
- Electricity pricing sensors
- Input booleans for modes and overrides
- Input numbers for temperatures and thresholds

#### Documentation
- 20+ documentation files:
  - Deployment guides
  - Configuration guides
  - Troubleshooting guides
  - Status reports
- Python validation scripts

### Known Issues (Fixed in v2.0.0)
- Repository organization needed improvement
- No notification system
- No AI integration
- Node-RED flow used wrong helper name for eco temperature
- Missing comprehensive README

---

## Expected Benefits

### Cost Savings (Annual)
- **Heating:** 15-25% reduction → €300-500/year
- **Hot water:** 10-20% reduction → €100-200/year
- **EV charging:** 20-30% reduction → €100-200/year
- **Total:** €500-800/year savings

### Efficiency Improvements
- **Power management:** Automatic load balancing prevents peak charges
- **Heating optimization:** Price-based modes reduce costs during expensive hours
- **Phase balancing:** Improves grid connection efficiency
- **AI recommendations:** Personalized tips for continuous improvement

### User Experience
- **iPhone notifications:** Stay informed about power events
- **AI assistant:** Get instant reports and analysis
- **Professional dashboards:** Complete visibility and control
- **Organized repository:** Easy maintenance and updates

---

## Migration from v1.0.0 to v2.0.0

### Backup First
```bash
# Backup current config
cp -r /config /config_backup_v1
```

### Update Files
```bash
# Pull latest changes
git pull origin main

# Copy new configuration
scp config/**/*.yaml root@homeassistant:/config/
scp dashboards/*.yaml root@homeassistant:/config/dashboards/

# Import Node-RED flows
# Node-RED → Menu → Import → Select updated flows
```

### Configuration Changes
1. Add to `configuration.yaml`:
```yaml
# AI Conversation
conversation: !include ai/conversation_config.yaml

# iPhone Notifications
notify: !include config/notify/ios_notify.yaml

# New Automations
automation: !include_dir_merge_list config/automations/
```

2. Install Home Assistant Companion App on iPhone

3. Restart Home Assistant

4. Test:
   - Ask AI: "Give me a power report"
   - Trigger notification: Turn on high power device
   - Check Settings pages in both dashboards

### Verification
```bash
# Run validation script
python3 scripts/validate_config.py

# Check HA logs
# Settings → System → Logs
```

---

## Roadmap

### Planned for v2.1.0
- [ ] Add presence detection automation
- [ ] Weather forecast integration for heating
- [ ] Advanced Tesla charging optimization
- [ ] Improved phase balancing algorithm
- [ ] Web-based configuration UI

### Planned for v3.0.0
- [ ] Machine learning for consumption prediction
- [ ] Integration with solar panels
- [ ] Battery storage optimization
- [ ] Multi-home support
- [ ] Mobile app enhancements

---

## Support

- **Issues:** Create issue on GitHub
- **Documentation:** See `docs/` directory
- **Community:** Home Assistant forums

---

**Repository:** https://github.com/konderi/HA  
**Maintained by:** konderi  
**Last Updated:** 2026-02-09
