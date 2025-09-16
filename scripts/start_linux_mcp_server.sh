#!/usr/bin/env bash

# Start the REAPER MCP Server on Linux
# - Ensures Python >= 3.10
# - Ensures .venv exists and deps installed
# - Exports REAPER_MCP_BRIDGE_DIR for Linux
# - Runs server.app with selected profile (default: dsl-production)

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="${SCRIPT_DIR%/scripts}"
cd "$REPO_DIR"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Starting REAPER MCP Server (Linux)${NC}"
echo "Repo: $REPO_DIR"

check_py() {
  local cmd="$1"
  "$cmd" - <<'PY'
import sys
major, minor = sys.version_info[:2]
sys.exit(0 if (major == 3 and minor >= 10) or (major > 3) else 1)
PY
}

PYTHON_CMD=""
for c in python3.12 python3.11 python3.10 python3; do
  if command -v "$c" >/dev/null 2>&1 && check_py "$c"; then PYTHON_CMD="$c"; break; fi
done

if [[ -z "$PYTHON_CMD" ]]; then
  echo -e "${RED}Python 3.10+ required but not found.${NC}" >&2
  exit 1
fi
echo -e "${GREEN}✓ Using Python:${NC} $($PYTHON_CMD --version)"

VENV_DIR="$REPO_DIR/.venv"

# Create or fix venv
if [[ -d "$VENV_DIR" ]]; then
  if [[ ! -x "$VENV_DIR/bin/python" ]]; then
    echo -e "${YELLOW}Existing .venv is invalid (no bin/python). Recreating...${NC}"
    rm -rf "$VENV_DIR"
    "$PYTHON_CMD" -m venv "$VENV_DIR"
  fi
else
  echo "Creating virtual environment in .venv"
  "$PYTHON_CMD" -m venv "$VENV_DIR"
fi

# Use venv's python and pip explicitly to avoid system pip (PEP 668) issues
VENV_PY="$VENV_DIR/bin/python"
VENV_PIP="$VENV_DIR/bin/python -m pip"

# Verify venv python works and has correct version; recreate if not
if ! "$VENV_PY" - <<'PY' >/dev/null 2>&1
import sys; print(sys.version)
PY
then
  echo -e "${YELLOW}Venv python appears broken. Recreating venv...${NC}"
  rm -rf "$VENV_DIR"
  "$PYTHON_CMD" -m venv "$VENV_DIR"
fi

# Bootstrap pip if needed
if ! $VENV_PY -m pip --version >/dev/null 2>&1; then
  $VENV_PY -m ensurepip --upgrade || true
fi

if ! $VENV_PY -c "import mcp" >/dev/null 2>&1; then
  echo -e "${YELLOW}Installing dependencies into venv...${NC}"
  $VENV_PIP install --upgrade pip
  # Install project in editable mode (pulls dependencies from pyproject)
  $VENV_PIP install -e .
else
  echo -e "${GREEN}Dependencies already present in venv${NC}"
fi

# Ensure Linux bridge dir
export REAPER_MCP_BRIDGE_DIR="$HOME/.config/REAPER/Scripts/mcp_bridge_data"
mkdir -p "$REAPER_MCP_BRIDGE_DIR"
echo -e "${GREEN}✓ Bridge dir:${NC} $REAPER_MCP_BRIDGE_DIR"

# Profile from arg or default
PROFILE="dsl-production"
if [[ $# -ge 2 && $1 == "--profile" ]]; then
  PROFILE="$2"; shift 2
elif [[ $# -ge 1 ]]; then
  PROFILE="$1"; shift 1
fi

echo -e "${GREEN}✓ Profile:${NC} $PROFILE"
echo
echo "Server starting… (Make sure the Lua bridge is running in REAPER)"
echo "============================================"

exec "$VENV_PY" -m server.app --profile "$PROFILE"
