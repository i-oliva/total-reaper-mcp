#!/usr/bin/env bash
# Setup script for Codex Web environment
# Ensures a usable Python interpreter and installs testing dependencies

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

PYTHON_VERSION="3.10.2"
PYTHON_BIN=""

if command -v pyenv >/dev/null 2>&1; then
  if ! pyenv versions --bare | grep -Fxq "$PYTHON_VERSION"; then
    if ! pyenv install -s "$PYTHON_VERSION"; then
      echo "[codex-setup] pyenv could not install $PYTHON_VERSION, falling back to system python" >&2
      pyenv local --unset 2>/dev/null || true
    fi
  fi

  if pyenv versions --bare | grep -Fxq "$PYTHON_VERSION"; then
    pyenv local "$PYTHON_VERSION"
    PYTHON_BIN="$(pyenv which python)"
  else
    pyenv local --unset 2>/dev/null || true
  fi
fi

if [[ -z "$PYTHON_BIN" ]]; then
  PYTHON_BIN="$(command -v python3 || true)"
fi

if [[ -z "$PYTHON_BIN" ]]; then
  echo "[codex-setup] python3 not found" >&2
  exit 1
fi

"$PYTHON_BIN" -m pip install --upgrade pip
"$PYTHON_BIN" -m pip install -e .
"$PYTHON_BIN" -m pip install pytest pytest-asyncio
