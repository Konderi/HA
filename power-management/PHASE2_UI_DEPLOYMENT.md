# 🚀 Phase 2 Deployment - UI Method (Easiest!)

## Step 1: Create Helper Entities via UI (5-7 minutes)

Since copy-paste is difficult, let's create helpers using Home Assistant's built-in UI. Much easier!

### 1.1 Access Helpers Menu
1. Open Home Assistant
2. Go to: **Settings → Devices & Services → Helpers**
3. Click **"+ CREATE HELPER"** button

---

### 1.2 Create Schedule Helpers (2 helpers)

#### Helper 1: MH1 Start Time
1. Click **"+ CREATE HELPER"**
2. Select **"Time"**
3. Fill in:
   - **Name:** `MH1 Heating Start Time`
   - **Icon:** Click icon → Search "clock" → Select `mdi:clock-start`
   - **Initial value:** `22:00:00`
4. Click **CREATE**

#### Helper 2: MH1 End Time
1. Click **"+ CREATE HELPER"**
2. Select **"Time"**
3. Fill in:
   - **Name:** `MH1 Heating End Time`
   - **Icon:** Search "clock" → Select `mdi:clock-end`
   - **Initial value:** `07:00:00`
4. Click **CREATE**

---

### 1.3 Create Toggle Helpers (2 helpers)

#### Helper 3: Kids at Home
1. Click **"+ CREATE HELPER"**
2. Select **"Toggle"**
3. Fill in:
   - **Name:** `Kids at Home`
   - **Icon:** Search "home" → Select `mdi:home-account`
4. Click **CREATE**

#### Helper 4: MH1 Manual Override
1. Click **"+ CREATE HELPER"**
2. Select **"Toggle"**
3. Fill in:
   - **Name:** `MH1 Manual Override`
   - **Icon:** Search "radiator" → Select `mdi:radiator`
4. Click **CREATE**

---

### 1.4 Create Number Helpers (3 helpers)

#### Helper 5: MH1 Target Temperature
1. Click **"+ CREATE HELPER"**
2. Select **"Number"**
3. Fill in:
   - **Name:** `MH1 Target Temperature`
   - **Icon:** Search "thermometer" → Select `mdi:thermometer`
   - **Minimum:** `18`
   - **Maximum:** `24`
   - **Step size:** `0.5`
   - **Display mode:** `Slider`
   - **Unit of measurement:** `°C`
4. Click **CREATE**

#### Helper 6: Kids Rooms Minimum Temperature
1. Click **"+ CREATE HELPER"**
2. Select **"Number"**
3. Fill in:
   - **Name:** `Kids Rooms Minimum Temperature`
   - **Icon:** Search "thermometer" → Select `mdi:thermometer-low`
   - **Minimum:** `16`
   - **Maximum:** `20`
   - **Step size:** `0.5`
   - **Display mode:** `Slider`
   - **Unit of measurement:** `°C`
4. Click **CREATE**

#### Helper 7: Kids Rooms Target Temperature
1. Click **"+ CREATE HELPER"**
2. Select **"Number"**
3. Fill in:
   - **Name:** `Kids Rooms Target Temperature`
   - **Icon:** Search "thermometer" → Select `mdi:thermometer`
   - **Minimum:** `18`
   - **Maximum:** `22`
   - **Step size:** `0.5`
   - **Display mode:** `Slider`
   - **Unit of measurement:** `°C`
4. Click **CREATE**

---

### ✅ 1.5 Verify All 7 Helpers Created

In **Settings → Devices & Services → Helpers**, you should now see:

**Time helpers (2):**
- ✅ MH1 Heating Start Time
- ✅ MH1 Heating End Time

**Toggle helpers (2):**
- ✅ Kids at Home
- ✅ MH1 Manual Override

**Number helpers (3):**
- ✅ MH1 Target Temperature
- ✅ Kids Rooms Minimum Temperature
- ✅ Kids Rooms Target Temperature

**Total: 7 helpers** ✅

---

### 1.6 Set Initial Values

Click on each helper and set initial values:

**MH1 Heating Start Time:** Set to `22:00` (your bedtime)
**MH1 Heating End Time:** Set to `07:00` (your wake time)
**Kids at Home:** Toggle **ON** (if kids are home this week)
**MH1 Target Temperature:** Set to `20°C`
**Kids Rooms Minimum Temperature:** Set to `18°C`
**Kids Rooms Target Temperature:** Set to `19°C`

---

## Step 2: Import Node-RED Flows (15 minutes)

Now let's import the 5 automation flows!

### 2.1 Access Node-RED
Open: **http://homeassistant.local:1880**

If you see "not configured" warning:
1. Click the warning
2. Enter HA URL: `http://homeassistant.local:8123`
3. Enter your access token (get from HA Profile → Long-Lived Access Tokens)

---

### 2.2 Import Flow 1: Temperature-Based Radiator Control ⭐ (NEW!)

**This is your main radiator automation!**

1. Open this file in VS Code: `power-management/flows/temperature-radiator-control.json`
2. Select All (Cmd+A) → Copy (Cmd+C)
3. In Node-RED: Click **☰ (hamburger menu)** → **Import**
4. Paste JSON into box
5. Click **Import**
6. Flow appears on canvas
7. Click **Deploy** button (top right)

**What it does:**
- ✅ MH1 heats only 22:00-07:00 to your target temp
- ✅ Tuomas room heats when kids home + temp < 18°C
- ✅ Sara room heats when kids home + temp < 18°C
- ✅ Auto-off when kids toggle = OFF

---

### 2.3 Import Flow 2: Priority Load Balancer 🔴 (CRITICAL!)

**Prevents fuse overload!**

1. Open file: `power-management/flows/priority-load-balancer.json`
2. Copy → Import → Deploy

**What it does:**
- ✅ Keeps total power < 17,250W (3×25A limit)
- ✅ Sauna always priority #1 (never reduced)
- ✅ Reduces Tesla charging dynamically
- ✅ Turns off boiler if needed

---

### 2.4 Import Flow 3: Peak Power Limiter 💰

**Eliminates tehomaksu fees!**

1. Open file: `power-management/flows/peak-power-limiter.json`
2. Copy → Import → Deploy

**What it does:**
- ✅ Monitors 60-min rolling average
- ✅ Keeps consumption < 8kW (avoids peak fees)
- ✅ Predictive algorithm (forecasts 5/10/15/30 min ahead)
- ✅ Gentle reduction prioritizes comfort

---

### 2.5 Import Flow 4: Price-Based Optimizer 📊

**Schedules loads for cheap hours!**

1. Open file: `power-management/flows/price-based-optimizer.json`
2. Copy → Import → Deploy

**What it does:**
- ✅ Heat pump temp control (boost during cheap hours)
- ✅ Boiler scheduling (only runs in cheap hours)
- ✅ Uses Nordpool prices (6 cheapest/expensive hours)

---

### 2.6 Import Flow 5: Phase Monitor & Alerts ⚡

**Monitors electrical health!**

1. Open file: `power-management/flows/phase-monitor-alerts.json`
2. Copy → Import → Deploy

**What it does:**
- ✅ Voltage monitoring (<200V = critical alert)
- ✅ Phase imbalance detection
- ✅ Overload warnings (>85% capacity)
- ✅ Notifications via HA

---

### ✅ 2.7 Verify All Flows Imported

In Node-RED, you should see **5 flow tabs** at the top:
1. ✅ Temperature-Based Radiator Control
2. ✅ Priority Load Balancer
3. ✅ Peak Power Limiter
4. ✅ Price-Based Optimizer
5. ✅ Phase Monitor & Alerts

**Check for errors:**
- Click **🐛 (debug tab)** on right sidebar
- Should see temperature updates and messages
- No red error messages

---

## Step 3: Test Everything (10 minutes)

### Test 1: Kids Home Toggle 👨‍👩‍👧‍👦

1. Go to HA → Find **"Kids at Home"** toggle
2. **Turn it OFF**
3. Within 1 minute: Both kids radiators (Tuomas & Sara) should turn **OFF**
4. **Turn it ON**
5. If room temp < 18°C, radiators should turn **ON**

