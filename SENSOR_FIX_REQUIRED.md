# 🔧 Sensor Fix Required - Utility Meters Not Working

**Date:** 2026-02-09  
**Issue:** `sensor.talon_kokonaiskulutus_tunti_kwh` and related utility meters showing "0"

---

## 🔍 Problem Diagnosis

### Affected Sensors (All showing state "0")
- ✅ **Exists but broken:** `sensor.talon_kokonaiskulutus_tunti_kwh` (hourly)
- ✅ **Exists but broken:** `sensor.talon_kokonaiskulutus_paiva_kwh` (daily)  
- ✅ **Exists but broken:** `sensor.talon_kokonaiskulutus_viikko_kwh` (weekly)
- ✅ **Exists but broken:** `sensor.talon_kokonaiskulutus_kuukausi_kwh` (monthly) - Actually shows 615.8317 kWh (working!)
- ✅ **Exists but broken:** `sensor.talon_kokonaiskulutus_vuosi_kwh` (yearly) - Actually shows 2181.7308 kWh (working!)

###Root Cause
**Source Sensor is Unavailable:**
```
sensor.sahkon_kokonaisenergia = "unavailable"
```

This template sensor should sum the three ShellyEM3 energy channels:
- `sensor.shellyem3_channel_a_energy` = **28199.0024 kWh** ✅ Working
- `sensor.shellyem3_channel_b_energy` = **18297.5536 kWh** ✅ Working
- `sensor.shellyem3_channel_c_energy` = **18149.3896 kWh** ✅ Working
- **Expected Total:** 64645.9456 kWh

### Utility Meter Status
```yaml
Status: collecting
Last Valid State: None  ← THIS IS THE PROBLEM
Last Reset: 2026-02-09 06:00:00
Next Reset: 2026-02-09 09:00:00
```

The utility_meter has never received a valid value from the source sensor.

---

## 🏥 Solution Options

### Option 1: Deploy Existing Template Sensor (RECOMMENDED)

The template sensor definition exists in `power-management/template_sensors.yaml` lines 163-178:

```yaml
- name: "Sähkön kokonaisenergia"
  unique_id: sahko_kokonaiskulutus_energia
  unit_of_measurement: "kWh"
  device_class: energy
  state_class: total_increasing
  state: >
    {% set a = states('sensor.shellyem3_channel_a_energy') | float(0) %}
    {% set b = states('sensor.shellyem3_channel_b_energy') | float(0) %}
    {% set c = states('sensor.shellyem3_channel_c_energy') | float(0) %}
    {{ (a + b + c) | round(2) }}
  icon: mdi:lightning-bolt
  attributes:
    channel_a: "{{ states('sensor.shellyem3_channel_a_energy') | float(0) }}"
    channel_b: "{{ states('sensor.shellyem3_channel_b_energy') | float(0) }}"
    channel_c: "{{ states('sensor.shellyem3_channel_c_energy') | float(0) }}"
```

**Action:** Add this to your active Home Assistant configuration.

### Option 2: Create in config/sensors/

Create file: `config/sensors/total_energy.yaml`

```yaml
# Total Energy Sensor for Utility Meters
template:
  - sensor:
      - name: "Sähkön kokonaisenergia"
        unique_id: sahko_kokonaisenergia
        unit_of_measurement: "kWh"
        device_class: energy
        state_class: total_increasing
        state: >
          {% set a = states('sensor.shellyem3_channel_a_energy') | float(0) %}
          {% set b = states('sensor.shellyem3_channel_b_energy') | float(0) %}
          {% set c = states('sensor.shellyem3_channel_c_energy') | float(0) %}
          {{ (a + b + c) | round(2) }}
        icon: mdi:lightning-bolt
        attributes:
          channel_a: "{{ states('sensor.shellyem3_channel_a_energy') | float(0) }}"
          channel_b: "{{ states('sensor.shellyem3_channel_b_energy') | float(0) }}"
          channel_c: "{{ states('sensor.shellyem3_channel_c_energy') | float(0) }}"
          phase_a_kwh: "{{ states('sensor.shellyem3_channel_a_energy') }}"
          phase_b_kwh: "{{ states('sensor.shellyem3_channel_b_energy') }}"
          phase_c_kwh: "{{ states('sensor.shellyem3_channel_c_energy') }}"
```

