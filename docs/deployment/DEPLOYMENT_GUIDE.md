# 🚀 DEPLOYMENT GUIDE - Move Fixes to Home Assistant

## 📋 **What Was Fixed in Git (Not Yet Deployed)**

These files were updated in your Git repo but **NOT yet in your Home Assistant**:

### **1. Pricing Formula Fixes**
- ✅ `electricity_pricing_constants.yaml`
- ✅ `electricity_pricing.yaml`

### **2. Dashboard Sensor Fixes**
- ✅ `dashboards/power-management-professional.yaml`
- ✅ `dashboards/power-management-mobile.yaml`
- ✅ `dashboards/nodered-flow-monitor.yaml`
- ✅ `dashboards/magic-mirror-fullhd.yaml`

### **3. Helper Configuration (If Not Yet Created)**
- ✅ `power-management/input_numbers.yaml`
- ✅ `power-management/input_booleans.yaml`
- ✅ `power-management/input_datetimes.yaml`
- ✅ `power-management/power_management_automations.yaml`

---

## 🎯 **DEPLOYMENT STEPS**

### **STEP 1: Copy Pricing Files to Home Assistant** ⏱️ 3 minutes

**Files to copy:**
```
FROM Git Repo → TO Home Assistant /config/

electricity_pricing_constants.yaml  →  /config/electricity_pricing_constants.yaml
electricity_pricing.yaml            →  /config/electricity_pricing.yaml
```

**How to copy:**

#### **Option A: Using File Editor (Easiest)**
1. Open Home Assistant → **Settings → Add-ons → File Editor**
2. Navigate to `/config/`
3. For each file:
   - Open the file in your Git repo (on Mac)
   - Copy all content
   - In File Editor, create/edit the file
   - Paste the content
   - Click **Save**

#### **Option B: Using Samba/Network Share**
1. On Mac, connect to: `\\homeassistant.local\config`
2. Copy files directly to the `/config/` folder

#### **Option C: Using SSH/SCP**
```bash
cd "/Users/tonijoronen/Library/Mobile Documents/com~apple~CloudDocs/Git/HomeAssistant"

scp electricity_pricing_constants.yaml root@homeassistant.local:/config/
scp electricity_pricing.yaml root@homeassistant.local:/config/
```

---

### **STEP 2: Update configuration.yaml** ⏱️ 2 minutes

**Already done?** Check if your `/config/configuration.yaml` has these lines:

```yaml
homeassistant:
  packages:
    electricity_pricing_constants: !include electricity_pricing_constants.yaml
    electricity_pricing: !include electricity_pricing.yaml
```

**If NOT present:**
1. Open `/config/configuration.yaml` in File Editor
2. Find the `homeassistant:` section
3. Add the lines above (around line 50-54)
4. Save

---

### **STEP 3: Validate & Restart Home Assistant** ⏱️ 3 minutes

1. **Check Configuration:**
   - Go to **Settings → Developer Tools → YAML**
   - Click **"Check Configuration"**
   - Should show: ✅ "Configuration valid!"
   - If errors appear, check the file content

2. **Restart Home Assistant:**
   - Go to **Settings → System → Restart**
   - Click **"Restart Home Assistant"**
   - Wait ~1-2 minutes

3. **Verify Sensor Exists:**
   - Go to **Developer Tools → States**
   - Search for: `electricity_total_price_cents`
   - Should show a value like: `14.44` (c/kWh)
   - Check attributes show: nordpool_price_cents, transfer_price, tax, margin, vat_multiplier

---

### **STEP 4: Copy Dashboard Files** ⏱️ 5 minutes

**Files to copy:**
```
FROM Git Repo → TO Home Assistant /config/

dashboards/power-management-professional.yaml  →  /config/dashboards/power-management-professional.yaml
dashboards/power-management-mobile.yaml        →  /config/dashboards/power-management-mobile.yaml
dashboards/nodered-flow-monitor.yaml           →  /config/dashboards/nodered-flow-monitor.yaml
dashboards/magic-mirror-fullhd.yaml            →  /config/dashboards/magic-mirror-fullhd.yaml
```

**Using File Editor:**
1. Navigate to `/config/dashboards/`
2. For each file:
   - Open file in Git repo on Mac
   - Copy all content
   - Open file in File Editor
   - Replace all content
   - Click **Save**

**OR using Samba:**
- Copy files directly to `\\homeassistant.local\config\dashboards\`

---

### **STEP 5: Reload Dashboards** ⏱️ 1 minute

**Option A: Reload via UI**
1. Go to each dashboard
2. Click the three dots (⋮) in top right
3. Click **"Reload"**

**Option B: Force Browser Refresh**
1. Go to dashboard
2. Press `Ctrl+Shift+R` (Windows/Linux) or `Cmd+Shift+R` (Mac)
3. This clears cache and reloads

**Option C: Restart HA (if dashboards still show old data)**
- Settings → System → Restart

---

### **STEP 6: Verify Everything Works** ⏱️ 5 minutes

#### **Check Pricing Sensor:**
- Developer Tools → States → `sensor.electricity_total_price_cents`
- Should show reasonable value (10-25 c/kWh range)
- Check attributes:
  ```yaml
  nordpool_price_cents: 3.21
  transfer_price: 4.92 or 3.01
  tax: 2.79372
  margin: 0.59
  vat_multiplier: 1.255
  tariff_type: "day (07-22)" or "night (22-07)"
  ```

#### **Check Dashboards:**
1. **Power Management Professional Dashboard:**
   - Price charts should display (not empty)
   - "Current Price" should show c/kWh value (not "unavailable")
   - ApexCharts 24-hour price graph should show bars

2. **Power Management Mobile Dashboard:**
   - "Total Price" card should show value (not "Entity not available")
   - Price displays should show numbers

3. **Node-RED Flow Monitor:**
   - Price Sensor should show active status
   - Price displays should show current c/kWh

4. **Magic Mirror Dashboard:**
   - Price chart should display data

---

## 🔍 **TROUBLESHOOTING**

### **Problem: sensor.electricity_total_price_cents not found**

**Check 1:** Are files in correct location?
```
ls /config/electricity_pricing_constants.yaml
ls /config/electricity_pricing.yaml
```

**Check 2:** Is configuration.yaml updated?
```yaml
# Should have:
homeassistant:
  packages:
    electricity_pricing_constants: !include electricity_pricing_constants.yaml
    electricity_pricing: !include electricity_pricing.yaml
