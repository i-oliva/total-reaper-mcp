# Outstanding API Events by Priority

This document aggregates the unchecked entries from `IMPLEMENTATION_MASTER.md`, removes anything already wired up in the Python tool layer, and then sorts the remaining gaps by the practical impact they have on the REAPER MCP server. Use it as the staging queue when adding new coverage.

## Snapshot
- High priority work unlocks core server capabilities still missing from automation, media state inspection, and FX parameter control.
- Medium priority items focus on surface synchronization and low-level state helpers that become valuable once the core gaps are closed.
- Low priority items are either convenience string utilities or require the optional SWS extension (409 functions), making them better suited for a dedicated follow-up cycle.

| Priority | Scope | Outstanding |
| --- | --- | --- |
| High | Core API, audio/media/MIDI state, FX parameter & preset control | 58 functions |
| Medium | Control-surface event mirroring, plugin/object plumbing | 53 functions |
| Low | String & GUID helpers, SWS/BR extension surface | 427 functions |

> Counts are derived by diffing the unchecked records in `IMPLEMENTATION_MASTER.md` against every `bridge.call_lua(...)` usage in the codebase (tools, DSL, tests).

## High Priority

### Core engine & session control
- `APITest` — Test API functionality
- `GetLastTouchedFX` — Get last touched FX
- `GetMasterMuteSoloFlags` — Get master mute/solo flags
- `PreventUIRefresh` — Prevent UI refresh temporarily
- `ReaScriptError` — Generate ReaScript error

### Audio, media, and MIDI state access
- `Audio_Init` — Initialize audio system
- `Audio_Quit` — Quit audio system
- `GetAudioAccessorHash` — Get audio accessor hash
- `GetSetItemState` — Get/set item state
- `GetSetItemState2` — Get/set item state v2
- `MIDI_GetHash` — Get MIDI hash
- `MIDI_GetTrackHash` — Get track MIDI hash
- `MIDI_InsertEvt` — Insert MIDI event
- `MIDI_SetEvt` — Set MIDI event

### FX parameter & preset control
- `FxGetPresetName` — Get FX preset name
- `GetFocusedFX` — Get focused FX
- `GetFocusedFX2` — Get focused FX v2
- `GetLastTouchedFX` — Get last touched FX
- `TakeFX_EndParamEdit` — End take FX param edit
- `TakeFX_FormatParamValue` — Format take FX param value
- `TakeFX_FormatParamValueNormalized` — Format normalized param value
- `TakeFX_GetChainVisible` — Get take FX chain visibility
- `TakeFX_GetEnvelope` — Get take FX envelope
- `TakeFX_GetFXGUID` — Get take FX GUID
- `TakeFX_GetIOSize` — Get take FX IO size
- `TakeFX_GetNamedConfigParm` — Get take FX named config param
- `TakeFX_GetOffline` — Get take FX offline state
- `TakeFX_GetOpen` — Get take FX open state
- `TakeFX_GetParameterStepSizes` — Get take FX parameter step sizes
- `TakeFX_GetParamEx` — Get take FX parameter extended
- `TakeFX_GetParamFromIdent` — Get take FX param from identifier
- `TakeFX_GetParamIdent` — Get take FX param identifier
- `TakeFX_GetPinMappings` — Get take FX pin mappings
- `TakeFX_GetPresetIndex` — Get take FX preset index
- `TakeFX_GetUserPresetFilename` — Get take FX user preset filename
- `TakeFX_NavigatePresets` — Navigate take FX presets
- `TakeFX_SetNamedConfigParm` — Set take FX named config param
- `TakeFX_SetOffline` — Set take FX offline
- `TakeFX_SetOpen` — Set take FX open
- `TakeFX_SetPinMappings` — Set take FX pin mappings
- `TakeFX_SetPresetByIndex` — Set take FX preset by index
- `TakeFX_Show` — Show take FX window
- `TrackFX_EndParamEdit` — End track FX param edit
- `TrackFX_GetEQ` — Get track EQ
- `TrackFX_GetEQBandEnabled` — Get EQ band enabled
- `TrackFX_GetEQParam` — Get EQ parameter
- `TrackFX_GetFloatingWindow` — Get floating FX window
- `TrackFX_GetNamedConfigParm` — Get track FX named config param
- `TrackFX_GetParameterStepSizes` — Get track FX parameter step sizes
- `TrackFX_GetParamEx` — Get track FX parameter extended
- `TrackFX_GetParamFromIdent` — Get track FX param from identifier
- `TrackFX_GetParamIdent` — Get track FX param identifier
- `TrackFX_GetPinMappings` — Get track FX pin mappings
- `TrackFX_GetUserPresetFilename` — Get track FX user preset filename
- `TrackFX_SetEQBandEnabled` — Set EQ band enabled
- `TrackFX_SetEQParam` — Set EQ parameter
- `TrackFX_SetNamedConfigParm` — Set track FX named config param
- `TrackFX_SetPinMappings` — Set track FX pin mappings

## Medium Priority

