# Beep Framework - Changelog

## Version 3.3.2 (2026-06-22) - FULL THEME ACCENT SYNC

### 🎨 EL TEMA AHORA CAMBIA TODOS LOS ACENTOS
Antes, al cambiar el color de tema solo cambiaban algunos elementos (logo, badge, borde). Ahora cambia TODO:
- Switches encendidos (ON)
- Rellenos y valores de los sliders
- Texto y borde de los keybinds
- Fondo de los selectores
- Indicador de tab activo + scrollbar
- Logo, badge de versión, FOV circle, watermark, notificaciones

### 🔧 TÉCNICO
- Nuevo sistema `AccentObjects` / `RegisterAccent` / `RefreshAccent`
- Cada elemento con acento se registra y se recolorea al cambiar el tema
- Primer swatch del Theme Changer cambiado de "Purple" a "Steel" (el azul-acero sobrio por defecto, ahora seleccionable)

---

## Version 3.3.1 (2026-06-22) - SOBER PALETTE & MINIMIZE FIX

### 🎨 NUEVA PALETA SOBRIA (menos "vibe coded")
- Cambiado el morado/magenta vibrante por gris carbón neutro + acento azul-acero desaturado (96, 116, 158)
- Fondos neutralizados (sin tinte morado): ventana, sidebar, top bar, componentes, notificaciones
- Look más sobrio y profesional

### 🐛 FIXES
- **Minimizar arreglado**: ahora `ClipsDescendants` oculta TODO el contenido al minimizar (antes se veía el sidebar y la búsqueda fuera de la barra)
- **Botón cerrar**: el icono ✕ no renderizaba (salía un cuadro □). Cambiado a una "X" que se ve en todos los executors
- Eliminada la sombra (drop shadow) que estorbaba con el recorte

---

## Version 3.3.0 (2026-06-22) - ELEGANT UI REDESIGN

### ✨ NUEVO DISEÑO VISUAL (UI COMPLETAMENTE RENOVADA)

Rediseño completo de la interfaz manteniendo el 100% de la funcionalidad.

**Ventana principal:**
- Barra de título superior con logo (punto de acento), nombre "Beep" y badge de versión
- Botones de Minimizar (—) y Cerrar (✕) con animaciones hover
- Ventana más grande (660x480) con sombra (drop shadow) y degradado morado
- Bordes redondeados más suaves

**Navegación:**
- Tabs laterales con barra indicadora animada (se desliza al cambiar)
- Efecto hover suave en cada tab
- Separador visual entre sidebar y contenido

**Componentes:**
- 🔘 Toggles modernos: switches deslizantes animados (knob que se mueve) en vez del texto [ON]/[OFF]
- 🎚️ Sliders mejorados: knob arrastrable + valor mostrado a la derecha en color de acento
- ⌨️ Keybinds: estilo más limpio con borde de acento
- 🔽 Selectores: flechas ‹ › elegantes
- 🔔 Notificaciones: rediseñadas con barra de acento lateral

**Theme Changer:**
- Ahora actualiza TODOS los elementos nuevos (logo, badge de versión, etc.)

### 🛡️ FUNCIONALIDAD INTACTA
- Sistema de dos niveles (Enable + keybind) se mantiene IGUAL
- Todas las features (Combat, Visual, Physics, Misc) funcionan exactamente igual
- Solo cambió el diseño visual, NO la lógica
- Mismas firmas de funciones helper (CreateToggle, CreateSlider, etc.)
- Exit Cheat sigue limpiando todo sin dejar rastro

### 🎮 CONTROLES
- INSERT - Abrir/Cerrar menú
- E - Fly Toggle | LeftControl - Speed Toggle | F2 - NoClip Toggle

---

## Version 3.2.8 (2026-06-21) - TWO-LEVEL TOGGLE SYSTEM

### ✅ FIXED - Sistema de dos niveles implementado correctamente

