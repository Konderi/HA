# 💰 Complete Pricing Guide

Comprehensive electricity pricing configuration for accurate cost tracking and optimization.

---

## 📊 Your Pricing Structure

Based on your actual electricity contract:

### Components Breakdown:

```
Nordpool Spot Price (hourly variable)
+ Electric Tax: 2.827515 c/kWh (incl. ALV 25.5%)
+ Margin: 0.59 c/kWh (incl. ALV 25.5%)
+ Transfer Fee (time-based):
  • Day (07:00-22:00): 5.11 c/kWh (incl. ALV 25.5%)
  • Night (22:00-07:00): 3.12 c/kWh (incl. ALV 25.5%)
+ Base Fee: 5.99 €/month (incl. ALV 25.5%)
─────────────────────────────────────────────
= Total Price per kWh (varies by hour + tariff)
```

### Converted to €/kWh:

```yaml
electric_tax: 0.02827515  # €/kWh (fixed)
margin: 0.0059           # €/kWh (fixed)
transfer_day: 0.0511     # €/kWh (07:00-22:00)
transfer_night: 0.0312   # €/kWh (22:00-07:00)
base_fee: 5.99           # €/month (fixed)
```

---

## 🔌 Data Source: Spot-Hinta.fi API

You're already using the excellent **Spot-Hinta.fi** integration which provides:

- ✅ Nordpool spot prices
- ✅ Already includes ALV (25.5%)
- ✅ Hourly data for today + tomorrow
- ✅ Rank system (1-24, cheapest to most expensive)
- ✅ Historical averages

**API Endpoint:** `https://api.spot-hinta.fi/TodayAndDayForward?HomeAssistant=true`

---

## 📄 Modern Template Sensors

### File: `templates/electricity_pricing.yaml`

Create this file with your complete pricing logic:

