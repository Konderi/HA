# 🎮 Enhanced Controls - Quick Reference Card

## 🚀 Quick Start (5 Minutes)

### 1. Create Helpers (Home Assistant UI)

**Settings** → **Devices & Services** → **Helpers** → **+ CREATE HELPER**

Create these 14 number helpers:
```
boiler_max_rank (1-24, initial: 8)
boiler_max_hours_daily (1-8, initial: 3)
mh1_outside_temp_threshold (-30-20, initial: 10)
mh1_min_room_temp (15-25, initial: 19)
mh1_max_room_temp (18-28, initial: 21)
tuomas_outside_temp_threshold (-30-20, initial: 12)
tuomas_min_room_temp (15-25, initial: 20)
tuomas_max_room_temp (18-28, initial: 22)
sara_outside_temp_threshold (-30-20, initial: 12)
sara_min_room_temp (15-25, initial: 20)
sara_max_room_temp (18-28, initial: 22)
```

Create these 2 toggle helpers:
```
boiler_luxus_mode (off)
tesla_priority_charging (off)
```

Create this 1 date/time helper:
```
boiler_luxus_activated (with date and time)
```

### 2. Import Flows (Node-RED)

**Node-RED** → **☰ Menu** → **Import** → Select files:
1. `price-based-optimizer.json` → **Update existing flow**
2. `priority-load-balancer.json` → **Update existing flow**
3. `temperature-radiator-control.json` → **Update existing flow**

**Deploy** → Verify no errors

### 3. Test (5 minutes each)

**Boiler:**
- Adjust `boiler_max_rank` to 5 → Wait 15 min → Verify rank respected

**Tesla:**
- Turn on `tesla_priority_charging` → Verify sauna/boiler turn off

**Radiator:**
- Adjust `mh1_min_room_temp` to 21 → Verify radiator responds

---

## 📊 Dashboard Quick Add

```yaml
type: entities
title: Power Controls
entities:
  - input_number.boiler_max_rank
  - input_number.boiler_max_hours_daily
  - input_boolean.boiler_luxus_mode
  - input_boolean.tesla_priority_charging
  - input_number.mh1_min_room_temp
  - input_number.tuomas_min_room_temp
  - input_number.sara_min_room_temp
```

---

## 🎯 Common Scenarios

### Scenario: Sauna Party Tonight (Many Guests)
**Action:** Turn ON `boiler_luxus_mode`  
**Effect:** Boiler runs immediately for 2 hours (ignores price)  
**Auto-Off:** After 2 hours

### Scenario: Urgent Tesla Charge (Unexpected Trip)
**Action:** Turn ON `tesla_priority_charging`  
**Effect:** Sauna OFF, Boiler OFF, Tesla max power  
**Auto-Off:** When battery reaches 80%

### Scenario: Warm Spring Day (No Heating Needed)
**Action:** Set all `outside_temp_threshold` to 12°C  
**Effect:** All radiators OFF when outside ≥ 12°C

### Scenario: Winter Cold Spell
**Action:** Lower `outside_temp_threshold` to 8°C  
**Effect:** Radiators stay active even when milder outside

### Scenario: Boiler Running Too Much
**Action:** Lower `boiler_max_rank` from 8 to 6  
**Effect:** Only runs in 6 cheapest hours (not 8)

### Scenario: Not Enough Hot Water
**Action:** Increase `boiler_max_hours_daily` from 3 to 4  
**Effect:** Can run up to 4 hours daily

---

## 🔧 Troubleshooting (90-Second Fixes)

### "Helpers not found" in Node-RED
→ Check entity names match exactly (case-sensitive)  
→ Restart Home Assistant  
→ Re-import flows

### "Boiler not respecting rank limit"
→ Check `sensor.shf_rank_now` is working  
→ Wait 15 minutes (next periodic check)  
→ Check Node-RED debug panel

### "Radiator not responding to outside temp"
→ Verify `sensor.outside_temperature` exists  
→ Check current outside temp value  
→ Threshold must be colder than outside to heat

### "Luxus mode not turning on boiler"
→ Check daily runtime < limit  
→ Verify boiler switch entity correct  
→ Check Node-RED status node

### "Tesla priority not turning off sauna"
→ Update sauna entity ID in flow:
```javascript
entity_id: 'switch.sauna'  // CHANGE THIS
```

