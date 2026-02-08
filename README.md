# 🏠 Home Assistant Power Management System

**Advanced Phase 2 Power Management & Heating Automation**

[![Home Assistant](https://img.shields.io/badge/Home%20Assistant-2026.2.x-blue.svg)](https://www.home-assistant.io/)
[![Node-RED](https://img.shields.io/badge/Node--RED-3.x-red.svg)](https://nodered.org/)

---

## 📋 Overview

Professional power management system for Finnish households with dynamic electricity pricing (Nordpool). Features intelligent heating automation, load balancing, and comprehensive monitoring dashboards.

### Key Features

⚡ **Smart Power Management**
- Real-time 3-phase power monitoring
- Automatic load balancing
- Peak power limiting (15 kW)
- Priority device management

🌡️ **Intelligent Heating Control**
- Price-based ILP temperature automation (3 modes)
- Room-by-room radiator control
- Thermal mass optimization
- 15-25% heating cost reduction

💰 **Dynamic Price Optimization**
- Nordpool spot price integration
- 24-hour price ranking (1-24)
- Automatic device scheduling
- Cost tracking and reporting

📱 **Professional Dashboards**
- Desktop dashboard (5 pages)
- Mobile dashboard (7 views)
- Real-time monitoring
- Comprehensive statistics

🤖 **AI Integration**
- Power consumption reports
- Energy analysis with recommendations
- Heating optimization tips

📲 **iPhone Notifications**
- Power alerts
- Price notifications
- Heating mode changes
- Daily summaries

---

## 🚀 Quick Start

```bash
# 1. Clone repository
git clone https://github.com/konderi/HA.git
cd HA

# 2. Copy configuration files
scp config/sensors/*.yaml root@homeassistant:/config/sensors/
scp config/input_helpers/*.yaml root@homeassistant:/config/input_helpers/
scp config/automations/*.yaml root@homeassistant:/config/automations/

# 3. Copy dashboards
scp dashboards/*.yaml root@homeassistant:/config/dashboards/

# 4. Import Node-RED flows
# Open Node-RED → Menu → Import → Select files from nodered/flows/

# 5. Restart Home Assistant
```

**📖 Full guide:** `docs/deployment/QUICK_DEPLOY.md`

---

## 📂 Repository Structure

```
HomeAssistant/
├── docs/               # Documentation
├── config/             # HA Configuration
├── dashboards/         # Lovelace Dashboards
├── nodered/            # Node-RED Flows
├── ai/                 # AI Integration
├── scripts/            # Python Tools
└── archive/            # Old files
```

---

## 🌡️ ILP Climate Control

**3 Automatic Modes:**

| Mode | Rank | Temperature | Purpose |
|------|------|-------------|---------|
| 🔥 Boost | 1-6 | 24°C | Cheap hours |
| 🏠 Normal | 7-18 | 21°C | Mid-price |
| 🍃 Eco | 19-24 | 19°C | Expensive |

Expected savings: **15-25%** on heating costs

---

## 📊 Dashboards

- **Professional** (Desktop): 5 pages - Monitor, Control, Flows, Statistics, Settings
- **Mobile**: 7 views - Overview, Heating, Energy, Prices, Devices, Statistics, Settings

---

## 🔀 Node-RED Flows

9 automation flows:
- advanced-heating-automation
- price-based-optimizer
- priority-load-balancer
- peak-power-limiter
- basic-heating-schedule
- eco-mode
- room-temperature-control
- temperature-radiator-control
- phase-monitor-alerts

---

## 🤖 AI Assistant

Ask: "Give me a power report", "Analyze energy usage", "Optimize heating"

---

## 📲 Notifications

Automatic iPhone alerts for:
- High power consumption
- Peak warnings
- Price changes
- Heating modes
- Daily summaries

---

## 📈 Expected Results

- **Heating:** 15-25% reduction (€300-500/year)
- **Hot water:** 10-20% reduction (€100-200/year)
- **EV charging:** 20-30% reduction
- **Total:** €500-800/year savings

---

## 🆘 Documentation

- **Deployment:** `docs/deployment/`
- **Configuration:** `docs/configuration/`
- **Troubleshooting:** `docs/troubleshooting/`
- **Status:** `docs/status/`

---

## 📝 Version 2.0.0 (2026-02-09)

- ✅ Repository reorganization
- ✅ iPhone notifications
- ✅ HA AI integration
- ✅ Settings pages (mobile & desktop)
- ✅ ILP climate control (3 modes)
- ✅ Updated Node-RED flows
- ✅ Comprehensive documentation

---

**Repository:** https://github.com/konderi/HA  
**Last Updated:** 2026-02-09

*Built with ❤️ for the Finnish Home Assistant community*
