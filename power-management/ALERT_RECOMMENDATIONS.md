# Recommended Alert Types for Home Automation

This document lists all the useful alerts implemented in your system plus additional ones you might want to add.

## ✅ Currently Implemented Alerts

### Electrical Safety Alerts
- [x] **Phase voltage <200V** - Critical electrical issue
- [x] **Phase voltage >250V** - Overvoltage protection
- [x] **Phase voltage 200-220V or 240-250V** - Warning for abnormal voltage
- [x] **Phase overload >5,750W** - Single phase protection
- [x] **Phase imbalance >50%** - Load distribution warning
- [x] **Total power >95%** - Critical overload prevention
- [x] **Total power >85%** - High load warning

### Device Management Alerts
- [x] **Sauna on >4 hours** - Safety reminder
- [x] **Car charging started** - With amperage and reason
- [x] **Car charging stopped/paused** - With reason
- [x] **Car battery ≥90%** - Charging can be stopped
- [x] **Water boiler ON/OFF** - State change notifications
- [x] **Water boiler <2 hours at 9 PM** - Minimum runtime warning
- [x] **Heat pump temperature changed** - Price-based adjustments
- [x] **Emergency load reduction activated** - Critical action taken

### Daily Reports
- [x] **Daily summary at 9 PM** - Water boiler runtime, status

---

## 💡 Additional Useful Alerts (Not Yet Implemented)

### Energy Cost Alerts
```
Priority: Medium
Implementation: Easy
```
- ⚡ **Price spike alert** - When current price >2x daily average
- 💰 **Price drop alert** - When entering cheapest 3 hours
- 📊 **Daily cost summary** - Total energy cost for the day
- 📈 **Monthly cost projection** - Estimated bill based on usage
- 💸 **Cost threshold exceeded** - Daily spending over target

### Device Health Monitoring
```
Priority: High
Implementation: Medium
```
- 🔴 **Device offline** - Critical device unavailable
  - Shelly devices
  - Tesla integration
  - Temperature sensors
- 📶 **Weak signal warning** - Device connectivity poor
- 🔋 **Battery low** - For wireless sensors
- ⚠️ **Sensor error** - Invalid readings detected

### Tesla-Specific Alerts
```
Priority: Medium
Implementation: Easy
```
- 🚗 **Car arrived home** - Ready for charging
- 🚗 **Car left home** - While still plugged in (forgot to unplug?)
- 🔋 **Charging interrupted** - Stopped unexpectedly
- ⏱️ **Charging taking too long** - >12 hours at low power
- 🎯 **Charge limit reached** - Custom target (e.g., 80%)
- 🌡️ **Battery cold** - Preconditioning might be needed

### Water Boiler Alerts
```
Priority: Medium
Implementation: Medium
```
- 💧 **No heating today** - Boiler hasn't run by 6 PM
- 💧 **Excessive runtime** - >6 hours in a day (possible issue)
- 💧 **Heating outside schedule** - Manual override detected
- 🌡️ **Water temperature low** - If you add temperature sensor

### Heat Pump Alerts
```
Priority: Medium
Implementation: Easy
```
- 🌡️ **Unusual power consumption** - Outside normal range
- 🌡️ **Failed to reach temperature** - Target not achieved in 2 hours
- 🌡️ **Continuous heating >6 hours** - Possible efficiency issue
- ❄️ **Defrost cycle** - If detectable, could indicate icing

### Sauna Alerts
```
Priority: Low
Implementation: Easy
```
- 🔥 **Sauna preheating complete** - Ready to use (if temp sensor available)
- 🔥 **Sauna cooling down** - Off for 30 minutes
- ⏱️ **Forgot sauna on** - No activity detected for 2 hours while on

### Weather-Related Alerts
```
Priority: Low
Implementation: Easy
```
- ❄️ **Freeze warning** - Outdoor temp dropping below -10°C
- 🌡️ **Temperature swing** - >10°C change in 6 hours
- ⚡ **Storm warning** - High winds, prepare for possible outage
- ☀️ **Perfect charging weather** - Mild temps, cheap prices

### Predictive Alerts
```
Priority: Medium
Implementation: Advanced
```
- 📈 **Tomorrow will be expensive** - Prepare to pre-heat
- 📉 **Tomorrow will be cheap** - Defer heating if possible
- 🔋 **Car won't reach target** - Based on available cheap hours
- 💧 **Boiler won't reach 2 hours** - Based on remaining cheap hours

### Security & Safety
```
Priority: High
Implementation: Medium
```
- 🔓 **High power usage while away** - Unexpected consumption
- 🏠 **Returned home** - Normal automation resumed
- 🌙 **Overnight power spike** - Unusual night usage
- 🚨 **Circuit breaker may trip** - Predictive warning at 93-94%

### Maintenance Reminders
```
Priority: Low
Implementation: Easy
```
- 🔧 **Heat pump filter cleaning** - Monthly reminder
- 🧹 **Shelly device restart** - If showing connectivity issues
- 📊 **Flow optimization** - Quarterly tune-up reminder
- 🔄 **System health check** - Monthly report

---

## 🎯 Prioritized Implementation Plan

### Phase 1: Critical (Do First)
Already implemented! ✅
- Voltage monitoring
- Overload protection
- Device conflict management

