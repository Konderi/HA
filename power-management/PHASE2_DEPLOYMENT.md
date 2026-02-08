# 🚀 Phase 2 Deployment Guide

Complete guide for deploying intelligent power management automation with Node-RED flows.

---

## 📋 Prerequisites

✅ **Phase 1 Complete** - All template sensors working
✅ **Node-RED Installed** - Settings → Add-ons → Node-RED
✅ **Home Assistant Integration** - Node-RED can connect to HA

---

## 🎯 What Phase 2 Adds

### 5 Intelligent Automation Flows:

1. **Priority Load Balancer** - Prevents 3×25A fuse overload
2. **Peak Power Limiter** - Eliminates tehomaksu (peak power fees)
3. **Price-Based Optimizer** - Heat pump scheduling for cheap hours
4. **Phase Monitor & Alerts** - Voltage, imbalance, overload warnings
5. **Temperature-Based Radiator Control** - Smart backup heating (NEW!)

### Control Features:

- 🎚️ Adjustable temperature targets
- ⏰ Flexible heating schedules
- 👦👧 Kids home/away toggle
- 🔧 Manual override options
- 📊 Real-time status monitoring

---

## 📦 Step 1: Deploy Helper Entities (5 minutes)

### Option A: Using configuration.yaml

1. Open `/config/configuration.yaml`
2. Add this line (if not already present):
   ```yaml
   input_boolean: !include power-management/phase2_helpers.yaml
   input_number: !include power-management/phase2_helpers.yaml
   input_datetime: !include power-management/phase2_helpers.yaml
   ```

3. **OR** if using packages, add:
   ```yaml
   homeassistant:
     packages:
       phase2_helpers: !include power-management/phase2_helpers.yaml
   ```

### Option B: Copy helper definitions

If you already have `input_boolean`, `input_number`, `input_datetime` sections, **copy the content** from `phase2_helpers.yaml` into your existing files.

### Verify Helper Creation:

1. Check Configuration: Developer Tools → YAML → Check Configuration
2. Restart Home Assistant
3. Verify helpers exist:
   - Settings → Devices & Services → Helpers
   - Search for "kids_home", "mh1_target_temp", etc.

---

## 🔄 Step 2: Import Node-RED Flows (15 minutes)

### 2.1 Access Node-RED

1. Open Node-RED: Settings → Add-ons → Node-RED → Open Web UI
2. Or navigate to: `http://homeassistant.local:1880`

### 2.2 Configure Home Assistant Connection

1. Click hamburger menu (☰) → **Manage palette**
2. Go to **Install** tab
3. Search for: `node-red-contrib-home-assistant-websocket`
4. Click **Install** (if not already installed)
5. Go back to main flow editor
6. Add a "server" node configuration:
   - Server name: `home_assistant`
   - Base URL: Leave default (auto-detects)
   - Access token: Will be auto-generated

### 2.3 Import Flows

**Import these 5 flows in order:**

#### Flow 1: Priority Load Balancer (CRITICAL - Import First!)

1. Open file: `power-management/flows/priority-load-balancer.json`
2. Copy entire content
3. In Node-RED: Hamburger menu → Import → Clipboard
4. Paste JSON → Import
5. Click **Deploy**

**What it does:**
- Monitors total power consumption
- Prevents fuse overload (17,250W max)
- Priority: Sauna > Heat Pump > Tesla > Boiler > Radiators
- Emergency reduction at 95% capacity
- Automatic rebalancing when devices turn off

#### Flow 2: Temperature-Based Radiator Control (NEW!)

1. Open file: `power-management/flows/temperature-radiator-control.json`
2. Copy content → Import → Deploy

**What it does:**
- **MH1:** Only heats 22:00-07:00, adjustable target temp
- **Kids Rooms:** Only heats when kids home, keeps > 18°C
- Temperature hysteresis prevents rapid cycling
- Manual override available for MH1
- Automatic shutdown when kids away