```

**Check 3:** Did you restart HA?
- Settings → System → Restart

**Check 4:** Check logs for errors
- Settings → System → Logs
- Filter for "electricity" or "template"

---

### **Problem: Dashboards still show "unavailable"**

**Solution 1:** Hard refresh browser
- Press `Ctrl+Shift+R` or `Cmd+Shift+R`
- Or clear browser cache

**Solution 2:** Verify dashboard files were copied
```
ls /config/dashboards/power-management-professional.yaml
ls /config/dashboards/power-management-mobile.yaml
```

**Solution 3:** Check if dashboards are using correct path
- Settings → Dashboards → Three dots → Edit
- Check "Path" field matches filename

---

### **Problem: Sensor shows 0 or wrong value**

**Check 1:** Is Nordpool sensor updating?
- Developer Tools → States → `sensor.nordpool_kwh_fi_eur_4_10_0`
- Should show current spot price (not 0)

**Check 2:** Check formula in electricity_pricing.yaml
- Should have: `(nordpool * 100) + transfer_price + tax + margin`
- Should multiply by VAT: `* 1.255`

**Check 3:** Check constants in electricity_pricing_constants.yaml
- Transfer: 4.92 (day) / 3.01 (night)
- Tax: 2.79372
- Margin: 0.59
- VAT: 1.255

---

## 📂 **OPTIONAL: Deploy Helper Entities** ⏱️ 10 minutes

If you want to use the 20 adjustable controls (dashboard sliders):

### **Option A: Create Helpers via UI (Recommended)**
Follow the guide in `ENHANCED_CONTROLS_DEPLOYMENT.md`
- Settings → Devices & Services → Helpers
- Create each helper manually (takes 10 min)

### **Option B: Use YAML Files**
1. Copy helper files:
   ```
   power-management/input_numbers.yaml      → /config/power-management/input_numbers.yaml
   power-management/input_booleans.yaml     → /config/power-management/input_booleans.yaml
   power-management/input_datetimes.yaml    → /config/power-management/input_datetimes.yaml
   ```

2. Update configuration.yaml:
   ```yaml
   input_number: !include power-management/input_numbers.yaml
   input_boolean: !include power-management/input_booleans.yaml
   input_datetime: !include power-management/input_datetimes.yaml
   ```

3. Restart Home Assistant

---

## 📊 **DEPLOYMENT SUMMARY**

### **Files You MUST Copy:**
1. ✅ `electricity_pricing_constants.yaml` → `/config/`
2. ✅ `electricity_pricing.yaml` → `/config/`
3. ✅ 4 dashboard YAML files → `/config/dashboards/`

### **Configuration Changes:**
1. ✅ Update `configuration.yaml` (add packages)
2. ✅ Restart Home Assistant

### **Verification:**
1. ✅ Check sensor exists: `sensor.electricity_total_price_cents`
2. ✅ Verify dashboards show prices (not "unavailable")
3. ✅ Test ApexCharts display data

---

## ⏱️ **TOTAL TIME ESTIMATE**

- Copy pricing files: **3 minutes**
- Update configuration.yaml: **2 minutes**
- Restart & verify sensor: **3 minutes**
- Copy dashboard files: **5 minutes**
- Reload dashboards: **1 minute**
- Final verification: **5 minutes**

**Total: ~20 minutes** ⏱️

---

## ✅ **QUICK CHECKLIST**

- [ ] Copy `electricity_pricing_constants.yaml` to `/config/`
- [ ] Copy `electricity_pricing.yaml` to `/config/`
- [ ] Update `configuration.yaml` with package includes
- [ ] Restart Home Assistant
- [ ] Verify `sensor.electricity_total_price_cents` exists
- [ ] Copy 4 dashboard files to `/config/dashboards/`
- [ ] Reload dashboards (Ctrl+Shift+R)
- [ ] Check dashboards show prices correctly
- [ ] Verify ApexCharts display data
- [ ] Test on mobile dashboard

---

## 🎉 **AFTER DEPLOYMENT**

Once deployed, you should see:

- ✅ `sensor.electricity_total_price_cents` showing correct price (14-16 c/kWh typical)
- ✅ Dashboards displaying price charts with data
- ✅ No "Entity not available" errors
- ✅ Price categories showing correct colors
- ✅ ApexCharts 24-hour graphs working

**You're deploying:**
- ✅ Fixed pricing formula (removed incorrect energy price)
- ✅ Updated margin (0.59 c/kWh)
- ✅ All dashboards using correct sensor
- ✅ No more deprecated sensors

**Status: Ready to deploy! 🚀**
