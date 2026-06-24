-- Beep Multi-Tool Framework
-- Universal ESP, Aimbot & Physics Controller
-- Custom UI - Black & Purple Theme

local BEEP_VERSION = "v4.0.0"

local StartTime = tick()
if not game:IsLoaded() then
    repeat task.wait(0.1) until game:IsLoaded() or (tick() - StartTime) > 30
end

-- Anti-Duplicate Protection
local CoreGui = game:GetService("CoreGui")
for _, oldUI in pairs(CoreGui:GetChildren()) do
    if oldUI:IsA("ScreenGui") and oldUI.Name:find("Beep_") then
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

-- Theme Colors (Black + Purple)
local Theme = {
    Background = Color3.fromRGB(12, 12, 16),
    Surface = Color3.fromRGB(18, 18, 24),
    Card = Color3.fromRGB(24, 24, 32),
    Accent = Color3.fromRGB(138, 43, 226),  -- Purple
    AccentDark = Color3.fromRGB(98, 28, 176),
    AccentLight = Color3.fromRGB(168, 85, 247),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 180),
    Border = Color3.fromRGB(48, 48, 64),
    Success = Color3.fromRGB(80, 255, 120),
    Error = Color3.fromRGB(255, 80, 80)
}

-- Configuration (ALL MODULES FROM v3.7.1)
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
        Accent = Theme.Accent
    },
    Combat = {
        SilentAim = false,
        FOV = 150,
        Smoothness = 5,
        TargetPart = "Head",
        ShowFOV = false,
        LockKey = "Q",
        LockedTarget = nil,
        Triggerbot = false,
        TriggerDelay = 0.1,
        AutoShoot = false,
        ShootDelay = 0.15,
        TeamCheck = true,
        HoldToAim = false,
        AimHoldKey = "MouseButton2",
        UltraRapidFire = false,
        UltraRapidFireDelay = 0.02,
        NoRecoil = false,
        NoSpread = false,
        AutoReload = false,
        KillAura = false,
        KillAuraRange = 20,
        KillAuraTeamCheck = true,
        TargetSwitcher = false,
        TargetSwitcherDelay = 0.1,
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
        NoClipToggleKey = "F2",
        PanicKey = "End"
    }
}

-- UI Constructor
local UI = { Tabs = {}, CurrentTab = nil, Visible = true, Active = true }
local AccentObjects = {}
local ToggleIndicators = {}
local ESPObjects = {}
local TracerConnections = {}
local BoxConnections = {}
local SkeletonConnections = {}

local function RegisterAccent(fn)
    table.insert(AccentObjects, fn)
    pcall(fn, Theme.Accent)
end

local function RefreshAccent(color)
    Theme.Accent = color
    Config.Visuals.Accent = color
    for _, fn in ipairs(AccentObjects) do pcall(fn, color) end
end

function UI:Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do pcall(function() inst[k] = v end) end
    return inst
end

-- Main Screen
UI.Screen = UI:Create("ScreenGui", {
    Name = "Beep_" .. HttpService:GenerateGUID(false),
    ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999999,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = CoreGui
})

-- Main Window
local Main = UI:Create("Frame", {
    Size = UDim2.new(0, 580, 0, 420),
    Position = UDim2.new(0.5, -290, 0.5, -210),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0, ClipsDescendants = true, Parent = UI.Screen
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
UI:Create("UIStroke", {Color = Theme.Accent, Thickness = 2, Transparency = 0.3, Parent = Main})

-- Top Bar
local TopBar = UI:Create("Frame", {
    Size = UDim2.new(1, 0, 0, 40),
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0, Parent = Main
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TopBar})
UI:Create("Frame", {Size = UDim2.new(1, 0, 0, 10), Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, Parent = TopBar})

-- Logo
local Logo = UI:Create("TextLabel", {
    Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1, Text = "Beep",
    TextColor3 = Theme.Accent, Font = Enum.Font.GothamBlack,
    TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left, Parent = TopBar
})
RegisterAccent(function(c) Logo.TextColor3 = c end)

-- Version Badge
local VersionBadge = UI:Create("TextLabel", {
    Size = UDim2.new(0, 50, 0, 20), Position = UDim2.new(0, 80, 0.5, -10),
    BackgroundColor3 = Theme.Card, Text = BEEP_VERSION,
    TextColor3 = Theme.AccentLight, Font = Enum.Font.GothamBold, TextSize = 10, Parent = TopBar
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = VersionBadge})

-- Close Button
local CloseBtn = UI:Create("TextButton", {
    Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -35, 0.5, -14),
    BackgroundColor3 = Theme.Card, Text = "×",
    TextColor3 = Theme.Error, Font = Enum.Font.GothamBold, TextSize = 18,
    AutoButtonColor = false, Parent = TopBar
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CloseBtn})

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Error}):Play()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Color3.new(1,1,1)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Card}):Play()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextColor3 = Theme.Error}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    UI.Visible = false; Main.Visible = false
    UI:Notify("Menu hidden. Press INSERT to reopen.")
end)

-- Minimize Button
local MinBtn = UI:Create("TextButton", {
    Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(1, -68, 0.5, -14),
    BackgroundColor3 = Theme.Card, Text = "—",
    TextColor3 = Theme.TextDim, Font = Enum.Font.GothamBold, TextSize = 14,
    AutoButtonColor = false, Parent = TopBar
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = MinBtn})

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 580, 0, 40) or UDim2.new(0, 580, 0, 420)
    TweenService:Create(Main, TweenInfo.new(0.2), {Size = targetSize}):Play()
end)

-- Sidebar
local Sidebar = UI:Create("Frame", {
    Size = UDim2.new(0, 130, 1, -40), Position = UDim2.new(0, 0, 0, 40),
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, Parent = Main
})
UI:Create("Frame", {Size = UDim2.new(0, 1, 1, -20), Position = UDim2.new(1, 0, 0, 10),
    BackgroundColor3 = Theme.Border, BorderSizePixel = 0, Parent = Sidebar})

-- Container
local Container = UI:Create("Frame", {
    Size = UDim2.new(1, -145, 1, -50), Position = UDim2.new(0, 140, 0, 45),
    BackgroundTransparency = 1, Parent = Main
})

-- Dragging
local dragToggle, dragStart, startPos = false, nil, nil
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true; dragStart = input.Position; startPos = Main.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragToggle = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Notification System
function UI:Notify(text)
    if not UI.Active then return end
    task.spawn(function()
        local n = UI:Create("Frame", {
            Size = UDim2.new(0, 280, 0, 45), Position = UDim2.new(1, 10, 0.85, 0),
            BackgroundColor3 = Theme.Surface, Parent = UI.Screen
        })
        UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = n})
        UI:Create("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Parent = n})
        UI:Create("Frame", {Size = UDim2.new(0, 3, 1, -12), Position = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = Theme.Accent, Parent = n})
        UI:Create("TextLabel", {Size = UDim2.new(1, -25, 1, 0), Position = UDim2.new(0, 18, 0, 0),
            BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
            Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true, Parent = n})
        n:TweenPosition(UDim2.new(0.98, -280, 0.85, 0), "Out", "Back", 0.3)
        task.wait(2.5)
        if n.Parent then n:TweenPosition(UDim2.new(1, 10, 0.85, 0), "In", "Quad", 0.3); task.wait(0.4); n:Destroy() end
    end)
end

