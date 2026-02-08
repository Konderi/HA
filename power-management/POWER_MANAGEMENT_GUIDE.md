# Power Management System - Complete Guide

## System Overview

Your intelligent power management system consists of **3 main Node-RED flows** that work together:

### 1. **Priority Load Balancer** (`priority-load-balancer.json`)
Prevents fuse overload by intelligently managing high-power devices.

### 2. **Price-Based Optimizer** (`price-based-optimizer.json`)
Optimizes energy usage based on electricity prices and schedules devices during cheap hours.

### 3. **Phase Monitor & Alerts** (`phase-monitor-alerts.json`)
Monitors electrical system health and sends Telegram alerts for issues.

---

## System Specifications

### Main Fuses
- **3 × 25A @ 230V**
- **Total Capacity:** 17,250W
- **Per Phase:** 5,750W max

### High-Power Devices

| Device | Power | Priority | Entity IDs |
|--------|-------|----------|------------|
| **Sauna** | 7kW | 1 (Highest) | `binary_sensor.kiuas_tilatieto`<br>`switch.sauna_channel_1` |
| **Tesla Charger** | 11kW max | 2 | `switch.tesla_model_3_charger`<br>`number.tesla_model_3_charging_amps` |
| **Water Boiler** | 3kW | 3 | `switch.shellypro4pm_ec62609fd3dc_switch_2` |

### Monitoring Sensors

| Type | Entity |
|------|--------|
| Total Power | `sensor.sahko_kokonaiskulutus_teho` |
| Phase A Power | `sensor.shellyem3_channel_a_power` |
| Phase B Power | `sensor.shellyem3_channel_b_power` |
| Phase C Power | `sensor.shellyem3_channel_c_power` |
| Phase A Voltage | `sensor.shellyem3_channel_a_voltage` |
| Phase B Voltage | `sensor.shellyem3_channel_b_voltage` |
| Phase C Voltage | `sensor.shellyem3_channel_c_voltage` |
| Electricity Price | `sensor.sahko_kokonaishinta_c` |
| Price Rank | `sensor.shf_rank_now` (1=cheapest, 24=most expensive) |

### Configuration Sliders

| Slider | Purpose | Entity |
|--------|---------|--------|
| Boiler Hours | How many cheapest hours to heat | `input_number.shf_rank_slider` |
| Heat Pump - Boost | Temperature during 6 cheapest hours | `input_number.tehostuslampo` |
| Heat Pump - Normal | Temperature during 12 middle hours | `input_number.normaalilampo_presence` |
| Heat Pump - Eco | Temperature during 6 most expensive hours | `input_number.yllapitolampo` |

---

## How It Works

### Priority Load Balancing

#### Scenario 1: Normal Operation
- Car charges at 16A (full power)
- Water boiler runs during cheap hours
- Heat pump adjusts temperature based on price

#### Scenario 2: Sauna Turns ON
1. **Immediate Actions:**
   - Water boiler turns OFF
   - Car charging reduces to 8A (or OFF if needed)
   
2. **Reasoning:**
   - Sauna: 7kW
   - Available: 10.25kW
   - Allows reduced car charging if needed

#### Scenario 3: High Power Load (>85%)
1. **Warning Level (85-95%):**
   - Gradually reduce car charging: 16A → 14A → 12A → 10A
   
2. **Critical Level (>95%):**
   - Emergency reduction
   - Car to minimum (6A) or OFF
   - Turn off water boiler
   - Send Telegram alert

#### Scenario 4: Car + Boiler Together
- Boiler: 3kW
- Car reduced to 12A (~8.3kW)
- Total: ~11.3kW ✅ Safe!

### Price-Based Optimization

#### Heat Pump (climate.mitsu_ilp)
- **6 cheapest hours (Rank 1-6):**
  - Set to `input_number.tehostuslampo` (boost temp)
  - Example: 23°C
  
- **12 middle hours (Rank 7-18):**
  - Set to `input_number.normaalilampo_presence` (normal temp)
  - Example: 21°C
  
- **6 most expensive hours (Rank 19-24):**
  - Set to `input_number.yllapitolampo` (eco temp)
  - Example: 19°C

#### Water Boiler
- Runs when `sensor.shf_rank_now ≤ input_number.shf_rank_slider`
- Example: If slider = 8, boiler runs during 8 cheapest hours
- **Minimum:** 2 hours per day
- **Normal:** 3 hours per day
- **Optimal:** 4 hours per day
- Daily summary at 9 PM

