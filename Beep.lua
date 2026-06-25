-- Beep Multi-Tool Framework
-- Universal ESP, Aimbot & Physics Controller
-- Stable Version

-- VERSION CONTROL (Update this for each new version)
local BEEP_VERSION = "v5.0.0"

local StartTime = tick()
if not game:IsLoaded() then
    repeat task.wait(0.1) until game:IsLoaded() or (tick() - StartTime) > 30
end

-- Anti-Duplicate Protection
local CoreGui = game:GetService("CoreGui")
for _, oldUI in pairs(CoreGui:GetChildren()) do
    if oldUI:IsA("ScreenGui") and oldUI.Name:find("Beep_Framework_") then
        oldUI:Destroy()
    end
end

-- Core Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- Configuration
local Config = {
    Visuals = {
        Enabled = false,
        Names = false,
        Distance = false,
        IDs = false,
        Skeletons = false,
        SkeletonESP = false,
        Tracers = false,
        HealthBars = false,
        BoxESP = false,
        HeadDot = false,
        Accent = Color3.fromRGB(255, 255, 255), -- White (Theme color)
        ESPColor = Color3.fromRGB(255, 255, 255) -- ESP color (customizable)
    },
    Combat = {
        SilentAim = false,
        FOV = 150,
        Smoothness = 0.5,
        TargetPart = "Head",
        ShowFOV = false,
        LockKey = "Q",
        LockedTarget = nil,
        Triggerbot = false,
        TriggerDelay = 0.1,        -- Normal: 10 shots/sec
        TeamCheck = true,
        HoldToAim = false,
        AimHoldKey = "MouseButton2",
        UltraRapidFire = false,    -- Renamed from RapidFire
        UltraRapidFireDelay = 0.02, -- ULTRA FAST: 50 shots/sec (5x faster than normal!)
        NoRecoil = false,
        NoSpread = false,
        AutoReload = false,
        KillAura = false,
        KillAuraRange = 20,
        KillAuraTeamCheck = true,
        -- Target Switcher (for Aim Assist)
        TargetSwitcher = false,       -- Auto-switch to next target when current dies
        TargetSwitcherDelay = 0.1,    -- Delay before switching (seconds)
        -- Ragebot
        Ragebot = false,
        RagebotTargetPart = "Head",
        RagebotMode = "Closest",
        RagebotFullMap = false,
        RagebotTeamCheck = true,
        RagebotVisibleCheck = false,
        RagebotMaxDistance = 5000,
        RagebotPrediction = 0,
        RagebotAutoTP = false,
        RagebotTPMode = "Teleport",
        RagebotTPSpeed = 150,
        RagebotTPOffset = 6,
        RagebotNoClip = false,
        RagebotGameProfile = "Auto",
        RagebotFaceTarget = false,
        RagebotIgnoreImmune = false
    },
    Physics = {
        Speed = 1,
        JumpPower = 100,
        NoClip = false,
        Fly = false,
        FlySpeed = 50,
        FlyKey = "E",
        SpeedEnabled = false,
        SpeedActive = false,
        SpeedKey = "LeftControl",
        JumpEnabled = false,
        ClickTP = false,
        ClickTPKey = "LeftControl",
        FlyActive = false,
        NoClipActive = false
    },
    Misc = {
        Fullbright = false,
        InfiniteJump = false,
        FOVChanger = false,
        FOVValue = 70,
        TeleportPlayer = nil,
        AntiAFK = false,
        RemoveFog = false,
        Watermark = true,
        ThemeColor = 1,
        NoClipToggleKey = "F2",
        PanicKey = "End"
    },
    UI = {
        ThemeColors = {
            Color3.fromRGB(255, 255, 255), -- White (default)
            Color3.fromRGB(255, 80, 80),  -- Red
            Color3.fromRGB(80, 160, 255), -- Blue
            Color3.fromRGB(80, 255, 120), -- Green
            Color3.fromRGB(255, 200, 80), -- Yellow/Orange
            Color3.fromRGB(255, 80, 200)  -- Pink
        }
    }
}

-- UI Constructor
local UI = { Tabs = {}, CurrentTab = nil, Visible = true, Active = true }

-- Accent registry: elements that should recolor when the theme changes
local AccentObjects = {}
local function RegisterAccent(fn)
    table.insert(AccentObjects, fn)
    pcall(fn, Config.Visuals.Accent)
end
local function RefreshAccent(color)
    for _, fn in ipairs(AccentObjects) do
        pcall(fn, color)
    end
end

-- Global function to detect if a color is light (needs dark elements)
local function isLightColorGlobal(c)
    return (c.R * 255 + c.G * 255 + c.B * 255) / 3 > 180
end

function UI:Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do 
        pcall(function() inst[k] = v end) 
    end
    return inst
end

UI.Screen = UI:Create("ScreenGui", {
    Name = "Beep_Framework_" .. HttpService:GenerateGUID(false),
    ResetOnSpawn = false, 
    IgnoreGuiInset = true, 
    DisplayOrder = 999999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = CoreGui
})

-- ===== PREMIUM LOADING SCREEN =====
local LoadingScreen = UI:Create("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(8, 8, 12),
    BorderSizePixel = 0,
    ZIndex = 1000,
    Parent = UI.Screen
})

local LoadingLogo = UI:Create("TextLabel", {
    Size = UDim2.new(0, 200, 0, 60),
    Position = UDim2.new(0.5, -100, 0.5, -80),
    BackgroundTransparency = 1,
    Text = "beep",
    TextColor3 = Config.Visuals.Accent,
    Font = Enum.Font.GothamBlack,
    TextSize = 48,
    ZIndex = 1001,
    Parent = LoadingScreen
})

local LoadingText = UI:Create("TextLabel", {
    Size = UDim2.new(0, 300, 0, 30),
    Position = UDim2.new(0.5, -150, 0.5, -10),
    BackgroundTransparency = 1,
    Text = "Loading framework...",
    TextColor3 = Color3.fromRGB(180, 180, 190),
    Font = Enum.Font.GothamMedium,
    TextSize = 14,
    ZIndex = 1001,
    Parent = LoadingScreen
})

local LoadingBar = UI:Create("Frame", {
    Size = UDim2.new(0, 300, 0, 4),
    Position = UDim2.new(0.5, -150, 0.5, 30),
    BackgroundColor3 = Color3.fromRGB(30, 30, 36),
    BorderSizePixel = 0,
    ZIndex = 1001,
    Parent = LoadingScreen
})
Instance.new("UICorner", LoadingBar).CornerRadius = UDim.new(1, 0)

local LoadingFill = UI:Create("Frame", {
    Size = UDim2.new(0, 0, 1, 0),
    BackgroundColor3 = Config.Visuals.Accent,
    BorderSizePixel = 0,
    ZIndex = 1002,
    Parent = LoadingBar
})
Instance.new("UICorner", LoadingFill).CornerRadius = UDim.new(1, 0)

-- Animated loading
task.spawn(function()
    local loadingSteps = {
        {text = "Initializing services...", progress = 0.2, wait = 0.15},
        {text = "Loading modules...", progress = 0.4, wait = 0.15},
        {text = "Setting up UI...", progress = 0.6, wait = 0.15},
        {text = "Configuring features...", progress = 0.8, wait = 0.15},
        {text = "Ready!", progress = 1, wait = 0.2},
    }
    
    for _, step in ipairs(loadingSteps) do
        LoadingText.Text = step.text
        TweenService:Create(LoadingFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(step.progress, 0, 1, 0)
        }):Play()
        task.wait(step.wait)
    end
    
    task.wait(0.2)
    -- Destroy loading screen immediately (no fade animation to avoid persistence bugs)
    LoadingScreen:Destroy()
end)

local Main = UI:Create("Frame", {
    Size = UDim2.new(0, 660, 0, 480), 
    Position = UDim2.new(0.5, -330, 0.5, -240),
    BackgroundColor3 = Color3.fromRGB(10, 10, 14),
    BorderSizePixel = 0, 
    ClipsDescendants = true,
    ZIndex = 1,
    Parent = UI.Screen
})
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

-- Subtle gradient on main background
UI:Create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 16)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
    }),
    Rotation = 90,
    Parent = Main
})

local MainStroke = UI:Create("UIStroke", {
    Color = Color3.fromRGB(36, 36, 44),
    Thickness = 1.5, 
    Transparency = 0.2,
    Parent = Main
})

-- ===== TOP BAR (Title + Window Controls) =====
local TopBar = UI:Create("Frame", {
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Color3.fromRGB(14, 14, 18),
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = Main
})
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)
-- cover bottom rounded corners of topbar
UI:Create("Frame", {
    Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = Color3.fromRGB(14, 14, 18), BorderSizePixel = 0, ZIndex = 6, Parent = TopBar
})
-- bottom border line of topbar
UI:Create("Frame", {
    Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Color3.fromRGB(30, 30, 38), BorderSizePixel = 0, ZIndex = 7, Parent = TopBar
})

-- Accent dot / logo mark
local LogoMark = UI:Create("Frame", {
    Size = UDim2.new(0, 10, 0, 10),
    Position = UDim2.new(0, 18, 0.5, -5),
    BackgroundColor3 = Config.Visuals.Accent,
    ZIndex = 7,
    Parent = TopBar
})
Instance.new("UICorner", LogoMark).CornerRadius = UDim.new(1, 0)
RegisterAccent(function(c) LogoMark.BackgroundColor3 = c end)

local TitleLabel = UI:Create("TextLabel", {
    Size = UDim2.new(0, 70, 1, 0),
    Position = UDim2.new(0, 36, 0, 0),
    BackgroundTransparency = 1,
    Text = "Beep",
    TextColor3 = Color3.fromRGB(235, 236, 240),
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7,
    Parent = TopBar
})

-- Version badge
local VersionBadge = UI:Create("TextLabel", {
    Size = UDim2.new(0, 50, 0, 20),
    Position = UDim2.new(0, 94, 0.5, -10),
    BackgroundColor3 = Color3.fromRGB(24, 24, 30),
    Text = BEEP_VERSION,
    TextColor3 = Config.Visuals.Accent,
    Font = Enum.Font.GothamSemibold,
    TextSize = 11,
    ZIndex = 7,
    Parent = TopBar
})
Instance.new("UICorner", VersionBadge).CornerRadius = UDim.new(0, 6)
RegisterAccent(function(c) VersionBadge.TextColor3 = c end)

-- Close button (hides menu)
local CloseBtn = UI:Create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -38, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(26, 26, 32),
    Text = "X",
    TextColor3 = Color3.fromRGB(210, 120, 120),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    AutoButtonColor = false,
    ZIndex = 7,
    Parent = TopBar
})
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- Minimize button
local MinimizeBtn = UI:Create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -74, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(22, 22, 28),
    Text = "—",
    TextColor3 = Color3.fromRGB(190, 192, 200),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    AutoButtonColor = false,
    ZIndex = 7,
    Parent = TopBar
})
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160, 60, 60)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(26, 26, 32)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    UI.Visible = false
    Main.Visible = false
    UI:Notify("Menu hidden. Press 'Insert' to reopen.")
end)

MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(46, 48, 58)}):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
end)
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    -- Main has ClipsDescendants = true, so shrinking hides all content automatically
    if minimized then
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 660, 0, 46)}):Play()
    else
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 660, 0, 480)}):Play()
    end
end)

-- Sidebar
local Sidebar = UI:Create("Frame", {
    Size = UDim2.new(0, 168, 1, -46), 
    Position = UDim2.new(0, 0, 0, 46),
    BackgroundColor3 = Color3.fromRGB(14, 14, 18),
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = Main
})

-- Sidebar separator line
UI:Create("Frame", {
    Size = UDim2.new(0, 1, 1, -20), Position = UDim2.new(1, 0, 0, 10),
    BackgroundColor3 = Color3.fromRGB(28, 28, 36), BorderSizePixel = 0, ZIndex = 2, Parent = Sidebar
})

-- Pages Container (Adjusted to be below search bar)
local Container = UI:Create("Frame", {
    Size = UDim2.new(1, -188, 1, -150), 
    Position = UDim2.new(0, 180, 0, 102),
    BackgroundTransparency = 1, 
    ZIndex = 2,
    Parent = Main
})

-- Branding (kept for theme-changer compatibility, placed at sidebar bottom)
local ProjectLabel = UI:Create("TextLabel", {
    Size = UDim2.new(0, 150, 0, 20),
    Position = UDim2.new(0, 16, 1, -28),
    BackgroundTransparency = 1,
    Text = "Made by 765g",
    TextColor3 = Config.Visuals.Accent,
    Font = Enum.Font.GothamSemibold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = Sidebar
})
RegisterAccent(function(c) ProjectLabel.TextColor3 = c end)

-- Watermark (Clean style with background)
local WatermarkFrame = UI:Create("Frame", {
    Size = UDim2.new(0, 0, 0, 24),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(20, 20, 25),
    BackgroundTransparency = 0.25,
    AutomaticSize = Enum.AutomaticSize.X,
    Active = true,
    ZIndex = 100,
    Visible = Config.Misc.Watermark,
    Parent = UI.Screen
})
Instance.new("UICorner", WatermarkFrame).CornerRadius = UDim.new(0, 6)
UI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = WatermarkFrame})