### Option 3: Verify Utility Meter Configuration

Check your Home Assistant `configuration.yaml` or `utility_meter.yaml` for:

```yaml
utility_meter:
  talon_kokonaiskulutus_tunti:
    source: sensor.sahkon_kokonaisenergia  # ← This sensor must exist!
    cycle: hourly
    name: "Talon kokonaiskulutus, tunti"
    
  talon_kokonaiskulutus_paiva:
    source: sensor.sahkon_kokonaisenergia
    cycle: daily
    name: "Talon kokonaiskulutus, päivä"
    
  talon_kokonaiskulutus_viikko:
    source: sensor.sahkon_kokonaisenergia
    cycle: weekly
    name: "Talon kokonaiskulutus, viikko"
    
  talon_kokonaiskulutus_kuukausi:
    source: sensor.sahkon_kokonaisenergia
    cycle: monthly
    name: "Talon kokonaiskulutus, kuukausi"
    
  talon_kokonaiskulutus_vuosi:
    source: sensor.sahkon_kokonaisenergia
    cycle: yearly
    name: "Talon kokonaiskulutus, vuosi"
```

---

## 🚨 Other Potential Issues

Let me check for other broken sensors in your dashboards...

### Sensors Used in Dashboards

**Professional Dashboard** (`dashboards/power-management-professional.yaml`):
- Line 107: `sensor.talon_kokonaiskulutus_tunti_kwh` ❌ BROKEN (0)
- Line 39: `sensor.talon_kokonaiskulutus_paiva_kwh` ❌ BROKEN (0)
- Line 729: `sensor.talon_kokonaiskulutus_kuukausi_kwh` ✅ WORKING (615.83)
- Line 696: `sensor.talon_kokonaiskulutus_kuukausi_kwh` ✅ WORKING (615.83)

**Mobile Dashboard** (`dashboards/power-management-mobile.yaml`):
- Line 225: `sensor.talon_kokonaiskulutus_tunti_kwh` ❌ BROKEN (0)
- Line 497: `sensor.talon_kokonaiskulutus_tunti_kwh` ❌ BROKEN (0)
- Line 438: `sensor.talon_kokonaiskulutus_paiva_kwh` ❌ BROKEN (0)
- Line 813: `sensor.talon_kokonaiskulutus_paiva_kwh` ❌ BROKEN (0)

### Impact
- **Hourly consumption charts:** Not showing data ❌
- **Daily consumption gauges:** Not showing data ❌
- **Weekly/Monthly/Yearly:** Working ✅
- **AI prompts:** Using broken sensors ❌

---

## 📋 Step-by-Step Fix

### 1. Create Template Sensor

**SSH to Home Assistant:**
```bash
ssh root@homeassistant
cd /config
```

**Create file:** `template_sensors_total_energy.yaml`
```bash
nano template_sensors_total_energy.yaml
```

**Paste this content:**
```yaml
template:
  - sensor:
      - name: "Sähkön kokonaisenergia"
        unique_id: sahkon_kokonaisenergia
        unit_of_measurement: "kWh"
        device_class: energy
        state_class: total_increasing
        state: >
          {% set a = states('sensor.shellyem3_channel_a_energy') | float(0) %}
          {% set b = states('sensor.shellyem3_channel_b_energy') | float(0) %}
          {% set c = states('sensor.shellyem3_channel_c_energy') | float(0) %}
          {{ (a + b + c) | round(2) }}
        icon: mdi:lightning-bolt
        availability: >
          {{ states('sensor.shellyem3_channel_a_energy') not in ['unavailable', 'unknown', 'none'] and
             states('sensor.shellyem3_channel_b_energy') not in ['unavailable', 'unknown', 'none'] and
             states('sensor.shellyem3_channel_c_energy') not in ['unavailable', 'unknown', 'none'] }}
        attributes:
          phase_a_kwh: "{{ states('sensor.shellyem3_channel_a_energy') }}"
          phase_b_kwh: "{{ states('sensor.shellyem3_channel_b_energy') }}"
          phase_c_kwh: "{{ states('sensor.shellyem3_channel_c_energy') }}"
```

Save (Ctrl+X, Y, Enter)

