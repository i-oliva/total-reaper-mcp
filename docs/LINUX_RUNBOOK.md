Linux Runbook: REAPER MCP Server

This guide covers Linux-only setup and testing. It uses the file bridge between REAPER and the Python MCP server.

Prerequisites
- REAPER installed and running
- Python 3.10+ (python3, python or pyenv work)

1) Install the Lua bridge into REAPER
```
./scripts/install_bridge_linux.sh
```
Expected output excerpt:
```
Installing MCP Bridge to REAPER (Linux)
Repo:        /home/<user>/total-reaper-mcp
Bridge file: lua/mcp_bridge.lua
Target dir:  /home/<user>/.config/REAPER/Scripts
Target name: mcp_bridge_file_v2.lua

Backed up existing bridge to mcp_bridge_file_v2.lua.backup

✓ Bridge installed to: /home/<user>/.config/REAPER/Scripts/mcp_bridge_file_v2.lua

Next steps:
  1) Start REAPER
  2) Actions → Show action list → Load… → select mcp_bridge_file_v2.lua
  3) Run the action (keep it running)
  4) Start the MCP server: scripts/start_linux_mcp_server.sh
```

2) Export the bridge directory for Linux
Do not wrap lines; use a single-line export:
```
export REAPER_MCP_BRIDGE_DIR="$HOME/.config/REAPER/Scripts/mcp_bridge_data"
```

3) Create a virtual environment and install
If python3.10 is unavailable, use python3 or python.
```
python -m venv .venv && source .venv/bin/activate
pip install -e .
```

4) Sanity check the bridge
```
python scripts/test_bridge_connection.py
```
Expected output excerpt:
```
Testing bridge connection...
✓ CountTracks: {'ret': 0, 'ok': True}
✓ GetAllTracksInfo: Found 0 tracks
✓ GetCursorPosition: {'ret': 0.0, 'ok': True}
```

5) Run tests against a live REAPER + bridge
The tests spawn the server process for you. Use the full profile so all required tools are available.
```
MCP_TEST_PROFILE=full pytest tests/test_core_api_functions.py -v -s
```
Tips:
- If you see "Unknown tool: <name>", you’re likely running with a restricted profile. Use `MCP_TEST_PROFILE=full`.
- If the server log shows a macOS path for the bridge on Linux, update your shell with the export in step 2 and re-run.

Stability tips
- Avoid mixing direct bridge calls (`from server.bridge import bridge; await bridge.call_lua(...)`) with MCP client calls in the same test run; they share the bridge directory. Prefer `reaper_mcp_client.call_tool(...)` everywhere. If you must call the bridge directly, run those tests separately.
- You can increase the bridge response timeout if your system is busy:
  `export REAPER_MCP_TIMEOUT_SEC=15`
- If a test times out, confirm the REAPER console is printing “Processing request …” and “Sending response …”. If not, reload the Lua script and re-run the test.

6) Optional: start the server manually (Linux)
If you want to run the MCP server outside of pytest:
```
./scripts/start_linux_mcp_server.sh --profile full
```
Keep the server running, then connect clients or tools to it as needed.