-- Tab System
function UI:CreateTab(name)
    local idx = #UI.Tabs
    local Page = UI:Create("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0), ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent, Visible = false, Parent = Container
    })
    RegisterAccent(function(c) Page.ScrollBarImageColor3 = c end)
    
    local Layout = UI:Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = Page})
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    local TabBtn = UI:Create("TextButton", {
        Size = UDim2.new(1, -16, 0, 36), Position = UDim2.new(0, 8, 0, 10 + (idx * 42)),
        BackgroundColor3 = idx == 0 and Theme.Card or Theme.Surface,
        BackgroundTransparency = idx == 0 and 0 or 1, Text = "", AutoButtonColor = false, Parent = Sidebar
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TabBtn})
    
    local Indicator = UI:Create("Frame", {
        Size = UDim2.new(0, 3, 0, idx == 0 and 20 or 0),
        Position = UDim2.new(0, 0, 0.5, idx == 0 and -10 or 0),
        BackgroundColor3 = Theme.Accent, Parent = TabBtn
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})
    RegisterAccent(function(c) Indicator.BackgroundColor3 = c end)
    
    local TabLabel = UI:Create("TextLabel", {
        Size = UDim2.new(1, -15, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = name,
        TextColor3 = idx == 0 and Theme.Text or Theme.TextDim,
        Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = TabBtn
    })
    
    TabBtn.MouseEnter:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.5}):Play()
        end
    end)
    TabBtn.MouseLeave:Connect(function()
        if not Page.Visible then
            TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        end
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        for _, v in pairs(Sidebar:GetChildren()) do
            if v:IsA("TextButton") then
                local lbl = v:FindFirstChildOfClass("TextLabel")
                local ind = v:FindFirstChildOfClass("Frame")
                if lbl then TweenService:Create(lbl, TweenInfo.new(0.15), {TextColor3 = Theme.TextDim}):Play() end
                TweenService:Create(v, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                if ind then TweenService:Create(ind, TweenInfo.new(0.15), {Size = UDim2.new(0, 3, 0, 0)}):Play() end
            end
        end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
        TweenService:Create(TabLabel, TweenInfo.new(0.15), {TextColor3 = Theme.Text}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.15), {Size = UDim2.new(0, 3, 0, 20)}):Play()
    end)
    
    if idx == 0 then Page.Visible = true end
    table.insert(UI.Tabs, Page)
    return Page
end

-- Toggle Helper
local function SetSwitchVisual(track, knob, state)
    TweenService:Create(track, TweenInfo.new(0.18), {
        BackgroundColor3 = state and Theme.Accent or Theme.Card
    }):Play()
    TweenService:Create(knob, TweenInfo.new(0.18), {
        Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7)
    }):Play()
end

function UI:CreateToggle(parent, text, configSection, configKey, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -8, 0, 38), BackgroundColor3 = Theme.Card, Parent = parent})
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Frame})
    UI:Create("TextLabel", {Size = UDim2.new(0.7, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    
    local state = Config[configSection][configKey]
    local Track = UI:Create("TextButton", {
        Size = UDim2.new(0, 40, 0, 20), Position = UDim2.new(1, -50, 0.5, -10),
        BackgroundColor3 = state and Theme.Accent or Theme.Card, Text = "", AutoButtonColor = false, Parent = Frame
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Track})
    UI:Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = Track})
    
    local Knob = UI:Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = state and UDim2.new(1, -18, 0.5, -7) or UDim2.new(0, 4, 0.5, -7),
        BackgroundColor3 = Theme.Text, Parent = Track
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})
    
    ToggleIndicators[configSection.."."..configKey] = {track = Track, knob = Knob}
    RegisterAccent(function(c) if Config[configSection][configKey] then Track.BackgroundColor3 = c end end)
    
    Track.MouseButton1Click:Connect(function()
        if not UI.Active then return end
        local newState = not Config[configSection][configKey]
        Config[configSection][configKey] = newState
        SetSwitchVisual(Track, Knob, newState)
        if callback then callback(newState) end
    end)
end

function UI:UpdateToggle(configSection, configKey, state)
    local ind = ToggleIndicators[configSection.."."..configKey]
    if ind then SetSwitchVisual(ind.track, ind.knob, state) end
end

function UI:CreateSlider(parent, text, min, max, configSection, configKey, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -8, 0, 50), BackgroundColor3 = Theme.Card, Parent = parent})
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Frame})
    UI:Create("TextLabel", {Size = UDim2.new(0.6, 0, 0, 22), Position = UDim2.new(0, 12, 0, 4),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    
    local ValueLabel = UI:Create("TextLabel", {
        Size = UDim2.new(0, 50, 0, 22), Position = UDim2.new(1, -60, 0, 4),
        BackgroundTransparency = 1, Text = tostring(Config[configSection][configKey]),
        TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = Frame
    })
    RegisterAccent(function(c) ValueLabel.TextColor3 = c end)
    
    local SlideBar = UI:Create("Frame", {
        Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 36),
        BackgroundColor3 = Theme.Border, Parent = Frame
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = SlideBar})
    
    local Fill = UI:Create("Frame", {
        Size = UDim2.new((Config[configSection][configKey] - min)/(max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent, Parent = SlideBar
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 3), Parent = Fill})
    RegisterAccent(function(c) Fill.BackgroundColor3 = c end)
    
    local Knob = UI:Create("Frame", {
        Size = UDim2.new(0, 12, 0, 12), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, 0, 0.5, 0), BackgroundColor3 = Theme.Text, Parent = Fill
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Knob})
    
    local Trigger = UI:Create("TextButton", {Size = UDim2.new(1, 0, 3, 0), Position = UDim2.new(0, 0, -1, 0),
        BackgroundTransparency = 1, Text = "", Parent = SlideBar})
    
    local function update(input)
        local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        Config[configSection][configKey] = val
        ValueLabel.Text = tostring(val)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        if callback then callback(val) end
    end
    
    local dragging = false
    Trigger.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

function UI:CreateKeybind(parent, text, configSection, configKey)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -8, 0, 38), BackgroundColor3 = Theme.Card, Parent = parent})
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Frame})
    UI:Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    
    local KeyBtn = UI:Create("TextButton", {
        Size = UDim2.new(0, 70, 0, 24), Position = UDim2.new(1, -80, 0.5, -12),
        BackgroundColor3 = Theme.Surface,
        Text = Config[configSection][configKey] == "MouseButton2" and "RMB" or Config[configSection][configKey],
        TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 10, AutoButtonColor = false, Parent = Frame
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeyBtn})
    UI:Create("UIStroke", {Color = Theme.Accent, Thickness = 1, Transparency = 0.5, Parent = KeyBtn})
    RegisterAccent(function(c) KeyBtn.TextColor3 = c; KeyBtn:FindFirstChildOfClass("UIStroke").Color = c end)
    
    local listening = false
    KeyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true; KeyBtn.Text = "..."
        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Config[configSection][configKey] = input.KeyCode.Name
                KeyBtn.Text = input.KeyCode.Name
            elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                Config[configSection][configKey] = "MouseButton2"
                KeyBtn.Text = "RMB"
            end
            listening = false; conn:Disconnect()
        end)
    end)
end

