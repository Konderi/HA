# Lovelace Dashboards

Professional power management dashboards for desktop and mobile.

## Available Dashboards

### 1. power-management-professional.yaml
**Target:** Desktop, tablets, large screens  
**Pages:** 5  
**Lines:** 1,380

**Pages:**
1. **📊 Monitor** (Home)
   - Real-time power consumption
   - 24-hour power chart
   - Phase distribution
   - Current costs
   - Price ranking

2. **🎛️ Control**
   - ILP climate control
   - Room temperature controls
   - Manual overrides
   - Boost mode
   - Holiday mode

3. **🔀 Flows**
   - Node-RED flow status
   - Automation states
   - Flow execution times
   - Debug information

4. **📈 Statistics**
   - Daily/weekly/monthly consumption
   - Cost analysis
   - Heating efficiency
   - Phase balance history
   - ApexCharts visualizations

5. **⚙️ Settings**
   - All input helpers (90+)
   - ILP temperature settings
   - Power thresholds
   - Timing parameters
   - System configuration

### 2. power-management-mobile.yaml
**Target:** Smartphones  
**Views:** 7  
**Lines:** 1,007

**Views:**
1. **🏠 Power Overview**
   - Current power (kW)
   - Today's consumption
   - Current price
   - Quick actions

2. **🌡️ Heating**
   - ILP current temp
   - Mode indicator
   - Room temperatures
   - Outdoor temp

3. **⚡ Energy**
   - Daily consumption
   - Weekly trends
   - Cost breakdown
   - Savings

4. **💰 Prices**
   - Current rank
   - Price chart (24h)
   - Cheapest hours
   - Most expensive hours

5. **🔌 Devices**
   - Tesla charging
   - Hot water boiler
   - Sauna heating
   - Other devices

6. **📊 Statistics**
   - Consumption history
   - Cost trends
   - Efficiency metrics

7. **⚙️ Settings**
   - ILP modes (Boost/Normal/Eco)
   - Quick toggles
   - Manual overrides
   - Essential settings

### 3. power-management-custom.yaml
**Target:** Custom/test dashboard  
**Purpose:** Experimental features

## Installation

### Method 1: File Copy
```bash
# Copy all dashboards
scp dashboards/*.yaml root@homeassistant:/config/dashboards/

# Restart Home Assistant
```

### Method 2: Manual Import
1. Open Home Assistant
2. Go to **Settings** → **Dashboards**
3. Click **Add Dashboard**
4. Choose **Start from scratch**
5. Click **⋮** → **Edit** → **Raw configuration editor**
6. Paste dashboard YAML content
7. Click **Save**

### Method 3: Via Dashboard Settings
1. Settings → Dashboards → **Add Dashboard**
2. Name: "Power Management Professional"
3. URL: `power-management-professional`
4. Icon: `mdi:lightning-bolt`
5. Sidebar visibility: **Show**
6. Admin only: **No**
7. Click **Add** → **Take Control** → Raw editor → Paste YAML

## Configuration

### Required Integrations
- **Nordpool** - Electricity pricing
- **Spot-hinta.fi** - Price ranking
- **ApexCharts** - Graphs and charts
- **Custom Button Card** (HACS) - Custom UI elements
- **Mushroom Cards** (HACS) - Modern card designs

### Required Entities
All entities must exist in Home Assistant:
- `sensor.nordpool_kwh_fi_eur_4_10_0`
- `sensor.shf_rank_now`
- `sensor.current_power_consumption`
- `climate.mitsu_ilp`
- `input_number.tehostuslampo`
- `input_number.normaalilampo_presence`
- `input_number.lamponpudotus_presence`
- Plus 90+ additional entities

### Theme Recommendations
- **Professional Dashboard**: HA default, iOS dark, Material themes
- **Mobile Dashboard**: Minimalist themes, high contrast

## Customization

### Changing ILP Settings Card
Edit lines 920-970 in `power-management-professional.yaml`:
```yaml
- type: entities
  title: ILP Climate Control
  entities:
    - input_number.tehostuslampo
    - input_number.normaalilampo_presence
    - input_number.lamponpudotus_presence
```

### Modifying ApexCharts
Edit chart configuration around line 200:
```yaml
type: custom:apexcharts-card
graph_span: 24h
span:
  start: day
series:
  - entity: sensor.current_power_consumption
    name: Power
    type: line
```

### Adding New Views (Mobile)
Add new view at end of file:
```yaml
  - title: My View
    path: my-view
    icon: mdi:home
    cards:
      - type: entities
        title: My Card
        entities:
          - sensor.my_sensor
```

## Screenshots

*Add screenshots to `dashboards/screenshots/` directory*

## Performance

- **Load Time:** < 2 seconds
- **Update Frequency:** 5-10 seconds
- **Cards:** 50+ per dashboard
- **Sensors:** 100+ monitored entities

## Troubleshooting

### Dashboard Not Showing
- Check YAML syntax: Use YAML validator
- Verify all entities exist
- Check browser console for errors
- Clear browser cache

### Missing Cards
- Install required custom integrations (ApexCharts, Button Card, Mushroom)
- Restart Home Assistant
- Hard refresh browser (Ctrl+F5)

### Entities Show "Unavailable"
- Verify entity exists: Developer Tools → States
- Check integration is loaded
- Restart integration
- Check configuration.yaml includes

### Mobile Dashboard Issues
- Use responsive view in HA
- Check viewport settings
- Test on actual mobile device
- Adjust card sizes if needed

## Updates

When updating dashboards:
1. Backup current dashboard YAML
2. Test changes in raw editor
3. Verify all entities still exist
4. Check mobile responsive view
5. Deploy to production

## Related Documentation

- **Configuration Guide**: `../docs/configuration/DASHBOARD_SETUP.md`
- **Entity Reference**: `../docs/configuration/ENTITY_REFERENCE.md`
- **Troubleshooting**: `../docs/troubleshooting/DASHBOARD_ERRORS.md`

## Version History

- **v2.0.0** (2026-02-09): Added Settings pages, ILP climate sections
- **v1.0.0**: Initial dashboards with monitoring and control
