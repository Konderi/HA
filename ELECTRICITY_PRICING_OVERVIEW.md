# ⚡ Electricity Pricing System - Complete Overview

## 📍 Where Your Electricity Price Data Lives

Your system uses a **multi-layer pricing structure** with data from multiple sources:

---

## 🎯 **1. Live Spot Prices (Nordpool Integration)**

### **Source: spot-price.yaml** 
**Location:** `/config/old_configs/spot-price.yaml` (but included in your active config)

**What it does:**
- Fetches **live Nordpool spot prices** from `https://api.spot-hinta.fi/`
- Updates automatically every 7 days (automation handles daily updates)
- Provides 48 hours of data (today + tomorrow)
- Includes **price rankings** (1-24, where 1 = cheapest hour)

**Key sensors created:**
- `sensor.shf_electricity_price` - Raw API data (main data source)
- `sensor.shf_electricity_price_now` - Current hour spot price
- `sensor.shf_rank_now` - Current hour ranking (1-24)
- `sensor.nordpool_kwh_fi_eur_4_10_0` - Nordpool price in €/kWh

**Configuration:**
```yaml
# In your configuration.yaml (line 51):
homeassistant:
  packages:
    pack_1: !include spot-price.yaml  # ← This loads Nordpool data
```

---

## 💰 **2. Your Contract Pricing Components**

### **Source: electricity_pricing_constants.yaml**
**Location:** `/config/electricity_pricing_constants.yaml`

**What it contains:**
```yaml
# YOUR CURRENT PRICING (c/kWh):

Energy Price:
  Day (07:00-22:00):   0.44 c/kWh
  Night (22:00-07:00): 0.37 c/kWh

Transfer Price:
  Day:   4.92 c/kWh
  Night: 3.01 c/kWh

Fixed Components:
  Tax:       2.79372 c/kWh  (Finnish electricity tax)
  Margin:    0.25 c/kWh     (Supplier margin)
  VAT:       1.255          (25.5% multiplier)
```

**Configuration:**
```yaml
# In your configuration.yaml (line 53):
homeassistant:
  packages:
    electricity_pricing_constants: !include electricity_pricing_constants.yaml
```

**📝 To Update Your Prices:**
1. Open `/config/electricity_pricing_constants.yaml`
2. Edit the values (lines 11-24)
3. Restart Home Assistant
4. All sensors auto-update!

---

## 🧮 **3. Total Price Calculation**

### **Source: electricity_pricing.yaml**
**Location:** `/config/electricity_pricing.yaml`

**What it does:**
Combines **Nordpool spot price + your contract components** into total price:

```
Total Price = (Nordpool + Energy + Transfer + Tax + Margin) × VAT

Example at 10:00 (day tariff):
  Nordpool:  3.21 c/kWh  (from spot-price.yaml)
  Energy:    0.44 c/kWh  (your contract)
  Transfer:  4.92 c/kWh  (your contract)
  Tax:       2.79 c/kWh  (fixed)
  Margin:    0.25 c/kWh  (supplier)
  ─────────────────────
  Subtotal: 11.61 c/kWh
  × VAT:    × 1.255
  ═══════════════════
  TOTAL:    14.57 c/kWh  ← This is what you actually pay!
```

**Key sensors created:**
- `sensor.electricity_total_price_cents` - **Your actual c/kWh price** (most important!)
- `sensor.shf_electricity_price_now` - Raw spot price component
- `sensor.electricity_average_price_today` - Daily average
- `sensor.electricity_min_price_today` - Cheapest hour today
- `sensor.electricity_max_price_today` - Most expensive hour today

**Configuration:**
```yaml
# In your configuration.yaml (line 54):
homeassistant:
  packages:
    electricity_pricing: !include electricity_pricing.yaml
```

---

## 📊 **4. How Node-RED Flows Use This Data**

Your Node-RED flows use these sensors for automation decisions:

### **Price-Based Optimizer Flow:**
```javascript
// Reads current price rank
const currentRank = parseInt(global.get('homeassistant.homeAssistant.states["sensor.shf_rank_now"].state'));

// Reads user's max rank setting
const maxRank = parseFloat(global.get('homeassistant.homeAssistant.states["input_number.boiler_max_rank"].state')) || 8;

// Decides: Should boiler run?
if (currentRank <= maxRank) {
  // YES - cheap enough!
  // Turn on boiler
} else {
  // NO - too expensive
  // Keep boiler off
}
```

