-- Beep v4.0.0 - Custom Black+Purple UI
local BEEP_VERSION = "v4.0.0"
if not game:IsLoaded() then repeat task.wait(0.1) until game:IsLoaded() or tick() > 30 end

local CoreGui = game:GetService("CoreGui")
for _, v in pairs(CoreGui:GetChildren()) do if v:IsA("ScreenGui") and v.Name:find("Beep_") then v:Destroy() end end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local WS = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()
local Camera = WS.CurrentCamera

local Theme = {
    Bg = Color3.fromRGB(12, 12, 16), Surface = Color3.fromRGB(18, 18, 24), Card = Color3.fromRGB(24, 24, 32),
    Accent = Color3.fromRGB(138, 43, 226), Text = Color3.fromRGB(255, 255, 255), Dim = Color3.fromRGB(140, 140, 160),
    Border = Color3.fromRGB(48, 48, 64), Red = Color3.fromRGB(255, 80, 80), Green = Color3.fromRGB(80, 255, 120)
}

local Config = {
    Visuals = {Enabled=false, Names=false, Distance=false, IDs=false, Skeletons=false, SkeletonESP=false, Tracers=false, HealthBars=false, BoxESP=false, HeadDot=false},
    Combat = {SilentAim=false, FOV=150, Smoothness=5, TargetPart="Head", ShowFOV=false, LockKey="Q", LockedTarget=nil, Triggerbot=false, TriggerDelay=0.1, AutoShoot=false, ShootDelay=0.15, TeamCheck=true, HoldToAim=false, AimHoldKey="MouseButton2", UltraRapidFire=false, UltraRapidFireDelay=0.02, KillAura=false, KillAuraRange=20, KillAuraTeamCheck=true, TargetSwitcher=false, TargetSwitcherDelay=0.1, Ragebot=false, RagebotTargetPart="Head", RagebotMode="Closest", RagebotFullMap=false, RagebotTeamCheck=true, RagebotVisibleCheck=false, RagebotMaxDistance=5000, RagebotPrediction=0, RagebotAutoTP=false, RagebotTPMode="Teleport", RagebotTPSpeed=150, RagebotTPOffset=6, RagebotNoClip=false, RagebotGameProfile="Auto", RagebotFaceTarget=false, RagebotIgnoreImmune=false},
    Physics = {Speed=1, JumpPower=100, NoClip=false, Fly=false, FlySpeed=50, FlyKey="E", SpeedEnabled=false, SpeedActive=false, SpeedKey="LeftControl", JumpEnabled=false, ClickTP=false, ClickTPKey="LeftControl", FlyActive=false, NoClipActive=false},
    Misc = {Fullbright=false, InfiniteJump=false, FOVChanger=false, FOVValue=70, AntiAFK=false, Watermark=true, NoClipToggleKey="F2", PanicKey="End"}
}

local UI = {Tabs={}, Visible=true, Active=true}
local AccentFns, ESPObjs, TracerConns, BoxConns, SkelConns = {}, {}, {}, {}, {}
local function RegAccent(fn) table.insert(AccentFns, fn); pcall(fn, Theme.Accent) end
local function RefreshAccent(c) Theme.Accent = c; for _, fn in ipairs(AccentFns) do pcall(fn, c) end end

function UI:Create(cls, props) local i = Instance.new(cls); for k, v in pairs(props) do pcall(function() i[k] = v end) end; return i end

UI.Screen = UI:Create("ScreenGui", {Name="Beep_"..game:GetService("HttpService"):GenerateGUID(false), ResetOnSpawn=false, IgnoreGuiInset=true, DisplayOrder=999999, Parent=CoreGui})

local Main = UI:Create("Frame", {Size=UDim2.new(0,560,0,400), Position=UDim2.new(0.5,-280,0.5,-200), BackgroundColor3=Theme.Bg, BorderSizePixel=0, ClipsDescendants=true, Parent=UI.Screen})
UI:Create("UICorner", {CornerRadius=UDim.new(0,10), Parent=Main})
UI:Create("UIStroke", {Color=Theme.Accent, Thickness=2, Transparency=0.3, Parent=Main})
RegAccent(function(c) Main:FindFirstChildOfClass("UIStroke").Color = c end)


local TopBar = UI:Create("Frame", {Size=UDim2.new(1,0,0,38), BackgroundColor3=Theme.Surface, BorderSizePixel=0, Parent=Main})
UI:Create("UICorner", {CornerRadius=UDim.new(0,10), Parent=TopBar})
UI:Create("Frame", {Size=UDim2.new(1,0,0,10), Position=UDim2.new(0,0,1,-10), BackgroundColor3=Theme.Surface, BorderSizePixel=0, Parent=TopBar})

local Logo = UI:Create("TextLabel", {Size=UDim2.new(0,80,1,0), Position=UDim2.new(0,12,0,0), BackgroundTransparency=1, Text="Beep", TextColor3=Theme.Accent, Font=Enum.Font.GothamBlack, TextSize=20, TextXAlignment=Enum.TextXAlignment.Left, Parent=TopBar})
RegAccent(function(c) Logo.TextColor3 = c end)
UI:Create("TextLabel", {Size=UDim2.new(0,45,0,18), Position=UDim2.new(0,70,0.5,-9), BackgroundColor3=Theme.Card, Text=BEEP_VERSION, TextColor3=Theme.Dim, Font=Enum.Font.GothamBold, TextSize=9, Parent=TopBar})

local CloseBtn = UI:Create("TextButton", {Size=UDim2.new(0,26,0,26), Position=UDim2.new(1,-32,0.5,-13), BackgroundColor3=Theme.Card, Text="×", TextColor3=Theme.Red, Font=Enum.Font.GothamBold, TextSize=16, AutoButtonColor=false, Parent=TopBar})
UI:Create("UICorner", {CornerRadius=UDim.new(0,6), Parent=CloseBtn})
CloseBtn.MouseButton1Click:Connect(function() UI.Visible = false; Main.Visible = false end)

local Sidebar = UI:Create("Frame", {Size=UDim2.new(0,120,1,-38), Position=UDim2.new(0,0,0,38), BackgroundColor3=Theme.Surface, BorderSizePixel=0, Parent=Main})
UI:Create("Frame", {Size=UDim2.new(0,1,1,-16), Position=UDim2.new(1,0,0,8), BackgroundColor3=Theme.Border, BorderSizePixel=0, Parent=Sidebar})

local Container = UI:Create("Frame", {Size=UDim2.new(1,-130,1,-45), Position=UDim2.new(0,125,0,42), BackgroundTransparency=1, Parent=Main})

local drag, dStart, sPos = false, nil, nil
TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=true; dStart=i.Position; sPos=Main.Position end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end end)
UIS.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d=i.Position-dStart; Main.Position=UDim2.new(sPos.X.Scale,sPos.X.Offset+d.X,sPos.Y.Scale,sPos.Y.Offset+d.Y) end end)