function UI:CreateSelector(parent, text, configSection, configKey, options, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -8, 0, 38), BackgroundColor3 = Theme.Card, Parent = parent})
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Frame})
    UI:Create("TextLabel", {Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = text, TextColor3 = Theme.Text,
        Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = Frame})
    
    local SelBtn = UI:Create("TextButton", {
        Size = UDim2.new(0, 120, 0, 26), Position = UDim2.new(1, -130, 0.5, -13),
        BackgroundColor3 = Theme.Accent, Text = "‹ "..Config[configSection][configKey].." ›",
        TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 10, AutoButtonColor = false, Parent = Frame
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SelBtn})
    RegisterAccent(function(c) SelBtn.BackgroundColor3 = c end)
    
    SelBtn.MouseButton1Click:Connect(function()
        if not UI.Active then return end
        local idx = 1
        for i, opt in ipairs(options) do if Config[configSection][configKey] == opt then idx = i; break end end
        local next = (idx % #options) + 1
        Config[configSection][configKey] = options[next]
        SelBtn.Text = "‹ "..options[next].." ›"
        if callback then callback(options[next]) end
    end)
end

-- ============================================
-- COMBAT SYSTEM (From v3.7.1)
-- ============================================
local Combat = {}

function Combat:GetClosestPlayer()
    local closest, shortestDistance = nil, Config.Combat.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(Config.Combat.TargetPart) or player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
            if part and part.Position.Y >= -40 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distance < shortestDistance then closest = player; shortestDistance = distance end
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
    local part = target.Character:FindFirstChild(Config.Combat.TargetPart) or target.Character:FindFirstChild("Head")
    if not part or part.Position.Y < -40 then return false end
    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end
    return (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude <= Config.Combat.FOV
end

-- Shooting Function
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local lastShootTime = 0

local function Shoot()
    local currentTime = tick()
    if Config.Combat.UltraRapidFire and currentTime - lastShootTime < Config.Combat.UltraRapidFireDelay then return end
    lastShootTime = currentTime
    task.spawn(function()
        local char = LocalPlayer.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then tool:Activate(); task.wait(0.05); tool:Deactivate(); return end
        pcall(function() VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0); task.wait(0.05); VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0) end)
    end)
end

-- Team Detection
local function IsEnemy(player, useTeamCheck)
    if player == LocalPlayer then return false end
    if not useTeamCheck then return true end
    if LocalPlayer.Team and player.Team then return LocalPlayer.Team ~= player.Team end
    return true
end

-- Target Lock System
UserInputService.InputBegan:Connect(function(input, gp)
    if not UI.Active or gp then return end
    if input.KeyCode.Name == Config.Combat.LockKey then
        if Config.Combat.LockedTarget then
            Config.Combat.LockedTarget = nil; UI:Notify("Target Unlocked")
        else
            local target = Combat:GetClosestPlayer()
            if target and IsEnemy(target, Config.Combat.TeamCheck) then
                Config.Combat.LockedTarget = target
                UI:Notify("Target Locked: "..target.DisplayName)
            end
        end
    end
    if input.KeyCode.Name == Config.Physics.SpeedKey and Config.Physics.SpeedEnabled then
        Config.Physics.SpeedActive = not Config.Physics.SpeedActive
        UI:Notify(Config.Physics.SpeedActive and "Speed: ON" or "Speed: OFF")
    end
end)

-- Aim Assist Loop
local lastAimShootTime, aimHoldActive = 0, false
local currentAimTarget, lastAimTargetHealth, targetSwitchCooldown = nil, nil, 0

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not UI.Active or not Config.Combat.HoldToAim then return end
    if (Config.Combat.AimHoldKey == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2) or
       (input.KeyCode.Name == Config.Combat.AimHoldKey) then aimHoldActive = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if (Config.Combat.AimHoldKey == "MouseButton2" and input.UserInputType == Enum.UserInputType.MouseButton2) or
       (input.KeyCode.Name == Config.Combat.AimHoldKey) then aimHoldActive = false end
end)

RunService.RenderStepped:Connect(function()
    if not UI.Active then return end
    -- Target Switcher
    if Config.Combat.TargetSwitcher and currentAimTarget and tick() >= targetSwitchCooldown then
        pcall(function()
            if currentAimTarget.Character then
                local hum = currentAimTarget.Character:FindFirstChildOfClass("Humanoid")
                if hum and (hum.Health <= 0 or (lastAimTargetHealth and hum.Health < 10)) then
                    if Config.Combat.LockedTarget == currentAimTarget then Config.Combat.LockedTarget = nil end
                    currentAimTarget, lastAimTargetHealth = nil, nil
                    targetSwitchCooldown = tick() + Config.Combat.TargetSwitcherDelay
                else lastAimTargetHealth = hum and hum.Health end
            end
        end)
    end
    -- Aim
    local shouldAim = Config.Combat.SilentAim and (not Config.Combat.HoldToAim or aimHoldActive)
    if shouldAim then
        local target = Config.Combat.LockedTarget
        if target and not Combat:IsTargetValid(target) then Config.Combat.LockedTarget = nil; target = nil end
        if not target then target = Combat:GetClosestPlayer() end
        if target ~= currentAimTarget then currentAimTarget = target end
        if target and target.Character and IsEnemy(target, Config.Combat.TeamCheck) then
            local part = target.Character:FindFirstChild(Config.Combat.TargetPart) or target.Character:FindFirstChild("Head")
            if part then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), Config.Combat.Smoothness * 0.1) end
        end
    end
end)

-- ============================================
-- RAGEBOT SYSTEM (From v3.7.1)
-- ============================================
local Ragebot = {}
local GameProfiles = {
    ["Universal"] = {part = "Head", visible = false, prediction = 0, faceTarget = true},
    ["Rivals"] = {part = "Head", visible = false, prediction = 0, faceTarget = true},
    ["Arsenal"] = {part = "Head", visible = false, prediction = 0, faceTarget = false},
    ["Jailbreak"] = {part = "Head", visible = true, prediction = 2, faceTarget = true},
}
local detectedProfile = "Universal"
pcall(function()
    local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    local n = (info and info.Name or ""):lower()
    if n:find("rival") then detectedProfile = "Rivals"
    elseif n:find("arsenal") then detectedProfile = "Arsenal"
    elseif n:find("jailbreak") then detectedProfile = "Jailbreak" end
end)

local function ragebotSettings()
    local prof = Config.Combat.RagebotGameProfile
    if prof == "Manual" then return {part = Config.Combat.RagebotTargetPart, visible = Config.Combat.RagebotVisibleCheck, prediction = Config.Combat.RagebotPrediction, faceTarget = Config.Combat.RagebotFaceTarget} end
    if prof == "Auto" then prof = detectedProfile end
    return GameProfiles[prof] or GameProfiles["Universal"]
end

local function getRagebotPart(char, partName)
    return char:FindFirstChild(partName) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function ragebotVisible(part, character)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position), params)
    return not result or result.Instance:IsDescendantOf(character)
end

function Ragebot:GetTarget()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local settings, best, bestScore = ragebotSettings(), nil, nil
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            local part = getRagebotPart(player.Character, settings.part)
            local immune = Config.Combat.RagebotIgnoreImmune and player.Character:FindFirstChildOfClass("ForceField")
            if hum and hum.Health > 0 and part and not immune and part.Position.Y >= -40 and IsEnemy(player, Config.Combat.RagebotTeamCheck) then
                local dist = (part.Position - myRoot.Position).Magnitude
                if dist <= Config.Combat.RagebotMaxDistance then
                    local pass = Config.Combat.RagebotFullMap or select(2, Camera:WorldToViewportPoint(part.Position))
                    if pass and (not settings.visible or ragebotVisible(part, player.Character)) then
                        local score = Config.Combat.RagebotMode == "Lowest Health" and hum.Health or dist
                        if not bestScore or score < bestScore then bestScore, best = score, part end
                    end
                end
            end
        end
    end
    return best
end

