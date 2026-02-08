# Professional Power Management Dashboard Guide

## Overview

The **Power Management Professional** dashboard is a comprehensive 4-page control center optimized for PC/desktop users. It provides complete control over your home's power management, heating systems, and automation flows.

---

## Dashboard Structure

### 📊 PAGE 1: MONITOR
**Path:** `/dashboard-powermanagement/monitor`

**Purpose:** Real-time system overview and monitoring

**Contents:**
- **4 Key Gauges:**
  - Current Power (0-17.25kW with color segments)
  - Current Electricity Price (c/kWh)
  - Today's Consumption (kWh)
  - Power Factor (0-1)

- **7-Day Effectiveness Chart:**
  - Hourly consumption vs price overlay
  - Shows automation impact
  - Color-coded price levels

- **Real-time Monitoring:**
  - Phase currents (A, B, C)
  - Phase voltages
  - Device status overview (Sauna, Boiler, Tesla, Radiators)

- **Today's Price Chart:**
  - 24-hour column chart
  - NOW indicator
  - Color-coded price levels

- **System Status Summary:**
  - Current power usage percentage
  - Kids home status
  - Active radiators count
  - Node-RED flow status

---

### 🎛️ PAGE 2: CONTROL
**Path:** `/dashboard-powermanagement/control`

**Purpose:** Complete heating and device management

**Contents:**

#### Kids Home Control Section
**All Helper Entities:**
- `input_boolean.kids_home` - Toggle every other week
- `input_number.kids_rooms_target_temp` - Target when kids home (default: 21°C)
- `input_number.kids_rooms_min_temp` - Minimum when kids away (default: 16°C)

**Live Status:**
- Tuomas room temperature + radiator state
- Sara room temperature + radiator state

#### Individual Room Control
- **Tuomas Room:** Temperature graph + radiator switch
- **Sara Room:** Temperature graph + radiator switch

#### Master Bedroom (MH1) Section
**All Helper Entities:**
- `input_datetime.mh1_start_time` - Heating start (default: 22:00)
- `input_datetime.mh1_end_time` - Heating end (default: 07:00)
- `input_number.mh1_target_temp` - Target temperature (default: 20°C)
- `input_boolean.mh1_manual_override` - Force 24/7 heating

**Live Status:**
- Current MH1 temperature
- Radiator on/off status

#### Temperature Chart
- 24-hour chart with 5 rooms:
  - MH1 (Master) - Red
  - Tuomas - Cyan
  - Sara - Yellow
  - Living Room - Green
  - Kitchen - Purple

#### Device Control
**Tesla Charging:**
- Charger switch
- Charging amps (6-16A)
- Battery level
- Auto-managed by Node-RED note

**Other Devices:**
- Water Boiler (3kW)
- Heat Pump
- Sauna (7kW)
- Sauna heater status

#### Priority Information
- Automatic priority order explanation
- Tesla adjustment rules
- Peak power protection details

---

### 🔄 PAGE 3: FLOWS
**Path:** `/dashboard-powermanagement/flows`

**Purpose:** Node-RED automation flow visualization

**Contents:**

#### Flow Status Table
Real-time status of all 5 flows:
1. **Temperature Control** - Every 5 min
2. **Priority Balancer** - Real-time
3. **Peak Limiter** - Every 30s
4. **Price Optimizer** - Hourly
5. **Phase Monitor** - Continuous

#### Temperature Control Flow
ASCII flowchart showing:
- Kids home check
- Target vs minimum temperature logic
- Each room's decision tree
- Current states with emojis

#### Priority Load Balancer Flow
ASCII flowchart showing:
- Current power and capacity %
- Priority order (Sauna > Heating > Boiler > Tesla)
- Tesla adjustment logic based on conditions

#### Peak Power Limiter
Logic display:
- Purpose: Keep 60-min avg <8kW
- Current status (SAFE/WARNING/CRITICAL)
- Action thresholds
- Expected savings