### **Key Sensors Used by Flows:**
| Sensor | Used By | Purpose |
|--------|---------|---------|
| `sensor.shf_rank_now` | Price-Based Optimizer | Boiler on/off decisions |
| `sensor.electricity_total_price_cents` | Dashboard | Show current price |
| `sensor.electricity_average_price_today` | Dashboard | Compare to average |
| `sensor.shf_electricity_price_now` | Peak Power Limiter | Cost calculations |
| `sensor.nordpool_kwh_fi_eur_4_10_0` | All flows | Base price data |

---

## 🔍 **5. Where to Find Each Sensor**

### **In Home Assistant UI:**

1. **Developer Tools → States**
   - Search for: `sensor.shf_rank_now`
   - Search for: `sensor.electricity_total_price_cents`
   - Search for: `sensor.nordpool_kwh_fi_eur_4_10_0`

2. **Settings → Devices & Services → Entities**
   - Filter by: "electricity"
   - Filter by: "shf"
   - Filter by: "nordpool"

### **In Node-RED:**

1. **Use the "current state" node**
   - Entity ID: `sensor.shf_rank_now`
   - Entity ID: `sensor.electricity_total_price_cents`

2. **Or read from global context:**
   ```javascript
   const rank = global.get('homeassistant.homeAssistant.states["sensor.shf_rank_now"].state');
   const price = global.get('homeassistant.homeAssistant.states["sensor.electricity_total_price_cents"].state');
   ```

---

## 🎛️ **6. User-Adjustable Price Controls**

You have **sliders** to control price-based behavior:

### **Boiler Price Control:**
**Entity:** `input_number.boiler_max_rank`
- **Range:** 1-24
- **Current:** 8
- **Meaning:** "Only heat water during the 8 cheapest hours"

**How to adjust:**
1. Settings → Devices & Services → Helpers
2. Find "Boiler Max Price Rank"
3. Adjust slider: Lower = more savings, Higher = more hot water

### **Heat Pump Temperature by Price:**
**Entities:** (you may already have these)
- `input_number.tehostuslampo` - Boost temp (6 cheapest hours)
- `input_number.normaalilampo_presence` - Normal temp (12 middle hours)
- `input_number.yllapitolampo` - Eco temp (6 most expensive hours)

---

## 📈 **7. Data Flow Diagram**

```
┌─────────────────────────────────────┐
│  🌐 Internet: spot-hinta.fi API    │
│  (Nordpool prices for Finland)      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  📦 spot-price.yaml                 │
│  - Fetches 48h of prices            │
│  - Calculates rankings (1-24)       │
│  - Updates hourly                   │
└──────────────┬──────────────────────┘
               │
               ▼
       sensor.nordpool_kwh_fi_eur_4_10_0
       sensor.shf_rank_now
               │
               ├─────────────────┐
               ▼                 ▼
┌──────────────────────┐  ┌─────────────────────┐
│ electricity_pricing  │  │  Node-RED Flows     │
│ _constants.yaml      │  │  - Price optimizer  │
│ (Your contract)      │  │  - Load balancer    │
└──────────┬───────────┘  │  - Dashboard        │
           │              └─────────────────────┘
           ▼
┌──────────────────────┐
│ electricity_pricing  │
│ .yaml                │
│ (Total calculation)  │
└──────────┬───────────┘
           │
           ▼
   sensor.electricity_total_price_cents
   (What you actually pay!)
           │
           ├─────────────────┐
           ▼                 ▼
   ┌──────────────┐  ┌──────────────┐
   │  Dashboard   │  │  Automations │
   │  Cards       │  │  & Alerts    │
   └──────────────┘  └──────────────┘
```

---

## 🛠️ **8. How to Update Your Pricing**

### **Scenario 1: Electricity contract changes**

**Edit:** `/config/electricity_pricing_constants.yaml`

```yaml
# Example: New contract with cheaper night transfer
electricity_transfer_price: &electricity_transfer_price
  day: 4.92      # Keep same
  night: 2.50    # ← Change from 3.01 to 2.50
```

**Then:** Restart Home Assistant → All sensors update automatically!

### **Scenario 2: Want different price ranking behavior**

**Adjust dashboard slider:**
1. Settings → Helpers → "Boiler Max Price Rank"
2. Change from 8 to 10 (runs during 10 cheapest hours instead of 8)
3. **No restart needed!** Change is immediate.