-- Ragebot Loop
RunService.RenderStepped:Connect(function(dt)
    if not UI.Active or not Config.Combat.Ragebot then return end
    local target = Ragebot:GetTarget()
    if not target then return end
    local settings = ragebotSettings()
    local aimPos = target.Position
    if settings.prediction > 0 then aimPos = aimPos + (target.AssemblyLinearVelocity * (settings.prediction / 100)) end
    if settings.faceTarget and not Config.Combat.RagebotAutoTP then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot then myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(target.Position.X, myRoot.Position.Y, target.Position.Z)) end
    end
    if Config.Combat.RagebotAutoTP then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local fromDir = (myRoot.Position - target.Position); if fromDir.Magnitude < 0.1 then fromDir = Vector3.new(0,0,1) end
            local goalPos = target.Position + (fromDir.Unit * Config.Combat.RagebotTPOffset)
            if Config.Combat.RagebotTPMode == "Teleport" then
                myRoot.CFrame = CFrame.new(goalPos, Vector3.new(target.Position.X, goalPos.Y, target.Position.Z))
            else
                local toGoal = (goalPos - myRoot.Position)
                if toGoal.Magnitude > 0.5 then
                    local newPos = myRoot.Position + (toGoal.Unit * math.min(Config.Combat.RagebotTPSpeed * dt, toGoal.Magnitude))
                    myRoot.CFrame = CFrame.new(newPos, Vector3.new(target.Position.X, newPos.Y, target.Position.Z))
                end
            end
            pcall(function() myRoot.AssemblyLinearVelocity = Vector3.zero end)
        end
    end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPos)
end)

-- Ragebot NoClip
local ragebotNoclipParts = {}
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local want = UI.Active and Config.Combat.Ragebot and Config.Combat.RagebotNoClip
    if want then
        for _, p in ipairs(char:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false; ragebotNoclipParts[p] = true end end
    elseif next(ragebotNoclipParts) then
        for p in pairs(ragebotNoclipParts) do if p and p.Parent then pcall(function() p.CanCollide = true end) end end
        ragebotNoclipParts = {}
    end
end)

-- PANIC Key
UserInputService.InputBegan:Connect(function(input)
    if not UI.Active or input.KeyCode.Name ~= Config.Misc.PanicKey then return end
    Config.Combat.Ragebot, Config.Combat.SilentAim, Config.Combat.Triggerbot = false, false, false
    Config.Combat.KillAura, Config.Physics.SpeedActive, Config.Physics.FlyActive = false, false, false
    pcall(function()
        UI:UpdateToggle("Combat", "Ragebot", false); UI:UpdateToggle("Combat", "SilentAim", false)
        UI:UpdateToggle("Combat", "Triggerbot", false); UI:UpdateToggle("Combat", "KillAura", false)
    end)
    UI:Notify("PANIC: All combat disabled")
end)

-- Triggerbot System
local lastTriggerTime = 0
task.spawn(function()
    while task.wait(0.05) do
        if UI.Active and Config.Combat.Triggerbot then
            local char = LocalPlayer.Character
            local mouseTarget = char and Mouse.Target
            local targetChar = mouseTarget and mouseTarget:FindFirstAncestorOfClass("Model")
            local targetPlayer = targetChar and Players:GetPlayerFromCharacter(targetChar)
            if targetPlayer and targetPlayer ~= LocalPlayer and IsEnemy(targetPlayer, Config.Combat.TeamCheck) then
                local hum = targetChar:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    local delay = Config.Combat.UltraRapidFire and Config.Combat.UltraRapidFireDelay or Config.Combat.TriggerDelay
                    if tick() - lastTriggerTime >= delay then Shoot(); lastTriggerTime = tick() end
                end
            end
        end
    end
end)

-- Auto Shoot for Locked Target
task.spawn(function()
    while task.wait(0.05) do
        if UI.Active and Config.Combat.AutoShoot and Config.Combat.LockedTarget then
            if tick() - lastAimShootTime >= Config.Combat.ShootDelay then
                if Combat:IsTargetValid(Config.Combat.LockedTarget) then Shoot(); lastAimShootTime = tick() end
            end
        end
    end
end)

-- Kill Aura
local lastKillAuraTime = 0
task.spawn(function()
    while task.wait(0.1) do
        if not Config.Combat.KillAura or not UI.Active then continue end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local closest, closestDist = nil, Config.Combat.KillAuraRange
        for _, player in pairs(Players:GetPlayers()) do
            if IsEnemy(player, Config.Combat.KillAuraTeamCheck) and player.Character then
                local eRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local eHum = player.Character:FindFirstChildOfClass("Humanoid")
                if eRoot and eHum and eHum.Health > 0 then
                    local dist = (root.Position - eRoot.Position).Magnitude
                    if dist < closestDist then closest, closestDist = player, dist end
                end
            end
        end
        if closest and closest.Character then
            local part = closest.Character:FindFirstChild("Head") or closest.Character:FindFirstChild("HumanoidRootPart")
            if part then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
                if tick() - lastKillAuraTime >= 0.15 then Shoot(); lastKillAuraTime = tick() end
            end
        end
    end
end)

-- ============================================
-- ESP SYSTEM (From v3.7.1)
-- ============================================
local Visuals = {}

local function apply3DChams(part)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
    box.Color3 = Theme.Accent; box.AlwaysOnTop = true; box.Transparency = 0.4
    box.Adornee = part; box.Parent = part; box.Visible = false
    table.insert(ESPObjects, box)
    return box
end

function Visuals:DrawESPOnCharacter(player)
    if player == LocalPlayer then return end
    local function setupCharacter(char)
        local head = char:WaitForChild("Head", 10)
        if not head then return end
        local bGui = UI:Create("BillboardGui", {Size = UDim2.new(0, 150, 0, 40), StudsOffset = Vector3.new(0, 3, 0), AlwaysOnTop = true, Enabled = false, Parent = head})
        local label = UI:Create("TextLabel", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 11, TextStrokeTransparency = 0.5, Parent = bGui})
        table.insert(ESPObjects, bGui)
        
        local headDot
        task.spawn(function()
            local hp = char:WaitForChild("Head", 10)
            if hp then
                headDot = UI:Create("BillboardGui", {Size = UDim2.new(0, 10, 0, 10), AlwaysOnTop = true, Enabled = false, Parent = hp})
                local dot = UI:Create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0, Parent = headDot})
                Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
                table.insert(ESPObjects, headDot)
            end
        end)
        
        local trackingParts = {}
        for _, obj in pairs(char:GetChildren()) do if obj:IsA("BasePart") then table.insert(trackingParts, apply3DChams(obj)) end end
        
        task.spawn(function()
            while bGui.Parent and char:IsDescendantOf(Workspace) and UI.Active do
                local enabled = Config.Visuals.Enabled
                bGui.Enabled = enabled
                if headDot then headDot.Enabled = enabled and Config.Visuals.HeadDot end
                local isEnemy = IsEnemy(player, true)
                local color = isEnemy and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 255, 120)
                for _, box in pairs(trackingParts) do if box and box.Parent then box.Visible = enabled and Config.Visuals.Skeletons; box.Color3 = color end end
                if enabled then
                    local root = char:FindFirstChild("HumanoidRootPart") or head
                    local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
                    local txt = player.DisplayName
                    if Config.Visuals.Distance then txt = txt.." ["..dist.."m]" end
                    if Config.Visuals.IDs then txt = txt.."\n["..player.UserId.."]" end
                    label.TextColor3 = color
                    label.Text = Config.Visuals.Names and txt or ""
                else label.Text = "" end
                task.wait(0.1)
            end
        end)
    end
    if player.Character then task.spawn(function() setupCharacter(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setupCharacter(char) end) end)
