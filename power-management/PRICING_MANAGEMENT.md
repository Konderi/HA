# 🎛️ Electricity Pricing Management Guide

Complete guide for managing your electricity pricing constants in one central location.

---

## 🎯 Single Source of Truth

**All pricing values are now centralized in:**
```
electricity_pricing_constants.yaml
```

### ✅ Benefits:

1. **One Place to Update** - Change prices in one file only
2. **No Duplication** - Values used everywhere automatically
3. **UI Controls** - Adjust prices from Home Assistant dashboard
4. **Easy Maintenance** - Update contract changes instantly
5. **No Code Editing** - Change values without touching templates

---

## 📋 Your Current Pricing Constants

### File: `electricity_pricing_constants.yaml`

```yaml
# Core Pricing (All include ALV 25.5%)
electricity_tax_eur: 0.02827515       # 2.827515 c/kWh
electricity_margin_eur: 0.0059        # 0.59 c/kWh
electricity_transfer_day_eur: 0.0511  # 5.11 c/kWh (07:00-22:00)
electricity_transfer_night_eur: 0.0312 # 3.12 c/kWh (22:00-07:00)
electricity_base_fee_monthly: 5.99     # €/month

# Tariff Schedule
electricity_day_tariff_start_hour: 7   # 07:00
electricity_day_tariff_end_hour: 22    # 22:00
```

---

## 🔧 How to Change Prices

### Method 1: Via Home Assistant UI (Recommended)

1. **Navigate to Settings:**
   ```
   Settings → Devices & Services → Helpers
   ```

2. **Find your pricing inputs:**
   - Filter by "electricity"
   - You'll see all pricing sliders/inputs

3. **Adjust values:**
   - Electric Tax (€/kWh)
   - Company Margin (€/kWh)
   - Transfer Fee Day (€/kWh)
   - Transfer Fee Night (€/kWh)
   - Monthly Base Fee (€)
   - Day Tariff Hours

4. **Changes take effect immediately!**
   - All sensors update automatically
   - No restart required

### Method 2: Edit YAML File

1. **Open file:**
   ```bash
   config/electricity_pricing_constants.yaml
   ```

2. **Change the `initial:` values:**
   ```yaml
   electricity_tax_eur:
     initial: 0.02827515  # ← Change this
   
   electricity_margin_eur:
     initial: 0.0059      # ← Change this
   ```

3. **Check configuration:**
   ```
   Developer Tools → YAML → Check Configuration
   ```

4. **Restart Home Assistant:**
   ```
   Settings → System → Restart
   ```

---

## 📊 What Uses These Constants

### All these sensors automatically use your constants:

1. **`sensor.transfer_tariff_now`**
   - Uses: `electricity_transfer_day_eur`, `electricity_transfer_night_eur`
   - Uses: `electricity_day_tariff_start_hour`, `electricity_day_tariff_end_hour`

2. **`sensor.electricity_total_price_now`**
   - Uses: ALL pricing constants
   - Formula: `spot + tax + margin + transfer`

3. **`sensor.electricity_average_price_today`**
   - Uses: ALL pricing constants
   - Calculates weighted average based on day/night hours

4. **`sensor.electricity_min_price_today`**
   - Uses: Tax, margin, night transfer (cheapest combination)

5. **`sensor.electricity_max_price_today`**
   - Uses: Tax, margin, day transfer (most expensive combination)

6. **`sensor.electricity_monthly_base_fee`**
   - Uses: `electricity_base_fee_monthly`

7. **`sensor.electricity_estimated_monthly_cost`**
   - Uses: Average price + base fee

---

## 🔄 Common Update Scenarios

### Scenario 1: Your Company Raises Transfer Fees

**Current:**
```yaml
Day: 5.11 c/kWh
Night: 3.12 c/kWh
```

**New Price (Example: +2% increase):**
```yaml
Day: 5.21 c/kWh (was 5.11)
Night: 3.18 c/kWh (was 3.12)
```