local Watermark = UI:Create("TextLabel", {
    Size = UDim2.new(0, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundTransparency = 1,
    Text = "beep",
    TextColor3 = Config.Visuals.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    AutomaticSize = Enum.AutomaticSize.X,
    ZIndex = 101,
    Parent = WatermarkFrame
})
UI:Create("UIStroke", {Color = Color3.new(0, 0, 0), Thickness = 1.2, Transparency = 0.3, Parent = Watermark})
RegisterAccent(function(c)
    Watermark.TextColor3 = c
end)

-- Make Watermark Draggable
local watermarkDragging = false
local watermarkDragStart = nil
local watermarkStartPos = nil

WatermarkFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        watermarkDragging = true
        watermarkDragStart = input.Position
        watermarkStartPos = WatermarkFrame.Position
    end
end)

WatermarkFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        watermarkDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if watermarkDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - watermarkDragStart
        WatermarkFrame.Position = UDim2.new(
            watermarkStartPos.X.Scale, 
            watermarkStartPos.X.Offset + delta.X,
            watermarkStartPos.Y.Scale, 
            watermarkStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Update Watermark
task.spawn(function()
    while task.wait(0.5) do
        if UI.Active and Config.Misc.Watermark then
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            Watermark.Text = string.format("beep | %dfps | %dms", fps, ping)
            WatermarkFrame.Visible = Config.Misc.Watermark
        else
            WatermarkFrame.Visible = false
        end
    end
end)

-- ===== ARRAYLIST (Active Features List - Premium Feature) =====
local ArraylistFrame = UI:Create("Frame", {
    Size = UDim2.new(0, 220, 0, 0),
    Position = UDim2.new(1, -230, 0, 10),
    BackgroundTransparency = 1,
    AutomaticSize = Enum.AutomaticSize.Y,
    ZIndex = 100,
    Parent = UI.Screen
})

local ArraylistLayout = UI:Create("UIListLayout", {
    Padding = UDim.new(0, 4),
    SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Parent = ArraylistFrame
})

local ArraylistItems = {}

local function UpdateArraylist()
    for _, item in pairs(ArraylistItems) do
        if item and item.Parent then item:Destroy() end
    end
    ArraylistItems = {}
    
    local activeFeatures = {}
    
    if Config.Combat.SilentAim then table.insert(activeFeatures, {name = "Aim Assist", color = Config.Visuals.Accent, key = Config.Combat.LockKey}) end
    if Config.Combat.Ragebot then table.insert(activeFeatures, {name = "Ragebot", color = Color3.fromRGB(255, 80, 80), key = ""}) end
    if Config.Combat.Triggerbot then table.insert(activeFeatures, {name = "Triggerbot", color = Color3.fromRGB(255, 200, 80), key = ""}) end
    if Config.Combat.KillAura then table.insert(activeFeatures, {name = "Kill Aura", color = Color3.fromRGB(255, 100, 100), key = ""}) end
    if Config.Combat.UltraRapidFire then table.insert(activeFeatures, {name = "Ultra Rapid Fire", color = Color3.fromRGB(255, 150, 50), key = ""}) end
    if Config.Physics.SpeedActive then table.insert(activeFeatures, {name = "Speed", color = Color3.fromRGB(80, 255, 200), key = Config.Physics.SpeedKey}) end
    if Config.Physics.FlyActive then table.insert(activeFeatures, {name = "Fly", color = Color3.fromRGB(120, 180, 255), key = Config.Physics.FlyKey}) end
    if Config.Physics.NoClipActive then table.insert(activeFeatures, {name = "NoClip", color = Color3.fromRGB(200, 150, 255), key = Config.Misc.NoClipToggleKey}) end
    if Config.Visuals.Enabled then table.insert(activeFeatures, {name = "ESP", color = Color3.fromRGB(80, 255, 120), key = ""}) end
    
    for i, feature in ipairs(activeFeatures) do
        local item = UI:Create("Frame", {
            Size = UDim2.new(0, 0, 0, 24),
            BackgroundColor3 = Color3.fromRGB(16, 16, 20),
            BackgroundTransparency = 0.15,
            AutomaticSize = Enum.AutomaticSize.X,
            LayoutOrder = i,
            ZIndex = 101,
            Parent = ArraylistFrame
        })
        Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)
        UI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = item})
        
        local indicator = UI:Create("Frame", {
            Size = UDim2.new(0, 2, 1, -8), Position = UDim2.new(0, 3, 0, 4),
            BackgroundColor3 = feature.color, BorderSizePixel = 0, ZIndex = 102, Parent = item
        })
        Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
        
        local label = UI:Create("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = feature.name .. (feature.key ~= "" and " [" .. feature.key .. "]" or ""),
            TextColor3 = Color3.new(1, 1, 1),
            Font = Enum.Font.GothamBold,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.X,
            ZIndex = 102,
            Parent = item
        })
        
        table.insert(ArraylistItems, item)
    end
end

task.spawn(function()
    while task.wait(1) do
        if UI.Active then
            UpdateArraylist()
        end
    end
end)

-- Search Bar (Below the menu, doesn't cover content)
local SearchBar = UI:Create("Frame", {
    Size = UDim2.new(1, -200, 0, 38),
    Position = UDim2.new(0, 180, 0, 56),
    BackgroundColor3 = Color3.fromRGB(18, 18, 24),
    ZIndex = 15,
    Parent = Main
})
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0, 10)
UI:Create("UIStroke", {Color = Color3.fromRGB(34, 34, 42), Thickness = 1, Transparency = 0.4, Parent = SearchBar})

local SearchBox = UI:Create("TextBox", {
    Size = UDim2.new(1, -16, 1, -10),
    Position = UDim2.new(0, 12, 0, 5),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Search any hack across all tabs...",
    TextColor3 = Color3.new(1, 1, 1),
    PlaceholderColor3 = Color3.fromRGB(150, 140, 160),
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex = 16,
    Parent = SearchBar
})

-- Universal Search System (searches all tabs and shows results)
local searchResults = {}

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = SearchBox.Text:lower()
    
    -- Clear previous results
    searchResults = {}
    
    if searchText == "" then
        -- Show all items
        for _, tab in pairs(UI.Tabs) do
            for _, child in pairs(tab:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChildOfClass("TextLabel") then
                    child.Visible = true
                end
            end
        end
        return
    end
    
    -- Search through ALL tabs
    for tabIndex, tab in pairs(UI.Tabs) do
        for _, child in pairs(tab:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChildOfClass("TextLabel") then
                local label = child:FindFirstChildOfClass("TextLabel")
                local text = label.Text:lower()
                
                if text:find(searchText) then
                    -- Show this item
                    child.Visible = true
                    table.insert(searchResults, {tab = tab, item = child, tabIndex = tabIndex, name = label.Text})
                else
                    -- Hide this item
                    child.Visible = false
                end
            end
        end
    end
    
    -- If results found, auto-switch to first tab with results
    if #searchResults > 0 then
        local firstResult = searchResults[1]
        -- Hide all tabs
        for _, t in pairs(Container:GetChildren()) do 
            if t:IsA("ScrollingFrame") then 
                t.Visible = false 
            end 
        end
        -- Show the tab with the first result
        firstResult.tab.Visible = true
        
        -- Update sidebar colors
        local tabButtons = {}
        for _, v in pairs(Sidebar:GetChildren()) do
            if v:IsA("TextButton") then
                table.insert(tabButtons, v)
            end
        end
        for i, btn in pairs(tabButtons) do
            if i == firstResult.tabIndex then
                btn.TextColor3 = Config.Visuals.Accent
            else
                btn.TextColor3 = Color3.fromRGB(150, 140, 160)
            end
        end
    end
end)

-- Notification System
function UI:Notify(text)
    if not UI.Active then return end
    task.spawn(function()
        local n = UI:Create("Frame", {
            Size = UDim2.new(0, 290, 0, 48), 
            Position = UDim2.new(1, 10, 0.8, 0),
            BackgroundColor3 = Color3.fromRGB(22, 23, 28), 
            ZIndex = 20,
            Parent = UI.Screen
        })
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 10)
        UI:Create("UIStroke", {Color = Config.Visuals.Accent, Thickness = 1.5, Transparency = 0.3, Parent = n})

        -- accent side bar
        local bar = UI:Create("Frame", {
            Size = UDim2.new(0, 4, 1, -16), Position = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = Config.Visuals.Accent, ZIndex = 21, Parent = n
        })
        Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
        
        UI:Create("TextLabel", {
            Size = UDim2.new(1, -30, 1, 0), 
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1, 
            Text = text,
            TextColor3 = Color3.new(1,1,1), 
            Font = Enum.Font.GothamMedium, 
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 21,
            Parent = n
        })
        
        n:TweenPosition(UDim2.new(0.98, -290, 0.8, 0), "Out", "Back", 0.4)
        task.wait(3)
        if n and n.Parent then
            n:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quad", 0.4)
            task.wait(0.5) 
            n:Destroy()
        end
    end)
end

-- Dragging System (robust: uses global InputEnded so it never gets stuck)
local dragToggle = false
local dragStart = nil
local startPos = nil

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- FOV Circle
local FOVContainer = UI:Create("Frame", {
    Size = UDim2.new(0, Config.Combat.FOV * 2, 0, Config.Combat.FOV * 2),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 0,
    Parent = UI.Screen
})
local FOVStroke = UI:Create("UIStroke", {Color = Config.Visuals.Accent, Thickness = 1, Transparency = 0.5, Parent = FOVContainer})
Instance.new("UICorner", FOVContainer).CornerRadius = UDim.new(1, 0)
RegisterAccent(function(c) FOVStroke.Color = c end)

RunService.RenderStepped:Connect(function()
    if not UI.Active then return end
    if Config.Combat.ShowFOV then
        FOVContainer.Visible = true
        FOVContainer.Size = UDim2.new(0, Config.Combat.FOV * 2, 0, Config.Combat.FOV * 2)
        FOVContainer.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y + 36)
    else
        FOVContainer.Visible = false
    end
end)

-- Toggle Menu with Insert Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not UI.Active then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        UI.Visible = not UI.Visible
        Main.Visible = UI.Visible
        UI:Notify(UI.Visible and "Menu Opened" or "Menu Closed")
    end
end)

-- Tab System
function UI:CreateTab(name)
    local tabIndex = #UI.Tabs
    local Page = UI:Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Config.Visuals.Accent,
        Visible = false,
        ZIndex = 3,
        Parent = Container
    })
    RegisterAccent(function(c) Page.ScrollBarImageColor3 = c end)
    local Layout = UI:Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Page
    })
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    local TabButton = UI:Create("TextButton", {
        Size = UDim2.new(0, 148, 0, 38),
        Position = UDim2.new(0, 10, 0, 16 + (tabIndex * 46)),
        BackgroundColor3 = Color3.fromRGB(20, 20, 26),
        BackgroundTransparency = tabIndex == 0 and 0 or 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 3,
        Parent = Sidebar
    })
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 10)

    -- Accent selection indicator (left bar)
    local Indicator = UI:Create("Frame", {
        Size = UDim2.new(0, 3, 0, tabIndex == 0 and 22 or 0),
        Position = UDim2.new(0, 0, 0.5, tabIndex == 0 and -11 or 0),
        BackgroundColor3 = Config.Visuals.Accent,
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = TabButton
    })
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)
    RegisterAccent(function(c) Indicator.BackgroundColor3 = c end)

    local TabLabel = UI:Create("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = tabIndex == 0 and Color3.new(1,1,1) or Color3.fromRGB(150, 140, 160),
        Font = Enum.Font.GothamBold, -- Premium bold font
        TextSize = 14, -- Larger for better visibility
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Parent = TabButton
    })

    TabButton.MouseEnter:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(210, 200, 220)}):Play()
        end
    end)
    TabButton.MouseLeave:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(150, 140, 160)}):Play()
        end
    end)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(Sidebar:GetChildren()) do 
            if v:IsA("TextButton") then 
                local lbl = v:FindFirstChildOfClass("TextLabel")
                local ind = v:FindFirstChildOfClass("Frame")
                if lbl then TweenService:Create(lbl, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(150, 140, 160)}):Play() end
                TweenService:Create(v, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                if ind then TweenService:Create(ind, TweenInfo.new(0.15), {Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0)}):Play() end
            end 
        end
        Page.Visible = true
        TweenService:Create(TabButton, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
        TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Color3.new(1,1,1)}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.15), {Size = UDim2.new(0, 3, 0, 22), Position = UDim2.new(0, 0, 0.5, -11)}):Play()
    end)
    
    if tabIndex == 0 then
        Page.Visible = true
    end
    
    table.insert(UI.Tabs, Page)
    return Page
end

-- Storage for toggle indicators (for keybind updates)
local ToggleIndicators = {}

-- Helper to animate a switch visual
local function SetSwitchVisual(track, knob, state)
    TweenService:Create(track, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
        BackgroundColor3 = state and Config.Visuals.Accent or Color3.fromRGB(38, 38, 46)
    }):Play()
    TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
        Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
    }):Play()
