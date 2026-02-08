#!/usr/bin/env python3
"""
Comprehensive Node-RED Flow Fixer
Fixes:
1. Remove deprecated state_type properties
2. Update old electricity sensor names
3. Add comments for missing entities
4. Disable Telegram nodes (optional)
"""

import json
import sys
from pathlib import Path
from typing import Dict, List, Tuple

# Entity mapping: OLD → NEW
ENTITY_MAPPING = {
    'sensor.electricity_price': 'sensor.electricity_total_price_cents',
    'sensor.sahko_kokonaishinta_c': 'sensor.electricity_total_price_cents',
    'sensor.current_electricity_cost_rate': 'sensor.electricity_total_price_cents',
    'sensor.shf_electricity_full_price_charts': 'sensor.electricity_total_price_cents',
    'sensor.sahkon_myyntihinta_c_kwh': 'sensor.electricity_total_price_cents',
}

# Entities that need user configuration
PLACEHOLDER_ENTITIES = {
    'person.user': '⚠️ UPDATE: person.your_name',
    'weather.home': '⚠️ UPDATE: weather.your_integration',
    'climate.living_room': '⚠️ UPDATE: climate.your_thermostat',
    'sensor.sahko_kokonaiskulutus_teho': '⚠️ UPDATE: sensor.your_power_meter',
    'sensor.solar_power': '⚠️ UPDATE: sensor.your_solar (or disable)',
    'input_boolean.eco_mode': '⚠️ UPDATE: Check if this exists in HA',
    'binary_sensor.living_room_motion': '⚠️ UPDATE: binary_sensor.your_motion',
}

class NodeRedFlowFixer:
    def __init__(self):
        self.stats = {
            'state_type_removed': 0,
            'entities_updated': 0,
            'placeholders_added': 0,
            'telegram_disabled': 0,
            'nodes_processed': 0,
        }
    
    def fix_node(self, node: Dict) -> Tuple[bool, List[str]]:
        """Fix a single node, return (changed, messages)"""
        if not isinstance(node, dict):
            return False, []
        
        changed = False
        messages = []
        node_name = node.get('name', node.get('id', 'unknown'))
        self.stats['nodes_processed'] += 1
        
        # 1. Remove state_type (deprecated)
        if 'state_type' in node:
            old_value = node['state_type']
            del node['state_type']
            changed = True
            self.stats['state_type_removed'] += 1
            messages.append(f"   ✅ Removed state_type: '{old_value}' from '{node_name}'")
        
        # 2. Update entity IDs (deprecated sensors)
        if 'entityidfilter' in node:
            old_entity = node['entityidfilter']
            if old_entity in ENTITY_MAPPING:
                new_entity = ENTITY_MAPPING[old_entity]
                node['entityidfilter'] = new_entity
                changed = True
                self.stats['entities_updated'] += 1
                messages.append(f"   🔄 Updated entity: {old_entity} → {new_entity} in '{node_name}'")
            
            elif old_entity in PLACEHOLDER_ENTITIES:
                # Add warning comment in node name
                warning = PLACEHOLDER_ENTITIES[old_entity]
                if '⚠️' not in node.get('name', ''):
                    node['name'] = f"{node_name} - {warning}"
                    changed = True
                    self.stats['placeholders_added'] += 1
                    messages.append(f"   ⚠️  Added placeholder warning to '{node_name}'")
        
        # 3. Handle Telegram nodes (optional disable)
        if node.get('type') == 'api-call-service':
            domain = node.get('domain', '')
            service = node.get('service', '')
            if domain == 'notify' and service == 'telegram':
                # Add comment to node
                if '(DISABLED - No Telegram)' not in node.get('name', ''):
                    node['name'] = f"{node_name} (DISABLED - No Telegram)"
                    # Don't actually disable, just mark it
                    changed = True
                    self.stats['telegram_disabled'] += 1
                    messages.append(f"   📱 Marked Telegram node: '{node_name}'")
        
        return changed, messages
    
    def fix_flows(self, data: List[Dict]) -> Tuple[int, List[str]]:
        """Fix all nodes in flow data"""
        all_messages = []
        total_changes = 0
        
        for node in data:
            changed, messages = self.fix_node(node)
            if changed:
                total_changes += 1
                all_messages.extend(messages)
        
        return total_changes, all_messages
    
    def print_stats(self):
        """Print summary statistics"""
        print("\n" + "=" * 70)
        print("📊 SUMMARY")
        print("=" * 70)
        print(f"Nodes processed:        {self.stats['nodes_processed']}")
        print(f"state_type removed:     {self.stats['state_type_removed']}")
        print(f"Entities updated:       {self.stats['entities_updated']}")
        print(f"Placeholders added:     {self.stats['placeholders_added']}")
        print(f"Telegram nodes marked:  {self.stats['telegram_disabled']}")
        print("=" * 70)

def main():
    print("=" * 70)
    print("🔧 Comprehensive Node-RED Flow Fixer")
    print("=" * 70)
    
    # Get input file
    if len(sys.argv) < 2:
        print("\n❌ Error: No input file specified")
        print("\nUsage:")
        print("  python3 fix_nodered_flows_all.py <flow_file.json>")
        print("\nExample:")
        print("  python3 fix_nodered_flows_all.py my_flows_backup.json")
        print("\nTo export your flows:")
        print("  1. Open Node-RED")
        print("  2. Menu → Export → All flows")
        print("  3. Save as my_flows_backup.json")
        print("  4. Run this script on that file")
        sys.exit(1)
    
    input_file = Path(sys.argv[1])
    
    if not input_file.exists():
        print(f"\n❌ Error: File not found: {input_file}")
        sys.exit(1)
    
    output_file = input_file.parent / f"{input_file.stem}_FIXED.json"
    
    print(f"\n📄 Input:  {input_file}")
    print(f"📄 Output: {output_file}")
    
    # Load flows
    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)
    except json.JSONDecodeError as e:
        print(f"\n❌ JSON decode error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Error reading file: {e}")
        sys.exit(1)
    
    if not isinstance(data, list):
        print("\n❌ Error: Not a valid Node-RED flow file (expected array)")
        sys.exit(1)
    
    print(f"\n✅ Loaded {len(data)} nodes")
    
    # Fix flows
    fixer = NodeRedFlowFixer()
    print("\n🔨 Fixing flows...")
    total_changes, messages = fixer.fix_flows(data)
    
    # Print all messages
    if messages:
        print("\n📝 Changes made:\n")
        for msg in messages:
            print(msg)
    else:
        print("\n✓  No changes needed (flows already clean)")
    
    # Save fixed flows
    if total_changes > 0:
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"\n💾 Saved fixed flows to: {output_file}")
        except Exception as e:
            print(f"\n❌ Error saving file: {e}")
            sys.exit(1)
    
    # Print statistics
    fixer.print_stats()
    
    # Next steps
    if total_changes > 0:
        print("\n📝 NEXT STEPS:")
        print("=" * 70)
        print("1. Open the fixed file:")
        print(f"   {output_file}")
        print("\n2. Copy ALL contents (Cmd+A, Cmd+C)")
        print("\n3. In Node-RED:")
        print("   - Menu (☰) → Import")
        print("   - Paste the contents")
        print("   - Select: 'Replace existing flows'")
        print("   - Click 'Import'")
        print("\n4. Review nodes with ⚠️ warnings:")
        print("   - Update entity IDs to match your HA setup")
        print("   - Or disable nodes you don't use")
        print("\n5. Deploy the flows")
        print("\n6. Check Node-RED debug panel for errors")
        print("=" * 70)
    
    print("\n✅ Done!")

if __name__ == "__main__":
    main()