**How to Update:**
```bash
# Option A: Via UI
Settings → Helpers → "Transfer Fee Day" → Change to 0.0521
Settings → Helpers → "Transfer Fee Night" → Change to 0.0318

# Option B: Via YAML
electricity_transfer_day_eur:
  initial: 0.0521  # Changed from 0.0511

electricity_transfer_night_eur:
  initial: 0.0318  # Changed from 0.0312
```

**Result:** All prices update automatically everywhere!

### Scenario 2: Electricity Tax Changes

**Current:**
```yaml
Tax: 2.827515 c/kWh
```

**New (Government change):**
```yaml
Tax: 3.000 c/kWh
```

**How to Update:**
```yaml
electricity_tax_eur:
  initial: 0.03000  # Changed from 0.02827515
```

### Scenario 3: You Switch Energy Companies

**Current Company:**
```yaml
Margin: 0.59 c/kWh
Base Fee: 5.99 €/month
```

**New Company:**
```yaml
Margin: 0.45 c/kWh
Base Fee: 4.99 €/month
```

**How to Update:**
```yaml
electricity_margin_eur:
  initial: 0.0045  # Changed from 0.0059

electricity_base_fee_monthly:
  initial: 4.99    # Changed from 5.99
```

### Scenario 4: Tariff Hours Change

**Current:**
```yaml
Day: 07:00-22:00
Night: 22:00-07:00
```

**New (Winter schedule):**
```yaml
Day: 06:00-23:00
Night: 23:00-06:00
```

**How to Update:**
```yaml
electricity_day_tariff_start_hour:
  initial: 6       # Changed from 7

electricity_day_tariff_end_hour:
  initial: 23      # Changed from 22
```

---

## 🎛️ Dashboard for Managing Prices

### Create a Pricing Management Card:

```yaml
type: vertical-stack
cards:
  - type: markdown
    content: |
      # ⚙️ Electricity Pricing Settings
      
      **Single source of truth for all pricing calculations**
      
      Changes take effect immediately!
  
  - type: entities
    title: Fixed Costs (€/kWh)
    entities:
      - entity: input_number.electricity_tax_eur
        name: "Electric Tax"
        icon: mdi:percent
      - entity: input_number.electricity_margin_eur
        name: "Company Margin"
        icon: mdi:cash-plus
  
  - type: entities
    title: Transfer Fees (€/kWh)
    entities:
      - entity: input_number.electricity_transfer_day_eur
        name: "Day Transfer (07-22)"
        icon: mdi:weather-sunny
      - entity: input_number.electricity_transfer_night_eur
        name: "Night Transfer (22-07)"
        icon: mdi:weather-night
  
  - type: entities
    title: Tariff Schedule
    entities:
      - entity: input_number.electricity_day_tariff_start_hour
        name: "Day Starts At"
      - entity: input_number.electricity_day_tariff_end_hour
        name: "Day Ends At"
  
  - type: entities
    title: Monthly Costs
    entities:
      - entity: input_number.electricity_base_fee_monthly
        name: "Base Fee"
        icon: mdi:calendar-month
  
  - type: divider
  
  - type: markdown
    content: |
      ### 📊 Current Price Breakdown
  
  - type: entities
    entities:
      - entity: sensor.electricity_pricing_info
        type: attribute
        attribute: fixed_costs_day_cents
        name: "Fixed Costs (Day)"
        suffix: "c/kWh"
      - entity: sensor.electricity_pricing_info
        type: attribute
        attribute: fixed_costs_night_cents
        name: "Fixed Costs (Night)"
        suffix: "c/kWh"
      - type: section
      - entity: sensor.electricity_total_price_now
        name: "Total Price Now"
      - entity: sensor.transfer_tariff_now
        name: "Current Tariff"
        secondary_info: last-changed
```

---

## ✅ Verification After Changes

### Check That Everything Works:

1. **View Pricing Info Sensor:**
   ```
   Developer Tools → States → sensor.electricity_pricing_info
   ```
   
   Check attributes:
   - `electric_tax_cents`
   - `margin_cents`
   - `transfer_day_cents`
   - `transfer_night_cents`
   - `fixed_costs_day_cents`
   - `fixed_costs_night_cents`