function UI:Notify(txt)
    if not UI.Active then return end
    task.spawn(function()
        local n = UI:Create("Frame", {Size=UDim2.new(0,260,0,40), Position=UDim2.new(1,10,0.85,0), BackgroundColor3=Theme.Surface, Parent=UI.Screen})
        UI:Create("UICorner", {CornerRadius=UDim.new(0,8), Parent=n})
        UI:Create("UIStroke", {Color=Theme.Accent, Thickness=1.5, Parent=n})
        UI:Create("Frame", {Size=UDim2.new(0,3,1,-10), Position=UDim2.new(0,5,0,5), BackgroundColor3=Theme.Accent, Parent=n})
        UI:Create("TextLabel", {Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,15,0,0), BackgroundTransparency=1, Text=txt, TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Parent=n})
        n:TweenPosition(UDim2.new(0.98,-260,0.85,0), "Out", "Back", 0.3); task.wait(2.5)
        if n.Parent then n:TweenPosition(UDim2.new(1,10,0.85,0), "In", "Quad", 0.3); task.wait(0.4); n:Destroy() end
    end)
end


function UI:CreateTab(name)
    local idx = #UI.Tabs
    local Page = UI:Create("ScrollingFrame", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, CanvasSize=UDim2.new(0,0,0,0), ScrollBarThickness=3, ScrollBarImageColor3=Theme.Accent, Visible=false, Parent=Container})
    RegAccent(function(c) Page.ScrollBarImageColor3 = c end)
    local Layout = UI:Create("UIListLayout", {Padding=UDim.new(0,5), Parent=Page})
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Page.CanvasSize = UDim2.new(0,0,0,Layout.AbsoluteContentSize.Y+10) end)
    
    local TabBtn = UI:Create("TextButton", {Size=UDim2.new(1,-12,0,32), Position=UDim2.new(0,6,0,8+(idx*38)), BackgroundColor3=idx==0 and Theme.Card or Theme.Surface, BackgroundTransparency=idx==0 and 0 or 1, Text="", AutoButtonColor=false, Parent=Sidebar})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,8), Parent=TabBtn})
    local Ind = UI:Create("Frame", {Size=UDim2.new(0,3,0,idx==0 and 18 or 0), Position=UDim2.new(0,0,0.5,idx==0 and -9 or 0), BackgroundColor3=Theme.Accent, Parent=TabBtn})
    UI:Create("UICorner", {CornerRadius=UDim.new(1,0), Parent=Ind})
    RegAccent(function(c) Ind.BackgroundColor3 = c end)
    local Lbl = UI:Create("TextLabel", {Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=name, TextColor3=idx==0 and Theme.Text or Theme.Dim, Font=Enum.Font.GothamMedium, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=TabBtn})
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
        for _, v in pairs(Sidebar:GetChildren()) do if v:IsA("TextButton") then
            local l = v:FindFirstChildOfClass("TextLabel"); local i = v:FindFirstChildOfClass("Frame")
            if l then TS:Create(l, TweenInfo.new(0.15), {TextColor3=Theme.Dim}):Play() end
            TS:Create(v, TweenInfo.new(0.15), {BackgroundTransparency=1}):Play()
            if i then TS:Create(i, TweenInfo.new(0.15), {Size=UDim2.new(0,3,0,0)}):Play() end
        end end
        Page.Visible = true
        TS:Create(TabBtn, TweenInfo.new(0.15), {BackgroundTransparency=0}):Play()
        TS:Create(Lbl, TweenInfo.new(0.15), {TextColor3=Theme.Text}):Play()
        TS:Create(Ind, TweenInfo.new(0.15), {Size=UDim2.new(0,3,0,18)}):Play()
    end)
    if idx == 0 then Page.Visible = true end
    table.insert(UI.Tabs, Page)
    return Page
end

local ToggleInds = {}
local function SetSwitch(t, k, s) TS:Create(t, TweenInfo.new(0.15), {BackgroundColor3=s and Theme.Accent or Theme.Card}):Play(); TS:Create(k, TweenInfo.new(0.15), {Position=s and UDim2.new(1,-16,0.5,-6) or UDim2.new(0,3,0.5,-6)}):Play() end

function UI:CreateToggle(p, txt, sec, key, cb)
    local F = UI:Create("Frame", {Size=UDim2.new(1,-6,0,34), BackgroundColor3=Theme.Card, Parent=p})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,6), Parent=F})
    UI:Create("TextLabel", {Size=UDim2.new(0.7,0,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=txt, TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=F})
    local st = Config[sec][key]
    local T = UI:Create("TextButton", {Size=UDim2.new(0,36,0,18), Position=UDim2.new(1,-44,0.5,-9), BackgroundColor3=st and Theme.Accent or Theme.Card, Text="", AutoButtonColor=false, Parent=F})
    UI:Create("UICorner", {CornerRadius=UDim.new(1,0), Parent=T}); UI:Create("UIStroke", {Color=Theme.Border, Thickness=1, Parent=T})
    local K = UI:Create("Frame", {Size=UDim2.new(0,12,0,12), Position=st and UDim2.new(1,-16,0.5,-6) or UDim2.new(0,3,0.5,-6), BackgroundColor3=Theme.Text, Parent=T})
    UI:Create("UICorner", {CornerRadius=UDim.new(1,0), Parent=K})
    ToggleInds[sec.."."..key] = {t=T, k=K}
    RegAccent(function(c) if Config[sec][key] then T.BackgroundColor3 = c end end)
    T.MouseButton1Click:Connect(function() if not UI.Active then return end; local ns = not Config[sec][key]; Config[sec][key] = ns; SetSwitch(T, K, ns); if cb then cb(ns) end end)
end
function UI:UpdateToggle(sec, key, st) local i = ToggleInds[sec.."."..key]; if i then SetSwitch(i.t, i.k, st) end end


function UI:CreateSlider(p, txt, min, max, sec, key, cb)
    local F = UI:Create("Frame", {Size=UDim2.new(1,-6,0,46), BackgroundColor3=Theme.Card, Parent=p})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,6), Parent=F})
    UI:Create("TextLabel", {Size=UDim2.new(0.6,0,0,20), Position=UDim2.new(0,10,0,3), BackgroundTransparency=1, Text=txt, TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=F})
    local VL = UI:Create("TextLabel", {Size=UDim2.new(0,40,0,20), Position=UDim2.new(1,-50,0,3), BackgroundTransparency=1, Text=tostring(Config[sec][key]), TextColor3=Theme.Accent, Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Right, Parent=F})
    RegAccent(function(c) VL.TextColor3 = c end)
    local SB = UI:Create("Frame", {Size=UDim2.new(1,-20,0,5), Position=UDim2.new(0,10,0,32), BackgroundColor3=Theme.Border, Parent=F})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,3), Parent=SB})
    local Fill = UI:Create("Frame", {Size=UDim2.new((Config[sec][key]-min)/(max-min),0,1,0), BackgroundColor3=Theme.Accent, Parent=SB})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,3), Parent=Fill})
    RegAccent(function(c) Fill.BackgroundColor3 = c end)
    local Knob = UI:Create("Frame", {Size=UDim2.new(0,10,0,10), AnchorPoint=Vector2.new(0.5,0.5), Position=UDim2.new(1,0,0.5,0), BackgroundColor3=Theme.Text, Parent=Fill})
    UI:Create("UICorner", {CornerRadius=UDim.new(1,0), Parent=Knob})
    local Trig = UI:Create("TextButton", {Size=UDim2.new(1,0,3,0), Position=UDim2.new(0,0,-1,0), BackgroundTransparency=1, Text="", Parent=SB})
    local function upd(i) local pos = math.clamp((i.Position.X-SB.AbsolutePosition.X)/SB.AbsoluteSize.X,0,1); local val = math.floor(min+(pos*(max-min))); Config[sec][key] = val; VL.Text = tostring(val); Fill.Size = UDim2.new(pos,0,1,0); if cb then cb(val) end end
    local drg = false
    Trig.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drg=true; upd(i) end end)
    UIS.InputChanged:Connect(function(i) if drg and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i) end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drg=false end end)
