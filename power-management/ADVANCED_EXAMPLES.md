# Advanced Examples

## Example 1: Vacation Mode

Automatically lower heating when you're away for extended periods.

### Create Helper
- Name: "Vacation Mode"
- Entity ID: `input_boolean.vacation_mode`

### Node-RED Flow Addition

Add this to your advanced heating flow:

```javascript
// In a function node
const isVacation = global.get('homeassistant.homeAssistant.states["input_boolean.vacation_mode"].state');

if (isVacation === 'on') {
    msg.payload = 15; // Minimal heating
    return msg;
}

// Otherwise continue with normal logic
return msg;
```

## Example 2: Window Open Detection

Automatically turn off heating when windows are open.

```javascript
// Function node: Check Window Sensors
const windows = [
    'binary_sensor.living_room_window',
    'binary_sensor.bedroom_window',
    'binary_sensor.kitchen_window'
];

let anyWindowOpen = false;

windows.forEach(window => {
    const state = global.get(`homeassistant.homeAssistant.states["${window}"].state`);
    if (state === 'on') {
        anyWindowOpen = true;
    }
});

if (anyWindowOpen) {
    // Turn off heating
    msg.payload = {
        domain: 'climate',
        service: 'turn_off',
        data: {
            entity_id: 'climate.living_room'
        }
    };
} else {
    return null; // Don't change if windows closed
}

return msg;
```

## Example 3: Humidity-Based Heating Boost

Boost bathroom heating after shower detection (high humidity).

```javascript
// Function node: Humidity-based Boost
const humidity = parseFloat(global.get('homeassistant.homeAssistant.states["sensor.bathroom_humidity"].state'));
const targetHumidity = 60;

if (humidity > targetHumidity) {
    // High humidity detected, boost heating to help dry
    msg.payload = 24;
    msg.boost_reason = 'humidity';
    
    // Set a timeout to return to normal after 30 minutes
    flow.set('bathroom_boost_until', Date.now() + (30 * 60 * 1000));
    
    return msg;
}

return null;
```

## Example 4: Guest Mode

Override schedules when guests are visiting.

### Create Helper
- Name: "Guest Mode"
- Entity ID: `input_boolean.guest_mode`

```javascript
// Function node: Guest Mode Logic
const guestMode = global.get('homeassistant.homeAssistant.states["input_boolean.guest_mode"].state');

if (guestMode === 'on') {
    // Keep house warmer and for longer hours
    const hour = new Date().getHours();
    
    if (hour >= 7 && hour < 24) {
        msg.payload = 22; // Comfortable all day
    } else {
        msg.payload = 19; // Warmer at night too
    }
    
    return msg;
}

return null; // Continue with normal schedule
```

## Example 5: Predictive Heating (Pre-warming)

Start heating before you arrive home based on travel time.

```javascript
// Function node: Predictive Pre-warming
const travelTime = parseInt(global.get('homeassistant.homeAssistant.states["sensor.travel_time_home"].state'));
const currentState = global.get('homeassistant.homeAssistant.states["person.user"].state');

// If away and travel time is 30 mins or less, start warming
if (currentState === 'not_home' && travelTime <= 30) {
    msg.payload = 21; // Start pre-warming
    msg.reason = 'predictive_heating';
    
    node.status({
        fill: 'blue',
        shape: 'dot',
        text: `Pre-warming: ${travelTime} min away`
    });
    
    return msg;
}

return null;
```

## Example 6: Temperature Zones with Priority

Different priority levels for different rooms.

```javascript
// Function node: Priority-based Heating
const rooms = [
    { id: 'climate.bedroom', priority: 1, temp: 19 },
    { id: 'climate.living_room', priority: 2, temp: 21 },
    { id: 'climate.office', priority: 3, temp: 20 },
    { id: 'climate.bathroom', priority: 4, temp: 22 }
];

// Get current power usage
const powerUsage = parseFloat(global.get('homeassistant.homeAssistant.states["sensor.power_usage"].state'));
const powerLimit = 5000; // 5kW limit

// If approaching power limit, reduce lower priority rooms
if (powerUsage > powerLimit * 0.8) {
    const messages = [];
    
    rooms.forEach(room => {
        let temp = room.temp;
        
        // Reduce temperature for lower priority rooms
        if (room.priority > 2) {
            temp -= 2;
        }
        
        messages.push({
            payload: {
                entity_id: room.id,
                temperature: temp
            }
        });
    });
    
    return [messages];
}

return null;
```