---

## 📱 Mobile Dashboard Example

```yaml
type: vertical-stack
cards:
  - type: entities
    title: 💧 Boiler
    entities:
      - entity: input_number.boiler_max_rank
        name: Max Rank
      - entity: input_number.boiler_max_hours_daily
        name: Max Hours/Day
      - entity: input_boolean.boiler_luxus_mode
        name: Luxus Mode
        tap_action:
          action: toggle
  
  - type: entities
    title: 🚗 Tesla
    entities:
      - entity: input_boolean.tesla_priority_charging
        name: Priority Charge
        tap_action:
          action: toggle
      - entity: sensor.tesla_model_3_battery
        name: Battery
  
  - type: entities
    title: 🌡️ Radiators
    entities:
      - entity: input_number.mh1_min_room_temp
        name: MH1 Min
      - entity: input_number.tuomas_min_room_temp
        name: Tuomas Min
      - entity: input_number.sara_min_room_temp
        name: Sara Min
```

---

## 🎨 Status Indicators

### Node-RED Status Colors

**🟢 Green Dot:** Device ON and operating normally  
**⚪ Grey Dot:** Device OFF or idle  
**🟡 Yellow Ring:** Special mode active (Luxus)  
**🔵 Blue Ring:** Tesla priority active  
**🔴 Red Ring:** Limit reached or error  

### Common Status Messages

**Boiler:**
- `Rank 5 ≤ 8 - 2.5h left` = Running, 2.5h remaining today
- `LUXUS - 1.8h left` = Luxus mode, 1.8h left in 2h window
- `Daily 3h limit reached` = Stopped for today
- `Tesla priority active` = Off due to Tesla

**Tesla:**
- `TESLA PRIORITY - Sauna OFF` = Priority mode activated
- `Sauna ON - Car charging reduced to 8A` = Sauna has priority

**Radiators:**
- `20.5°C | Temp 19.8°C < min 20°C` = Heating to reach minimum
- `21.5°C | Outside 15°C ≥ threshold 12°C` = Off due to mild weather
- `18.5°C | Kids away - safety heating` = Minimal heating when kids gone

---

## 📈 Optimization Tips

### Winter Settings (November - March)
```
boiler_max_rank: 10-12 (run more often)
boiler_max_hours_daily: 4-5 (more hot water needed)
outside_temp_threshold: 8°C (heat more aggressively)
min_room_temp: 20-21°C (comfortable warmth)
```

### Summer Settings (June - August)
```
boiler_max_rank: 4-6 (only cheapest hours)
boiler_max_hours_daily: 2-3 (less hot water needed)
outside_temp_threshold: 15°C (minimal heating)
min_room_temp: 18-19°C (rarely heats)
```

### Spring/Fall Settings (April-May, September-October)
```
boiler_max_rank: 8 (balanced)
boiler_max_hours_daily: 3 (normal usage)
outside_temp_threshold: 12°C (moderate heating)
min_room_temp: 19-20°C (comfortable)
```

---

## ✅ Daily Checklist

**Morning:**
- [ ] Check boiler runtime yesterday
- [ ] Verify no overload events
- [ ] Check radiator temps comfortable

**Evening:**
- [ ] Check tomorrow's Nordpool prices
- [ ] Adjust rank if needed
- [ ] Enable Luxus mode if sauna party
- [ ] Enable Tesla priority if trip tomorrow

---

## 🎯 Success Metrics

**Week 1:**
- Boiler respects rank limit ✓
- Boiler respects daily hours ✓
- Radiators maintain comfort ✓
- No manual interventions ✓

**Month 1:**
- Energy costs reduced ✓
- All features used successfully ✓
- Optimal settings found ✓

---

## 📞 Quick Help

**Full Documentation:** [ENHANCED_CONTROLS_DEPLOYMENT.md](./ENHANCED_CONTROLS_DEPLOYMENT.md)

**Entity ID List:** All helpers start with:
- `input_number.boiler_*`
- `input_boolean.boiler_luxus_mode`
- `input_boolean.tesla_priority_charging`
- `input_number.mh1_*`
- `input_number.tuomas_*`
- `input_number.sara_*`

**Common Issues:** See deployment guide troubleshooting section

---

**🎉 You're all set! Enjoy your enhanced smart home!**
