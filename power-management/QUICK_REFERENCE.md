# Power Management - Quick Reference

## 🚨 Alert Types You'll Receive

### Critical (Immediate Action)
| Alert | Meaning | Action |
|-------|---------|--------|
| 🚨 Phase voltage <200V | Low voltage on a phase | Check electrical panel, contact electrician if persistent |
| 🚨 Phase overload >5750W | Single phase overloaded | System will auto-reduce loads, check what's running |
| ⚠️ Power >95% | Total power critical | Emergency load reduction activated |

### Warnings (Monitor)
| Alert | Meaning | Action |
|-------|---------|--------|
| ⚠️ Power >85% | High total load | System reducing car charging, normal operation |
| ⚠️ Phase imbalance >50% | Uneven load distribution | Consider redistributing devices across phases |
| ⚠️ Voltage 200-220V or 240-250V | Outside normal range | Monitor, may indicate grid issues |
| ⚠️ Sauna on >4 hours | Safety check | Verify sauna should still be on |
| ⚠️ Boiler <2h at 9PM | Not enough heating | Check if price rank slider is too low |

### Info (FYI)
| Notification | Meaning |
|--------------|---------|
| 🚗 Car charging started at XA | Tesla started charging |
| 🚗 Car charging paused | Waiting for better conditions |
| 💧 Water boiler ON/OFF | Boiler following price schedule |
| 🌡️ Heat pump temperature changed | Following price-based schedule |
| ✅ Tesla charged to 90%+ | Can stop charging if desired |
| 📊 Daily summary | Water boiler runtime report |

---

## ⚡ Device Priority

When power is tight, devices are managed in this order:

1. **🔥 Sauna** - Highest priority, others reduce when sauna is on
2. **🚗 Tesla** - High priority, but amperage adjusts dynamically
3. **💧 Water Boiler** - Lower priority, waits if necessary
4. **🌡️ Heat Pump** - Always on, temperature adjusts by price
5. **🔋 Garage Heater** - Lowest, only during cheapest 6 hours

---

## 📊 Typical Scenarios

### Scenario: Normal Evening
- **18:00:** Price rank = 15 (normal)
- **Actions:**
  - Heat pump at normal temp (21°C)
  - Car charges at 16A if plugged in
  - Boiler off (not in cheap hours)

### Scenario: Cheap Hour Morning
- **05:00:** Price rank = 2 (cheap)
- **Actions:**
  - Heat pump boosted to 23°C
  - Water boiler ON
  - Car charges at 12A (sharing with boiler)
  - Garage heater ON (if <6°C)

### Scenario: Someone Starts Sauna
- **Actions within seconds:**
  1. Water boiler turns OFF
  2. Car charging reduces to 8A (or OFF)
  3. Heat pump continues (temperature adjusted by price)
  4. Telegram notification sent

### Scenario: Total Power >95%
- **Actions immediately:**
  1. Car charging drops to 6A or OFF
  2. Water boiler turns OFF
  3. Critical alert sent to Telegram
  4. System monitors and adjusts continuously

---

## 🎛️ Control Sliders (Your Configuration)

### Water Boiler Schedule
**`input_number.shf_rank_slider`**
- Value = number of cheapest hours to heat
- Example: Set to 8 = boiler runs during 8 cheapest hours
- Recommended: 6-10 for 2-4 hours actual runtime

### Heat Pump Temperatures

**`input_number.tehostuslampo`** (Boost - 6 cheapest hours)
- Recommended: 22-24°C
- Higher = more comfort, more cost

**`input_number.normaalilampo_presence`** (Normal - 12 middle hours)
- Recommended: 20-22°C
- Your baseline comfort temperature

**`input_number.yllapitolampo`** (Eco - 6 most expensive hours)
- Recommended: 18-20°C
- Lower = more savings

---

## 🔍 Quick Diagnostics

### "My car isn't charging"

Check in order:
1. Is car at home? (location tracker)
2. Is it plugged in? (binary sensor)
3. Battery <90%?
4. Is price rank ≤12? (or battery <50%)
5. Is sauna off?
6. Is total power <85%?

### "Water boiler not running during cheap hours"