end

function UI:CreateToggle(parent, text, configSection, configKey, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 42), BackgroundColor3 = Color3.fromRGB(18, 18, 24), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    UI:Create("UIStroke", {Color = Color3.fromRGB(32, 32, 40), Thickness = 1, Transparency = 0.4, Parent = Frame})
    
    UI:Create("TextLabel", {Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(225, 226, 232), Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    
    local state = Config[configSection][configKey]

    -- Switch track
    local Track = UI:Create("TextButton", {
        Size = UDim2.new(0, 44, 0, 22), Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = state and Config.Visuals.Accent or Color3.fromRGB(38, 38, 46),
        Text = "", AutoButtonColor = false, ZIndex = 5, Parent = Frame
    })
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    -- Knob
    local Knob = UI:Create("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8),
        BackgroundColor3 = isLightColorGlobal(Config.Visuals.Accent) and Color3.fromRGB(80, 80, 90) or Color3.new(1, 1, 1),
        ZIndex = 6, Parent = Track
    })
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    -- Store indicator reference for keybind updates
    local key = configSection .. "." .. configKey
    ToggleIndicators[key] = {track = Track, knob = Knob}
    RegisterAccent(function(c)
        if Config[configSection][configKey] then Track.BackgroundColor3 = c end
        Knob.BackgroundColor3 = isLightColorGlobal(c) and Color3.fromRGB(80, 80, 90) or Color3.new(1, 1, 1)
    end)
    
    Track.MouseButton1Click:Connect(function()
        if not UI.Active then return end
        local newState = not Config[configSection][configKey]
        Config[configSection][configKey] = newState
        SetSwitchVisual(Track, Knob, newState)
        if callback then callback(newState) end
    end)
end

-- Helper function to update toggle indicators from keybinds
function UI:UpdateToggle(configSection, configKey, state)
    local key = configSection .. "." .. configKey
    local ind = ToggleIndicators[key]
    if ind and ind.track and ind.knob then
        SetSwitchVisual(ind.track, ind.knob, state)
    end
end

function UI:CreateSlider(parent, text, min, max, configSection, configKey, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 54), BackgroundColor3 = Color3.fromRGB(18, 18, 24), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    UI:Create("UIStroke", {Color = Color3.fromRGB(32, 32, 40), Thickness = 1, Transparency = 0.4, Parent = Frame})
    
    local Label = UI:Create("TextLabel", {Size = UDim2.new(0.7, 0, 0, 25), Position = UDim2.new(0, 14, 0, 4), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(225, 226, 232), Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    local ValueLabel = UI:Create("TextLabel", {Size = UDim2.new(0, 60, 0, 25), Position = UDim2.new(1, -70, 0, 4), BackgroundTransparency = 1, Text = tostring(Config[configSection][configKey]), TextColor3 = Config.Visuals.Accent, Font = Enum.Font.GothamBold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 5, Parent = Frame})
    
    local SlideBar = UI:Create("Frame", {Size = UDim2.new(1, -28, 0, 6), Position = UDim2.new(0, 14, 0, 38), BackgroundColor3 = Color3.fromRGB(34, 34, 42), ZIndex = 5, Parent = Frame})
    Instance.new("UICorner", SlideBar).CornerRadius = UDim.new(0, 3)
    
    local Fill = UI:Create("Frame", {Size = UDim2.new((Config[configSection][configKey] - min)/(max - min), 0, 1, 0), BackgroundColor3 = Config.Visuals.Accent, ZIndex = 6, Parent = SlideBar})
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)

    -- Knob
    local Knob = UI:Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0),
        BackgroundColor3 = isLightColorGlobal(Config.Visuals.Accent) and Color3.fromRGB(80, 80, 90) or Color3.new(1, 1, 1), ZIndex = 7, Parent = Fill
    })
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    RegisterAccent(function(c) 
        Fill.BackgroundColor3 = c
        ValueLabel.TextColor3 = c 
        Knob.BackgroundColor3 = isLightColorGlobal(c) and Color3.fromRGB(80, 80, 90) or Color3.new(1, 1, 1)
    end)
    
    local Trigger = UI:Create("TextButton", {Size = UDim2.new(1, 0, 3, 0), Position = UDim2.new(0, 0, -1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 7, Parent = SlideBar})
    
    local function update(input)
        local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        Config[configSection][configKey] = val
        ValueLabel.Text = tostring(val)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        if callback then callback(val) end
    end
    
    local draggingSlider = false
    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = true update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSlider = false end
    end)
end

function UI:CreateKeybind(parent, text, configSection, configKey)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 42), BackgroundColor3 = Color3.fromRGB(18, 18, 24), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    UI:Create("UIStroke", {Color = Color3.fromRGB(32, 32, 40), Thickness = 1, Transparency = 0.4, Parent = Frame})
    
    UI:Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(225, 226, 232), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    
    local KeyButton = UI:Create("TextButton", {
        Size = UDim2.new(0, 72, 0, 26), Position = UDim2.new(1, -84, 0.5, -13),
        BackgroundColor3 = Color3.fromRGB(28, 28, 36),
        Text = Config[configSection][configKey] == "MouseButton2" and "RMB" or Config[configSection][configKey],
        TextColor3 = Config.Visuals.Accent, Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, ZIndex = 5, Parent = Frame
    })
    Instance.new("UICorner", KeyButton).CornerRadius = UDim.new(0, 7)
    local kbStroke = UI:Create("UIStroke", {Color = Config.Visuals.Accent, Thickness = 1, Transparency = 0.6, Parent = KeyButton})
    RegisterAccent(function(c) KeyButton.TextColor3 = c; kbStroke.Color = c end)
    
    local listening = false
    KeyButton.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        KeyButton.Text = "..."
        local connection
        connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode.Name
                Config[configSection][configKey] = key
                KeyButton.Text = key
                listening = false
                connection:Disconnect()
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                Config[configSection][configKey] = "MouseButton2"
                KeyButton.Text = "RMB"
                listening = false
                connection:Disconnect()
            end
        end)
    end)
end