end

for _, p in pairs(Players:GetPlayers()) do Visuals:DrawESPOnCharacter(p) end
Players.PlayerAdded:Connect(function(p) Visuals:DrawESPOnCharacter(p) end)

-- Tracers
local function CreateTracer(player)
    if player == LocalPlayer then return end
    local function setup(char)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        local line = Drawing.new("Line"); line.Visible = false; line.Thickness = 1
        local conn = RunService.RenderStepped:Connect(function()
            if not UI.Active or not char:IsDescendantOf(Workspace) then line:Remove(); conn:Disconnect(); return end
            if Config.Visuals.Tracers then
                local color = IsEnemy(player, true) and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 255, 120)
                line.Color = color
                local sp, on = Camera:WorldToViewportPoint(root.Position)
                if on then line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y); line.To = Vector2.new(sp.X, sp.Y); line.Visible = true
                else line.Visible = false end
            else line.Visible = false end
        end)
        table.insert(TracerConnections, {line = line, connection = conn})
    end
    if player.Character then task.spawn(function() setup(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setup(char) end) end)
end
for _, p in pairs(Players:GetPlayers()) do CreateTracer(p) end
Players.PlayerAdded:Connect(function(p) CreateTracer(p) end)

-- Health Bars
local function CreateHealthBar(player)
    if player == LocalPlayer then return end
    local function setup(char)
        local head = char:WaitForChild("Head", 10)
        local hum = char:WaitForChild("Humanoid", 10)
        if not head or not hum then return end
        local bg = Instance.new("BillboardGui", head)
        bg.Size = UDim2.new(4, 0, 0.5, 0); bg.StudsOffset = Vector3.new(0, 4, 0); bg.AlwaysOnTop = true; bg.Enabled = false
        local frame = Instance.new("Frame", bg); frame.Size = UDim2.new(1, 0, 1, 0); frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1); frame.BorderSizePixel = 0
        local bar = Instance.new("Frame", frame); bar.Size = UDim2.new(1, 0, 1, 0); bar.BackgroundColor3 = Color3.new(0, 1, 0); bar.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4); Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)
        task.spawn(function()
            while bg.Parent and char:IsDescendantOf(Workspace) and UI.Active do
                bg.Enabled = Config.Visuals.HealthBars
                if Config.Visuals.HealthBars then
                    local pct = hum.Health / hum.MaxHealth
                    bar.Size = UDim2.new(pct, 0, 1, 0); bar.BackgroundColor3 = Color3.new(1 - pct, pct, 0)
                end
                task.wait(0.1)
            end
            bg:Destroy()
        end)
    end
    if player.Character then task.spawn(function() setup(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setup(char) end) end)
end
for _, p in pairs(Players:GetPlayers()) do CreateHealthBar(p) end
Players.PlayerAdded:Connect(function(p) CreateHealthBar(p) end)

-- Skeleton ESP
local function CreateSkeleton(player)
    if player == LocalPlayer then return end
    local function setup(char)
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end
        local bones = char:FindFirstChild("Torso") and {{from="Head",to="Torso"},{from="Torso",to="Left Arm"},{from="Torso",to="Right Arm"},{from="Torso",to="Left Leg"},{from="Torso",to="Right Leg"}}
            or {{from="Head",to="UpperTorso"},{from="UpperTorso",to="LowerTorso"},{from="UpperTorso",to="LeftUpperArm"},{from="LeftUpperArm",to="LeftLowerArm"},{from="UpperTorso",to="RightUpperArm"},{from="RightUpperArm",to="RightLowerArm"},{from="LowerTorso",to="LeftUpperLeg"},{from="LeftUpperLeg",to="LeftLowerLeg"},{from="LowerTorso",to="RightUpperLeg"},{from="RightUpperLeg",to="RightLowerLeg"}}
        local lines = {}
        for _, b in pairs(bones) do local l = Drawing.new("Line"); l.Visible = false; l.Thickness = 2; table.insert(lines, {line=l, from=b.from, to=b.to}) end
        local conn = RunService.RenderStepped:Connect(function()
            if not UI.Active or not char:IsDescendantOf(Workspace) then for _, d in pairs(lines) do d.line:Remove() end; conn:Disconnect(); return end
            if Config.Visuals.SkeletonESP then
                local color = IsEnemy(player, true) and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(80, 255, 120)
                for _, d in pairs(lines) do
                    local fp, tp = char:FindFirstChild(d.from), char:FindFirstChild(d.to)
                    if fp and tp then
                        local f, fv = Camera:WorldToViewportPoint(fp.Position)
                        local t, tv = Camera:WorldToViewportPoint(tp.Position)
                        if fv and tv then d.line.From = Vector2.new(f.X, f.Y); d.line.To = Vector2.new(t.X, t.Y); d.line.Color = color; d.line.Visible = true
                        else d.line.Visible = false end
                    else d.line.Visible = false end
                end
            else for _, d in pairs(lines) do d.line.Visible = false end end
        end)
        table.insert(SkeletonConnections, {lines = lines, connection = conn})
    end
    if player.Character then task.spawn(function() setup(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setup(char) end) end)
end
for _, p in pairs(Players:GetPlayers()) do CreateSkeleton(p) end
Players.PlayerAdded:Connect(function(p) CreateSkeleton(p) end)

-- Box ESP 2D
local function CreateBox2D(player)
    if player == LocalPlayer then return end
    local function setup(char)
        local root = char:WaitForChild("HumanoidRootPart", 5)
        if not root then return end
        local box = Drawing.new("Square"); box.Visible = false; box.Thickness = 2; box.Filled = false
        local conn = RunService.RenderStepped:Connect(function()
            if not UI.Active or not char:IsDescendantOf(Workspace) then box:Remove(); conn:Disconnect(); return end
            if Config.Visuals.BoxESP then
                local color = IsEnemy(player, true) and Color3.new(1, 0.3, 0.3) or Color3.new(0.3, 1, 0.5)
                box.Color = color
                local head = char:FindFirstChild("Head")
                if root and head then
                    local rp, rv = Camera:WorldToViewportPoint(root.Position)
                    local hp = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local lp = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                    if rv then local h = math.abs(hp.Y - lp.Y); local w = h/2; box.Size = Vector2.new(w, h); box.Position = Vector2.new(rp.X - w/2, hp.Y); box.Visible = true
                    else box.Visible = false end
                else box.Visible = false end
            else box.Visible = false end
        end)
        table.insert(BoxConnections, {box = box, connection = conn})
    end
    if player.Character then task.spawn(function() setup(player.Character) end) end
    player.CharacterAdded:Connect(function(char) task.spawn(function() setup(char) end) end)
end
for _, p in pairs(Players:GetPlayers()) do CreateBox2D(p) end
Players.PlayerAdded:Connect(function(p) CreateBox2D(p) end)

-- ============================================
-- PHYSICS & MISC SYSTEMS (From v3.7.1)
-- ============================================
local Lighting = game:GetService("Lighting")
local origLight = {Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient}

RunService.RenderStepped:Connect(function()
    if Config.Misc.Fullbright and UI.Active then
        Lighting.Brightness = 2; Lighting.ClockTime = 12; Lighting.GlobalShadows = false; Lighting.Ambient = Color3.new(1,1,1)
    end
    if Config.Misc.RemoveFog and UI.Active then Lighting.FogEnd = 100000 end
    if Config.Misc.FOVChanger and UI.Active then Camera.FieldOfView = Config.Misc.FOVValue else Camera.FieldOfView = 70 end
end)

