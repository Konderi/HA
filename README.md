# 🏠 Home Assistant Projects

A collection of professional Home Assistant automations, integrations, and configurations for smart home management.

---

## 📊 Implementation Status

```
[████████▱▱] 80% Complete

✅ Phase 1: Critical Fixes         100% - Completed 8 Feb 2026
✅ Phase 2: Core System            100% - Completed 8 Feb 2026
✅ Phase 3: Professional Dashboards 100% - Completed 8 Feb 2026
⬜ Phase 4: AI Enhancement          0% - Not Started
⬜ Phase 5: Testing & Validation   20% - In Progress
```

**Latest Update:** Phase 2 & 3 complete - All 5 Node-RED flows deployed and operational, professional mobile dashboard created, Node-RED flow monitoring dashboard added. System actively managing power, heating, and Tesla charging.

**Active Features:**
- 🏠 Temperature-based radiator control (Kids home toggle working)
- ⚖️ Priority load balancer (Tesla amp adjustment 6-16A)
- ⚡ Peak power limiter (Tehomaksu prevention <8kW)
- 💰 Price-based heat pump optimizer
- 📡 Phase monitoring with alerts
- 📱 Professional mobile dashboard (5 pages)
- 🔄 Node-RED flow monitoring dashboard

[View Detailed Progress →](./power-management/IMPLEMENTATION_PROGRESS.md) | [View Master Plan →](./power-management/MASTER_IMPLEMENTATION_PLAN.md)

---

## 📁 Projects

### ⚡ [Power Management System](./power-management/)

**Professional Power Management & Heating Optimization System**

A comprehensive 5-flow Node-RED automation system that prevents main fuse burnout, eliminates peak power fees (tehomaksu), optimizes electricity costs, manages heating intelligently, and monitors electrical system health.

#### Key Features:
- 🏠 **Smart heating control** - Temperature-based radiator automation with kids home detection
- 🔒 **Fuse protection** - Priority-based load balancing (Sauna → Heating → Boiler → Tesla)
- 📊 **Tehomaksu prevention** - Stays below 8kW 60-minute average, saves €100-200/year
- 💡 **Price optimization** - Schedules heat pump based on Nordpool electricity prices
- 🚗 **Tesla integration** - Dynamic charging amp adjustment (6-16A) based on load
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

#### Status: ✅ Production Active

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