function UI:CreateSelector(parent, text, configSection, configKey, options, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 42), BackgroundColor3 = Color3.fromRGB(18, 18, 24), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    UI:Create("UIStroke", {Color = Color3.fromRGB(32, 32, 40), Thickness = 1, Transparency = 0.4, Parent = Frame})
    
    UI:Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(225, 226, 232), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    
    -- Function to determine if color is light (needs dark text)
    local function isLightColor(c)
        return (c.R * 255 + c.G * 255 + c.B * 255) / 3 > 180
    end
    
    local SelectorButton = UI:Create("TextButton", {
        Size = UDim2.new(0, 130, 0, 26), Position = UDim2.new(1, -142, 0.5, -13),
        BackgroundColor3 = Config.Visuals.Accent,
        Text = "< " .. Config[configSection][configKey] .. " >",
        TextColor3 = isLightColor(Config.Visuals.Accent) and Color3.new(0,0,0) or Color3.new(1,1,1),
        Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, ZIndex = 5, Parent = Frame
    })
    Instance.new("UICorner", SelectorButton).CornerRadius = UDim.new(0, 7)
    RegisterAccent(function(c) 
        SelectorButton.BackgroundColor3 = c 
        SelectorButton.TextColor3 = isLightColor(c) and Color3.new(0,0,0) or Color3.new(1,1,1)
    end)
    
    SelectorButton.MouseButton1Click:Connect(function()
        if not UI.Active then return end
        local currentIndex = 1
        for i, option in ipairs(options) do
            if Config[configSection][configKey] == option then
                currentIndex = i
                break
            end
        end
        local nextIndex = (currentIndex % #options) + 1
        Config[configSection][configKey] = options[nextIndex]
        SelectorButton.Text = "< " .. options[nextIndex] .. " >"
        if callback then callback(options[nextIndex]) end
    end)
end

-- Helper function to parse HEX color (supports #FFFFFF, FFFFFF, #FFF, FFF formats)
local function ParseHexColor(hexStr)
    local hex = hexStr:gsub("#", ""):gsub(" ", ""):upper()
    if #hex == 3 then
        hex = hex:sub(1,1):rep(2) .. hex:sub(2,2):rep(2) .. hex:sub(3,3):rep(2)
    end
    if #hex == 6 then
        local r = tonumber(hex:sub(1,2), 16)
        local g = tonumber(hex:sub(3,4), 16)
        local b = tonumber(hex:sub(5,6), 16)
        if r and g and b then
            return Color3.fromRGB(r, g, b), hex
        end
    end
    return nil, nil
end

-- HSV to RGB conversion
local function HSVtoRGB(h, s, v)
    local r, g, b
    local i = math.floor(h * 6)
    local f = h * 6 - i
    local p = v * (1 - s)
    local q = v * (1 - f * s)
    local t = v * (1 - (1 - f) * s)
    i = i % 6
    if i == 0 then r, g, b = v, t, p
    elseif i == 1 then r, g, b = q, v, p
    elseif i == 2 then r, g, b = p, v, t
    elseif i == 3 then r, g, b = p, q, v
    elseif i == 4 then r, g, b = t, p, v
    elseif i == 5 then r, g, b = v, p, q
    end
    return Color3.new(r, g, b)
end

-- Color Picker Component (compact, Beep style)
-- Only calls callback and shows notification when OK is pressed
function UI:CreateColorPicker(parent, text, configSection, configKey, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 42), BackgroundColor3 = Color3.fromRGB(18, 18, 24), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    UI:Create("UIStroke", {Color = Color3.fromRGB(32, 32, 40), Thickness = 1, Transparency = 0.4, Parent = Frame})
    
    UI:Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 14, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(225, 226, 232), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    
    local currentColor = Config[configSection][configKey]
    local currentHue, currentSat, currentVal = 0, 1, 1
    local previewColor = currentColor -- Color while dragging (not applied yet)
    
    -- Color preview button (click to open picker)
    local ColorBtn = UI:Create("TextButton", {
        Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(1, -40, 0.5, -13),
        BackgroundColor3 = currentColor, Text = "", ZIndex = 5, Parent = Frame
    })
    Instance.new("UICorner", ColorBtn).CornerRadius = UDim.new(0, 6)
    UI:Create("UIStroke", {Color = Color3.fromRGB(60, 60, 70), Thickness = 1, Parent = ColorBtn})
    
    local pickerOpen = false
    local PickerFrame = nil
    
    -- Apply color only when OK is pressed
    local function applyColor(color)
        Config[configSection][configKey] = color
        ColorBtn.BackgroundColor3 = color
        currentColor = color
        -- If it's Theme/Accent, refresh all accent elements
        if configKey == "Accent" then
            RefreshAccent(color)
        end
        if callback then callback(color) end
        UI:Notify("Color changed")
    end
    
    local function closePicker(apply)
        if apply and previewColor then
            applyColor(previewColor)
        end
        if PickerFrame then PickerFrame:Destroy() PickerFrame = nil end
        pickerOpen = false
    end
    
    ColorBtn.MouseButton1Click:Connect(function()
        if pickerOpen then closePicker(false) return end
        pickerOpen = true
        previewColor = currentColor
        
        local btnPos = ColorBtn.AbsolutePosition
        
        -- Picker popup
        PickerFrame = UI:Create("Frame", {
            Size = UDim2.new(0, 180, 0, 160),
            Position = UDim2.new(0, btnPos.X - 150, 0, btnPos.Y + 30),
            BackgroundColor3 = Color3.fromRGB(20, 20, 26),
            ZIndex = 200, Parent = UI.Screen
        })
        Instance.new("UICorner", PickerFrame).CornerRadius = UDim.new(0, 8)
        UI:Create("UIStroke", {Color = Color3.fromRGB(50, 50, 60), Thickness = 1, Parent = PickerFrame})
        
        -- Saturation/Value box (100x100)
        local SVBox = UI:Create("ImageLabel", {
            Size = UDim2.new(0, 100, 0, 100), Position = UDim2.new(0, 10, 0, 10),
            BackgroundColor3 = HSVtoRGB(currentHue, 1, 1),
            Image = "rbxassetid://4155801252", ZIndex = 201, Parent = PickerFrame
        })
        Instance.new("UICorner", SVBox).CornerRadius = UDim.new(0, 4)
        
        -- SV cursor
        local SVCursor = UI:Create("Frame", {
            Size = UDim2.new(0, 10, 0, 10), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(currentSat, 0, 1 - currentVal, 0),
            BackgroundColor3 = Color3.new(1,1,1), ZIndex = 202, Parent = SVBox
        })
        Instance.new("UICorner", SVCursor).CornerRadius = UDim.new(1, 0)
        UI:Create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 2, Parent = SVCursor})
        
        -- Hue bar (vertical)
        local HueBar = UI:Create("Frame", {
            Size = UDim2.new(0, 20, 0, 100), Position = UDim2.new(0, 120, 0, 10),
            ZIndex = 201, Parent = PickerFrame
        })
        Instance.new("UICorner", HueBar).CornerRadius = UDim.new(0, 4)
        UI:Create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0))
            }), Rotation = 90, Parent = HueBar
        })
        
        -- Hue cursor
        local HueCursor = UI:Create("Frame", {
            Size = UDim2.new(1, 4, 0, 6), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, currentHue, 0),
            BackgroundColor3 = Color3.new(1,1,1), ZIndex = 202, Parent = HueBar
        })
        Instance.new("UICorner", HueCursor).CornerRadius = UDim.new(0, 2)
        UI:Create("UIStroke", {Color = Color3.new(0,0,0), Thickness = 1, Parent = HueCursor})
        
        -- HEX input
        local hexStr = string.format("%02X%02X%02X", math.floor(currentColor.R*255), math.floor(currentColor.G*255), math.floor(currentColor.B*255))
        local HexInput = UI:Create("TextBox", {
            Size = UDim2.new(0, 70, 0, 24), Position = UDim2.new(0, 10, 0, 120),
            BackgroundColor3 = Color3.fromRGB(30, 30, 38), Text = hexStr,
            TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 11,
            ClearTextOnFocus = false, ZIndex = 201, Parent = PickerFrame
        })
        Instance.new("UICorner", HexInput).CornerRadius = UDim.new(0, 4)
        
        -- Preview
        local Preview = UI:Create("Frame", {
            Size = UDim2.new(0, 30, 0, 24), Position = UDim2.new(0, 85, 0, 120),
            BackgroundColor3 = currentColor, ZIndex = 201, Parent = PickerFrame
        })
        Instance.new("UICorner", Preview).CornerRadius = UDim.new(0, 4)
        
        -- OK button (applies the color)
        local OKBtn = UI:Create("TextButton", {
            Size = UDim2.new(0, 40, 0, 24), Position = UDim2.new(0, 130, 0, 120),
            BackgroundColor3 = Color3.fromRGB(60, 140, 60), Text = "OK",
            TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 10,
            ZIndex = 201, Parent = PickerFrame
        })
        Instance.new("UICorner", OKBtn).CornerRadius = UDim.new(0, 4)
        OKBtn.MouseButton1Click:Connect(function()
            closePicker(true) -- Apply color on OK
        end)
        
        -- Update preview only (not applied until OK)
        local function updatePreview()
            local color = HSVtoRGB(currentHue, currentSat, currentVal)
            SVBox.BackgroundColor3 = HSVtoRGB(currentHue, 1, 1)
            Preview.BackgroundColor3 = color
            HexInput.Text = string.format("%02X%02X%02X", math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255))
            previewColor = color
        end
        
        -- SV drag
        local draggingSV = false
        SVBox.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = true end
        end)
        SVBox.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSV = false end
        end)
        
        -- Hue drag
        local draggingHue = false
        HueBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end
        end)
        HueBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = false end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                if draggingSV then
                    local x = math.clamp((input.Position.X - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
                    local y = math.clamp((input.Position.Y - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
                    currentSat = x
                    currentVal = 1 - y
                    SVCursor.Position = UDim2.new(x, 0, y, 0)
                    updatePreview()
                end
                if draggingHue then
                    local y = math.clamp((input.Position.Y - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                    currentHue = y
                    HueCursor.Position = UDim2.new(0.5, 0, y, 0)
                    updatePreview()
                end
            end
        end)
        
        HexInput.FocusLost:Connect(function()
            local color, hex = ParseHexColor(HexInput.Text)
            if color and hex then
                HexInput.Text = hex
                Preview.BackgroundColor3 = color
                previewColor = color
            end
        end)
    end)
    
    if configKey == "Accent" or configKey == "ESPColor" then
        RegisterAccent(function(c)
            if configKey == "Accent" then
                ColorBtn.BackgroundColor3 = c
            end
        end)
    end
end

-- Backwards compatibility alias
function UI:CreateColorInput(parent, text, configSection, configKey, callback)
    return UI:CreateColorPicker(parent, text, configSection, configKey, callback)
end

-- Combat System
local Combat = {}
function Combat:GetClosestPlayer()
    local closest = nil
    local shortestDistance = Config.Combat.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            -- Try to find the selected target part ONLY
            local part = player.Character:FindFirstChild(Config.Combat.TargetPart)
            
            -- Only use fallback if the configured part doesn't exist
            if not part then
                part = player.Character:FindFirstChild("Head")
                    or player.Character:FindFirstChild("UpperTorso")
                    or player.Character:FindFirstChild("Torso")
                    or player.Character:FindFirstChild("HumanoidRootPart")
                    or player.Character:FindFirstChildOfClass("MeshPart")
            end
            
            -- Skip players in the void (Y < -40)
            if part and part.Position.Y >= -40 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
                    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (mousePos - targetPos).Magnitude
                    if distance < shortestDistance then
                        closest = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closest
end

function Combat:IsTargetValid(target)
    if not target or not target.Character then return false end
    local hum = target.Character:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    
    -- Try to find the selected target part ONLY
    local part = target.Character:FindFirstChild(Config.Combat.TargetPart)
    
    -- Only use fallback if the configured part doesn't exist
    if not part then
        part = target.Character:FindFirstChild("Head")
            or target.Character:FindFirstChild("UpperTorso")
            or target.Character:FindFirstChild("Torso")
            or target.Character:FindFirstChild("HumanoidRootPart")
            or target.Character:FindFirstChildOfClass("MeshPart")
    end
    
    if not part then return false end
    
    -- Skip players in the void (Y < -40)
    if part.Position.Y < -40 then return false end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end
    
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
    local distance = (mousePos - targetPos).Magnitude
    
    return distance <= Config.Combat.FOV
end

-- Universal Shooting Function (Maximum Performance)
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local lastShootTime = 0

local function Shoot()
    -- Check Ultra Rapid Fire delay
    local currentTime = tick()
    if Config.Combat.UltraRapidFire then
        if currentTime - lastShootTime < Config.Combat.UltraRapidFireDelay then
            return -- Too soon, skip this shot
        end
    end
    lastShootTime = currentTime
    
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        -- Method 1: Tool Activation (fastest and most reliable)
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Handle") then
            tool:Activate()
            task.wait(0.05)
            tool:Deactivate()
            return
        end
        
        -- Method 2: VirtualInputManager (most compatible)
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end)
        
        -- Method 3: VirtualUser fallback
        pcall(function()
            VirtualUser:Button1Down(Vector2.new(0, 0))
            task.wait(0.05)
            VirtualUser:Button1Up(Vector2.new(0, 0))
        end)
    end)
end

-- Universal Team Detection System
local function IsEnemy(player, useTeamCheck)
    if player == LocalPlayer then return false end
    
    -- If team check is disabled, everyone is an enemy
    if not useTeamCheck then return true end
    
    -- Method 1: Check Roblox Teams
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team ~= player.Team
    end
    
    -- Method 2: Check for common team indicators in character
    local myChar = LocalPlayer.Character
    local theirChar = player.Character
    if myChar and theirChar then
        -- Check for team-colored parts (common in many games)
        local myTeamPart = myChar:FindFirstChild("TeamColor") or myChar:FindFirstChild("Team")
        local theirTeamPart = theirChar:FindFirstChild("TeamColor") or theirChar:FindFirstChild("Team")
        
        if myTeamPart and theirTeamPart then
            if myTeamPart:IsA("StringValue") or myTeamPart:IsA("IntValue") then
                return myTeamPart.Value ~= theirTeamPart.Value
            end
        end
    end
    
    -- Method 3: Check player attributes (used in some games)
    local myTeamAttr = LocalPlayer:GetAttribute("Team") or LocalPlayer:GetAttribute("TeamID")
    local theirTeamAttr = player:GetAttribute("Team") or player:GetAttribute("TeamID")
    if myTeamAttr and theirTeamAttr then
        return myTeamAttr ~= theirTeamAttr
    end
    
    -- Method 4: Check character name color (some games use this)
    if myChar and theirChar then
        local myHead = myChar:FindFirstChild("Head")
        local theirHead = theirChar:FindFirstChild("Head")
        if myHead and theirHead then
            local myNameTag = myHead:FindFirstChildOfClass("BillboardGui")
            local theirNameTag = theirHead:FindFirstChildOfClass("BillboardGui")
            if myNameTag and theirNameTag then
                local myLabel = myNameTag:FindFirstChildOfClass("TextLabel")
                local theirLabel = theirNameTag:FindFirstChildOfClass("TextLabel")
                if myLabel and theirLabel then
                    return myLabel.TextColor3 ~= theirLabel.TextColor3
                end
            end
        end
    end
    
    -- Default: If no team system detected, everyone is enemy
    return true
end

-- Lock/Unlock Target System
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not UI.Active or gameProcessed then return end
    
    -- Target Lock Toggle
    if input.KeyCode.Name == Config.Combat.LockKey then
        if Config.Combat.LockedTarget then
            Config.Combat.LockedTarget = nil
            UI:Notify("Target Unlocked")
        else
            local target = Combat:GetClosestPlayer()
            if target then
                -- Check if it's an enemy before locking
                if not IsEnemy(target, Config.Combat.TeamCheck) then
                    UI:Notify("Cannot lock teammate")
                    return
                end
                Config.Combat.LockedTarget = target
                UI:Notify("Target Locked: " .. target.DisplayName)
            else
                UI:Notify("No target in FOV")
            end
        end
    end
    
    -- Speed Hack Toggle (only works if SpeedEnabled is ON in menu)
    if input.KeyCode.Name == Config.Physics.SpeedKey then
        if Config.Physics.SpeedEnabled then
            Config.Physics.SpeedActive = not Config.Physics.SpeedActive
            UI:Notify(Config.Physics.SpeedActive and "Speed: ON" or "Speed: OFF")
        end
    end
end)

local lastAimShootTime = 0
local aimHoldActive = false
local currentAimTarget = nil        -- Track current aim target for switcher
local lastAimTargetHealth = nil     -- Track health to detect kills
local targetSwitchCooldown = 0      -- Cooldown to prevent spam switching

-- Hold to Aim Input Handler
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not UI.Active or not Config.Combat.HoldToAim then return end
    
    -- Check if it's the aim hold key
    if (Config.Combat.AimHoldKey == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2) or
       (Config.Combat.AimHoldKey ~= "MouseButton2" and input.KeyCode.Name == Config.Combat.AimHoldKey) then
        aimHoldActive = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if not UI.Active then return end
    
    -- Release aim hold key
    if (Config.Combat.AimHoldKey == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2) or
       (Config.Combat.AimHoldKey ~= "MouseButton2" and input.KeyCode.Name == Config.Combat.AimHoldKey) then
        aimHoldActive = false
    end
end)

RunService.RenderStepped:Connect(function()
    if not UI.Active then return end
    
    -- TARGET SWITCHER: Check if current aim target died
    if Config.Combat.TargetSwitcher and currentAimTarget and tick() >= targetSwitchCooldown then
        pcall(function()
            if currentAimTarget.Character then
                local hum = currentAimTarget.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- Target died or very low HP → force switch
                    if hum.Health <= 0 or (lastAimTargetHealth and hum.Health < lastAimTargetHealth and hum.Health <= 10) then
                        -- Clear locked target to force new search
                        if Config.Combat.LockedTarget == currentAimTarget then
                            Config.Combat.LockedTarget = nil
                        end
                        currentAimTarget = nil
                        lastAimTargetHealth = nil
                        targetSwitchCooldown = tick() + Config.Combat.TargetSwitcherDelay
                        UI:Notify("Target eliminated - switching...")
                    else
                        lastAimTargetHealth = hum.Health
                    end
                end
            else
                -- Character disappeared
                currentAimTarget = nil
                lastAimTargetHealth = nil
            end
        end)
    end
    
    -- Only aim if: SilentAim is ON AND (HoldToAim is OFF OR hold key is pressed)
    local shouldAim = Config.Combat.SilentAim and (not Config.Combat.HoldToAim or aimHoldActive)
    
    if shouldAim then
        local target = nil
        
        -- Check if we have a locked target and if it's still valid
        if Config.Combat.LockedTarget then
            if Combat:IsTargetValid(Config.Combat.LockedTarget) then
                target = Config.Combat.LockedTarget
            else
                Config.Combat.LockedTarget = nil
                currentAimTarget = nil
                lastAimTargetHealth = nil
                UI:Notify("Target Lost")
            end
        else
            -- No locked target, get closest player
            target = Combat:GetClosestPlayer()
        end
        
        -- Update current target for switcher
        if target ~= currentAimTarget then
            currentAimTarget = target
            lastAimTargetHealth = nil
            if target and target.Character then
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                if hum then lastAimTargetHealth = hum.Health end
            end
        end
        
        if target and target.Character then
            -- Verify it's an enemy
            if IsEnemy(target, Config.Combat.TeamCheck) then
                -- Try to find the selected target part FIRST, no fallbacks unless not found
                local targetPart = nil
                local selectedPart = Config.Combat.TargetPart
                
                -- Try exact match first
                targetPart = target.Character:FindFirstChild(selectedPart)
                
                -- If not found, try fallbacks (for games with different part names)
                if not targetPart then
                    if selectedPart == "Head" then
                        targetPart = target.Character:FindFirstChild("Head")
                    elseif selectedPart == "UpperTorso" then
                        targetPart = target.Character:FindFirstChild("UpperTorso") 
                            or target.Character:FindFirstChild("Torso")
                    elseif selectedPart == "Torso" then
                        targetPart = target.Character:FindFirstChild("Torso")
                            or target.Character:FindFirstChild("UpperTorso")
                    elseif selectedPart == "HumanoidRootPart" then
                        targetPart = target.Character:FindFirstChild("HumanoidRootPart")
                    end
                end
                
                -- Final fallback if still nothing found
                if not targetPart then
                    targetPart = target.Character:FindFirstChild("Head")
                        or target.Character:FindFirstChild("UpperTorso")
                        or target.Character:FindFirstChild("Torso")
                        or target.Character:FindFirstChild("HumanoidRootPart")
                        or target.Character:FindFirstChildOfClass("MeshPart")
                end
                
                if targetPart then
                    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                    Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Config.Combat.Smoothness * 0.1)
                end
            end
        end
    end