2. **Verify Total Price:**
   ```
   Developer Tools → States → sensor.electricity_total_price_now
   ```
   
   Check attributes show your new values

3. **Test Tariff Switching:**
   ```bash
   # Wait for tariff change (07:00 or 22:00)
   # Or temporarily change tariff hours for testing
   ```

4. **Check Monthly Estimates:**
   ```
   sensor.electricity_estimated_monthly_cost
   # Should reflect new pricing
   ```

---

## 🔍 Troubleshooting

### Prices Don't Update After Change

**Via UI Changes:**
- Changes are immediate, no restart needed
- Refresh your dashboard (F5)
- Check entity state in Developer Tools

**Via YAML Changes:**
- Must restart Home Assistant
- Check configuration first
- Wait 30-60 seconds after restart

### Wrong Price Shown

**Check Constants:**
```yaml
# View current values
Developer Tools → States → input_number.electricity_*
```

**Verify Formula:**
```yaml
# Total should be:
spot + tax + margin + transfer (day or night)
```

**Check Time:**
```yaml
# Is tariff switching at correct hours?
sensor.transfer_tariff_now
# Check attributes: start_time, end_time
```

### Sensor Unavailable

**Missing Constants File:**
```yaml
# Ensure file exists:
config/electricity_pricing_constants.yaml

# Check in configuration.yaml:
input_number: !include electricity_pricing_constants.yaml
```

**Check Dependencies:**
```yaml
# Required sensor:
sensor.shf_electricity_price_now
# Must be working for pricing to work
```

---

## 📝 Backup Your Pricing

### Export Current Values:

```yaml
# Save this for reference:
Electric Tax:      {{ states('input_number.electricity_tax_eur') }} €/kWh
Margin:            {{ states('input_number.electricity_margin_eur') }} €/kWh
Transfer Day:      {{ states('input_number.electricity_transfer_day_eur') }} €/kWh
Transfer Night:    {{ states('input_number.electricity_transfer_night_eur') }} €/kWh
Base Fee:          {{ states('input_number.electricity_base_fee_monthly') }} €/month
Day Start Hour:    {{ states('input_number.electricity_day_tariff_start_hour') }}
Day End Hour:      {{ states('input_number.electricity_day_tariff_end_hour') }}
Last Updated:      {{ now().strftime('%Y-%m-%d') }}
```

---

## 🎓 Best Practices

### 1. Document Changes
```yaml
# Keep a log in the file:
# 2026-02-08: Initial setup (Margin 0.59 c/kWh)
# 2026-03-01: Transfer increase (Day: 5.11 → 5.21 c/kWh)
```

### 2. Test Before Going Live
```yaml
# Create test sensors first
# Verify calculations manually
# Compare with actual bill
```

### 3. Seasonal Adjustments
```yaml
# Some contracts have:
# - Winter peak pricing
# - Summer discounts
# - Weekend rates
# Update constants when seasons change
```

### 4. Regular Audits
```bash
# Monthly:
# - Compare estimated cost with actual bill
# - Adjust if company changed prices
# - Update if contract renewed
```

---

## 🎯 Quick Reference Card

### 💡 Need to Change Prices?

**Step 1:** Go to Home Assistant
```
Settings → Devices & Services → Helpers
Filter: "electricity"
```

**Step 2:** Click the value you want to change

**Step 3:** Enter new value

**Step 4:** Done! (No restart needed)

---

### 📞 When to Update

| Event | What to Update | Where |
|-------|----------------|-------|
| Company raises prices | Transfer fees | `electricity_transfer_*` |
| Government changes tax | Electric tax | `electricity_tax_eur` |
| Switch energy company | Margin + Base fee | `electricity_margin_eur` + `electricity_base_fee_monthly` |
| New contract terms | All values | Review entire file |
| Tariff hours change | Start/end hours | `electricity_day_tariff_*_hour` |

---

**Last Updated:** February 8, 2026  
**File Location:** `config/electricity_pricing_constants.yaml`  
**Status:** ✅ Centralized & Ready