#### Flow 3: Peak Power Limiter (Tehomaksu Protection)

1. Open file: `power-management/flows/peak-power-limiter.json`
2. Copy content → Import → Deploy

**What it does:**
- Monitors 60-minute rolling average
- Prevents monthly peak fees (keeps < 8kW)
- Predictive algorithm (5/10/15/30 min forecasts)
- Gentle load reduction with minimal disruption
- Monthly peak tracking

#### Flow 4: Price-Based Optimizer

1. Open file: `power-management/flows/price-based-optimizer.json`
2. Copy content → Import → Deploy

**What it does:**
- Heat pump temperature control based on Nordpool prices
- 6 cheapest hours = boost temperature
- 6 most expensive hours = reduce temperature
- Water boiler scheduling during cheap hours
- Configurable via sliders

#### Flow 5: Phase Monitor & Alerts

1. Open file: `power-management/flows/phase-monitor-alerts.json`
2. Copy content → Import → Deploy

**What it does:**
- Monitors phase voltages (<200V = critical)
- Overload warnings (>85% capacity)
- Phase imbalance detection
- Device state notifications
- Daily energy summaries

### 2.4 Verify Flow Connections

After importing all flows:

1. Check each flow tab is enabled (not greyed out)
2. Look for error indicators (red triangles)
3. If errors: Double-click node → Configure → Save
4. Click **Deploy** again

---

## 🎛️ Step 3: Add Dashboard Control (5 minutes)

1. Go to your Lovelace dashboard
2. Edit dashboard (three dots → Edit Dashboard)
3. Add new card → Manual
4. Copy content from: `lovelace_radiator_control_card.yaml`
5. Paste and save

**You'll see:**
- Kids home toggle
- Room temperatures
- Radiator switches
- Temperature targets
- Heating schedules
- Status overview

---

## ✅ Step 4: Initial Configuration (5 minutes)

### Set Your Preferences:

1. **Kids Status:**
   - Toggle `input_boolean.kids_home` based on current week

2. **Kids Rooms:**
   - Min temp: 18°C (default)
   - Target temp: 19°C (default)

3. **Master Bedroom (MH1):**
   - Target temp: 20°C (adjust to preference)
   - Start time: 22:00 (when you go to bed)
   - End time: 07:00 (when you wake up)
   - Manual override: OFF (use only for special occasions)

4. **Heat Pump (if using price optimizer):**
   - Set temperature sliders in HA for cheap/normal/expensive hours

---

## 🧪 Step 5: Testing (10 minutes)

### Test 1: Kids Home Toggle

1. Toggle `input_boolean.kids_home` to **ON**
2. Check if kids' room temps are below 18°C
3. Radiators should turn ON automatically
4. Toggle to **OFF** → Radiators should turn OFF immediately

### Test 2: MH1 Schedule

1. Temporarily change `mh1_start_time` to current time
2. Wait 1 minute
3. If temp < target, MH1 should turn ON
4. Reset schedule to 22:00

### Test 3: Priority Load Balancer

1. Turn on Sauna (if available)
2. Check if boiler turns OFF automatically
3. Check if Tesla charging reduces (if connected)

### Test 4: Temperature Hysteresis

1. Set MH1 target to current temp + 1°C
2. Radiator should turn ON
3. When temp reaches target, should turn OFF
4. Should not rapidly cycle on/off

---

## 📊 Step 6: Monitoring (Ongoing)

### What to Watch:

**First 24 Hours:**
- Check room temperatures stay within targets
- Verify radiators turn on/off at correct times
- Monitor power consumption doesn't exceed 17,250W
- Look for Node-RED errors in debug panel

**First Week:**
- Kids rooms maintain comfort when home
- MH1 stays warm at night
- No fuse trips or overload warnings
- Heat pump handles primary heating efficiently

**Weekly Tasks:**
- Toggle kids_home switch on changeover day
- Review energy consumption trends
- Adjust temperature targets if needed

---

## 🔧 Troubleshooting

