# 🏠 Professional Power Management & Heating Optimization System

A complete, production-ready Node-RED automation system for Home Assistant featuring intelligent power management, tehomaksu (peak power fee) elimination, and advanced heating optimization.

** 4 Integrated Flows** | **📊 Professional Dashboard** | **⚡ Real-time Monitoring** | **🎛️ Complete Control**

---

## ⚠️ URGENT: Legacy Sensor Migration Required

**If you have deprecation warnings about template sensors**, you need to migrate before HA 2026.6:

🚨 **46+ legacy sensors will stop working in HA 2026.6**

**Quick Fix (15 min):**
1. Add new pricing files to `configuration.yaml`
2. Replace old `sensors.yaml` with migrated version
3. Update dashboard sensor references
4. Restart Home Assistant

👉 **See [QUICK_MIGRATION.md](QUICK_MIGRATION.md) for 3-step fix**  
👉 **See [LEGACY_SENSOR_MIGRATION.md](LEGACY_SENSOR_MIGRATION.md) for detailed guide**

**Benefits:**
- ✅ No more deprecation warnings (46 → 0)
- ✅ System won't break in HA 2026.6
- ✅ Centralized pricing constants (easier updates)
- ✅ More accurate price calculations
- ✅ Future-proof for HA 2027+

---

## 🔋 Power Management System

Complete intelligent power management to prevent fuse overload, eliminate peak power fees, and optimize energy costs:

### 1. Priority Load Balancer
- **Prevents 3×25A fuse overload** with dynamic load management
- **Sauna priority** - Automatically reduces other devices when sauna is on
- **Smart Tesla charging** - Dynamic amperage adjustment (16A→12A→8A→6A)
- **Water boiler coordination** - Runs during cheapest electricity hours
- **Real-time phase monitoring** - Prevents single phase overload

### 2. Peak Power Limiter (Tehomaksu Protection) ⚡ NEW!
- **Monitors 60-minute rolling average** - Tracks power consumption continuously
- **Prevents monthly peak fees** - Keeps consumption under 8 kW threshold
- **Predictive algorithm** - Forecasts peaks 5/10/15/30 minutes ahead
- **Intelligent reduction** - Minimal disruption, prioritizes user comfort
- **Monthly tracking** - Reports peak usage trends

### 3. Price-Based Optimizer
- **Heat pump control** - 6/12/6 hour temperature optimization based on electricity prices
- **Rank-based scheduling** - Uses Nordpool price rankings (1=cheapest, 24=most expensive)
- **Configurable via sliders** - Adjust temperatures and schedules without editing flows
- **Water boiler tracking** - Ensures minimum 2-4 hours during cheap hours
- **Garage heater** - Battery protection during 6 cheapest hours (ready for future)

### 4. Phase Monitor & Alerts
- ⚠️ Phase voltage alerts (<200V)
- 🚨 Overload warnings (>85% capacity)
- ⚠️ Phase imbalance detection
- 💧 Device state notifications
- 📊 Daily energy summaries

👉 **See [POWER_MANAGEMENT_GUIDE.md](POWER_MANAGEMENT_GUIDE.md) for details**  
👉 **See [TEHOMAKSU_GUIDE.md](TEHOMAKSU_GUIDE.md) for peak power protection** ⚡  
👉 **See [DASHBOARD.md](DASHBOARD.md) for professional control panel setup** 🎛️

---

## 🔄 Migration Guides

### Heating Automation Migration 🔥
Replace old YAML heating automations with Node-RED flows:
- **Step-by-step guide** - Disable old automations, test Node-RED flows
- **6 automations** - All heating logic moved to Node-RED
- **Better control** - Priority-based, price-optimized heating
- **30-45 min** - Complete migration time including testing

👉 **See [HEATING_MIGRATION_GUIDE.md](HEATING_MIGRATION_GUIDE.md) for complete instructions**

