# 💰 Pricing Template Sensors

Add these to your `template.yaml` file for complete cost tracking with your actual electricity prices.

---

## 📊 Template Sensors

```yaml
# ============================================
# ELECTRICITY PRICING SENSORS
# All prices include ALV 25.5%
# ============================================

- sensor:
    # Current Transfer Tariff (Day/Night)
    - name: "Electricity Transfer Tariff"
      unique_id: electricity_transfer_tariff
      unit_of_measurement: "c/kWh"
      state_class: measurement
      state: >
        {% set hour = now().hour %}
        {% if hour >= 7 and hour < 22 %}
          5.11
        {% else %}
          3.12
        {% endif %}
      icon: >
        {% set hour = now().hour %}
        {% if hour >= 7 and hour < 22 %}
          mdi:weather-sunny
        {% else %}
          mdi:weather-night
        {% endif %}
      attributes:
        tariff_type: >
          {% set hour = now().hour %}
          {% if hour >= 7 and hour < 22 %}
            Day (07:00-22:00)
          {% else %}
            Night (22:00-07:00)
          {% endif %}
        next_change: >
          {% set hour = now().hour %}
          {% if hour >= 7 and hour < 22 %}
            {{ today_at("22:00") }}
          {% else %}
            {{ today_at("07:00") if hour >= 0 else today_at("07:00") + timedelta(days=1) }}
          {% endif %}
    
    # Total Electricity Price (Nordpool + All Fees)
    - name: "Electricity Total Price"
      unique_id: electricity_total_price
      unit_of_measurement: "c/kWh"
      device_class: monetary
      state_class: measurement
      state: >
        {% set nordpool = states('sensor.nordpool_kwh_fi_eur_3_10_0') | float(0) * 100 %}
        {% set tax = 2.827515 %}
        {% set margin = 0.59 %}
        {% set hour = now().hour %}
        {% set transfer = 5.11 if (hour >= 7 and hour < 22) else 3.12 %}
        {{ (nordpool + tax + margin + transfer) | round(2) }}
      icon: mdi:currency-eur
      attributes:
        nordpool_spot: >
          {{ (states('sensor.nordpool_kwh_fi_eur_3_10_0') | float(0) * 100) | round(2) }} c/kWh
        electric_tax: "2.83 c/kWh"
        margin: "0.59 c/kWh"
        transfer: >
          {% set hour = now().hour %}
          {{ '5.11 c/kWh (Day)' if (hour >= 7 and hour < 22) else '3.12 c/kWh (Night)' }}
        breakdown: >
          Nordpool: {{ (states('sensor.nordpool_kwh_fi_eur_3_10_0') | float(0) * 100) | round(2) }} c + 
          Tax: 2.83 c + Margin: 0.59 c + Transfer: {{ '5.11 c' if (now().hour >= 7 and now().hour < 22) else '3.12 c' }}
    
    # Hourly Cost (current consumption × price)
    - name: "Electricity Hourly Cost"
      unique_id: electricity_hourly_cost
      unit_of_measurement: "€"
      device_class: monetary
      state_class: measurement
      state: >
        {% set power_kw = states('sensor.total_power_consumption') | float(0) %}
        {% set price_cents = states('sensor.electricity_total_price') | float(0) %}
        {{ (power_kw * price_cents / 100) | round(3) }}
      icon: mdi:cash-clock
      attributes:
        per_hour: >
          {{ (states('sensor.total_power_consumption') | float(0) * 
              states('sensor.electricity_total_price') | float(0) / 100) | round(3) }} €
        per_day_estimate: >
          {{ (states('sensor.total_power_consumption') | float(0) * 
              states('sensor.electricity_total_price') | float(0) / 100 * 24) | round(2) }} €
        per_month_estimate: >
          {{ (states('sensor.total_power_consumption') | float(0) * 
              states('sensor.electricity_total_price') | float(0) / 100 * 24 * 30) | round(2) }} €
    
    # Today's Best Price Hour
    - name: "Electricity Cheapest Hour Today"
      unique_id: electricity_cheapest_hour_today
      state: >
        {% set ns = namespace(min_price=999, min_hour=0) %}
        {% for hour in range(24) %}
          {% set nordpool = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'raw_today')[hour] | float(999) * 100 %}
          {% set transfer = 5.11 if (hour >= 7 and hour < 22) else 3.12 %}
          {% set total = nordpool + 2.827515 + 0.59 + transfer %}
          {% if total < ns.min_price %}
            {% set ns.min_price = total %}
            {% set ns.min_hour = hour %}
          {% endif %}
        {% endfor %}
        {{ ns.min_hour }}
      icon: mdi:clock-star
      attributes:
        time: >
          {% set hour = states('sensor.electricity_cheapest_hour_today') | int(0) %}
          {{ '%02d:00-%02d:00' | format(hour, hour+1) }}
        price: >
          {% set hour = states('sensor.electricity_cheapest_hour_today') | int(0) %}
          {% set nordpool = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'raw_today')[hour] | float(0) * 100 %}
          {% set transfer = 5.11 if (hour >= 7 and hour < 22) else 3.12 %}
          {{ (nordpool + 2.827515 + 0.59 + transfer) | round(2) }} c/kWh
        is_night_rate: >
          {% set hour = states('sensor.electricity_cheapest_hour_today') | int(0) %}
          {{ hour < 7 or hour >= 22 }}
    
    # Today's Most Expensive Hour
    - name: "Electricity Most Expensive Hour Today"
      unique_id: electricity_most_expensive_hour_today
      state: >
        {% set ns = namespace(max_price=0, max_hour=0) %}
        {% for hour in range(24) %}
          {% set nordpool = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'raw_today')[hour] | float(0) * 100 %}
          {% set transfer = 5.11 if (hour >= 7 and hour < 22) else 3.12 %}
          {% set total = nordpool + 2.827515 + 0.59 + transfer %}
          {% if total > ns.max_price %}
            {% set ns.max_price = total %}
            {% set ns.max_hour = hour %}
          {% endif %}
        {% endfor %}
        {{ ns.max_hour }}
      icon: mdi:clock-alert
      attributes:
        time: >
          {% set hour = states('sensor.electricity_most_expensive_hour_today') | int(0) %}
          {{ '%02d:00-%02d:00' | format(hour, hour+1) }}
        price: >
          {% set hour = states('sensor.electricity_most_expensive_hour_today') | int(0) %}
          {% set nordpool = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'raw_today')[hour] | float(0) * 100 %}
          {% set transfer = 5.11 if (hour >= 7 and hour < 22) else 3.12 %}
          {{ (nordpool + 2.827515 + 0.59 + transfer) | round(2) }} c/kWh
    
    # Daily Cost Estimate
    - name: "Electricity Estimated Daily Cost"
      unique_id: electricity_estimated_daily_cost
      unit_of_measurement: "€"
      device_class: monetary
      state: >
        {% set day_hours = 15 %}
        {% set night_hours = 9 %}
        {% set avg_nordpool_day = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'average') | float(0) * 100 %}
        {% set avg_nordpool_night = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'min') | float(0) * 100 %}
        {% set avg_power = states('sensor.total_power_consumption') | float(0) %}
        
        {% set day_cost = avg_power * day_hours * (avg_nordpool_day + 2.827515 + 0.59 + 5.11) / 100 %}
        {% set night_cost = avg_power * night_hours * (avg_nordpool_night + 2.827515 + 0.59 + 3.12) / 100 %}
        {% set base_fee_daily = 5.99 / 30 %}
        
        {{ (day_cost + night_cost + base_fee_daily) | round(2) }}
      icon: mdi:calendar-today
      attributes:
        without_base_fee: >
          {% set day_hours = 15 %}
          {% set night_hours = 9 %}
          {% set avg_nordpool_day = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'average') | float(0) * 100 %}
          {% set avg_nordpool_night = state_attr('sensor.nordpool_kwh_fi_eur_3_10_0', 'min') | float(0) * 100 %}
          {% set avg_power = states('sensor.total_power_consumption') | float(0) %}
          {% set day_cost = avg_power * day_hours * (avg_nordpool_day + 2.827515 + 0.59 + 5.11) / 100 %}
          {% set night_cost = avg_power * night_hours * (avg_nordpool_night + 2.827515 + 0.59 + 3.12) / 100 %}
          {{ (day_cost + night_cost) | round(2) }} €
        base_fee_portion: "{{ (5.99 / 30) | round(2) }} €"
    
    # Monthly Cost Estimate
    - name: "Electricity Estimated Monthly Cost"
      unique_id: electricity_estimated_monthly_cost
      unit_of_measurement: "€"
      device_class: monetary
      state: >
        {% set daily_cost = states('sensor.electricity_estimated_daily_cost') | float(0) %}
        {{ (daily_cost * 30) | round(2) }}
      icon: mdi:calendar-month
      attributes:
        breakdown: >
          Daily avg: {{ states('sensor.electricity_estimated_daily_cost') }} € × 30 days
        includes_base_fee: "Yes (5.99 €/month)"
    
    # Potential Savings (if all flexible loads moved to night)
    - name: "Electricity Potential Night Savings"
      unique_id: electricity_potential_night_savings
      unit_of_measurement: "€"
      device_class: monetary
      state: >
        {% set flexible_loads = 3 + 11 + 7 %}
        {% set hours_per_day = 4 %}
        {% set transfer_diff = 5.11 - 3.12 %}
        {% set avg_nordpool_diff = 3 %}
        {% set total_diff = transfer_diff + avg_nordpool_diff %}
        {{ (flexible_loads * hours_per_day * total_diff / 100 * 30) | round(2) }}
      icon: mdi:piggy-bank
      attributes:
        per_day: >
          {% set flexible_loads = 3 + 11 + 7 %}
          {% set hours_per_day = 4 %}
          {% set transfer_diff = 5.11 - 3.12 %}
          {% set avg_nordpool_diff = 3 %}
          {% set total_diff = transfer_diff + avg_nordpool_diff %}
          {{ (flexible_loads * hours_per_day * total_diff / 100) | round(2) }} €
        explanation: >
          By moving flexible loads (boiler 3kW, car 11kW, sauna 7kW) to night hours, 
          you save on both transfer fees (1.99 c/kWh) and typically lower Nordpool prices (avg 3 c/kWh)

- binary_sensor:
    # Is Night Tariff Active
    - name: "Electricity Night Tariff Active"
      unique_id: electricity_night_tariff_active
      device_class: running
      state: >
        {% set hour = now().hour %}
        {{ hour < 7 or hour >= 22 }}
      icon: >
        {% if is_state('binary_sensor.electricity_night_tariff_active', 'on') %}
          mdi:weather-night
        {% else %}
          mdi:weather-sunny
        {% endif %}
      attributes:
        current_rate: >
          {{ states('sensor.electricity_transfer_tariff') }} c/kWh
        ends_at: >
          {% set hour = now().hour %}
          {% if hour < 7 or hour >= 22 %}
            {{ today_at("07:00") if hour >= 22 else today_at("07:00") }}
          {% else %}
            {{ today_at("22:00") }}
          {% endif %}
```

---

## 🎯 Helper Input Numbers

Add these to your `input_number.yaml` for customization:

```yaml
# Monthly Base Fee (for calculations)
electricity_base_fee:
  name: Monthly Base Fee
  min: 0
  max: 20
  step: 0.01
  unit_of_measurement: €
  icon: mdi:cash
  initial: 5.99

# Flexible Load Total Power (for savings calc)
flexible_loads_total_power:
  name: Flexible Loads Total Power
  min: 0
  max: 30
  step: 0.5
  unit_of_measurement: kW
  icon: mdi:flash
  initial: 21
```

---

## 📊 Usage in Dashboard

These sensors can be used in your dashboard for:
1. Real-time price monitoring
2. Cost estimation
3. Savings tracking
4. Optimal scheduling decisions

See `DASHBOARD_PRICING.md` for complete dashboard integration.

---

**Note:** Make sure your Nordpool sensor entity ID matches: `sensor.nordpool_kwh_fi_eur_3_10_0`  
If different, replace all instances in the template above.
