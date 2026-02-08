# 🚀 Quick Start Guide

Get your Home Assistant power management system up and running in 30 minutes.

## Prerequisites

### Required Hardware
- ✅ Home Assistant instance (2026.2.x or newer)
- ✅ Node-RED add-on installed
- ✅ Shelly EM3 (3-phase power monitoring)
- ✅ Mitsubishi ILP heat pump
- ✅ iPhone with HA Companion App (for notifications)

### Required Integrations
- ✅ Nordpool
- ✅ Spot-hinta.fi (custom component)
- ✅ ApexCharts (HACS)
- ✅ Mobile App

### System Requirements
- Home Assistant OS or Container
- At least 2 GB RAM
- 10 GB free storage

---

## 📥 Step 1: Clone Repository

```bash
# Clone from GitHub
git clone https://github.com/konderi/HA.git
cd HA

# Or download ZIP
# Download from: https://github.com/konderi/HA/archive/main.zip
# Extract to: ~/HA/
```

---

## 🔧 Step 2: Install Configuration Files

### Copy Sensor Configurations
```bash
# Copy electricity pricing sensors
scp config/sensors/*.yaml root@homeassistant:/config/sensors/
```

### Copy Input Helpers
```bash
# Copy all input helpers
scp config/input_helpers/*.yaml root@homeassistant:/config/input_helpers/
```

### Copy Automations & Notifications
```bash
# Copy notification automations
scp config/automations/*.yaml root@homeassistant:/config/automations/

# Copy iPhone notification config
scp config/notify/*.yaml root@homeassistant:/config/notify/
```

### Copy AI Configuration
```bash
# Copy AI conversation config
scp ai/conversation_config.yaml root@homeassistant:/config/ai/

# Copy AI prompt templates
scp ai/prompts/*.yaml root@homeassistant:/config/ai/prompts/
```

---

## 📝 Step 3: Update configuration.yaml

Add these lines to your `configuration.yaml`:

```yaml
# Sensors
sensor: !include_dir_merge_list sensors/

# Input Helpers
input_boolean: !include input_helpers/input_booleans.yaml
input_number: !include input_helpers/input_numbers.yaml
input_datetime: !include input_helpers/input_datetimes.yaml

# Automations
automation: !include_dir_merge_list automations/

# Notifications
notify: !include notify/ios_notify.yaml

# AI Conversation
conversation: !include ai/conversation_config.yaml
```

**Save and close the file.**

---

## 📱 Step 4: Configure iPhone Notifications

### Install Home Assistant Companion App
1. Open App Store on iPhone
2. Search: "Home Assistant"
3. Install official Home Assistant Companion App
4. Open app and login

### Get Device ID
1. In HA, go to **Settings** → **Devices & Services** → **Mobile App**
2. Find your iPhone (e.g., "Toni's iPhone")
3. Note the device ID (e.g., `iphone_17`)

### Update Notification Config
Edit `config/notify/ios_notify.yaml`:
```yaml
- name: iphone17
  platform: mobile_app
  device_id: iphone_17  # ← Change this to your device ID
```

---

## 🔄 Step 5: Import Node-RED Flows

### Method 1: Import via UI
1. Open Node-RED: `http://homeassistant.local:1880`
2. Click **Menu (☰)** → **Import**
3. Click **Select a file to import**
4. Navigate to `nodered/flows/`
5. Select **price-based-optimizer.json** first
6. Click **Import** → Position nodes → **Deploy**
7. Repeat for other 8 flows

### Method 2: Copy Flows Directly
```bash
# Copy all flows (overwrites existing)
scp nodered/flows/*.json root@homeassistant:/config/node-red/

# Restart Node-RED
# In HA: Settings → Add-ons → Node-RED → Restart
```

---

## 📊 Step 6: Install Dashboards

### Professional Dashboard (Desktop)
1. In HA, go to **Settings** → **Dashboards**
2. Click **+ Add Dashboard**
3. Name: "Power Management Professional"
4. URL: `power-management-professional`
5. Icon: `mdi:lightning-bolt`
6. Click **Add**
7. Click **⋮** (three dots) → **Edit** → **Raw configuration editor**
8. Copy entire content of `dashboards/power-management-professional.yaml`
9. Paste and click **Save**

### Mobile Dashboard
1. Click **+ Add Dashboard**
2. Name: "Power Management Mobile"
3. URL: `power-management-mobile`
4. Icon: `mdi:cellphone`
5. Click **Add**
6. Raw editor → Paste `dashboards/power-management-mobile.yaml`
7. Click **Save**

---

## 🔄 Step 7: Restart Home Assistant

```bash
# In Home Assistant UI:
# Settings → System → Restart

# Or via SSH:
ha core restart
```

**Wait 2-3 minutes for restart to complete.**

---

## ✅ Step 8: Verify Installation

### Check Entities Exist
1. Go to **Developer Tools** → **States**
2. Search for these entities:
   - `sensor.nordpool_kwh_fi_eur_4_10_0` (Nordpool price)
   - `sensor.shf_rank_now` (Spot-hinta.fi ranking)
   - `sensor.current_power_consumption` (Total power)
   - `climate.mitsu_ilp` (ILP heat pump)
   - `input_number.tehostuslampo` (Boost temp)
   - `input_number.normaalilampo_presence` (Normal temp)
   - `input_number.lamponpudotus_presence` (Eco temp)

### Test Node-RED Flows
1. Open Node-RED: `http://homeassistant.local:1880`
2. Find **price-based-optimizer** flow
3. Click the inject (timestamp) node on the left
4. Check debug panel (right side) for output
5. Verify ILP temperature changed in HA