### Control-surface event mirroring
- `CSurf_GetTouchState` — Get touch state
- `CSurf_GoEnd` — Go to end
- `CSurf_GoStart` — Go to start
- `CSurf_OnArrow` — Handle arrow key
- `CSurf_OnFwd` — Handle forward
- `CSurf_OnFXChange` — Handle FX change
- `CSurf_OnInputMonitorChange` — Handle input monitor change
- `CSurf_OnInputMonitorChangeEx` — Handle input monitor change extended
- `CSurf_OnMuteChange` — Handle mute change
- `CSurf_OnMuteChangeEx` — Handle mute change extended
- `CSurf_OnPanChange` — Handle pan change
- `CSurf_OnPanChangeEx` — Handle pan change extended
- `CSurf_OnPlayRateChange` — Handle play rate change
- `CSurf_OnRecArmChange` — Handle record arm change
- `CSurf_OnRecArmChangeEx` — Handle record arm change extended
- `CSurf_OnRecvPanChange` — Handle receive pan change
- `CSurf_OnRecvVolumeChange` — Handle receive volume change
- `CSurf_OnRew` — Handle rewind
- `CSurf_OnRewFwd` — Handle rewind/forward
- `CSurf_OnScroll` — Handle scroll
- `CSurf_OnSelectedChange` — Handle selection change
- `CSurf_OnSendPanChange` — Handle send pan change
- `CSurf_OnSendVolumeChange` — Handle send volume change
- `CSurf_OnSoloChange` — Handle solo change
- `CSurf_OnSoloChangeEx` — Handle solo change extended
- `CSurf_OnTempoChange` — Handle tempo change
- `CSurf_OnTrackSelection` — Handle track selection
- `CSurf_OnVolumeChange` — Handle volume change
- `CSurf_OnVolumeChangeEx` — Handle volume change extended
- `CSurf_OnWidthChange` — Handle width change
- `CSurf_OnWidthChangeEx` — Handle width change extended
- `CSurf_OnZoom` — Handle zoom
- `CSurf_ResetAllCachedVolPanStates` — Reset cached vol/pan states
- `CSurf_ScrubAmt` — Scrub amount
- `CSurf_SetAutoMode` — Set automation mode
- `CSurf_SetPlayState` — Set play state (partial impl exists)
- `CSurf_SetRepeatState` — Set repeat state (partial impl exists)
- `CSurf_SetSurfaceMute` — Set surface mute
- `CSurf_SetSurfacePan` — Set surface pan
- `CSurf_SetSurfaceRecArm` — Set surface record arm
- `CSurf_SetSurfaceSelected` — Set surface selected
- `CSurf_SetSurfaceSolo` — Set surface solo
- `CSurf_SetSurfaceVolume` — Set surface volume
- `CSurf_SetTrackListChange` — Set track list change

### Plugin/object plumbing
- `get_config_var_string` — Get config variable string
- `get_midi_config_var` — Get MIDI config variable
- `GetSetObjectState` — Get/set object state
- `GetSetObjectState2` — Get/set object state v2
- `ValidatePtr2` — Validate pointer v2
- `plugin_getapi` — Get plugin API
- `plugin_getFilterList` — Get plugin filter list
- `plugin_getImportableProjectFilterList` — Get importable project filter list
- `plugin_register` — Register plugin

## Low Priority

### String, GUID, and time formatting helpers
- `WDL_FastString` — Fast string operations
- `WDL_String` — String operations
- `format_timestr` — Format time string
- `format_timestr_len` — Format time string with length
- `format_timestr_pos` — Format time string position
- `parse_timestr` — Parse time string
- `parse_timestr_len` — Parse time string with length
- `parse_timestr_pos` — Parse time string position
- `mkpanstr` — Make pan string
- `mkvolpanstr` — Make volume/pan string
- `mkvolstr` — Make volume string
- `parsepanstr` — Parse pan string
- `guidToString` — GUID to string
- `stringToGuid` — String to GUID
- `genGuid` — Generate GUID
- `relative_fn` — Relative filename
- `resolve_fn` — Resolve filename
- `resolve_fn2` — Resolve filename v2

### SWS/BR extension backlog
- 409 SWS extension (`BR_*`) functions remain outstanding. They span envelope allocation, mouse context queries, take/track GUID helpers, Win32 window utilities, and numerous UI helpers. Implement these only after confirming SWS is a hard dependency for the target deployment. The authoritative list (with descriptions) stays in `IMPLEMENTATION_MASTER.md` under **File I/O and Preferences**.

## Coding Agent Prompt

Use the template below when handing a group to the coding agent. Replace `<GROUP_NAME>` with one of the priority blocks above and prune the function bullets to only the ones you expect them to tackle in that pass.

```
You are working in /home/i-oliva/total-reaper-mcp.
Goal: implement the remaining REAPER bridge coverage for <GROUP_NAME> (see outstanding_api_events.md).

Context you must keep in mind:
- Python tools live in server/tools/. Each API method gets a coroutine that calls bridge.call_lua("<Function>", ...).
- Lua dispatch lives in lua/mcp_bridge.lua (search for the existing elseif fname == "..." blocks). Mirror the Python signature.
- Tests are under tests/ and rely on pytest + the async bridge fixtures. Add or extend coverage before exiting.
- After wiring the Lua and Python pieces, update IMPLEMENTATION_MASTER.md and outstanding_api_events.md to reflect the new status.
- Run pytest (or the targeted test module) to confirm nothing regressed.

Tasks:
1. Implement Lua bindings for the listed functions in <GROUP_NAME>.
2. Expose matching Python tool functions (or enhance existing modules) with clear docstrings.
3. Extend or add pytest coverage validating success + failure paths.
4. Update documentation: IMPLEMENTATION_MASTER.md checkboxes and outstanding_api_events.md counts.
5. Provide a brief summary of changes (files touched, tests run) when you finish.

Keep error handling consistent with existing tools, and reuse helper utilities where possible.
```
