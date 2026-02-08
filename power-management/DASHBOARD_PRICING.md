# 💰 Pricing Dashboard Cards

Dashboard configuration for displaying your complete electricity costs with real-time pricing.

---

## 🎨 Dashboard Cards

Add these to your Lovelace dashboard:

### 1. Current Price Overview

```yaml
type: vertical-stack
cards:
  # Current Total Price
  - type: custom:mushroom-chips-card
    chips:
      - type: template
        icon: mdi:currency-eur
        content: "{{ states('sensor.electricity_total_price') }} c/kWh"
        icon_color: >
          {% set price = states('sensor.electricity_total_price') | float(0) %}
          {% if price < 10 %}
            green
          {% elif price < 15 %}
            orange
          {% else %}
            red
          {% endif %}
        tap_action:
          action: more-info
          entity: sensor.electricity_total_price
      
      - type: template
        icon: >
          {{ state_attr('sensor.electricity_transfer_tariff', 'tariff_type').split()[0] == 'Day' | iif('mdi:weather-sunny', 'mdi:weather-night') }}
        content: >
          {{ state_attr('sensor.electricity_transfer_tariff', 'tariff_type').split()[0] }}
        icon_color: >
          {{ state_attr('sensor.electricity_transfer_tariff', 'tariff_type').split()[0] == 'Night' | iif('blue', 'orange') }}
      
      - type: template
        icon: mdi:cash-clock
        content: "{{ states('sensor.electricity_hourly_cost') }} €/h"
        icon_color: grey
  
  # Price Breakdown
  - type: entities
    title: 💰 Current Price Breakdown
    entities:
      - entity: sensor.electricity_total_price
        name: Total Price
        icon: mdi:cash-multiple
      
      - type: section
        label: Components
      
      - type: custom:mushroom-template-card
        primary: "Nordpool Spot"
        secondary: "{{ state_attr('sensor.electricity_total_price', 'nordpool_spot') }}"
        icon: mdi:chart-line
        icon_color: blue
        layout: horizontal
      
      - type: custom:mushroom-template-card
        primary: "Electric Tax"
        secondary: "2.83 c/kWh"
        icon: mdi:bank
        icon_color: grey
        layout: horizontal
      
      - type: custom:mushroom-template-card
        primary: "Margin"
        secondary: "0.59 c/kWh"
        icon: mdi:cash
        icon_color: grey
        layout: horizontal
      
      - type: custom:mushroom-template-card
        primary: "Transfer Fee"
        secondary: "{{ state_attr('sensor.electricity_total_price', 'transfer') }}"
        icon: >
          {{ 'mdi:weather-sunny' if is_state_attr('binary_sensor.electricity_night_tariff_active', 'state', 'off') else 'mdi:weather-night' }}
        icon_color: >
          {{ 'orange' if is_state_attr('binary_sensor.electricity_night_tariff_active', 'state', 'off') else 'blue' }}
        layout: horizontal
```

---

### 2. Cost Monitoring

```yaml
type: vertical-stack
cards:
  - type: custom:mushroom-title-card
    title: 💵 Cost Monitoring
  
  - type: horizontal-stack
    cards:
      # Hourly Cost
      - type: custom:mushroom-entity-card
        entity: sensor.electricity_hourly_cost
        name: Current Cost
        icon: mdi:cash-clock
        icon_color: blue
        primary_info: state
        secondary_info: name
      
      # Daily Estimate
      - type: custom:mushroom-template-card
        primary: "{{ states('sensor.electricity_estimated_daily_cost') }} €"
        secondary: "Today Est."
        icon: mdi:calendar-today
        icon_color: green
        tap_action:
          action: more-info
          entity: sensor.electricity_estimated_daily_cost
      
      # Monthly Estimate  
      - type: custom:mushroom-template-card
        primary: "{{ states('sensor.electricity_estimated_monthly_cost') }} €"
        secondary: "Month Est."
        icon: mdi:calendar-month
        icon_color: orange
        tap_action:
          action: more-info
          entity: sensor.electricity_estimated_monthly_cost
  
  # Savings Potential
  - type: custom:mushroom-template-card
    primary: "Potential Savings: {{ states('sensor.electricity_potential_night_savings') }} €/month"
    secondary: "By optimizing flexible loads to night hours"
    icon: mdi:piggy-bank
    icon_color: green
    layout: horizontal
```

---

### 3. Today's Price Range

