# 🚀 Phase 2 Deployment - Step-by-Step

## ✅ Step 1: Deploy Updated Configuration (5 minutes)

### 1.1 Backup Current Configuration
```bash
# In VS Code Server terminal
cp /config/configuration.yaml /config/configuration.yaml.backup
```

### 1.2 Deploy New Configuration

**Option A: Copy via VS Code Server (Easiest)**
1. Open file: `power-management/configuration_phase2_READY.yaml`
2. Select All (Cmd+A) → Copy (Cmd+C)
3. Open file: `/config/configuration.yaml`
4. Select All (Cmd+A) → Paste (Cmd+V)
5. Save (Cmd+S)

**Option B: Via HA File Editor**
1. Settings → Add-ons → File Editor
2. Open `/config/configuration.yaml`
3. Copy content from `configuration_phase2_READY.yaml`
4. Paste and save

### 1.3 Check Configuration
1. Developer Tools → YAML tab
2. Click "Check Configuration"
3. Should show: ✅ "Configuration valid!"

### 1.4 Restart Home Assistant
1. Settings → System → Restart
2. Wait 2-3 minutes for restart

### 1.5 Verify Helpers Created
1. Settings → Devices & Services → Helpers
2. Search for "kids"
3. Should see: `Kids at Home` toggle
4. Search for "mh1"
5. Should see: `MH1 Target Temperature`, `MH1 Heating Start Time`, etc.

**✅ Checklist:**
- [ ] Configuration.yaml backed up
- [ ] New configuration deployed
- [ ] Configuration check passed
- [ ] Home Assistant restarted
- [ ] 7 new helpers visible in UI

---

## ✅ Step 2: Import Node-RED Flows (15 minutes)

### 2.1 Access Node-RED
Open: http://homeassistant.local:1880

### 2.2 Import Flow 1: Temperature-Based Radiator Control (NEW!)

**This is the main flow for your radiator automation!**

1. Open file in VS Code: `power-management/flows/temperature-radiator-control.json`
2. Select All → Copy
3. In Node-RED: Click ☰ (hamburger menu) → Import → Clipboard
4. Paste JSON → Click "Import"
5. Flow appears in editor
6. Click "Deploy" button (top right)

**What this flow does:**
- MH1: Heats 22:00-07:00 to your target temp
- Tuomas: Heats when kids home + temp < 18°C
- Sara: Heats when kids home + temp < 18°C
- Automatic on/off based on temperature readings

### 2.3 Import Flow 2: Priority Load Balancer (CRITICAL)

**Prevents fuse overload!**

1. Open file: `power-management/flows/priority-load-balancer.json`
2. Copy → Import → Deploy

**What this flow does:**
- Prevents exceeding 17,250W
- Sauna always priority #1
- Adjusts Tesla charging dynamically
- Controls boiler timing

### 2.4 Import Flow 3: Peak Power Limiter

**Eliminates tehomaksu fees!**

1. Open file: `power-management/flows/peak-power-limiter.json`
2. Copy → Import → Deploy

**What this flow does:**
- Monitors 60-min rolling average
- Keeps consumption < 8kW
- Predicts future peaks
- Gentle load reduction

### 2.5 Import Flow 4: Price-Based Optimizer

**Schedules loads for cheap hours!**

1. Open file: `power-management/flows/price-based-optimizer.json`
2. Copy → Import → Deploy

**What this flow does:**
- Heat pump temperature control
- Boiler scheduling (cheap hours only)
- 6 cheapest/expensive hour logic

### 2.6 Import Flow 5: Phase Monitor & Alerts

**Monitors electrical health!**

1. Open file: `power-management/flows/phase-monitor-alerts.json`
2. Copy → Import → Deploy

**What this flow does:**
- Voltage monitoring (<200V alerts)
- Phase imbalance detection
- Overload warnings

### 2.7 Verify All Flows Loaded

In Node-RED, you should see **5 flow tabs** at the top:
1. ✅ Temperature-Based Radiator Control
2. ✅ Priority Load Balancer
3. ✅ Peak Power Limiter
4. ✅ Price-Based Optimizer
5. ✅ Phase Monitor & Alerts

**Check for errors:**
- Look for red triangles (⚠️) on nodes
- If found: Double-click node → Re-save → Deploy again

**✅ Checklist:**
- [ ] All 5 flows imported
- [ ] No error indicators
- [ ] Deployed successfully
- [ ] Flow tabs visible

---

## ✅ Step 3: Configure Initial Settings (5 minutes)

### 3.1 Set Kids Status

**In Home Assistant:**
1. Go to dashboard or Settings → Helpers
2. Find `Kids at Home` toggle
3. Set to **ON** if kids are home this week
4. Set to **OFF** if kids are away this week

### 3.2 Set MH1 Temperature & Schedule

**In Home Assistant:**
1. `MH1 Target Temperature`: Set to 20°C (or your preference)
2. `MH1 Heating Start Time`: Set to 22:00 (when you go to bed)
3. `MH1 Heating End Time`: Set to 07:00 (when you wake up)
4. `MH1 Manual Override`: Leave OFF (only use for special occasions)

### 3.3 Set Kids Rooms Temperatures

1. `Kids Rooms Minimum Temperature`: 18°C (default is good)
2. `Kids Rooms Target Temperature`: 19°C (default is good)

**✅ Checklist:**
- [ ] Kids home status set correctly
- [ ] MH1 temperature configured
- [ ] MH1 schedule configured
- [ ] Kids room temps configured

---

## ✅ Step 4: Add Dashboard Control (Optional - 5 minutes)

### 4.1 Add Radiator Control Card

