-- Beep Multi-Tool Framework
-- Universal ESP, Aimbot & Physics Controller

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
        IDs = false,
        Skeletons = false,
        Accent = Color3.fromRGB(140, 80, 255)
    },
    Combat = {
        SilentAim = false,
        FOV = 150,
        Smoothness = 0.5,
        TargetPart = "Head",
        ShowFOV = true,
        LockKey = "Q",
        LockedTarget = nil
    },
    Physics = {
        Speed = 1,
        JumpPower = 100,
        NoClip = false,
        Fly = false,
        FlySpeed = 50,
        FlyKey = "E",
        SpeedEnabled = false,
        SpeedKey = "LeftControl",
        JumpEnabled = false
    },
    Misc = {
        Tracers = false,
        HealthBars = false,
        Fullbright = false,
        InfiniteJump = false,
        FOVChanger = false,
        FOVValue = 70,
        KillAura = false,
        KillAuraRange = 20,
        TeleportPlayer = nil
    }
}

-- UI Constructor
local UI = { Tabs = {}, CurrentTab = nil, Visible = true, Active = true }

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
    Parent = CoreGui
})

local Main = UI:Create("Frame", {
    Size = UDim2.new(0, 640, 0, 460), 
    Position = UDim2.new(0.5, -320, 0.5, -230),
    BackgroundColor3 = Color3.fromRGB(12, 10, 18),
    BorderSizePixel = 0, 
    ZIndex = 1,
    Parent = UI.Screen
})
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local MainStroke = UI:Create("UIStroke", {
    Color = Color3.fromRGB(60, 40, 90),
    Thickness = 1.5, 
    Parent = Main
})

-- Sidebar
local Sidebar = UI:Create("Frame", {
    Size = UDim2.new(0, 160, 1, 0), 
    BackgroundColor3 = Color3.fromRGB(18, 14, 26),
    ZIndex = 2,
    Parent = Main
})
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

-- Pages Container
local Container = UI:Create("Frame", {
    Size = UDim2.new(1, -170, 1, -80), 
    Position = UDim2.new(0, 170, 0, 10),
    BackgroundTransparency = 1, 
    ZIndex = 2,
    Parent = Main
})

-- Branding
local ProjectLabel = UI:Create("TextLabel", {
    Size = UDim2.new(0, 200, 0, 20),
    Position = UDim2.new(0, 15, 1, -25),
    BackgroundTransparency = 1,
    Text = "Beep Framework",
    TextColor3 = Config.Visuals.Accent,
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5,
    Parent = Main
})

-- Close Button
local CloseMenuBtn = UI:Create("TextButton", {
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0, 10),
    BackgroundColor3 = Color3.fromRGB(231, 76, 60),
    Text = "X",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    ZIndex = 15,
    Parent = Main
})
Instance.new("UICorner", CloseMenuBtn).CornerRadius = UDim.new(0, 6)

CloseMenuBtn.MouseButton1Click:Connect(function()
    UI.Active = false
    Config.Physics.Fly = false
    Config.Combat.LockedTarget = nil
    
    -- Clean up all ESP objects
    for _, obj in pairs(ESPObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    ESPObjects = {}
    
    -- Clean up tracers
    if TracerFolder then
        TracerFolder:Destroy()
    end
    
    UI.Screen:Destroy()
end)

-- Notification System
function UI:Notify(text)
    if not UI.Active then return end
    task.spawn(function()
        local n = UI:Create("Frame", {
            Size = UDim2.new(0, 280, 0, 45), 
            Position = UDim2.new(1, 10, 0.8, 0),
            BackgroundColor3 = Color3.fromRGB(20, 15, 30), 
            ZIndex = 20,
            Parent = UI.Screen
        })
        Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
        UI:Create("UIStroke", {Color = Config.Visuals.Accent, Thickness = 1, Parent = n})
        
        UI:Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0), 
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1, 
            Text = text,
            TextColor3 = Color3.new(1,1,1), 
            Font = Enum.Font.GothamBold, 
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 21,
            Parent = n
        })
        
        n:TweenPosition(UDim2.new(0.98, -280, 0.8, 0), "Out", "Back", 0.4)
        task.wait(3)
        if n and n.Parent then
            n:TweenPosition(UDim2.new(1, 10, 0.8, 0), "In", "Quad", 0.4)
            task.wait(0.5) 
            n:Destroy()
        end
    end)
end

