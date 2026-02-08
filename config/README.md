# Configuration Directory

This directory contains all Home Assistant configuration files organized by category.

## Directory Structure

```
config/
├── sensors/              # Sensor configurations
│   ├── electricity_pricing_sensors.yaml
│   ├── electricity_pricing_sensors_phase2.yaml
│   └── electricity_pricing_sensors_phase3.yaml
├── input_helpers/        # Input helpers (sliders, toggles, dates)
│   ├── input_booleans.yaml
│   ├── input_numbers.yaml
│   └── input_datetimes.yaml
├── automations/          # Automation configurations
│   └── notifications.yaml
└── notify/              # Notification service configs
    └── ios_notify.yaml
```

## Key Files

### Sensors
- **electricity_pricing_sensors.yaml**: Nordpool price sensors, rankings, and calculations
- Phase 2/3: Additional pricing sensors and templates

### Input Helpers
- **input_booleans.yaml**: Toggle switches for holiday mode, boost mode, manual overrides
- **input_numbers.yaml**: Sliders for temperatures, thresholds, timers (90+ helpers)
- **input_datetimes.yaml**: Date/time selectors for scheduling

### Automations
- **notifications.yaml**: 12+ iPhone notification automations

### Notify
- **ios_notify.yaml**: iPhone 17 notification service configuration

## ILP Climate Input Helpers

**Temperature Controls (Price-Based):**
- `input_number.tehostuslampo` - **Boost Mode** (24°C, Rank 1-6)
- `input_number.normaalilampo_presence` - **Normal Mode** (21°C, Rank 7-18)
- `input_number.lamponpudotus_presence` - **Eco Mode** (19°C, Rank 19-24)

**Additional Settings:**
- `input_number.yllapitolampo` - Maintenance temp
- `input_number.ilp_pyynti` - Manual request temp
- `input_number.ilp_max_rank_boost` - Max rank for boost mode
- `input_number.ulkolampo_trigger` - Outdoor temp heating trigger

## Usage

### Adding to configuration.yaml

```yaml
# Sensors
sensor: !include_dir_merge_list sensors/

# Input helpers
input_boolean: !include input_helpers/input_booleans.yaml
input_number: !include input_helpers/input_numbers.yaml
input_datetime: !include input_helpers/input_datetimes.yaml

# Automations
automation: !include_dir_merge_list automations/

# Notifications
notify: !include notify/ios_notify.yaml
```

### Deployment

```bash
# Copy all config files
scp config/**/*.yaml root@homeassistant:/config/

# Or selectively
scp config/sensors/*.yaml root@homeassistant:/config/sensors/
scp config/input_helpers/*.yaml root@homeassistant:/config/input_helpers/
scp config/automations/*.yaml root@homeassistant:/config/automations/
scp config/notify/*.yaml root@homeassistant:/config/notify/
```

## Validation

Use the Python validation script:

```bash
python3 scripts/validate_config.py
```

## Notes

- All entity IDs validated against live Home Assistant instance
- Input numbers have proper ranges and icons
- Notification automations require iPhone Companion App
- Price-based helpers use Spot-hinta.fi ranking (1-24)

## Related Documentation

- **Deployment Guide**: `../docs/deployment/QUICK_DEPLOY.md`
- **Configuration Guide**: `../docs/configuration/INPUT_HELPERS.md`
- **Troubleshooting**: `../docs/troubleshooting/ENTITY_NOT_FOUND.md`
