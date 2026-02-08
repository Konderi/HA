# 📊 ApexCharts Dashboard Upgrade Guide
## Modern Sensor Integration with Centralized Pricing

**Upgrade your electricity price charts to use the new centralized pricing system**

---

## 🎯 Overview

### What's Changing

Your current ApexCharts use:
- ❌ **Hardcoded prices** (siirto, alv, marginaali arrays)
- ❌ **Legacy sensors** (will break in HA 2026.6)
- ❌ **Complex data_generator** calculations
- ❌ **Manual price updates** required

New charts will use:
- ✅ **Centralized pricing constants** (single source of truth)
- ✅ **Modern sensors** (future-proof)
- ✅ **Simpler configuration** (HA does calculations)
- ✅ **Automatic updates** (change once, updates everywhere)

### Benefits

| Feature | Old Charts | New Charts |
|---------|-----------|------------|
| **Sensor syntax** | ❌ Deprecated | ✅ Modern |
| **Price updates** | ❌ Edit 2 charts | ✅ Edit 1 file |
| **Day/night tariff** | ❌ Hardcoded array | ✅ Auto-detected |
| **Calculation accuracy** | ❌ May drift | ✅ Always accurate |
| **Future compatibility** | ❌ Breaks 2026.6 | ✅ Works forever |

---

## 📦 Your Current Charts

### Chart 1: Electricity Total Price 24h (Bar Chart)

**Current Configuration:**
```yaml
type: custom:apexcharts-card
header:
  title: Sähkön kokonaishinta 24h
series:
  - entity: sensor.shf_electricity_price
    data_generator: >
      # Hardcoded values (BAD):
      var siirto = [3.01, 3.01, ..., 4.92, 4.92, ...]  # 24 values
      var alv = 1.24;
      var marginaali = 0.0045;
      # Complex calculation
  - entity: sensor.sahkon_myyntihinta_c_kwh  # DEPRECATED
  - entity: sensor.sahko_siirtohinta  # DEPRECATED
  - entity: sensor.sahko_kokonaishinta_c  # DEPRECATED
```

**Problems:**
- Hardcoded transfer prices (night: 3.01, day: 4.92)
- Uses deprecated sensors
- Manual calculation in data_generator
- Price updates require editing the chart

### Chart 2: Electricity Price & Consumption 7d (Line + Area)

**Current Configuration:**
```yaml
type: custom:apexcharts-card
header:
  title: Sähkön kokonaishinta ja -kulutus 7d
series:
  - entity: sensor.talon_kokonaiskulutus_tunti_kwh
  - entity: sensor.sahko_kokonaishinta_c  # DEPRECATED
```

**Problems:**
- Uses deprecated `sensor.sahko_kokonaishinta_c`
- Will stop working in HA 2026.6

---

## ✅ Prerequisites

### Required Files Already Created

- ✅ `electricity_pricing.yaml` - Modern pricing sensors
- ✅ `electricity_pricing_constants.yaml` - Centralized constants
- ✅ `legacy_sensors_migrated.yaml` - Compatibility layer (optional)

### Required Sensors (Verify These Exist)

**New Modern Sensors:**
```yaml
sensor.electricity_total_price_now        # Total price EUR/kWh
sensor.electricity_total_price_cents      # Total price c/kWh (for charts)
sensor.transfer_tariff_now               # Current transfer tariff
sensor.shf_electricity_price_now          # Spot price (from SHF API)
binary_sensor.night_tariff_active        # Day/night indicator
```

**Check in Developer Tools → States:**
```bash
# Search for these sensors
electricity_total_price
transfer_tariff
night_tariff
```

If missing, ensure you've completed the legacy sensor migration first:
👉 See [LEGACY_SENSOR_MIGRATION.md](./LEGACY_SENSOR_MIGRATION.md)

---

## 🚀 Upgrade Steps

### Chart 1: Electricity Total Price 24h (Upgraded)

#### Step 1.1: Understand the New Approach

**Old way:**
```javascript
// Hardcoded transfer prices
var siirto = [3.01, 3.01, 3.01, 3.01, 3.01, 3.01, 3.01, 
              4.92, 4.92, 4.92, 4.92, 4.92, 4.92, 4.92, 
              4.92, 4.92, 4.92, 4.92, 4.92, 4.92, 4.92, 
              4.92, 3.01, 3.01];  // 24 values!
// Manual calculation with VAT and margin
return ((price + margin) * vat) * 100 + siirto[hour];
```

