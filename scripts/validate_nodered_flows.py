#!/usr/bin/env python3
"""
Node-RED Flow Validator
Validates all Node-RED flows for common issues and entity references
"""

import json
import os
import re
from pathlib import Path

# Known entity mappings (already fixed)
ENTITY_FIXES = {
    'person.user': 'person.toni',
    'weather.home': 'weather.forecast_koti',
    'climate.living_room': 'climate.mitsu_ilp',
    'sensor.sahko_kokonaiskulutus_teho': 'sensor.total_power_consumption',
    'sensor.electricity_price': 'sensor.electricity_total_price_cents',
}

# Optional entities that may not exist (ok to have)
OPTIONAL_ENTITIES = [
    'sensor.solar_power',
    'sensor.garage_temperature',
    'switch.garage_heater',
    'notify.telegram',
]

# Valid entities confirmed in live Home Assistant
VALID_ENTITIES = [
    'person.toni',
    'person.konderi',
    'weather.forecast_koti',
    'climate.mitsu_ilp',
    'sensor.total_power_consumption',
    'sensor.electricity_total_price_cents',
    'sensor.nordpool_kwh_fi_eur_4_10_0',
    'switch.tesla_model_3_charger',
    'device_tracker.tesla_model_3_location_tracker',
    'number.tesla_model_3_charging_amps',
    'switch.shellypro4pm_ec62608b70e8_channel_2',  # Boiler
    'sensor.shellyem3_channel_a_power',
    'sensor.shellyem3_channel_b_power',
    'sensor.shellyem3_channel_c_power',
]

def find_entities_in_json(data, path=""):
    """Recursively find all entity_id references in JSON"""
    entities = []
    
    if isinstance(data, dict):
        for key, value in data.items():
            if key == 'entity_id' or key == 'entityidfilter':
                if isinstance(value, str):
                    entities.append((value, f"{path}.{key}"))
            else:
                entities.extend(find_entities_in_json(value, f"{path}.{key}"))
    elif isinstance(data, list):
        for i, item in enumerate(data):
            entities.extend(find_entities_in_json(item, f"{path}[{i}]"))
    elif isinstance(data, str):
        # Find entity IDs in code strings (func nodes)
        matches = re.findall(r'(?:entity_id|states)\[?["\']([a-z_]+\.[a-z0-9_]+)["\']', data)
        for match in matches:
            entities.append((match, path))
    
    return entities

def validate_flow_file(filepath):
    """Validate a single flow file"""
    print(f"\n{'='*70}")
    print(f"📄 Validating: {filepath.name}")
    print('='*70)
    
    with open(filepath, 'r') as f:
        data = json.load(f)
    
    # Find all entity references
    entities = find_entities_in_json(data)
    entity_set = set(ent for ent, _ in entities)
    
    issues = []
    warnings = []
    ok = []
    
    for entity in sorted(entity_set):
        if entity in ENTITY_FIXES.values():
            ok.append(f"✅ {entity} - Valid (fixed entity)")
        elif entity in VALID_ENTITIES:
            ok.append(f"✅ {entity} - Valid")
        elif entity in OPTIONAL_ENTITIES:
            warnings.append(f"ℹ️  {entity} - Optional (disable node if not used)")
        elif entity in ENTITY_FIXES.keys():
            issues.append(f"❌ {entity} - Should be {ENTITY_FIXES[entity]}")
        else:
            # Check if it looks like a valid entity pattern
            if re.match(r'^[a-z_]+\.[a-z0-9_]+$', entity):
                warnings.append(f"⚠️  {entity} - Not validated (may need checking)")
    
    # Print results
    if ok:
        print(f"\n✅ Valid Entities ({len(ok)}):")
        for msg in ok[:10]:  # Show first 10
            print(f"   {msg}")
        if len(ok) > 10:
            print(f"   ... and {len(ok) - 10} more valid entities")
    
    if warnings:
        print(f"\n⚠️  Warnings ({len(warnings)}):")
        for msg in warnings:
            print(f"   {msg}")
    
    if issues:
        print(f"\n❌ Issues Found ({len(issues)}):")
        for msg in issues:
            print(f"   {msg}")
        return False
    
    # Check for deprecation warnings in node names
    for item in data if isinstance(data, list) else [data]:
        if isinstance(item, dict) and 'name' in item:
            name = item['name']
            if '⚠️' in name or 'UPDATE' in name or 'PLACEHOLDER' in name:
                issues.append(f"❌ Node name has warning: '{name}'")
    
    if not issues:
        print(f"\n🎉 All checks passed!")
        return True
    else:
        return False

def main():
    flows_dir = Path(__file__).parent / 'power-management' / 'flows'
    
    if not flows_dir.exists():
        print(f"❌ Flows directory not found: {flows_dir}")
        return
    
    print("\n" + "="*70)
    print("🔍 Node-RED Flow Validator")
    print("="*70)
    print(f"📁 Scanning: {flows_dir}")
    
    flow_files = sorted(flows_dir.glob('*.json'))
    print(f"📊 Found {len(flow_files)} flow files")
    
    results = {}
    for filepath in flow_files:
        try:
            results[filepath.name] = validate_flow_file(filepath)
        except Exception as e:
            print(f"\n❌ Error validating {filepath.name}: {e}")
            results[filepath.name] = False
    
    # Summary
    print("\n" + "="*70)
    print("📊 VALIDATION SUMMARY")
    print("="*70)
    
    passed = sum(1 for v in results.values() if v)
    total = len(results)
    
    for filename, result in results.items():
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status} - {filename}")
    
    print(f"\n{'='*70}")
    print(f"Result: {passed}/{total} flows passed validation")
    print("="*70)
    
    if passed == total:
        print("\n🎉 All flows are ready for import!")
        print("\n📋 Next steps:")
        print("   1. Copy flow files to Home Assistant")
        print("   2. Import via Node-RED UI (Menu → Import)")
        print("   3. Deploy and test")
    else:
        print(f"\n⚠️  {total - passed} flow(s) need attention")
        print("   Run the fix script or manually update the entities")

if __name__ == '__main__':
    main()
