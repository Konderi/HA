# 🚀 Quick Start Implementation Guide

## ⚡ Priority Order - What to Implement First

```
1. ⚠️  Priority Load Balancer    [CRITICAL - Prevents fuse burnout]
2. ⚡ Peak Power Limiter         [HIGH - Saves 50-150€/year]
3. 💰 Price-Based Optimizer      [MEDIUM - Daily cost savings]
4. 📊 Phase Monitor & Alerts     [LOW - Nice to have]
```

---

## 📋 Implementation Checklist

### ✅ Phase 1: Priority Load Balancer (30 minutes)

**Why First:** Protects your electrical system from overload

**Steps:**
```
☐ 1. Open Node-RED (Settings → Add-ons → Node-RED → Open Web UI)
☐ 2. Click hamburger menu (☰) → Import
☐ 3. Select file: flows/priority-load-balancer.json
☐ 4. Click "Import"
☐ 5. Click "Deploy" (top right)
☐ 6. Watch debug panel for 5 minutes
☐ 7. Test: Turn on sauna → Check if car reduces
```

**Verify:**
- [ ] Sauna state monitoring works
- [ ] Car amperage adjustments work
- [ ] Boiler control works
- [ ] Telegram notifications arrive
- [ ] Debug shows no errors

**Expected Result:**
```
✅ Sauna ON → Car reduces to 8A, Boiler OFF
✅ Total power monitored continuously
✅ Emergency reduction at 95% capacity
```

---

### ⚡ Phase 2: Peak Power Limiter (20 minutes)

**Why Second:** Saves significant money (50-150€/year)

**Steps:**
```
☐ 1. In Node-RED, Import: flows/peak-power-limiter.json
☐ 2. Click "Deploy"
☐ 3. Check debug panel for power readings
☐ 4. Verify phase sensors are working:
     • sensor.shellyem3_channel_a_power
     • sensor.shellyem3_channel_b_power
     • sensor.shellyem3_channel_c_power
☐ 5. Wait 60 minutes for buffer to fill
☐ 6. Monitor 60-min average in node status
```

**Verify:**
- [ ] Phase power sensors readable
- [ ] Total power calculation correct
- [ ] 60-minute buffer filling up
- [ ] Rolling average calculated
- [ ] Prediction algorithm running

**Expected Result:**
```
✅ Shows: "60-min avg: 6.5 kW (45/60)" in node status
✅ Predictions calculated every minute
✅ No errors in debug panel
```

**Monitor First Day:**
- [ ] Check notifications for false alarms
- [ ] Verify reduction logic makes sense
- [ ] Adjust thresholds if too sensitive

---

### 💰 Phase 3: Price-Based Optimizer (20 minutes)

**Why Third:** Optimizes energy costs based on prices

**Steps:**
```
☐ 1. In Node-RED, Import: flows/price-based-optimizer.json
☐ 2. Click "Deploy"
☐ 3. Verify price rank sensor exists:
     • sensor.shf_rank_now
☐ 4. Verify temperature sliders exist:
     • input_number.yllapitolampo (eco temp)
     • input_number.normaalilampo_presence (normal temp)
     • input_number.tehostuslampo (boost temp)
     • input_number.shf_rank_slider (boiler threshold)
☐ 5. Watch for next price rank change
```

**Verify:**
- [ ] Heat pump temperature changes with price rank
- [ ] Boiler runs during cheap hours
- [ ] Boiler respects sauna priority
- [ ] Boiler respects peak limit
- [ ] Daily summary at 9 PM

**Expected Result:**
```
✅ Rank 1-6:  Heat pump BOOST, Boiler ON (if safe)
✅ Rank 7-18: Heat pump NORMAL
✅ Rank 19-24: Heat pump ECO, Boiler OFF
```

---

### 📊 Phase 4: Phase Monitor & Alerts (15 minutes)

**Why Last:** Monitoring only, doesn't control devices

**Steps:**
```
☐ 1. In Node-RED, Import: flows/phase-monitor-alerts.json
☐ 2. Click "Deploy"
☐ 3. Check if voltage sensors exist:
     • sensor.shellyem3_channel_a_voltage
     • sensor.shellyem3_channel_b_voltage
     • sensor.shellyem3_channel_c_voltage
☐ 4. If missing, create template sensors (see below)
☐ 5. Test notifications
```