-- Infinite Jump
local lastJump = 0
UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not UI.Active or input.KeyCode ~= Enum.KeyCode.Space or not Config.Misc.InfiniteJump then return end
    if tick() - lastJump < 0.05 then return end; lastJump = tick()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 50, root.AssemblyLinearVelocity.Z) end
end)

-- Click Teleport
Mouse.Button1Down:Connect(function()
    if not UI.Active or not Config.Physics.ClickTP then return end
    if not UserInputService:IsKeyDown(Enum.KeyCode[Config.Physics.ClickTPKey]) then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)); UI:Notify("Teleported") end
end)

-- Fly System
local FlyConn, FlyBV, FlyBG
local function EnableFly()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    if FlyBV then FlyBV:Destroy() end; if FlyBG then FlyBG:Destroy() end
    FlyBV = Instance.new("BodyVelocity"); FlyBV.MaxForce = Vector3.new(9e9,9e9,9e9); FlyBV.Parent = root
    FlyBG = Instance.new("BodyGyro"); FlyBG.MaxTorque = Vector3.new(9e9,9e9,9e9); FlyBG.P = 9e4; FlyBG.Parent = root
    if FlyConn then FlyConn:Disconnect() end
    FlyConn = RunService.RenderStepped:Connect(function()
        if not Config.Physics.Fly or not Config.Physics.FlyActive or not UI.Active then
            if FlyBV then FlyBV:Destroy(); FlyBV = nil end; if FlyBG then FlyBG:Destroy(); FlyBG = nil end
            if FlyConn then FlyConn:Disconnect(); FlyConn = nil end; return
        end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
        FlyBV.Velocity = dir.Magnitude > 0 and dir.Unit * Config.Physics.FlySpeed or Vector3.zero
        FlyBG.CFrame = Camera.CFrame
    end)
end
local function DisableFly() if FlyBV then FlyBV:Destroy(); FlyBV=nil end; if FlyBG then FlyBG:Destroy(); FlyBG=nil end; if FlyConn then FlyConn:Disconnect(); FlyConn=nil end end

UserInputService.InputBegan:Connect(function(input, gp)
    if not UI.Active or gp then return end
    if input.KeyCode.Name == Config.Physics.FlyKey and Config.Physics.Fly then
        Config.Physics.FlyActive = not Config.Physics.FlyActive
        if Config.Physics.FlyActive then EnableFly() else DisableFly() end
        UI:Notify(Config.Physics.FlyActive and "Fly: ON" or "Fly: OFF")
    end
    if input.KeyCode.Name == Config.Misc.NoClipToggleKey and Config.Physics.NoClip then
        Config.Physics.NoClipActive = not Config.Physics.NoClipActive
        UI:Notify(Config.Physics.NoClipActive and "NoClip: ON" or "NoClip: OFF")
    end
end)

-- Speed & NoClip
RunService.Stepped:Connect(function()
    if not UI.Active then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if hum and root and Config.Physics.SpeedEnabled and Config.Physics.SpeedActive and hum.MoveDirection.Magnitude > 0 then
        root.CFrame = root.CFrame + (hum.MoveDirection * Config.Physics.Speed * 0.5)
    end
    if hum and Config.Physics.JumpEnabled then
        if hum.UseJumpPower then hum.JumpPower = Config.Physics.JumpPower else hum.JumpHeight = Config.Physics.JumpPower / 10 end
    end
    if char and Config.Physics.NoClip and Config.Physics.NoClipActive then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

-- Anti-AFK
local afkTime = 0
RunService.Heartbeat:Connect(function()
    if not UI.Active or not Config.Misc.AntiAFK then return end
    afkTime = afkTime + 1
    if afkTime >= 300 * 60 then
        afkTime = 0
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(Vector3.new(0.1, 0, 0)) end
    end
end)

-- Toggle Menu
UserInputService.InputBegan:Connect(function(input, gp)
    if not UI.Active then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        UI.Visible = not UI.Visible; Main.Visible = UI.Visible
        UI:Notify(UI.Visible and "Menu Opened" or "Menu Closed")
    end
end)

-- FOV Circle
local FOVContainer = UI:Create("Frame", {
    Size = UDim2.new(0, Config.Combat.FOV * 2, 0, Config.Combat.FOV * 2),
    AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Visible = false, Parent = UI.Screen
})
local FOVStroke = UI:Create("UIStroke", {Color = Theme.Accent, Thickness = 1, Transparency = 0.5, Parent = FOVContainer})
Instance.new("UICorner", FOVContainer).CornerRadius = UDim.new(1, 0)
RegisterAccent(function(c) FOVStroke.Color = c end)

RunService.RenderStepped:Connect(function()
    if not UI.Active then return end
    if Config.Combat.ShowFOV then
        FOVContainer.Visible = true
        FOVContainer.Size = UDim2.new(0, Config.Combat.FOV * 2, 0, Config.Combat.FOV * 2)
        FOVContainer.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y + 36)
    else FOVContainer.Visible = false end
end)