```yaml
# ============================================
# ELECTRICITY PRICING - COMPLETE SYSTEM
# Based on Spot-Hinta.fi API + Your Contract
# ============================================

template:
  - sensor:
      # ====================
      # TRANSFER TARIFF (DAY/NIGHT)
      # ====================
      - name: "Transfer Tariff Now"
        unique_id: transfer_tariff_now
        unit_of_measurement: "€/kWh"
        device_class: monetary
        state: >
          {% set hour = now().hour %}
          {{ 0.0511 if 7 <= hour < 22 else 0.0312 }}
        icon: >
          {% set hour = now().hour %}
          {{ 'mdi:weather-sunny' if 7 <= hour < 22 else 'mdi:weather-night' }}
        attributes:
          tariff_type: >
            {% set hour = now().hour %}
            {{ 'Day' if 7 <= hour < 22 else 'Night' }}
          tariff_cents: >
            {% set hour = now().hour %}
            {{ 5.11 if 7 <= hour < 22 else 3.12 }}
          start_time: >
            {% set hour = now().hour %}
            {{ '07:00' if 7 <= hour < 22 else '22:00' }}
          end_time: >
            {% set hour = now().hour %}
            {{ '22:00' if 7 <= hour < 22 else '07:00' }}

      # ====================
      # TOTAL ELECTRICITY PRICE (ALL COMPONENTS)
      # ====================
      - name: "Electricity Total Price Now"
        unique_id: electricity_total_price_now
        unit_of_measurement: "€/kWh"
        device_class: monetary
        state_class: measurement
        state: >
          {% set spot = states('sensor.shf_electricity_price_now') | float(0) %}
          {% set tax = 0.02827515 %}
          {% set margin = 0.0059 %}
          {% set transfer = states('sensor.transfer_tariff_now') | float(0.0511) %}
          {{ (spot + tax + margin + transfer) | round(5) }}
        icon: mdi:currency-eur
        attributes:
          # Breakdown in €/kWh
          spot_price: '{{ states("sensor.shf_electricity_price_now") | float(0) | round(5) }}'
          electric_tax: 0.02827515
          margin: 0.0059
          transfer_fee: '{{ states("sensor.transfer_tariff_now") | float(0) | round(5) }}'
          
          # Breakdown in cents/kWh
          spot_price_cents: '{{ (states("sensor.shf_electricity_price_now") | float(0) * 100) | round(2) }}'
          electric_tax_cents: 2.83
          margin_cents: 0.59
          transfer_fee_cents: '{{ (states("sensor.transfer_tariff_now") | float(0) * 100) | round(2) }}'
          total_cents: '{{ (this.state | float(0) * 100) | round(2) }}'
          
          # Additional info
          rank: '{{ states("sensor.shf_rank_now") }}'
          tariff_type: '{{ state_attr("sensor.transfer_tariff_now", "tariff_type") }}'

      # ====================
      # PRICE IN CENTS (FOR CHARTS)
      # ====================
      - name: "Electricity Total Price Cents"
        unique_id: electricity_total_price_cents
        unit_of_measurement: "c/kWh"
        device_class: monetary
        state_class: measurement
        state: >
          {{ (states('sensor.electricity_total_price_now') | float(0) * 100) | round(2) }}
        icon: mdi:cash-100

      # ====================
      # HOURLY COST (CURRENT CONSUMPTION)
      # ====================
      - name: "Electricity Cost Now"
        unique_id: electricity_cost_now
        unit_of_measurement: "€/h"
        device_class: monetary
        state: >
          {% set power_kw = states('sensor.total_power_consumption') | float(0) %}
          {% set price = states('sensor.electricity_total_price_now') | float(0) %}
          {{ (power_kw * price) | round(3) }}
        icon: mdi:currency-eur-off
        attributes:
          power_kw: '{{ states("sensor.total_power_consumption") | float(0) | round(2) }}'
          price_per_kwh: '{{ states("sensor.electricity_total_price_now") | float(0) | round(5) }}'
          cost_per_minute: '{{ (this.state | float(0) / 60) | round(4) }}'

      # ====================
      # DAILY STATISTICS
      # ====================
      - name: "Electricity Average Price Today"
        unique_id: electricity_average_price_today
        unit_of_measurement: "€/kWh"
        device_class: monetary
        state: >
          {% set spot_avg = state_attr('sensor.shf_electricity_price_now', 'today_avg') | float(0) %}
          {% set tax = 0.02827515 %}
          {% set margin = 0.0059 %}
          {% set transfer_day = 0.0511 %}
          {% set transfer_night = 0.0312 %}
          {% set avg_transfer = (transfer_day * 15 + transfer_night * 9) / 24 %}
          {{ (spot_avg + tax + margin + avg_transfer) | round(5) }}
        icon: mdi:chart-line
        attributes:
          spot_average: '{{ state_attr("sensor.shf_electricity_price_now", "today_avg") | float(0) | round(5) }}'
          day_hours: 15
          night_hours: 9
          weighted_transfer: '{{ ((0.0511 * 15 + 0.0312 * 9) / 24) | round(5) }}'

      - name: "Electricity Min Price Today"
        unique_id: electricity_min_price_today
        unit_of_measurement: "€/kWh"
        device_class: monetary
        state: >
          {% set spot_min = state_attr('sensor.shf_electricity_price_now', 'today_min') | float(0) %}
          {% set tax = 0.02827515 %}
          {% set margin = 0.0059 %}
          {% set transfer_night = 0.0312 %}
          {{ (spot_min + tax + margin + transfer_night) | round(5) }}
        icon: mdi:arrow-down-bold

      - name: "Electricity Max Price Today"
        unique_id: electricity_max_price_today
        unit_of_measurement: "€/kWh"
        device_class: monetary
        state: >
          {% set spot_max = state_attr('sensor.shf_electricity_price_now', 'today_max') | float(0) %}
          {% set tax = 0.02827515 %}
          {% set margin = 0.0059 %}
          {% set transfer_day = 0.0511 %}
          {{ (spot_max + tax + margin + transfer_day) | round(5) }}
        icon: mdi:arrow-up-bold

      # ====================
      # MONTHLY ESTIMATES
      # ====================
      - name: "Electricity Monthly Base Fee"
        unique_id: electricity_monthly_base_fee
        unit_of_measurement: "€"
        device_class: monetary
        state: "5.99"
        icon: mdi:calendar-month
        attributes:
          description: "Fixed monthly base fee (incl. ALV 25.5%)"
          yearly_total: "71.88"

      - name: "Electricity Estimated Monthly Cost"
        unique_id: electricity_estimated_monthly_cost
        unit_of_measurement: "€"
        device_class: monetary
        state: >
          {% set daily_kwh = states('sensor.energy_daily') | float(0) %}
          {% set avg_price = states('sensor.electricity_average_price_today') | float(0) %}
          {% set base_fee = 5.99 %}
          {% set monthly_energy_cost = daily_kwh * avg_price * 30 %}
          {{ (monthly_energy_cost + base_fee) | round(2) }}
        icon: mdi:calculator
        attributes:
          daily_consumption_kwh: '{{ states("sensor.energy_daily") | float(0) | round(1) }}'
          monthly_consumption_kwh: '{{ (states("sensor.energy_daily") | float(0) * 30) | round(0) }}'
          energy_cost: '{{ (states("sensor.energy_daily") | float(0) * states("sensor.electricity_average_price_today") | float(0) * 30) | round(2) }}'
          base_fee: "5.99"

      # ====================
      # SAVINGS TRACKING
      # ====================
      - name: "Electricity Savings This Month"
        unique_id: electricity_savings_this_month
        unit_of_measurement: "€"
        device_class: monetary
        state: >
          {% set saved_from_peak = states('sensor.nodered_saved_euros') | float(0) %}
          {% set saved_from_optimization = states('sensor.price_optimization_savings') | float(0) %}
          {{ (saved_from_peak + saved_from_optimization) | round(2) }}
        icon: mdi:piggy-bank
        attributes:
          peak_limiter_savings: '{{ states("sensor.nodered_saved_euros") | float(0) | round(2) }}'
          price_optimization_savings: '{{ states("sensor.price_optimization_savings") | float(0) | round(2) }}'
          interventions_count: '{{ states("sensor.nodered_interventions_count") | float(0) | int }}'

  - binary_sensor:
      # ====================
      # PRICING STATUS
      # ====================
      - name: "Electricity Price Cheap Now"
        unique_id: electricity_price_cheap_now
        device_class: power
        state: >
          {% set rank = states('sensor.shf_rank_now') | int(24) %}
          {{ rank <= 8 }}
        icon: >
          {% set rank = states('sensor.shf_rank_now') | int(24) %}
          {{ 'mdi:currency-eur-off' if rank <= 8 else 'mdi:currency-eur' }}
        attributes:
          current_rank: '{{ states("sensor.shf_rank_now") }}'
          threshold_rank: 8
          description: "Price is in cheapest 1/3 of day"

      - name: "Electricity Price Expensive Now"
        unique_id: electricity_price_expensive_now
        device_class: problem
        state: >
          {% set rank = states('sensor.shf_rank_now') | int(0) %}
          {{ rank >= 18 }}
        icon: >
          {% set rank = states('sensor.shf_rank_now') | int(0) %}
          {{ 'mdi:alert' if rank >= 18 else 'mdi:check-circle' }}
        attributes:
          current_rank: '{{ states("sensor.shf_rank_now") }}'
          threshold_rank: 18
          description: "Price is in most expensive 1/4 of day"

      - name: "Night Tariff Active"
        unique_id: night_tariff_active
        state: >
          {% set hour = now().hour %}
          {{ hour < 7 or hour >= 22 }}
        icon: >
          {% set hour = now().hour %}
          {{ 'mdi:weather-night' if (hour < 7 or hour >= 22) else 'mdi:weather-sunny' }}
```

