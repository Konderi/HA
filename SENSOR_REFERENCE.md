# 🔍 Electricity Sensor Reference - Which Sensor to Use?

## ✅ **CORRECT SENSORS (Use These!)**

### **Primary Price Sensor:**
```yaml
sensor.electricity_total_price_cents
```
- **What:** Your complete electricity price (Nordpool + Transfer + Tax + Margin + VAT)
- **Unit:** c/kWh
- **Formula:** `(Nordpool + Transfer + Tax + Margin) × 1.255`
- **Use for:** Dashboards, automations, price displays
- **Status:** ✅ **Modern, actively maintained**

### **Nordpool Spot Price Sensors:**
```yaml
sensor.nordpool_kwh_fi_eur_4_10_0
```
- **What:** Raw Nordpool spot price
- **Unit:** €/kWh
- **Use for:** Seeing just the spot price component
- **Status:** ✅ **Active from Nordpool integration**

```yaml
sensor.shf_electricity_price_now
```
- **What:** Alternative Nordpool spot price (from spot-hinta.fi API)
- **Unit:** €/kWh  
- **Use for:** Backup if nordpool_kwh sensor unavailable
- **Status:** ✅ **Active from spot-price.yaml**

```yaml
sensor.shf_rank_now
```
- **What:** Current hour price ranking (1-24, where 1=cheapest)
- **Use for:** Node-RED automation decisions, boiler scheduling
- **Status:** ✅ **Active, critical for automations**

---

## ❌ **DEPRECATED SENSORS (Don't Use!)**

### **Old Total Price Sensor:**
```yaml
sensor.sahko_kokonaishinta_c  ❌ DEPRECATED
```
- **Problem:** Old Finnish-named sensor, likely doesn't exist in your system
- **Status:** ❌ Removed/deprecated
- **Replace with:** `sensor.electricity_total_price_cents`

### **Old Generic Price Sensor:**
```yaml
sensor.current_electricity_cost_rate  ❌ DEPRECATED
```
- **Problem:** Wrong formula or non-existent
- **Status:** ❌ Removed
- **Replace with:** `sensor.electricity_total_price_cents`

---

## ⚠️ **OTHER SENSORS IN YOUR DASHBOARDS**

These Finnish-named sensors are still in your dashboards. **Check if they exist:**

### **Price Adjustment Sensors:**
```yaml
sensor.sahko_hinnan_korjaus_paiva    # Day price adjustment
sensor.sahko_hinnan_korjaus_viikko   # Week price adjustment  
sensor.sahko_hinnan_korjaus_kuukausi # Month price adjustment
```
**Status:** ⚠️ Check in Home Assistant if these exist
- If they exist and update: Keep them ✅
- If "unavailable": Remove or replace

### **Price Component Sensors:**
```yaml
sensor.sahkon_myyntihinta_c_kwh  # Energy sales price
sensor.sahko_siirtohinta         # Transfer price
```
**Status:** ⚠️ Check if these exist
- **Note:** These should be **replaced by**:
  - Energy price: Built into `sensor.nordpool_kwh_fi_eur_4_10_0`
  - Transfer price: Now calculated in `sensor.electricity_total_price_cents` attributes

---

## 🔧 **How to Check If a Sensor Exists**

### **Method 1: Developer Tools**
1. Go to **Settings → Developer Tools → States**
2. Search for the sensor name
3. If it shows:
   - ✅ Green "Available" = Sensor exists
   - ❌ "Unavailable" = Sensor missing or broken
   - ❌ Not found = Sensor doesn't exist

### **Method 2: Dashboard**
1. Look at your dashboard
2. Sensor cards showing "Entity not available" = Missing sensor

---

## 📊 **Dashboard Sensor Mappings**

### **For ApexCharts (Price Graphs):**
```yaml
# ✅ CORRECT:
- entity: sensor.electricity_total_price_cents
  name: Total Price (c/kWh)

# ❌ WRONG:
- entity: sensor.sahko_kokonaishinta_c
- entity: sensor.current_electricity_cost_rate
```

