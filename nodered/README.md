# Node-RED Flows

This directory contains all Node-RED automation flows for power management and heating control.

## Directory Structure

```
nodered/
├── flows/          # JSON flow files
└── docs/           # Flow documentation
```

## Available Flows

### 🔥 Heating Automation

**1. price-based-optimizer.json** ⭐  
**Purpose:** Main price-based ILP temperature control  
**Features:**
- Reads Spot-hinta.fi ranking (1-24)
- Sets ILP temp based on rank:
  - Rank 1-6: Boost mode (24°C)
  - Rank 7-18: Normal mode (21°C)
  - Rank 19-24: Eco mode (19°C)
- Updates every hour at :01
- Uses correct input helpers: `tehostuslampo`, `normaalilampo_presence`, `lamponpudotus_presence`

**2. basic-heating-schedule.json**  
**Purpose:** Simple time-based heating schedule  
**Features:**
- Morning warmup (06:00-09:00)
- Evening comfort (17:00-22:00)
- Night setback (22:00-06:00)

**3. advanced-heating-automation.json**  
**Purpose:** Advanced heating with presence detection  
**Features:**
- Multiple room control
- Presence-based adjustments
- Holiday mode support

**4. room-temperature-control.json**  
**Purpose:** Individual room temperature management  
**Features:**
- Master bedroom, Tuomas room, Sara room
- Smart radiator valve control
- Target temperature tracking

**5. temperature-radiator-control.json**  
**Purpose:** Radiator valve automation  
**Features:**
- PWM control algorithm
- Thermal mass compensation
- Overshoot prevention

**6. eco-mode.json**  
**Purpose:** Energy-saving eco mode  
**Features:**
- Away mode activation
- Temperature setback
- Device power-down

### ⚡ Power Management

**7. priority-load-balancer.json**  
**Purpose:** Automatic load balancing  
**Features:**
- 3-phase power monitoring
- Device priority management
- Load shedding algorithm

**8. peak-power-limiter.json**  
**Purpose:** Peak power limiting (15 kW)  
**Features:**
- Real-time power monitoring
- Critical load protection
- Non-essential device shutdown

**9. phase-monitor-alerts.json**  
**Purpose:** Phase imbalance monitoring  
**Features:**
- Phase difference detection
- Balance optimization
- Alert notifications

## Import Instructions

### Method 1: Node-RED UI
1. Open Node-RED web interface
2. Click **Menu (☰)** → **Import**
3. Click **Select a file to import**
4. Navigate to `nodered/flows/`
5. Select flow file (e.g., `price-based-optimizer.json`)
6. Click **Import**
7. Position the imported nodes
8. Click **Deploy**

### Method 2: Copy to Node-RED Directory
```bash
# Copy all flows (overwrites existing)
scp nodered/flows/*.json root@homeassistant:/config/node-red/

# Restart Node-RED
# Settings → Server Controls → Node-RED: Restart
```

### Method 3: Clipboard Import
```bash
# Copy flow content to clipboard
cat nodered/flows/price-based-optimizer.json | pbcopy

# In Node-RED: Menu → Import → Clipboard → Paste → Import
```

## Configuration

### Required Home Assistant Entities

**Sensors:**
- `sensor.nordpool_kwh_fi_eur_4_10_0` - Nordpool price
- `sensor.shf_rank_now` - Spot-hinta.fi ranking (1-24)
- `sensor.shellyem3_channel_a_power` - Phase A power
- `sensor.shellyem3_channel_b_power` - Phase B power
- `sensor.shellyem3_channel_c_power` - Phase C power
- `sensor.current_power_consumption` - Total power
- `climate.mitsu_ilp` - ILP heat pump

**Input Numbers:**
- `input_number.tehostuslampo` - Boost temp (24°C)
- `input_number.normaalilampo_presence` - Normal temp (21°C)
- `input_number.lamponpudotus_presence` - Eco temp (19°C)

**Input Booleans:**
- `input_boolean.holiday_mode`
- `input_boolean.boost_mode`
- `input_boolean.manual_override`

### Global Variables

Node-RED stores variables in:
```
/config/node-red/.config.nodes.json
```

## Testing Flows

### Test Price-Based Optimizer
1. Check current rank: `sensor.shf_rank_now`
2. Trigger flow manually: Inject timestamp node
3. Verify ILP temp change: `climate.mitsu_ilp.temperature`
4. Check debug output in Node-RED sidebar

### Test Peak Power Limiter
1. Monitor total power: `sensor.current_power_consumption`
2. Simulate high load: Turn on multiple devices
3. Verify non-essential devices turn off when > 13.5 kW
4. Check notification sent to iPhone

## Troubleshooting

### Flow Not Triggering
- Check inject node schedule (cron)
- Verify HA connection: Configuration nodes → server
- Check flow is deployed (red deploy button = changes pending)

### Entity Not Found
- Verify entity exists in HA
- Check spelling in flow nodes
- Use HA MCP to query: `ha_get_states`

### ILP Not Changing Temperature
- Check `climate.mitsu_ilp` state
- Verify input helpers have values
- Check manual override is disabled
- Review Node-RED debug log

## Performance

- **CPU Usage:** < 5% per flow
- **Memory:** ~50 MB total for all flows
- **Update Frequency:**
  - Price optimizer: Every hour
  - Power monitor: Every 10 seconds
  - Room control: Every 5 minutes

## Related Documentation

- **Flow Details**: `nodered/docs/`
- **Entity Reference**: `../docs/configuration/ENTITY_REFERENCE.md`
- **Troubleshooting**: `../docs/troubleshooting/NODE_RED_ERRORS.md`

## Version History

- **v2.0.0** (2026-02-09): Updated price-based-optimizer with correct helpers
- **v1.0.0**: Initial Phase 2 implementation
