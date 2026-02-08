# Installation Guide

## Step 1: Install Node-RED in Home Assistant

### Using Home Assistant OS or Supervised:

1. Navigate to **Settings** > **Add-ons** > **Add-on Store**
2. Search for "Node-RED"
3. Click on "Node-RED" by the Community Add-ons
4. Click **Install**
5. Once installed, toggle:
   - **Start on boot**
   - **Watchdog**
6. Click **Start**

### Configuration:

In the Node-RED add-on configuration tab, add:
```yaml
credential_secret: YOUR_SECRET_KEY_HERE
```

## Step 2: Install Node-RED Companion Integration

1. Go to **Settings** > **Devices & Services**
2. Click **+ Add Integration**
3. Search for "Node-RED"
4. Follow the setup wizard
5. This allows Node-RED to create entities in Home Assistant

## Step 3: Access Node-RED

1. Click **Open Web UI** from the Node-RED add-on page
   - Or navigate to: `http://homeassistant.local:1880`
2. The Node-RED editor should open

## Step 4: Install Required Nodes

The Home Assistant add-on should have `node-red-contrib-home-assistant-websocket` pre-installed. To verify:

1. Click the **hamburger menu** (☰) in top-right
2. Select **Manage palette**
3. Go to **Install** tab
4. Search for: `node-red-contrib-home-assistant-websocket`
5. If not installed, click **Install**

## Step 5: Import Flows

### Method 1: Import from File

1. In Node-RED editor, click hamburger menu (☰)
2. Select **Import**
3. Click **select a file to import**
4. Choose one of the flow JSON files from the `flows/` directory
5. Click **Import**
6. Click **Deploy** to activate

### Method 2: Import from Clipboard

1. Open a flow JSON file in a text editor
2. Copy all content (Cmd+A, Cmd+C)
3. In Node-RED, click hamburger menu (☰) > **Import**
4. Click **clipboard** tab
5. Paste the content
6. Click **Import**
7. Click **Deploy**

## Step 6: Configure Entity IDs

After importing, you must update entity IDs to match your setup:

1. **Find nodes with entity references:**
   - Double-click nodes labeled "Set Temperature", "Home Presence", etc.
   
2. **Update entity IDs:**
   - In **api-call-service** nodes: Update `entityId` field
   - In **server-state-changed** nodes: Update entity filter
   - In **api-current-state** nodes: Update entity_id field

3. **Common entities to update:**
   - `climate.living_room` → Your thermostat entity
   - `person.user` → Your person entity
   - `weather.home` → Your weather entity
   - `sensor.electricity_price` → Your price sensor (if available)

## Step 7: Create Required Helpers

### For Eco Mode flow:

1. Go to Home Assistant: **Settings** > **Devices & Services** > **Helpers**
2. Click **Create Helper** > **Toggle**
3. Name: "Eco Mode"
4. Entity ID: `input_boolean.eco_mode`
5. Click **Create**

## Step 8: Test the Flows

1. **Manual testing:**
   - In Node-RED, click the button on any **inject** node
   - Check the debug panel (bug icon on right sidebar)
   - Verify temperature changes in Home Assistant

2. **Check climate entity:**
   - Go to Home Assistant > **Developer Tools** > **States**
   - Find your climate entity
   - Verify the temperature is changing

3. **Monitor logs:**
   - Enable debug nodes in flows
   - Watch for errors in Node-RED debug panel

## Step 9: Deploy and Monitor

1. Click **Deploy** button (top-right)
2. Monitor the first automation cycles
3. Adjust temperatures and schedules as needed
4. Check Home Assistant history for temperature changes

## Recommended Flow Import Order

1. **basic-heating-schedule.json** - Start here to test basic functionality
2. **advanced-heating-automation.json** - Add presence and weather features
3. **room-temperature-control.json** - Enable multi-room control
4. **eco-mode.json** - Add energy optimization (requires price sensor)

## Verification Checklist

- [ ] Node-RED add-on installed and running
- [ ] Node-RED Companion integration configured
- [ ] Flows imported successfully
- [ ] Entity IDs updated to match your devices
- [ ] Required helpers created
- [ ] Test triggers executed successfully
- [ ] Temperature changes visible in Home Assistant
- [ ] Debug panel shows no errors

## Next Steps

- Review [CONFIGURATION.md](CONFIGURATION.md) for customization options
- Adjust temperature schedules for your preferences
- Add more rooms to multi-room control
- Set up eco mode if you have dynamic electricity pricing
- Create Home Assistant dashboard cards to control heating

## Backup Your Flows

Node-RED flows are automatically backed up with Home Assistant snapshots, but you can also:

1. Export flows: Hamburger menu > **Export** > Select flow > Copy
2. Save to file for version control
3. Commit to this Git repository for tracking changes
