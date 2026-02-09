# MH1 Radiator - Configurable Schedule Deployment Guide

## What Changed?

✅ **Input datetime helpers configured:**
- `input_datetime.mh1_start_time` - Default: 22:00:00
- `input_datetime.mh1_end_time` - Default: 07:00:00

✅ **Node-RED flow updated:**
- Reads schedule from helpers instead of hardcoded values
- Supports overnight ranges (22:00-07:00)
- Shows actual schedule in error messages

✅ **Files committed to git:**
- Commit: `acf1b38`
- 4 files changed, 574 insertions

---

## Quick Deployment (3 Steps)

### Step 1: Restart Home Assistant
```
Settings → System → Restart
```
**Why:** Load new input_datetime helpers

### Step 2: Import Node-RED Flow
```
Node-RED UI → Import → Select file:
nodered/flows/temperature-radiator-control.json
→ Replace existing → Deploy
```
**Why:** Update MH1 control logic to read from helpers

### Step 3: Verify
```bash
# Check helpers available:
Settings → Devices & Services → Helpers → Search "MH1"

Should show:
✅ MH1 Heating Start Time = 22:00:00
✅ MH1 Heating End Time = 07:00:00
```

---

## How to Use

**Change schedule times:**
```
Settings → Devices & Services → Helpers
Click: "MH1 Heating Start Time"
Change: 21:00:00 (example)
Click: Save
```

**Schedule takes effect immediately** (on next temperature update)

---

## Current Status

- ✅ Configuration files updated
- ✅ Node-RED flows updated
- ✅ Changes committed to git
- ⏳ **Ready for deployment** → Restart HA + Import flow
- ⏳ **Test tonight at 22:00** → Verify MH1 turns ON

---

## Full Documentation

See: `MH1_CONFIGURABLE_SCHEDULE.md` for:
- Complete deployment steps
- Troubleshooting guide
- Schedule logic explanation
- Configuration summary
- Testing checklist

---

Created: 2025-01-XX
Commit: acf1b38