**Expected:** ✅ Radiators respond to toggle immediately

---

### Test 2: MH1 Schedule 🕙

Current time is not in 22:00-07:00 window, so:
1. Temporarily change **MH1 Heating Start Time** to **current time**
2. Wait 2 minutes
3. If room temp < 20°C, MH1 should turn **ON**
4. Change **MH1 Heating End Time** to **current time**
5. MH1 should turn **OFF**
6. **Reset schedule:** Start=22:00, End=07:00

**Expected:** ✅ MH1 only heats during scheduled time

---

### Test 3: Manual Override 🔧

1. Turn **ON** "MH1 Manual Override"
2. MH1 should heat **regardless of time**
3. Turn **OFF** manual override
4. MH1 should follow schedule again

**Expected:** ✅ Manual override works 24/7

---

### Test 4: Node-RED Debug 🐛

1. Open Node-RED
2. Click **🐛 (debug tab)** on right
3. You should see:
   - Temperature readings updating
   - Decision logic messages ("MH1: OFF - outside schedule")
   - Control actions

**Expected:** ✅ No errors, messages make sense

---

## Step 4: Monitor First 24 Hours 📊

Let the system run and watch for:

**✅ Room Temperatures:**
- MH1: Stays ~20°C during 22:00-07:00
- Tuomas/Sara: Stay ≥18°C when kids home
- Comfortable throughout

**✅ Radiator Behavior:**
- Turns on/off smoothly (not cycling rapidly)
- Respects schedules
- Kids radiators OFF when toggle OFF

**✅ Power Management:**
- Total power never exceeds 17,250W
- No fuse trips
- Tesla charging adjusts if needed

**✅ Node-RED Logs:**
- No errors in debug panel
- Decision logic makes sense

---

## 🎉 Phase 2 Complete!

### What You Now Have:

✅ **7 helper entities** (created via UI)
✅ **5 Node-RED flows** for automation:
   - Temperature-based radiator control ⭐ NEW!
   - Priority load balancer (fuse protection) 🔴
   - Peak power limiter (tehomaksu elimination) 💰
   - Price-based optimizer (heat pump scheduling) 📊
   - Phase monitor (electrical health) ⚡
✅ **Intelligent heating automation**

### Expected Savings:

💰 **Energy:**
- Kids away week: ~40-50 kWh saved
- MH1 night-only: ~15-20 kWh/week saved
- Peak avoidance: €16-24/month saved
- **Total: ~€30-50/month** 🎯

🏠 **Comfort:**
- MH1 warm at bedtime
- Kids rooms comfortable when home
- No cold mornings

⚡ **Safety:**
- Automatic fuse protection
- Phase monitoring
- Voltage alerts

---

## 🎯 Next Steps:

1. ✅ Let it run for **1 week** to verify behavior
2. ✅ Toggle "Kids at Home" next Saturday/Sunday (custody changeover)
3. ✅ Monitor energy dashboard
4. ✅ Adjust target temps if needed

---

## 📞 Need Help?

**Quick Checks:**
- Node-RED debug panel (🐛 tab)
- HA logs (Settings → System → Logs)
- Helper values (Settings → Helpers)

**Common Issues:**
- **Radiators not turning on?** Check kids_home toggle and schedule
- **MH1 always on?** Check manual override is OFF
- **Errors in Node-RED?** Re-import flow and deploy
- **Helpers missing?** Check they're created in UI

---

**You're all set! Enjoy your intelligent power management! 🚀**

---

## Optional: Add Dashboard Card (5 min)

Want a nice control panel? Add this card:

1. Edit Lovelace dashboard
2. Add Card → Manual
3. Open file: `power-management/lovelace_radiator_control_card.yaml`
4. Copy contents → Paste → Save

You'll get:
- Kids home toggle
- Live room temperatures
- Radiator switches
- Temperature sliders
- MH1 schedule controls
- Status overview

**This is optional - flows work without the dashboard card!**
