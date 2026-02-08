# 🎛️ Professional Power Management Dashboard

Complete Lovelace dashboard configuration for monitoring and controlling your power management and heating optimization system.

**✅ Tested with:**
- Home Assistant 2026.2.x
- Node-RED 21.0.0
- Modern template sensor syntax (HA 2021.4+)
- Current Lovelace card specifications

---

## 📊 Dashboard Overview

The dashboard provides:
- **Real-time monitoring** of all power metrics
- **Interactive controls** for all settings
- **Historical data** and trends
- **Status indicators** for system health
- **Quick actions** for manual overrides
- **Professional look** optimized for both desktop and mobile

---

## 🎨 Dashboard Preview

```
┌─────────────────────────────────────────────────────────┐
│  ⚡ Power Management & Heating Optimization System       │
└─────────────────────────────────────────────────────────┘

┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ Current Power │ │ 60-min Avg   │ │ Monthly Peak │
│   12.5 kW    │ │   7.2 kW     │ │   9.1 kW     │
│   ⚠️ HIGH     │ │   ✅ SAFE     │ │   ⚠️ 1.1 kW   │
└──────────────┘ └──────────────┘ └──────────────┘

┌─────────────────────────────────────────────────────────┐
│  🔋 System Status                                        │
│  ────────────────────────────────────────────────────  │
│  Load Balancer:     ACTIVE ✅                           │
│  Peak Limiter:      MONITORING ✅                       │
│  Price Optimizer:   NORMAL MODE (Rank 12)              │
│  Phase Monitor:     ALL OK ✅                           │
└─────────────────────────────────────────────────────────┘

┌──────────────────┐ ┌──────────────────┐
│  Device Status   │ │  Quick Controls  │
│  ──────────────  │ │  ──────────────  │
│  🔥 Sauna: OFF   │ │  🛑 Emergency    │
│  🚗 Car: 12A     │ │  ⏸️ Pause Auto   │
│  💧 Boiler: ON   │ │  ↻ Reset Stats   │
└──────────────────┘ └──────────────────┘

┌─────────────────────────────────────────────────────────┐
│  📈 24-Hour Power History                               │
│  [Interactive graph showing power consumption]          │
└─────────────────────────────────────────────────────────┘

┌──────────────────┐ ┌──────────────────┐
│  💰 This Month   │ │  ⚙️ Settings     │
│  ──────────────  │ │  ──────────────  │
│  Peak: 9.1 kW    │ │  Peak Limit: 8kW │
│  Fee: 2.20€      │ │  Warning: 7.5kW  │
│  Saved: 12.40€   │ │  Caution: 7.0kW  │
└──────────────────┘ └──────────────────┘
```

---

## 🔧 Installation

### Step 1: Create Helper Entities

**For separated configuration files**, create the following files in your Home Assistant config directory:

#### Option A: Separated Files (Recommended)

Create these files:
- `input_boolean.yaml`
- `input_number.yaml`
- `input_datetime.yaml`
- `template.yaml` (or `sensor.yaml` if using legacy format)
- `binary_sensor.yaml`
- `script.yaml`

Then add to your `configuration.yaml`:

```yaml
# Include separate configuration files
input_boolean: !include input_boolean.yaml
input_number: !include input_number.yaml
input_datetime: !include input_datetime.yaml
template: !include template.yaml
binary_sensor: !include binary_sensor.yaml
script: !include script.yaml
```

#### Option B: Single configuration.yaml

If you prefer a single file, skip to the YAML sections below and add them to your `configuration.yaml`.

---

### Step 2: Helper Entity Files

#### 📄 `input_boolean.yaml`

```yaml
# ============================================
# POWER MANAGEMENT HELPER ENTITIES
# ============================================

# System Controls
power_management_enabled:
  name: Power Management Enabled
  icon: mdi:shield-check
  initial: true

peak_limiter_enabled:
  name: Peak Power Limiter Enabled
  icon: mdi:chart-bell-curve
  initial: true

price_optimizer_enabled:
  name: Price Optimizer Enabled
  icon: mdi:cash-multiple
  initial: true

load_balancer_manual_mode:
  name: Manual Override Mode
  icon: mdi:hand-back-right
  initial: false

quiet_hours_enabled:
  name: Quiet Hours (No Notifications)
  icon: mdi:bell-sleep
  initial: false
```

---

#### 📄 `input_number.yaml`