-- Dragging System
local dragToggle = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(Main, TweenInfo.new(0.10), {Position = position}):Play()
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
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
        ScrollBarThickness = 2,
        Visible = false,
        ZIndex = 3,
        Parent = Container
    })
    local Layout = UI:Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = Page
    })
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
    end)
    
    local TabButton = UI:Create("TextButton", {
        Size = UDim2.new(0, 140, 0, 35),
        Position = UDim2.new(0, 10, 0, 20 + (tabIndex * 42)),
        BackgroundColor3 = Color3.fromRGB(26, 20, 36),
        Text = name,
        TextColor3 = Color3.fromRGB(150, 140, 160),
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        ZIndex = 3,
        Parent = Sidebar
    })
    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)
    
    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(Sidebar:GetChildren()) do 
            if v:IsA("TextButton") and v ~= CloseMenuBtn then v.TextColor3 = Color3.fromRGB(150, 140, 160) end 
        end
        Page.Visible = true
        TabButton.TextColor3 = Config.Visuals.Accent
    end)
    
    if tabIndex == 0 then
        Page.Visible = true
        TabButton.TextColor3 = Config.Visuals.Accent
    end
    
    table.insert(UI.Tabs, Page)
    return Page
end

function UI:CreateToggle(parent, text, configSection, configKey, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 40), BackgroundColor3 = Color3.fromRGB(22, 18, 32), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    UI:Create("TextLabel", {Size = UDim2.new(0.6, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    
    local Indicator = UI:Create("TextButton", {
        Size = UDim2.new(0, 70, 0, 24), Position = UDim2.new(1, -80, 0.5, -12),
        BackgroundColor3 = Config[configSection][configKey] and Config.Visuals.Accent or Color3.fromRGB(45, 35, 60),
        Text = Config[configSection][configKey] and "[ ON ]" or "[ OFF ]",
        TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 5, Parent = Frame
    })
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 6)
    
    Indicator.MouseButton1Click:Connect(function()
        if not UI.Active then return end
        local state = not Config[configSection][configKey]
        Config[configSection][configKey] = state
        Indicator.BackgroundColor3 = state and Config.Visuals.Accent or Color3.fromRGB(45, 35, 60)
        Indicator.Text = state and "[ ON ]" or "[ OFF ]"
        if callback then callback(state) end
    end)
end

function UI:CreateSlider(parent, text, min, max, configSection, configKey, callback)
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 50), BackgroundColor3 = Color3.fromRGB(22, 18, 32), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = UI:Create("TextLabel", {Size = UDim2.new(0.7, 0, 0, 25), Position = UDim2.new(0, 10, 0, 2), BackgroundTransparency = 1, Text = text .. ": " .. tostring(Config[configSection][configKey]), TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    local SlideBar = UI:Create("Frame", {Size = UDim2.new(1, -20, 0, 6), Position = UDim2.new(0, 10, 0, 34), BackgroundColor3 = Color3.fromRGB(45, 35, 60), ZIndex = 5, Parent = Frame})
    Instance.new("UICorner", SlideBar).CornerRadius = UDim.new(0, 3)
    
    local Fill = UI:Create("Frame", {Size = UDim2.new((Config[configSection][configKey] - min)/(max - min), 0, 1, 0), BackgroundColor3 = Config.Visuals.Accent, ZIndex = 5, Parent = SlideBar})
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 3)
    
    local Trigger = UI:Create("TextButton", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", ZIndex = 6, Parent = SlideBar})
    
    local function update(input)
        local pos = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (pos * (max - min)))
        Config[configSection][configKey] = val
        Label.Text = text .. ": " .. tostring(val)
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
    local Frame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 40), BackgroundColor3 = Color3.fromRGB(22, 18, 32), ZIndex = 4, Parent = parent})
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    UI:Create("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = Frame})
    
    local KeyButton = UI:Create("TextButton", {
        Size = UDim2.new(0, 70, 0, 24), Position = UDim2.new(1, -80, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(45, 35, 60),
        Text = Config[configSection][configKey],
        TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 5, Parent = Frame
    })
    Instance.new("UICorner", KeyButton).CornerRadius = UDim.new(0, 6)
    
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
            end
        end)
    end)
end