### ApexCharts Dashboard Upgrade 📊
Upgrade electricity price charts to use modern sensors:
- **2 charts upgraded** - 24h price chart + 7-day consumption chart
- **Removes hardcoded prices** - Uses centralized pricing constants
- **Future-proof** - Compatible with HA 2026.6+
- **Simpler config** - No complex JavaScript calculations

👉 **See [APEXCHARTS_UPGRADE_GUIDE.md](APEXCHARTS_UPGRADE_GUIDE.md) for chart configurations**

### Legacy Sensor Migration ⚠️
Fix 46+ deprecated template sensor warnings:
- **Critical deadline** - Must complete before HA 2026.6
- **15-minute fix** - Quick migration with step-by-step guide
- **Zero warnings** - Clean system after migration
- **Better accuracy** - Centralized pricing, day/night auto-detection

👉 **See [QUICK_MIGRATION.md](QUICK_MIGRATION.md) for fast fix**  
👉 **See [LEGACY_SENSOR_MIGRATION.md](LEGACY_SENSOR_MIGRATION.md) for detailed guide**

---

## 🎛️ Professional Control Panel

Complete Lovelace dashboard for monitoring and controlling the entire system:

### Power Management Dashboard
- **Real-time power monitoring** - Live phase power, total consumption, 60-min average
- **Peak power tracker** - Current month peak, projected fees, intervention counter
- **System status cards** - Load balancer state, peak limiter active, optimizer mode
- **Quick controls** - Override switches, emergency controls, manual mode toggles
- **Historical graphs** - 24-hour power consumption, peak history, cost trends

### Configuration Controls
- **Temperature sliders** - Boost/Normal/Eco temperatures for heat pump
- **Threshold adjustments** - Peak power limit, warning levels, price rank settings
- **Device priorities** - Enable/disable automation per device
- **Notification settings** - Alert levels, quiet hours, report frequency

### Statistics & Reports
- **Daily summary** - Peak power, interventions, system health
- **Monthly overview** - Tehomaksu charges, efficiency metrics
- **Device runtime** - Usage hours per device, cost breakdown
- **Optimization score** - System efficiency rating, recommendations

👉 **See [DASHBOARD.md](DASHBOARD.md) for complete YAML configuration and setup instructions**

### Professional ApexCharts Dashboards 📊
- **6 advanced charts** - Multi-metric analysis, power factor monitoring, heatmaps
- **Power quality tracking** - Real-time efficiency metrics per device and phase
- **Interactive visualizations** - Zoom, pan, export, gradient fills, annotations
- **Pattern recognition** - Weekly heatmaps reveal optimization opportunities
- **Device analytics** - Compare power factor across heating devices

👉 **See [PROFESSIONAL_APEXCHARTS.md](PROFESSIONAL_APEXCHARTS.md) for advanced chart configurations**  
👉 **See [VISUAL_CHARTS_GUIDE.md](VISUAL_CHARTS_GUIDE.md) for visual mockups and examples**  
👉 **See [AI_POWER_MANAGEMENT.md](AI_POWER_MANAGEMENT.md) for intelligent reporting and analysis** 🤖

---

## 🌡️ Heating Automation Features

- **Schedule-based heating control** - Different temperatures for different times of day
- **Presence detection** - Automatically adjust heating when home/away
- **Weather-based adjustments** - Adapt heating based on outdoor temperature
- **Room-by-room control** - Independent temperature control per room
- **Override modes** - Manual control with automatic reset
- **Energy optimization** - Reduce heating during expensive electricity hours

## 📦 What's Included

### Core System (4 Flows)
1. **priority-load-balancer.json** (10.5 KB) - Fuse protection & device coordination
2. **peak-power-limiter.json** (15.2 KB) - Tehomaksu elimination & peak prevention
3. **price-based-optimizer.json** (8.7 KB) - Daily cost optimization
4. **phase-monitor-alerts.json** (9.2 KB) - System health monitoring

