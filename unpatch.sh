#!/usr/bin/env bash
set -euo pipefail

HERMES_DIR="$HOME/.hermes/hermes-agent"

if [ ! -d "$HERMES_DIR" ]; then
  echo "❌ Hermes directory not found: $HERMES_DIR"
  exit 1
fi

echo "🔨 Reverting patches via git checkout..."

cd "$HERMES_DIR"
for f in \
  tools/registry.py \
  model_tools.py \
  agent/prompt_builder.py \
  agent/system_prompt.py \
  agent/agent_init.py \
  agent/conversation_loop.py
do
  if git diff --quiet -- "$f" 2>/dev/null; then
    echo "   ⏭  $f (no changes)"
  else
    git checkout -- "$f"
    echo "   ✅ $f reverted"
  fi
done

# Remove new file (not tracked by Hermes git)
if [ -f "$HERMES_DIR/tools/tool_search.py" ]; then
  rm "$HERMES_DIR/tools/tool_search.py"
  echo "   🗑️  tools/tool_search.py removed"
fi

# Clean __pycache__
find "$HERMES_DIR" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

echo ""
echo "✅ Patches reverted."
echo ""
echo "📋 Remove tool_search config from ~/.hermes/config.yaml if desired."