end)

-- No Recoil System
local originalCameraCFrame = Camera.CFrame
RunService.RenderStepped:Connect(function()
    if Config.Combat.NoRecoil and UI.Active then
        -- Store camera position before recoil
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Tool") then
            originalCameraCFrame = Camera.CFrame
        end
    end
end)

-- ===== RAGEBOT SYSTEM =====
-- Aggressive aimbot: targets any player on the whole map, snaps to target, auto-fires.
-- Works best in client-sided hit detection games (e.g. Arsenal).
local Ragebot = {}

-- Per-game profiles. These tune the strategy; the universal core (camera snap)
-- works on any game whose guns raycast from the camera.
-- Note: For auto-shoot, enable Triggerbot (works with Ragebot)
-- NOTE: 'part' is now always taken from Config.Combat.RagebotTargetPart (user choice)
local GameProfiles = {
    ["Universal"] = {visible = false, prediction = 0,  fireMethod = "auto", faceTarget = true},
    ["Rivals"]    = {visible = false, prediction = 0,  fireMethod = "hold", faceTarget = true},
    ["Arsenal"]   = {visible = false, prediction = 0,  fireMethod = "hold", faceTarget = false},
    ["Jailbreak"] = {visible = true,  prediction = 2,  fireMethod = "tool", faceTarget = true},
}

-- Detect the game once (by name) for the "Auto" profile
local detectedProfile = "Universal"
pcall(function()
    local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    local n = (info and info.Name or ""):lower()
    if n:find("rival") then detectedProfile = "Rivals"
    elseif n:find("arsenal") then detectedProfile = "Arsenal"
    elseif n:find("jailbreak") or n:find("jail break") then detectedProfile = "Jailbreak" end
end)

-- Resolve the effective settings based on the selected profile
local function ragebotSettings()
    local prof = Config.Combat.RagebotGameProfile
    if prof == "Manual" then
        return {
            part = Config.Combat.RagebotTargetPart,
            visible = Config.Combat.RagebotVisibleCheck,
            prediction = Config.Combat.RagebotPrediction,
            fireMethod = "auto",
            faceTarget = Config.Combat.RagebotFaceTarget,
        }
    end
    if prof == "Auto" then prof = detectedProfile end
    local profile = GameProfiles[prof] or GameProfiles["Universal"]
    -- Always use user's selected target part
    profile.part = Config.Combat.RagebotTargetPart
    return profile
end

local function getRagebotPart(char, partName)
    -- Try to find the specified part ONLY
    local part = char:FindFirstChild(partName or Config.Combat.RagebotTargetPart)
    
    -- Only use fallback if the configured part doesn't exist
    if not part then
        part = char:FindFirstChild("Head")
            or char:FindFirstChild("HumanoidRootPart")
            or char:FindFirstChild("UpperTorso")
            or char:FindFirstChild("Torso")
            or char:FindFirstChildWhichIsA("BasePart")
    end
    
    return part
end

local function ragebotVisible(part, character)
    local origin = Camera.CFrame.Position
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(origin, (part.Position - origin), params)
    if not result then return true end
    return result.Instance:IsDescendantOf(character)
end

function Ragebot:GetTarget()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))
    if not myRoot then return nil end

    local settings = ragebotSettings()
    local best, bestScore
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local mode = Config.Combat.RagebotMode

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local part = getRagebotPart(player.Character, settings.part)
            -- Skip players with spawn protection (ForceField = immune, can't be damaged)
            local immune = Config.Combat.RagebotIgnoreImmune and player.Character:FindFirstChildOfClass("ForceField") ~= nil
            -- Skip players in the void (falling/dead) - Y position < -40
            local inVoid = part and part.Position.Y < -40
            
            if hum and hum.Health > 0 and part and not immune and not inVoid and IsEnemy(player, Config.Combat.RagebotTeamCheck) then
                local dist = (part.Position - myRoot.Position).Magnitude
                if dist <= Config.Combat.RagebotMaxDistance then
                    -- On-screen filter (only if Full Map is off)
                    local passScreen = true
                    if not Config.Combat.RagebotFullMap then
                        local _, onScreen = Camera:WorldToViewportPoint(part.Position)
                        passScreen = onScreen
                    end
                    -- Visible (wall) filter (from profile)
                    local passVisible = true
                    if settings.visible then
                        passVisible = ragebotVisible(part, player.Character)
                    end
                    if passScreen and passVisible then
                        local score
                        if mode == "Lowest Health" then
                            score = hum.Health
                        elseif mode == "Crosshair" then
                            local sp = Camera:WorldToViewportPoint(part.Position)
                            score = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                        else -- Closest
                            score = dist
                        end
                        if not bestScore or score < bestScore then
                            bestScore = score
                            best = part
                        end
                    end
                end
            end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function(dt)
    if not UI.Active or not Config.Combat.Ragebot then
        return
    end
    
    -- Get best target based on mode (Closest/Lowest HP/Crosshair)
    local target = Ragebot:GetTarget()
    
    if not target then
        return
    end

    local settings = ragebotSettings()
    local aimPos = target.Position
    
    -- Prediction for projectile weapons (from active profile)
    if settings.prediction > 0 then
        local vel = target.AssemblyLinearVelocity
        aimPos = aimPos + (vel * (settings.prediction / 100))
    end

    -- Face the target with the body so the GUN/character points at the enemy
    -- (critical for games like Rivals where bullets fire from the character, not the camera)
    if settings.faceTarget and not Config.Combat.RagebotAutoTP then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local flat = Vector3.new(target.Position.X, myRoot.Position.Y, target.Position.Z)
            myRoot.CFrame = CFrame.new(myRoot.Position, flat)
        end
    end

    -- Auto teleport / fly to the target
    if Config.Combat.RagebotAutoTP then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
        if myRoot then
            local offset = Config.Combat.RagebotTPOffset
            -- desired position: a few studs away from the target on our side
            local fromDir = (myRoot.Position - target.Position)
            if fromDir.Magnitude < 0.1 then fromDir = Vector3.new(0, 0, 1) end
            local goalPos = target.Position + (fromDir.Unit * offset)

            if Config.Combat.RagebotTPMode == "Teleport" then
                -- Instant teleport next to the target (upright, facing the enemy)
                local flat = Vector3.new(target.Position.X, goalPos.Y, target.Position.Z)
                myRoot.CFrame = CFrame.new(goalPos, flat)
                pcall(function() myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
            else
                -- Fly: move toward the target at high speed (upright, facing the enemy)
                local toGoal = (goalPos - myRoot.Position)
                local dist = toGoal.Magnitude
                if dist > 0.5 then
                    local step = math.min(Config.Combat.RagebotTPSpeed * dt, dist)
                    local newPos = myRoot.Position + (toGoal.Unit * step)
                    local flat = Vector3.new(target.Position.X, newPos.Y, target.Position.Z)
                    myRoot.CFrame = CFrame.new(newPos, flat)
                    pcall(function() myRoot.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
                end
            end
        end
    end

    -- Snap camera to target (this is what registers hits in client-sided games)
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
    
    -- Note: For auto-shoot with Ragebot, enable Triggerbot
    -- The Triggerbot will handle shooting when aimed at target
end)

-- ===== RAGEBOT NOCLIP (with collision restore) =====
-- Disables collisions while Ragebot+NoClip are active, and restores them when turned off
-- so the player doesn't fall through the map.
local ragebotNoclipParts = {}
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local want = UI.Active and Config.Combat.Ragebot and Config.Combat.RagebotNoClip
    if want then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = false
                ragebotNoclipParts[p] = true
            end
        end
    elseif next(ragebotNoclipParts) then
        for p in pairs(ragebotNoclipParts) do
            if p and p.Parent then pcall(function() p.CanCollide = true end) end
        end
        ragebotNoclipParts = {}
    end
end)

-- ===== PANIC KEY =====
-- Instantly disables all aggressive/movement features.
-- Ignores gameProcessed on purpose, so it works even with the Roblox menu/chat open.
UserInputService.InputBegan:Connect(function(input)
    if not UI.Active then return end
    if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode.Name == Config.Misc.PanicKey then
        Config.Combat.Ragebot = false
        Config.Combat.RagebotAutoShoot = false
        Config.Combat.RagebotAutoTP = false
        Config.Combat.KillAura = false
        Config.Combat.SilentAim = false
        Config.Combat.Triggerbot = false
        Config.Physics.SpeedActive = false
        Config.Physics.FlyActive = false
        Config.Physics.NoClipActive = false
        -- Refresh menu visuals
        pcall(function()
            UI:UpdateToggle("Combat", "Ragebot", false)
            UI:UpdateToggle("Combat", "RagebotAutoShoot", false)
            UI:UpdateToggle("Combat", "RagebotAutoTP", false)
            UI:UpdateToggle("Combat", "KillAura", false)
            UI:UpdateToggle("Combat", "SilentAim", false)
            UI:UpdateToggle("Combat", "Triggerbot", false)
        end)
        UI:Notify("PANIC: all combat & movement disabled")
    end
end)



-- No Spread System (Client-side visual only - actual spread is server-side)
-- This prevents visual spread by stabilizing aim
local spreadCompensation = Vector3.new(0, 0, 0)
RunService.Heartbeat:Connect(function()
    if Config.Combat.NoSpread and UI.Active then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                -- Reset any spread-related properties if they exist
                pcall(function()
                    if tool:FindFirstChild("Spread") then
                        tool.Spread.Value = 0
                    end
                    if tool:FindFirstChild("MaxSpread") then
                        tool.MaxSpread.Value = 0
                    end
                end)
            end
        end
    end
end)

-- Auto Reload System
RunService.Heartbeat:Connect(function()
    if Config.Combat.AutoReload and UI.Active then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool then
                -- Check for common ammo/reload properties
                pcall(function()
                    -- Method 1: Check for Ammo value
                    local ammo = tool:FindFirstChild("Ammo") or tool:FindFirstChild("CurrentAmmo")
                    if ammo and ammo:IsA("IntValue") or ammo and ammo:IsA("NumberValue") then
                        if ammo.Value <= 0 then
                            -- Try to reload
                            if tool:FindFirstChild("Reload") then
                                tool.Reload:FireServer()
                            end
                            -- Press R key as backup
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                task.wait(0.05)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, game)
                            end)
                        end
                    end
                    
                    -- Method 2: Check for Magazine value
                    local mag = tool:FindFirstChild("Magazine") or tool:FindFirstChild("Mag")
                    if mag and (mag:IsA("IntValue") or mag:IsA("NumberValue")) then
                        if mag.Value <= 0 then
                            pcall(function()
                                game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.R, false, game)
                                task.wait(0.05)
                                game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.R, false, game)
                            end)
                        end
                    end
                end)
            end
        end
    end
end)

-- Triggerbot System (Automatic & Fast - Respects Rapid Fire)
local lastTriggerTime = 0
local isAimingAtEnemy = false

task.spawn(function()
    while task.wait(0.05) do -- Check every 50ms (20 times per second) - Much faster!
        if UI.Active and Config.Combat.Triggerbot then
            -- Direct, fast checks - no pcall overhead
            local char = LocalPlayer.Character
            if not char then 
                isAimingAtEnemy = false
                continue 
            end
            
            local mouseTarget = Mouse.Target
            if not mouseTarget then 
                isAimingAtEnemy = false
                continue 
            end
            
            -- Extra check: Must be a BasePart belonging to a character
            if not mouseTarget:IsA("BasePart") then
                isAimingAtEnemy = false
                continue
            end
            
            local targetChar = mouseTarget:FindFirstAncestorOfClass("Model")
            if not targetChar then 
                isAimingAtEnemy = false
                continue 
            end
            
            -- Must have a Humanoid to be a valid character
            local hum = targetChar:FindFirstChildOfClass("Humanoid")
            if not hum then
                isAimingAtEnemy = false
                continue
            end
            
            local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
            if not targetPlayer or targetPlayer == LocalPlayer then 
                isAimingAtEnemy = false
                continue 
            end
            
            if not IsEnemy(targetPlayer, Config.Combat.TeamCheck) then 
                isAimingAtEnemy = false
                continue 
            end
            
            if hum.Health <= 0 then 
                isAimingAtEnemy = false
                continue 
            end
            
            -- We're aiming at an enemy! Shoot automatically
            isAimingAtEnemy = true
            local currentTime = tick()
            
            -- Use Ultra Rapid Fire delay if enabled, otherwise use Trigger Delay
            local fireDelay = Config.Combat.UltraRapidFire and Config.Combat.UltraRapidFireDelay or Config.Combat.TriggerDelay
            
            if currentTime - lastTriggerTime >= fireDelay then
                Shoot()
                lastTriggerTime = currentTime
            end
        else
            isAimingAtEnemy = false
        end
    end
end)