### Documentation (27 Guides)
- Complete technical documentation
- Step-by-step implementation guides  
- Professional dashboard setup 🎛️
- Migration guides (legacy sensors, heating, charts) 🔄
- Professional ApexCharts with power factor monitoring 📊
- Visual design guides with mockups �
- Troubleshooting and optimization

### Optional Extras (4 Flows)
- Advanced heating automation flows
- Room-by-room temperature control
- Eco mode and presence detection

**Total Setup Time:** 90 minutes | **Maintenance:** Zero

---

## 🚀 Quick Start

### 1. Prerequisites
```yaml
Required:
  ✓ Home Assistant (2023.x or newer)
  ✓ Node-RED add-on installed
  ✓ Telegram bot configured
  ✓ Shelly EM3 or equivalent power monitoring
  ✓ Nordpool integration (for price optimization)

Recommended:
  ✓ Tesla integration (for car charging control)
  ✓ Climate entity (heat pump/thermostat)
  ✓ Smart switches for high-power devices
```

### 2. Installation (30 minutes)
```bash
1. Read: IMPLEMENTATION_CHECKLIST.md
2. Import flows in order (1→2→3→4)
3. Deploy and verify
4. Set up dashboard (optional but recommended)
5. Monitor first 24 hours
```

### 3. Expected Results
```
Week 1:  First interventions, system learning
Month 1: System optimized, smooth operation
Year 1:  "Set and forget" automation! 🎉
```

---

## 🎯 Key Features

### Intelligent & Predictive
- **60-minute rolling average monitoring** - Not just instant power
- **Predictive algorithms** - Forecast peaks 5-30 minutes ahead
- **Machine learning ready** - Adapts to your usage patterns

### Safe & Reliable
- **Four-layer protection** - Safety → Economics → Comfort → Cost
- **Graceful degradation** - Works even if some sensors fail
- **Rate-limited alerts** - No notification spam
- **Emergency overrides** - Manual control always available

### User-Friendly
- **Professional dashboard** - Monitor everything at a glance
- **Clear notifications** - Know exactly what's happening and why
- **Configurable sliders** - Adjust settings without coding
- **Daily/monthly reports** - Track system performance automatically

### Production-Ready
- **All entity IDs configured** - Ready for your system
- **Error handling included** - Robust and stable
- **Comprehensive logging** - Easy troubleshooting
- **Tested integration** - All flows work together perfectly

---

## 🎛️ Professional Dashboard

A complete Lovelace dashboard provides centralized control and monitoring:

### Features:
- **Real-time metrics** - Current power, 60-min average, monthly peak
- **System status** - Visual indicators for all automation systems
- **Device control** - Quick toggles for sauna, car, boiler, heat pump
- **Interactive graphs** - 24-hour power consumption with ApexCharts
- **Financial tracking** - Monthly fees and intervention tracking
- **Configuration controls** - Adjust all thresholds and temperatures
- **Mobile optimized** - Responsive design for phone and tablet
- **Professional appearance** - Color-coded status, smooth animations

### Quick Setup:
1. Install required custom cards (HACS)
2. Copy helper entities to `configuration.yaml`
3. Import dashboard YAML from `DASHBOARD.md`
4. Customize colors and layout
5. Add to mobile app shortcuts

**Full instructions in [DASHBOARD.md](DASHBOARD.md)** 🎛️

---

## 📚 Documentation

### Quick Start
- **[IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)** - Step-by-step deployment guide
- **[PROJECT_COMPLETE.md](PROJECT_COMPLETE.md)** - Complete project summary
- **[COMPLETE_MIGRATION_GUIDE.md](COMPLETE_MIGRATION_GUIDE.md)** - Overview of all migrations 🔄