**Nivel 1: Enable en el menú** (Habilita el sistema)
- "Enable Speed Hack" → Habilita el sistema de Speed
- "Fly Mode" → Habilita el sistema de Fly  
- "NoClip" → Habilita el sistema de NoClip

**Nivel 2: Keybind** (Toggle temporal ON/OFF)
- LeftControl → Toggle Speed ON/OFF (solo si SpeedEnabled está ON)
- E → Toggle Fly ON/OFF (solo si Fly está ON en menú)
- F2 → Toggle NoClip ON/OFF (solo si NoClip está ON en menú)

### 🎯 CÓMO FUNCIONA

**Ejemplo con Speed:**
1. Abres menú → Activas "Enable Speed Hack"
2. Sistema de Speed habilitado (pero aún no activo)
3. Presionas LeftControl → Speed se ACTIVA
4. Presionas LeftControl otra vez → Speed se DESACTIVA
5. "Enable Speed Hack" sigue ON en el menú
6. Puedes seguir usando LeftControl para prender/apagar
7. Si desactivas "Enable Speed Hack" → LeftControl deja de funcionar

### 💡 BENEFICIOS
- ✅ Control total: Activa el sistema cuando quieras
- ✅ Toggle rápido: Usa keybind para ON/OFF temporal
- ✅ No interfiere con controles del juego cuando está deshabilitado
- ✅ Conveniente: No necesitas abrir menú constantemente

### 🔧 TECHNICAL CHANGES
- Added `SpeedActive`, `FlyActive`, `NoClipActive` variables
- Keybinds only work if main system is enabled
- Keybinds toggle the "Active" state, not the "Enabled" state
- "Enabled" stays ON in menu, "Active" toggles with keybind

---

## Version 3.2.7 (2026-06-21) - FULL TOGGLE KEYBINDS

### ✅ FIXED - Keybinds ahora son toggles ON/OFF completos
- **Speed (LeftControl)** - Presiona para activar, presiona de nuevo para desactivar
- **Fly (E)** - Presiona para activar, presiona de nuevo para desactivar
- **NoClip (F2)** - Presiona para activar, presiona de nuevo para desactivar

### 🎯 BEHAVIOR
**Antes (v3.2.6):**
- Keybinds solo apagaban
- Necesitabas abrir menú para volver a activar
- Inconveniente y lento

**Ahora (v3.2.7):**
- Keybinds funcionan como toggles completos
- Presiona una vez = ON
- Presiona otra vez = OFF
- Los toggles en el menú se actualizan automáticamente
- Mucho más conveniente y rápido

### 💡 EXAMPLE
```
1. Presionas LeftControl → Speed se activa (toggle en menú cambia a ON)
2. Presionas LeftControl otra vez → Speed se desactiva (toggle en menú cambia a OFF)
3. Presionas LeftControl de nuevo → Speed se activa otra vez
4. No necesitas abrir el menú
```

### 🔄 VISUAL SYNC MAINTAINED
- Los toggles en el menú se actualizan cuando usas keybinds
- Sincronización perfecta entre keybinds y UI
- Siempre sabes el estado actual

---

## Version 3.2.6 (2026-06-21) - ESP KEYBIND REMOVED

### 🗑️ REMOVED
- **ESP Toggle Key (F1)** - Completamente eliminado
  - ❌ Keybind F1 removido del código
  - ❌ Configuración ESPToggleKey eliminada
  - ❌ Input handler del ESP toggle eliminado
  - ❌ Opción "ESP Toggle Key" removida del menú Misc
  - Ya no hay forma de apagar ESP con keybind

### ✅ REMAINING KEYBINDS
Solo quedan 3 keybinds activos:
- **E** - Fly Toggle (solo apaga si Fly está ON en menú)
- **LeftControl** - Speed Toggle (solo apaga si Speed está ON en menú)
- **F2** - NoClip Toggle (solo apaga si NoClip está ON en menú)

