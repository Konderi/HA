# 📊 Dashboard Deployment Guide

Quick reference for deploying all three professional dashboards to Home Assistant.

---

## 🎯 Three Dashboards Available

### 1. 📱 Power Management Mobile
**Purpose:** Primary control interface for daily use  
**File:** `dashboards/power-management-mobile.yaml`  
**Pages:** 6 views with navigation  
**Best For:** Mobile phones, tablets, daily monitoring

### 2. 🪞 Magic Mirror Full HD
**Purpose:** At-a-glance hallway display  
**File:** `dashboards/magic-mirror-fullhd.yaml`  
**Layout:** 3-column, no-scroll, 1920x1080  
**Best For:** Wall-mounted tablets, kiosk displays

### 3. 🔄 Node-RED Flow Monitor
**Purpose:** Flow visualization and troubleshooting  
**File:** `dashboards/nodered-flow-monitor.yaml`  
**Pages:** 5 flow diagrams with ASCII art  
**Best For:** Understanding automation logic, debugging

---

## 🚀 Quick Deployment

### Dashboard 1: Power Management Mobile (Primary)

**Step 1: Create Dashboard**
1. Open Home Assistant
2. Click **☰ Menu** → **Settings** → **Dashboards**
3. Click **+ ADD DASHBOARD** (bottom right)
4. Fill in:
   - **Title:** `Power Management` (or `Tehohallinta`)
   - **Icon:** `mdi:lightning-bolt`
   - **Show in sidebar:** ✅ Yes
   - **Admin only:** ☐ No
5. Click **CREATE**

**Step 2: Add Configuration**
1. Find your new dashboard in the sidebar
2. Click on it to open
3. Click **⋮** (top right) → **Edit Dashboard**
4. Click **⋮** (top right again) → **Raw Configuration Editor**
5. **DELETE** everything in the editor
6. Open `dashboards/power-management-mobile.yaml` in a text editor
7. **SELECT ALL** (Cmd+A / Ctrl+A) and **COPY**
8. **PASTE** into the Raw Configuration Editor
9. Click **SAVE** (bottom right)
10. Click **X** to close editor
11. Click **DONE** (top right)

**Step 3: Test**
- You should see the Overview page with navigation buttons
- Click "Heating" button → Should navigate to heating page
- Click back button → Returns to overview
- Try all 5 navigation buttons
- Test on mobile device

✅ **Success:** All navigation works, all cards visible, consistent theme

---

### Dashboard 2: Magic Mirror Full HD (Optional)

**Best If:** You have a wall-mounted tablet or hallway display

**Step 1: Create Dashboard**
1. **☰ Menu** → **Settings** → **Dashboards** → **+ ADD DASHBOARD**
2. Fill in:
   - **Title:** `Magic Mirror` (or `Käytävän Näyttö`)
   - **Icon:** `mdi:mirror`
   - **Show in sidebar:** ☐ No (kiosk mode)
   - **Admin only:** ☐ No
3. Click **CREATE**

**Step 2: Add Configuration**
1. Find "Magic Mirror" in sidebar (or go to `/lovelace-magic-mirror`)
2. **⋮** → **Edit Dashboard** → **⋮** → **Raw Configuration Editor**
3. Delete all, copy `dashboards/magic-mirror-fullhd.yaml`, paste, save

**Step 3: Kiosk Mode Setup (Optional)**
1. On your hallway tablet, open Home Assistant app
2. Go to the Magic Mirror dashboard
3. Enable full-screen mode (browser/app specific)
4. Set device to stay awake
5. Optional: Use `input_boolean.kiosk_mode` for hiding sidebar

✅ **Success:** Full HD display fits on screen without scrolling

---

### Dashboard 3: Node-RED Flow Monitor (Developer)

**Best If:** You want to understand or troubleshoot the Node-RED flows

**Step 1: Create Dashboard**
1. **☰ Menu** → **Settings** → **Dashboards** → **+ ADD DASHBOARD**
2. Fill in:
   - **Title:** `Node-RED Flows`
   - **Icon:** `mdi:sitemap`
   - **Show in sidebar:** ✅ Yes
   - **Admin only:** ☑ Yes (developer tool)
3. Click **CREATE**

**Step 2: Add Configuration**
1. Open "Node-RED Flows" dashboard
2. **⋮** → **Edit Dashboard** → **⋮** → **Raw Configuration Editor**
3. Delete all, copy `dashboards/nodered-flow-monitor.yaml`, paste, save

**Step 3: Explore**
- Overview page shows all 5 flow statuses
- Click flow buttons to see detailed flowcharts
- ASCII diagrams show decision logic
- Real-time entity states displayed
- Useful for learning how automation works

✅ **Success:** Flow diagrams visible, status indicators working

---

## 🎨 Dashboard Features

### Power Management Mobile

**Page 1: Overview**
- Current power, price, consumption gauges
- Quick navigation (5 labeled buttons with gradients)
- 7-day consumption vs price chart
- System status summary

**Page 2: Heating**
- Kids home toggle (prominent)
- Room controls (Tuomas, Sara, MH1)
- Temperature targets and schedules
- 24h temperature chart

**Page 3: Energy**
- Power gauge (0-17.25 kW)
- 7-day consumption analysis
- Phase current monitors
- Monthly statistics

**Page 4: Prices**
- 24h price chart (color-coded)
- Price breakdown (spot/transfer/total)
- Best charging windows
- Nordpool forecast