### Migration Guides 🔄
- **[QUICK_MIGRATION.md](QUICK_MIGRATION.md)** - ⚠️ URGENT: 15-min legacy sensor fix
- **[LEGACY_SENSOR_MIGRATION.md](LEGACY_SENSOR_MIGRATION.md)** - Detailed sensor migration (600+ lines)
- **[MIGRATION_SUMMARY.md](MIGRATION_SUMMARY.md)** - Migration status and checklist
- **[HEATING_MIGRATION_GUIDE.md](HEATING_MIGRATION_GUIDE.md)** - Replace YAML automations with Node-RED
- **[APEXCHARTS_UPGRADE_GUIDE.md](APEXCHARTS_UPGRADE_GUIDE.md)** - Modernize dashboard charts

### Professional Charts & Analytics 📊
- **[PROFESSIONAL_APEXCHARTS.md](PROFESSIONAL_APEXCHARTS.md)** - 6 advanced charts with power factor (1,050+ lines)
- **[VISUAL_CHARTS_GUIDE.md](VISUAL_CHARTS_GUIDE.md)** - Visual mockups and design patterns
- **[PROFESSIONAL_CHARTS_SUMMARY.md](PROFESSIONAL_CHARTS_SUMMARY.md)** - Quick reference guide
- **[DOCUMENTATION_SUMMARY.md](DOCUMENTATION_SUMMARY.md)** - Complete documentation index

### AI-Enhanced Features 🤖
- **[AI_POWER_MANAGEMENT.md](AI_POWER_MANAGEMENT.md)** - AI-powered reporting and analysis (NEW!)
  - Daily energy reports with natural language summaries
  - Weekly trend analysis and recommendations
  - Anomaly detection with explanations
  - Natural language queries and voice interface
  - Predictive optimization suggestions
  - Equipment health monitoring

### Core Guides
- **[POWER_MANAGEMENT_GUIDE.md](POWER_MANAGEMENT_GUIDE.md)** - Complete system documentation
- **[TEHOMAKSU_GUIDE.md](TEHOMAKSU_GUIDE.md)** - Peak power protection guide
- **[DASHBOARD.md](DASHBOARD.md)** - Professional control panel setup 🎛️

### Reference
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Daily use and troubleshooting
- **[FLOW_INTEGRATION_ANALYSIS.md](FLOW_INTEGRATION_ANALYSIS.md)** - How flows work together
- **[VISUAL_DIAGRAMS.md](VISUAL_DIAGRAMS.md)** - System architecture

### Setup & Configuration
- **[INSTALLATION.md](INSTALLATION.md)** - Installation steps
- **[CONFIGURATION.md](CONFIGURATION.md)** - Customization guide
- **[ALERT_RECOMMENDATIONS.md](ALERT_RECOMMENDATIONS.md)** - Alert types and enhancements

### Additional Info
- **[ADVANCED_EXAMPLES.md](ADVANCED_EXAMPLES.md)** - Advanced automation examples
- **[NODERED_VS_HA.md](NODERED_VS_HA.md)** - Why Node-RED vs YAML
- **[SUMMARY.md](SUMMARY.md)** - System overview
- **[FILE_STRUCTURE.md](FILE_STRUCTURE.md)** - Repository navigation

---

## 🏆 What Makes This System Special

### Industry-First Features:
- ✨ First open-source tehomaksu (peak power fee) prevention
- ✨ Predictive algorithm (prevents issues before they occur)
- ✨ Four-layer protection system (Safety → Economics → Comfort → Cost)
- ✨ Professional dashboard with real-time analytics
- ✨ Complete integration (all flows work together seamlessly)
- ✨ Power factor monitoring with device-level efficiency tracking 📊
- ✨ 6 professional ApexCharts with multi-metric analysis 📈
- ✨ Comprehensive migration guides for legacy systems 🔄

### Production Quality:
- ✅ All entity IDs pre-configured for your system
- ✅ Comprehensive error handling and recovery
- ✅ Rate-limited alerts (no spam)
- ✅ 27 detailed documentation guides (5,700+ lines)
- ✅ Mobile-optimized dashboard
- ✅ Tested and proven in real-world use
- ✅ Power factor monitoring for equipment health
- ✅ Visual design mockups and implementation guides

