#!/usr/bin/env bash
# ============================================================
# Dual Pincer Plugin — Global Setup Script
# ============================================================
# This script symlinks the dual-pincer agents and command into
# OpenCode's global config so they're available in ANY project.
#
# Usage:
#   bash bin/global-setup.sh
#
# Or from the repo root:
#   ./bin/global-setup.sh
# ============================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OPENCODE_CONFIG="${HOME}/.config/opencode"

echo "🔧 Dual Pincer — Global Setup"
echo "=============================="
echo ""
echo "Repo:       ${REPO_DIR}"
echo "Config:     ${OPENCODE_CONFIG}"
echo ""

# --- 1. Create symlinks for agents ---
echo "📁 Setting up agents..."
mkdir -p "${OPENCODE_CONFIG}/agents"

for agent in dual-pincer-mediator dual-pincer-steelman dual-pincer-redteam; do
  src="${REPO_DIR}/.opencode/agents/${agent}.md"
  dst="${OPENCODE_CONFIG}/agents/${agent}.md"
  if [ -f "$src" ]; then
    ln -sf "$src" "$dst"
    echo "   ✅ ${agent}.md → ${dst}"
  else
    echo "   ⚠️  ${src} not found — skipping"
  fi
done

# --- 2. Create symlink for command ---
echo "📁 Setting up commands..."
mkdir -p "${OPENCODE_CONFIG}/commands"

src="${REPO_DIR}/.opencode/commands/dual-pincer.md"
dst="${OPENCODE_CONFIG}/commands/dual-pincer.md"
if [ -f "$src" ]; then
  ln -sf "$src" "$dst"
  echo "   ✅ dual-pincer.md → ${dst}"
else
  echo "   ⚠️  ${src} not found — skipping"
fi

# --- 3. Register plugin in global opencode.jsonc ---
PLUGIN_PATH="${REPO_DIR}/.opencode/plugins/dual-pincer-plugin.ts"
CONFIG_FILE="${OPENCODE_CONFIG}/opencode.jsonc"

if [ -f "$CONFIG_FILE" ]; then
  echo ""
  echo "📝 Checking global plugin registration..."

  # Check if the plugin is already registered
  if grep -q "dual-pincer-plugin.ts" "$CONFIG_FILE" 2>/dev/null; then
    echo "   ✅ Plugin already registered in ${CONFIG_FILE}"
  else
    echo "   ⚠️  You need to add the plugin to your global opencode.jsonc"
    echo ""
    echo "   Add this line to ${CONFIG_FILE}:"
    echo '   "plugin": ["'"${PLUGIN_PATH}"'"]'
    echo ""
  fi
else
  echo ""
  echo "📝 Creating global opencode.jsonc..."
  cat > "$CONFIG_FILE" << EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "plugin": ["${PLUGIN_PATH}"]
}
EOF
  echo "   ✅ Created ${CONFIG_FILE}"
fi

echo ""
echo "🎉 Dual Pincer is now available globally!"
echo ""
echo "   ▶  Open OpenCode in any project and run:"
echo "      /dual-pincer <your prompt>"
echo ""
echo "   ▶  The dp_analyze tool is also available to any agent."
echo ""