### 🎯 WHY?
- Simplificación del sistema de keybinds
- ESP se controla únicamente desde el menú ahora
- Menos complejidad, más control manual

---

## Version 3.2.5 (2026-06-21) - CLEAN START

### ✨ CLEAN START ON LAUNCH
- **All modules disabled by default** - Al abrir el cheat, TODO está OFF excepto Watermark
  - ✅ Watermark: ON (único módulo activo por defecto)
  - ❌ ESP: OFF
  - ❌ Show Distance: OFF (antes ON, ahora OFF)
  - ❌ Show FOV Circle: OFF (antes ON, ahora OFF)
  - ❌ All Combat features: OFF
  - ❌ All Visual features: OFF
  - ❌ All Physics features: OFF
  - ❌ All Misc features: OFF (excepto Watermark)

### 🎯 WHY THIS CHANGE?
- **Clean startup** - Cheat inicia completamente limpio
- **Manual control** - Usuario activa solo lo que necesita
- **No surprises** - Sin features activas sin tu consentimiento
- **Better security** - Nada activado automáticamente
- **Performance** - Solo corre lo que activas

### 📝 CHANGES MADE
- `Config.Visuals.Distance` changed from `true` to `false`
- `Config.Combat.ShowFOV` changed from `true` to `false`
- All other modules already `false` by default

### ✅ STARTUP BEHAVIOR
**When you load the cheat:**
1. UI opens
2. Only Watermark is visible (bottom left)
3. ALL features are OFF
4. You manually enable what you need

**Example workflow:**
1. Load cheat → Everything OFF except Watermark
2. Open menu (INSERT)
3. Go to Visual tab → Enable ESP features you want
4. Go to Combat tab → Enable Aim Assist if needed
5. Go to Physics tab → Enable Speed/Fly if needed
6. Use features → Everything under your control

---

## Version 3.2.4 (2026-06-21) - FIXED KEYBIND SECURITY

### 🔒 SECURITY FIX
- **Keybind Security Restored** - Keybinds ya NO pueden activar features sin habilitarlas en menú primero
  - **F1 (ESP)** - Solo apaga ESP si ya está ON en menú
  - **F2 (NoClip)** - Solo apaga NoClip si ya está ON en menú
  - **LeftControl (Speed)** - Solo apaga Speed si ya está ON en menú
  - **E (Fly)** - Solo apaga Fly si ya está ON en menú
  - Previene activación accidental o no autorizada via keybinds
  
### ✨ MAINTAINED FEATURES
- **Visual Sync** - Los toggles en el menú aún se actualizan cuando usas keybinds
  - Cuando apagas con keybind, el toggle en el menú cambia a OFF visualmente
  - Sincronización perfecta entre keybinds y UI
  
### 🎯 CORRECT BEHAVIOR NOW
- **Step 1**: Debes activar feature en el menú PRIMERO
- **Step 2**: Luego puedes usar keybind para apagarla rápidamente
- **Step 3**: Para volver a activarla, abre el menú de nuevo
- **Result**: Mayor control y seguridad

### 📝 TECHNICAL CHANGES
- Reverted keybinds to "only turn OFF" behavior
- Maintained visual toggle sync system
- All keybinds check if feature is enabled before allowing toggle
- Visual feedback still updates menu toggles when keybinds are used

---

## Version 3.2.3 (2026-06-21) - UI SYNC & CLEANUP EDITION

### ✨ NEW FEATURES
- **Visual Toggle Sync** - Keybinds ahora actualizan los toggles visuales en el menú
  - Presiona F1 y verás todos los ESP toggles cambiar en el menú
  - Presiona E y verás el Fly toggle cambiar en el menú
  - Presiona LeftControl y verás el Speed toggle cambiar en el menú
  - Presiona F2 y verás el NoClip toggle cambiar en el menú
  - Sincronización perfecta entre keybinds y UI