**Page 5: Devices**
- Tesla controls (switch, amps, battery)
- Heating devices (boiler, heat pump, sauna)
- Priority order explanation
- Device status

**Page 6: Statistics**
- Monthly cost gauge
- Daily/weekly/monthly consumption
- Cost tracking
- Trend analysis

---

### Magic Mirror Full HD

**LEFT COLUMN:**
- Large clock + date
- Tesla battery
- Outside temperature
- Frigate camera
- Today's calendar

**CENTER COLUMN:**
- Current power + price
- **7-day consumption vs price** (key!)
- 24h price chart
- Daily/monthly gauges

**RIGHT COLUMN:**
- Phase 2 radiator controls
- 24h temperature history
- Device switches
- Best charging window
- Sauna status (conditional)

---

### Node-RED Flow Monitor

**Overview Page:**
- Status table (✅ Active / ❌ Error)
- Quick navigation to flow details
- System health check
- Last update time

**Temperature Control Flow:**
```
ASCII flowchart showing:
- Kids home check
- Room-by-room control logic
- Temperature hysteresis (±0.5°C)
- Current states
```

**Priority Load Balancer:**
```
Priority order visualization:
1. Sauna (protected)
2. Heating (protected)
3. Boiler (medium)
4. Tesla (adjustable)

Capacity management display
Tesla adjustment logic
```

**Peak Power Limiter:**
```
60-minute average monitoring
Warning/critical thresholds
Reduction sequence
Tehomaksu calculator
```

**Price Optimizer:**
```
Price classification system
Heat pump control logic
Temperature adjustments
Optimization decisions
```

---

## 🔧 Troubleshooting

### "Some entities are not available"
- Check entity IDs in your HA match dashboard config
- Some sensors might be named differently
- Replace `sensor.xxx` names as needed in YAML

### Navigation doesn't work
- Paths fixed in latest version (commit 03a856a)
- Clear browser cache
- Ensure using `/power-management-mobile/page-name` format

### Cards not displaying
- Install required custom cards via HACS:
  - `mushroom` (Mushroom Cards)
  - `apexcharts-card`
  - `card-mod` (optional but recommended)
- Restart Home Assistant after installing

### Mobile layout issues
- Dashboards optimized for mobile (fill_container used)
- Try portrait and landscape modes
- Some cards may wrap on very small screens

### Flow monitor shows errors
- Check Node-RED flows are deployed
- Verify entities exist in HA
- Template sensors need to be available
- Check HA logs for template errors

---

## 📱 Mobile App Tips

### iOS/Android App
1. Open dashboard
2. Tap **⋮** → **Pin to Home Screen**
3. Choose icon and name
4. Quick access from phone home screen

### Notifications
- Enable notifications for alerts
- Priority balancer sends warnings
- Phase monitor sends voltage alerts
- Tesla battery notifications

### Widget Support
- Some entities can be added as widgets
- Quick glance at power/price
- Toggle kids_home from widget

---

## 🎯 Recommended Setup

**Daily Driver:** Power Management Mobile
- Main control interface
- Check morning/evening
- Adjust settings as needed

**Hallway Display:** Magic Mirror (optional)
- At-a-glance status
- No interaction needed
- Professional look

**Learning/Debugging:** Node-RED Flow Monitor
- Understand automation logic
- Troubleshoot issues
- Educational tool

---

## 📊 What to Monitor

### Daily (2 minutes)
1. Open Power Management dashboard
2. Check Overview page:
   - Current power (should be <8kW)
   - Current price (color indicator)
   - Any error messages
3. Verify kids_home toggle matches week schedule

### Weekly (5 minutes)
1. Go to Energy page
2. Check 7-day consumption vs price chart:
   - Orange peaks = consumption
   - Green line = cheap prices
   - **Goal:** Orange peaks during green/yellow (cheap hours)
3. Adjust targets if needed

### Monthly (10 minutes)
1. Go to Statistics page
2. Compare monthly cost to previous months
3. Check if tehomaksu fees are €0
4. Calculate actual savings vs €35-50 target
5. Fine-tune settings if needed

---

## ✅ Deployment Checklist

- [ ] Power Management Mobile dashboard created
- [ ] Configuration pasted and saved
- [ ] All 6 pages visible and navigable
- [ ] Navigation buttons work correctly
- [ ] All cards displaying (no entity errors)
- [ ] Theme looks consistent and readable
- [ ] Tested on mobile device
- [ ] Pinned to phone home screen (optional)

**Optional:**
- [ ] Magic Mirror dashboard created (if you have display)
- [ ] Node-RED Flow Monitor created (for learning/debugging)

**Post-Deployment:**
- [ ] Disabled old conflicting automations
- [ ] Set up kids_home toggle weekly reminder
- [ ] Configured notification preferences
- [ ] Bookmarked dashboards

---

## 🎉 You're Done!

Your professional power management system is now fully deployed with:
- ✅ 5 Node-RED flows managing power automatically
- ✅ Mobile dashboard for daily control
- ✅ Visual flow monitoring for understanding system
- ✅ Optional hallway display for at-a-glance status

**Expected results:**
- 💰 €35-50/month savings (€420-600/year)
- ⚡ No tehomaksu fees (staying <8kW)
- 🏠 Smart heating (minimum temp when kids away)
- 🚗 Tesla charging optimized
- 📱 Professional control interface

**Need help?** Check the troubleshooting section or PHASE2_DEPLOYMENT_SUMMARY.md

---

*Dashboard Deployment Guide v1.0*  
*Last Updated: 8 February 2026*