end

function UI:CreateKeybind(p, txt, sec, key)
    local F = UI:Create("Frame", {Size=UDim2.new(1,-6,0,34), BackgroundColor3=Theme.Card, Parent=p})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,6), Parent=F})
    UI:Create("TextLabel", {Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=txt, TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=F})
    local KB = UI:Create("TextButton", {Size=UDim2.new(0,60,0,22), Position=UDim2.new(1,-68,0.5,-11), BackgroundColor3=Theme.Surface, Text=Config[sec][key]=="MouseButton2" and "RMB" or Config[sec][key], TextColor3=Theme.Accent, Font=Enum.Font.GothamBold, TextSize=9, AutoButtonColor=false, Parent=F})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,5), Parent=KB})
    RegAccent(function(c) KB.TextColor3 = c end)
    local lst = false
    KB.MouseButton1Click:Connect(function() if lst then return end; lst=true; KB.Text="..."
        local cn; cn = UIS.InputBegan:Connect(function(i, gp) if gp then return end
            if i.UserInputType == Enum.UserInputType.Keyboard then Config[sec][key]=i.KeyCode.Name; KB.Text=i.KeyCode.Name
            elseif i.UserInputType == Enum.UserInputType.MouseButton2 then Config[sec][key]="MouseButton2"; KB.Text="RMB" end
            lst=false; cn:Disconnect()
        end)
    end)
end

function UI:CreateSelector(p, txt, sec, key, opts, cb)
    local F = UI:Create("Frame", {Size=UDim2.new(1,-6,0,34), BackgroundColor3=Theme.Card, Parent=p})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,6), Parent=F})
    UI:Create("TextLabel", {Size=UDim2.new(0.45,0,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text=txt, TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=F})
    local SB = UI:Create("TextButton", {Size=UDim2.new(0,100,0,22), Position=UDim2.new(1,-108,0.5,-11), BackgroundColor3=Theme.Accent, Text="‹ "..Config[sec][key].." ›", TextColor3=Theme.Text, Font=Enum.Font.GothamBold, TextSize=9, AutoButtonColor=false, Parent=F})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,5), Parent=SB})
    RegAccent(function(c) SB.BackgroundColor3 = c end)
    SB.MouseButton1Click:Connect(function() if not UI.Active then return end
        local idx = 1; for i, o in ipairs(opts) do if Config[sec][key]==o then idx=i; break end end
        local nxt = (idx % #opts) + 1; Config[sec][key]=opts[nxt]; SB.Text="‹ "..opts[nxt].." ›"; if cb then cb(opts[nxt]) end
    end)
end


-- Combat System
local Combat = {}
function Combat:GetClosest()
    local closest, dist = nil, Config.Combat.FOV
    for _, pl in pairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local part = pl.Character:FindFirstChild(Config.Combat.TargetPart) or pl.Character:FindFirstChild("Head")
            if part and part.Position.Y >= -40 then
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then local d = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(sp.X, sp.Y)).Magnitude; if d < dist then closest, dist = pl, d end end
            end
        end
    end
    return closest
end

function Combat:IsValid(t)
    if not t or not t.Character then return false end
    local hum = t.Character:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health <= 0 then return false end
    local part = t.Character:FindFirstChild(Config.Combat.TargetPart) or t.Character:FindFirstChild("Head"); if not part or part.Position.Y < -40 then return false end
    local sp, on = Camera:WorldToViewportPoint(part.Position); if not on then return false end
    return (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(sp.X, sp.Y)).Magnitude <= Config.Combat.FOV
end

local function IsEnemy(pl, tc) if pl == LP then return false end; if not tc then return true end; if LP.Team and pl.Team then return LP.Team ~= pl.Team end; return true end

local VIM = game:GetService("VirtualInputManager")
local lastShoot = 0
local function Shoot()
    if Config.Combat.UltraRapidFire and tick() - lastShoot < Config.Combat.UltraRapidFireDelay then return end; lastShoot = tick()
    task.spawn(function()
        local char = LP.Character; if not char then return end
        local tool = char:FindFirstChildOfClass("Tool"); if tool then tool:Activate(); task.wait(0.05); tool:Deactivate(); return end
        pcall(function() VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.05); VIM:SendMouseButtonEvent(0,0,0,false,game,0) end)
    end)
end

UIS.InputBegan:Connect(function(i, gp)
    if not UI.Active or gp then return end
    if i.KeyCode.Name == Config.Combat.LockKey then
        if Config.Combat.LockedTarget then Config.Combat.LockedTarget = nil; UI:Notify("Unlocked")
        else local t = Combat:GetClosest(); if t and IsEnemy(t, Config.Combat.TeamCheck) then Config.Combat.LockedTarget = t; UI:Notify("Locked: "..t.DisplayName) end end
    end
    if i.KeyCode.Name == Config.Physics.SpeedKey and Config.Physics.SpeedEnabled then Config.Physics.SpeedActive = not Config.Physics.SpeedActive; UI:Notify(Config.Physics.SpeedActive and "Speed ON" or "Speed OFF") end
end)

local aimHold, curTarget, lastHP, tSwitch = false, nil, nil, 0
UIS.InputBegan:Connect(function(i, gp) if gp or not UI.Active or not Config.Combat.HoldToAim then return end; if (Config.Combat.AimHoldKey=="MouseButton2" and i.UserInputType==Enum.UserInputType.MouseButton2) or i.KeyCode.Name==Config.Combat.AimHoldKey then aimHold=true end end)
UIS.InputEnded:Connect(function(i) if (Config.Combat.AimHoldKey=="MouseButton2" and i.UserInputType==Enum.UserInputType.MouseButton2) or i.KeyCode.Name==Config.Combat.AimHoldKey then aimHold=false end end)