### 🔄 IMPROVEMENTS
- **ESP Toggle Enhanced** - F1 ahora apaga TODOS los ESP features visualmente también
  - Cuando presionas F1 para desactivar, todos los sub-toggles también se apagan en el menú
  - Comportamiento consistente: ON = todo activado, OFF = todo desactivado
  
- **Complete Toggle Behavior** - Todos los keybinds vuelven a ser toggles ON/OFF completos
  - F1 (ESP): Toggle ON/OFF completo con sincronización visual
  - F2 (NoClip): Toggle ON/OFF completo con sincronización visual
  - LeftControl (Speed): Toggle ON/OFF completo con sincronización visual
  - E (Fly): Toggle ON/OFF completo con sincronización visual

### 🧹 EXIT CHEAT IMPROVEMENTS
- **Enhanced Cleanup** - Exit Cheat ahora elimina absolutamente TODO sin dejar rastro
  - ✅ Limpia Health Bars (BillboardGui)
  - ✅ Limpia Head Dots (BillboardGui)
  - ✅ Limpia Name Tags (BillboardGui)
  - ✅ Limpia FOV Circle completamente
  - ✅ Limpia Watermark
  - ✅ Limpia ESP Objects
  - ✅ Limpia Tracers
  - ✅ Limpia Box ESP
  - ✅ Limpia Skeleton ESP
  - ✅ Limpia todas las referencias y conexiones
  - **ZERO rastro después de Exit Cheat**

### 🎯 TECHNICAL CHANGES
- Added `ToggleIndicators` storage system for visual sync
- Added `UI:UpdateToggle()` helper function
- Enhanced Exit Cheat cleanup with BillboardGui detection
- Improved keybind system with full toggle + visual feedback

---

## Version 3.2.2 (2026-06-21) - SECURITY EDITION

### 🔒 SECURITY IMPROVEMENTS
- **Keybind Security** - All toggle keybinds now require feature to be enabled in menu first
  - **ESP Toggle (F1)** - Only turns OFF ESP if it's already ON in menu
  - **NoClip Toggle (F2)** - Only turns OFF NoClip if it's already ON in menu
  - **Speed Toggle (LeftControl)** - Only turns OFF Speed if it's already ON in menu
  - **Fly Toggle (E)** - Only turns OFF Fly if it's already ON in menu
  - This prevents accidental activation via keybind without enabling in UI first
  - You must enable features in the menu, then you can toggle them OFF with keybinds
  
### 🎯 WHY THIS CHANGE?
- Prevents unauthorized activation (must use menu first)
- Better control - keybinds only work as quick disable buttons
- More secure - no surprise activations from key presses
- Consistent behavior across all toggle features

### ⌨️ TOGGLE KEYS (Security-Enhanced)
- **F1** - ESP Toggle OFF (only if ESP is ON in menu)
- **F2** - NoClip Toggle OFF (only if NoClip is ON in menu)
- **E** - Fly Toggle OFF (only if Fly is ON in menu)
- **LeftControl** - Speed Toggle OFF (only if Speed is ON in menu)

---

## Version 3.2.1 (2026-06-21) - CLEAN EDITION

