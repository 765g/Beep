# Beep Framework - Changelog

## Version 2.2.0 (2026-06-21)

### ✨ New Features
- **Watermark** - Displays FPS, Ping, and Time (toggleable in Misc tab)
- **Theme Changer** - 6 color themes: Purple, Red, Blue, Green, Yellow, Pink
- **Remove Fog** - Toggle to remove all fog from the map
- **Bunny Hop** - Auto-jump when holding space for continuous hopping
- **Click Teleport** - Hold CTRL + Click to teleport to mouse position
- **Distance ESP** - Shows distance in meters (always visible with names)

### 🔧 Improvements
- **Auto Shoot Fixed** - Now uses 3 methods (Tool:Activate, VirtualInputManager, VirtualUser)
- **Triggerbot Fixed** - Properly releases mouse button after shooting
- **Better Shoot() Function** - Includes both Button1Down and Button1Up
- **Config Expanded** - Added settings for all new features
- **UI Organization** - Better organized tabs with new toggles

### 🐛 Bug Fixes
- Fixed Auto Shoot not working at all
- Fixed Triggerbot not releasing mouse button
- Fixed Watermark visibility toggle
- Fixed Theme Changer not updating all UI elements

### 📦 Features Added to Config
- `Config.Misc.Watermark` - Toggle watermark display
- `Config.Misc.RemoveFog` - Toggle fog removal
- `Config.Misc.ThemeColor` - Current theme selection (1-6)
- `Config.Physics.BunnyHop` - Toggle bunny hop
- `Config.Physics.ClickTP` - Toggle click teleport
- `Config.Physics.ClickTPKey` - Keybind for click teleport
- `Config.Visuals.Distance` - Show distance in ESP

### 🎨 UI Improvements
- Watermark shows: Version, FPS, Ping, Time
- Theme buttons in Misc tab (6 colors available)
- All new toggles properly integrated
- Better color consistency across themes

---

## Version 2.1.0 (2026-06-21)

### ✨ New Features
- **Target Body Part Selector** - Simple button to cycle between Head, UpperTorso, Torso, and HumanoidRootPart
- **Hold to Aim** - Optional toggle to only aim while holding a key (default: RMB)
- **Auto Shoot (Locked Target)** - Automatically shoot at locked targets
- **Triggerbot** - Auto-shoot when cursor is over enemy
- **Universal Team Detection** - Works in any Roblox game with 4 detection methods
- **Kill Aura** - Auto-aim and auto-shoot enemies within range
- **Tracers** - Lines from player to enemies
- **Health Bars** - Dynamic color-changing health bars
- **2D Box ESP** - Square boxes around players
- **Fullbright** - Full lighting
- **Infinite Jump** - Jump infinitely in air
- **FOV Changer** - Adjust field of view (70-120)
- **Teleport to Player** - Teleport to any player via dropdown
- **Anti-AFK** - Prevent kick for inactivity

### 🔧 Improvements
- **Ultra-Optimized Shooting** - Reduced lag to zero on all auto-shoot features
- **Triggerbot optimized** - Runs at 5 fps (200ms interval) for zero lag
- **Auto Shoot optimized** - Separated from aim loop, runs at 20 fps
- **Kill Aura optimized** - Moved to task.spawn at 10 fps instead of 60 fps
- **Improved Close Button (X)** - Now properly disables all features and cleans up everything
- **Simple Target Selector** - Replaced complex dropdown with simple cycle button
- **Smart Fallback System** - Automatically finds alternative body parts if selected one doesn't exist

### 🐛 Bug Fixes
- Fixed Jump Boost defaulting to enabled on game join
- Fixed ESP showing "Label" text when disabled
- Fixed close button not properly disabling fly mode
- Fixed FOV circle only visible when menu open
- Fixed WalkSpeed not working (replaced with CFrame speed hack)
- Fixed Tracers not rendering (Drawing API implementation)
- Fixed Infinite Jump not working (changed to InputBegan)
- Fixed Auto Shoot causing severe lag
- Fixed Triggerbot causing FPS drops
- Fixed close button not cleaning up all ESP objects

### 🎮 Controls
- **INSERT** - Toggle menu visibility
- **Q** - Lock/unlock target (sticky targeting)
- **RMB** - Hold to aim (if Hold to Aim enabled)
- **LeftControl** - Toggle speed hack
- **E** - Toggle fly mode
- **W/A/S/D** - Fly movement
- **SPACE** - Fly up
- **LEFT SHIFT** - Fly down

### 📦 Features List
**Combat:**
- Aim Assist with customizable FOV (50-400)
- Target Body Part selector (Head/UpperTorso/Torso/HumanoidRootPart)
- Hold to Aim toggle
- Sticky Target Locking (Q key)
- Auto Shoot for locked targets
- Triggerbot
- Team Check (Combat & Kill Aura separately)
- Smoothness control (1-10)
- FOV Circle indicator

**Visuals:**
- Name ESP with distance
- Player ID display
- 3D Chams/Boxes
- Tracers
- Health Bars
- 2D Box ESP

**Physics:**
- Speed Hack (1-5x multiplier with toggle key)
- Jump Boost (50-300 power with individual toggle)
- NoClip
- Fly Mode (10-500 speed with custom keybind)

**Misc:**
- Anti-AFK
- Fullbright
- Infinite Jump
- FOV Changer (70-120)
- Kill Aura with range control (5-50)
- Teleport to Player

---

## Version 1.0.0 (Initial Release)

### Initial Features
- Basic Aim Assist
- ESP with names and IDs
- 3D Chams
- Speed control
- Jump enhancement
- Fly mode
- NoClip
- Purple-themed UI
- Draggable menu
- Anti-duplicate protection