**New way:**
```yaml
# Use pre-calculated sensor
entity: sensor.electricity_total_price_cents
# That's it! No calculations needed
```

**Why better?**
- ✅ Sensor already has ALL costs (spot + tax + margin + transfer)
- ✅ Day/night tariff auto-detected (no hardcoded arrays)
- ✅ Updates when you change pricing constants
- ✅ No complex JavaScript

#### Step 1.2: New Chart Configuration

**Replace your Chart 1 with this:**

```yaml
type: custom:apexcharts-card
apex_config:
  xaxis:
    labels:
      format: H:mm
  tooltip:
    fixed:
      enabled: true
      position: topRight
  legend:
    show: false
graph_span: 30h
experimental:
  color_threshold: true
show:
  last_updated: false
header:
  title: Sähkön kokonaishinta 24h
  show: true
  show_states: true
  colorize_states: true
span:
  start: hour
  offset: "-2h"
yaxis:
  - min: 0
    max: "|+5|"
    decimals: 0
    apex_config:
      forceNiceScale: true
now:
  show: true
  label: Now
series:
  # Main price bars - Uses modern sensor with ALL costs included
  - entity: sensor.electricity_total_price_cents
    name: Total Price
    show:
      in_header: false
      extremas: true
    type: column
    color: lightgray
    float_precision: 2
    unit: "c/kWh"
    color_threshold:
      - value: 0
        color: green
      - value: 15
        color: "#90EE90"
      - value: 20
        color: gold
      - value: 25
        color: orange
      - value: 30
        color: "#FF6347"
      - value: 35
        color: red
        
  # Current price line (for reference)
  - entity: sensor.electricity_total_price_cents
    name: Current Price
    show:
      in_header: true
      header_color_threshold: true
      in_chart: false
    type: line
    color: lightgray
    float_precision: 2
    stroke_width: 0
    unit: "c/kWh"
    color_threshold:
      - value: 0
        color: green
      - value: 15
        color: "#90EE90"
      - value: 20
        color: gold
      - value: 25
        color: orange
      - value: 30
        color: "#FF6347"
      - value: 35
        color: red
        
  # Spot price only (no transfer/tax/margin)
  - entity: sensor.shf_electricity_price_now
    name: Spot Price
    float_precision: 2
    extend_to: false
    unit: "c/kWh"
    color: "#0066CC"
    show:
      in_header: true
      legend_value: true
      in_chart: false
      header_color_threshold: false
    transform: "return x * 100;"  # Convert EUR to cents
    
  # Transfer tariff (day/night aware)
  - entity: sensor.transfer_tariff_now
    name: Transfer
    float_precision: 2
    extend_to: false
    unit: "c/kWh"
    color: green
    show:
      in_header: true
      legend_value: true
      in_chart: false
      header_color_threshold: false
    transform: "return x * 100;"  # Convert EUR to cents
    
  # Night tariff indicator
  - entity: binary_sensor.night_tariff_active
    name: Night Tariff
    show:
      in_header: true
      legend_value: false
      in_chart: false
    transform: "return x === 'on' ? '🌙 Night' : '☀️ Day';"
```

**Key Changes:**
- ✅ Uses `sensor.electricity_total_price_cents` (already has ALL costs)
- ✅ No `data_generator` JavaScript needed
- ✅ Uses `sensor.transfer_tariff_now` (auto day/night detection)
- ✅ Shows night tariff indicator
- ✅ Simpler, cleaner configuration

#### Step 1.3: Alternative - With Forecast Data

If you want to show tomorrow's prices (like original chart):

