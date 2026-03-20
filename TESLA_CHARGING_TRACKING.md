# 🚗 Tesla Charging Cost Tracking - Deployment Guide

Track Tesla Model 3 charging energy consumption and costs with monthly and yearly totals.

---

## 📊 What You'll Get

### Sensors Created

**Power & Energy:**
- `sensor.tesla_charging_power` - Current charging power (kW)
- `sensor.tesla_charging_energy` - Cumulative charging energy (kWh)
- `binary_sensor.tesla_charging_at_home` - Status: Home & charging

**Time Period Consumption:**
- `sensor.tesla_latausenergia_tunti_kwh` - Hourly charging (kWh)
- `sensor.tesla_latausenergia_paiva_kwh` - Daily charging (kWh)
- `sensor.tesla_latausenergia_viikko_kwh` - Weekly charging (kWh)
- `sensor.tesla_latausenergia_kuukausi_kwh` - **Monthly charging (kWh)** ✨
- `sensor.tesla_latausenergia_vuosi_kwh` - **Yearly charging (kWh)** ✨

**Cost Tracking (uses total price with transfer fees, taxes, VAT):**
- `sensor.tesla_hourly_charging_cost` - Hourly cost (€)
- `sensor.tesla_monthly_charging_cost` - **Monthly cost (€)** ✨
- `sensor.tesla_yearly_charging_cost` - **Yearly cost (€)** ✨
- `sensor.tesla_last_charge_cost` - **Last charging session cost (€)** ⭐ NEW!
- `sensor.tesla_current_session_cost` - **Current charging session cost (€)** ⭐ NEW!

---

## 📋 Prerequisites

**Required Sensors (you already have these):**
- ✅ `switch.tesla_model_3_charger` - Charger on/off
- ✅ `number.tesla_model_3_charging_amps` - Charging amps
- ✅ `binary_sensor.tesla_model_3_charger` - Plugged in status
- ✅ `sensor.electricity_total_price_cents` - Electricity price

---

## 🚀 Deployment Steps

### Step 1: Copy Tesla Files

```bash
# Copy the sensor definitions
scp config/sensors/tesla_charging_sensors.yaml root@homeassistant:/config/sensors/
scp config/sensors/tesla_utility_meters.yaml root@homeassistant:/config/sensors/

# Copy input helpers
scp config/input_helpers/tesla_charging_helpers.yaml root@homeassistant:/config/input_helpers/

# Copy automation
scp config/automations/tesla_charging_tracking.yaml root@homeassistant:/config/automations/
```

### Step 2: Update Home Assistant Configuration

**SSH to Home Assistant:**
```bash
ssh root@homeassistant
```

**Edit configuration.yaml:**
```bash
nano /config/configuration.yaml
```

