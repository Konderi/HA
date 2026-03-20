# 🚗⚡ Tesla Charging Cost Tracking - Quick Summary

Track Tesla charging consumption and costs with **real total pricing** including all fees, taxes, and VAT.

---

## ✨ New Sensors Created

### 📊 Monthly & Yearly Totals
- `sensor.tesla_latausenergia_kuukausi_kwh` - Monthly consumption
- `sensor.tesla_monthly_charging_cost` - Monthly cost (€)
- `sensor.tesla_latausenergia_vuosi_kwh` - Yearly consumption  
- `sensor.tesla_yearly_charging_cost` - Yearly cost (€)

### ⭐ Last Charge Session (NEW!)
- `sensor.tesla_last_charge_cost` - Last charging session cost (€)
  - Shows: Energy (kWh), Duration (min), Avg price (€/kWh)
  - Start/end timestamps
  
### 🔄 Current Session (NEW!)
- `sensor.tesla_current_session_cost` - Real-time session cost (€)
  - Updates live while charging
  - Shows accumulated cost so far

---

## 💰 Real Total Pricing

**Uses:** `sensor.electricity_total_price_cents`

**Includes ALL costs:**
- ✅ Nordpool spot price (hourly market rate)
- ✅ Transfer fees (day 4.92 / night 3.01 c/kWh)
- ✅ Electricity tax (2.79 c/kWh)
- ✅ Supplier margin (0.59 c/kWh)
- ✅ VAT (25.5%)

**Example charging session:**
```
Energy: 44 kWh @ 16A for 4 hours
Total price: 14.44 c/kWh (includes everything)
Session cost: 6.35 €
```

---

## 🚀 Quick Deploy

```bash
# Copy all files
scp config/sensors/tesla_*.yaml root@homeassistant:/config/sensors/
scp config/input_helpers/tesla_charging_helpers.yaml root@homeassistant:/config/input_helpers/
scp config/automations/tesla_charging_tracking.yaml root@homeassistant:/config/automations/

# Add to configuration.yaml:
template: !include_dir_merge_list sensors/
sensor: !include sensors/tesla_utility_meters.yaml
utility_meter: !include sensors/tesla_utility_meters.yaml
input_number: !include_dir_merge_named input_helpers/
input_text: !include_dir_merge_named input_helpers/
automation: !include_dir_merge_list automations/

# Restart
ssh root@homeassistant "ha core check && ha core restart"
```

---

## 📱 Dashboard Example

```yaml
type: entities
title: 🔌 Tesla Charging
entities:
  # Current Status
  - entity: sensor.tesla_charging_power
    name: Current Power
  - entity: sensor.tesla_current_session_cost
    name: This Session
    
  # Last Charge
  - type: section
    label: Last Charge
  - entity: sensor.tesla_last_charge_cost
    name: Cost
  - entity: sensor.tesla_last_charge_cost
    name: Energy
    attribute: energy_kwh
  - entity: sensor.tesla_last_charge_cost
    name: Duration
    attribute: duration_minutes
    
  # Monthly
  - type: section
    label: This Month
  - entity: sensor.tesla_latausenergia_kuukausi_kwh
  - entity: sensor.tesla_monthly_charging_cost
    
  # Yearly
  - type: section
    label: This Year
  - entity: sensor.tesla_latausenergia_vuosi_kwh
  - entity: sensor.tesla_yearly_charging_cost
```

---

## 📊 What You'll See

**During charging:**
```
Current Power: 11.05 kW
This Session: 2.35 € (increasing)
```

**After charging stops (automatic notification):**
```
Last Charge:
  Cost: 6.35 €
  Energy: 44.2 kWh
  Duration: 240 min (4.0h)
  Avg Price: 0.144 €/kWh
```

**Monthly totals:**
```
This Month: 248.5 kWh
Cost: 38.50 €
```

**Yearly totals:**
```
This Year: 2,847 kWh
Cost: 425.80 €
```

---

## 🔔 Automatic Notifications

**When charging starts:**
```
🔌 Tesla Charging Started
Started at 22:15
Current price: 0.11 €/kWh
```

**When charging stops:**
```
✅ Tesla Charging Complete
Charged: 44.2 kWh
Cost: 6.35 €
Duration: 4.0h
Avg price: 0.144 €/kWh

Started: 22:15
Ended: 02:15
```

---

## ✅ Benefits

✅ **Accurate costs** - Real total price, not just spot price  
✅ **Session tracking** - Know exactly what each charge costs  
✅ **Monthly budgeting** - Track monthly charging expenses  
✅ **Yearly analysis** - Understand annual charging costs  
✅ **iPhone notifications** - Get notified with session details  
✅ **Dashboard visibility** - See all stats at a glance  
✅ **No interference** - Works alongside your existing Node-RED automation  

---

## 📚 Files Created

1. `config/sensors/tesla_charging_sensors.yaml` - Power, cost, session sensors
2. `config/sensors/tesla_utility_meters.yaml` - Riemann sum + utility meters
3. `config/input_helpers/tesla_charging_helpers.yaml` - Session storage helpers
4. `config/automations/tesla_charging_tracking.yaml` - Session tracking logic

---

## 📖 Full Documentation

**Complete guide:** [TESLA_CHARGING_TRACKING.md](TESLA_CHARGING_TRACKING.md)

---

## 💡 Example: Why Total Price Matters

**Spot price only:** 3.21 c/kWh  
**Real total cost:** 14.44 c/kWh (4.5x higher!)

44 kWh charging:
- ❌ Spot only: 1.41 € (misleading!)
- ✅ True cost: 6.35 € (what you actually pay)

**These sensors show the REAL cost you pay on your bill!**