### User Experience:
- 🎯 Set up in 90 minutes
- 🎯 Zero maintenance required
- 🎯 Professional monitoring interface
- 🎯 Clear, actionable notifications
- 🎯 "Set and forget" reliability

---

## 🚀 Getting Started

### Step 1: Read the Docs (15 minutes)
```bash
1. README.md (this file) - Overview
2. COMPLETE_MIGRATION_GUIDE.md - Migration overview (if upgrading)
3. IMPLEMENTATION_CHECKLIST.md - Deployment steps
4. DASHBOARD.md - Control panel setup
5. PROFESSIONAL_APEXCHARTS.md - Advanced analytics (optional)
```

### Step 2: Import Flows (60 minutes)
```bash
1. priority-load-balancer.json - Safety first!
2. peak-power-limiter.json - Money saver!
3. price-based-optimizer.json - Cost optimizer
4. phase-monitor-alerts.json - Health monitoring
```

### Step 3: Set Up Dashboard (30 minutes)
```bash
1. Install custom cards (HACS)
2. Add helper entities
3. Import dashboard YAML
4. Customize and test
```

### Step 4: Professional Charts (60 minutes, optional but recommended)
```bash
1. Create power_quality_sensors.yaml (15 min)
2. Add Chart 1: 24h Price, Power & Efficiency (15 min)
3. Add Charts 2-4: Power factor analysis (15 min)
4. Add Charts 5-6: Heatmap & scatter plot (15 min)
```

### Step 5: Monitor & Enjoy
```bash
Day 1:   Watch it learn your patterns
Week 1:  First interventions visible
Month 1: System optimized, smooth operation
Year 1:  Complete automation achieved! 🎉
```

---

## ⚡ System Requirements

### Required:
- **Home Assistant 2026.2.x** (or 2024.x+, tested on 2026.2)
- **Node-RED add-on v21.0.0** (or newer)
- Shelly EM3 (or similar 3-phase power monitoring)
- Nordpool electricity price integration
- Telegram bot configured

### Recommended:
- Tesla integration (for car charging control)
- Climate entity (heat pump/thermostat)
- Smart switches for high-power devices (sauna, boiler)

### Optional:
- HACS (for custom dashboard cards)
- Mobile app (for notifications and quick access)

### Compatibility Notes:
- ✅ Uses modern template sensor syntax (HA 2021.4+)
- ✅ Compatible with separated YAML configuration files
- ✅ Lovelace dashboard uses current card specifications
- ✅ Node-RED flows compatible with v18.x - v21.x

---

## 📞 Support & Community

### Getting Help:
1. Check **QUICK_REFERENCE.md** for common issues
2. Review **IMPLEMENTATION_CHECKLIST.md** troubleshooting section
3. Enable Node-RED debug panel for detailed logs
4. Check entity IDs in Home Assistant Developer Tools

### Contributing:
- Report issues or suggest improvements via GitHub
- Share your dashboard customizations
- Document your usage patterns and savings

---

## 📜 License

MIT License - Free to use, modify, and distribute

---

## 🎉 Ready to Deploy

You now have everything for a **professional-grade power management system**:

- ✅ 4 intelligent automation flows
- ✅ 27 comprehensive documentation guides (5,700+ lines)
- ✅ Professional monitoring dashboard
- ✅ Complete control panel with all settings
- ✅ Mobile-optimized interface
- ✅ 6 professional ApexCharts with power factor monitoring
- ✅ AI-powered reporting and natural language analysis 🤖
- ✅ Complete migration guides for legacy systems
- ✅ Visual design mockups and patterns
- ✅ Zero ongoing maintenance

**Time to automate your home!** 🏠⚡

---

*Built with ❤️ for Home Assistant + Node-RED • Saving energy, one kilowatt at a time! 💚*

**Questions?** Start with [IMPLEMENTATION_CHECKLIST.md](IMPLEMENTATION_CHECKLIST.md)  
**Ready?** Let's deploy! 🚀