-- NoClip Toggle Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not UI.Active or gameProcessed then return end
    
    if input.KeyCode.Name == Config.Misc.NoClipToggleKey then
        -- Only works if NoClip system is enabled in menu
        if Config.Physics.NoClip then
            Config.Physics.NoClipActive = not Config.Physics.NoClipActive
            UI:Notify(Config.Physics.NoClipActive and "NoClip: ON" or "NoClip: OFF")
        end
    end
end)

-- ESP System
local Visuals = {}
local ESPObjects = {} -- Track all ESP objects for cleanup

local function apply3DChams(part)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
    box.Color3 = Config.Visuals.Accent
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.4
    box.Adornee = part
    box.Parent = part
    box.Visible = false
    table.insert(ESPObjects, box)
    return box
end

function Visuals:DrawESPOnCharacter(player)
    if player == LocalPlayer then return end
    
    local function setupCharacter(char)
        local head = char:WaitForChild("Head", 10) or char:FindFirstChildOfClass("MeshPart") or char:WaitForChild("HumanoidRootPart", 10)
        if not head then return end
        
        local bGui = UI:Create("BillboardGui", {Size = UDim2.new(0, 150, 0, 40), StudsOffset = Vector3.new(0, 3, 0), AlwaysOnTop = true, ResetOnSpawn = true, Enabled = false, Parent = head})
        local label = UI:Create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = Color3.new(1, 1, 1), Font = Enum.Font.GothamBold, TextSize = 11, TextStrokeTransparency = 0.5, Text = "", Parent = bGui})
        
        table.insert(ESPObjects, bGui)
        
        -- Head Dot (Only for ENEMIES)
        local headDot = nil
        local headDotFrame = nil
        task.spawn(function()
            local headPart = char:WaitForChild("Head", 10)
            if headPart then
                headDot = UI:Create("BillboardGui", {
                    Size = UDim2.new(0, 10, 0, 10), 
                    StudsOffset = Vector3.new(0, 0, 0), 
                    AlwaysOnTop = true,
                    Enabled = false,
                    Parent = headPart
                })
                headDotFrame = UI:Create("Frame", {
                    Size = UDim2.new(1, 0, 1, 0), 
                    BackgroundColor3 = Config.Visuals.ESPColor, 
                    BorderSizePixel = 0, 
                    Parent = headDot
                })
                Instance.new("UICorner", headDotFrame).CornerRadius = UDim.new(1, 0)
                table.insert(ESPObjects, headDot)
            end
        end)
        
        local trackingParts = {}
        local function scanParts(rootPart)
            for _, obj in pairs(rootPart:GetChildren()) do
                if obj:IsA("BasePart") or obj:IsA("MeshPart") then
                    table.insert(trackingParts, apply3DChams(obj))
                end
            end
        end
        scanParts(char)
        
        task.spawn(function()
            while bGui.Parent and char:IsDescendantOf(Workspace) and UI.Active do
                local visualsEnabled = Config.Visuals.Enabled
                
                -- Control BillboardGui visibility
                bGui.Enabled = visualsEnabled
                
                -- Update Head Dot visibility (ONLY for enemies)
                if headDot then
                    local isEnemyForDot = IsEnemy(player, true)
                    headDot.Enabled = visualsEnabled and Config.Visuals.HeadDot and isEnemyForDot
                    -- Update head dot color to match ESP color
                    if headDotFrame then
                        headDotFrame.BackgroundColor3 = Config.Visuals.ESPColor
                    end
                end
                
                -- Check if player is enemy for color coding
                local isEnemy = IsEnemy(player, true) -- Always check teams
                local espColor = isEnemy and Config.Visuals.ESPColor or Color3.fromRGB(80, 255, 120) -- Custom color for enemies, Green for teammates
                
                -- Update 3D Chams color based on team
                for _, box in pairs(trackingParts) do
                    if box and box.Parent then
                        box.Visible = visualsEnabled and Config.Visuals.Skeletons
                        box.Color3 = espColor
                    end
                end
                
                if visualsEnabled then
                    local rootPart = char:FindFirstChild("HumanoidRootPart") or head
                    local distance = math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude)
                    local text = player.DisplayName
                    
                    -- Add distance if enabled
                    if Config.Visuals.Distance then
                        text = text .. " [" .. distance .. "m]"
                    end
                    
                    -- Add ID if enabled
                    if Config.Visuals.IDs then 
                        text = text .. "\n[" .. player.UserId .. "]"
                    end
                    
                    -- Names and IDs always white
                    label.TextColor3 = Color3.new(1, 1, 1)
                    
                    if Config.Visuals.Names then 
                        label.Text = text 
                    else 
                        label.Text = "" 
                    end
                else
                    label.Text = ""
                end
                task.wait(0.1)
            end
        end)
    end
    
    if player.Character then task.spawn(function() setupCharacter(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setupCharacter(char) end) end)
end

for _, p in pairs(Players:GetPlayers()) do Visuals:DrawESPOnCharacter(p) end
Players.PlayerAdded:Connect(function(p) Visuals:DrawESPOnCharacter(p) end)

-- Tracers System
local TracerConnections = {}

local function CreateTracer(player)
    if player == LocalPlayer then return end
    
    local function setupTracer(char)
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        
        local line = Drawing.new("Line")
        line.Visible = false
        line.Color = Color3.new(Config.Visuals.Accent.R, Config.Visuals.Accent.G, Config.Visuals.Accent.B)
        line.Thickness = 1
        line.Transparency = 1
        
        local connection = RunService.RenderStepped:Connect(function()
            if not UI.Active or not char:IsDescendantOf(Workspace) or not rootPart.Parent then
                line:Remove()
                connection:Disconnect()
                return
            end
            
            if Config.Visuals.Enabled and Config.Visuals.Tracers then
                -- Update color based on team
                local isEnemy = IsEnemy(player, true)
                local espColor = isEnemy and Config.Visuals.ESPColor or Color3.fromRGB(80, 255, 120)
                line.Color = Color3.new(espColor.R, espColor.G, espColor.B)
                
                local screenPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
                if onScreen then
                    local screenSize = Camera.ViewportSize
                    line.From = Vector2.new(screenSize.X / 2, screenSize.Y)
                    line.To = Vector2.new(screenPos.X, screenPos.Y)
                    line.Visible = true
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
        end)
        
        table.insert(TracerConnections, {line = line, connection = connection})
    end
    
    if player.Character then task.spawn(function() setupTracer(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setupTracer(char) end) end)
end

for _, p in pairs(Players:GetPlayers()) do CreateTracer(p) end
Players.PlayerAdded:Connect(function(p) CreateTracer(p) end)

-- Health Bars System
local function CreateHealthBar(player)
    if player == LocalPlayer then return end
    
    local function setupHealthBar(char)
        local head = char:WaitForChild("Head", 10)
        local hum = char:WaitForChild("Humanoid", 10)
        if not head or not hum then return end
        
        local billboardGui = Instance.new("BillboardGui", head)
        billboardGui.Size = UDim2.new(4, 0, 0.5, 0)
        billboardGui.StudsOffset = Vector3.new(0, 4, 0)
        billboardGui.AlwaysOnTop = true
        billboardGui.Enabled = false
        
        local frame = Instance.new("Frame", billboardGui)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
        frame.BorderSizePixel = 0
        
        local healthBar = Instance.new("Frame", frame)
        healthBar.Size = UDim2.new(1, 0, 1, 0)
        healthBar.BackgroundColor3 = Color3.new(0, 1, 0)
        healthBar.BorderSizePixel = 0
        
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)
        Instance.new("UICorner", healthBar).CornerRadius = UDim.new(0, 4)
        
        task.spawn(function()
            while billboardGui.Parent and char:IsDescendantOf(Workspace) and UI.Active do
                billboardGui.Enabled = Config.Visuals.Enabled and Config.Visuals.HealthBars
                if Config.Visuals.Enabled and Config.Visuals.HealthBars then
                    local healthPercent = hum.Health / hum.MaxHealth
                    healthBar.Size = UDim2.new(healthPercent, 0, 1, 0)
                    healthBar.BackgroundColor3 = Color3.new(1 - healthPercent, healthPercent, 0)
                end
                task.wait(0.1)
            end
            billboardGui:Destroy()
        end)
    end
    
    if player.Character then task.spawn(function() setupHealthBar(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setupHealthBar(char) end) end)
end

for _, p in pairs(Players:GetPlayers()) do CreateHealthBar(p) end
Players.PlayerAdded:Connect(function(p) CreateHealthBar(p) end)

-- Skeleton ESP System
local SkeletonConnections = {}

local function CreateSkeleton(player)
    if player == LocalPlayer then return end
    
    local function setupSkeleton(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        
        -- Define skeleton connections (bones)
        local bones = {
            {from = "Head", to = "UpperTorso"},
            {from = "UpperTorso", to = "LowerTorso"},
            {from = "UpperTorso", to = "LeftUpperArm"},
            {from = "LeftUpperArm", to = "LeftLowerArm"},
            {from = "LeftLowerArm", to = "LeftHand"},
            {from = "UpperTorso", to = "RightUpperArm"},
            {from = "RightUpperArm", to = "RightLowerArm"},
            {from = "RightLowerArm", to = "RightHand"},
            {from = "LowerTorso", to = "LeftUpperLeg"},
            {from = "LeftUpperLeg", to = "LeftLowerLeg"},
            {from = "LeftLowerLeg", to = "LeftFoot"},
            {from = "LowerTorso", to = "RightUpperLeg"},
            {from = "RightUpperLeg", to = "RightLowerLeg"},
            {from = "RightLowerLeg", to = "RightFoot"}
        }
        
        -- R6 fallback bones
        local r6Bones = {
            {from = "Head", to = "Torso"},
            {from = "Torso", to = "Left Arm"},
            {from = "Torso", to = "Right Arm"},
            {from = "Torso", to = "Left Leg"},
            {from = "Torso", to = "Right Leg"}
        }
        
        local lines = {}
        local connections = {}
        
        -- Try R15 first, fallback to R6
        local boneSet = bones
        local isR6 = char:FindFirstChild("Torso") ~= nil
        if isR6 then boneSet = r6Bones end
        
        -- Create lines for each bone
        for _, bone in pairs(boneSet) do
            local line = Drawing.new("Line")
            line.Visible = false
            line.Thickness = 2
            line.Transparency = 1
            table.insert(lines, {line = line, from = bone.from, to = bone.to})
        end
        
        local connection = RunService.RenderStepped:Connect(function()
            if not UI.Active or not char:IsDescendantOf(Workspace) or not hrp.Parent then
                for _, lineData in pairs(lines) do
                    lineData.line:Remove()
                end
                connection:Disconnect()
                return
            end
            
            if Config.Visuals.Enabled and Config.Visuals.SkeletonESP then
                -- Check if it's enemy for color
                local isEnemy = IsEnemy(player, true)
                local skeletonColor = isEnemy and Config.Visuals.ESPColor or Color3.fromRGB(80, 255, 120)
                
                for _, lineData in pairs(lines) do
                    local fromPart = char:FindFirstChild(lineData.from)
                    local toPart = char:FindFirstChild(lineData.to)
                    
                    if fromPart and toPart then
                        local fromPos, fromVis = Camera:WorldToViewportPoint(fromPart.Position)
                        local toPos, toVis = Camera:WorldToViewportPoint(toPart.Position)
                        
                        if fromVis and toVis then
                            lineData.line.From = Vector2.new(fromPos.X, fromPos.Y)
                            lineData.line.To = Vector2.new(toPos.X, toPos.Y)
                            lineData.line.Color = Color3.new(skeletonColor.R, skeletonColor.G, skeletonColor.B)
                            lineData.line.Visible = true
                        else
                            lineData.line.Visible = false
                        end
                    else
                        lineData.line.Visible = false
                    end
                end
            else
                for _, lineData in pairs(lines) do
                    lineData.line.Visible = false
                end
            end
        end)
        
        table.insert(SkeletonConnections, {lines = lines, connection = connection})
    end
    
    if player.Character then task.spawn(function() setupSkeleton(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setupSkeleton(char) end) end)
end

for _, p in pairs(Players:GetPlayers()) do CreateSkeleton(p) end
Players.PlayerAdded:Connect(function(p) CreateSkeleton(p) end)

-- Box ESP 2D System
local BoxConnections = {}

local function CreateBox2D(player)
    if player == LocalPlayer then return end
    
    local function setupBox(char)
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        
        local box = Drawing.new("Square")
        box.Visible = false
        box.Color = Color3.new(Config.Visuals.Accent.R, Config.Visuals.Accent.G, Config.Visuals.Accent.B)
        box.Thickness = 2
        box.Transparency = 1
        box.Filled = false
        
        local connection = RunService.RenderStepped:Connect(function()
            if not UI.Active or not char:IsDescendantOf(Workspace) or not rootPart.Parent then
                box:Remove()
                connection:Disconnect()
                return
            end
            
            if Config.Visuals.Enabled and Config.Visuals.BoxESP then
                -- Check if player is enemy for color coding
                local isEnemy = IsEnemy(player, true) -- Always check teams
                local boxColor = isEnemy and Config.Visuals.ESPColor or Color3.fromRGB(80, 255, 120) -- Custom color for enemies, Green for teammates
                box.Color = boxColor
                
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                if hrp and head then
                    local rootPos, rootVis = Camera:WorldToViewportPoint(hrp.Position)
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    
                    if rootVis then
                        local height = math.abs(headPos.Y - legPos.Y)
                        local width = height / 2
                        
                        box.Size = Vector2.new(width, height)
                        box.Position = Vector2.new(rootPos.X - width / 2, headPos.Y)
                        box.Visible = true
                    else
                        box.Visible = false
                    end
                else
                    box.Visible = false
                end
            else
                box.Visible = false
            end
        end)
        
        table.insert(BoxConnections, {box = box, connection = connection})
    end
    
    if player.Character then task.spawn(function() setupBox(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setupBox(char) end) end)
end

for _, p in pairs(Players:GetPlayers()) do CreateBox2D(p) end
Players.PlayerAdded:Connect(function(p) CreateBox2D(p) end)

-- Fullbright & Remove Fog System
local Lighting = game:GetService("Lighting")
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient
}

