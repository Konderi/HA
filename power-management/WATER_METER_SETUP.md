# 💧 Manual Water Meter System Setup

This system lets you manually track your water consumption by entering meter readings.

---

## 🎯 Features

- ✅ Manual water meter reading entry
- ✅ Automatic consumption calculation
- ✅ Cost tracking with water + wastewater + VAT
- ✅ Dashboard card for easy updates
- ✅ History tracking via Home Assistant statistics

---

## 📋 Setup Steps

### 1. Create the Input Helper

**Option A - Via UI (Recommended):**
1. Go to **Settings → Devices & Services → Helpers**
2. Click **+ Create Helper**
3. Choose **Number**
4. Configure:
   - **Name:** Water Meter Reading
   - **Icon:** mdi:counter
   - **Minimum:** 0
   - **Maximum:** 999999
   - **Step size:** 1
   - **Unit of measurement:** L
   - **Display mode:** Box
5. Click **Create**

**Option B - Via YAML:**
1. Copy `input_numbers.yaml` to `/config/input_numbers.yaml`
2. Add to `configuration.yaml`:
   ```yaml
   input_number: !include input_numbers.yaml
   ```
3. Restart Home Assistant

### 2. Deploy Template Sensors

The water sensors are already in `template_sensors_modern.yaml`:
- `sensor.water_consumption` - Tracks total consumption
- `sensor.water_total_cost` - Calculates total cost

### 3. Add Dashboard Card

Copy the card configuration from `lovelace_water_meter_card.yaml` and add to your dashboard:
1. Edit Dashboard → Add Card → Manual Card
2. Paste the YAML content
3. Save

---

## 📊 How to Use

### Initial Setup:
1. Read your physical water meter
2. Enter the current reading in liters into the helper
3. The system will track consumption from this baseline

### Regular Updates:
1. When you read your meter (monthly/quarterly):
2. Enter the new reading
3. The system automatically calculates:
   - Total consumption
   - Water fee
   - Wastewater fee
   - VAT
   - Total cost

---

## 💰 Cost Calculation

**Current Rates (configured in template_sensors_modern.yaml):**
- Water fee: **1.45 €/m³**
- Wastewater fee: **2.32 €/m³**
- VAT: **24%** (multiplier: 1.24)

**Formula:**
```
Total Cost = Consumption (m³) × (Water + Wastewater) × VAT
Total Cost = Consumption (m³) × (1.45 + 2.32) × 1.24
Total Cost = Consumption (m³) × 4.67 €
```

### Example:
- Meter reading: **15,000 liters** = 15 m³
- Cost: 15 × 4.67 = **70.05 €**

---

## 🔄 Updating Prices

If your water prices change, edit `template_sensors_modern.yaml`:

```yaml
# Find this section and update values:
- name: "Water Total Cost"
  state: >
    {% set water_fee = 1.45 %}        # ← Update here
    {% set wastewater_fee = 2.32 %}   # ← Update here
    {% set vat = 1.24 %}               # ← Update here (1.24 = 24% VAT)
```

After updating:
1. Save the file
2. Developer Tools → YAML → Reload Template Entities
3. Or restart Home Assistant

---

## 📈 Tracking History

Home Assistant automatically tracks:
- ✅ **Consumption history** (sensor.water_consumption is `state_class: total_increasing`)
- ✅ **Cost history** (sensor.water_total_cost)
- ✅ **Energy dashboard compatible** (can add to utility tracking)

### Add to Energy Dashboard:
1. Settings → Dashboards → Energy
2. Water Consumption → Add Consumption
3. Select `sensor.water_consumption`
4. Select `sensor.water_total_cost` for cost tracking

---

## 🎨 Dashboard Example

The included card shows:
- 💧 Current meter reading (editable)
- 📊 Total consumption in liters and m³
- 💰 Total cost
- 📝 Cost breakdown (water + wastewater + VAT)
- ➕ Quick +100L button (for testing)

---

## 🔍 Troubleshooting

**Problem:** Helper not showing
- **Solution:** Create via UI (Settings → Helpers) or check configuration.yaml includes input_numbers.yaml

**Problem:** Sensors show "unavailable"
- **Solution:** Make sure input_number.water_meter_reading exists and has a value

**Problem:** Cost calculation wrong
- **Solution:** Check water prices in template_sensors_modern.yaml match your bill

**Problem:** Want to reset consumption
- **Solution:** Set the helper to your current meter reading to start fresh

---

## 📱 Mobile App Integration

The input helper works great on mobile:
1. Open Home Assistant app
2. Go to your dashboard
3. Tap the water meter reading field
4. Enter new value directly
5. Cost updates automatically

---

## 🚀 Future Enhancements (Optional)

You could add:
- **Automations** to remind you to read the meter monthly
- **Notifications** if consumption is unusually high
- **Historical charts** using ApexCharts
- **Monthly consumption** statistics
- **Comparison** with previous periods

Let me know if you'd like any of these additions!

---

## 📝 Notes

- The system uses **liters** as the base unit (common on Finnish water meters)
- Converts automatically to **m³** for cost calculation
- **No external integration required** - completely offline
- **Privacy-friendly** - no data sent anywhere
- **Energy dashboard compatible** - integrates with HA energy tracking

---

**Need help?** Check the sensor attributes for detailed calculation breakdowns!