### Test AI Assistant
1. Click **Assist** icon in HA sidebar
2. Type: "Give me a power report"
3. Wait for response (should show current power, price, heating mode)

### Test iPhone Notifications
1. Turn on a high-power device (> 12 kW total)
2. Wait 30 seconds
3. Check iPhone for notification: "⚠️ High Power Consumption"
4. If no notification, check:
   - Companion App is installed
   - Device ID is correct in `ios_notify.yaml`
   - Automation is enabled: `config/automations/notifications.yaml`

### Test Dashboards
1. Navigate to **Power Management Professional** dashboard
2. Check all pages load (Monitor, Control, Flows, Statistics, Settings)
3. On mobile, open **Power Management Mobile** dashboard
4. Verify all 7 views display correctly

---

## 🎯 Step 9: Configure Your Settings

### Set Temperature Preferences
1. Go to **Settings** page in dashboard
2. Find **ILP Climate Control** section
3. Set your preferred temperatures:
   - **Boost Mode (Rank 1-6):** 24°C (cheap hours)
   - **Normal Mode (Rank 7-18):** 21°C (mid-price)
   - **Eco Mode (Rank 19-24):** 19°C (expensive hours)

### Set Power Thresholds
1. In Settings page, find **Power Management** section
2. Set:
   - **Peak Power Limit:** 14.5 kW (default)
   - **High Power Warning:** 12 kW (default)
   - **Critical Power Limit:** 13.5 kW (default)

### Configure Room Temperatures
1. Find **Room Control** section
2. Set target temps for each room:
   - Master bedroom: 22°C
   - Tuomas room: 21°C
   - Sara room: 20°C

---

## 🧪 Step 10: Test Automation

### Test Price-Based Heating
1. Check current price rank: `sensor.shf_rank_now`
2. Wait for next hour (flows trigger at :01 past the hour)
3. Verify ILP temperature changes:
   - Rank 1-6: Should set to Boost temp (24°C)
   - Rank 7-18: Should set to Normal temp (21°C)
   - Rank 19-24: Should set to Eco temp (19°C)

### Manual Test
1. In Node-RED, find **price-based-optimizer** flow
2. Click inject node (timestamp icon on left)
3. Check ILP changes immediately

### Test Notifications
Trigger each notification type:
- **High Power:** Use sauna + Tesla charging (> 12 kW)
- **Peak Warning:** Add more devices (> 13.5 kW)
- **Cheap Price:** Wait for rank 1-3 hour
- **Expensive Price:** Wait for rank 22-24 hour
- **Heating Mode:** Manually change price rank to trigger mode change
- **Daily Summary:** Wait until 22:00

---

## 📈 Monitor Performance

### First 24 Hours
- Monitor power consumption on **Monitor** page
- Check heating mode changes throughout the day
- Verify notifications arrive correctly
- Review phase balance

### First Week
- Check **Statistics** page for consumption patterns
- Ask AI: "Analyze my energy usage"
- Review optimization score (target: 70+)
- Compare costs to previous week

### First Month
- Calculate savings vs previous month
- Ask AI: "Optimize heating"
- Fine-tune temperature settings
- Review and adjust thresholds

---

## 🆘 Troubleshooting

### Entities Not Found
```bash
# Run validation script
python3 scripts/validate_config.py

# Check Home Assistant logs
# Settings → System → Logs
```

### Node-RED Flows Not Working
- Verify HA connection: Node-RED → Configuration nodes → `server`
- Check entity IDs are correct
- Deploy flows (red Deploy button means changes pending)
- Check debug panel for errors

### iPhone Notifications Not Arriving
1. Verify Companion App is installed and logged in
2. Check device ID matches in `ios_notify.yaml`
3. Test notification manually:
   - Developer Tools → Services
   - Service: `notify.iphone17`
   - Message: "Test notification"
   - Call Service
4. Check iPhone notification settings allow HA notifications

### AI Not Responding
- Check `conversation:` line in `configuration.yaml`
- Verify `ai/conversation_config.yaml` exists
- Restart Home Assistant
- Test in Developer Tools → Services → `conversation.process`

### Dashboards Not Loading
- Check YAML syntax (use YAML validator)
- Verify all entities exist
- Clear browser cache (Ctrl+F5)
- Check browser console for errors (F12)

### High Power False Alerts
- Adjust threshold in `input_number.high_power_threshold`
- Current default: 12 kW
- Increase to 13-14 kW if needed

---

## 📚 Additional Resources

- **Full Documentation:** `docs/`
- **Configuration Guide:** `docs/configuration/`
- **Troubleshooting:** `docs/troubleshooting/`
- **Entity Reference:** `docs/configuration/ENTITY_REFERENCE.md`
- **Node-RED Guide:** `nodered/README.md`
- **AI Guide:** `ai/README.md`

---

## ✨ Next Steps

### Optimize Your System
1. **Week 1:** Monitor and observe patterns
2. **Week 2:** Fine-tune temperature settings
3. **Week 3:** Adjust power thresholds
4. **Week 4:** Review savings and optimize

### Advanced Features
- Add presence detection
- Integrate weather forecasts
- Customize Node-RED flows
- Create custom AI prompts
- Build additional dashboards

### Join Community
- Home Assistant forums
- GitHub discussions
- Share your improvements

---

## 🎉 Congratulations!

Your Home Assistant power management system is now operational!

**Expected Benefits:**
- 15-25% heating cost reduction
- Automatic power management
- iPhone notifications for all power events
- AI-powered optimization recommendations
- Professional monitoring dashboards

**Estimated Annual Savings:** €500-800

---

**Questions?** Create an issue on GitHub: https://github.com/konderi/HA/issues

**Last Updated:** 2026-02-09
