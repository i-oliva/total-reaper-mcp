#!/usr/bin/env bash

# Install the MCP Lua bridge for REAPER on Linux
# Copies lua/mcp_bridge.lua into ~/.config/REAPER/Scripts as mcp_bridge_file_v2.lua

set -euo pipefail

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." &> /dev/null && pwd )"
cd "$REPO_DIR"

REAPER_SCRIPTS_DIR="$HOME/.config/REAPER/Scripts"
BRIDGE_FILE="lua/mcp_bridge.lua"
TARGET_NAME="mcp_bridge_file_v2.lua"

echo "Installing MCP Bridge to REAPER (Linux)"
echo "Repo:        $REPO_DIR"
echo "Bridge file: $BRIDGE_FILE"
echo "Target dir:  $REAPER_SCRIPTS_DIR"
echo "Target name: $TARGET_NAME"
echo

# Ensure bridge exists
if [[ ! -f "$BRIDGE_FILE" ]]; then
  echo "Error: Bridge file not found at $BRIDGE_FILE" >&2
  exit 1
fi

# Ensure Scripts dir exists
mkdir -p "$REAPER_SCRIPTS_DIR"

# Backup existing bridge if present
if [[ -f "$REAPER_SCRIPTS_DIR/$TARGET_NAME" ]]; then
  cp -f "$REAPER_SCRIPTS_DIR/$TARGET_NAME" "$REAPER_SCRIPTS_DIR/${TARGET_NAME}.backup"
  echo "Backed up existing bridge to ${TARGET_NAME}.backup"
fi

# Copy the bridge
cp -f "$BRIDGE_FILE" "$REAPER_SCRIPTS_DIR/$TARGET_NAME"

echo
echo "✓ Bridge installed to: $REAPER_SCRIPTS_DIR/$TARGET_NAME"
echo
echo "Next steps:"
echo "  1) Start REAPER"
echo "  2) Actions → Show action list → Load… → select $TARGET_NAME"
echo "  3) Run the action (keep it running)"
echo "  4) Start the MCP server: scripts/start_linux_mcp_server.sh"