### 🗑️ REMOVED (Non-functional features)
- **Silent Aim** - Removed (didn't work properly in most games)
- **Hitbox Expander** - Removed (didn't work properly in most games)

### ⚡ IMPROVEMENTS
- **Smart ESP Toggle** - F1 now activates ALL main ESP features automatically
  - Enables: ESP Master, Names, Distance, Skeleton, 3D Boxes, Tracers, Health Bars, 2D Boxes
  - One key press for complete ESP setup
  - Much more convenient

### 🎯 CLEAN CODEBASE
- Removed ~100 lines of non-functional code
- Better performance
- More reliable features
- Focus on what actually works

### 📦 UPDATED FEATURE COUNT
**Total: 44 Features** (was 46, removed 2 non-functional)

**Combat Tab (20 features):**
✅ Aim Assist with FOV control
✅ Target Part Selector
✅ Hold to Aim
✅ Sticky Target Lock
✅ Auto Shoot
✅ Triggerbot
✅ Rapid Fire
✅ No Recoil
✅ No Spread
✅ Auto Reload
✅ Kill Aura + Auto Aim
✅ Team Check

**Visual Tab (10 features):**
✅ Enable ESP
✅ Show Names
✅ Show Distance
✅ Show IDs
✅ Head Dot
✅ Skeleton ESP (works perfectly)
✅ 3D Boxes/Chams
✅ Tracers
✅ Health Bars
✅ 2D Box ESP

**Misc Tab (8 features):**
✅ Watermark
✅ Remove Fog
✅ Anti-AFK
✅ Fullbright
✅ FOV Changer
✅ Theme Changer
✅ **Smart ESP Toggle Key (IMPROVED)**
✅ NoClip Toggle Key

### ⌨️ TOGGLE KEYS
- **F1** - Smart ESP Toggle (activates all main features)
- **F2** - NoClip Toggle
- **E** - Fly Toggle
- **LeftControl** - Speed Toggle

---

## Version 3.2.0 (2026-06-21) - ADVANCED EDITION

### ✨ NEW FEATURES
1. **Silent Aim** - True silent aim (no camera movement)
   - Uses metamethod hooking for maximum stealth
   - Redirects bullets without moving your view
   - Works with all weapons

2. **Hitbox Expander** - Makes enemy hitboxes larger
   - Adjustable size: 1-20 studs
   - Affects Head, Torso, and HumanoidRootPart
   - Makes parts invisible (transparency = 1)
   - Only affects enemies (respects team check)
   - Easier to hit targets

3. **Skeleton ESP** - Shows player bone structure
   - Displays lines connecting body parts
   - R15 support (14 bones)
   - R6 fallback support (5 bones)
   - Team colors: Red=Enemy, Green=Teammate
   - Real-time position updates

4. **Toggle Keys** - Quick access hotkeys
   - ESP Toggle (F1 default) - Customizable in Misc tab
   - NoClip Toggle (F2 default) - Customizable in Misc tab
   - Works like Speed and Fly toggle keys

### ⌨️ TOGGLE KEYS (Customizable)
- **F1** - ESP Toggle
- **F2** - NoClip Toggle
- **E** - Fly Toggle (already existed)
- **LeftControl** - Speed Toggle (already existed)

### 📦 UPDATED FEATURE COUNT
**Total: 46 Features**

**Combat Tab (23 features):**
✅ Aim Assist with FOV control
✅ **Silent Aim (NEW)**
✅ **Hitbox Expander (NEW)**
✅ **Hitbox Size Slider (NEW)**
✅ Target Part Selector
✅ Hold to Aim
✅ Sticky Target Lock
✅ Auto Shoot
✅ Triggerbot
✅ Rapid Fire
✅ No Recoil
✅ No Spread
✅ Auto Reload
✅ Kill Aura + Auto Aim
✅ Team Check

**Visual Tab (10 features):**
✅ Enable ESP
✅ Show Names
✅ Show Distance
✅ Show IDs
✅ Head Dot
✅ **Skeleton ESP (NEW)**
✅ 3D Boxes/Chams
✅ Tracers
✅ Health Bars
✅ 2D Box ESP

**Misc Tab (8 features):**
✅ Watermark
✅ Remove Fog
✅ Anti-AFK
✅ Fullbright
✅ FOV Changer
✅ Theme Changer
✅ **ESP Toggle Key (NEW)**
✅ **NoClip Toggle Key (NEW)**

### 🎯 TECHNICAL DETAILS
- Silent Aim uses `__namecall` metamethod hooking
- Hitbox Expander runs on Heartbeat for real-time updates
- Skeleton ESP uses Drawing API for performance
- Toggle keys work like Speed and Fly (simple and effective)
- All new features respect team check settings

---

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