#### Tesla Charging
- **Conditions to start:**
  1. Car at home (`device_tracker.tesla_model_3_location_tracker == 'home'`)
  2. Plugged in (`binary_sensor.tesla_model_3_charger == 'on'`)
  3. Battery < 90%
  4. No sauna conflict
  5. Price rank ≤ 12 (or battery < 50%)

- **Dynamic amperage:**
  - Full power (16A): Available capacity, cheap hours
  - Reduced (12A): Boiler running simultaneously
  - Low (8A): Sauna active
  - Minimum (6A): Critical load situation

#### Garage Heater (Ready for Future)
- Only runs during 6 cheapest hours (Rank 1-6)
- Maintains temperature > 6°C
- Protects battery in cold weather
- **Placeholders:** 
  - `switch.garage_heater`
  - `sensor.garage_temperature`

---

## Alerts System

### Telegram Notifications

All alerts are sent via `notify.telegram` service.

#### Critical Alerts (sent every 5 minutes max)
- ⚠️ **Total power >95%** - Emergency load reduction
- 🚨 **Phase voltage <200V or >250V** - Electrical issue
- 🚨 **Single phase overload >5,750W** - Phase protection

#### Warning Alerts (sent every 15 minutes max)
- ⚠️ **Total power >85%** - Preparing to reduce load
- ⚠️ **Phase voltage outside 220-240V** - Voltage abnormal
- ⚠️ **Phase imbalance >50%** - Load distribution issue
- ⚠️ **Sauna on >4 hours** - Safety reminder
- ⚠️ **Water boiler <2 hours at 9 PM** - Minimum not reached

#### Info Notifications
- 🚗 **Car charging started/stopped** - With amperage and reason
- 💧 **Water boiler on/off** - With price rank
- 🌡️ **Heat pump temperature changed** - With mode (boost/normal/eco)
- ✅ **Tesla charged to 90%** - Ready to stop charging
- 📊 **Daily summary at 9 PM** - Water boiler runtime

---

## Installation Steps

### 1. Import Flows

1. Open Node-RED (typically `http://homeassistant.local:1880`)
2. Click menu (☰) → **Import**
3. Import each flow file:
   - `priority-load-balancer.json`
   - `price-based-optimizer.json`
   - `phase-monitor-alerts.json`
4. Click **Deploy**

### 2. Verify Telegram Integration

Ensure you have Telegram bot configured in Home Assistant:

```yaml
# configuration.yaml
notify:
  - platform: telegram
    name: telegram
    chat_id: YOUR_CHAT_ID
```

### 3. Check Entity Availability

Verify all sensors are available in Home Assistant:
- Developer Tools → States
- Search for each entity listed above

### 4. Missing Voltage Sensors?

If you don't have `sensor.shellyem3_channel_X_voltage` entities, add placeholders:

**Option A:** Create template sensors in `configuration.yaml`:
```yaml
template:
  - sensor:
      - name: "ShellyEM3 Channel A Voltage"
        unique_id: shellyem3_channel_a_voltage
        state: 230  # Fixed value
        unit_of_measurement: "V"
        
      - name: "ShellyEM3 Channel B Voltage"
        unique_id: shellyem3_channel_b_voltage
        state: 230
        unit_of_measurement: "V"
        
      - name: "ShellyEM3 Channel C Voltage"
        unique_id: shellyem3_channel_c_voltage
        state: 230
        unit_of_measurement: "V"
```

**Option B:** Disable voltage monitoring
- In Node-RED, disable the voltage monitor nodes

---

## Testing the System

### Test 1: Priority Load Balancing

1. **Turn on Sauna:**
   - Watch for car charging to reduce or turn off
   - Check Telegram for notification

2. **Plug in Tesla:**
   - Should start charging if price rank is good
   - Amperage should adjust based on other loads

3. **Simulate high load:**
   - Monitor debug panel for load warnings

### Test 2: Price-Based Control

1. **Check current price rank:**
   - Look at `sensor.shf_rank_now`
   
2. **Adjust boiler slider:**
   - Set `input_number.shf_rank_slider` to current rank + 1
   - Boiler should turn on
   
3. **Change heat pump sliders:**
   - Adjust temperature sliders
   - Heat pump should respond on next rank change

### Test 3: Alerts

1. **Test Telegram:**
   - In Node-RED, click inject node on any notification
   - Should receive Telegram message