### **Scenario 3: Nordpool API not updating**

**Check:**
1. Developer Tools → States → `sensor.shf_electricity_price`
2. Look at "last_changed" timestamp
3. If > 1 day old, automation may be broken

**Fix:**
- Check automation: "SHF Electricity Price Update"
- Manually trigger: Developer Tools → Services → `automation.trigger`
- Or: Developer Tools → States → `sensor.shf_electricity_price` → "Reload"

---

## 📋 **9. Quick Reference Card**

| What You Want to Know | Check This Sensor |
|-----------------------|-------------------|
| **Current c/kWh price (total)** | `sensor.electricity_total_price_cents` |
| **Current price ranking (1-24)** | `sensor.shf_rank_now` |
| **Raw Nordpool spot price** | `sensor.nordpool_kwh_fi_eur_4_10_0` |
| **Today's average price** | `sensor.electricity_average_price_today` |
| **Cheapest hour today** | `sensor.electricity_min_price_today` |
| **Most expensive hour today** | `sensor.electricity_max_price_today` |
| **Is now cheap?** | `sensor.shf_rank_now` ≤ 8 |
| **Your contract day rate** | See `electricity_pricing_constants.yaml` |
| **Your contract night rate** | See `electricity_pricing_constants.yaml` |

---

## 🎯 **10. For Your Node-RED Flows**

### **Reading Current Rank:**
```javascript
// Get current price rank (1-24)
const currentRank = parseInt(
  global.get('homeassistant.homeAssistant.states["sensor.shf_rank_now"].state')
);

// Get user's max rank setting
const maxRank = parseFloat(
  global.get('homeassistant.homeAssistant.states["input_number.boiler_max_rank"].state')
) || 8;

// Decision logic
if (currentRank <= maxRank) {
  msg.payload = "CHEAP - Turn ON";
} else {
  msg.payload = "EXPENSIVE - Turn OFF";
}

return msg;
```

### **Reading Current Price:**
```javascript
// Get total price in c/kWh
const totalPrice = parseFloat(
  global.get('homeassistant.homeAssistant.states["sensor.electricity_total_price_cents"].state')
);

// Get average for comparison
const avgPrice = parseFloat(
  global.get('homeassistant.homeAssistant.states["sensor.electricity_average_price_today"].state')
);

// Is it cheap compared to average?
if (totalPrice < avgPrice * 0.85) {
  msg.payload = "15% below average - VERY CHEAP!";
}

return msg;
```

---

## 🚨 **11. Troubleshooting**

### **Problem: Prices not updating**
**Check:**
1. Internet connection
2. API status: Visit https://spot-hinta.fi/ in browser
3. Automation "SHF Electricity Price Update" is enabled
4. Check HA logs: Settings → System → Logs (filter "shf")

### **Problem: Wrong price calculations**
**Check:**
1. `electricity_pricing_constants.yaml` has correct values
2. Day/night tariff switching at correct hours (07:00 and 22:00)
3. VAT multiplier is 1.255 (not 0.255!)

### **Problem: Boiler running during expensive hours**
**Check:**
1. `input_number.boiler_max_rank` value (Settings → Helpers)
2. Current rank: `sensor.shf_rank_now`
3. Is Luxus mode ON? (`input_boolean.boiler_luxus_mode`)
4. Node-RED flow "Price-Based Optimizer" is deployed

---

## ✅ **Summary**

Your electricity pricing system has **3 layers**:

1. **🌐 Nordpool spot prices** (live from API) → `spot-price.yaml`
2. **📝 Your contract components** (your rates) → `electricity_pricing_constants.yaml`
3. **🧮 Total calculated price** (spot + contract) → `electricity_pricing.yaml`

**All referenced in:** `configuration.yaml` lines 51-54

**Used by:**
- ✅ Node-RED flows (automation decisions)
- ✅ Dashboard cards (price display)
- ✅ Automations (alerts, scheduling)
- ✅ History graphs (cost tracking)

**To modify prices:** Edit `electricity_pricing_constants.yaml` and restart HA.

**To modify behavior:** Adjust dashboard sliders (no restart needed).

---

## 📞 **Need More Help?**

- **File locations:** See section 1-3 above
- **Update pricing:** See section 8 above
- **Node-RED usage:** See section 10 above
- **Troubleshooting:** See section 11 above

**All your pricing configuration is production-ready and working! 🎉**
