#!/usr/bin/env python3
"""
Quick MCP client to exercise the DSL tools against REAPER.

Usage:
  - Ensure REAPER is running and the Lua bridge (mcp_bridge_file_v2.lua) is loaded.
  - Do NOT start scripts/start_linux_mcp_server.sh; this client will spawn the server.
  - python scripts/mcp_try_dsl.py
"""
import asyncio
import os
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client


REPO_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
BRIDGE_DIR = os.environ.get(
    'REAPER_MCP_BRIDGE_DIR',
    os.path.expanduser('~/.config/REAPER/Scripts/mcp_bridge_data')
)


async def main():
    server_params = StdioServerParameters(
        command=os.path.join(REPO_DIR, '.venv', 'bin', 'python'),
        args=["-m", "server.app", "--profile", "dsl-production"],
        env={"REAPER_MCP_BRIDGE_DIR": BRIDGE_DIR},
        cwd=REPO_DIR,
    )

    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()

            tools = await session.list_tools()
            print(f"Available tools: {len(tools.tools)}")

            # Create a bass track
            res = await session.call_tool("dsl_track_create", {"name": "Bass", "role": "bass"})
            print("dsl_track_create →", res.content[0].text)

            # Set volume to -6 dB
            res = await session.call_tool("dsl_track_volume", {"track": "bass", "volume": "-6dB"})
            print("dsl_track_volume →", res.content[0].text)

            # Create an 8-bar loop (MIDI)
            res = await session.call_tool("dsl_loop_create", {"track": "bass", "time": "8 bars", "midi": True})
            print("dsl_loop_create →", res.content[0].text)

            # Play
            res = await session.call_tool("dsl_play", {})
            print("dsl_play →", res.content[0].text)


if __name__ == "__main__":
    asyncio.run(main())