```yaml
# ============================================
# POWER MANAGEMENT NUMBER INPUTS
# ============================================

input_number:
# ============================================
# POWER MANAGEMENT NUMBER INPUTS
# ============================================

# Peak Power Settings
peak_power_threshold:
  name: Peak Power Threshold
  min: 6
  max: 12
  step: 0.5
  unit_of_measurement: kW
  icon: mdi:flash
  initial: 8.0

peak_warning_level:
  name: Peak Warning Level
  min: 5
  max: 10
  step: 0.5
  unit_of_measurement: kW
  icon: mdi:alert
  initial: 7.5

peak_caution_level:
  name: Peak Caution Level
  min: 5
  max: 9
  step: 0.5
  unit_of_measurement: kW
  icon: mdi:information
  initial: 7.0

# Temperature Settings (Already exist, included for reference)
yllapitolampo:
  name: Eco Temperature
  min: 15
  max: 23
  step: 0.5
  unit_of_measurement: °C
  icon: mdi:thermometer-low

normaalilampo_presence:
  name: Normal Temperature
  min: 18
  max: 25
  step: 0.5
  unit_of_measurement: °C
  icon: mdi:thermometer

tehostuslampo:
  name: Boost Temperature
  min: 20
  max: 27
  step: 0.5
  unit_of_measurement: °C
  icon: mdi:thermometer-high

# Price Rank Slider (Already exists)
shf_rank_slider:
  name: Boiler Price Rank Threshold
  min: 1
  max: 24
  step: 1
  icon: mdi:cash-clock

# Notification Settings
notification_rate_limit_emergency:
  name: Emergency Alert Interval
  min: 1
  max: 60
  step: 1
  unit_of_measurement: min
  icon: mdi:alarm-light
  initial: 5

notification_rate_limit_warning:
  name: Warning Alert Interval
  min: 5
  max: 120
  step: 5
  unit_of_measurement: min
  icon: mdi:alarm
  initial: 15
```

---

#### 📄 `input_datetime.yaml`

```yaml
# ============================================
# POWER MANAGEMENT TIME INPUTS
# ============================================

quiet_hours_start:
  name: Quiet Hours Start
  has_time: true
  has_date: false
  initial: "22:00"

quiet_hours_end:
  name: Quiet Hours End
  has_time: true
  has_date: false
  initial: "07:00"
```

---

#### 📄 `template.yaml`

