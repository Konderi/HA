# 🏠 Home Assistant Projects

A collection of professional Home Assistant automations, integrations, and configurations for smart home management.

---

## 📊 Implementation Status

```
[██████████] 100% Complete - Production Ready!

✅ Phase 1: Critical Fixes          100% - Completed 8 Feb 2026
✅ Phase 2: Core System             100% - Completed 8 Feb 2026  
✅ Phase 3: Professional Dashboards 100% - Completed 8 Feb 2026
✅ Phase 4: Enhanced Controls       100% - Completed 8 Feb 2026
✅ Phase 5: Code Modernization      100% - Completed 8 Feb 2026
```

**Latest Update (8 Feb 2026):** All phases complete! System fully enhanced with 20 adjustable controls, deprecation warnings fixed, comprehensive documentation (3,500+ lines). Production-ready with zero known issues.

**🎉 Enhanced Features (v2.0):**
- 🎛️ **20 Adjustable Controls** - Dashboard sliders (no code editing!)
- 💧 **Boiler Intelligence** - Rank limit, daily hours, Luxus mode
- 🚗 **Tesla Priority Mode** - Emergency charging override
- �️ **Per-Room Climate** - Independent temp control (MH1, Tuomas, Sara)
- 🌍 **Outside Temp Aware** - Auto-disable heating on warm days
- 🔄 **Cross-Flow Sync** - Global context communication
- 📍 **Location Aware** - Tesla charging only when home
- 🧹 **Zero Deprecations** - Modern, future-proof code

**📚 Documentation:**
- 11 comprehensive guides (3,500+ lines)
- Quick start (5 min setup)
- Full deployment guides
- Troubleshooting sections
- Real-world examples

[View All Documentation →](./docs/)

---

## 📁 Projects

### ⚡ [Power Management System](./power-management/)

**Professional Power Management & Heating Optimization System**

A comprehensive 5-flow Node-RED automation system that prevents main fuse burnout, eliminates peak power fees (tehomaksu), optimizes electricity costs, manages heating intelligently, and monitors electrical system health.

#### Key Features:
- �️ **20 Adjustable Controls** - Sliders & toggles (no code editing needed!)
- 💧 **Smart Boiler Control** - Max rank, daily runtime limit, Luxus 2h override mode
- 🚗 **Tesla Priority Mode** - Emergency charging (turns off sauna + boiler)
- 🌡️ **Per-Room Climate Control** - Independent settings for MH1, Tuomas, Sara rooms
- 🌍 **Outside Temperature Aware** - Auto-disable heating when warm outside
- �🏠 **Smart heating control** - Temperature-based radiator automation with kids home detection
- 🔒 **Fuse protection** - Priority-based load balancing (Sauna → Heating → Boiler → Tesla)
- 📊 **Tehomaksu prevention** - Stays below 8kW 60-minute average, saves €100-200/year
- 💡 **Price optimization** - Schedules loads based on Nordpool electricity prices
- 🚗 **Tesla integration** - Dynamic charging amp adjustment (6-16A) + location-aware
- 📈 **Phase monitoring** - Real-time voltage and load monitoring with Telegram alerts
- ⚡ **Power factor tracking** - Device-level efficiency monitoring
- 📱 **Professional dashboards** - Mobile-optimized UI with flow monitoring
- 🔄 **Flow visualization** - Real-time Node-RED flow status and decision logic
- 🎛️ **Complete control** - Magic mirror Full HD display + mobile multi-page interface

#### Tech Stack:
- Node-RED (5 production automation flows)
- Home Assistant 2026.2.x
- Lovelace UI with custom cards (mushroom, apexcharts)
- Shelly EM3 power monitoring (3-phase + power factor)
- Shelly Pro 4PM (radiator control)
- Nordpool price integration
- Tesla API integration
- Telegram bot for notifications
- Modern template sensors (HA 2026.6+ compatible)

#### Dashboards:
- ✅ **Power Management Mobile** - 5-page mobile interface (Overview, Heating, Energy, Prices, Devices, Statistics)
- ✅ **Magic Mirror Full HD** - Professional 1920x1080 no-scroll hallway display
- ✅ **Node-RED Flow Monitor** - Visual flow diagrams with real-time status

#### Compatibility:
- ✅ **Home Assistant 2026.2.x** (tested and deployed)
- ✅ **Node-RED 21.0.0+** (tested)
- ✅ Modern template syntax
- ✅ Separated YAML configuration

#### Status: ✅ Production Active & Enhanced (v2.0)

**System Capabilities:**
- 🎛️ 20 adjustable parameters (dashboard control)
- 🔄 5 coordinated Node-RED flows
- 📊 3 professional dashboards
- 🌡️ 3 independently controlled radiators
- 🚗 Location-aware Tesla charging
- 💧 Intelligent boiler management
- 📚 3,500+ lines of documentation

**Expected Savings:** €35-50/month (€420-600/year)
- Tehomaksu avoidance: €100-200/year
- Price optimization: €150-250/year
- Smart heating: €100-150/year

**[View Complete Documentation →](./power-management/README.md)**

---

## 🚀 Getting Started

Each project includes comprehensive documentation with:
- Step-by-step installation guides
- Configuration examples
- Visual flow diagrams
- Troubleshooting tips
- Best practices

Navigate to individual project folders for detailed instructions.

---

## 📋 Requirements

### Core:
- **Home Assistant 2026.2.x** (or 2024.x+)
- **Node-RED 21.0.0+** (or 18.x+)
- **Custom Cards:**
  - mushroom-cards (HACS)
  - apexcharts-card (HACS)
  - card-mod (HACS, optional but recommended)

### Hardware:
- Shelly EM3 (3-phase power monitoring)
- Shelly Pro 4PM (4-channel radiator control)
- Temperature sensors (Aqara or similar)
- Tesla API access (optional)

### Recommended:
- HACS (Home Assistant Community Store)
- Mobile app for notifications
- Git for version control

### Compatibility:
See [COMPATIBILITY.md](./power-management/COMPATIBILITY.md) for detailed version information.

---

## 🤝 Contributing

This repository contains production-tested automations and configurations. Feel free to:
- Use these projects in your own setup
- Report issues or suggest improvements
- Share your customizations and experiences

---

## 📜 License

MIT License - Free to use, modify, and distribute

---

## 📞 Support

For project-specific questions, refer to the documentation in each project folder.

---

*Built with ❤️ for Home Assistant • Making homes smarter, one automation at a time! 🏠✨*