```yaml
# Add this series to show tomorrow's forecast
- entity: sensor.nordpool_kwh_fi_eur_4_10_0
  name: Tomorrow Prices
  show:
    in_header: false
    in_chart: true
  type: column
  color: "#CCCCCC"
  opacity: 0.5
  float_precision: 2
  data_generator: |
    // Calculate full price for tomorrow
    const tax = parseFloat(states['input_number.electricity_tax_eur'].state);
    const margin = parseFloat(states['input_number.electricity_margin_eur'].state);
    const transferDay = parseFloat(states['input_number.electricity_transfer_day_eur'].state);
    const transferNight = parseFloat(states['input_number.electricity_transfer_night_eur'].state);
    const dayStart = parseInt(states['input_number.electricity_day_tariff_start_hour'].state);
    const dayEnd = parseInt(states['input_number.electricity_day_tariff_end_hour'].state);
    
    if (!entity.attributes.tomorrow_valid) {
      return [];
    }
    
    return entity.attributes.tomorrow.map((price, index) => {
      const hour = index;
      const isDayTariff = hour >= dayStart && hour < dayEnd;
      const transfer = isDayTariff ? transferDay : transferNight;
      const totalPrice = (price + tax + margin + transfer) * 100;
      const timestamp = new Date().setHours(24 + hour, 0, 0, 0);
      return [timestamp, totalPrice];
    });
```

**Note:** This still uses data_generator but pulls values from centralized constants!

---

### Chart 2: Electricity Price & Consumption 7d (Upgraded)

#### Step 2.1: New Chart Configuration

**Replace your Chart 2 with this:**

```yaml
type: custom:apexcharts-card
apex_config:
  legend:
    show: false
  xaxis:
    labels:
      format: d.M.
  tooltip:
    fixed:
      enabled: true
      position: topRight
experimental:
  color_threshold: true
graph_span: 7d
show:
  last_updated: false
now:
  show: false
header:
  standard_format: false
  show: true
  show_states: true
  colorize_states: true
  title: Sähkön kokonaishinta ja -kulutus 7d
span:
  start: hour
  offset: "-7d"
series:
  # Hourly consumption (kWh)
  - entity: sensor.talon_kokonaiskulutus_tunti_kwh
    yaxis_id: tuntikulutus
    name: Hourly Consumption
    type: area
    stroke_width: 1
    float_precision: 3
    extend_to: now
    color: "#EA8043"
    opacity: 0.8
    unit: "kWh"
    group_by:
      func: last
      duration: 1hour
    show:
      header_color_threshold: true
      legend_value: false
      in_header: true
      
  # Total price (c/kWh) - MODERN SENSOR
  - entity: sensor.electricity_total_price_cents
    yaxis_id: nordpool
    name: Total Price
    type: line
    float_precision: 1
    extend_to: false
    unit: "c/kWh"
    stroke_width: 3
    color: "#6186EC"
    show:
      header_color_threshold: true
      legend_value: false
      in_header: true
    color_threshold:
      - value: 0
        color: green
      - value: 15
        color: "#90EE90"
      - value: 20
        color: gold
      - value: 25
        color: orange
      - value: 30
        color: "#FF6347"
      - value: 35
        color: red
        
yaxis:
  - id: tuntikulutus
    min: 0
    opposite: false
    decimals: 0
    apex_config:
      title:
        text: "Consumption (kWh)"
  - id: nordpool
    min: 0
    max: 60
    opposite: true
    decimals: 0
    apex_config:
      title:
        text: "Price (c/kWh)"
```

