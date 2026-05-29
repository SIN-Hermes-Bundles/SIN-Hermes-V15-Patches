#!/usr/bin/env bash
set -euo pipefail

HERMES_DIR="$HOME/.hermes/hermes-agent"
PATCH_DIR="$(cd "$(dirname "$0")" && pwd)/patches"

if [ ! -d "$HERMES_DIR" ]; then
  echo "❌ Hermes directory not found: $HERMES_DIR"
  exit 1
fi

echo "🔧 Applying SIN-Hermes-V15 patches..."
echo "   Target: $HERMES_DIR"

cp "$PATCH_DIR/tools/tool_search.py"   "$HERMES_DIR/tools/tool_search.py"
cp "$PATCH_DIR/tools/registry.py"      "$HERMES_DIR/tools/registry.py"
cp "$PATCH_DIR/model_tools.py"         "$HERMES_DIR/model_tools.py"
cp "$PATCH_DIR/agent/prompt_builder.py"     "$HERMES_DIR/agent/prompt_builder.py"
cp "$PATCH_DIR/agent/system_prompt.py"      "$HERMES_DIR/agent/system_prompt.py"
cp "$PATCH_DIR/agent/agent_init.py"         "$HERMES_DIR/agent/agent_init.py"
cp "$PATCH_DIR/agent/conversation_loop.py"  "$HERMES_DIR/agent/conversation_loop.py"
cp "$PATCH_DIR/hermes_cli/models.py"       "$HERMES_DIR/hermes_cli/models.py"

# Apply config.yaml patch
CONFIG_SRC="$(cd "$(dirname "$0")" && pwd)/config.yaml"
CONFIG_DST="$HOME/.hermes/config.yaml"
if [ -f "$CONFIG_SRC" ] && [ -f "$CONFIG_DST" ]; then
  echo "🔧 Patching tool_search config..."
  # Extract the tool_search section from the source and replace in dest
  python3 -c "
import yaml, sys
src = yaml.safe_load(open('$CONFIG_SRC'))
dst = yaml.safe_load(open('$CONFIG_DST'))
if 'tool_search' in src:
    dst['tool_search'] = src['tool_search']
    yaml.dump(dst, open('$CONFIG_DST', 'w'), default_flow_style=False, sort_keys=False)
    print('✅ tool_search config updated')
else:
    print('⚠️ No tool_search section in source config')
"
fi

# Clean __pycache__ to avoid stale bytecode
find "$HERMES_DIR" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

echo "✅ Patches applied. Clear __pycache__ manually if needed:"
echo "   find $HERMES_DIR -name __pycache__ -exec rm -rf {} +"
echo ""
echo "📋 Config updated: ~/.hermes/config.yaml"
