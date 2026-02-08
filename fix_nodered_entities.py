#!/usr/bin/env python3
"""
Fix Node-RED flows with actual entity IDs from Home Assistant
"""

import json
import sys
from pathlib import Path

# Entity mappings from validation
ENTITY_FIXES = {
    'person.user': 'person.toni',
    'weather.home': 'weather.forecast_koti',
    'climate.living_room': 'climate.mitsu_ilp',
    'sensor.sahko_kokonaiskulutus_teho': 'sensor.total_power_consumption',
}

def fix_flow_file(file_path):
    """Fix entity IDs in a Node-RED flow file"""
    print(f"\n📄 Processing: {file_path.name}")
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        changes = []
        
        # Replace each entity
        for old_entity, new_entity in ENTITY_FIXES.items():
            if old_entity in content:
                count = content.count(old_entity)
                content = content.replace(old_entity, new_entity)
                changes.append(f"   ✅ {old_entity} → {new_entity} ({count} occurrences)")
        
        # Remove warning messages from node names
        warning_patterns = [
            ' ⚠️ UPDATE person.user to your person entity',
            ' ⚠️ UPDATE weather.home',
            ' ⚠️ UPDATE to your climate entity',
            ' ⚠️ UPDATE climate.living_room',
            ' ⚠️ UPDATE sensor to your power meter',
            ' ⚠️ UPDATE sensor.solar_power',
        ]
        
        for pattern in warning_patterns:
            if pattern in content:
                content = content.replace(pattern, '')
                changes.append(f"   🧹 Removed warning: '{pattern}'")
        
        if content != original_content:
            # Validate JSON before saving
            try:
                json.loads(content)
            except json.JSONDecodeError as e:
                print(f"   ❌ JSON validation failed: {e}")
                return 0
            
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            
            print("\n".join(changes))
            print(f"   💾 Saved {len(changes)} changes")
            return len(changes)
        else:
            print("   ✓  No changes needed")
            return 0
    
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return 0

def main():
    """Fix all flow files"""
    print("=" * 70)
    print("🔧 Node-RED Entity ID Fixer")
    print("=" * 70)
    
    workspace_root = Path(__file__).parent
    flow_dir = workspace_root / "power-management" / "flows"
    
    if not flow_dir.exists():
        print(f"\n❌ Flow directory not found: {flow_dir}")
        return
    
    flow_files = list(flow_dir.glob("*.json"))
    print(f"\n📋 Found {len(flow_files)} flow files\n")
    
    total_changes = 0
    files_changed = 0
    
    for flow_file in flow_files:
        changes = fix_flow_file(flow_file)
        if changes > 0:
            total_changes += changes
            files_changed += 1
    
    print("\n" + "=" * 70)
    print(f"✅ Fixed {total_changes} entity references in {files_changed} files")
    print("=" * 70)
    
    if total_changes > 0:
        print("\n📝 Entity mappings applied:")
        for old, new in ENTITY_FIXES.items():
            print(f"   {old} → {new}")
        
        print("\n✅ All flows are now ready to import to Node-RED!")
    else:
        print("\n✓  All flows already have correct entity IDs")

if __name__ == "__main__":
    main()