**If Voltage Sensors Missing:**
Create in `configuration.yaml`:
```yaml
template:
  - sensor:
      - name: "Shelly EM3 Channel A Voltage"
        unique_id: shellyem3_channel_a_voltage
        unit_of_measurement: "V"
        device_class: voltage
        state: >
          {{ state_attr('sensor.shellyem3_channel_a', 'voltage') | float(230) }}
      
      - name: "Shelly EM3 Channel B Voltage"
        unique_id: shellyem3_channel_b_voltage
        unit_of_measurement: "V"
        device_class: voltage
        state: >
          {{ state_attr('sensor.shellyem3_channel_b', 'voltage') | float(230) }}
      
      - name: "Shelly EM3 Channel C Voltage"
        unique_id: shellyem3_channel_c_voltage
        unit_of_measurement: "V"
        device_class: voltage
        state: >
          {{ state_attr('sensor.shellyem3_channel_c', 'voltage') | float(230) }}
```

**Verify:**
- [ ] Voltage readings display
- [ ] Phase balance calculated
- [ ] Rate limiting works (no spam)
- [ ] Sauna timer alerts after 4 hours
- [ ] Car charge complete notification

---

## 🔍 Post-Implementation Verification

### Day 1 Checklist (Critical)

```
Morning (First 2 hours):
☐ Check Node-RED debug panel for errors
☐ Verify all flows are running (green "connected" status)
☐ Test one device manually (turn on/off)
☐ Confirm Telegram notifications working

Afternoon (During use):
☐ Turn on sauna → Verify priority works
☐ Plug in car → Verify charging starts
☐ Check 60-min average is calculating
☐ Monitor peak limiter behavior

Evening (Peak time 18-21):
☐ All devices coordinating correctly?
☐ Peak limiter intervening if needed?
☐ Price optimizer running boiler at cheap hour?
☐ No unexpected device shutdowns?

Night (Before bed):
☐ Review Telegram notifications from day
☐ Check for any errors in Node-RED
☐ Verify daily summaries sent (9 PM)
☐ Note any adjustments needed
```

---

### Week 1 Monitoring

```
Daily:
☐ Read morning notifications
☐ Check 60-min average peak
☐ Verify interventions make sense
☐ Adjust thresholds if too sensitive

By Day 3:
☐ Peak limiter buffer fully operational (60 readings)
☐ Pattern of interventions clear
☐ User comfort maintained

By Day 7:
☐ Decide if any adjustments needed
☐ Review intervention count
☐ Check if monthly peak on track
☐ Calculate week's savings
```

---

## ⚙️ Configuration Adjustments

### If Peak Limiter Too Aggressive:

**Option 1: Increase thresholds**
```javascript
// In peak-power-limiter.json, predict_future_peak node:
const threshold = 8.5;        // Instead of 8.0
const warningLevel = 8.0;     // Instead of 7.5
const cautionLevel = 7.5;     // Instead of 7.0
```

**Option 2: Reduce prediction sensitivity**
```javascript
// In peak-power-limiter.json, predict_future_peak node:
// Use only longer predictions
msg.worstCasePeak = Math.max(
    msg.predicted15min,    // Remove 5 and 10 min predictions
    msg.predicted30min
);
```

### If Too Many Telegram Notifications:

**Option 1: Adjust rate limits**
```javascript
// In phase-monitor-alerts.json, rate limiter nodes:
const minInterval = 30 * 60 * 1000;  // 30 min instead of 15 min
```

**Option 2: Disable non-critical alerts**
```javascript
// Comment out or disable:
// - Caution level alerts
// - Phase balance warnings
// Keep only emergency alerts
```

### If Price Optimization Not Aggressive Enough:

**Option 1: Adjust boiler rank slider**
```
In Home Assistant:
  → Settings → Devices & Services
  → Helpers → input_number.shf_rank_slider
  → Change from 8 to 12 (run during more hours)
```

**Option 2: Modify heat pump temperature spread**
```
In Home Assistant, adjust sliders:
  • tehostuslampo (boost): Increase by 1-2°C
  • yllapitolampo (eco): Decrease by 1-2°C
  → Larger temperature swing = more savings
```

---

## 🐛 Common Issues & Solutions

### Issue: "sensor.shellyem3_channel_a_power not found"

**Solution:**
1. Check actual sensor name in Home Assistant
2. Go to: Developer Tools → States
3. Search for "shellyem3" or "power"
4. Update entity ID in flow
5. Redeploy

---

### Issue: "60-min average shows 0.00 kW"

**Cause:** Buffer still filling or sensors not working

**Solution:**
1. Check debug panel for `msg.totalPowerKW`
2. Should show current power (e.g., 5.2 kW)
3. If shows 0 or null → sensor problem
4. Wait 60 minutes for buffer to fill completely
5. Node status shows "(45/60)" while filling

