#!/usr/bin/env python3
"""
Fix Node-RED state_type deprecation warnings
Removes all "state_type" properties from server-state-changed nodes
"""

import json
import os
from pathlib import Path

def fix_state_type_in_file(file_path):
    """Remove state_type from a Node-RED flow JSON file"""
    print(f"\n📄 Processing: {file_path.name}")
    
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        
        if not isinstance(data, list):
            print(f"   ⚠️  Not a valid Node-RED flow file (not an array)")
            return 0
        
        changes = 0
        for node in data:
            if not isinstance(node, dict):
                continue
            
            # Check if node has state_type (deprecated property)
            if 'state_type' in node:
                node_name = node.get('name', node.get('id', 'unknown'))
                node_type = node.get('type', 'unknown')
                old_value = node['state_type']
                
                # Remove the deprecated property
                del node['state_type']
                changes += 1
                print(f"   ✅ Removed state_type: '{old_value}' from '{node_name}' ({node_type})")
        
        if changes > 0:
            # Write back to file with proper formatting
            with open(file_path, 'w', encoding='utf-8') as f:
                json.dump(data, f, indent=2, ensure_ascii=False)
            print(f"   💾 Saved {changes} changes to {file_path.name}")
        else:
            print(f"   ✓  No state_type found (already clean)")
        
        return changes
    
    except json.JSONDecodeError as e:
        print(f"   ❌ JSON decode error: {e}")
        return 0
    except Exception as e:
        print(f"   ❌ Error: {e}")
        return 0

def main():
    """Find and fix all Node-RED flow JSON files"""
    print("=" * 60)
    print("🔧 Node-RED state_type Deprecation Fix")
    print("=" * 60)
    
    # Get the workspace root directory
    workspace_root = Path(__file__).parent
    print(f"\n📁 Workspace: {workspace_root}")
    
    # Find all JSON files in the workspace
    json_files = list(workspace_root.rglob("*.json"))
    flow_files = [f for f in json_files if 'flows' in str(f) or 'node-red' in str(f).lower()]
    
    if not flow_files:
        print("\n⚠️  No Node-RED flow files found!")
        print("   Looking for files in directories containing 'flows' or 'node-red'")
        print(f"\n   All JSON files found ({len(json_files)}):")
        for f in json_files[:10]:  # Show first 10
            print(f"   - {f.relative_to(workspace_root)}")
        if len(json_files) > 10:
            print(f"   ... and {len(json_files) - 10} more")
        return
    
    print(f"\n📋 Found {len(flow_files)} flow file(s):\n")
    for f in flow_files:
        print(f"   - {f.relative_to(workspace_root)}")
    
    # Process each file
    total_changes = 0
    for flow_file in flow_files:
        changes = fix_state_type_in_file(flow_file)
        total_changes += changes
    
    # Summary
    print("\n" + "=" * 60)
    if total_changes > 0:
        print(f"✅ SUCCESS! Fixed {total_changes} state_type deprecation(s)")
        print("\n📝 Next steps:")
        print("   1. Import the fixed flows to Node-RED:")
        print("      - Open Node-RED editor")
        print("      - Menu → Import → Select file")
        print("      - Choose 'Replace existing flows'")
        print("      - Deploy")
        print("\n   2. Restart Node-RED (or just Deploy)")
        print("\n   3. Check for errors in Node-RED debug panel")
    else:
        print("✓  All flows are already clean (no state_type found)")
    print("=" * 60)

if __name__ == "__main__":
    main()