Check:
1. Current price rank vs slider value
2. Is sauna on?
3. Is car charging at full power?
4. Can you manually toggle the switch?

### "Getting too many alerts"

- Rate limiting is built-in (critical: 5min, warning: 15min)
- If still too many, check for actual electrical issues
- Can disable specific alert nodes in Node-RED

### "Heat pump not responding to prices"

Check:
1. Are temperature sliders set correctly?
2. Can you control climate entity manually?
3. Check Node-RED debug panel for errors
4. Verify `sensor.shf_rank_now` is updating

---

## 📱 Monitoring Tips

### Home Assistant Dashboard
Create cards for:
- Total power consumption (gauge card)
- Phase powers (entities card)
- Current price rank (entity card)
- Device states (entities card)
- Car battery level (gauge card)

### Node-RED Dashboard
- Watch debug panel during peak usage
- Monitor status messages on nodes
- Check flow connections are active

### Telegram
- Keep notifications enabled
- Review daily summaries
- Pay attention to voltage alerts

---

## 🛠️ Manual Overrides

### Emergency: Stop All Automations
In Node-RED: Disable the flow tabs temporarily

### Force Car to Charge
Manually turn on: `switch.tesla_model_3_charger`
- System will still manage amperage for safety

### Force Boiler ON
Manually turn on: `switch.shellypro4pm_ec62609fd3dc_switch_2`
- Will turn off automatically outside cheap hours

### Bypass Price Schedules
Set sliders to extreme values:
- Boiler slider to 24 = always try to run
- Boiler slider to 1 = only absolute cheapest

---

## 💡 Pro Tips

### Optimize Savings
1. Set boiler slider to 6-8 (cheaper hours only)
2. Increase temperature difference (boost high, eco low)
3. Charge Tesla during ranks 1-6 when possible
4. Monitor daily summaries to find patterns

### Maximize Comfort
1. Set boiler slider to 10-12 (more hours)
2. Smaller temperature differences (21-23°C range)
3. Keep heat pump normal temp at desired level

### Balance Both
1. Start with boiler slider = 8
2. Boost temp = normal + 2°C
3. Eco temp = normal - 2°C
4. Adjust based on your needs and bills

---

## 📞 When to Call for Help

### Electrician Needed
- Voltage consistently <200V or >250V
- Frequent fuse trips despite automations
- Phase imbalance that doesn't resolve
- Unusual burning smell or sounds

### System Issues (Check Node-RED)
- Devices not responding to commands
- Sensors showing unavailable
- Constant errors in debug panel
- Telegram not receiving messages

---

## 📈 Understanding Your Energy Data

### Price Rank System
- **Rank 1-6:** Cheapest hours (green 🟢)
- **Rank 7-18:** Normal hours (yellow 🟡)
- **Rank 19-24:** Most expensive hours (red 🔴)

### Power Levels
- **0-14,000W:** Normal, all systems go ✅
- **14,000-16,000W:** Caution, system monitoring closely ⚠️
- **16,000-17,250W:** High load, automatic reductions 🚨
- **>17,250W:** Overload, emergency actions ❌

### Daily Patterns
- **Night (00:00-06:00):** Usually cheapest, best for boiler/charging
- **Morning (06:00-09:00):** Medium prices, comfort heating
- **Day (09:00-17:00):** Variable prices
- **Evening (17:00-22:00):** Often expensive, eco mode
- **Late Evening (22:00-00:00):** Prices dropping, prepare for cheap night

---

## 🎯 Goals Achieved

✅ **Safety:** Never trip 25A fuses
✅ **Savings:** Use electricity during cheapest hours
✅ **Comfort:** Maintain desired temperatures
✅ **Convenience:** Fully automatic operation
✅ **Visibility:** Telegram alerts keep you informed
✅ **Flexibility:** Easy adjustments via sliders
✅ **Intelligence:** Smart load balancing and prioritization

---

## Next Steps

1. **Week 1:** Monitor alerts, verify operation
2. **Week 2:** Adjust sliders to your preference
3. **Week 3:** Review energy bills for savings
4. **Week 4:** Fine-tune temperatures and schedules
5. **Ongoing:** Seasonal adjustments as needed

Enjoy your intelligent power management system! 🎉
