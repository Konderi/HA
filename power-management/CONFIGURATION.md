# Configuration Guide

## Entity Setup

Before importing the flows, ensure you have the following entities configured in Home Assistant:

### Climate Entities (Required)
- `climate.living_room` - Living room thermostat
- `climate.bedroom` - Bedroom thermostat (for multi-room control)
- `climate.office` - Office thermostat (for multi-room control)
- `climate.bathroom` - Bathroom thermostat (for multi-room control)

### Person/Presence Sensors (Optional)
- `person.user` - Your person entity for presence detection
- `binary_sensor.living_room_motion` - Motion sensor (for room occupancy)

### Weather (Optional)
- `weather.home` - Weather integration for outdoor temperature

### Energy (Optional for Eco Mode)
- `sensor.electricity_price` - Current electricity price
- `sensor.solar_power` - Solar panel production
- `input_boolean.eco_mode` - Toggle for eco mode (create this helper in Home Assistant)

## Creating Helpers in Home Assistant

### Eco Mode Toggle
1. Go to Settings > Devices & Services > Helpers
2. Click "Create Helper"
3. Choose "Toggle"
4. Name: "Eco Mode"
5. Entity ID: `input_boolean.eco_mode`

### Temperature Offset Slider (Optional)
1. Create Helper > Number
2. Name: "Temperature Offset"
3. Entity ID: `input_number.temp_offset`
4. Min: -3, Max: 3, Step: 0.5

## Customizing the Flows

### Changing Entity IDs

After importing flows, you'll need to update entity IDs to match your setup:

1. Open Node-RED editor
2. Double-click on nodes that reference entities
3. Update the entity IDs in:
   - **api-call-service** nodes (climate control)
   - **server-state-changed** nodes (presence, weather, prices)
   - **api-current-state** nodes (state checking)

### Adjusting Temperature Schedules

Edit the function nodes to customize temperatures:
- Morning temperature: Default 21°C
- Day temperature: Default 20°C
- Evening temperature: Default 22°C
- Night temperature: Default 18°C
- Away temperature: Default 16°C

### Modifying Time Schedules

Time triggers use cron format:
- `00 06 * * *` = 6:00 AM every day
- `00 17 * * 1-5` = 5:00 PM Monday-Friday
- `00 22 * * 0,6` = 10:00 PM on weekends

## Testing Your Setup

1. Deploy the flows in Node-RED
2. Check the debug panel for any errors
3. Manually trigger inject nodes to test schedules
4. Monitor temperature changes in Home Assistant
5. Verify automations in Node-RED logs

## Troubleshooting

### Flow doesn't trigger
- Verify entity IDs are correct
- Check Home Assistant connection in Node-RED
- Enable debug nodes to see data flow

### Temperature not changing
- Confirm your climate entities support `set_temperature` service
- Check if manual control is overriding automation
- Verify the thermostat is online and responding

### High electricity price not detected
- Ensure electricity price sensor is working
- Adjust price thresholds in eco-mode flow
- Check sensor units (€/kWh, c/kWh, etc.)

## Advanced Configuration

### Adding Multiple Thermostats

In call-service nodes, change:
```json
"entityId": ["climate.living_room"]
```
To:
```json
"entityId": ["climate.living_room", "climate.bedroom", "climate.office"]
```

### Creating Temperature Zones

Group rooms by usage pattern:
- **Active Zone**: Living room, kitchen (warm during active hours)
- **Sleep Zone**: Bedrooms (cooler most times, warm in morning)
- **Work Zone**: Office (warm during work hours only)