### Phase 2: Cost Optimization (High Value)
```javascript
// Add to price-based-optimizer.json

// Price spike alert
if (currentPrice > dailyAverage * 2) {
    msg.alert = `⚡ PRICE SPIKE: ${currentPrice}c/kWh (Avg: ${dailyAverage}c/kWh)`;
}

// Daily cost summary
const dailyCost = dailyEnergy * averagePrice / 100;
msg.alert = `💰 Today's energy cost: €${dailyCost.toFixed(2)}`;
```

### Phase 3: Device Health (Reliability)
```javascript
// Add to new flow: device-health-monitor.json

// Device offline check
const deviceState = global.get('homeassistant.homeAssistant.states["switch.device"].state');
if (deviceState === 'unavailable') {
    msg.alert = `🔴 Device offline: ${deviceName}`;
}
```

### Phase 4: Predictive (Advanced)
```javascript
// Analyze tomorrow's prices
const tomorrowPrices = // fetch from sensor
const avgTomorrow = tomorrowPrices.reduce((a,b) => a+b) / tomorrowPrices.length;

if (avgTomorrow > todayAvg * 1.5) {
    msg.alert = `📈 Tomorrow will be expensive! Pre-heat tonight.`;
}
```

---

## 📋 Alert Configuration Template

For each new alert you want to add:

### 1. Define Alert Parameters
```yaml
Alert Name: [Descriptive name]
Priority: Critical / High / Medium / Low
Trigger: [What causes the alert]
Frequency: Immediate / Rate-limited / Once per day
Action Required: Yes / No
Telegram Category: 🚨 Critical / ⚠️ Warning / ℹ️ Info
```

### 2. Implementation Checklist
- [ ] Create monitoring node (state-changed or inject)
- [ ] Add evaluation logic (function node)
- [ ] Implement rate limiting if needed
- [ ] Add to telegram notification flow
- [ ] Test trigger conditions
- [ ] Document in QUICK_REFERENCE.md

### 3. Example: Add "Device Offline" Alert

```javascript
// In new function node
const device = 'switch.water_boiler';
const deviceName = 'Water Boiler';
const state = global.get(`homeassistant.homeAssistant.states["${device}"].state`);

if (state === 'unavailable' || state === 'unknown') {
    const lastSeen = flow.get(`${device}_last_seen`) || 'unknown';
    
    msg.alert = `🔴 ${deviceName} offline\\nLast seen: ${lastSeen}`;
    msg.level = 'high';
    
    return msg;
}

// Update last seen
flow.set(`${device}_last_seen`, new Date().toLocaleString());
return null;
```

---

## 🎨 Alert Emoji Guide

Use consistent emojis for easy recognition:

### Status
- ✅ Success / Normal
- ⚠️ Warning
- 🚨 Critical / Emergency
- ℹ️ Information
- 🔴 Offline / Error

### Devices
- 🚗 Car / Tesla
- 💧 Water / Boiler
- 🔥 Heat / Sauna
- 🌡️ Temperature / Heat Pump
- 🔋 Battery / Power
- ⚡ Electricity / Voltage

### Actions
- 🔄 Reload / Restart
- 📊 Report / Summary
- 📈 Increase / Rising
- 📉 Decrease / Falling
- 💰 Cost / Money
- ⏱️ Time / Duration

---

## 🔊 Alert Volume Management

### Critical (Always notify)
- Voltage issues
- Overload situations
- Device safety (sauna >4h)

### Warning (Rate-limited)
- High load warnings
- Phase imbalance
- Voltage fluctuations

### Info (Can be silenced at night)
- Device state changes
- Temperature adjustments
- Charging status

### Daily Summaries (Once per day)
- Cost reports
- Runtime statistics
- System health

---

## 🌙 Quiet Hours Configuration

To reduce notifications at night, add to function nodes:

```javascript
const hour = new Date().getHours();
const isQuietHours = (hour >= 22 || hour < 7);

if (isQuietHours && msg.level !== 'critical') {
    // Store alert but don't send
    flow.set('pending_alerts', msg.alert);
    return null;
}

// Send critical alerts anytime
return msg;
```

---

## 📱 Telegram Message Formatting

### Use Markdown for Better Readability

```javascript
msg.payload = {
    data: {
        message: `*🚨 CRITICAL ALERT*\n\n` +
                 `Phase A Voltage: ${voltage}V\n` +
                 `Status: Too Low (<200V)\n\n` +
                 `Action: Check electrical panel`,
        parse_mode: 'Markdown'
    }
};
```

### Add Buttons for Actions (Advanced)

```javascript
msg.payload = {
    data: {
        message: '🚗 Car charged to 90%',
        inline_keyboard: [
            [{ text: '🛑 Stop Charging', callback_data: '/stop_charging' }],
            [{ text: '➕ Continue to 100%', callback_data: '/continue_charging' }]
        ]
    }
};
```

---

## 🎯 Your Next Steps

1. **Review current alerts** - Are you receiving them? Are they useful?
2. **Choose Phase 2 alerts** - Pick 2-3 cost optimization alerts
3. **Implement gradually** - Add one alert per week
4. **Test thoroughly** - Ensure rate limiting works
5. **Document changes** - Update this file with your additions

Remember: **More alerts ≠ Better**. Focus on actionable, valuable notifications!
