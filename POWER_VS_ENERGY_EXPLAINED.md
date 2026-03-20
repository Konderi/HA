# ⚡ Power vs Energy Sensors - Which to Use?

## 🤔 The Confusion

You have **two types** of sensors from ShellyEM3:

| Sensor Type | What It Measures | Example Value | Use Case |
|-------------|------------------|---------------|----------|
| **Energy** | Cumulative total (like odometer) | 28.2 kWh | ✅ Utility meters |
| **Power** | Current draw (like speedometer) | 2,450 W | ✅ Real-time monitoring |

---

## 📊 Option 1: Energy Sensors (RECOMMENDED) ✅

### Current Configuration
**File:** `config/sensors/total_energy_sensor.yaml`

```yaml
- name: "Sähkön kokonaisenergia"
  state_class: total_increasing  # Cumulative total
  unit_of_measurement: "kWh"
  state: >
    {{ ((a + b + c) / 1000) | round(2) }}
```

### How It Works
```
09:00 → Energy = 64.5 kWh
10:00 → Energy = 66.8 kWh
Consumption = 66.8 - 64.5 = 2.3 kWh ✅
```

### Advantages
- ✅ **Most accurate** - Direct meter reading
- ✅ **No integration errors** - Exact values
- ✅ **Standard approach** - How all energy meters work
- ✅ **Persistent** - Survives restarts without data loss
- ✅ **What utility companies use** - Same as your electricity bill

### Use This If
- You want accurate consumption tracking
- You trust ShellyEM3 energy readings
- You want the standard solution

---

## ⚡ Option 2: Power Sensors with Integration

### Alternative Configuration  
**File:** `config/sensors/total_power_sensor_integrated.yaml`

```yaml
# Step 1: Sum power sensors
- name: "Sähkön kokonaisteho"
  state_class: measurement  # Instantaneous value
  unit_of_measurement: "W"
  state: >
    {{ (a + b + c) | round(0) }}

# Step 2: Integrate power → energy
sensor:
  - platform: integration
    source: sensor.sahkon_kokonaisteho
    unit_prefix: k  # kWh
```

### How It Works
```
Power readings every second:
2,450 W × 1h = 2.45 kWh
Integrated over time = consumption
```

### Disadvantages
- ⚠️ **Less accurate** - Integration introduces errors
- ⚠️ **Accumulates drift** - Small errors add up over time
- ⚠️ **Resets on restart** - Loses progress (unless configured otherwise)
- ⚠️ **More complex** - Extra integration step
- ⚠️ **Unnecessary** - ShellyEM3 already provides energy!

### Use This If
- Energy sensors are broken/unavailable
- You need real-time consumption changes
- You have a specific reason not to use energy sensors

---

## 🏆 Recommendation: Use Energy Sensors

### Why?

**ShellyEM3 already measures energy accurately!**
- It has internal counters that track kWh
- These are the same counters utilities use
- More reliable than integrating power readings

**Your old config used energy sensors:**
```yaml
# From archive/current_config_phase2/template_sensors.yaml
- name: "Total Energy Consumption"
  state: >
    {% set a = states('sensor.shellyem3_channel_a_energy') | float(0) %}
    {% set b = states('sensor.shellyem3_channel_b_energy') | float(0) %}
    {% set c = states('sensor.shellyem3_channel_c_energy') | float(0) %}
    {{ (a + b + c) | round(2) }}  # ← Used energy, not power!
```

### The Only Fix Needed

**Just convert Wh → kWh:** Add `/1000`

```yaml
{{ ((a + b + c) / 1000) | round(2) }}
```

---

## 🔍 Understanding the Difference

### Real-World Analogy

**Energy sensor** = Car odometer (total km driven)
- Keeps increasing: 10,000 km → 10,050 km → 10,100 km
- Trip meter: 10,100 - 10,000 = 100 km traveled
- **This is what utility meters need!**

**Power sensor** = Car speedometer (current speed)
- Changes constantly: 0 km/h → 80 km/h → 50 km/h → 0 km/h  
- To calculate distance: integrate speed over time (complex!)
- **This is what power monitoring shows!**

---

## ✅ What You Should Do

### Keep Your Current Energy-Based Setup

1. **Use:** `config/sensors/total_energy_sensor.yaml` (with `/1000` fix)
2. **Deploy it** to Home Assistant
3. **Update utility meters** to use `sensor.sahkon_kokonaisenergia_2`
4. **Done!** ✅

### When to Create Power Sensors

Create **separate power sensors** for **real-time monitoring**:

```yaml
# For dashboard gauges showing current consumption
- name: "Current Power Consumption"
  unit_of_measurement: "kW"
  state: >
    {{ ((a + b + c) / 1000) | round(2) }}
```

Use these on dashboards to show **right now** consumption, but **keep energy sensors for utility meters**.

---

## 📁 Files Summary

| File | Purpose | Status |
|------|---------|--------|
| `total_energy_sensor.yaml` | ✅ Energy-based (recommended) | Ready |
| `total_power_sensor_integrated.yaml` | ⚡ Power-based (alternative) | Available if needed |

---

## 🎯 TL;DR

- **Utility meters** need **energy sensors** (cumulative totals)
- **ShellyEM3** provides accurate **energy sensors**  
- **Power sensors** are for **real-time monitoring**, not consumption tracking
- **Your current setup is correct** - just needed `/1000` for Wh→kWh conversion
- **Don't overthink it** - use energy sensors like your old config did! ✅