## Example 7: Weather Forecast Optimization

Adjust heating based on tomorrow's weather forecast.

```javascript
// Function node: Forecast-based Optimization
const forecast = global.get('homeassistant.homeAssistant.states["weather.home"].attributes.forecast');

if (forecast && forecast.length > 0) {
    const tomorrow = forecast[0];
    const tomorrowHigh = tomorrow.temperature;
    
    // If tomorrow will be warm, reduce evening heating
    if (tomorrowHigh > 15) {
        const hour = new Date().getHours();
        
        if (hour >= 20) {
            msg.payload = 19; // Lower evening temp
            msg.reason = 'warm_forecast_tomorrow';
            return msg;
        }
    }
    
    // If tomorrow will be very cold, boost evening heating
    if (tomorrowHigh < 0) {
        const hour = new Date().getHours();
        
        if (hour >= 20) {
            msg.payload = 22; // Higher evening temp
            msg.reason = 'cold_forecast_tomorrow';
            return msg;
        }
    }
}

return null;
```

## Example 8: Learning Temperature Preferences

Track and learn preferred temperatures over time.

```javascript
// Function node: Learning Algorithm
const now = new Date();
const hour = now.getHours();
const day = now.getDay();

// Get historical preferences from context
let preferences = flow.get('temp_preferences') || {};
const key = `day${day}_hour${hour}`;

// Get current manual temperature if set
const currentTemp = parseFloat(global.get('homeassistant.homeAssistant.states["climate.living_room"].attributes.temperature'));

// Store preference
if (!preferences[key]) {
    preferences[key] = [];
}

preferences[key].push(currentTemp);

// Keep only last 30 data points
if (preferences[key].length > 30) {
    preferences[key].shift();
}

// Calculate average preferred temperature
const avgTemp = preferences[key].reduce((a, b) => a + b, 0) / preferences[key].length;

flow.set('temp_preferences', preferences);

msg.payload = Math.round(avgTemp * 10) / 10; // Round to 1 decimal
msg.learned = true;

return msg;
```

## Example 9: Integration with Sleep Tracking

Adjust bedroom temperature based on sleep stages.

```javascript
// Function node: Sleep Stage Heating
const sleepState = global.get('homeassistant.homeAssistant.states["sensor.sleep_stage"].state');

switch(sleepState) {
    case 'awake':
        msg.payload = 20; // Normal temp
        break;
    case 'light':
        msg.payload = 18; // Cooler for better sleep
        break;
    case 'deep':
        msg.payload = 17; // Coolest for deep sleep
        break;
    case 'rem':
        msg.payload = 18; // Slightly warmer
        break;
    default:
        return null;
}

msg.entity_id = 'climate.bedroom';
return msg;
```

## Example 10: Multi-Zone Coordination

Coordinate heating across zones to avoid overloading the system.

```javascript
// Function node: Zone Coordinator
const zones = [
    { id: 'climate.living_room', requested: 21 },
    { id: 'climate.bedroom', requested: 19 },
    { id: 'climate.office', requested: 20 },
    { id: 'climate.bathroom', requested: 22 }
];

// Get current states
let activeZones = 0;
zones.forEach(zone => {
    const state = global.get(`homeassistant.homeAssistant.states["${zone.id}"].state`);
    if (state === 'heating') {
        activeZones++;
    }
});

const maxConcurrent = 2; // Maximum zones heating simultaneously

// If too many zones active, prioritize
if (activeZones >= maxConcurrent) {
    // Only heat the highest priority zone
    msg.payload = {
        entity_id: zones[0].id,
        temperature: zones[0].requested
    };
    
    // Delay others
    zones.slice(1).forEach(zone => {
        // Set to slightly lower to prevent heating
        // Will be adjusted later
    });
} else {
    // Normal operation
    return null;
}

return msg;
```

## Implementing These Examples

1. Add a new function node to your existing flow
2. Copy the JavaScript code into the function node
3. Connect appropriate input/output nodes
4. Update entity IDs to match your setup
5. Deploy and test
6. Monitor in debug panel

Remember to test thoroughly before relying on these automations!
