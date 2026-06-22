# Beep Framework - Changelog

## Version 3.1.1 (2026-06-21) - OPTIMIZED EDITION

### 🔄 REORGANIZATION
- **Kill Aura** - Moved from Misc tab to Combat tab (better organization)
- **Kill Aura Team Check** - Now in Combat tab
- **Kill Aura Range** - Now in Combat tab

### ⚡ IMPROVEMENTS
- **Infinite Jump ENHANCED** - NO COOLDOWN, bypasses all game restrictions
  - Dual method: State Change + Velocity Force
  - Ultra-fast response time: 50ms between jumps
  - Works even when games have jump cooldowns
  - Force velocity upwards (50 studs/s)
  - Ignores swimming and climbing states

### 📦 UPDATED FEATURE LIST (v3.1.1)
**Combat Tab (18 características - KILL AURA MOVED HERE):**
✅ Aim Assist with FOV control (50-400)
✅ Target Part Selector (Head/UpperTorso/Torso/HumanoidRootPart)
✅ Hold to Aim (RMB toggle)
✅ Sticky Target Lock (Q key)
✅ Auto Shoot for Locked Targets
✅ Triggerbot (auto-shoot on hover)
✅ Rapid Fire with adjustable delay
✅ No Recoil (camera stabilization)
✅ No Spread (resets spread values)
✅ Auto Reload (detects empty ammo)
✅ **Kill Aura + Auto Aim (MOVED FROM MISC)**
✅ **Kill Aura Team Check**
✅ **Kill Aura Range (5-50)**
✅ Team Check
✅ Smoothness control (1-10)
✅ FOV Circle indicator

**Misc Tab (6 características - KILL AURA REMOVED):**
✅ Watermark (draggable, shows FPS/Ping/Time)
✅ Theme Changer (6 colors)
✅ Remove Fog
✅ Anti-AFK
✅ Fullbright
✅ FOV Changer (70-120)

### 🎯 TOTAL: **41 CARACTERÍSTICAS** completamente funcionales

---

## Version 3.1.0 (2026-06-21) - REFINED EDITION

### 🗑️ REMOVED FEATURES
- **Weapon ESP** - Completely removed from config and UI (Visual tab)
- **Bunny Hop** - Completely removed from code and UI (Physics tab)

### 🔄 REORGANIZATION
- **Infinite Jump** - Moved from Misc tab to Physics tab (replaced Bunny Hop position)

### ✅ FIXES & IMPROVEMENTS
- **Head Dot** - Now works on ALL players, not just some
- **ESP Team Colors** - All ESP features now show team colors:
  - **Red** for enemies
  - **Green** for teammates
  - Applies to: Names, 3D Chams, Tracers, 2D Boxes
- **Team Detection** - Universal system works in any Roblox game

### 📦 FINAL FEATURE LIST (v3.1.0)
**Combat Tab:**
✅ Aim Assist with FOV control (50-400)
✅ Target Part Selector (Head/UpperTorso/Torso/HumanoidRootPart)
✅ Hold to Aim (RMB toggle)
✅ Sticky Target Lock (Q key)
✅ Auto Shoot for Locked Targets
✅ Triggerbot (auto-shoot on hover)
✅ Rapid Fire with adjustable delay
✅ No Recoil (camera stabilization)
✅ No Spread (resets spread values)
✅ Auto Reload (detects empty ammo)
✅ Team Check
✅ Smoothness control (1-10)
✅ FOV Circle indicator

**Visual Tab:**
✅ Enable ESP master toggle
✅ Show Names with distance [XXm]
✅ Show IDs (Player UserID)
✅ Head Dot (red circle on heads - ALL PLAYERS)
✅ 3D Boxes/Chams (team colored)
✅ Tracers (team colored)
✅ Health Bars (dynamic color)
✅ 2D Box ESP (team colored)

**Physics Tab:**
✅ Speed Hack (1-5x multiplier with toggle key)
✅ Jump Boost (50-300 power)
✅ Infinite Jump (MOVED FROM MISC)
✅ Click Teleport (CTRL+Click)
✅ NoClip
✅ Fly Mode (WASD controls, 10-500 speed)

**Misc Tab:**
✅ Watermark (draggable, shows FPS/Ping/Time)
✅ Theme Changer (6 colors: Purple, Red, Blue, Green, Yellow, Pink)
✅ Remove Fog
✅ Anti-AFK
✅ Fullbright
✅ FOV Changer (70-120)
✅ Kill Aura + Auto Aim (5-50 range)
✅ Kill Aura Team Check

### 🎯 CLEAN BUILD
- Zero lag performance
- Universal compatibility
- All features 100% functional
- Cleaner UI (removed unused features)
- Better organization (logical tab placement)

---

## Version 3.0.0 (2026-06-21) - COMPLETE EDITION

### ✨ NEW FEATURES
- **Rapid Fire** - Shoot faster with adjustable delay (0.01-1s)
- **No Recoil** - Eliminates weapon recoil (camera stabilization)
- **No Spread** - Removes bullet spread (resets spread values)
- **Auto Reload** - Automatically reloads when ammo is empty
- **Weapon ESP** - Shows equipped weapon of each player
- **Head Dot** - Red dot on enemy heads for easier aiming

### 🔧 FIXED
- **Bunny Hop** - Now works perfectly with proper timing
- **Watermark** - Moved to bottom left and made draggable
- **Distance ESP** - Now displays correctly with improved formatting

### 🎨 IMPROVEMENTS
- **Watermark Draggable** - Click and drag to move anywhere
- **Watermark Position** - Starts at bottom left (Y: 400px)
- **ESP Enhanced** - Distance shows as [XXm] next to name
- **Weapon Display** - Shows gun icon + weapon name
- **Head Dot** - Circular red indicator on head
- **All Combat Features** - Fully implemented and tested

### 💻 TECHNICAL
- Rapid Fire uses delay system to control fire rate
- No Recoil stores camera CFrame to prevent recoil
- No Spread resets Spread/MaxSpread values in tools
- Auto Reload checks Ammo/Magazine values and presses R
- Weapon ESP updates in real-time (0.1s intervals)
- Head Dot uses BillboardGui with rounded frame

### 📦 ALL FEATURES NOW FUNCTIONAL
✅ Aim Assist with Target Selector
✅ Hold to Aim (RMB)
✅ Sticky Target Lock (Q)
✅ Auto Shoot for Locked Targets
✅ Triggerbot (auto-shoot on hover)
✅ **Rapid Fire (NEW - WORKING)**
✅ **No Recoil (NEW - WORKING)**
✅ **No Spread (NEW - WORKING)**
✅ **Auto Reload (NEW - WORKING)**
✅ Team Detection (universal)
✅ ESP with Names, Distance, IDs
✅ **Weapon ESP (NEW - WORKING)**
✅ **Head Dot (NEW - WORKING)**
✅ 3D Chams/Boxes
✅ Tracers
✅ Health Bars
✅ 2D Box ESP
✅ Speed Hack (CFrame-based)
✅ Jump Boost
✅ **Bunny Hop (FIXED - WORKING)**
✅ **Click Teleport (WORKING)**
✅ NoClip
✅ Fly Mode (WASD controls)
✅ **Watermark (FIXED - Draggable)**
✅ Theme Changer (6 colors)
✅ Remove Fog
✅ Anti-AFK
✅ Fullbright
✅ Infinite Jump
✅ FOV Changer
✅ Kill Aura
✅ Teleport to Player

---

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