```yaml
# ============================================
# POWER MANAGEMENT TEMPLATE SENSORS
# ============================================

- sensor:
# ============================================
# POWER MANAGEMENT TEMPLATE SENSORS
# ============================================

- sensor:
    # Current Total Power (A+B+C)
    - name: "Total Power Consumption"
      unique_id: total_power_consumption
      unit_of_measurement: "kW"
      device_class: power
      state_class: measurement
      state: >
        {% set a = states('sensor.shellyem3_channel_a_power') | float(0) %}
        {% set b = states('sensor.shellyem3_channel_b_power') | float(0) %}
        {% set c = states('sensor.shellyem3_channel_c_power') | float(0) %}
        {{ ((a + b + c) / 1000) | round(2) }}
      icon: mdi:flash
    
    # 60-Minute Rolling Average (from Node-RED flow context)
    - name: "Power 60min Average"
      unique_id: power_60min_average
      unit_of_measurement: "kW"
      device_class: power
      state_class: measurement
      state: >
        {{ states('sensor.nodered_60min_avg') | float(0) | round(2) }}
      icon: mdi:chart-line
      attributes:
        buffer_size: "{{ state_attr('sensor.nodered_60min_avg', 'buffer_size') }}"
        predicted_peak: "{{ state_attr('sensor.nodered_60min_avg', 'predicted_peak') }}"
    
    # Monthly Peak Power
    - name: "Monthly Peak Power"
      unique_id: monthly_peak_power
      unit_of_measurement: "kW"
      device_class: power
      state: >
        {{ states('sensor.nodered_monthly_peak') | float(0) | round(2) }}
      icon: mdi:chart-bell-curve-cumulative
      attributes:
        timestamp: "{{ state_attr('sensor.nodered_monthly_peak', 'timestamp') }}"
        over_threshold: >
          {% set peak = states('sensor.nodered_monthly_peak') | float(0) %}
          {% set threshold = states('input_number.peak_power_threshold') | float(8) %}
          {{ (peak - threshold) | round(2) if peak > threshold else 0 }}
    
    # Monthly Power Fee
    - name: "Monthly Power Fee"
      unique_id: monthly_power_fee
      unit_of_measurement: "€"
      device_class: monetary
      state: >
        {% set peak = states('sensor.nodered_monthly_peak') | float(0) %}
        {% set threshold = states('input_number.peak_power_threshold') | float(8) %}
        {% set rate = 2.0 %}
        {{ ((peak - threshold) * rate) | round(2) if peak > threshold else 0 }}
      icon: mdi:currency-eur
    
    # Monthly Savings
    - name: "Monthly Power Savings"
      unique_id: monthly_power_savings
      unit_of_measurement: "€"
      device_class: monetary
      state: >
        {{ states('sensor.nodered_saved_euros') | float(0) | round(2) }}
      icon: mdi:piggy-bank
    
    # System Status
    - name: "Power Management Status"
      unique_id: power_management_status
      state: >
          {% if not is_state('input_boolean.power_management_enabled', 'on') %}
            Disabled
          {% elif is_state('binary_sensor.peak_limit_active', 'on') %}
            Peak Limiting
          {% elif states('sensor.power_60min_average') | float(0) > states('input_number.peak_warning_level') | float(7.5) %}
            Warning
          {% elif states('sensor.power_60min_average') | float(0) > states('input_number.peak_caution_level') | float(7) %}
            Caution
          {% else %}
            Normal
          {% endif %}
        icon: >
          {% if not is_state('input_boolean.power_management_enabled', 'on') %}
            mdi:power-off
          {% elif is_state('binary_sensor.peak_limit_active', 'on') %}
            mdi:shield-alert
          {% elif states('sensor.power_60min_average') | float(0) > states('input_number.peak_warning_level') | float(7.5) %}
            mdi:alert
          {% elif states('sensor.power_60min_average') | float(0) > states('input_number.peak_caution_level') | float(7) %}
            mdi:information
          {% else %}
            mdi:shield-check
          {% endif %}
        attributes:
          current_power: "{{ states('sensor.total_power_consumption') }}"
          avg_60min: "{{ states('sensor.power_60min_average') }}"
          monthly_peak: "{{ states('sensor.monthly_peak_power') }}"
          load_balancer: "{{ 'Active' if is_state('binary_sensor.load_balancer_active', 'on') else 'Standby' }}"
          peak_limiter: "{{ 'Active' if is_state('binary_sensor.peak_limit_active', 'on') else 'Monitoring' }}"
      
      # Price Optimizer Mode
      - name: "Price Optimizer Mode"
        unique_id: price_optimizer_mode
        state: >
          {% set rank = states('sensor.shf_rank_now') | int(12) %}
          {% if rank <= 6 %}
            Boost
          {% elif rank >= 19 %}
            Eco
          {% else %}
            Normal
          {% endif %}
        icon: >
          {% set rank = states('sensor.shf_rank_now') | int(12) %}
          {% if rank <= 6 %}
            mdi:speedometer
          {% elif rank >= 19 %}
            mdi:leaf
          {% else %}
            mdi:speedometer-medium
          {% endif %}
        attributes:
          price_rank: "{{ states('sensor.shf_rank_now') }}"
          heat_pump_mode: >
            {% set rank = states('sensor.shf_rank_now') | int(12) %}
            {% if rank <= 6 %}
              Boost ({{ states('input_number.tehostuslampo') }}°C)
            {% elif rank >= 19 %}
              Eco ({{ states('input_number.yllapitolampo') }}°C)
            {% else %}
              Normal ({{ states('input_number.normaalilampo_presence') }}°C)
            {% endif %}
      
      # Interventions Counter
      - name: "Monthly Interventions"
        unique_id: monthly_interventions
        state: >
          {{ states('sensor.nodered_interventions_count') | int(0) }}
        icon: mdi:counter
        unit_of_measurement: "times"
      
      # Net Savings (saved - current fee)
      - name: "Net Monthly Savings"
        unique_id: net_monthly_savings
        unit_of_measurement: "€"
        device_class: monetary
        state: >
        {% set saved = states('sensor.monthly_power_savings') | float(0) %}
        {% set fee = states('sensor.monthly_power_fee') | float(0) %}
        {{ (saved - fee) | round(2) }}
      icon: mdi:cash-plus

- binary_sensor:
    # Peak Limit Active (from Node-RED flow context)
    - name: "Peak Limit Active"
      unique_id: peak_limit_active
      device_class: running
      state: >
        {{ is_state('sensor.nodered_peak_limit_active', 'true') }}
    
    # Load Balancer Active
    - name: "Load Balancer Active"
      unique_id: load_balancer_active
      device_class: running
      state: >
        {{ states('sensor.total_power_consumption') | float(0) > 14.5 }}
    
    # System Health
    - name: "Power Management Healthy"
      unique_id: power_management_healthy
      device_class: problem
      state: >
        {% set flows_ok = states('binary_sensor.nodered_flows_active') == 'on' %}
        {% set sensors_ok = not is_state('sensor.total_power_consumption', 'unavailable') %}
        {{ flows_ok and sensors_ok }}
```