### Radiators Not Turning On:

**Check:**
1. Helper entities exist (Settings → Helpers)
2. Temperature sensors have valid values
3. Schedule is active (for MH1)
4. Kids home = ON (for kids' rooms)
5. Node-RED flows are deployed and enabled

**Debug:**
- Node-RED → Click "bug" tab (right sidebar)
- Enable debug nodes in flow
- Watch for temperature readings and decision logic

### Radiators Won't Turn Off:

**Check:**
1. Current temp ≥ target temp
2. Hysteresis band (0.5°C for MH1, 0.3°C for kids)
3. Manual override OFF (for MH1)

### Node-RED Connection Issues:

1. Check HA integration: Node-RED → Configuration nodes
2. Verify server config has valid connection
3. Restart Node-RED add-on
4. Check HA logs for authentication errors

### Helper Entities Not Found:

1. Verify `phase2_helpers.yaml` is in `/config/power-management/`
2. Check configuration.yaml includes it
3. Run config check: Developer Tools → YAML
4. Restart Home Assistant

---

## 🎯 Expected Behavior Summary

### Normal Operation:

**Weekdays (Kids Home):**
- MH1: Heats 22:00-07:00 to 20°C
- Tuomas/Sara: Keep above 18°C anytime
- Heat pump: Primary heating all day
- Tesla: Charges when sauna off and power available
- Boiler: Runs during cheap hours only

**Weekdays (Kids Away):**
- MH1: Heats 22:00-07:00 to 20°C
- Tuomas/Sara: OFF (energy savings!)
- Heat pump: Primary heating all day
- Tesla: Charges when power available
- Boiler: Runs during cheap hours only

### Emergency Scenarios:

**Approaching Fuse Limit (>85%):**
1. Reduce Tesla charging (16A → 12A → 8A → 6A)
2. Turn off boiler if on
3. Turn off kids radiators (if on)
4. Keep MH1 if needed for comfort
5. Alert sent

**Sauna Turns ON:**
1. Turn off boiler immediately
2. Reduce Tesla to 8A or OFF
3. Keep heat pump running
4. Radiators controlled normally

**Power Spike (>95%):**
1. Emergency reduction
2. Tesla to minimum (6A) or OFF
3. Boiler OFF
4. All radiators OFF temporarily
5. Critical alert sent

---

## 📈 Performance Metrics

### Energy Savings Expected:

- **Kids away week:** ~40-50 kWh saved (no kids' room heating)
- **MH1 schedule:** ~15-20 kWh/week saved (day = no heat)
- **Price optimization:** ~20-30% cost reduction (heat pump timing)
- **Peak avoidance:** €16-24/month saved (no tehomaksu fees)

### Comfort Maintained:

- All rooms stay within ±1°C of target
- No cold bedrooms at night
- Kids' rooms comfortable when home
- Heat pump provides consistent background heating

---

## 🎉 Phase 2 Complete!

You now have:

✅ 5 intelligent automation flows
✅ Temperature-based radiator control
✅ Kids home/away energy management
✅ MH1 night-only heating
✅ Fuse overload protection
✅ Peak power fee elimination
✅ Price-optimized heat pump control
✅ Phase monitoring and alerts
✅ Dashboard control panel

### What's Next?

**Phase 3 Preview (Optional):**
- Advanced energy analytics dashboard
- Device-by-device consumption tracking
- Automated reporting and insights
- Cost analysis per device
- Energy efficiency recommendations

**Let the system run for 1 week before Phase 3!**

---

## 📞 Support

If you encounter issues:

1. Check Node-RED debug panel
2. Review HA logs (Settings → System → Logs)
3. Verify all helper entities exist
4. Test flows individually
5. Check this guide's troubleshooting section

**System is working when:**
- No errors in Node-RED debug
- Radiators turn on/off automatically
- Power stays under 17,250W
- Kids rooms only heat when home
- MH1 heats only at night (22:00-07:00)

Enjoy your intelligent power management system! 🚀
