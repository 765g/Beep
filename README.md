# Beep Framework

Universal multi-tool for Roblox executors featuring combat automation, visual enhancements, and physics modifications.

## Features

### Combat Tools
- **Aim Assist** - Smooth camera lock onto targets within FOV
- **Configurable FOV** - Adjustable detection radius (50-400 units)
- **Smoothness Control** - Fine-tune aim interpolation
- **Visual FOV Indicator** - Real-time circle showing active detection zone

### Visual Enhancements
- **Player ESP** - See players through walls with 3D highlighting
- **Name Tags** - Display player names with distance tracking
- **User ID Display** - Show account IDs for identification
- **3D Chams** - Full-body boxes on all character parts

### Physics Modifications
- **Speed Control** - Adjust walk speed (16-150)
- **Jump Enhancement** - Modify jump power (50-200)
- **NoClip** - Walk through walls and obstacles

## Installation

### Quick Loadstring
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/awjz/beep/main/Beep.lua"))()
```

### Alternative Loader
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/awjz/beep/main/loader.lua"))()
```

## Usage

1. Execute the loadstring in your preferred executor
2. The menu opens automatically on load
3. Use **INSERT** key to toggle menu visibility
4. Configure features through the tabbed interface
5. Click **X** button to completely close and reset

## Controls

- **INSERT** - Toggle menu visibility
- **Mouse Drag** - Move the menu window
- **Tab Buttons** - Switch between feature categories
- **Toggles** - Click ON/OFF buttons to enable/disable
- **Sliders** - Drag to adjust numeric values

## Compatibility

Works with any Roblox game and most script executors including:
- Synapse X / Synapse Z
- Script-Ware
- Krnl
- Fluxus
- Trigon
- Arceus X

## Notes

- Menu persists through respawns
- Anti-duplicate system prevents multiple instances
- Smooth animations and purple-themed UI
- All features run client-side only
- Physics resets automatically on menu close

## Requirements

- Working Roblox executor with loadstring support
- HttpGet enabled for external script loading

---

**Version:** 1.0  
**Last Updated:** 2026