RS.RenderStepped:Connect(function()
    if not UI.Active then return end
    if Config.Combat.TargetSwitcher and curTarget and tick() >= tSwitch then
        pcall(function() if curTarget.Character then local h = curTarget.Character:FindFirstChildOfClass("Humanoid"); if h and (h.Health<=0 or (lastHP and h.Health<10)) then if Config.Combat.LockedTarget==curTarget then Config.Combat.LockedTarget=nil end; curTarget,lastHP=nil,nil; tSwitch=tick()+Config.Combat.TargetSwitcherDelay else lastHP=h and h.Health end end end)
    end
    local shouldAim = Config.Combat.SilentAim and (not Config.Combat.HoldToAim or aimHold)
    if shouldAim then
        local t = Config.Combat.LockedTarget; if t and not Combat:IsValid(t) then Config.Combat.LockedTarget=nil; t=nil end
        if not t then t = Combat:GetClosest() end; if t ~= curTarget then curTarget = t end
        if t and t.Character and IsEnemy(t, Config.Combat.TeamCheck) then
            local part = t.Character:FindFirstChild(Config.Combat.TargetPart) or t.Character:FindFirstChild("Head")
            if part then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, part.Position), Config.Combat.Smoothness * 0.1) end
        end
    end
end)


-- Ragebot
local GameProfiles = {Universal={part="Head",visible=false,pred=0,face=true}, Rivals={part="Head",visible=false,pred=0,face=true}, Arsenal={part="Head",visible=false,pred=0,face=false}, Jailbreak={part="Head",visible=true,pred=2,face=true}}
local detProf = "Universal"
pcall(function() local i = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId); local n = (i and i.Name or ""):lower(); if n:find("rival") then detProf="Rivals" elseif n:find("arsenal") then detProf="Arsenal" elseif n:find("jailbreak") then detProf="Jailbreak" end end)

local function rbSettings() local p=Config.Combat.RagebotGameProfile; if p=="Manual" then return {part=Config.Combat.RagebotTargetPart,visible=Config.Combat.RagebotVisibleCheck,pred=Config.Combat.RagebotPrediction,face=Config.Combat.RagebotFaceTarget} end; if p=="Auto" then p=detProf end; return GameProfiles[p] or GameProfiles["Universal"] end
local function rbPart(c,pn) return c:FindFirstChild(pn) or c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart") end
local function rbVis(p,c) local pr=RaycastParams.new(); pr.FilterDescendantsInstances={LP.Character,Camera}; local r=workspace:Raycast(Camera.CFrame.Position,(p.Position-Camera.CFrame.Position),pr); return not r or r.Instance:IsDescendantOf(c) end

local function rbTarget()
    local myChar,myRoot = LP.Character, LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not myRoot then return nil end
    local s,best,bScore = rbSettings(), nil, nil
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local hum = pl.Character:FindFirstChildOfClass("Humanoid"); local part = rbPart(pl.Character, s.part)
            local imm = Config.Combat.RagebotIgnoreImmune and pl.Character:FindFirstChildOfClass("ForceField")
            if hum and hum.Health>0 and part and not imm and part.Position.Y>=-40 and IsEnemy(pl, Config.Combat.RagebotTeamCheck) then
                local dist = (part.Position - myRoot.Position).Magnitude
                if dist <= Config.Combat.RagebotMaxDistance then
                    local pass = Config.Combat.RagebotFullMap or select(2, Camera:WorldToViewportPoint(part.Position))
                    if pass and (not s.visible or rbVis(part, pl.Character)) then
                        local sc = Config.Combat.RagebotMode=="Lowest Health" and hum.Health or dist
                        if not bScore or sc < bScore then bScore,best = sc,part end
                    end
                end
            end
        end
    end
    return best
end

RS.RenderStepped:Connect(function(dt)
    if not UI.Active or not Config.Combat.Ragebot then return end
    local t = rbTarget(); if not t then return end
    local s = rbSettings(); local aim = t.Position
    if s.pred > 0 then aim = aim + (t.AssemblyLinearVelocity * (s.pred/100)) end
    if s.face and not Config.Combat.RagebotAutoTP then
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then myRoot.CFrame = CFrame.new(myRoot.Position, Vector3.new(t.Position.X, myRoot.Position.Y, t.Position.Z)) end
    end
    if Config.Combat.RagebotAutoTP then
        local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local fd = (myRoot.Position - t.Position); if fd.Magnitude < 0.1 then fd = Vector3.new(0,0,1) end
            local gp = t.Position + (fd.Unit * Config.Combat.RagebotTPOffset)
            if Config.Combat.RagebotTPMode=="Teleport" then myRoot.CFrame = CFrame.new(gp, Vector3.new(t.Position.X, gp.Y, t.Position.Z))
            else local tg = (gp - myRoot.Position); if tg.Magnitude > 0.5 then local np = myRoot.Position + (tg.Unit * math.min(Config.Combat.RagebotTPSpeed*dt, tg.Magnitude)); myRoot.CFrame = CFrame.new(np, Vector3.new(t.Position.X, np.Y, t.Position.Z)) end end
            pcall(function() myRoot.AssemblyLinearVelocity = Vector3.zero end)
        end
    end
    Camera.CFrame = CFrame.new(Camera.CFrame.Position, aim)
end)

local rbNoclip = {}
RS.Stepped:Connect(function() local c=LP.Character; if not c then return end
    local want = UI.Active and Config.Combat.Ragebot and Config.Combat.RagebotNoClip
    if want then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide=false; rbNoclip[p]=true end end
    elseif next(rbNoclip) then for p in pairs(rbNoclip) do if p and p.Parent then pcall(function() p.CanCollide=true end) end end; rbNoclip={} end
end)

UIS.InputBegan:Connect(function(i) if not UI.Active or i.KeyCode.Name ~= Config.Misc.PanicKey then return end
    Config.Combat.Ragebot,Config.Combat.SilentAim,Config.Combat.Triggerbot,Config.Combat.KillAura,Config.Physics.SpeedActive,Config.Physics.FlyActive = false,false,false,false,false,false
    pcall(function() UI:UpdateToggle("Combat","Ragebot",false); UI:UpdateToggle("Combat","SilentAim",false); UI:UpdateToggle("Combat","Triggerbot",false); UI:UpdateToggle("Combat","KillAura",false) end)
    UI:Notify("PANIC: Disabled")
end)


-- Triggerbot
local lastTrig = 0
task.spawn(function() while task.wait(0.05) do
    if UI.Active and Config.Combat.Triggerbot then
        local tgt = Mouse.Target; local tc = tgt and tgt:FindFirstAncestorOfClass("Model"); local tp = tc and Players:GetPlayerFromCharacter(tc)
        if tp and tp ~= LP and IsEnemy(tp, Config.Combat.TeamCheck) then
            local h = tc:FindFirstChildOfClass("Humanoid"); if h and h.Health>0 then
                local d = Config.Combat.UltraRapidFire and Config.Combat.UltraRapidFireDelay or Config.Combat.TriggerDelay
                if tick()-lastTrig >= d then Shoot(); lastTrig=tick() end
            end
        end
    end
end end)