---

## 🔄 Migration from Old Config

### What Changes:

#### OLD (spot-price2.yaml):
```yaml
# Old hardcoded values
siirto_paiva = 0.0492  # Wrong value
siirto_yo = 0.0301     # Wrong value
alv = 1.24             # Wrong ALV
marginaali = 0.0045    # Wrong margin
```

#### NEW (electricity_pricing.yaml):
```yaml
# Correct values from your contract
transfer_day: 0.0511   # 5.11 c/kWh (incl. ALV)
transfer_night: 0.0312 # 3.12 c/kWh (incl. ALV)
electric_tax: 0.02827515  # 2.827515 c/kWh
margin: 0.0059         # 0.59 c/kWh
```

---

## 📊 Integration with Node-RED

### Update Your Flows to Use New Sensors:

#### Priority Load Balancer:
```javascript
// OLD
const price = msg.payload.state; // generic price

// NEW
const totalPrice = msg.payload.state; // includes ALL costs
const priceBreakdown = {
    spot: msg.payload.attributes.spot_price,
    tax: msg.payload.attributes.electric_tax,
    margin: msg.payload.attributes.margin,
    transfer: msg.payload.attributes.transfer_fee,
    total: msg.payload.state
};
```

#### Price-Based Optimizer:
```javascript
// Use rank system (already working)
const rank = global.get('shf_rank_slider') || 12;
const currentRank = msg.payload.state;

if (currentRank <= rank) {
    // Cheap electricity, run devices
}
```