-- Watermark
local Watermark = UI:Create("TextLabel", {
    Size = UDim2.new(0, 280, 0, 45), Position = UDim2.new(0, 10, 0, 400),
    BackgroundColor3 = Theme.Background, BackgroundTransparency = 0.2,
    Text = "Beep "..BEEP_VERSION.." | FPS: 60 | Ping: 0ms",
    TextColor3 = Theme.Text, Font = Enum.Font.GothamBold, TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    Visible = Config.Misc.Watermark, Parent = UI.Screen
})
UI:Create("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), Parent = Watermark})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Watermark})
UI:Create("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Parent = Watermark})
RegisterAccent(function(c) local s = Watermark:FindFirstChildOfClass("UIStroke"); if s then s.Color = c end end)

-- Watermark Drag
local wmDrag, wmStart, wmPos = false, nil, nil
Watermark.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then wmDrag = true; wmStart = i.Position; wmPos = Watermark.Position end end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then wmDrag = false end end)
UserInputService.InputChanged:Connect(function(i) if wmDrag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - wmStart; Watermark.Position = UDim2.new(wmPos.X.Scale, wmPos.X.Offset + d.X, wmPos.Y.Scale, wmPos.Y.Offset + d.Y) end end)

task.spawn(function()
    while task.wait(1) do
        if UI.Active and Config.Misc.Watermark then
            local fps = math.floor(1 / RunService.RenderStepped:Wait())
            local ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            Watermark.Text = string.format("Beep %s | FPS: %d | Ping: %dms | %s", BEEP_VERSION, fps, ping, os.date("%H:%M:%S"))
            Watermark.Visible = true
        else Watermark.Visible = false end
    end
end)

-- ============================================
-- CREATE ALL TABS
-- ============================================
local CombatPage = UI:CreateTab("Combat")
local VisualsPage = UI:CreateTab("Visuals")
local PhysicsPage = UI:CreateTab("Physics")
local MiscPage = UI:CreateTab("Misc")

-- ============================================
-- COMBAT TAB CONTROLS
-- ============================================
-- Section: Aim Assist
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  AIM ASSIST", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = CombatPage})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = CombatPage:FindFirstChild("TextLabel")})

UI:CreateToggle(CombatPage, "Silent Aim", "Combat", "SilentAim")
UI:CreateSlider(CombatPage, "FOV Size", 50, 500, "Combat", "FOV")
UI:CreateSlider(CombatPage, "Smoothness", 1, 20, "Combat", "Smoothness")
UI:CreateToggle(CombatPage, "Show FOV Circle", "Combat", "ShowFOV")
UI:CreateSelector(CombatPage, "Target Part", "Combat", "TargetPart", {"Head", "HumanoidRootPart", "Torso"})
UI:CreateToggle(CombatPage, "Hold to Aim", "Combat", "HoldToAim")
UI:CreateKeybind(CombatPage, "Aim Hold Key", "Combat", "AimHoldKey")
UI:CreateToggle(CombatPage, "Team Check", "Combat", "TeamCheck")
UI:CreateKeybind(CombatPage, "Lock Target Key", "Combat", "LockKey")
UI:CreateToggle(CombatPage, "Target Switcher", "Combat", "TargetSwitcher")

-- Section: Shooting
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  SHOOTING", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = CombatPage})
UI:CreateToggle(CombatPage, "Triggerbot", "Combat", "Triggerbot")
UI:CreateToggle(CombatPage, "Auto Shoot (Locked)", "Combat", "AutoShoot")
UI:CreateToggle(CombatPage, "Ultra Rapid Fire", "Combat", "UltraRapidFire")
UI:CreateToggle(CombatPage, "Kill Aura", "Combat", "KillAura")
UI:CreateSlider(CombatPage, "Kill Aura Range", 5, 50, "Combat", "KillAuraRange")

-- Section: Ragebot
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  RAGEBOT", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = CombatPage})
UI:CreateToggle(CombatPage, "Ragebot", "Combat", "Ragebot")
UI:CreateSelector(CombatPage, "Game Profile", "Combat", "RagebotGameProfile", {"Auto", "Manual", "Universal", "Rivals", "Arsenal", "Jailbreak"})
UI:CreateSelector(CombatPage, "Target Mode", "Combat", "RagebotMode", {"Closest", "Lowest Health"})
UI:CreateSelector(CombatPage, "Target Part", "Combat", "RagebotTargetPart", {"Head", "HumanoidRootPart", "Torso"})
UI:CreateToggle(CombatPage, "Full Map Range", "Combat", "RagebotFullMap")
UI:CreateSlider(CombatPage, "Max Distance", 100, 10000, "Combat", "RagebotMaxDistance")
UI:CreateSlider(CombatPage, "Prediction", 0, 100, "Combat", "RagebotPrediction")
UI:CreateToggle(CombatPage, "Visible Check", "Combat", "RagebotVisibleCheck")
UI:CreateToggle(CombatPage, "Team Check", "Combat", "RagebotTeamCheck")
UI:CreateToggle(CombatPage, "Ignore Force Fields", "Combat", "RagebotIgnoreImmune")
UI:CreateToggle(CombatPage, "Face Target", "Combat", "RagebotFaceTarget")
UI:CreateToggle(CombatPage, "Auto TP to Target", "Combat", "RagebotAutoTP")
UI:CreateSelector(CombatPage, "TP Mode", "Combat", "RagebotTPMode", {"Teleport", "Lerp"})
UI:CreateSlider(CombatPage, "TP Speed", 50, 500, "Combat", "RagebotTPSpeed")
UI:CreateSlider(CombatPage, "TP Offset", 1, 20, "Combat", "RagebotTPOffset")
UI:CreateToggle(CombatPage, "Ragebot NoClip", "Combat", "RagebotNoClip")

-- ============================================
-- VISUALS TAB CONTROLS
-- ============================================
-- Section: ESP
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  ESP", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = VisualsPage})
UI:CreateToggle(VisualsPage, "Enable ESP", "Visuals", "Enabled")
UI:CreateToggle(VisualsPage, "Show Names", "Visuals", "Names")
UI:CreateToggle(VisualsPage, "Show Distance", "Visuals", "Distance")
UI:CreateToggle(VisualsPage, "Show User IDs", "Visuals", "IDs")
UI:CreateToggle(VisualsPage, "Head Dot", "Visuals", "HeadDot")

-- Section: Highlights
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  HIGHLIGHTS", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = VisualsPage})
UI:CreateToggle(VisualsPage, "3D Chams", "Visuals", "Skeletons")
UI:CreateToggle(VisualsPage, "Box ESP 2D", "Visuals", "BoxESP")
UI:CreateToggle(VisualsPage, "Skeleton ESP", "Visuals", "SkeletonESP")
UI:CreateToggle(VisualsPage, "Tracers", "Visuals", "Tracers")
UI:CreateToggle(VisualsPage, "Health Bars", "Visuals", "HealthBars")

-- ============================================
-- PHYSICS TAB CONTROLS
-- ============================================
-- Section: Movement
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  MOVEMENT", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = PhysicsPage})
UI:CreateToggle(PhysicsPage, "Speed Hack", "Physics", "SpeedEnabled", function(v) if not v then Config.Physics.SpeedActive = false end end)
UI:CreateSlider(PhysicsPage, "Speed Multiplier", 1, 10, "Physics", "Speed")
UI:CreateKeybind(PhysicsPage, "Speed Toggle Key", "Physics", "SpeedKey")
UI:CreateToggle(PhysicsPage, "Jump Power", "Physics", "JumpEnabled")
UI:CreateSlider(PhysicsPage, "Jump Power Value", 50, 500, "Physics", "JumpPower")

-- Section: Fly
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  FLY", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = PhysicsPage})
UI:CreateToggle(PhysicsPage, "Fly Mode", "Physics", "Fly")
UI:CreateSlider(PhysicsPage, "Fly Speed", 10, 200, "Physics", "FlySpeed")
UI:CreateKeybind(PhysicsPage, "Fly Toggle Key", "Physics", "FlyKey")

-- Section: NoClip
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  NOCLIP", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = PhysicsPage})
UI:CreateToggle(PhysicsPage, "NoClip Mode", "Physics", "NoClip")
UI:CreateKeybind(PhysicsPage, "NoClip Toggle Key", "Misc", "NoClipToggleKey")

-- Section: Teleport
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  TELEPORT", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = PhysicsPage})
UI:CreateToggle(PhysicsPage, "Click Teleport", "Physics", "ClickTP")
UI:CreateKeybind(PhysicsPage, "Click TP Key", "Physics", "ClickTPKey")

-- ============================================
-- MISC TAB CONTROLS
-- ============================================
-- Section: World
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  WORLD", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = MiscPage})
UI:CreateToggle(MiscPage, "Fullbright", "Misc", "Fullbright")
UI:CreateToggle(MiscPage, "Remove Fog", "Misc", "RemoveFog")

-- Section: Player
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  PLAYER", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = MiscPage})
UI:CreateToggle(MiscPage, "Infinite Jump", "Misc", "InfiniteJump")
UI:CreateToggle(MiscPage, "Anti-AFK", "Misc", "AntiAFK")

-- Section: Camera
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  CAMERA", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = MiscPage})
UI:CreateToggle(MiscPage, "FOV Changer", "Misc", "FOVChanger")
UI:CreateSlider(MiscPage, "Field of View", 30, 120, "Misc", "FOVValue")

-- Section: UI
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  UI", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = MiscPage})
UI:CreateToggle(MiscPage, "Show Watermark", "Misc", "Watermark")
UI:CreateKeybind(MiscPage, "Panic Key", "Misc", "PanicKey")

-- Section: Theme Accent Colors
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  THEME ACCENT", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = MiscPage})

local ThemeFrame = UI:Create("Frame", {Size = UDim2.new(1, -8, 0, 50), BackgroundColor3 = Theme.Card, Parent = MiscPage})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ThemeFrame})
UI:Create("TextLabel", {Size = UDim2.new(0, 100, 1, 0), Position = UDim2.new(0, 12, 0, 0), BackgroundTransparency = 1, Text = "Accent Color", TextColor3 = Theme.Text, Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = ThemeFrame})