2. **Check debug panel:**
   - Enable all debug nodes
   - Watch for any errors

---

## Customization

### Adjust Load Thresholds

In `priority-load-balancer.json`, find the `evaluate_load` function node:

```javascript
const warningThreshold = maxPower * 0.85; // Change 0.85 to your preference
const criticalThreshold = maxPower * 0.95; // Change 0.95 to your preference
```

### Change Car Charging Behavior

In `priority-load-balancer.json`, find `smart_car_charging_decision` function:

```javascript
if (battery >= 90) {  // Change from 90% to your preference
```

### Adjust Alert Frequency

In `phase-monitor-alerts.json`, find rate limit functions:

```javascript
const minInterval = 5 * 60 * 1000; // Critical: 5 minutes
const minInterval = 15 * 60 * 1000; // Warning: 15 minutes
```

---

## Troubleshooting

### Water Boiler Not Starting

1. **Check price rank:**
   - Is `sensor.shf_rank_now` ≤ slider value?
   
2. **Check conflicts:**
   - Is sauna on?
   - Is car charging at high power?

3. **Check entity:**
   - Is switch available?
   - Can you manually toggle it?

### Car Not Charging

1. **Check conditions:**
   - Is car at home?
   - Is it plugged in?
   - Battery < 90%?
   
2. **Check price:**
   - Is rank acceptable? (≤12 or battery <50%)
   
3. **Check load:**
   - Is total power too high?
   - Is sauna on?

### No Telegram Notifications

1. **Verify Telegram integration:**
   ```yaml
   # Check in Home Assistant
   Developer Tools → Services
   Service: notify.telegram
   Test sending a message
   ```

2. **Check Node-RED:**
   - Is there an error in debug panel?
   - Is notification reaching telegram node?

### Heat Pump Not Responding

1. **Check entity:**
   - Can you control `climate.mitsu_ilp` manually?
   
2. **Check sliders:**
   - Are temperature sliders set correctly?
   - Are they realistic values (15-25°C)?

3. **Check service call:**
   - Look at debug output
   - Is service being called?

---

## Recommended Dashboard

Create a Home Assistant dashboard to monitor the system:

```yaml
type: vertical-stack
cards:
  - type: entities
    title: Power Management
    entities:
      - sensor.sahko_kokonaiskulutus_teho
      - sensor.shellyem3_channel_a_power
      - sensor.shellyem3_channel_b_power
      - sensor.shellyem3_channel_c_power
      - sensor.shf_rank_now
      - sensor.sahko_kokonaishinta_c
      
  - type: entities
    title: High-Power Devices
    entities:
      - binary_sensor.kiuas_tilatieto
      - switch.tesla_model_3_charger
      - number.tesla_model_3_charging_amps
      - sensor.tesla_model_3_battery
      - switch.shellypro4pm_ec62609fd3dc_switch_2
      
  - type: entities
    title: Configuration
    entities:
      - input_number.shf_rank_slider
      - input_number.tehostuslampo
      - input_number.normaalilampo_presence
      - input_number.yllapitolampo
```

---

## Future Enhancements

### Add Garage Heater

When you get the garage heater set up:

1. Replace placeholders in `price-based-optimizer.json`:
   - `switch.garage_heater` → Your actual entity
   - `sensor.garage_temperature` → Your actual sensor

2. Adjust minimum temperature if needed (currently 6°C)

### Add More Devices

To add additional devices to load balancing:

1. Add power monitoring for the device
2. Add to conflict checking logic
3. Assign priority level
4. Update total capacity calculations

### Historical Analytics

Consider adding:
- Power usage graphs
- Cost tracking
- Device runtime statistics
- Efficiency reports

---

## Support & Maintenance

### Regular Checks

- **Weekly:** Review Telegram alerts for patterns
- **Monthly:** Check boiler runtime statistics
- **Seasonal:** Adjust temperature sliders for comfort

### Backup

Node-RED flows are backed up with Home Assistant snapshots, but also:
1. Export flows regularly (Menu → Export)
2. Commit to Git repository
3. Document any customizations

### Updates

When updating entity IDs or adding devices:
1. Search and replace in Node-RED
2. Test thoroughly
3. Monitor for first 24 hours
4. Update documentation

---

## Questions?

Review the flows in Node-RED editor to see exactly how everything works. Each function node contains detailed comments explaining the logic!