RunService.RenderStepped:Connect(function()
    if Config.Misc.Fullbright and UI.Active then
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.Ambient = originalLighting.Ambient
    end
    
    -- Remove Fog
    if Config.Misc.RemoveFog and UI.Active then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    else
        if not Config.Misc.Fullbright then
            Lighting.FogEnd = originalLighting.FogEnd
            Lighting.FogStart = originalLighting.FogStart
        end
    end
end)

-- FOV Changer
RunService.RenderStepped:Connect(function()
    if Config.Misc.FOVChanger and UI.Active then
        Camera.FieldOfView = Config.Misc.FOVValue
    else
        Camera.FieldOfView = 70
    end
end)

-- Infinite Jump (NO COOLDOWN - Bypasses game restrictions)
local InfiniteJumpConnection = nil
local lastJumpTime = 0

InfiniteJumpConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not UI.Active then return end
    if input.KeyCode == Enum.KeyCode.Space and Config.Misc.InfiniteJump then
        local currentTime = tick()
        -- Ultra-fast response time (50ms minimum between jumps)
        if currentTime - lastJumpTime < 0.05 then return end
        lastJumpTime = currentTime
        
        local char = LocalPlayer.Character
        if not char then return end
        
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        
        -- Method 1: Direct State Change (bypasses cooldowns)
        if hum:GetState() ~= Enum.HumanoidStateType.Swimming and hum:GetState() ~= Enum.HumanoidStateType.Climbing then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        
        -- Method 2: Force velocity upwards (bypasses jump restrictions)
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            task.spawn(function()
                local velocity = rootPart.AssemblyLinearVelocity
                rootPart.AssemblyLinearVelocity = Vector3.new(velocity.X, 50, velocity.Z)
            end)
        end
    end
end)

-- Click Teleport System
Mouse.Button1Down:Connect(function()
    if not UI.Active or not Config.Physics.ClickTP then return end
    if not UserInputService:IsKeyDown(Enum.KeyCode[Config.Physics.ClickTPKey]) then return end
    
    local char = LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local targetPos = Mouse.Hit.Position
    rootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
    UI:Notify("Teleported to position")
end)

-- Kill Aura System (Optimized - with Auto Aim + Auto Shoot + Team Check)
local lastKillAuraShootTime = 0
local killAuraShootDelay = 0.15

task.spawn(function()
    while task.wait(0.1) do -- Check every 100ms instead of every frame
        if not Config.Combat.KillAura or not UI.Active then continue end
        
        local char = LocalPlayer.Character
        if not char then continue end
        
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if not rootPart then continue end
        
        local closestEnemy = nil
        local closestDistance = Config.Combat.KillAuraRange
        
        -- Find closest enemy in range
        for _, player in pairs(Players:GetPlayers()) do
            if IsEnemy(player, Config.Combat.KillAuraTeamCheck) and player.Character then
                local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
                if enemyRoot and enemyHum and enemyHum.Health > 0 then
                    local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                    if distance <= Config.Combat.KillAuraRange and distance < closestDistance then
                        closestEnemy = player
                        closestDistance = distance
                    end
                end
            end
        end
        
        -- Auto aim and attack closest enemy
        if closestEnemy and closestEnemy.Character then
            -- Try to find the selected target part ONLY
            local targetPart = closestEnemy.Character:FindFirstChild(Config.Combat.TargetPart)
            
            -- Only use fallback if the configured part doesn't exist
            if not targetPart then
                targetPart = closestEnemy.Character:FindFirstChild("Head")
                    or closestEnemy.Character:FindFirstChild("HumanoidRootPart")
            end
            
            if targetPart then
                -- Auto aim to target
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = targetCFrame
                
                -- Auto shoot with delay
                local currentTime = tick()
                if currentTime - lastKillAuraShootTime >= killAuraShootDelay then
                    Shoot()
                    lastKillAuraShootTime = currentTime
                end
            end
        end
    end
end)

-- Anti-AFK System
local afkTime = 0
local afkConnection = nil

afkConnection = RunService.Heartbeat:Connect(function()
    if not UI.Active or not Config.Misc.AntiAFK then return end
    
    afkTime = afkTime + 1
    
    -- Every 300 seconds (5 minutes), perform random action
    if afkTime >= 300 * 60 then -- 60 = approx heartbeat per second
        afkTime = 0
        
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Random small movement
            local randomAction = math.random(1, 3)
            if randomAction == 1 then
                hum:Move(Vector3.new(0.1, 0, 0))
            elseif randomAction == 2 then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            else
                -- Just move camera slightly
                Camera.CFrame = Camera.CFrame * CFrame.Angles(0, math.rad(0.1), 0)
            end
        end
    end
end)

-- Physics System
local FlyConnection = nil
local FlyBodyVelocity = nil
local FlyBodyGyro = nil

local function EnableFly()
    local char = LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() end
    if FlyBodyGyro then FlyBodyGyro:Destroy() end
    
    FlyBodyVelocity = Instance.new("BodyVelocity")
    FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyVelocity.Parent = rootPart
    
    FlyBodyGyro = Instance.new("BodyGyro")
    FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    FlyBodyGyro.P = 9e4
    FlyBodyGyro.Parent = rootPart
    
    if FlyConnection then FlyConnection:Disconnect() end
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not Config.Physics.Fly or not Config.Physics.FlyActive or not UI.Active then
            if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
            if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
            if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
            return
        end
        
        local cam = Camera.CFrame
        local direction = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then direction = direction + (cam.LookVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then direction = direction - (cam.LookVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then direction = direction - (cam.RightVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then direction = direction + (cam.RightVector) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction = direction + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then direction = direction - Vector3.new(0, 1, 0) end
        
        if direction.Magnitude > 0 then
            direction = direction.Unit
        end
        
        FlyBodyVelocity.Velocity = direction * Config.Physics.FlySpeed
        FlyBodyGyro.CFrame = cam
    end)
end

local function DisableFly()
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
    if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
    if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not UI.Active or gameProcessed then return end
    if input.KeyCode.Name == Config.Physics.FlyKey then
        -- Only works if Fly system is enabled in menu
        if Config.Physics.Fly then
            Config.Physics.FlyActive = not Config.Physics.FlyActive
            
            if Config.Physics.FlyActive then
                EnableFly()
            else
                DisableFly()
            end
            
            UI:Notify(Config.Physics.FlyActive and "Fly: ON" or "Fly: OFF")
        end
    end
end)

RunService.Stepped:Connect(function()
    if not UI.Active then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    -- Speed Hack using CFrame movement
    if Config.Physics.SpeedEnabled and Config.Physics.SpeedActive and hum.MoveDirection.Magnitude > 0 then
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            local moveDirection = hum.MoveDirection
            rootPart.CFrame = rootPart.CFrame + (moveDirection * Config.Physics.Speed * 0.5)
        end
    end
    
    -- Only modify Jump if Jump is enabled
    if Config.Physics.JumpEnabled then
        if hum.UseJumpPower then
            hum.JumpPower = Config.Physics.JumpPower
        else
            hum.JumpHeight = Config.Physics.JumpPower / 10
        end
    end
    
    -- Only apply NoClip if enabled AND active
    if Config.Physics.NoClip and Config.Physics.NoClipActive then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Initialize Tabs
local CombatPage = UI:CreateTab("Combat")
local VisualsPage = UI:CreateTab("Visuals")
local PhysicsPage = UI:CreateTab("Physics")
local MiscPage = UI:CreateTab("Misc")

-- Combat Controls
UI:CreateToggle(CombatPage, "Aim Assist", "Combat", "SilentAim")
UI:CreateSelector(CombatPage, "Target Body Part", "Combat", "TargetPart", {"Head", "UpperTorso", "Torso", "HumanoidRootPart"})
UI:CreateToggle(CombatPage, "Hold to Aim", "Combat", "HoldToAim")
UI:CreateKeybind(CombatPage, "Aim Hold Key", "Combat", "AimHoldKey")
UI:CreateToggle(CombatPage, "Team Check", "Combat", "TeamCheck")
UI:CreateSlider(CombatPage, "FOV Radius", 50, 400, "Combat", "FOV")
UI:CreateSlider(CombatPage, "Smoothness", 1, 10, "Combat", "Smoothness")
UI:CreateToggle(CombatPage, "Show FOV Circle", "Combat", "ShowFOV")
UI:CreateKeybind(CombatPage, "Lock/Unlock Target", "Combat", "LockKey")
UI:CreateToggle(CombatPage, "Triggerbot", "Combat", "Triggerbot")
UI:CreateSlider(CombatPage, "Trigger Delay (s)", 0, 1, "Combat", "TriggerDelay")
UI:CreateToggle(CombatPage, "Ultra Rapid Fire", "Combat", "UltraRapidFire")
UI:CreateSlider(CombatPage, "Ultra Rapid Fire Delay (s)", 0.01, 0.1, "Combat", "UltraRapidFireDelay")
UI:CreateToggle(CombatPage, "No Recoil", "Combat", "NoRecoil")
UI:CreateToggle(CombatPage, "No Spread", "Combat", "NoSpread")
UI:CreateToggle(CombatPage, "Auto Reload", "Combat", "AutoReload")
UI:CreateToggle(CombatPage, "Kill Aura + Auto Aim", "Combat", "KillAura")
UI:CreateToggle(CombatPage, "Kill Aura Team Check", "Combat", "KillAuraTeamCheck")
UI:CreateSlider(CombatPage, "Kill Aura Range", 5, 50, "Combat", "KillAuraRange")
UI:CreateToggle(CombatPage, "Target Switcher (auto-switch on kill)", "Combat", "TargetSwitcher")
UI:CreateSlider(CombatPage, "Target Switcher Delay (s)", 0, 1, "Combat", "TargetSwitcherDelay")

-- Ragebot Controls
UI:CreateToggle(CombatPage, "Ragebot (Enable)", "Combat", "Ragebot")
UI:CreateSelector(CombatPage, "Ragebot Game Profile", "Combat", "RagebotGameProfile", {"Auto", "Manual", "Universal", "Rivals", "Arsenal", "Jailbreak"}, function(v)
    UI:Notify("Ragebot profile: " .. v .. (v == "Auto" and " (detected: " .. detectedProfile .. ")" or ""))
end)
UI:CreateSelector(CombatPage, "Ragebot Target", "Combat", "RagebotMode", {"Closest", "Lowest Health", "Crosshair"})
UI:CreateSelector(CombatPage, "Ragebot Body Part", "Combat", "RagebotTargetPart", {"Head", "UpperTorso", "Torso", "HumanoidRootPart"})
UI:CreateToggle(CombatPage, "Ragebot Full Map", "Combat", "RagebotFullMap")

-- Info Label: For Ragebot Auto Shoot, enable Triggerbot
local InfoFrame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 50), BackgroundColor3 = Color3.fromRGB(25, 25, 32), ZIndex = 4, Parent = CombatPage})
Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 8)
local InfoStroke = UI:Create("UIStroke", {Color = Config.Visuals.Accent, Thickness = 1.5, Transparency = 0.3, Parent = InfoFrame})
local InfoLabel = UI:Create("TextLabel", {
    Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1, 
    Text = "Tip: For Ragebot Auto-Shoot, enable Triggerbot",
    TextColor3 = Config.Visuals.Accent, 
    Font = Enum.Font.GothamBold, TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Center, TextWrapped = true,
    ZIndex = 5, Parent = InfoFrame
})
RegisterAccent(function(c)
    InfoStroke.Color = c
    InfoLabel.TextColor3 = c
end)