**Add these sections** (if they don't already exist):

```yaml
# Load Tesla sensors from sensors directory
template: !include_dir_merge_list sensors/

# Riemann Sum Integration and utility meters for energy tracking
sensor: !include sensors/tesla_utility_meters.yaml
utility_meter: !include sensors/tesla_utility_meters.yaml

# Input helpers for session tracking
input_number: !include_dir_merge_named input_helpers/
input_text: !include_dir_merge_named input_helpers/

# Automations for session tracking
automation: !include_dir_merge_list automations/
```

**OR if you already have these sections**, merge the content:

**Option A - Include directory (recommended):**
```yaml
template: !include_dir_merge_list sensors/
```

**Option B - Merge manually:**
Copy the content from `tesla_charging_sensors.yaml` into your existing template file.

**Save:** Ctrl+X, Y, Enter

### Step 3: Validate Configuration

```bash
ha core check
```

**Expected:** "Configuration valid!"

### Step 4: Restart Home Assistant

```bash
ha core restart
```

Wait 2-3 minutes.

---

## ✅ Verification

### Immediately After Restart

**1. Check Tesla charging power sensor:**
```
Developer Tools → States → search "tesla_charging_power"
```
- Should show `0 kW` (car not charging)
- Or actual power if currently charging

**2. Plug in Tesla and start charging, then check:**
```
sensor.tesla_charging_power = X.XX kW (e.g., 11.05 kW at 16A)
sensor.tesla_charging_energy = Increasing kWh value
binary_sensor.tesla_charging_at_home = on
sensor.tesla_current_session_cost = Increasing € value (real-time)
```

**3. When charging stops, check:**
```
sensor.tesla_last_charge_cost = X.XX € (cost of last session)
sensor.tesla_last_charge_energy = X.X kWh (energy of last session)
```

Attributes will show:
- Start/end time
- Duration in minutes
- Average price per kWh

**Formula:** Power (kW) = 400V × Amps × 1.732 / 1000
- 6A = 4.15 kW
- 10A = 6.93 kW
- 16A = 11.05 kW (typical)

### After 1 Hour of Charging

**Check utility meters:**
```
sensor.tesla_latausenergia_tunti_kwh = X.X kWh (hourly consumption)
sensor.tesla_hourly_charging_cost = X.XX € (hourly cost)
```

### After 1 Day

```
sensor.tesla_latausenergia_paiva_kwh = XX.X kWh
```

### After 1 Month

```
sensor.tesla_latausenergia_kuukausi_kwh = XXX kWh (e.g., 250 kWh)
sensor.tesla_monthly_charging_cost = XX.XX € (e.g., 35.50 €)
```

---

## 📊 Example Values

### Typical Charging Session
```
Charging: 16A × 4 hours
Power: 11.05 kW
Energy: 44.2 kWh
Cost: 6.28 € (at 14.2 c/kWh average)
```

### Monthly (30 kWh/day average)
```
Consumption: ~250 kWh/month
Cost: ~35-45 €/month (varies by price)
```

### Yearly
```
Consumption: ~3,000 kWh/year
Cost: ~420-600 €/year
```

---

## 💰 Total Price Calculation

**All costs use `sensor.electricity_total_price_cents` which includes ALL components:**

✅ **Nordpool spot price** - Hourly market price  
✅ **Transfer fees** - Day (4.92 c/kWh) / Night (3.01 c/kWh) tariffs  
✅ **Electricity tax** - 2.79 c/kWh  
✅ **Supplier margin** - 0.59 c/kWh  
✅ **VAT** - 25.5% on total  

**Formula:** `(Nordpool + Transfer + Tax + Margin) × 1.255`

**Example at 3.21 c/kWh Nordpool (daytime):**
```
(3.21 + 4.92 + 2.79 + 0.59) × 1.255 = 14.44 c/kWh
44 kWh charging session = 6.35 €
```

This ensures you see the **real total cost** of charging, not just the spot price!

---

## 🎨 Dashboard Cards

### Example: Tesla Charging Status Card

```yaml
type: entities
title: 🚗 Tesla Charging
entities:
  - entity: binary_sensor.tesla_charging_at_home
    name: Charging Status
  - entity: sensor.tesla_charging_power
    name: Current Power
  - entity: number.tesla_model_3_charging_amps
    name: Charging Amps
  - entity: sensor.tesla_current_session_cost
    name: This Session Cost
  - type: section
    label: Last Charge
  - entity: sensor.tesla_last_charge_cost
    name: Last Charge Cost
    secondary_info: |
      {{ state_attr('sensor.tesla_last_charge_cost', 'energy_kwh') }} kWh
      {{ state_attr('sensor.tesla_last_charge_cost', 'duration_minutes') }} min
  - type: section
    label: Today
  - entity: sensor.tesla_latausenergia_paiva_kwh
    name: Energy Today
  - type: section
    label: This Month
  - entity: sensor.tesla_latausenergia_kuukausi_kwh
    name: Energy This Month
  - entity: sensor.tesla_monthly_charging_cost
    name: Cost This Month
  - type: section
    label: This Year
  - entity: sensor.tesla_latausenergia_vuosi_kwh
    name: Energy This Year
  - entity: sensor.tesla_yearly_charging_cost
    name: Cost This Year
```

### Example: Last Charge Summary Card

```yaml
type: glance
title: 🔌 Last Charging Session
entities:
  - entity: sensor.tesla_last_charge_cost
    name: Cost
  - entity: sensor.tesla_last_charge_cost
    name: Energy
    attribute: energy_kwh
  - entity: sensor.tesla_last_charge_cost
    name: Duration
    attribute: duration_minutes
  - entity: sensor.tesla_last_charge_cost
    name: Avg Price
    attribute: avg_price_per_kwh
```

### Example: Monthly Cost Gauge

```yaml
type: gauge
entity: sensor.tesla_monthly_charging_cost
name: Tesla Charging Cost (Month)
min: 0
max: 100
unit: €
needle: true
severity:
  green: 0
  yellow: 50
  red: 80
```

---

## 🔧 Customization

### Change Voltage (if single-phase)

Edit `config/sensors/tesla_charging_sensors.yaml`:

```yaml
# For single-phase 230V:
{{ ((230 * amps) / 1000) | round(2) }}

# For 3-phase 400V (default):
{{ ((400 * amps * 1.732) / 1000) | round(2) }}
```

### Adjust Cost Calculation

The cost sensors use `sensor.electricity_total_price_cents`. If you want to use a different price sensor:

```yaml
{% set price = states('sensor.YOUR_PRICE_SENSOR') | float(0) %}
```

---

## 🚨 Troubleshooting

### sensor.tesla_charging_power shows "0" when charging

**Check:**
1. Is `switch.tesla_model_3_charger` = "on"?
2. Is `number.tesla_model_3_charging_amps` showing current amps?
3. Are sensor names correct in your HA?

**Fix:** Verify entity names match your Tesla integration.

### sensor.tesla_charging_energy not increasing

**Issue:** Riemann Sum integration not configured.

**Fix:** Make sure `sensor: !include sensors/tesla_utility_meters.yaml` is in configuration.yaml

### Utility meters showing "0"

**Wait:** Utility meters need time to accumulate:
- Hourly: 1 hour
- Daily: 24 hours
- Monthly: 1 month

**Check:** Source sensor `sensor.tesla_charging_energy` is increasing during charging.

### Cost sensors showing incorrect values

**Check:**
1. `sensor.electricity_total_price_cents` exists and has valid value
2. Utility meter sensors have accumulated data
3. Price is in cents/kWh format

---

## 📈 Advanced: Add to AI Prompts

Add Tesla charging info to your energy analysis prompts:

```yaml
# ai/prompts/energy_analysis.yaml
Tesla Charging Summary:
- Monthly consumption: {{ states('sensor.tesla_latausenergia_kuukausi_kwh') }} kWh
- Monthly cost: {{ states('sensor.tesla_monthly_charging_cost') }} €
- Yearly consumption: {{ states('sensor.tesla_latausenergia_vuosi_kwh') }} kWh
- Yearly cost: {{ states('sensor.tesla_yearly_charging_cost') }} €
- Average cost per kWh: {{ (states('sensor.tesla_monthly_charging_cost')|float / states('sensor.tesla_latausenergia_kuukausi_kwh')|float) | round(3) }} €/kWh
```

---

## 💡 Integration with Existing Flows

Your Node-RED flows already manage Tesla charging. These sensors provide **tracking only** - they don't interfere with your existing automation.

**What your flows do:**
- ✅ Start/stop charging based on price
- ✅ Adjust charging amps for load balancing
- ✅ Optimize for peak power limits

**What these sensors add:**
- ✅ Track exactly how much charging costs
- ✅ Monthly and yearly consumption totals
- ✅ Dashboard visibility
- ✅ Cost analysis and optimization insights

---

## 📚 Related Files

- **Sensor definitions:** `config/sensors/tesla_charging_sensors.yaml`
- **Utility meters:** `config/sensors/tesla_utility_meters.yaml`
- **Node-RED flows:** `nodered/flows/peak-power-limiter.json`
- **Priority balancer:** `nodered/flows/priority-load-balancer.json`

---

## 🎉 Success Criteria

✅ `sensor.tesla_charging_power` shows current charging power  
✅ `sensor.tesla_charging_energy` increases during charging  
✅ `sensor.tesla_latausenergia_kuukausi_kwh` accumulates monthly  
✅ `sensor.tesla_monthly_charging_cost` shows monthly cost in €  
✅ `sensor.tesla_yearly_charging_cost` shows yearly cost in €  
✅ Dashboard cards display Tesla charging info  

---

**Support:** If you encounter issues, check:
- Home Assistant logs: `ha core logs | grep tesla`
- Sensor states: Developer Tools → States
- Integration status: Settings → Devices & Services → Tesla
