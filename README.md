# 🏠 Home Assistant Projects

A collection of professional Home Assistant automations, integrations, and configurations for smart home management.

---

## � Implementation Status

```
[██▱▱▱▱▱▱▱▱] 20% Complete

✅ Phase 1: Critical Fixes         100% - Completed 8 Feb 2026
⬜ Phase 2: Core System             0% - Not Started
⬜ Phase 3: Professional Charts     0% - Not Started
⬜ Phase 4: AI Enhancement          0% - Not Started
⬜ Phase 5: Testing & Validation    0% - Not Started
```

**Latest Update:** Phase 1 complete - All legacy sensors migrated, new electricity pricing system deployed, zero deprecation warnings. System stable and ready for HA 2026.6+.

[View Detailed Progress →](./power-management/IMPLEMENTATION_PROGRESS.md) | [View Master Plan →](./power-management/MASTER_IMPLEMENTATION_PLAN.md)

---

## 📁 Projects

### ⚡ [Power Management System](./power-management/)

**Professional Power Management & Heating Optimization System**

A comprehensive 4-flow Node-RED automation system that prevents main fuse burnout, eliminates peak power fees (tehomaksu), optimizes electricity costs, and monitors electrical system health.

#### Key Features:
- 🔒 **Fuse protection** - Priority-based load balancing for high-power devices
- 📊 **Tehomaksu prevention** - Eliminates peak power fees through intelligent monitoring
- 💡 **Price optimization** - Schedules devices based on Nordpool electricity prices
- 📈 **Phase monitoring** - Real-time voltage and load monitoring with alerts
- ⚡ **Power factor tracking** - Device-level efficiency monitoring with 6 professional charts
- 🔄 **Migration guides** - Complete upgrade paths for legacy systems
- 🎛️ **Professional dashboard** - Complete Lovelace control panel with real-time analytics

#### Tech Stack:
- Node-RED (4 core automation flows)
- Home Assistant Lovelace UI
- Shelly EM3 power monitoring (with power factor sensors)
- Nordpool price integration
- Telegram notifications
- ApexCharts (6 professional visualization charts)
- Modern template sensors (HA 2026.6+ compatible)
- OpenAI/Claude/Gemini AI integration for intelligent reporting

#### Compatibility:
- ✅ **Home Assistant 2026.2.x** (tested)
- ✅ **Node-RED 21.0.0** (tested)
- ✅ Modern template syntax
- ✅ Separated YAML configuration support

#### Status: ✅ Production Ready

**[View Complete Documentation →](./power-management/README.md)**

---

## 🚀 Getting Started

Each project includes comprehensive documentation with:
- Step-by-step installation guides
- Configuration examples
- Troubleshooting tips
- Best practices

Navigate to individual project folders for detailed instructions.

---

## 📋 Requirements

### Core:
- **Home Assistant 2026.2.x** (or 2024.x+)
- **Node-RED 21.0.0** (or 18.x+)

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