### **For Price Display Cards:**
```yaml
# ✅ CORRECT:
entity: sensor.electricity_total_price_cents

# ❌ WRONG:
entity: sensor.sahko_kokonaishinta_c
entity: sensor.current_electricity_cost_rate
```

### **For Nordpool Spot Price:**
```yaml
# ✅ CORRECT (primary):
entity: sensor.nordpool_kwh_fi_eur_4_10_0

# ✅ CORRECT (alternative):
entity: sensor.shf_electricity_price_now
```

### **For Price Rankings (Automation):**
```yaml
# ✅ CORRECT:
entity: sensor.shf_rank_now  # Values 1-24
```

---

## 🚀 **What We Fixed Today**

### **Commit 1: Fix Pricing Formula**
```
electricity_pricing.yaml
electricity_pricing_constants.yaml
```
- ✅ Removed incorrect energy_price addition
- ✅ Updated margin to 0.59 c/kWh
- ✅ Formula now: (Nordpool + Transfer + Tax + Margin) × VAT

### **Commit 2: Fix Dashboard Sensors (23 replacements)**
```
power-management-professional.yaml (7 fixes)
power-management-mobile.yaml (7 fixes)
nodered-flow-monitor.yaml (6 fixes)
magic-mirror-fullhd.yaml (3 fixes)
```
- ✅ Replaced `sensor.current_electricity_cost_rate` → `sensor.electricity_total_price_cents`

### **Commit 3: Fix Mobile Dashboard**
```
power-management-mobile.yaml (1 fix)
```
- ✅ Replaced `sensor.sahko_kokonaishinta_c` → `sensor.electricity_total_price_cents`

---

## ✅ **Current Status**

### **FIXED:**
- ✅ All ApexCharts using correct sensor
- ✅ All price displays using correct sensor
- ✅ Mobile dashboard using correct sensor
- ✅ Pricing formula corrected
- ✅ Margin updated to 0.59 c/kWh

### **REMAINING TO CHECK:**
You still have these sensors in dashboards that might not exist:
- ⚠️ `sensor.sahko_hinnan_korjaus_*` (price adjustment sensors)
- ⚠️ `sensor.sahkon_myyntihinta_c_kwh` (energy sales price)
- ⚠️ `sensor.sahko_siirtohinta` (transfer price)

**Action:** Check if these exist in your Home Assistant:
- If they exist and work: Keep them ✅
- If they're unavailable: We can remove or replace them

---

## 🎯 **Quick Reference**

| Purpose | Use This Sensor |
|---------|-----------------|
| **Total price (what you pay)** | `sensor.electricity_total_price_cents` |
| **Nordpool spot price** | `sensor.nordpool_kwh_fi_eur_4_10_0` |
| **Price ranking (1-24)** | `sensor.shf_rank_now` |
| **Alternative spot price** | `sensor.shf_electricity_price_now` |
| **Historical average** | `sensor.electricity_average_price_today` |
| **Today's min price** | `sensor.electricity_min_price_today` |
| **Today's max price** | `sensor.electricity_max_price_today` |

---

## 📝 **For Your Node-RED Flows**

```javascript
// Get total price (what you actually pay)
const totalPrice = parseFloat(
  global.get('homeassistant.homeAssistant.states["sensor.electricity_total_price_cents"].state')
);

// Get current rank (for automation decisions)
const currentRank = parseInt(
  global.get('homeassistant.homeAssistant.states["sensor.shf_rank_now"].state')
);

// Get just the Nordpool spot component
const nordpoolPrice = parseFloat(
  global.get('homeassistant.homeAssistant.states["sensor.nordpool_kwh_fi_eur_4_10_0"].state')
) * 100; // Convert € to cents
```

---

**All critical sensors fixed and working! 🎉**