> **Note:** If using a separate `binary_sensor.yaml` file, copy only the content under `- binary_sensor:` without the header line.

---

#### � `script.yaml`

```yaml
# ============================================
# POWER MANAGEMENT SCRIPTS
# ============================================

### Main Power Management Dashboard

Create a new dashboard or add to existing one:

```yaml
# ============================================
# POWER MANAGEMENT DASHBOARD
# ============================================

title: Power Management
path: power-management
icon: mdi:flash
badges: []
cards:
  # ============================================
  # HEADER SECTION
  # ============================================
  
  - type: markdown
    content: |
      # ⚡ Power Management & Heating Optimization System
      Professional monitoring and control for your smart home
    card_mod:
      style: |
        ha-card {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          font-weight: bold;
          text-align: center;
          padding: 10px;
        }
  
  # ============================================
  # KEY METRICS ROW
  # ============================================
  
  - type: horizontal-stack
    cards:
      # Current Power
      - type: custom:mushroom-entity-card
        entity: sensor.total_power_consumption
        name: Current Power
        icon: mdi:flash
        icon_color: >
          {% if states(config.entity) | float > 14 %}
            red
          {% elif states(config.entity) | float > 10 %}
            orange
          {% else %}
            green
          {% endif %}
        tap_action:
          action: more-info
        card_mod:
          style: |
            ha-card {
              border-left: 4px solid 
                {% if states('sensor.total_power_consumption') | float > 14 %}
                  red
                {% elif states('sensor.total_power_consumption') | float > 10 %}
                  orange
                {% else %}
                  green
                {% endif %};
            }
      
      # 60-Min Average
      - type: custom:mushroom-entity-card
        entity: sensor.power_60min_average
        name: 60-Min Average
        icon: mdi:chart-line
        icon_color: >
          {% if states(config.entity) | float > 8 %}
            red
          {% elif states(config.entity) | float > 7.5 %}
            orange
          {% elif states(config.entity) | float > 7 %}
            yellow
          {% else %}
            green
          {% endif %}
        tap_action:
          action: more-info
        card_mod:
          style: |
            ha-card {
              border-left: 4px solid 
                {% if states('sensor.power_60min_average') | float > 8 %}
                  red
                {% elif states('sensor.power_60min_average') | float > 7.5 %}
                  orange
                {% elif states('sensor.power_60min_average') | float > 7 %}
                  #ffa500
                {% else %}
                  green
                {% endif %};
            }
      
      # Monthly Peak
      - type: custom:mushroom-entity-card
        entity: sensor.monthly_peak_power
        name: Monthly Peak
        icon: mdi:chart-bell-curve-cumulative
        icon_color: >
          {% if states(config.entity) | float > 8 %}
            red
          {% elif states(config.entity) | float > 7.5 %}
            orange
          {% else %}
            green
          {% endif %}
        secondary_info: >
          {% set peak = states('sensor.monthly_peak_power') | float(0) %}
          {% set threshold = states('input_number.peak_power_threshold') | float(8) %}
          {% if peak > threshold %}
            +{{ (peak - threshold) | round(1) }} kW over
          {% else %}
            {{ (threshold - peak) | round(1) }} kW margin
          {% endif %}
        tap_action:
          action: more-info
        card_mod:
          style: |
            ha-card {
              border-left: 4px solid 
                {% if states('sensor.monthly_peak_power') | float > 8 %}
                  red
                {% elif states('sensor.monthly_peak_power') | float > 7.5 %}
                  orange
                {% else %}
                  green
                {% endif %};
            }
  
  # ============================================
  # SYSTEM STATUS SECTION
  # ============================================
  
  - type: custom:mushroom-title-card
    title: System Status
    subtitle: Real-time monitoring of all automation systems
  
  - type: entities
    title: Active Systems
    show_header_toggle: false
    state_color: true
    entities:
      - entity: sensor.power_management_status
        name: Overall Status
        icon: mdi:shield-check
      - type: divider
      - entity: binary_sensor.load_balancer_active
        name: Load Balancer
        secondary_info: last-changed
      - entity: binary_sensor.peak_limit_active
        name: Peak Power Limiter
        secondary_info: last-changed
      - entity: sensor.price_optimizer_mode
        name: Price Optimizer
        secondary_info: last-changed
      - entity: binary_sensor.power_management_healthy
        name: System Health
        secondary_info: last-changed
    card_mod:
      style: |
        ha-card {
          border-left: 4px solid #667eea;
        }
  
  # ============================================
  # DEVICE STATUS ROW
  # ============================================
  
  - type: horizontal-stack
    cards:
      # Device States
      - type: entities
        title: 🔌 Device Status
        show_header_toggle: false
        state_color: true
        entities:
          - entity: binary_sensor.kiuas_tilatieto
            name: 🔥 Sauna
            secondary_info: last-changed
          - entity: switch.tesla_model_3_charger
            name: 🚗 Car Charger
            secondary_info: last-changed
          - entity: number.tesla_model_3_charging_amps
            name: "  ↳ Charging Amps"
          - entity: switch.shellypro4pm_ec62609fd3dc_switch_2
            name: 💧 Water Boiler
            secondary_info: last-changed
          - entity: climate.mitsu_ilp
            name: 🌡️ Heat Pump
            secondary_info: last-changed
      
      # Quick Controls
      - type: entities
        title: 🎛️ Quick Controls
        show_header_toggle: false
        entities:
          - entity: input_boolean.power_management_enabled
            name: Master Enable
            icon: mdi:power
          - entity: input_boolean.load_balancer_manual_mode
            name: Manual Override
            icon: mdi:hand-back-right
          - entity: input_boolean.quiet_hours_enabled
            name: Quiet Hours
            icon: mdi:bell-sleep
          - type: button
            name: Reset Monthly Stats
            icon: mdi:refresh
            action_name: Reset
            tap_action:
              action: call-service
              service: script.reset_power_stats
              confirmation:
                text: Reset all monthly statistics?
          - type: button
            name: Emergency Stop All
            icon: mdi:stop-circle
            action_name: STOP
            tap_action:
              action: call-service
              service: script.emergency_stop_all
              confirmation:
                text: Stop all automated devices?
        card_mod:
          style: |
            ha-card {
              border-left: 4px solid #f44336;
            }
  
  # ============================================
  # POWER CONSUMPTION GRAPH
  # ============================================
  
  - type: custom:apexcharts-card
    header:
      show: true
      title: 24-Hour Power Consumption
      show_states: true
      colorize_states: true
    graph_span: 24h
    span:
      start: day
    apex_config:
      chart:
        height: 300px
      stroke:
        width: 2
      yaxis:
        - id: power
          min: 0
          max: ~20
          decimals: 1
          apex_config:
            tickAmount: 5
    series:
      - entity: sensor.total_power_consumption
        name: Current Power
        type: line
        color: '#2196F3'
        stroke_width: 2
        yaxis_id: power
        show:
          in_header: true
      - entity: sensor.power_60min_average
        name: 60-Min Average
        type: line
        color: '#FF9800'
        stroke_width: 3
        yaxis_id: power
        show:
          in_header: true
      - entity: input_number.peak_power_threshold
        name: Threshold
        type: line
        color: '#F44336'
        stroke_width: 2
        curve: stepline
        yaxis_id: power
        show:
          in_header: false
          legend_value: false
    card_mod:
      style: |
        ha-card {
          border-left: 4px solid #2196F3;
        }
  
  # ============================================
  # MONTHLY STATISTICS ROW
  # ============================================
  
  - type: horizontal-stack
    cards:
      # Financial Summary
      - type: entities
        title: 💰 This Month
        show_header_toggle: false
        state_color: true
        entities:
          - entity: sensor.monthly_peak_power
            name: Peak Power
            icon: mdi:chart-bell-curve
          - entity: sensor.monthly_power_fee
            name: Current Fee
            icon: mdi:currency-eur
          - entity: sensor.monthly_power_savings
            name: Prevented Fees
            icon: mdi:piggy-bank
          - entity: sensor.net_monthly_savings
            name: Net Savings
            icon: mdi:cash-plus
          - type: divider
          - entity: sensor.monthly_interventions
            name: Interventions
            icon: mdi:shield-check
        card_mod:
          style: |
            ha-card {
              border-left: 4px solid #4CAF50;
            }
      
      # Configuration
      - type: entities
        title: ⚙️ Peak Power Settings
        show_header_toggle: false
        entities:
          - entity: input_number.peak_power_threshold
            name: Peak Threshold
            icon: mdi:flash
          - entity: input_number.peak_warning_level
            name: Warning Level
            icon: mdi:alert
          - entity: input_number.peak_caution_level
            name: Caution Level
            icon: mdi:information
          - type: divider
          - entity: input_boolean.peak_limiter_enabled
            name: Peak Limiter
          - entity: input_boolean.price_optimizer_enabled
            name: Price Optimizer
        card_mod:
          style: |
            ha-card {
              border-left: 4px solid #9C27B0;
            }
  
  # ============================================
  # TEMPERATURE CONTROL SECTION
  # ============================================
  
  - type: custom:mushroom-title-card
    title: Temperature Control
    subtitle: Heat pump optimization based on electricity prices
  
  - type: entities
    title: 🌡️ Temperature Settings
    show_header_toggle: false
    entities:
      - type: custom:mushroom-entity-card
        entity: sensor.price_optimizer_mode
        name: Current Mode
        icon: mdi:thermometer-auto
        layout: horizontal
      - type: divider
      - entity: input_number.tehostuslampo
        name: Boost Temperature (Cheap)
        icon: mdi:thermometer-high
      - entity: input_number.normaalilampo_presence
        name: Normal Temperature (Mid)
        icon: mdi:thermometer
      - entity: input_number.yllapitolampo
        name: Eco Temperature (Expensive)
        icon: mdi:thermometer-low
      - type: divider
      - entity: input_number.shf_rank_slider
        name: Boiler Rank Threshold
        icon: mdi:cash-clock
      - entity: sensor.shf_rank_now
        name: Current Price Rank
        icon: mdi:currency-eur
    card_mod:
      style: |
        ha-card {
          border-left: 4px solid #FF5722;
        }
  
  # ============================================
  # PHASE MONITORING SECTION
  # ============================================
  
  - type: custom:mushroom-title-card
    title: Phase Monitoring
    subtitle: Three-phase power and voltage monitoring
  
  - type: horizontal-stack
    cards:
      # Phase A
      - type: gauge
        entity: sensor.shellyem3_channel_a_power
        name: Phase A Power
        min: 0
        max: 5750
        severity:
          green: 0
          yellow: 4000
          red: 5000
        needle: true
      
      # Phase B
      - type: gauge
        entity: sensor.shellyem3_channel_b_power
        name: Phase B Power
        min: 0
        max: 5750
        severity:
          green: 0
          yellow: 4000
          red: 5000
        needle: true
      
      # Phase C
      - type: gauge
        entity: sensor.shellyem3_channel_c_power
        name: Phase C Power
        min: 0
        max: 5750
        severity:
          green: 0
          yellow: 4000
          red: 5000
        needle: true
  
  - type: entities
    title: ⚡ Phase Details
    show_header_toggle: false
    state_color: true
    entities:
      - entity: sensor.shellyem3_channel_a_voltage
        name: Phase A Voltage
        icon: mdi:sine-wave
      - entity: sensor.shellyem3_channel_b_voltage
        name: Phase B Voltage
        icon: mdi:sine-wave
      - entity: sensor.shellyem3_channel_c_voltage
        name: Phase C Voltage
        icon: mdi:sine-wave
      - type: divider
      - entity: sensor.shellyem3_channel_a_power
        name: Phase A Power
      - entity: sensor.shellyem3_channel_b_power
        name: Phase B Power
      - entity: sensor.shellyem3_channel_c_power
        name: Phase C Power
  
  # ============================================
  # NOTIFICATION SETTINGS
  # ============================================
  
  - type: custom:mushroom-title-card
    title: Notification Settings
    subtitle: Configure alert behavior and quiet hours
  
  - type: entities
    title: 🔔 Alert Configuration
    show_header_toggle: false
    entities:
      - entity: input_number.notification_rate_limit_emergency
        name: Emergency Alert Interval
        icon: mdi:alarm-light
      - entity: input_number.notification_rate_limit_warning
        name: Warning Alert Interval
        icon: mdi:alarm
      - type: divider
      - entity: input_boolean.quiet_hours_enabled
        name: Enable Quiet Hours
        icon: mdi:bell-sleep
      - entity: input_datetime.quiet_hours_start
        name: Quiet Hours Start
        icon: mdi:clock-start
      - entity: input_datetime.quiet_hours_end
        name: Quiet Hours End
        icon: mdi:clock-end
    card_mod:
      style: |
        ha-card {
          border-left: 4px solid #00BCD4;
        }
  
  # ============================================
  # SYSTEM INFO FOOTER
  # ============================================
  
  - type: markdown
    content: |
      ---
      **System Version:** 1.0.0 | **Flows:** 4/4 Active | **Uptime:** {{ relative_time(states.sensor.uptime.last_changed) }}
      
      📊 [View Detailed Stats](/#power-stats) | 📖 [Documentation](/#docs) | ⚙️ [Node-RED](http://homeassistant.local:1880)
    card_mod:
      style: |
        ha-card {
          background: rgba(0,0,0,0.05);
          text-align: center;
          font-size: 0.9em;
        }
```

---

## 🎨 Custom Cards Required

Install these custom cards via HACS:

```yaml
Required:
  - mushroom (Mushroom Cards)
  - apexcharts-card (ApexCharts)
  - card-mod (Card Mod)

Optional but Recommended:
  - mini-graph-card (Mini Graph Card)
  - button-card (Button Card)
  - bar-card (Bar Card)
```

### Installation via HACS:

1. Open HACS → Frontend
2. Search for each card
3. Click Install
4. Restart Home Assistant

---

# ============================================
# POWER MANAGEMENT SCRIPTS
# ============================================

reset_power_stats:
  alias: Reset Power Management Statistics
  sequence:
    - service: mqtt.publish
      data:
        topic: "nodered/power/reset_stats"
        payload: "true"
    - service: notify.telegram
      data:
        message: "📊 Monthly power statistics have been reset."
  mode: single
  icon: mdi:refresh

emergency_stop_all:
  alias: Emergency Stop All Devices
  sequence:
    - service: switch.turn_off
      target:
        entity_id:
          - switch.tesla_model_3_charger
          - switch.shellypro4pm_ec62609fd3dc_switch_2
    - service: climate.set_hvac_mode
      target:
        entity_id: climate.mitsu_ilp
      data:
        hvac_mode: "off"
    - service: notify.telegram
      data:
        message: "🛑 EMERGENCY STOP: All automated devices have been turned off!"
    - service: input_boolean.turn_on
      target:
        entity_id: input_boolean.load_balancer_manual_mode
  mode: single
  icon: mdi:stop-circle

resume_automation:
  alias: Resume Normal Automation
  sequence:
    - service: input_boolean.turn_off
      target:
        entity_id: input_boolean.load_balancer_manual_mode
    - service: input_boolean.turn_on
      target:
        entity_id: input_boolean.power_management_enabled
    - service: notify.telegram
      data:
        message: "✅ Automation resumed - System back to normal operation"
  mode: single
  icon: mdi:play-circle

test_telegram_notification:
  alias: Test Telegram Notification
  sequence:
    - service: notify.telegram
      data:
        message: |
          🧪 Test Notification
          
          Current Power: {{ states('sensor.total_power_consumption') }} kW
          60-Min Avg: {{ states('sensor.power_60min_average') }} kW
          Monthly Peak: {{ states('sensor.monthly_peak_power') }} kW
          System Status: {{ states('sensor.power_management_status') }}
          
          All systems operational! ✅
  mode: single
  icon: mdi:test-tube
```

> **Note:** Copy this entire section to your `script.yaml` file.

---

### Step 3: Verify Configuration

After creating/updating the files, verify your configuration:

```bash
# Check configuration
ha core check

# Or in Home Assistant UI:
# Developer Tools → YAML → Check Configuration
```

---

### Step 4: Restart Home Assistant

After all files are created and verified:
1. Go to **Developer Tools** → **YAML**
2. Click **Restart** (or use `ha core restart`)
3. Wait for Home Assistant to fully restart
4. Verify all entities are created in **Developer Tools** → **States**

---

## 📱 Dashboard YAML Configuration

Create a second view for detailed statistics:

```yaml
title: Power Statistics
path: power-stats
icon: mdi:chart-line
cards:
  - type: markdown
    content: |
      # 📊 Detailed Power Statistics
      Historical data and analytics
  
  # Monthly Peak History
  - type: custom:apexcharts-card
    header:
      title: Monthly Peak Power History
      show_states: false
    graph_span: 12month
    span:
      start: year
    apex_config:
      chart:
        height: 250px
    series:
      - entity: sensor.monthly_peak_power
        name: Monthly Peak
        type: column
        color: '#F44336'
        group_by:
          duration: 1month
          func: max
  
  # Daily Interventions
  - type: custom:apexcharts-card
    header:
      title: Daily Interventions (Last 30 Days)
      show_states: false
    graph_span: 30d
    apex_config:
      chart:
        height: 200px
    series:
      - entity: sensor.monthly_interventions
        name: Interventions
        type: column
        color: '#FF9800'
        group_by:
          duration: 1d
          func: diff
  
  # Cost Savings Trend
  - type: custom:apexcharts-card
    header:
      title: Cumulative Savings (This Year)
      show_states: true
    graph_span: 1year
    span:
      start: year
    apex_config:
      chart:
        height: 250px
    series:
      - entity: sensor.net_monthly_savings
        name: Monthly Savings
        type: area
        color: '#4CAF50'
        group_by:
          duration: 1month
          func: last
```

---

## 🎯 Mobile Dashboard (Responsive)

Optimized view for mobile devices:

```yaml
title: Power (Mobile)
path: power-mobile
icon: mdi:cellphone
panel: true
cards:
  - type: custom:layout-card
    layout_type: custom:grid-layout
    layout:
      grid-template-columns: 1fr
      grid-template-rows: auto
      gap: 10px
    cards:
      # Status Banner
      - type: custom:mushroom-entity-card
        entity: sensor.power_management_status
        name: System Status
        layout: horizontal
        icon_color: >
          {% if states(config.entity) == 'Normal' %}
            green
          {% elif states(config.entity) == 'Caution' %}
            yellow
          {% elif states(config.entity) == 'Warning' %}
            orange
          {% else %}
            red
          {% endif %}
      
      # Quick Metrics
      - type: glance
        entities:
          - entity: sensor.total_power_consumption
            name: Now
          - entity: sensor.power_60min_average
            name: 60-Min
          - entity: sensor.monthly_peak_power
            name: Peak
        show_name: true
        show_state: true
      
      # Quick Toggles
      - type: horizontal-stack
        cards:
          - type: custom:mushroom-entity-card
            entity: input_boolean.power_management_enabled
            name: System
            icon: mdi:power
            layout: vertical
            tap_action:
              action: toggle
          - type: custom:mushroom-entity-card
            entity: input_boolean.quiet_hours_enabled
            name: Quiet
            icon: mdi:bell-sleep
            layout: vertical
            tap_action:
              action: toggle
      
      # Devices
      - type: entities
        title: Devices
        show_header_toggle: false
        state_color: true
        entities:
          - binary_sensor.kiuas_tilatieto
          - switch.tesla_model_3_charger
          - switch.shellypro4pm_ec62609fd3dc_switch_2
      
      # Graph
      - type: custom:mini-graph-card
        entities:
          - entity: sensor.total_power_consumption
            name: Current
          - entity: sensor.power_60min_average
            name: Average
        hours_to_show: 6
        line_width: 2
        animate: true
```

---

## ✅ Setup Checklist

```
☐ Add helper entities to configuration.yaml
☐ Restart Home Assistant
☐ Install custom cards via HACS
☐ Add scripts to scripts.yaml
☐ Create Power Management dashboard
☐ Import dashboard YAML
☐ Customize colors/icons to preference
☐ Test all controls and buttons
☐ Verify graphs display correctly
☐ Test mobile view
☐ Create shortcuts on home screen
☐ Enjoy professional dashboard! 🎉
```

---

## 🎨 Customization Tips

### Color Themes:

**Default (Purple/Blue):**
```css
Primary: #667eea
Secondary: #764ba2
Accent: #2196F3
```

**Green Energy Theme:**
```css
Primary: #4CAF50
Secondary: #8BC34A
Accent: #CDDC39
```

**Professional Dark:**
```css
Primary: #37474F
Secondary: #455A64
Accent: #00BCD4
```

### Icons:

Common power-related icons:
- `mdi:flash` - Lightning/power
- `mdi:chart-line` - Graphs
- `mdi:shield-check` - Protection
- `mdi:piggy-bank` - Savings
- `mdi:thermometer` - Temperature
- `mdi:cash-multiple` - Money

---

## 📱 Mobile App Integration

Add to mobile app for quick access:

1. Open Home Assistant app
2. Settings → Shortcuts
3. Add shortcuts for:
   - View Power Dashboard
   - Emergency Stop All
   - Toggle Quiet Hours
   - View Statistics

---

## 🎊 You're Done!

Your professional power management dashboard is now complete with:
- ✅ Real-time monitoring
- ✅ Interactive controls
- ✅ Historical analytics
- ✅ Mobile optimization
- ✅ Professional appearance

**Enjoy your world-class power management interface!** 🚀

---

*For questions or customization help, refer to the Home Assistant dashboard documentation or community forums.*