---

## 📱 Dashboard Integration

### Pricing Dashboard Card:

```yaml
type: vertical-stack
cards:
  - type: markdown
    content: |
      # 💰 Current Electricity Price
      
  - type: horizontal-stack
    cards:
      - type: tile
        entity: sensor.electricity_total_price_now
        name: Total Price
        icon: mdi:currency-eur
        color: >
          {% set rank = states('sensor.shf_rank_now') | int(12) %}
          {% if rank <= 8 %}green
          {% elif rank <= 16 %}orange
          {% else %}red{% endif %}
      
      - type: tile
        entity: sensor.electricity_total_price_cents
        name: Price (Cents)
        icon: mdi:cash-100
      
      - type: tile
        entity: sensor.shf_rank_now
        name: Rank Today
        icon: mdi:podium
  
  - type: markdown
    content: |
      ### Price Breakdown
  
  - type: entities
    entities:
      - entity: sensor.shf_electricity_price_now
        name: "Spot Price (Nordpool)"
      - entity: sensor.transfer_tariff_now
        name: "Transfer Fee"
        secondary_info: >
          {{ state_attr('sensor.transfer_tariff_now', 'tariff_type') }}
          ({{ state_attr('sensor.transfer_tariff_now', 'start_time') }} - 
          {{ state_attr('sensor.transfer_tariff_now', 'end_time') }})
      - type: section
      - entity: sensor.electricity_total_price_now
        name: "TOTAL"
        icon: mdi:cash-plus
  
  - type: markdown
    content: |
      ### Today's Statistics
  
  - type: glance
    entities:
      - entity: sensor.electricity_min_price_today
        name: Min
      - entity: sensor.electricity_average_price_today
        name: Average
      - entity: sensor.electricity_max_price_today
        name: Max
  
  - type: markdown
    content: |
      ### Current Cost
  
  - type: entities
    entities:
      - entity: sensor.electricity_cost_now
        name: "Cost per Hour"
        icon: mdi:clock-outline
      - entity: sensor.total_power_consumption
        name: "Current Power"
  
  - type: markdown
    content: |
      ### Monthly Estimate
  
  - type: entities
    entities:
      - entity: sensor.electricity_estimated_monthly_cost
        name: "Estimated Total"
      - entity: sensor.electricity_monthly_base_fee
        name: "Base Fee"
      - entity: sensor.electricity_savings_this_month
        name: "Savings"
        icon: mdi:piggy-bank
```

---

## 🎯 Benefits of New System

### Compared to Old Configuration:

| Feature | Old Config | New Config |
|---------|-----------|------------|
| **Accurate Transfer Fees** | ❌ Wrong values | ✅ Correct: 5.11/3.12 c |
| **Electric Tax** | ❌ Missing | ✅ Included: 2.83 c |
| **Margin** | ❌ Wrong value | ✅ Correct: 0.59 c |
| **Price Breakdown** | ❌ No details | ✅ Full breakdown |
| **Current Cost** | ❌ Not available | ✅ Real-time €/hour |
| **Monthly Estimate** | ❌ No tracking | ✅ Automatic calc |
| **Savings Tracking** | ❌ Manual only | ✅ Automated |
| **Modern Syntax** | ❌ Legacy | ✅ HA 2026.2.x |

---

## 📝 Installation Steps

### 1. Create Template File

```bash
# In your HA config directory:
mkdir -p templates
nano templates/electricity_pricing.yaml
# Paste the template sensors from above
```

### 2. Update configuration.yaml

```yaml
# Add this line:
template: !include_dir_merge_list templates/
```

### 3. Check Configuration

```bash
# In Home Assistant:
Developer Tools → YAML → Check Configuration
```

### 4. Restart Home Assistant

```bash
# Restart required for template changes
Settings → System → Restart
```

### 5. Verify Entities

```bash
# Check in Developer Tools → States:
- sensor.electricity_total_price_now
- sensor.transfer_tariff_now
- sensor.electricity_cost_now
- sensor.electricity_estimated_monthly_cost
```

---

## 🔍 Troubleshooting

### If Prices Look Wrong:

1. **Check SHF sensor is working:**
   ```yaml
   sensor.shf_electricity_price_now
   # Should show current spot price
   ```

2. **Verify transfer tariff:**
   ```yaml
   sensor.transfer_tariff_now
   # Should be 0.0511 (day) or 0.0312 (night)
   ```

3. **Check time zone:**
   ```yaml
   # In configuration.yaml:
   homeassistant:
     time_zone: Europe/Helsinki
   ```

### If Sensors Don't Appear:

1. Check YAML syntax (no tabs, correct indentation)
2. Verify template file path in configuration.yaml
3. Check Home Assistant logs for errors
4. Ensure SHF integration is working

---

## 📈 Example Calculations

### Current Price (Day, 10:00):
```
Nordpool spot:     0.08000 €/kWh (8.00 c/kWh)
+ Electric tax:    0.02828 €/kWh (2.83 c/kWh)
+ Margin:          0.00590 €/kWh (0.59 c/kWh)
+ Transfer (day):  0.05110 €/kWh (5.11 c/kWh)
─────────────────────────────────────────────
= Total:           0.16528 €/kWh (16.53 c/kWh)
```

### Current Price (Night, 23:00):
```
Nordpool spot:     0.05000 €/kWh (5.00 c/kWh)
+ Electric tax:    0.02828 €/kWh (2.83 c/kWh)
+ Margin:          0.00590 €/kWh (0.59 c/kWh)
+ Transfer (night): 0.03120 €/kWh (3.12 c/kWh)
─────────────────────────────────────────────
= Total:           0.11538 €/kWh (11.54 c/kWh)
```

### Monthly Estimate (800 kWh):
```
Energy cost:    800 kWh × 0.14 €/kWh = 112.00 €
+ Base fee:                             5.99 €
─────────────────────────────────────────────
= Total:                              117.99 €
```

---

## ✅ Verification Checklist

Before going live:

- [ ] SHF integration working (sensor.shf_electricity_price_now)
- [ ] Template file created (templates/electricity_pricing.yaml)
- [ ] Configuration.yaml updated (template include)
- [ ] Configuration check passed
- [ ] Home Assistant restarted
- [ ] All sensors visible in States
- [ ] Prices match manual calculations
- [ ] Transfer tariff changes at 07:00 and 22:00
- [ ] Dashboard cards showing data
- [ ] Node-RED flows updated (if needed)

---

**Last Updated:** February 8, 2026  
**Your Contract:** Helen (estimated based on typical Finnish contracts)  
**Status:** ✅ Ready to Deploy