-- Combat System
local Combat = {}
function Combat:GetClosestPlayer()
    local closest = nil
    local shortestDistance = Config.Combat.FOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local part = player.Character:FindFirstChild(Config.Combat.TargetPart) or player.Character:FindFirstChildOfClass("MeshPart") or player.Character:FindFirstChild("HumanoidRootPart")
            if part then
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
    
    local part = target.Character:FindFirstChild(Config.Combat.TargetPart) or target.Character:FindFirstChildOfClass("MeshPart") or target.Character:FindFirstChild("HumanoidRootPart")
    if not part then return false end
    
    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
    if not onScreen then return false end
    
    local mousePos = Vector2.new(Mouse.X, Mouse.Y)
    local targetPos = Vector2.new(screenPos.X, screenPos.Y)
    local distance = (mousePos - targetPos).Magnitude
    
    return distance <= Config.Combat.FOV
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
                Config.Combat.LockedTarget = target
                UI:Notify("Target Locked: " .. target.DisplayName)
            else
                UI:Notify("No target in FOV")
            end
        end
    end
    
    -- Speed Hack Toggle
    if input.KeyCode.Name == Config.Physics.SpeedKey then
        Config.Physics.SpeedEnabled = not Config.Physics.SpeedEnabled
        UI:Notify(Config.Physics.SpeedEnabled and "Speed Hack: ON" or "Speed Hack: OFF")
    end
end)

RunService.RenderStepped:Connect(function()
    if not UI.Active then return end
    if Config.Combat.SilentAim then
        local target = nil
        
        -- Check if we have a locked target and if it's still valid
        if Config.Combat.LockedTarget then
            if Combat:IsTargetValid(Config.Combat.LockedTarget) then
                target = Config.Combat.LockedTarget
            else
                Config.Combat.LockedTarget = nil
                UI:Notify("Target Lost")
            end
        else
            -- No locked target, get closest player
            target = Combat:GetClosestPlayer()
        end
        
        if target and target.Character then
            local targetPart = target.Character:FindFirstChild(Config.Combat.TargetPart) or target.Character:FindFirstChildOfClass("MeshPart") or target.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, Config.Combat.Smoothness * 0.1)
            end
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
                
                for _, box in pairs(trackingParts) do
                    if box and box.Parent then
                        box.Visible = visualsEnabled and Config.Visuals.Skeletons
                    end
                end
                
                if visualsEnabled then
                    local rootPart = char:FindFirstChild("HumanoidRootPart") or head
                    local distance = math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude)
                    local text = player.DisplayName
                    if Config.Visuals.IDs then text = text .. " [" .. player.UserId .. "]" end
                    if Config.Visuals.Names then label.Text = text .. "\n" .. distance .. "m" else label.Text = "" end
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
local TracerFolder = Instance.new("Folder", CoreGui)
TracerFolder.Name = "BeepTracers"

local function CreateTracer(player)
    if player == LocalPlayer then return end
    
    local function setupTracer(char)
        local rootPart = char:WaitForChild("HumanoidRootPart", 5)
        if not rootPart then return end
        
        local attachment0 = Instance.new("Attachment", Camera)
        local attachment1 = Instance.new("Attachment", rootPart)
        local beam = Instance.new("Beam", TracerFolder)
        
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.Color = ColorSequence.new(Config.Visuals.Accent)
        beam.Width0 = 0.1
        beam.Width1 = 0.1
        beam.FaceCamera = true
        beam.Enabled = false
        
        task.spawn(function()
            while beam.Parent and char:IsDescendantOf(Workspace) and UI.Active do
                beam.Enabled = Config.Misc.Tracers
                task.wait(0.1)
            end
            beam:Destroy()
            attachment0:Destroy()
            attachment1:Destroy()
        end)
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
                billboardGui.Enabled = Config.Misc.HealthBars
                if Config.Misc.HealthBars then
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

-- Fullbright System
local Lighting = game:GetService("Lighting")
local originalLighting = {
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    GlobalShadows = Lighting.GlobalShadows,
    Ambient = Lighting.Ambient
}

