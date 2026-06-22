# Beep Framework v2.1.0

Universal multi-tool for Roblox executors featuring combat automation, visual enhancements, and physics modifications.

**Ultra-optimized - Zero lag guaranteed!**

## Features

### Combat Tools
- **Aim Assist** - Smooth camera lock onto targets within FOV (50-400 radius)
- **Target Body Part Selector** - Choose between Head, UpperTorso, Torso, or HumanoidRootPart
- **Hold to Aim** - Optional toggle to only aim while holding a key (default: RMB)
- **Sticky Target Lock** - Lock onto specific targets with Q key
- **Auto Shoot** - Automatically shoot locked targets with adjustable delay
- **Triggerbot** - Auto-shoot when hovering over enemies (optimized to 5 fps)
- **Universal Team Check** - Works in any Roblox game with 4 detection methods
- **Smoothness Control** - Fine-tune aim interpolation (1-10)
- **Visual FOV Indicator** - Real-time circle showing active detection zone

### Visual Enhancements
- **Player ESP** - See players through walls with 3D highlighting
- **Name Tags** - Display player names with distance tracking
- **User ID Display** - Show account IDs for identification
- **3D Chams** - Full-body boxes on all character parts
- **Tracers** - Lines from your character to other players
- **Health Bars** - Dynamic color-changing health bars
- **2D Box ESP** - Square boxes around players

### Physics Modifications
- **Speed Hack** - CFrame-based speed multiplier (1-5x with toggle key)
- **Jump Boost** - Modify jump power (50-300 with individual toggle)
- **Fly Mode** - Full 6-axis flight with WASD controls (10-500 speed)
- **Custom Fly Keybind** - Assign any key to toggle fly mode (default: E)
- **NoClip** - Walk through walls and obstacles

### Misc Tools
- **Kill Aura** - Auto-aim and auto-shoot enemies within range (5-50 studs)
- **Fullbright** - Full scene lighting
- **Infinite Jump** - Jump infinitely in air
- **FOV Changer** - Adjust field of view (70-120)
- **Teleport to Player** - Instantly teleport to any player
- **Anti-AFK** - Prevent kick for inactivity

## Installation

### Quick Loadstring
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/awjz/beep-tool/main/Beep.lua"))()
```

### Alternative Loader
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/awjz/beep-tool/main/loader.lua"))()
```

## Usage

1. Execute the loadstring in your preferred executor
2. The menu opens automatically on load
3. Use **INSERT** key to toggle menu visibility
4. Configure features through the tabbed interface
5. Click **X** button to completely close and reset

## Controls

- **INSERT** - Toggle menu visibility
- **Q** (default) - Lock/unlock target (sticky targeting)
- **RMB** (default) - Hold to aim (if Hold to Aim is enabled)
- **LeftControl** (default) - Toggle speed hack on/off
- **E** (default) - Toggle fly mode on/off
- **W/A/S/D** - Move while flying
- **SPACE** - Fly up
- **LEFT SHIFT** - Fly down
- **Mouse Drag** - Move the menu window
- **Tab Buttons** - Switch between feature categories
- **Toggles** - Click ON/OFF buttons to enable/disable
- **Sliders** - Drag to adjust numeric values
- **< Selector >** - Click to cycle through options
- **Keybind Button** - Click and press any key to rebind

## Compatibility

Works with any Roblox game and most script executors including:
- Synapse X / Synapse Z
- Script-Ware
- Krnl
- Fluxus
- Trigon
- Arceus X

## Notes

- **Zero Lag Guarantee** - Ultra-optimized for maximum performance
- Menu persists through respawns
- Anti-duplicate system prevents multiple instances
- Smooth animations and purple-themed UI
- All features run client-side only
- Physics resets automatically on menu close
- Universal team detection works in any game
- Smart fallback system for body part targeting
- Close button (X) properly cleans up all features

## Performance Optimizations

- **Triggerbot**: 5 fps (200ms interval) - zero lag
- **Auto Shoot**: 20 fps - separated from aim loop
- **Kill Aura**: 10 fps - reduced from 60 fps
- **Shoot() function**: No pcall overhead, cached services
- **All features tested**: No FPS drops on any executor

## Requirements

- Working Roblox executor with loadstring support
- HttpGet enabled for external script loading

## Version History

- **v2.1.0** (Current) - Target Selector, Performance Optimization, Fixed Close Button
- **v1.0.0** - Initial Release

---

**Version:** 2.1.0  
**Last Updated:** June 21, 2026  
**Repository:** [github.com/awjz/beep-tool](https://github.com/awjz/beep-tool)