### 2. Add to configuration.yaml

**Edit configuration.yaml:**
```bash
nano /config/configuration.yaml
```

**Add this line:**
```yaml
template: !include template_sensors_total_energy.yaml
```

Or if you already have `template:` section, merge it.

### 3. Check Configuration

```bash
ha core check
```

Should show: "Configuration valid!"

### 4. Restart Home Assistant

**From UI:**
- Settings → System → Restart

**Or from SSH:**
```bash
ha core restart
```

Wait 2-3 minutes.

### 5. Verify Fix

**Developer Tools → States:**
```
sensor.sahkon_kokonaisenergia = 64645.95 kWh (or similar)
```

**Check utility meters (wait 1-2 hours for data):**
```
sensor.talon_kokonaiskulutus_tunti_kwh > 0
sensor.talon_kokonaiskulutus_paiva_kwh > 0
```

---

## 🔍 Additional Checks Needed

### 1. Check for More Unavailable Sensors

Run this in Developer Tools → Template:
```jinja2
{% for state in states.sensor %}
  {% if state.state == 'unavailable' %}
    {{ state.entity_id }}: {{ state.name }}
  {% endif %}
{% endfor %}
```

### 2. Validate Dashboard Sensors

**Professional Dashboard** - Check these sensors exist:
- `sensor.average_power_factor` (line 56)
- `sensor.sahko_hinnan_korjaus_*` (multiple locations)
- `sensor.electricity_total_price_cents` (multiple locations)

**Mobile Dashboard** - Check these sensors exist:
- `sensor.current_power_consumption` (line 32)
- All input_number helpers

### 3. Check AI Prompts

**File:** `ai/prompts/energy_analysis.yaml`
- Line 11: Uses `sensor.talon_kokonaiskulutus_paiva_kwh` ❌ BROKEN

**File:** `ai/prompts/power_report.yaml`
- Uses `sensor.talon_kokonaiskulutus_paiva_kwh` ❌ BROKEN

**File:** `config/automations/notifications.yaml`
- Line 184: Uses `sensor.talon_kokonaiskulutus_paiva_kwh` ❌ BROKEN

These will start working once the source sensor is fixed.

---

## 📊 Expected Results After Fix

Once `sensor.sahkon_kokonaisenergia` is available:

### Immediate (After restart)
- ✅ `sensor.sahkon_kokonaisenergia` shows ~64,646 kWh
- ✅ Utility meters change status from "collecting" with valid data

### After 1 Hour
- ✅ `sensor.talon_kokonaiskulutus_tunti_kwh` starts accumulating (should show 1-5 kWh)

### After 1 Day
- ✅ `sensor.talon_kokonaiskulutus_paiva_kwh` shows daily total (typically 40-80 kWh)

### Dashboard Impact
- ✅ Hourly consumption charts start showing data
- ✅ Daily consumption gauges work
- ✅ 7-day trends populate
- ✅ AI prompts return accurate consumption data

---

## 💡 Prevention

To prevent this in the future:

1. **Add availability template** to all important template sensors
2. **Monitor sensor health** with automation:
```yaml
automation:
  - alias: "Alert: Critical Sensor Unavailable"
    trigger:
      - platform: state
        entity_id: sensor.sahkon_kokonaisenergia
        to: 'unavailable'
        for: "00:05:00"
    action:
      - service: notify.iphone17
        data:
          title: "⚠️ Critical Sensor Unavailable"
          message: "sensor.sahkon_kokonaisenergia is unavailable. Utility meters will not work!"
```

3. **Regular validation** of dashboard sensors

---

## 🆘 If Problem Persists

1. Check Home Assistant logs:
   ```bash
   tail -f /config/home-assistant.log | grep "sahkon_kokonaisenergia"
   ```

2. Check ShellyEM3 device status in HA
3. Verify ShellyEM3 channels are reporting energy (they are ✅)
4. Try recreating utility_meters with reset
5. Contact if errors appear in logs

---

**Status:** 🔴 **CRITICAL** - Affects multiple dashboards and AI features  
**Priority:** 🔥 **HIGH** - Should be fixed ASAP  
**Complexity:** ⭐ **LOW** - Simple template sensor deployment

**Est. Fix Time:** 10 minutes