```yaml
type: entities
title: 📊 Today's Price Analysis
entities:
  - type: custom:mushroom-template-card
    primary: "Cheapest Hour"
    secondary: >
      {{ state_attr('sensor.electricity_cheapest_hour_today', 'time') }} - 
      {{ state_attr('sensor.electricity_cheapest_hour_today', 'price') }}
    icon: mdi:clock-star
    icon_color: green
    layout: horizontal
    tap_action:
      action: none
  
  - type: custom:mushroom-template-card
    primary: "Most Expensive Hour"
    secondary: >
      {{ state_attr('sensor.electricity_most_expensive_hour_today', 'time') }} - 
      {{ state_attr('sensor.electricity_most_expensive_hour_today', 'price') }}
    icon: mdi:clock-alert
    icon_color: red
    layout: horizontal
    tap_action:
      action: none
  
  - type: custom:mushroom-template-card
    primary: "Price Difference"
    secondary: >
      {{ (state_attr('sensor.electricity_most_expensive_hour_today', 'price').split()[0] | float(0) - 
          state_attr('sensor.electricity_cheapest_hour_today', 'price').split()[0] | float(0)) | round(2) }} c/kWh savings available
    icon: mdi:chart-bell-curve
    icon_color: blue
    layout: horizontal
```

---

### 4. Hourly Price Graph

```yaml
type: custom:apexcharts-card
header:
  title: 💰 24-Hour Total Price (All Fees Included)
  show_states: false
graph_span: 24h
span:
  start: day
apex_config:
  chart:
    height: 280px
  yaxis:
    - min: 0
      decimals: 1
      labels:
        formatter: |
          EVAL:function(value) {
            return value.toFixed(1) + ' c/kWh';
          }
  annotations:
    yaxis:
      - y: 10
        borderColor: '#00E396'
        label:
          text: 'Cheap'
          style:
            color: '#fff'
            background: '#00E396'
      - y: 15
        borderColor: '#FEB019'
        label:
          text: 'Expensive'
          style:
            color: '#fff'
            background: '#FEB019'
  fill:
    type: gradient
    gradient:
      shadeIntensity: 1
      opacityFrom: 0.7
      opacityTo: 0.3
series:
  - entity: sensor.electricity_total_price
    name: Total Price
    type: area
    color: '#2196F3'
    stroke_width: 2
    data_generator: |
      return entity.attributes.raw_today.map((price, index) => {
        const nordpool = price * 100;
        const transfer = (index >= 7 && index < 22) ? 5.11 : 3.12;
        const total = nordpool + 2.827515 + 0.59 + transfer;
        return [new Date(entity.attributes.raw_today_time[index]).getTime(), total];
      });
```

---

### 5. Transfer Tariff Indicator

```yaml
type: custom:mushroom-template-card
primary: >
  {% if is_state('binary_sensor.electricity_night_tariff_active', 'on') %}
    🌙 Night Tariff Active (3.12 c/kWh)
  {% else %}
    ☀️ Day Tariff Active (5.11 c/kWh)
  {% endif %}
secondary: >
  {% if is_state('binary_sensor.electricity_night_tariff_active', 'on') %}
    Saving 1.99 c/kWh on transfer • Until 07:00
  {% else %}
    Night rate starts at 22:00 • Save 1.99 c/kWh
  {% endif %}
icon: >
  {% if is_state('binary_sensor.electricity_night_tariff_active', 'on') %}
    mdi:weather-night
  {% else %}
    mdi:weather-sunny
  {% endif %}
icon_color: >
  {% if is_state('binary_sensor.electricity_night_tariff_active', 'on') %}
    blue
  {% else %}
    orange
  {% endif %}
layout: vertical
tap_action:
  action: more-info
  entity: binary_sensor.electricity_night_tariff_active
```

---

### 6. Monthly Cost Progress

```yaml
type: vertical-stack
cards:
  - type: custom:mushroom-title-card
    title: 📅 Monthly Progress
    subtitle: "Estimated: {{ states('sensor.electricity_estimated_monthly_cost') }} €"
  
  - type: gauge
    entity: sensor.electricity_estimated_monthly_cost
    name: Monthly Cost
    min: 0
    max: 200
    severity:
      green: 0
      yellow: 120
      red: 150
    needle: true
  
  - type: entities
    entities:
      - type: custom:mushroom-template-card
        primary: "Base Fee"
        secondary: "5.99 € ({{ (5.99 / states('sensor.electricity_estimated_monthly_cost') | float(1) * 100) | round(1) }}% of total)"
        icon: mdi:cash
        icon_color: grey
        layout: horizontal
      
      - type: custom:mushroom-template-card
        primary: "Consumption"
        secondary: "{{ (states('sensor.electricity_estimated_monthly_cost') | float(0) - 5.99) | round(2) }} € ({{ ((states('sensor.electricity_estimated_monthly_cost') | float(0) - 5.99) / states('sensor.electricity_estimated_monthly_cost') | float(1) * 100) | round(1) }}% of total)"
        icon: mdi:flash
        icon_color: blue
        layout: horizontal
      
      - type: custom:mushroom-template-card
        primary: "Potential Savings"
        secondary: "{{ states('sensor.electricity_potential_night_savings') }} € by optimizing"
        icon: mdi:piggy-bank
        icon_color: green
        layout: horizontal
```

