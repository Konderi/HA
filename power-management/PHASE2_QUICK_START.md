# 🚀 Phase 2 - Quick Start Guide

**Status:** ✅ READY TO DEPLOY  
**Time Required:** 30-40 minutes  
**Complexity:** Medium (Node-RED import + configuration)

---

## 📦 What You're Deploying

### New Temperature-Based Radiator Control:
- **MH1 (Master Bedroom):** Night-only heating (22:00-07:00)
- **Tuomas & Sara Rooms:** Only when kids home, maintain >18°C
- **Smart Logic:** Temperature hysteresis, manual overrides, schedule control

### Existing Flows (Already Created):
1. Priority Load Balancer - Sauna/Tesla/Boiler coordination
2. Peak Power Limiter - Tehomaksu protection (8kW limit)
3. Price-Based Optimizer - Heat pump scheduling
4. Phase Monitor & Alerts - Voltage/imbalance warnings

---

## ⚡ Quick Deploy (30 min)

### Step 1: Deploy Helpers (5 min)
```bash
# Copy to HA via VS Code Server addon
/config/power-management/phase2_helpers.yaml
```

**Add to configuration.yaml:**
```yaml
input_boolean: !include power-management/phase2_helpers.yaml
input_number: !include power-management/phase2_helpers.yaml
input_datetime: !include power-management/phase2_helpers.yaml
```

**Restart HA** → Verify helpers exist

### Step 2: Import Node-RED Flows (15 min)

**Access Node-RED:** http://homeassistant.local:1880

**Import in this order:**

1. **Priority Load Balancer** ← FIRST (safety critical!)
   - File: `flows/priority-load-balancer.json`
   - Controls: Tesla, Boiler, Sauna priority
   
2. **Temperature Radiator Control** ← NEW!
   - File: `flows/temperature-radiator-control.json`
   - Controls: MH1, Tuomas, Sara radiators
   
3. **Peak Power Limiter**
   - File: `flows/peak-power-limiter.json`
   - Prevents tehomaksu fees
   
4. **Price-Based Optimizer**
   - File: `flows/price-based-optimizer.json`
   - Heat pump scheduling
   
5. **Phase Monitor & Alerts**
   - File: `flows/phase-monitor-alerts.json`
   - Voltage/imbalance monitoring

**Import method:**
- Copy JSON content
- Node-RED → ☰ → Import → Clipboard
- Paste → Import → Deploy

### Step 3: Add Dashboard (5 min)

1. Edit Lovelace dashboard
2. Add card → Manual
3. Copy content from: `lovelace_radiator_control_card.yaml`
4. Save

### Step 4: Configure (5 min)

**Set your preferences:**
- Kids home toggle: ON/OFF based on current week
- MH1 target temp: 20°C (adjust to preference)
- MH1 schedule: 22:00 - 07:00
- Kids rooms: Min 18°C, Target 19°C

---

## 🎯 What Happens After Deploy

### Automatic Behavior:

**MH1 (Master Bedroom):**
- ✅ Only heats between 22:00-07:00
- ✅ Maintains your target temperature
- ✅ Turns off during daytime (room empty = energy savings)

**Kids' Rooms (Tuomas & Sara):**
- ✅ Only heat when `kids_home` toggle = ON
- ✅ Keep temperature above 18°C
- ✅ Turn off automatically when toggle = OFF
- ✅ Energy savings during away week!

**Power Management:**
- ✅ Never exceeds 17,250W (fuse protection)
- ✅ Sauna always has priority
- ✅ Tesla charging adjusts dynamically
- ✅ Boiler runs during cheap hours
- ✅ Heat pump optimizes based on price

**Emergency Load Shedding:**
1. Reduce Tesla (16A → 12A → 8A → 6A → OFF)
2. Turn off Boiler
3. Turn off kids radiators
4. Turn off MH1 (only if temp > 21°C)
5. Keep heat pump running (most efficient)

---

## 🎛️ Your New Controls

**Dashboard Card Shows:**
- 👦👧 Kids home toggle (switch weekly)
- 🌡️ All room temperatures (live)
- 🔘 Radiator switches (manual control available)
- 🎚️ Temperature targets (adjustable)
- ⏰ MH1 heating schedule (customizable)
- 📊 Status overview

**Sliders You Can Adjust:**
- MH1 target temperature (18-24°C)
- Kids rooms min temperature (16-20°C)
- Kids rooms target temperature (18-22°C)
- MH1 start time (default 22:00)
- MH1 end time (default 07:00)

**Toggles:**
- Kids at home (ON/OFF)
- MH1 manual override (force 24/7 heating)

---

## 📊 Expected Results

### Energy Savings:
- **Kids away week:** ~40-50 kWh saved
- **MH1 night-only:** ~15-20 kWh/week saved
- **Peak avoidance:** €16-24/month saved (no tehomaksu)
- **Total monthly:** ~€30-50 savings

### Comfort:
- ✅ Bedroom warm at night (MH1)
- ✅ Kids rooms comfortable when home
- ✅ No cold spots
- ✅ No overheating
- ✅ Heat pump handles primary heating

### Safety:
- ✅ Fuse never trips (17,250W protection)
- ✅ Emergency load shedding automatic
- ✅ Alerts for voltage issues
- ✅ Phase imbalance detection

---

## ✅ Verification Checklist

After deployment, verify:

- [ ] All 5 Node-RED flows imported and deployed
- [ ] Helper entities exist (Settings → Helpers)
- [ ] Dashboard card shows all controls
- [ ] Kids home toggle works (radiators turn on/off)
- [ ] MH1 schedule check (change time temporarily to test)
- [ ] Temperature readings show in dashboard
- [ ] No errors in Node-RED debug panel
- [ ] No errors in HA logs

**If all checked:** Phase 2 is COMPLETE! ✅

---

## 🔧 Quick Troubleshooting

**Radiators not turning on?**
- Check helper entities exist
- Verify kids_home = ON (for kids' rooms)
- Check MH1 schedule is active
- Enable Node-RED debug to see decision logic

**Node-RED connection error?**
- Check HA integration configured
- Restart Node-RED addon
- Verify access token valid

**Helpers not found?**
- Verify phase2_helpers.yaml in /config/power-management/
- Check configuration.yaml includes it
- Restart Home Assistant

---

## 📖 Full Documentation

For detailed information, see:
- **PHASE2_DEPLOYMENT.md** - Complete step-by-step guide
- **power-management/README.md** - System overview
- **POWER_MANAGEMENT_GUIDE.md** - How everything works together

---

## 🎉 You're Ready!

Everything is prepared and waiting in your Git repository:

✅ Helper entities configuration
✅ Temperature-based radiator control flow
✅ 4 existing power management flows
✅ Dashboard control card
✅ Complete documentation

**Start with Step 1 above and deploy!** 🚀

**Estimated total time:** 30-40 minutes  
**Difficulty:** Medium (follow guide step-by-step)  
**Result:** Intelligent, automated power management! 💪