local ThemeColors = {
    Color3.fromRGB(138, 43, 226),  -- Purple (Default)
    Color3.fromRGB(255, 80, 80),   -- Red
    Color3.fromRGB(80, 160, 255),  -- Blue
    Color3.fromRGB(80, 255, 120),  -- Green
    Color3.fromRGB(255, 200, 80),  -- Yellow
    Color3.fromRGB(255, 80, 200),  -- Pink
    Color3.fromRGB(0, 255, 255),   -- Cyan
    Color3.fromRGB(255, 128, 0),   -- Orange
}

for i, color in ipairs(ThemeColors) do
    local ColorBtn = UI:Create("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 110 + ((i-1) * 34), 0.5, -14),
        BackgroundColor3 = color, Text = "", AutoButtonColor = false, Parent = ThemeFrame
    })
    UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ColorBtn})
    UI:Create("UIStroke", {Color = Theme.Border, Thickness = 2, Parent = ColorBtn})
    
    ColorBtn.MouseButton1Click:Connect(function()
        RefreshAccent(color)
        UI:Notify("Theme changed!")
        for _, btn in pairs(ThemeFrame:GetChildren()) do
            if btn:IsA("TextButton") then
                local stroke = btn:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Color = Theme.Border; stroke.Thickness = 2 end
            end
        end
        local myStroke = ColorBtn:FindFirstChildOfClass("UIStroke")
        if myStroke then myStroke.Color = Theme.Text; myStroke.Thickness = 3 end
    end)
end

-- Teleport to Player
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  TELEPORT TO PLAYER", TextColor3 = Theme.Accent, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = MiscPage})

local TPFrame = UI:Create("Frame", {Size = UDim2.new(1, -8, 0, 38), BackgroundColor3 = Theme.Card, Parent = MiscPage})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = TPFrame})

local TPBox = UI:Create("TextBox", {
    Size = UDim2.new(0.6, -10, 0, 26), Position = UDim2.new(0, 10, 0.5, -13),
    BackgroundColor3 = Theme.Surface, Text = "", PlaceholderText = "Player name...",
    TextColor3 = Theme.Text, PlaceholderColor3 = Theme.TextDim, Font = Enum.Font.Gotham, TextSize = 11, Parent = TPFrame
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TPBox})

local TPBtn = UI:Create("TextButton", {
    Size = UDim2.new(0.35, 0, 0, 26), Position = UDim2.new(0.62, 0, 0.5, -13),
    BackgroundColor3 = Theme.Accent, Text = "Teleport", TextColor3 = Theme.Text,
    Font = Enum.Font.GothamBold, TextSize = 11, AutoButtonColor = false, Parent = TPFrame
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TPBtn})
RegisterAccent(function(c) TPBtn.BackgroundColor3 = c end)

TPBtn.MouseButton1Click:Connect(function()
    if not UI.Active then return end
    local name = TPBox.Text:lower()
    if name == "" then UI:Notify("Enter a player name"); return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and (player.Name:lower():find(name) or player.DisplayName:lower():find(name)) then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if root and myRoot then
                myRoot.CFrame = root.CFrame + Vector3.new(0, 3, 0)
                UI:Notify("Teleported to " .. player.DisplayName)
                TPBox.Text = ""
                return
            end
        end
    end
    UI:Notify("Player not found")
end)

-- Exit Cheat Button
UI:Create("TextLabel", {Size = UDim2.new(1, -8, 0, 26), BackgroundColor3 = Theme.Surface, Text = "  DANGER ZONE", TextColor3 = Theme.Error, Font = Enum.Font.GothamBold, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = MiscPage})

local ExitBtn = UI:Create("TextButton", {
    Size = UDim2.new(1, -8, 0, 38), BackgroundColor3 = Color3.fromRGB(60, 20, 20),
    Text = "EXIT CHEAT", TextColor3 = Theme.Error, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false, Parent = MiscPage
})
UI:Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ExitBtn})
UI:Create("UIStroke", {Color = Theme.Error, Thickness = 1, Transparency = 0.5, Parent = ExitBtn})

ExitBtn.MouseEnter:Connect(function() TweenService:Create(ExitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Error}):Play() end)
ExitBtn.MouseLeave:Connect(function() TweenService:Create(ExitBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 20, 20)}):Play() end)

ExitBtn.MouseButton1Click:Connect(function()
    UI.Active = false
    UI:Notify("Goodbye!")
    task.wait(0.5)
    -- Cleanup all visuals
    for _, obj in pairs(ESPObjects) do pcall(function() obj:Destroy() end) end
    for _, t in pairs(TracerConnections) do pcall(function() t.line:Remove(); t.connection:Disconnect() end) end
    for _, b in pairs(BoxConnections) do pcall(function() b.box:Remove(); b.connection:Disconnect() end) end
    for _, s in pairs(SkeletonConnections) do pcall(function() for _, l in pairs(s.lines) do l.line:Remove() end; s.connection:Disconnect() end) end
    -- Restore lighting
    pcall(function() Lighting.Brightness = origLight.Brightness; Lighting.ClockTime = origLight.ClockTime; Lighting.FogEnd = origLight.FogEnd; Lighting.GlobalShadows = origLight.GlobalShadows; Lighting.Ambient = origLight.Ambient end)
    -- Destroy fly
    DisableFly()
    -- Destroy UI
    UI.Screen:Destroy()
end)

-- ============================================
-- STARTUP
-- ============================================
UI:Notify("Beep "..BEEP_VERSION.." loaded. Press INSERT to toggle menu.") = UI:CreateTab("Combat")
local VisualsPage = UI:CreateTab("Visuals")
local PhysicsPage = UI:CreateTab("Physics")
local MiscPage = UI:CreateTab("Misc")

-- Combat Tab
UI:CreateToggle(CombatPage, "Aim Assist", "Combat", "SilentAim")
UI:CreateSelector(CombatPage, "Target Part", "Combat", "TargetPart", {"Head", "UpperTorso", "Torso", "HumanoidRootPart"})
UI:CreateToggle(CombatPage, "Hold to Aim", "Combat", "HoldToAim")
UI:CreateKeybind(CombatPage, "Aim Hold Key", "Combat", "AimHoldKey")
UI:CreateToggle(CombatPage, "Team Check", "Combat", "TeamCheck")
UI:CreateSlider(CombatPage, "FOV Radius", 50, 400, "Combat", "FOV")
UI:CreateSlider(CombatPage, "Smoothness", 1, 10, "Combat", "Smoothness")
UI:CreateToggle(CombatPage, "Show FOV Circle", "Combat", "ShowFOV")
UI:CreateKeybind(CombatPage, "Lock Target Key", "Combat", "LockKey")
UI:CreateToggle(CombatPage, "Auto Shoot", "Combat", "AutoShoot")
UI:CreateToggle(CombatPage, "Triggerbot", "Combat", "Triggerbot")
UI:CreateSlider(CombatPage, "Trigger Delay", 0, 1, "Combat", "TriggerDelay")
UI:CreateToggle(CombatPage, "Ultra Rapid Fire", "Combat", "UltraRapidFire")
UI:CreateToggle(CombatPage, "No Recoil", "Combat", "NoRecoil")
UI:CreateToggle(CombatPage, "Kill Aura", "Combat", "KillAura")
UI:CreateSlider(CombatPage, "Kill Aura Range", 5, 50, "Combat", "KillAuraRange")
UI:CreateToggle(CombatPage, "Target Switcher", "Combat", "TargetSwitcher")