#### Price Optimizer
Logic display:
- Current price category
- Heat pump action based on price
- Expected savings

---

### 📈 PAGE 4: STATISTICS
**Path:** `/dashboard-powermanagement/statistics`

**Purpose:** Historical analysis and cost tracking

**Contents:**

#### Monthly Summary Gauges
- This month cost (€0-500)
- This month consumption (0-2000 kWh)

#### Consumption Breakdown
**Energy:**
- Today (kWh)
- This Week (kWh)
- This Month (kWh)

**Costs:**
- Today (€)
- This Week (€)
- This Month (€)

#### 30-Day Consumption Trend
- Column chart showing daily consumption
- Visual trend analysis

#### Best Charging Window Tomorrow
- Optimal time window
- Average price
- Savings vs worst window
- Estimated cost for full charge

#### Expected Savings (Phase 2)
**Monthly Breakdown:**
- Smart Heating: €12-16
- Kids Away Mode: €6-8
- Tehomaksu Avoidance: €16-24
- Price Optimization: €0-8
- **Total: €34-48/month**

**Annual Projection:**
- Minimum: €408/year
- Expected: €480/year
- Maximum: €576/year

**Current Status:**
- Kids home (Yes/No)
- MH1 schedule
- Active radiators count
- Peak power status

---

## Helper Entities Summary

### 7 Required Helpers (All Created in Phase 2)

#### Boolean Helpers (2)
1. **input_boolean.kids_home**
   - Toggle: Every other week
   - Controls: Kids room target temperatures
   - Impact: €6-8/month savings when away

2. **input_boolean.mh1_manual_override**
   - Default: OFF
   - Purpose: Force 24/7 heating in MH1
   - Use: Override schedule for continuous heating

#### Number Helpers (3)
3. **input_number.kids_rooms_target_temp**
   - Min: 16°C, Max: 24°C, Step: 0.5°C
   - Default: 21°C
   - Used when: Kids home = ON

4. **input_number.kids_rooms_min_temp**
   - Min: 14°C, Max: 20°C, Step: 0.5°C
   - Default: 16°C
   - Used when: Kids home = OFF

5. **input_number.mh1_target_temp**
   - Min: 16°C, Max: 24°C, Step: 0.5°C
   - Default: 20°C
   - Used: During MH1 schedule window

#### DateTime Helpers (2)
6. **input_datetime.mh1_start_time**
   - Default: 22:00
   - Purpose: When to start MH1 heating

7. **input_datetime.mh1_end_time**
   - Default: 07:00
   - Purpose: When to stop MH1 heating

---

## Deployment Instructions

### 1. Copy Dashboard File
```bash
# Dashboard already in repository
dashboards/power-management-professional.yaml
```

### 2. Add to Home Assistant
1. Go to **Settings** → **Dashboards**
2. Click **+ ADD DASHBOARD**
3. Choose **New dashboard from scratch**
4. Title: `Power Management Pro`
5. Icon: `mdi:lightning-bolt`
6. Click **CREATE**

### 3. Import YAML
1. Open the new dashboard
2. Click **⋮** (menu) → **Edit Dashboard**
3. Click **⋮** again → **Raw configuration editor**
4. **Paste entire content** from `power-management-professional.yaml`
5. Click **SAVE**

### 4. Verify Helpers
All 7 helpers should already exist from Phase 2 deployment:
```
Settings → Devices & Services → Helpers → Filter by "kids" and "mh1"
```

Should see:
- ✅ Kids at Home
- ✅ Kids Rooms Target Temperature
- ✅ Kids Rooms Minimum Temperature
- ✅ MH1 Heating Start Time
- ✅ MH1 Heating End Time
- ✅ MH1 Target Temperature
- ✅ MH1 Manual Override

### 5. Access Dashboard
URL format:
```
http://homeassistant.local:8123/dashboard-powermanagement/monitor
http://homeassistant.local:8123/dashboard-powermanagement/control
http://homeassistant.local:8123/dashboard-powermanagement/flows
http://homeassistant.local:8123/dashboard-powermanagement/statistics
```