-- Auto Shoot
local lastAimShoot = 0
task.spawn(function() while task.wait(0.05) do
    if UI.Active and Config.Combat.AutoShoot and Config.Combat.LockedTarget then
        if tick()-lastAimShoot >= Config.Combat.ShootDelay then if Combat:IsValid(Config.Combat.LockedTarget) then Shoot(); lastAimShoot=tick() end end
    end
end end)

-- Kill Aura
local lastKA = 0
task.spawn(function() while task.wait(0.1) do
    if not Config.Combat.KillAura or not UI.Active then continue end
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not root then continue end
    local cl, cd = nil, Config.Combat.KillAuraRange
    for _, pl in pairs(Players:GetPlayers()) do
        if IsEnemy(pl, Config.Combat.KillAuraTeamCheck) and pl.Character then
            local er = pl.Character:FindFirstChild("HumanoidRootPart"); local eh = pl.Character:FindFirstChildOfClass("Humanoid")
            if er and eh and eh.Health>0 then local d = (root.Position-er.Position).Magnitude; if d < cd then cl,cd=pl,d end end
        end
    end
    if cl and cl.Character then
        local pt = cl.Character:FindFirstChild("Head") or cl.Character:FindFirstChild("HumanoidRootPart")
        if pt then Camera.CFrame = CFrame.new(Camera.CFrame.Position, pt.Position); if tick()-lastKA>=0.15 then Shoot(); lastKA=tick() end end
    end
end end)