---

### 7. Price Comparison Card

```yaml
type: custom:mushroom-template-card
primary: "💡 Smart Scheduling Recommendation"
secondary: >
  {% set current_price = states('sensor.electricity_total_price') | float(0) %}
  {% set cheap_hour_price = state_attr('sensor.electricity_cheapest_hour_today', 'price').split()[0] | float(0) %}
  {% set savings = current_price - cheap_hour_price %}
  {% if savings > 5 %}
    ⚠️ HIGH PRICE! Wait for {{ state_attr('sensor.electricity_cheapest_hour_today', 'time') }} to save {{ savings | round(1) }} c/kWh
  {% elif savings > 2 %}
    💡 Consider waiting for {{ state_attr('sensor.electricity_cheapest_hour_today', 'time') }} (save {{ savings | round(1) }} c/kWh)
  {% else %}
    ✅ Good time to use electricity (only {{ savings | round(1) }} c/kWh more than cheapest)
  {% endif %}
icon: mdi:lightbulb-on
icon_color: >
  {% set current_price = states('sensor.electricity_total_price') | float(0) %}
  {% set cheap_hour_price = state_attr('sensor.electricity_cheapest_hour_today', 'price').split()[0] | float(0) %}
  {% set savings = current_price - cheap_hour_price %}
  {% if savings > 5 %}
    red
  {% elif savings > 2 %}
    orange
  {% else %}
    green
  {% endif %}
layout: vertical
```

---

## 🎯 Complete Dashboard View

To create a complete pricing view, stack all cards:

```yaml
title: Electricity Pricing
path: electricity-pricing
icon: mdi:currency-eur
cards:
  - !include pricing_overview.yaml  # Card 1
  - !include cost_monitoring.yaml   # Card 2
  - !include price_analysis.yaml    # Card 3
  - !include hourly_price_graph.yaml # Card 4
  - !include tariff_indicator.yaml  # Card 5
  - !include monthly_progress.yaml  # Card 6
  - !include price_comparison.yaml  # Card 7
```

---

## 📱 Mobile Optimization

For mobile, use a simplified view:

```yaml
type: vertical-stack
cards:
  # Quick Price
  - type: custom:mushroom-chips-card
    chips:
      - type: template
        content: "{{ states('sensor.electricity_total_price') }} c"
        icon: mdi:currency-eur
        icon_color: >
          {% set price = states('sensor.electricity_total_price') | float(0) %}
          {{ 'green' if price < 10 else ('orange' if price < 15 else 'red') }}
      
      - type: template
        content: "{{ states('sensor.electricity_hourly_cost') }} €/h"
        icon: mdi:cash-clock
      
      - type: template
        content: >
          {{ 'Night' if is_state('binary_sensor.electricity_night_tariff_active', 'on') else 'Day' }}
        icon: >
          {{ 'mdi:weather-night' if is_state('binary_sensor.electricity_night_tariff_active', 'on') else 'mdi:weather-sunny' }}
        icon_color: >
          {{ 'blue' if is_state('binary_sensor.electricity_night_tariff_active', 'on') else 'orange' }}
  
  # Mini Graph
  - type: custom:mini-graph-card
    entities:
      - sensor.electricity_total_price
    name: Today's Prices
    hours_to_show: 24
    points_per_hour: 1
    color_thresholds:
      - value: 0
        color: '#00E396'
      - value: 10
        color: '#FEB019'
      - value: 15
        color: '#FF4560'
```

---

## ⚙️ Customization Tips

1. **Adjust thresholds** in gauge and color coding to match your preferences
2. **Change graph height** in `apex_config.chart.height`
3. **Modify colors** using hex codes or HA color names
4. **Add/remove** components based on your needs

---

## 📊 Required Entities

Make sure these sensors exist:
- `sensor.nordpool_kwh_fi_eur_3_10_0` (Nordpool integration)
- `sensor.total_power_consumption` (from DASHBOARD.md)
- All pricing sensors from `PRICING_SENSORS.md`

---

**Last Updated:** February 2026  
**Compatible with:** Home Assistant 2026.2.x