RunService.RenderStepped:Connect(function()
    if Config.Misc.Fullbright and UI.Active then
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(1, 1, 1)
    else
        Lighting.Brightness = originalLighting.Brightness
        Lighting.ClockTime = originalLighting.ClockTime
        Lighting.FogEnd = originalLighting.FogEnd
        Lighting.GlobalShadows = originalLighting.GlobalShadows
        Lighting.Ambient = originalLighting.Ambient
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

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Config.Misc.InfiniteJump and UI.Active then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Kill Aura System
RunService.Heartbeat:Connect(function()
    if not Config.Misc.KillAura or not UI.Active then return end
    local char = LocalPlayer.Character
    if not char then return end
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local enemyHum = player.Character:FindFirstChildOfClass("Humanoid")
            if enemyRoot and enemyHum and enemyHum.Health > 0 then
                local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                if distance <= Config.Misc.KillAuraRange then
                    -- Simulate attack - this works for most Roblox games
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
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
        if not Config.Physics.Fly or not UI.Active then
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
        Config.Physics.Fly = not Config.Physics.Fly
        if Config.Physics.Fly then
            EnableFly()
            UI:Notify("Fly Mode: ON")
        else
            DisableFly()
            UI:Notify("Fly Mode: OFF")
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
    if Config.Physics.SpeedEnabled and hum.MoveDirection.Magnitude > 0 then
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
    
    -- Only apply NoClip if enabled
    if Config.Physics.NoClip then
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
UI:CreateSlider(CombatPage, "FOV Radius", 50, 400, "Combat", "FOV")
UI:CreateSlider(CombatPage, "Smoothness", 1, 10, "Combat", "Smoothness")
UI:CreateToggle(CombatPage, "Show FOV Circle", "Combat", "ShowFOV")
UI:CreateKeybind(CombatPage, "Lock/Unlock Target", "Combat", "LockKey")

-- Visual Controls
UI:CreateToggle(VisualsPage, "Enable ESP", "Visuals", "Enabled")
UI:CreateToggle(VisualsPage, "Show Names", "Visuals", "Names")
UI:CreateToggle(VisualsPage, "Show IDs", "Visuals", "IDs")
UI:CreateToggle(VisualsPage, "3D Boxes / Chams", "Visuals", "Skeletons")

-- Physics Controls
UI:CreateToggle(PhysicsPage, "Enable Speed Hack", "Physics", "SpeedEnabled")
UI:CreateSlider(PhysicsPage, "Speed Multiplier", 1, 5, "Physics", "Speed")
UI:CreateKeybind(PhysicsPage, "Speed Toggle Key", "Physics", "SpeedKey")
UI:CreateToggle(PhysicsPage, "Enable Jump Boost", "Physics", "JumpEnabled")
UI:CreateSlider(PhysicsPage, "Jump Power", 50, 300, "Physics", "JumpPower")
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
UI:CreateToggle(MiscPage, "Tracers", "Misc", "Tracers")
UI:CreateToggle(MiscPage, "Health Bars", "Misc", "HealthBars")
UI:CreateToggle(MiscPage, "Fullbright", "Misc", "Fullbright")
UI:CreateToggle(MiscPage, "Infinite Jump", "Misc", "InfiniteJump")
UI:CreateToggle(MiscPage, "FOV Changer", "Misc", "FOVChanger")
UI:CreateSlider(MiscPage, "FOV Value", 70, 120, "Misc", "FOVValue")
UI:CreateToggle(MiscPage, "Kill Aura", "Misc", "KillAura")
UI:CreateSlider(MiscPage, "Kill Aura Range", 5, 50, "Misc", "KillAuraRange")

-- Teleport to Player Section
local TeleportFrame = UI:Create("Frame", {Size = UDim2.new(1, -10, 0, 90), BackgroundColor3 = Color3.fromRGB(22, 18, 32), ZIndex = 4, Parent = MiscPage})
Instance.new("UICorner", TeleportFrame).CornerRadius = UDim.new(0, 6)

UI:Create("TextLabel", {
    Size = UDim2.new(1, -20, 0, 25), Position = UDim2.new(0, 10, 0, 5),
    BackgroundTransparency = 1, Text = "Teleport to Player",
    TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 5, Parent = TeleportFrame
})

local PlayerDropdown = UI:Create("TextButton", {
    Size = UDim2.new(1, -20, 0, 30), Position = UDim2.new(0, 10, 0, 35),
    BackgroundColor3 = Color3.fromRGB(45, 35, 60), Text = "Select Player...",
    TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 11, ZIndex = 5, Parent = TeleportFrame
})
Instance.new("UICorner", PlayerDropdown).CornerRadius = UDim.new(0, 6)

local TeleportBtn = UI:Create("TextButton", {
    Size = UDim2.new(0, 100, 0, 25), Position = UDim2.new(1, -110, 1, -30),
    BackgroundColor3 = Config.Visuals.Accent, Text = "TELEPORT",
    TextColor3 = Color3.new(1,1,1), Font = Enum.Font.GothamBold, TextSize = 11, ZIndex = 5, Parent = TeleportFrame
})
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 6)

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
    DropdownList = UI:Create("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 150), Position = UDim2.new(0, 10, 0, 70),
        BackgroundColor3 = Color3.fromRGB(30, 25, 40), ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0), ZIndex = 10, Parent = TeleportFrame
    })
    Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
    
    local Layout = UI:Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = DropdownList})
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        DropdownList.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = UI:Create("TextButton", {
                Size = UDim2.new(1, -5, 0, 25), BackgroundColor3 = Color3.fromRGB(45, 35, 60),
                Text = player.DisplayName, TextColor3 = Color3.new(1,1,1),
                Font = Enum.Font.Gotham, TextSize = 10, ZIndex = 11, Parent = DropdownList
            })
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
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

UI:Notify("Beep loaded. Press 'Insert' to toggle menu.")