1. Edit your Lovelace dashboard
2. Click "Add Card" → Manual
3. Open file: `power-management/lovelace_radiator_control_card.yaml`
4. Copy entire content
5. Paste into card editor
6. Save

**You'll see:**
- Kids home toggle
- Room temperatures (live)
- Radiator switches
- Temperature sliders
- MH1 schedule controls
- Status overview

**✅ Checklist:**
- [ ] Dashboard card added
- [ ] All controls visible
- [ ] Temperatures showing

---

## ✅ Step 5: Testing (10 minutes)

### Test 1: Kids Home Toggle

**Test kids room radiators:**
1. Make sure `Kids at Home` toggle = ON
2. Check temperature in Sara or Tuomas room
3. If temp < 18°C, radiator should turn ON within 1 minute
4. Toggle `Kids at Home` to OFF
5. Both kids radiators should turn OFF immediately

**Expected:**
- ✅ Radiators only ON when kids home
- ✅ Radiators turn OFF when toggle set to OFF

### Test 2: MH1 Schedule

**Test master bedroom schedule:**
1. Note current time
2. Temporarily change `MH1 Start Time` to current time + 1 minute
3. Wait 2 minutes
4. If room temp < target, MH1 should turn ON
5. Change `MH1 End Time` to current time
6. MH1 should turn OFF
7. Reset schedule to 22:00 - 07:00

**Expected:**
- ✅ MH1 only heats during scheduled time
- ✅ MH1 respects temperature target

### Test 3: Manual Override

**Test MH1 manual control:**
1. Turn ON `MH1 Manual Override`
2. MH1 should heat regardless of time
3. Turn OFF manual override
4. MH1 should follow schedule again

**Expected:**
- ✅ Manual override works 24/7
- ✅ Returns to schedule when OFF

### Test 4: Node-RED Debug

**Check flows are running:**
1. Open Node-RED
2. Click 🐛 (debug tab on right)
3. You should see temperature updates
4. You should see decision logic messages

**Expected:**
- ✅ No error messages
- ✅ Temperature values updating
- ✅ Control decisions logging

**✅ Checklist:**
- [ ] Kids toggle works
- [ ] MH1 schedule works
- [ ] Manual override works
- [ ] Node-RED debug shows activity
- [ ] No errors in logs

---

## ✅ Step 6: Monitor First 24 Hours

### What to Watch:

**Room Temperatures:**
- MH1: Should stay ~20°C during 22:00-07:00
- Tuomas/Sara: Should stay ≥18°C when kids home
- All rooms should be comfortable

**Radiator Behavior:**
- Should turn on/off smoothly (not rapidly cycling)
- Should respect schedules
- Should turn off when kids away

**Power Management:**
- Total power never exceeds 17,250W
- No fuse trips
- Tesla charging adjusts if needed
- Boiler runs during cheap hours

**Node-RED Logs:**
- Check debug panel for any errors
- Decision logic should make sense
- Temperature readings should be accurate

### Adjustments:

**If rooms too cold:**
- Increase target temperatures by 0.5-1°C

**If rooms too warm:**
- Decrease target temperatures by 0.5-1°C

**If MH1 cycling too much:**
- Temperature hysteresis is 0.5°C (normal)
- If still cycling: Check sensor location

**If kids rooms heating when away:**
- Verify `Kids at Home` toggle = OFF
- Check Node-RED flow is deployed

---

## 🎉 Phase 2 Deployment Complete!

### What You Now Have:

✅ **7 new helper entities** for control
✅ **5 Node-RED flows** for automation:
   - Temperature-based radiator control (NEW!)
   - Priority load balancer (fuse protection)
   - Peak power limiter (tehomaksu elimination)
   - Price-based optimizer (heat pump scheduling)
   - Phase monitor (electrical health)
✅ **Dashboard control panel** (optional)
✅ **Intelligent heating automation**

### Expected Results:

💰 **Energy Savings:**
- Kids away week: ~40-50 kWh saved
- MH1 night-only: ~15-20 kWh/week saved
- Peak avoidance: €16-24/month saved
- **Total: ~€30-50/month savings**

🏠 **Comfort:**
- MH1 warm at night (22:00-07:00)
- Kids rooms comfortable when home
- No cold bedrooms
- Heat pump handles primary heating

⚡ **Safety:**
- Fuse never trips (17,250W protection)
- Emergency load shedding automatic
- Phase monitoring alerts
- Voltage drop warnings

---

## 📊 Quick Status Check

**Everything working when:**
- [ ] Kids home toggle changes radiator behavior
- [ ] MH1 heats only 22:00-07:00 (unless manual override)
- [ ] Room temps stay within targets
- [ ] No errors in Node-RED debug
- [ ] Total power stays under 17,250W
- [ ] No fuse trips

**If any issues:** Check troubleshooting section in PHASE2_DEPLOYMENT.md

---

## 🎯 What's Next?

**Let it run for 1 week** to verify:
- Kids toggle behavior on changeover day
- MH1 night heating comfort
- Energy savings visible
- No unexpected behavior

**Phase 3 Preview (Optional):**
- Advanced energy analytics
- Per-device consumption tracking
- Automated reporting
- Cost breakdown dashboards

---

## 📞 Need Help?

**Check:**
1. Node-RED debug panel (🐛 tab)
2. HA logs (Settings → System → Logs)
3. Helper entities exist (Settings → Helpers)
4. Configuration.yaml backup safe

**Common Issues:**
- Radiators not turning on? Check kids_home toggle and schedule
- MH1 always on? Check manual override is OFF
- Errors in Node-RED? Re-import flow and deploy
- Helpers missing? Check configuration and restart HA

**You're all set! Enjoy your intelligent power management system! 🚀**