UI:CreateToggle(CombatPage, "Ragebot Team Check", "Combat", "RagebotTeamCheck")
UI:CreateToggle(CombatPage, "Ragebot Visible Check (no walls)", "Combat", "RagebotVisibleCheck")
UI:CreateSlider(CombatPage, "Ragebot Max Distance", 50, 5000, "Combat", "RagebotMaxDistance")
UI:CreateSlider(CombatPage, "Ragebot Prediction", 0, 50, "Combat", "RagebotPrediction")
UI:CreateToggle(CombatPage, "Ragebot Auto TP/Fly to Enemy", "Combat", "RagebotAutoTP")
UI:CreateSelector(CombatPage, "Ragebot Move Mode", "Combat", "RagebotTPMode", {"Teleport", "Fly"})
UI:CreateSlider(CombatPage, "Ragebot Fly Speed", 20, 500, "Combat", "RagebotTPSpeed")
UI:CreateSlider(CombatPage, "Ragebot Keep Distance", 2, 30, "Combat", "RagebotTPOffset")
UI:CreateToggle(CombatPage, "Ragebot NoClip (pass walls)", "Combat", "RagebotNoClip")
UI:CreateToggle(CombatPage, "Ragebot Face Target (body aim)", "Combat", "RagebotFaceTarget")
UI:CreateToggle(CombatPage, "Ragebot Ignore Immune (ForceField)", "Combat", "RagebotIgnoreImmune")

-- Visual Controls
UI:CreateToggle(VisualsPage, "Enable ESP", "Visuals", "Enabled")
UI:CreateToggle(VisualsPage, "Show Names", "Visuals", "Names")
UI:CreateToggle(VisualsPage, "Show Distance", "Visuals", "Distance")
UI:CreateToggle(VisualsPage, "Show IDs", "Visuals", "IDs")
UI:CreateToggle(VisualsPage, "Head Dot", "Visuals", "HeadDot")
UI:CreateToggle(VisualsPage, "Skeleton ESP", "Visuals", "SkeletonESP")
UI:CreateToggle(VisualsPage, "3D Boxes / Chams", "Visuals", "Skeletons")
UI:CreateToggle(VisualsPage, "Tracers", "Visuals", "Tracers")
UI:CreateToggle(VisualsPage, "Health Bars", "Visuals", "HealthBars")
UI:CreateToggle(VisualsPage, "2D Box ESP", "Visuals", "BoxESP")
UI:CreateColorInput(VisualsPage, "ESP Color", "Visuals", "ESPColor")

-- Physics Controls
UI:CreateToggle(PhysicsPage, "Enable Speed Hack", "Physics", "SpeedEnabled")
UI:CreateSlider(PhysicsPage, "Speed Multiplier", 1, 5, "Physics", "Speed")
UI:CreateKeybind(PhysicsPage, "Speed Toggle Key", "Physics", "SpeedKey")
UI:CreateToggle(PhysicsPage, "Enable Jump Boost", "Physics", "JumpEnabled")
UI:CreateSlider(PhysicsPage, "Jump Power", 50, 300, "Physics", "JumpPower")
UI:CreateToggle(PhysicsPage, "Infinite Jump", "Misc", "InfiniteJump")
UI:CreateToggle(PhysicsPage, "Click Teleport", "Physics", "ClickTP")
UI:CreateKeybind(PhysicsPage, "Click TP Key", "Physics", "ClickTPKey")
UI:CreateToggle(PhysicsPage, "NoClip", "Physics", "NoClip")
UI:CreateToggle(PhysicsPage, "Fly Mode", "Physics", "Fly", function(state)
    if state then
        EnableFly()
    else
        DisableFly()
    end
end)
UI:CreateSlider(PhysicsPage, "Fly Speed", 10, 500, "Physics", "FlySpeed")
UI:CreateKeybind(PhysicsPage, "Fly Toggle Key", "Physics", "FlyKey")

-- Misc Controls
UI:CreateToggle(MiscPage, "Watermark", "Misc", "Watermark")
UI:CreateToggle(MiscPage, "Remove Fog", "Misc", "RemoveFog")
UI:CreateToggle(MiscPage, "Anti-AFK", "Misc", "AntiAFK")
UI:CreateToggle(MiscPage, "Fullbright", "Misc", "Fullbright")
UI:CreateToggle(MiscPage, "FOV Changer", "Misc", "FOVChanger")
UI:CreateSlider(MiscPage, "FOV Value", 70, 120, "Misc", "FOVValue")
UI:CreateKeybind(MiscPage, "NoClip Toggle Key", "Misc", "NoClipToggleKey")
UI:CreateKeybind(MiscPage, "PANIC Key (stop all)", "Misc", "PanicKey")

-- Theme Color Picker (same style as ESP color)
UI:CreateColorPicker(MiscPage, "Theme Color", "Visuals", "Accent")

-- Teleport to Player Section
local TeleportFrame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 90), BackgroundColor3 = Color3.fromRGB(18, 18, 24), ZIndex = 4, Parent = MiscPage})
Instance.new("UICorner", TeleportFrame).CornerRadius = UDim.new(0, 6)

UI:Create("TextLabel", {
    Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 5),
    BackgroundTransparency = 1, Text = "Teleport to Player",
    TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = TeleportFrame
})

local PlayerDropdown = UI:Create("TextButton", {
    Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 35),
    BackgroundColor3 = Color3.fromRGB(28, 28, 36), Text = "Select Player...",
    TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 11, ZIndex = 5, Parent = TeleportFrame
})
Instance.new("UICorner", PlayerDropdown).CornerRadius = UDim.new(0, 6)

local function isLightColorGlobal(c)
    return (c.R * 255 + c.G * 255 + c.B * 255) / 3 > 180
end

local TeleportBtn = UI:Create("TextButton", {
    Size = UDim2.new(0, 100, 0, 25), Position = UDim2.new(1, -110, 1, -30),
    BackgroundColor3 = Config.Visuals.Accent, Text = "TELEPORT",
    TextColor3 = isLightColorGlobal(Config.Visuals.Accent) and Color3.new(0,0,0) or Color3.new(1,1,1),
    Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 5, Parent = TeleportFrame
})
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 6)
RegisterAccent(function(c) 
    TeleportBtn.BackgroundColor3 = c 
    TeleportBtn.TextColor3 = isLightColorGlobal(c) and Color3.new(0,0,0) or Color3.new(1,1,1)
end)

-- Dropdown functionality
local dropdownOpen = false
local DropdownList = nil

PlayerDropdown.MouseButton1Click:Connect(function()
    if dropdownOpen then
        if DropdownList then DropdownList:Destroy() end
        dropdownOpen = false
        return
    end
    
    dropdownOpen = true
    
    -- Get absolute position of PlayerDropdown to position the list correctly
    local dropdownAbsPos = PlayerDropdown.AbsolutePosition
    local dropdownAbsSize = PlayerDropdown.AbsoluteSize
    
    DropdownList = UI:Create("ScrollingFrame", {
        Size = UDim2.new(0, dropdownAbsSize.X, 0, 150), 
        Position = UDim2.new(0, dropdownAbsPos.X, 0, dropdownAbsPos.Y + dropdownAbsSize.Y + 5),
        BackgroundColor3 = Color3.fromRGB(15, 15, 20), ScrollBarThickness = 4,
        ScrollBarImageColor3 = Config.Visuals.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0), ZIndex = 100, Parent = UI.Screen
    })
    Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
    UI:Create("UIStroke", {Color = Config.Visuals.Accent, Thickness = 1, Transparency = 0.5, Parent = DropdownList})
    
    local Layout = UI:Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = DropdownList})
    UI:Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), Parent = DropdownList})
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 8)
    end)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = UI:Create("TextButton", {
                Size = UDim2.new(1, -8, 0, 28), BackgroundColor3 = Color3.fromRGB(25, 25, 32),
                Text = player.DisplayName, TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.GothamMedium, TextSize = 12, ZIndex = 101, Parent = DropdownList
            })
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
            
            -- Hover effect
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Config.Visuals.Accent}):Play()
                btn.TextColor3 = isLightColorGlobal(Config.Visuals.Accent) and Color3.new(0,0,0) or Color3.new(1,1,1)
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(25, 25, 32)}):Play()
                btn.TextColor3 = Color3.new(1,1,1)
            end)
            
            btn.MouseButton1Click:Connect(function()
                Config.Misc.TeleportPlayer = player
                PlayerDropdown.Text = player.DisplayName
                DropdownList:Destroy()
                dropdownOpen = false
            end)
        end
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    if Config.Misc.TeleportPlayer and Config.Misc.TeleportPlayer.Character then
        local targetRoot = Config.Misc.TeleportPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        
        if targetRoot and myRoot then
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
            UI:Notify("Teleported to " .. Config.Misc.TeleportPlayer.DisplayName)
        else
            UI:Notify("Teleport failed")
        end
    else
        UI:Notify("No player selected")
    end
end)

-- Exit Cheat Button
local ExitFrame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 60), BackgroundColor3 = Color3.fromRGB(18, 18, 24), ZIndex = 4, Parent = MiscPage})
Instance.new("UICorner", ExitFrame).CornerRadius = UDim.new(0, 6)
UI:Create("UIStroke", {Color = Color3.fromRGB(231, 76, 60), Thickness = 2, Parent = ExitFrame})

local ExitCheatBtn = UI:Create("TextButton", {
    Size = UDim2.new(1, -20, 1, -20),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(231, 76, 60),
    Text = "EXIT CHEAT (No Trace)",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 5,
    Parent = ExitFrame
})
Instance.new("UICorner", ExitCheatBtn).CornerRadius = UDim.new(0, 6)

ExitCheatBtn.MouseButton1Click:Connect(function()
    UI:Notify("Exiting cheat... Cleaning up...")
    task.wait(0.5)
    
    -- Disable the entire framework
    UI.Active = false
    UI.Visible = false
    
    -- Stop all physics modifications
    Config.Physics.Fly = false
    Config.Physics.NoClip = false
    Config.Physics.SpeedEnabled = false
    Config.Physics.JumpEnabled = false
    Config.Combat.SilentAim = false
    Config.Combat.LockedTarget = nil
    Config.Combat.Ragebot = false
    Config.Visuals.Enabled = false
    
    -- Disable fly mode
    if FlyBodyVelocity then FlyBodyVelocity:Destroy() FlyBodyVelocity = nil end
    if FlyBodyGyro then FlyBodyGyro:Destroy() FlyBodyGyro = nil end
    if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
    
    -- Clean up all ESP objects
    for _, obj in pairs(ESPObjects) do
        if obj and obj.Parent then
            pcall(function() obj:Destroy() end)
        end
    end
    ESPObjects = {}
    
    -- Clean up tracers
    for _, data in pairs(TracerConnections) do
        if data.line then
            pcall(function() data.line:Remove() end)
        end
        if data.connection then
            pcall(function() data.connection:Disconnect() end)
        end
    end
    TracerConnections = {}
    
    -- Clean up box ESP
    for _, data in pairs(BoxConnections) do
        if data.box then
            pcall(function() data.box:Remove() end)
        end
        if data.connection then
            pcall(function() data.connection:Disconnect() end)
        end
    end
    BoxConnections = {}
    
    -- Clean up skeleton ESP
    for _, data in pairs(SkeletonConnections) do
        if data.lines then
            for _, lineData in pairs(data.lines) do
                pcall(function() lineData.line:Remove() end)
            end
        end
        if data.connection then
            pcall(function() data.connection:Disconnect() end)
        end
    end
    SkeletonConnections = {}
    
    -- Clean up ALL BillboardGui (Health Bars, Name Tags, etc.)
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BillboardGui") then
                    pcall(function() part:Destroy() end)
                end
            end
        end
    end
    
    -- Clean up Head Dots (any BillboardGui in Workspace)
    for _, descendant in pairs(Workspace:GetDescendants()) do
        if descendant:IsA("BillboardGui") and descendant.Name:find("Beep") then
            pcall(function() descendant:Destroy() end)
        end
    end
    
    -- Clean up any FOV Circle
    if FOVContainer then
        pcall(function() FOVContainer:Destroy() end)
        FOVContainer = nil
    end
    if FOVStroke then
        pcall(function() FOVStroke:Destroy() end)
        FOVStroke = nil
    end
    
    -- Destroy the UI completely
    UI.Screen:Destroy()
    
    -- Clear Watermark
    if Watermark then
        pcall(function() Watermark:Destroy() end)
        Watermark = nil
    end
    
    -- Clear global variables
    UI = nil
    Config = nil
    Combat = nil
    Visuals = nil
    ESPObjects = nil
    TracerConnections = nil
    BoxConnections = nil
    SkeletonConnections = nil
    ToggleIndicators = nil
    
    print("[Beep] Cheat exited successfully. No trace left.")
end)

UI:Notify("Beep loaded. Press 'Insert' to toggle menu.")