---

## Usage Tips

### Weekly Routine
1. **Every Other Weekend:** Toggle `input_boolean.kids_home`
   - Kids arriving → Turn ON (Friday)
   - Kids leaving → Turn OFF (Sunday evening)

### Adjusting Heating
- **Kids Home Target:** Change `input_number.kids_rooms_target_temp` (typically 20-22°C)
- **Kids Away Minimum:** Keep `input_number.kids_rooms_min_temp` at 16°C to prevent freezing
- **MH1 Temperature:** Adjust `input_number.mh1_target_temp` (typically 19-21°C)

### Schedule Changes
- **Later Bedtime:** Change `input_datetime.mh1_start_time` (e.g., 23:00)
- **Earlier Wake-up:** Change `input_datetime.mh1_end_time` (e.g., 06:00)
- **Weekend Override:** Enable `input_boolean.mh1_manual_override` temporarily

### Monitoring
- **PAGE 1 (Monitor):** Daily check of system health
- **PAGE 2 (Control):** Adjust heating parameters as needed
- **PAGE 3 (Flows):** Troubleshoot if automations not working
- **PAGE 4 (Statistics):** Weekly review of costs and savings

---

## Custom Cards Required

Ensure these are installed via HACS:

1. **mushroom-cards** - For navigation buttons
2. **apexcharts-card** - For all charts
3. **card-mod** - For styling (backgrounds, borders)

Install via HACS:
```
HACS → Frontend → Search for "mushroom" → Install
HACS → Frontend → Search for "apexcharts" → Install
HACS → Frontend → Search for "card-mod" → Install
```

---

## Desktop Optimization Features

### Wide Layouts
- Horizontal stacks for side-by-side comparisons
- 2-column layouts for efficiency
- Large charts for better visibility

### Comprehensive Information
- Detailed status tables
- ASCII flowcharts for logic visualization
- Real-time status with emojis

### Professional Interface
- Gradient backgrounds for section headers
- Color-coded status indicators
- Organized sections with clear hierarchy

---

## Troubleshooting

### Issue: Page Not Loading
**Solution:** Check that all sensor entities exist in your HA installation

### Issue: Chart Not Displaying
**Solution:** Verify apexcharts-card is installed via HACS

### Issue: Helper Not Responding
**Solution:** Restart Node-RED after helper changes

### Issue: Template Errors
**Solution:** Check that all referenced entities exist (sensors, switches)

### Issue: Navigation Not Working
**Solution:** Verify dashboard URL is `/dashboard-powermanagement`

---

## Related Documentation

- [README.md](../README.md) - Project overview
- [PROJECT_STATUS.md](../PROJECT_STATUS.md) - Implementation status
- [PHASE2_DEPLOYMENT_SUMMARY.md](./PHASE2_DEPLOYMENT_SUMMARY.md) - Phase 2 details
- [DASHBOARD_DEPLOYMENT_GUIDE.md](./DASHBOARD_DEPLOYMENT_GUIDE.md) - All dashboards
- [NODERED_FLOW_MONITOR.md](./NODERED_FLOW_MONITOR.md) - Flow visualization

---

## Expected Results

### After Deployment

✅ **4 fully functional dashboard pages** optimized for desktop  
✅ **All 7 helper entities** accessible and adjustable  
✅ **Real-time monitoring** of power, temperature, and devices  
✅ **Flow visualization** showing automation logic  
✅ **Cost tracking** with savings projections  

### User Benefits

- **Complete Control:** All heating parameters in one place
- **Visual Feedback:** Charts and flowcharts show system behavior
- **Cost Awareness:** Real-time and projected savings visible
- **Easy Adjustments:** Sliders and toggles for quick changes
- **Professional Interface:** Desktop-optimized layouts for efficiency

---

**Last Updated:** February 8, 2026  
**Version:** 1.0  
**Status:** Production Ready ✅