---

### Issue: "Boiler turns on even when sauna active"

**Cause:** Flag not set or not readable

**Solution:**
1. Check priority-load-balancer is deployed
2. In Node-RED, Context Data sidebar
3. Look for flow context: `sauna_active`
4. Should be `true` when sauna on, `false` when off
5. If missing, check sauna sensor entity ID

---

### Issue: "Too many Telegram notifications"

**Cause:** No rate limiting or threshold too low

**Solution:**
1. Check rate limiter nodes are working
2. Increase rate limit intervals
3. Raise warning thresholds
4. Disable caution-level notifications
5. Keep only emergency alerts

---

### Issue: "Interventions too frequent"

**Cause:** Thresholds too conservative

**Solution:**
1. Your actual usage may be higher than expected
2. Check if provider allows higher limit (9-10 kW)
3. Adjust threshold in code
4. Or accept occasional interventions (saves money!)
5. Review device combinations

---

## 📊 Success Metrics

### After 1 Week:

```
✅ Zero fuse trips
✅ Zero unexpected device shutdowns
✅ Interventions appropriate (not too many/few)
✅ User comfort maintained
✅ Telegram notifications helpful
```

### After 1 Month:

```
✅ Monthly peak under 8 kW (or close)
✅ Calculate actual savings from bill
✅ System running smoothly
✅ No manual interventions needed
✅ Confidence in automation
```

### After 3 Months:

```
✅ Total savings: 15-40€
✅ System self-adjusting
✅ Patterns learned
✅ Minimal notifications
✅ "Set and forget" achieved 🎯
```

---

## 💡 Pro Tips

### Tip 1: Monitor First Week Actively
```
Don't set and forget immediately!
Watch notifications closely first 7 days.
Adjust thresholds based on real usage.
Then relax and let it work.
```

### Tip 2: Understand Your Patterns
```
Note when peaks typically occur:
  • Morning: 6-8 AM (breakfast)
  • Evening: 18-21 PM (cooking, sauna)
  • Weekends: Variable

Plan high-power activities accordingly.
```

### Tip 3: Trust the Automation
```
System knows better than manual control!
If it reduces car charging:
  → There's a good reason
  → Check notification for why
  → Will restore automatically
```

### Tip 4: Seasonal Adjustments
```
Winter: Higher baseline (heating)
  → Less margin for other devices
  → Be more cautious

Summer: Lower baseline
  → More margin available
  → Can be less restrictive
```

### Tip 5: Review Monthly Reports
```
Every 1st of month, review:
  • Monthly peak achieved
  • Interventions count
  • Estimated savings
  • Adjust if needed
```

---

## 🎯 Quick Reference Commands

### Check System Status:
```
Node-RED → Debug panel → Filter by flow name
Look for errors or warnings
```

### Manual Override (Emergency):
```
1. Disable flow temporarily:
   → Click flow tab
   → Click "Disable"
   
2. Re-enable when ready:
   → Click "Enable"
   → Click "Deploy"
```

### Reset Monthly Stats:
```
Context Data sidebar → Flow context → Delete:
  • monthly_peak
  • interventions_count
  • saved_euros
```

### Test Telegram:
```
Inject node → Timestamp → Trigger
Should send test notification
```

---

## 📞 Getting Help

### Before Asking:
```
1. Check Node-RED debug panel
2. Review this guide
3. Check TEHOMAKSU_GUIDE.md
4. Verify entity IDs correct
5. Wait 60 minutes (buffer fill time)
```

### Include in Help Request:
```
• Screenshot of debug panel
• Flow export (problematic node)
• Entity IDs you're using
• What you expected vs what happened
• Telegram notification text (if any)
```

---

## ✅ Final Checklist

```
☐ All 4 flows imported and deployed
☐ Entity IDs verified for your system
☐ Telegram notifications tested
☐ Debug panel shows no errors
☐ First interventions observed and appropriate
☐ User understands how it works
☐ Monthly tracking active
☐ Savings calculator ready
☐ Confidence: HIGH! 🚀
```

---

## 🎉 You're All Set!

Your complete power management system is now:
- ✅ Preventing fuse overload
- ✅ Eliminating peak power fees
- ✅ Optimizing energy costs
- ✅ Monitoring system health
- ✅ Saving 100-200€ per year

**Enjoy your automated, intelligent home!** 🏠💡

---

*Remember: The first week is for learning and adjustment. After that, it's truly "set and forget"!*