-- ESP
local function applyChams(p) local b=Instance.new("BoxHandleAdornment"); b.Size=p.Size+Vector3.new(0.05,0.05,0.05); b.Color3=Theme.Accent; b.AlwaysOnTop=true; b.Transparency=0.4; b.Adornee=p; b.Parent=p; b.Visible=false; table.insert(ESPObjs,b); return b end
local function drawESP(pl)
    if pl == LP then return end
    local function setup(c)
        local head = c:WaitForChild("Head",10); if not head then return end
        local bg = UI:Create("BillboardGui",{Size=UDim2.new(0,140,0,35),StudsOffset=Vector3.new(0,3,0),AlwaysOnTop=true,Enabled=false,Parent=head})
        local lb = UI:Create("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamBold,TextSize=10,TextStrokeTransparency=0.5,Parent=bg})
        table.insert(ESPObjs,bg)
        local hdot; task.spawn(function() local hp=c:WaitForChild("Head",10); if hp then hdot=UI:Create("BillboardGui",{Size=UDim2.new(0,8,0,8),AlwaysOnTop=true,Enabled=false,Parent=hp}); local dt=UI:Create("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.new(1,0,0),BorderSizePixel=0,Parent=hdot}); Instance.new("UICorner",dt).CornerRadius=UDim.new(1,0); table.insert(ESPObjs,hdot) end end)
        local tps = {}; for _,o in pairs(c:GetChildren()) do if o:IsA("BasePart") then table.insert(tps, applyChams(o)) end end
        task.spawn(function() while bg.Parent and c:IsDescendantOf(WS) and UI.Active do
            bg.Enabled = Config.Visuals.Enabled; if hdot then hdot.Enabled = Config.Visuals.Enabled and Config.Visuals.HeadDot end
            local isE = IsEnemy(pl,true); local col = isE and Theme.Red or Theme.Green
            for _,bx in pairs(tps) do if bx and bx.Parent then bx.Visible=Config.Visuals.Enabled and Config.Visuals.Skeletons; bx.Color3=col end end
            if Config.Visuals.Enabled then
                local rt = c:FindFirstChild("HumanoidRootPart") or head; local dst = math.floor((rt.Position-Camera.CFrame.Position).Magnitude)
                local txt = pl.DisplayName; if Config.Visuals.Distance then txt=txt.." ["..dst.."m]" end; if Config.Visuals.IDs then txt=txt.."\n["..pl.UserId.."]" end
                lb.TextColor3=col; lb.Text = Config.Visuals.Names and txt or ""
            else lb.Text="" end
            task.wait(0.1)
        end end)
    end
    if pl.Character then task.spawn(function() setup(pl.Character) end) end
    pl.CharacterAdded:Connect(function(c) task.spawn(function() setup(c) end) end)
end
for _,p in pairs(Players:GetPlayers()) do drawESP(p) end
Players.PlayerAdded:Connect(function(p) drawESP(p) end)


-- Tracers
local function mkTracer(pl) if pl==LP then return end
    local function setup(c) local rt=c:WaitForChild("HumanoidRootPart",5); if not rt then return end
        local ln=Drawing.new("Line"); ln.Visible=false; ln.Thickness=1
        local cn=RS.RenderStepped:Connect(function() if not UI.Active or not c:IsDescendantOf(WS) then ln:Remove(); cn:Disconnect(); return end
            if Config.Visuals.Tracers then ln.Color=IsEnemy(pl,true) and Theme.Red or Theme.Green; local sp,on=Camera:WorldToViewportPoint(rt.Position); if on then ln.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y); ln.To=Vector2.new(sp.X,sp.Y); ln.Visible=true else ln.Visible=false end else ln.Visible=false end
        end); table.insert(TracerConns,{l=ln,c=cn})
    end
    if pl.Character then task.spawn(function() setup(pl.Character) end) end; pl.CharacterAdded:Connect(function(c) task.spawn(function() setup(c) end) end)
end
for _,p in pairs(Players:GetPlayers()) do mkTracer(p) end; Players.PlayerAdded:Connect(function(p) mkTracer(p) end)

-- Health Bars
local function mkHealth(pl) if pl==LP then return end
    local function setup(c) local hd=c:WaitForChild("Head",10); local hm=c:WaitForChild("Humanoid",10); if not hd or not hm then return end
        local bg=Instance.new("BillboardGui",hd); bg.Size=UDim2.new(4,0,0.5,0); bg.StudsOffset=Vector3.new(0,4,0); bg.AlwaysOnTop=true; bg.Enabled=false
        local fr=Instance.new("Frame",bg); fr.Size=UDim2.new(1,0,1,0); fr.BackgroundColor3=Color3.new(0.1,0.1,0.1); fr.BorderSizePixel=0
        local br=Instance.new("Frame",fr); br.Size=UDim2.new(1,0,1,0); br.BackgroundColor3=Color3.new(0,1,0); br.BorderSizePixel=0
        Instance.new("UICorner",fr).CornerRadius=UDim.new(0,4); Instance.new("UICorner",br).CornerRadius=UDim.new(0,4)
        task.spawn(function() while bg.Parent and c:IsDescendantOf(WS) and UI.Active do bg.Enabled=Config.Visuals.HealthBars; if Config.Visuals.HealthBars then local pct=hm.Health/hm.MaxHealth; br.Size=UDim2.new(pct,0,1,0); br.BackgroundColor3=Color3.new(1-pct,pct,0) end; task.wait(0.1) end; bg:Destroy() end)
    end
    if pl.Character then task.spawn(function() setup(pl.Character) end) end; pl.CharacterAdded:Connect(function(c) task.spawn(function() setup(c) end) end)
end
for _,p in pairs(Players:GetPlayers()) do mkHealth(p) end; Players.PlayerAdded:Connect(function(p) mkHealth(p) end)

-- Skeleton ESP
local function mkSkel(pl) if pl==LP then return end
    local function setup(c) local hrp=c:WaitForChild("HumanoidRootPart",5); if not hrp then return end
        local bones = c:FindFirstChild("Torso") and {{f="Head",t="Torso"},{f="Torso",t="Left Arm"},{f="Torso",t="Right Arm"},{f="Torso",t="Left Leg"},{f="Torso",t="Right Leg"}} or {{f="Head",t="UpperTorso"},{f="UpperTorso",t="LowerTorso"},{f="UpperTorso",t="LeftUpperArm"},{f="LeftUpperArm",t="LeftLowerArm"},{f="UpperTorso",t="RightUpperArm"},{f="RightUpperArm",t="RightLowerArm"},{f="LowerTorso",t="LeftUpperLeg"},{f="LeftUpperLeg",t="LeftLowerLeg"},{f="LowerTorso",t="RightUpperLeg"},{f="RightUpperLeg",t="RightLowerLeg"}}
        local lns = {}; for _,b in pairs(bones) do local l=Drawing.new("Line"); l.Visible=false; l.Thickness=2; table.insert(lns,{l=l,f=b.f,t=b.t}) end
        local cn=RS.RenderStepped:Connect(function() if not UI.Active or not c:IsDescendantOf(WS) then for _,d in pairs(lns) do d.l:Remove() end; cn:Disconnect(); return end
            if Config.Visuals.SkeletonESP then local col=IsEnemy(pl,true) and Theme.Red or Theme.Green
                for _,d in pairs(lns) do local fp,tp=c:FindFirstChild(d.f),c:FindFirstChild(d.t)
                    if fp and tp then local f,fv=Camera:WorldToViewportPoint(fp.Position); local t,tv=Camera:WorldToViewportPoint(tp.Position)
                        if fv and tv then d.l.From=Vector2.new(f.X,f.Y); d.l.To=Vector2.new(t.X,t.Y); d.l.Color=col; d.l.Visible=true else d.l.Visible=false end
                    else d.l.Visible=false end
                end
            else for _,d in pairs(lns) do d.l.Visible=false end end
        end); table.insert(SkelConns,{ls=lns,c=cn})
    end
    if pl.Character then task.spawn(function() setup(pl.Character) end) end; pl.CharacterAdded:Connect(function(c) task.spawn(function() setup(c) end) end)
end
for _,p in pairs(Players:GetPlayers()) do mkSkel(p) end; Players.PlayerAdded:Connect(function(p) mkSkel(p) end)

-- Box ESP
local function mkBox(pl) if pl==LP then return end
    local function setup(c) local rt=c:WaitForChild("HumanoidRootPart",5); if not rt then return end
        local bx=Drawing.new("Square"); bx.Visible=false; bx.Thickness=2; bx.Filled=false
        local cn=RS.RenderStepped:Connect(function() if not UI.Active or not c:IsDescendantOf(WS) then bx:Remove(); cn:Disconnect(); return end
            if Config.Visuals.BoxESP then bx.Color=IsEnemy(pl,true) and Color3.new(1,0.3,0.3) or Color3.new(0.3,1,0.5)
                local hd=c:FindFirstChild("Head"); if rt and hd then local rp,rv=Camera:WorldToViewportPoint(rt.Position); local hp=Camera:WorldToViewportPoint(hd.Position+Vector3.new(0,0.5,0)); local lp=Camera:WorldToViewportPoint(rt.Position-Vector3.new(0,3,0))
                    if rv then local h=math.abs(hp.Y-lp.Y); local w=h/2; bx.Size=Vector2.new(w,h); bx.Position=Vector2.new(rp.X-w/2,hp.Y); bx.Visible=true else bx.Visible=false end
                else bx.Visible=false end
            else bx.Visible=false end
        end); table.insert(BoxConns,{b=bx,c=cn})
    end
    if pl.Character then task.spawn(function() setup(pl.Character) end) end; pl.CharacterAdded:Connect(function(c) task.spawn(function() setup(c) end) end)
end
for _,p in pairs(Players:GetPlayers()) do mkBox(p) end; Players.PlayerAdded:Connect(function(p) mkBox(p) end)


-- Physics & Misc
local Lighting = game:GetService("Lighting")
local origL = {B=Lighting.Brightness, C=Lighting.ClockTime, F=Lighting.FogEnd, G=Lighting.GlobalShadows, A=Lighting.Ambient}

RS.RenderStepped:Connect(function()
    if Config.Misc.Fullbright and UI.Active then Lighting.Brightness=2; Lighting.ClockTime=12; Lighting.GlobalShadows=false; Lighting.Ambient=Color3.new(1,1,1) end
    if Config.Misc.FOVChanger and UI.Active then Camera.FieldOfView=Config.Misc.FOVValue else Camera.FieldOfView=70 end
end)

local lastJ = 0
UIS.InputBegan:Connect(function(i, gp) if gp or not UI.Active or i.KeyCode~=Enum.KeyCode.Space or not Config.Misc.InfiniteJump then return end
    if tick()-lastJ < 0.05 then return end; lastJ=tick()
    local c,h = LP.Character, LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    local r = c and c:FindFirstChild("HumanoidRootPart"); if r then r.AssemblyLinearVelocity=Vector3.new(r.AssemblyLinearVelocity.X,50,r.AssemblyLinearVelocity.Z) end
end)

Mouse.Button1Down:Connect(function() if not UI.Active or not Config.Physics.ClickTP then return end
    if not UIS:IsKeyDown(Enum.KeyCode[Config.Physics.ClickTPKey]) then return end
    local r = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if r then r.CFrame=CFrame.new(Mouse.Hit.Position+Vector3.new(0,3,0)); UI:Notify("Teleported") end
end)

local FlyConn, FlyBV, FlyBG
local function EnableFly() local r=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"); if not r then return end
    if FlyBV then FlyBV:Destroy() end; if FlyBG then FlyBG:Destroy() end
    FlyBV=Instance.new("BodyVelocity"); FlyBV.MaxForce=Vector3.new(9e9,9e9,9e9); FlyBV.Parent=r
    FlyBG=Instance.new("BodyGyro"); FlyBG.MaxTorque=Vector3.new(9e9,9e9,9e9); FlyBG.P=9e4; FlyBG.Parent=r
    if FlyConn then FlyConn:Disconnect() end
    FlyConn=RS.RenderStepped:Connect(function() if not Config.Physics.Fly or not Config.Physics.FlyActive or not UI.Active then if FlyBV then FlyBV:Destroy(); FlyBV=nil end; if FlyBG then FlyBG:Destroy(); FlyBG=nil end; if FlyConn then FlyConn:Disconnect(); FlyConn=nil end; return end
        local d=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then d=d+Camera.CFrame.LookVector end; if UIS:IsKeyDown(Enum.KeyCode.S) then d=d-Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then d=d-Camera.CFrame.RightVector end; if UIS:IsKeyDown(Enum.KeyCode.D) then d=d+Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then d=d+Vector3.new(0,1,0) end; if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then d=d-Vector3.new(0,1,0) end
        FlyBV.Velocity = d.Magnitude>0 and d.Unit*Config.Physics.FlySpeed or Vector3.zero; FlyBG.CFrame=Camera.CFrame
    end)
end
local function DisableFly() if FlyBV then FlyBV:Destroy(); FlyBV=nil end; if FlyBG then FlyBG:Destroy(); FlyBG=nil end; if FlyConn then FlyConn:Disconnect(); FlyConn=nil end end

UIS.InputBegan:Connect(function(i, gp) if not UI.Active or gp then return end
    if i.KeyCode.Name==Config.Physics.FlyKey and Config.Physics.Fly then Config.Physics.FlyActive=not Config.Physics.FlyActive; if Config.Physics.FlyActive then EnableFly() else DisableFly() end; UI:Notify(Config.Physics.FlyActive and "Fly ON" or "Fly OFF") end
    if i.KeyCode.Name==Config.Misc.NoClipToggleKey and Config.Physics.NoClip then Config.Physics.NoClipActive=not Config.Physics.NoClipActive; UI:Notify(Config.Physics.NoClipActive and "NoClip ON" or "NoClip OFF") end
end)

RS.Stepped:Connect(function() if not UI.Active then return end
    local c,h,r = LP.Character, LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"), LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if h and r and Config.Physics.SpeedEnabled and Config.Physics.SpeedActive and h.MoveDirection.Magnitude>0 then r.CFrame=r.CFrame+(h.MoveDirection*Config.Physics.Speed*0.5) end
    if h and Config.Physics.JumpEnabled then if h.UseJumpPower then h.JumpPower=Config.Physics.JumpPower else h.JumpHeight=Config.Physics.JumpPower/10 end end
    if c and Config.Physics.NoClip and Config.Physics.NoClipActive then for _,p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end
end)

local afk=0
RS.Heartbeat:Connect(function() if not UI.Active or not Config.Misc.AntiAFK then return end; afk=afk+1; if afk>=300*60 then afk=0; local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid"); if h then h:Move(Vector3.new(0.1,0,0)) end end end)

UIS.InputBegan:Connect(function(i, gp) if not UI.Active then return end; if i.KeyCode==Enum.KeyCode.Insert then UI.Visible=not UI.Visible; Main.Visible=UI.Visible end end)

local FOVC = UI:Create("Frame", {Size=UDim2.new(0,Config.Combat.FOV*2,0,Config.Combat.FOV*2), AnchorPoint=Vector2.new(0.5,0.5), BackgroundTransparency=1, Visible=false, Parent=UI.Screen})
local FOVStroke = UI:Create("UIStroke", {Color=Theme.Accent, Thickness=1, Transparency=0.5, Parent=FOVC}); Instance.new("UICorner",FOVC).CornerRadius=UDim.new(1,0)
RegAccent(function(c) FOVStroke.Color=c end)
RS.RenderStepped:Connect(function() if not UI.Active then return end; if Config.Combat.ShowFOV then FOVC.Visible=true; FOVC.Size=UDim2.new(0,Config.Combat.FOV*2,0,Config.Combat.FOV*2); FOVC.Position=UDim2.new(0,Mouse.X,0,Mouse.Y+36) else FOVC.Visible=false end end)

local WM = UI:Create("TextLabel", {Size=UDim2.new(0,260,0,40), Position=UDim2.new(0,10,0,10), BackgroundColor3=Theme.Bg, BackgroundTransparency=0.2, Text="Beep "..BEEP_VERSION, TextColor3=Theme.Text, Font=Enum.Font.GothamBold, TextSize=10, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top, Visible=Config.Misc.Watermark, Parent=UI.Screen})
UI:Create("UIPadding", {PaddingLeft=UDim.new(0,8), PaddingTop=UDim.new(0,8), Parent=WM}); UI:Create("UICorner", {CornerRadius=UDim.new(0,8), Parent=WM}); UI:Create("UIStroke", {Color=Theme.Accent, Thickness=1.5, Parent=WM})
RegAccent(function(c) WM:FindFirstChildOfClass("UIStroke").Color=c end)
local wmD,wmS,wmP = false,nil,nil
WM.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then wmD=true; wmS=i.Position; wmP=WM.Position end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then wmD=false end end)
UIS.InputChanged:Connect(function(i) if wmD and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-wmS; WM.Position=UDim2.new(wmP.X.Scale,wmP.X.Offset+d.X,wmP.Y.Scale,wmP.Y.Offset+d.Y) end end)
task.spawn(function() while task.wait(1) do if UI.Active and Config.Misc.Watermark then local fps=math.floor(1/RS.RenderStepped:Wait()); local ping=math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()); WM.Text=string.format("Beep %s | FPS: %d | Ping: %dms | %s",BEEP_VERSION,fps,ping,os.date("%H:%M:%S")); WM.Visible=true else WM.Visible=false end end end)


-- Create Tabs
local CombatPage = UI:CreateTab("Combat")
local VisualsPage = UI:CreateTab("Visuals")
local PhysicsPage = UI:CreateTab("Physics")
local MiscPage = UI:CreateTab("Misc")

-- Combat Tab
UI:CreateToggle(CombatPage, "Silent Aim", "Combat", "SilentAim")
UI:CreateSlider(CombatPage, "FOV Size", 50, 400, "Combat", "FOV")
UI:CreateSlider(CombatPage, "Smoothness", 1, 20, "Combat", "Smoothness")
UI:CreateToggle(CombatPage, "Show FOV Circle", "Combat", "ShowFOV")
UI:CreateSelector(CombatPage, "Target Part", "Combat", "TargetPart", {"Head", "HumanoidRootPart", "Torso"})
UI:CreateToggle(CombatPage, "Hold to Aim", "Combat", "HoldToAim")
UI:CreateKeybind(CombatPage, "Aim Hold Key", "Combat", "AimHoldKey")
UI:CreateToggle(CombatPage, "Team Check", "Combat", "TeamCheck")
UI:CreateKeybind(CombatPage, "Lock Key", "Combat", "LockKey")
UI:CreateToggle(CombatPage, "Target Switcher", "Combat", "TargetSwitcher")
UI:CreateToggle(CombatPage, "Triggerbot", "Combat", "Triggerbot")
UI:CreateToggle(CombatPage, "Auto Shoot", "Combat", "AutoShoot")
UI:CreateToggle(CombatPage, "Ultra Rapid Fire", "Combat", "UltraRapidFire")
UI:CreateToggle(CombatPage, "Kill Aura", "Combat", "KillAura")
UI:CreateSlider(CombatPage, "Kill Aura Range", 5, 50, "Combat", "KillAuraRange")
UI:CreateToggle(CombatPage, "Ragebot", "Combat", "Ragebot")
UI:CreateSelector(CombatPage, "Game Profile", "Combat", "RagebotGameProfile", {"Auto", "Manual", "Universal", "Rivals", "Arsenal", "Jailbreak"})
UI:CreateSelector(CombatPage, "RB Mode", "Combat", "RagebotMode", {"Closest", "Lowest Health"})
UI:CreateToggle(CombatPage, "RB Full Map", "Combat", "RagebotFullMap")
UI:CreateSlider(CombatPage, "RB Max Distance", 100, 10000, "Combat", "RagebotMaxDistance")
UI:CreateToggle(CombatPage, "RB Auto TP", "Combat", "RagebotAutoTP")
UI:CreateToggle(CombatPage, "RB NoClip", "Combat", "RagebotNoClip")

-- Visuals Tab
UI:CreateToggle(VisualsPage, "Enable ESP", "Visuals", "Enabled")
UI:CreateToggle(VisualsPage, "Names", "Visuals", "Names")
UI:CreateToggle(VisualsPage, "Distance", "Visuals", "Distance")
UI:CreateToggle(VisualsPage, "User IDs", "Visuals", "IDs")
UI:CreateToggle(VisualsPage, "Head Dot", "Visuals", "HeadDot")
UI:CreateToggle(VisualsPage, "3D Chams", "Visuals", "Skeletons")
UI:CreateToggle(VisualsPage, "Box ESP", "Visuals", "BoxESP")
UI:CreateToggle(VisualsPage, "Skeleton ESP", "Visuals", "SkeletonESP")
UI:CreateToggle(VisualsPage, "Tracers", "Visuals", "Tracers")
UI:CreateToggle(VisualsPage, "Health Bars", "Visuals", "HealthBars")

-- Physics Tab
UI:CreateToggle(PhysicsPage, "Speed Hack", "Physics", "SpeedEnabled", function(v) if not v then Config.Physics.SpeedActive=false end end)
UI:CreateSlider(PhysicsPage, "Speed", 1, 10, "Physics", "Speed")
UI:CreateKeybind(PhysicsPage, "Speed Key", "Physics", "SpeedKey")
UI:CreateToggle(PhysicsPage, "Jump Power", "Physics", "JumpEnabled")
UI:CreateSlider(PhysicsPage, "Jump Value", 50, 500, "Physics", "JumpPower")
UI:CreateToggle(PhysicsPage, "Fly", "Physics", "Fly")
UI:CreateSlider(PhysicsPage, "Fly Speed", 10, 200, "Physics", "FlySpeed")
UI:CreateKeybind(PhysicsPage, "Fly Key", "Physics", "FlyKey")
UI:CreateToggle(PhysicsPage, "NoClip", "Physics", "NoClip")
UI:CreateKeybind(PhysicsPage, "NoClip Key", "Misc", "NoClipToggleKey")
UI:CreateToggle(PhysicsPage, "Click TP", "Physics", "ClickTP")
UI:CreateKeybind(PhysicsPage, "Click TP Key", "Physics", "ClickTPKey")

-- Misc Tab
UI:CreateToggle(MiscPage, "Fullbright", "Misc", "Fullbright")
UI:CreateToggle(MiscPage, "Infinite Jump", "Misc", "InfiniteJump")
UI:CreateToggle(MiscPage, "Anti-AFK", "Misc", "AntiAFK")
UI:CreateToggle(MiscPage, "FOV Changer", "Misc", "FOVChanger")
UI:CreateSlider(MiscPage, "FOV Value", 30, 120, "Misc", "FOVValue")
UI:CreateToggle(MiscPage, "Watermark", "Misc", "Watermark")
UI:CreateKeybind(MiscPage, "Panic Key", "Misc", "PanicKey")

-- Theme Colors
local ThemeFrame = UI:Create("Frame", {Size=UDim2.new(1,-6,0,45), BackgroundColor3=Theme.Card, Parent=MiscPage})
UI:Create("UICorner", {CornerRadius=UDim.new(0,6), Parent=ThemeFrame})
UI:Create("TextLabel", {Size=UDim2.new(0,80,1,0), Position=UDim2.new(0,10,0,0), BackgroundTransparency=1, Text="Accent", TextColor3=Theme.Text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left, Parent=ThemeFrame})
local colors = {Color3.fromRGB(138,43,226), Color3.fromRGB(255,80,80), Color3.fromRGB(80,160,255), Color3.fromRGB(80,255,120), Color3.fromRGB(255,200,80), Color3.fromRGB(255,80,200), Color3.fromRGB(0,255,255), Color3.fromRGB(255,128,0)}
for i, col in ipairs(colors) do
    local CB = UI:Create("TextButton", {Size=UDim2.new(0,24,0,24), Position=UDim2.new(0,85+((i-1)*30),0.5,-12), BackgroundColor3=col, Text="", AutoButtonColor=false, Parent=ThemeFrame})
    UI:Create("UICorner", {CornerRadius=UDim.new(0,5), Parent=CB})
    CB.MouseButton1Click:Connect(function() RefreshAccent(col); UI:Notify("Theme changed") end)
end

-- Exit Button
local ExitBtn = UI:Create("TextButton", {Size=UDim2.new(1,-6,0,34), BackgroundColor3=Color3.fromRGB(60,20,20), Text="EXIT CHEAT", TextColor3=Theme.Red, Font=Enum.Font.GothamBold, TextSize=12, AutoButtonColor=false, Parent=MiscPage})
UI:Create("UICorner", {CornerRadius=UDim.new(0,6), Parent=ExitBtn})
ExitBtn.MouseButton1Click:Connect(function()
    UI.Active=false; UI:Notify("Goodbye!")
    task.wait(0.5)
    for _,o in pairs(ESPObjs) do pcall(function() o:Destroy() end) end
    for _,t in pairs(TracerConns) do pcall(function() t.l:Remove(); t.c:Disconnect() end) end
    for _,b in pairs(BoxConns) do pcall(function() b.b:Remove(); b.c:Disconnect() end) end
    for _,s in pairs(SkelConns) do pcall(function() for _,l in pairs(s.ls) do l.l:Remove() end; s.c:Disconnect() end) end
    pcall(function() Lighting.Brightness=origL.B; Lighting.ClockTime=origL.C; Lighting.FogEnd=origL.F; Lighting.GlobalShadows=origL.G; Lighting.Ambient=origL.A end)
    DisableFly(); UI.Screen:Destroy()
end)

UI:Notify("Beep "..BEEP_VERSION.." loaded. Press INSERT.")