**Key Changes:**
- ✅ Uses `sensor.electricity_total_price_cents` instead of deprecated sensor
- ✅ Future-proof (won't break in HA 2026.6)
- ✅ Better color thresholds
- ✅ Clearer axis labels

---

## 🎨 Optional: Enhanced Charts

### Chart 3: Cost Analysis Dashboard (NEW)

Add this as a **bonus chart** to show cost breakdown:

```yaml
type: custom:apexcharts-card
header:
  title: Electricity Cost Breakdown
  show: true
  show_states: true
  colorize_states: true
graph_span: 24h
span:
  start: hour
now:
  show: true
  label: Now
series:
  # Spot price
  - entity: sensor.shf_electricity_price_now
    name: Spot Price
    type: column
    color: "#0066CC"
    float_precision: 2
    transform: "return x * 100;"
    show:
      in_header: true
      
  # Transfer tariff (day/night)
  - entity: sensor.transfer_tariff_now
    name: Transfer
    type: column
    color: "#4CAF50"
    float_precision: 2
    transform: "return x * 100;"
    show:
      in_header: true
      
  # Tax (constant but shown for clarity)
  - entity: input_number.electricity_tax_eur
    name: Tax + Margin
    type: column
    color: "#FFA726"
    float_precision: 2
    transform: "return x * 100 + (parseFloat(states['input_number.electricity_margin_eur'].state) * 100);"
    show:
      in_header: true
      
  # Total price line
  - entity: sensor.electricity_total_price_cents
    name: Total
    type: line
    stroke_width: 3
    color: "#E91E63"
    float_precision: 2
    show:
      in_header: true
      
yaxis:
  - min: 0
    decimals: 1
    apex_config:
      title:
        text: "Price (c/kWh)"
```

**Shows:**
- Spot price (blue bars)
- Transfer tariff (green bars)
- Tax + margin (orange bars)
- Total price (red line)

### Chart 4: Savings Tracker (NEW)

Track your monthly savings from the power management system:

```yaml
type: custom:apexcharts-card
header:
  title: Monthly Electricity Savings
  show: true
  show_states: true
  colorize_states: true
graph_span: 30d
span:
  start: day
  offset: "-30d"
series:
  # Estimated monthly cost
  - entity: sensor.electricity_estimated_monthly_cost
    name: Estimated Cost
    type: area
    color: "#FF6347"
    opacity: 0.6
    unit: "€"
    float_precision: 2
    show:
      in_header: true
      
  # Monthly savings
  - entity: sensor.electricity_savings_this_month
    name: Savings
    type: line
    stroke_width: 3
    color: "#4CAF50"
    unit: "€"
    float_precision: 2
    show:
      in_header: true
      
yaxis:
  - min: 0
    decimals: 0
    apex_config:
      title:
        text: "Amount (€)"
```

---

## 📱 Complete Dashboard Layout

### Recommended Dashboard Structure

```yaml
title: ⚡ Electricity Monitoring
path: electricity
icon: mdi:lightning-bolt
badges: []
cards:
  # Row 1: Current Status
  - type: horizontal-stack
    cards:
      - type: custom:mushroom-entity-card
        entity: sensor.electricity_total_price_cents
        name: Current Price
        icon: mdi:cash
        primary_info: state
        secondary_info: last-updated
        
      - type: custom:mushroom-entity-card
        entity: binary_sensor.night_tariff_active
        name: Tariff
        icon: mdi:clock-outline
        
      - type: custom:mushroom-entity-card
        entity: sensor.nordpool_rank
        name: Price Rank
        icon: mdi:chart-line
        
  # Row 2: 24h Price Chart
  - type: custom:apexcharts-card
    # Paste Chart 1 config here
    
  # Row 3: 7-day Price & Consumption
  - type: custom:apexcharts-card
    # Paste Chart 2 config here
    
  # Row 4: Cost Breakdown (Optional)
  - type: custom:apexcharts-card
    # Paste Chart 3 config here
    
  # Row 5: Monthly Savings (Optional)
  - type: custom:apexcharts-card
    # Paste Chart 4 config here
    
  # Row 6: Pricing Constants (Quick Edit)
  - type: entities
    title: ⚙️ Pricing Configuration
    entities:
      - entity: input_number.electricity_tax_eur
        name: Electric Tax
      - entity: input_number.electricity_margin_eur
        name: Margin
      - entity: input_number.electricity_transfer_day_eur
        name: Transfer (Day)
      - entity: input_number.electricity_transfer_night_eur
        name: Transfer (Night)
      - entity: input_number.electricity_base_fee_monthly
        name: Base Fee (Monthly)
```

---

## ✅ Testing Checklist

### After Upgrading Charts

- [ ] **Chart 1: 24h Price**
  - [ ] Shows current prices correctly
  - [ ] Bar colors match price thresholds
  - [ ] Spot price shown in header
  - [ ] Transfer price shown in header
  - [ ] Night tariff indicator visible
  - [ ] "Now" line shows current time
  
- [ ] **Chart 2: 7-day Price & Consumption**
  - [ ] Shows 7 days of data
  - [ ] Consumption area chart visible
  - [ ] Price line chart visible
  - [ ] Both axes scaled correctly
  - [ ] Colors match thresholds

- [ ] **Price Accuracy**
  - [ ] Compare chart price to `sensor.electricity_total_price_cents`
  - [ ] Should match exactly
  - [ ] Check during day and night (different transfer tariff)

- [ ] **Automatic Updates**
  - [ ] Change `input_number.electricity_transfer_day_eur`
  - [ ] Wait 30 seconds
  - [ ] Chart should update automatically

---

## 🔄 Migration Comparison

### Before vs After

| Aspect | Old Charts | New Charts |
|--------|-----------|------------|
| **Sensors** | ❌ Deprecated (`sahko_kokonaishinta_c`) | ✅ Modern (`electricity_total_price_cents`) |
| **Transfer prices** | ❌ 24-value hardcoded array | ✅ Auto day/night detection |
| **Calculations** | ❌ Complex JavaScript | ✅ HA does it (simpler) |
| **Price updates** | ❌ Edit 2 charts | ✅ Edit 1 file (constants) |
| **Future proof** | ❌ Breaks HA 2026.6 | ✅ Works forever |
| **Accuracy** | ⚠️ May drift from actual | ✅ Always accurate |
| **Maintenance** | ❌ High (multiple edits) | ✅ Low (single source) |

---

## 🐛 Troubleshooting

### Chart shows "No data"

**Solution 1: Check sensors exist**
```
Developer Tools → States
Search: electricity_total_price_cents
Status: Should show a number (e.g., "23.45")
```

**Solution 2: Check sensor history**
```
Developer Tools → States → sensor.electricity_total_price_cents → History
Should show graph with data
If empty: Sensor not recording history
```

**Solution 3: Enable history recording**
```yaml
# In configuration.yaml
recorder:
  include:
    entities:
      - sensor.electricity_total_price_cents
      - sensor.transfer_tariff_now
      - sensor.shf_electricity_price_now
```

### Chart shows wrong prices

**Solution: Verify pricing constants**
```
Settings → Devices & Services → Helpers
Check these values match your contract:
- electricity_tax_eur: 0.02827515
- electricity_margin_eur: 0.0059
- electricity_transfer_day_eur: 0.0511
- electricity_transfer_night_eur: 0.0312
```

### Day/night tariff not switching

**Solution: Check time configuration**
```
Settings → Devices & Services → Helpers
- electricity_day_tariff_start_hour: 7
- electricity_day_tariff_end_hour: 22

Current state:
binary_sensor.night_tariff_active
Should be "on" between 22:00-07:00
Should be "off" between 07:00-22:00
```

### Chart colors don't match

**Solution: Adjust color thresholds**

Your old chart had different thresholds. Adjust these values in the new chart:

```yaml
color_threshold:
  - value: 0
    color: green      # Very cheap
  - value: 15
    color: "#90EE90"  # Cheap
  - value: 20
    color: gold       # Normal
  - value: 25
    color: orange     # Expensive
  - value: 30
    color: "#FF6347"  # Very expensive
  - value: 35
    color: red        # Extremely expensive
```

Adjust the `value` numbers to match your preference.

---

## 📚 Related Documentation

- **[LEGACY_SENSOR_MIGRATION.md](./LEGACY_SENSOR_MIGRATION.md)** - Migrate deprecated sensors first
- **[PRICING_MANAGEMENT.md](./PRICING_MANAGEMENT.md)** - How to update pricing constants
- **[PRICING_GUIDE.md](./PRICING_GUIDE.md)** - Complete electricity pricing documentation
- **[DASHBOARD.md](./DASHBOARD.md)** - Main dashboard configuration guide

---

## 🎉 Benefits After Upgrade

### Immediate
- ✅ No more deprecation warnings
- ✅ Charts work with HA 2026.6+
- ✅ Accurate day/night tariff
- ✅ Simpler configuration

### Long-term
- ✅ **Single source of truth** - Update prices once, everywhere updates
- ✅ **Lower maintenance** - No need to edit multiple charts
- ✅ **Better accuracy** - HA calculates everything correctly
- ✅ **Future-proof** - Works with HA 2027, 2028+

### Cost Tracking
- ✅ More accurate electricity cost monitoring
- ✅ Better understanding of usage patterns
- ✅ Verify power management savings
- ✅ Track monthly costs vs. targets

---

**Guide created:** February 2026  
**HA Version:** 2026.2.x  
**ApexCharts Card:** Latest from HACS  
**Status:** ✅ Ready to implement
