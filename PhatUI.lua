--[[
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Phathubz/PhatUI/refs/heads/main/PhatUI.lua"))()

local win = UI:CreateWindow({
    Title = "PHAT UI v7",
    Width = 640,
    Height = 500,
})

local Tab = {
    Main = win:AddTab({Title = "Main"}),
    Combat = win:AddTab({Title = "Combat"}),
    Teleport = win:AddTab({Title = "Teleport"}),
    Settings = win:AddTab({Title = "Settings"}),
}

local MainSection = Tab.Main:AddSection("Welcome")

MainSection:AddButton({
    Title = "Test Notification",
    Callback = function()
        win:Notify("Success!", "Notification đang hoạt động!", "success", 4)
    end,
})

MainSection:AddToggle({
    Title = "Example Toggle",
    Default = false,
    Callback = function(v)
        win:Notify("Toggle", v and "Bật" or "Tắt", v and "success" or "warn", 3)
    end,
})

MainSection:AddSlider({
    Title = "Example Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(v)
    end,
})

MainSection:AddDropdown({
    Title = "Example Dropdown",
    Items = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(v)
        win:Notify("Dropdown", "Đã chọn: " .. v, "info", 2)
    end,
})

MainSection:AddInput({
    Title = "Example Input",
    Placeholder = "Nhập text...",
    Callback = function(text, enter)
        if enter then
            win:Notify("Input", "Text: " .. text, "info", 3)
        end
    end,
})

local CombatSection = Tab.Combat:AddSection("Combat Options")

CombatSection:AddButton({
    Title = "Kill Aura",
    Callback = function()
        win:Notify("Kill Aura", "Đã kích hoạt Kill Aura!", "success", 4)
    end,
})

CombatSection:AddButton({
    Title = "Auto Attack",
    Callback = function()
        win:Notify("Auto Attack", "Đang tấn công...", "info", 3)
    end,
})

CombatSection:AddToggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(v)
        win:Notify("Infinite Jump", v and "Đã bật" or "Đã tắt", v and "success" or "warn", 3)
    end,
})

CombatSection:AddSlider({
    Title = "Reach Distance",
    Min = 3,
    Max = 20,
    Default = 3,
    Callback = function(v)
    end,
})

local TeleSection = Tab.Teleport:AddSection("Teleport Options")

TeleSection:AddDropdown({
    Title = "Teleport To",
    Items = {"Spawn", "Nearest Player", "Random Player"},
    Default = "Spawn",
    Callback = function(v)
        win:Notify("Teleport", "Chế độ: " .. v, "info", 2)
    end,
})

TeleSection:AddInput({
    Title = "Player Name",
    Placeholder = "Nhập tên player...",
    Callback = function(text, enter)
        if enter and text ~= "" then
            win:Notify("Teleport", "Đang teleport đến: " .. text, "success", 3)
        end
    end,
})

local SettingsSection = Tab.Settings:AddSection("UI Settings")

SettingsSection:AddButton({
    Title = "Hide UI (Toggle Button)",
    Callback = function()
        win:Toggle()
    end,
})

SettingsSection:AddButton({
    Title = "Show UI",
    Callback = function()
        win:Show()
    end,
})

SettingsSection:AddButton({
    Title = "Hide UI",
    Callback = function()
        win:Hide()
    end,
})

SettingsSection:AddToggle({
    Title = "Test Toggle",
    Default = true,
    Callback = function(v)
    end,
})

win:Notify("Loaded", "PhatUI v7.0 đã sẵn sàng!", "success", 5)

--]]

local Phat = {}
Phat.__index = Phat
Phat.Options = {}

local function registerOption(name, ctrl, ctrlType, setFn, getFn)
    if name then
        Phat.Options[name] = {
            Type = ctrlType,
            SetValue = setFn,
            GetValue = getFn,
            _ctrl = ctrl,
        }
    end
end
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Palette: Red & Black
local C = {
    WIN = Color3.fromRGB(17, 17, 22),
    TOP = Color3.fromRGB(14, 14, 18),
    SIDE = Color3.fromRGB(12, 12, 16),
    SEC = Color3.fromRGB(22, 22, 28),
    ELEM = Color3.fromRGB(26, 26, 32),
    ELEMH = Color3.fromRGB(34, 22, 22),

    RED = Color3.fromRGB(204, 34, 34),
    RED2 = Color3.fromRGB(255, 68, 68),
    DARKRED = Color3.fromRGB(102, 10, 10),

    GREEN = Color3.fromRGB(34, 204, 100),
    BLUE = Color3.fromRGB(51, 153, 255),
    AMBER = Color3.fromRGB(204, 136, 0),

    T1 = Color3.fromRGB(238, 238, 238),
    T2 = Color3.fromRGB(170, 155, 155),
    T3 = Color3.fromRGB(90, 70, 70),

    DIV = Color3.fromRGB(30, 20, 20),
    BOR = Color3.fromRGB(42, 21, 21),
}

-- Helpers
local function tw(o, p, t, s, d)
    local ti = TweenInfo.new(t or 0.18, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out)
    local tween = TweenService:Create(o, ti, p)
    tween:Play()
    return tween
end

local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.BOR
    s.Thickness = th or 1
    return s
end

local function pad(p, t, r, b, l)
    local u = Instance.new("UIPadding", p)
    u.PaddingTop = UDim.new(0, t or 6)
    u.PaddingRight = UDim.new(0, r or 8)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft = UDim.new(0, l or 8)
end

local function vlist(p, px)
    local l = Instance.new("UIListLayout", p)
    l.FillDirection = Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, px or 4)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

local function mkLabel(parent, props)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.RichText = false
    for k, v in pairs(props) do l[k] = v end
    return l
end

-- Notification System
local NotificationHolder = nil

local function notify(title, msg, ntype, duration)
    duration = math.max(1, duration or 4)
    
    if not NotificationHolder then
        warn("[PhatUI] NotificationHolder not initialized")
        return
    end

    local accent = ({
        info = C.BLUE,
        success = C.GREEN,
        error = C.RED,
        warn = C.AMBER,
    })[ntype or "info"] or C.RED

    local card = Instance.new("Frame")
    card.Name = "Notification"
    card.Size = UDim2.new(1, -4, 0, 68)
    card.BackgroundColor3 = C.WIN
    card.BackgroundTransparency = 0
    card.BorderSizePixel = 0
    corner(card, 10)
    stroke(card, accent, 1)
    card.Parent = NotificationHolder

    local strip = Instance.new("Frame")
    strip.Size = UDim2.new(0, 4, 1, -16)
    strip.Position = UDim2.new(0, 0, 0, 8)
    strip.BackgroundColor3 = accent
    strip.BorderSizePixel = 0
    corner(strip, 3)
    strip.Parent = card

    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.fromOffset(55, 15)
    badge.Position = UDim2.new(0, 12, 0, 8)
    badge.BackgroundColor3 = accent
    badge.BackgroundTransparency = 0.7
    badge.Text = string.upper(ntype or "INFO")
    badge.TextColor3 = accent
    badge.TextSize = 9
    badge.Font = Enum.Font.GothamBold
    badge.TextXAlignment = Enum.TextXAlignment.Center
    badge.BorderSizePixel = 0
    corner(badge, 4)
    badge.Parent = card

    local countdownLbl = Instance.new("TextLabel")
    countdownLbl.Size = UDim2.fromOffset(28, 15)
    countdownLbl.Position = UDim2.new(1, -34, 0, 8)
    countdownLbl.BackgroundTransparency = 1
    countdownLbl.Text = tostring(duration) .. "s"
    countdownLbl.TextColor3 = C.T3
    countdownLbl.TextSize = 9
    countdownLbl.Font = Enum.Font.GothamBold
    countdownLbl.TextXAlignment = Enum.TextXAlignment.Right
    countdownLbl.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -24, 0, 18)
    titleLbl.Position = UDim2.new(0, 16, 0, 26)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = title or ""
    titleLbl.TextColor3 = C.T1
    titleLbl.TextSize = 12
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
    titleLbl.Parent = card

    local msgLbl = Instance.new("TextLabel")
    msgLbl.Size = UDim2.new(1, -24, 0, 16)
    msgLbl.Position = UDim2.new(0, 16, 0, 46)
    msgLbl.BackgroundTransparency = 1
    msgLbl.Text = msg or ""
    msgLbl.TextColor3 = C.T2
    msgLbl.TextSize = 11
    msgLbl.Font = Enum.Font.Gotham
    msgLbl.TextXAlignment = Enum.TextXAlignment.Left
    msgLbl.TextTruncate = Enum.TextTruncate.AtEnd
    msgLbl.Parent = card

    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, 0, 0, 3)
    progressTrack.Position = UDim2.new(0, 0, 1, -3)
    progressTrack.BackgroundColor3 = C.DIV
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = card

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BackgroundColor3 = accent
    progressFill.BorderSizePixel = 0
    corner(progressFill, 1)
    progressFill.Parent = progressTrack

    card.Position = UDim2.new(1.1, 0, 0, 0)
    tw(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)

    tw(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)

    task.spawn(function()
        for i = duration - 1, 0, -1 do
            task.wait(1)
            if countdownLbl and countdownLbl.Parent then
                countdownLbl.Text = tostring(i) .. "s"
            end
        end
    end)

    task.delay(duration + 0.05, function()
        if card and card.Parent then
            tw(card, {Position = UDim2.new(1.1, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quint)
            task.wait(0.22)
            if card and card.Parent then
                card:Destroy()
            end
        end
    end)

    return card
end

-- CreateWindow
function Phat:CreateWindow(cfg)
    cfg = cfg or {}
    local W = cfg.Width or 640
    local H = cfg.Height or 500
    local SW = cfg.SidebarWidth or 150

    local Window = {
        _tabs = {},
        Notify = notify,
        _visible = true,
        _width = W,
        _height = H,
    }

    local sg = Instance.new("ScreenGui")
    sg.Name = "PhatUI"
    sg.Parent = PlayerGui
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Size = UDim2.new(0, 300, 0, 400)
    NotificationHolder.Position = UDim2.new(1, -320, 1, -420)
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.ClipsDescendants = true
    NotificationHolder.Parent = sg
    local nl = vlist(NotificationHolder, 8)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, W, 0, H)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = C.WIN
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = sg
    corner(Main, 14)
    stroke(Main, C.BOR, 1.5)

    -- TopBar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 44)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    TopBar.BackgroundColor3 = C.TOP
    TopBar.BorderSizePixel = 0
    TopBar.ClipsDescendants = false
    TopBar.Parent = Main

    local accentLine = Instance.new("Frame")
    accentLine.Size = UDim2.new(1, 0, 0, 2)
    accentLine.Position = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = C.RED
    accentLine.BorderSizePixel = 0
    accentLine.Parent = TopBar

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.Position = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = C.RED
    dot.BorderSizePixel = 0
    corner(dot, 4)
    dot.Parent = TopBar

    mkLabel(TopBar, {
        Text = cfg.Title or "PHAT UI",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        TextColor3 = C.T1,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- Window Buttons
    local function makeBtn(xOff, txt, nc, hc, tc)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(26, 26)
        btn.Position = UDim2.new(1, xOff, 0.5, -13)
        btn.Text = txt
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundColor3 = nc
        btn.TextColor3 = tc or C.T3
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        corner(btn, 6)
        btn.Parent = TopBar

        btn.MouseEnter:Connect(function()
            tw(btn, {BackgroundColor3 = hc}, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            tw(btn, {BackgroundColor3 = nc}, 0.1)
        end)

        return btn
    end

    local BtnMin = makeBtn(-72, "─", C.ELEM, C.ELEMH, C.T3)
    local BtnMax = makeBtn(-42, "□", C.ELEM, C.ELEMH, C.T3)
    local BtnClose = makeBtn(-12, "X", Color3.fromRGB(45, 12, 12), C.RED, C.RED)

    -- TopBar Drag
    local drag = {active = false, startPos = nil, startMainPos = nil}
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag.active = true
            drag.startPos = i.Position
            drag.startMainPos = Main.Position
        end
    end)
    TopBar.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag.active = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag.active and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - drag.startPos
            Main.Position = UDim2.new(
                drag.startMainPos.X.Scale,
                drag.startMainPos.X.Offset + delta.X,
                drag.startMainPos.Y.Scale,
                drag.startMainPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Edge Drag
    local EDGE_SIZE = 10
    local function createEdgeHitbox(name, pos, size)
        local hitbox = Instance.new("Frame")
        hitbox.Name = "Edge_" .. name
        hitbox.Size = size
        hitbox.Position = pos
        hitbox.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        hitbox.BackgroundTransparency = 1
        hitbox.BorderSizePixel = 0
        hitbox.ZIndex = 100
        hitbox.Parent = Main

        local dragging = false
        local startPos, startMainPos

        hitbox.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = {
                    edge = name,
                    startPos = i.Position,
                    startSize = Main.Size,
                    startPosUDim = Main.Position
                }
            end
        end)
        hitbox.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        return {hitbox = hitbox, dragging = function() return dragging end, 
                setDragging = function(v) dragging = v end,
                getStart = function() return startPos, startMainPos end,
                setStart = function(s, m) startPos = s; startMainPos = m end}
    end

    createEdgeHitbox("Top", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, EDGE_SIZE))
    createEdgeHitbox("Bottom", UDim2.new(0, 0, 1, -EDGE_SIZE), UDim2.new(1, 0, 0, EDGE_SIZE))
    createEdgeHitbox("Left", UDim2.new(0, 0, 0, 0), UDim2.new(0, EDGE_SIZE, 1, 0))
    createEdgeHitbox("Right", UDim2.new(1, -EDGE_SIZE, 0, 0), UDim2.new(0, EDGE_SIZE, 1, 0))
    local resizing = nil

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if not resizing then return end

        local delta = input.Position - resizing.startPos
        local newSize = resizing.startSize
        local newPos = resizing.startPosUDim

        if resizing.edge == "Right" then
            newSize = UDim2.new(0, math.max(400, resizing.startSize.X.Offset + delta.X), 0, resizing.startSize.Y.Offset)
        elseif resizing.edge == "Left" then
            newSize = UDim2.new(0, math.max(400, resizing.startSize.X.Offset - delta.X), 0, resizing.startSize.Y.Offset)
            newPos = UDim2.new(
                resizing.startPosUDim.X.Scale,
                resizing.startPosUDim.X.Offset + delta.X,
                resizing.startPosUDim.Y.Scale,
                resizing.startPosUDim.Y.Offset
            )
        elseif resizing.edge == "Bottom" then
            newSize = UDim2.new(0, resizing.startSize.X.Offset, 0, math.max(300, resizing.startSize.Y.Offset + delta.Y))
        elseif resizing.edge == "Top" then
            newSize = UDim2.new(0, resizing.startSize.X.Offset, 0, math.max(300, resizing.startSize.Y.Offset - delta.Y))
            newPos = UDim2.new(
                resizing.startPosUDim.X.Scale,
                resizing.startPosUDim.X.Offset,
                resizing.startPosUDim.Y.Scale,
                resizing.startPosUDim.Y.Offset + delta.Y
            )
        end

        Main.Size = newSize
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = nil
        end
    end)
    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, SW, 1, -44)
    Sidebar.Position = UDim2.new(0, 0, 0, 44)
    Sidebar.BackgroundColor3 = C.SIDE
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local sideDivider = Instance.new("Frame")
    sideDivider.Size = UDim2.new(0, 1, 1, 0)
    sideDivider.Position = UDim2.new(1, -1, 0, 0)
    sideDivider.BackgroundColor3 = C.DIV
    sideDivider.BorderSizePixel = 0
    sideDivider.Parent = Sidebar

    mkLabel(Sidebar, {
        Text = "NAVIGATE",
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 12, 0, 8),
        TextColor3 = Color3.fromRGB(60, 30, 30),
        TextSize = 9,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 1, -28)
    tabContainer.Position = UDim2.new(0, 0, 0, 26)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = Sidebar
    vlist(tabContainer, 4)
    pad(tabContainer, 2, 6, 6, 6)

    -- Content
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -SW, 1, -44)
    Content.Position = UDim2.new(0, SW, 0, 44)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 3
    Content.ScrollBarImageColor3 = C.RED
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.Parent = Main
    vlist(Content, 10)
    pad(Content, 12, 12, 12, 12)

    -- Floating Toggle Button
    local CoreGui = game:GetService("CoreGui")
    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "PhatToggle"
    ToggleGui.Parent = CoreGui
    ToggleGui.ResetOnSpawn = false
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleButton"
    ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
    ToggleBtn.Position = UDim2.new(0, 18, 0.5, -26)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleBtn.Text = "P"
    ToggleBtn.TextScaled = true
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.AutoButtonColor = false
    corner(ToggleBtn, 10)
    ToggleBtn.Parent = ToggleGui

    local BtnGrad = Instance.new("UIGradient")
    BtnGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
    })
    BtnGrad.Parent = ToggleBtn

    local BtnStroke = Instance.new("UIStroke")
    BtnStroke.Thickness = 2
    BtnStroke.Color = Color3.fromRGB(130, 130, 130)
    BtnStroke.Parent = ToggleBtn

    local btnDrag = {active = false, start = nil, orig = nil}

    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDrag.active = true
            btnDrag.start = input.Position
            btnDrag.orig = ToggleBtn.Position
        end
    end)

    ToggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDrag.active = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if btnDrag.active and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - btnDrag.start
            ToggleBtn.Position = UDim2.new(
                btnDrag.orig.X.Scale,
                btnDrag.orig.X.Offset + delta.X,
                btnDrag.orig.Y.Scale,
                btnDrag.orig.Y.Offset + delta.Y
            )
        end
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        Window._visible = not Window._visible
        Main.Visible = Window._visible

        if Window._visible then
            BtnGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            })
            BtnStroke.Color = Color3.fromRGB(130, 130, 130)
        else
            BtnGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 0))
            })
            BtnStroke.Color = Color3.fromRGB(255, 120, 0)
        end
    end)

    ToggleBtn.MouseEnter:Connect(function()
        tw(ToggleBtn, {Size = UDim2.new(0, 60, 0, 60)}, 0.12, Enum.EasingStyle.Quad)
        BtnGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 0))
        })
        BtnStroke.Color = Color3.fromRGB(255, 120, 0)
    end)

    ToggleBtn.MouseLeave:Connect(function()
        if Window._visible then
            tw(ToggleBtn, {Size = UDim2.new(0, 52, 0, 52)}, 0.12, Enum.EasingStyle.Quad)
            BtnGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            })
            BtnStroke.Color = Color3.fromRGB(130, 130, 130)
        else
            tw(ToggleBtn, {Size = UDim2.new(0, 52, 0, 52)}, 0.12, Enum.EasingStyle.Quad)
        end
    end)

    -- Window Methods
    function Window:Toggle()
        self._visible = not self._visible
        Main.Visible = self._visible
        if self._visible then
            BtnGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 90, 90)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            })
            BtnStroke.Color = Color3.fromRGB(130, 130, 130)
        else
            BtnGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 20, 0))
            })
            BtnStroke.Color = Color3.fromRGB(255, 120, 0)
        end
        return self._visible
    end

    function Window:Show()
        self._visible = true
        Main.Visible = true
    end

    function Window:Hide()
        self._visible = false
        Main.Visible = false
    end

    function Window:IsVisible()
        return self._visible
    end

    -- AddTab
    local tabIdx = 0

    function Window:AddTab(cfg)
        cfg = cfg or {}
        tabIdx = tabIdx + 1
        local mi = tabIdx
        local Tab = {}

        local TBtn = Instance.new("TextButton")
        TBtn.Name = "Tab" .. mi
        TBtn.Size = UDim2.new(1, 0, 0, 38)
        TBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TBtn.BackgroundTransparency = 1
        TBtn.Text = ""
        TBtn.BorderSizePixel = 0
        TBtn.LayoutOrder = mi
        corner(TBtn, 8)
        TBtn.Parent = tabContainer

        local lBar = Instance.new("Frame")
        lBar.Size = UDim2.new(0, 3, 0.6, 0)
        lBar.Position = UDim2.new(0, 0, 0.2, 0)
        lBar.BackgroundColor3 = C.RED
        lBar.BorderSizePixel = 0
        lBar.Visible = false
        corner(lBar, 2)
        lBar.Parent = TBtn

        local icoBg = Instance.new("Frame")
        icoBg.Size = UDim2.fromOffset(24, 24)
        icoBg.Position = UDim2.new(0, 8, 0.5, -12)
        icoBg.BackgroundColor3 = C.DARKRED
        icoBg.BackgroundTransparency = 0.4
        icoBg.BorderSizePixel = 0
        corner(icoBg, 6)
        icoBg.Parent = TBtn

        mkLabel(icoBg, {
            Text = cfg.Icon or "●",
            Size = UDim2.new(1, 0, 1, 0),
            TextColor3 = C.T2,
            TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
        })

        local tLbl = mkLabel(TBtn, {
            Text = cfg.Title or ("Tab " .. mi),
            Size = UDim2.new(1, -46, 1, 0),
            Position = UDim2.new(0, 40, 0, 0),
            TextColor3 = C.T3,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local Page = Instance.new("Frame")
        Page.Name = "Page" .. mi
        Page.Size = UDim2.new(1, 0, 0, 0)
        Page.AutomaticSize = Enum.AutomaticSize.Y
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.LayoutOrder = mi
        vlist(Page, 10)
        Page.Parent = Content

        local function activate()
            for _, t in ipairs(Window._tabs) do
                t._page.Visible = false
                t._lbar.Visible = false
                tw(t._btn, {BackgroundTransparency = 1}, 0.12)
                tw(t._lbl, {TextColor3 = C.T3}, 0.12)
            end
            Page.Visible = true
            Page.BackgroundTransparency = 1
            tw(Page, {BackgroundTransparency = 0}, 0.2)
            lBar.Visible = true
            tw(TBtn, {BackgroundColor3 = C.ELEMH, BackgroundTransparency = 0}, 0.12)
            tw(tLbl, {TextColor3 = C.RED2}, 0.12)
        end

        Tab._page = Page
        Tab._btn = TBtn
        Tab._lbar = lBar
        Tab._lbl = tLbl

        TBtn.MouseButton1Click:Connect(activate)
        TBtn.MouseEnter:Connect(function()
            if not Page.Visible then
                tw(TBtn, {BackgroundColor3 = Color3.fromRGB(30, 15, 15), BackgroundTransparency = 0}, 0.08)
            end
        end)
        TBtn.MouseLeave:Connect(function()
            if not Page.Visible then
                tw(TBtn, {BackgroundTransparency = 1}, 0.1)
            end
        end)

        if tabIdx == 1 then task.defer(activate) end
        table.insert(Window._tabs, Tab)

        -- AddSection
        local secIdx = 0
        function Tab:AddSection(title)
            secIdx = secIdx + 1
            local Sec = {}

            local SecFrame = Instance.new("Frame")
            SecFrame.Name = "Sec" .. secIdx
            SecFrame.Size = UDim2.new(1, 0, 0, 0)
            SecFrame.AutomaticSize = Enum.AutomaticSize.Y
            SecFrame.BackgroundColor3 = C.SEC
            SecFrame.BorderSizePixel = 0
            SecFrame.LayoutOrder = secIdx
            corner(SecFrame, 10)
            stroke(SecFrame, C.BOR, 1)
            SecFrame.Parent = Page

            local topLine = Instance.new("Frame")
            topLine.Size = UDim2.new(1, 0, 0, 1)
            topLine.BackgroundColor3 = C.RED
            topLine.BorderSizePixel = 0
            topLine.Parent = SecFrame

            local hRow = Instance.new("Frame")
            hRow.Size = UDim2.new(1, 0, 0, 32)
            hRow.BackgroundTransparency = 1
            hRow.Parent = SecFrame

            local sdot = Instance.new("Frame")
            sdot.Size = UDim2.fromOffset(5, 5)
            sdot.Position = UDim2.new(0, 12, 0.5, -2.5)
            sdot.BackgroundColor3 = C.RED
            sdot.BorderSizePixel = 0
            corner(sdot, 3)
            sdot.Parent = hRow

            mkLabel(hRow, {
                Text = title or "Section",
                Size = UDim2.new(1, -28, 1, 0),
                Position = UDim2.new(0, 24, 0, 0),
                TextColor3 = C.T2,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            local divider = Instance.new("Frame")
            divider.Size = UDim2.new(1, -16, 0, 1)
            divider.Position = UDim2.new(0, 8, 0, 32)
            divider.BackgroundColor3 = C.DIV
            divider.BorderSizePixel = 0
            divider.Parent = SecFrame

            local inner = Instance.new("Frame")
            inner.Size = UDim2.new(1, 0, 0, 0)
            inner.AutomaticSize = Enum.AutomaticSize.Y
            inner.BackgroundTransparency = 1
            pad(inner, 38, 10, 10, 10)
            vlist(inner, 6)
            inner.Parent = SecFrame

            local ei = 0

            -- AddButton
            function Sec:AddButton(bc)
                bc = bc or {}
                ei = ei + 1

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 36)
                row.BackgroundTransparency = 1
                row.LayoutOrder = ei
                row.Parent = inner

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 1, 0)
                btn.BackgroundColor3 = C.ELEM
                btn.Text = ""
                btn.BorderSizePixel = 0
                corner(btn, 7)
                stroke(btn, C.BOR, 1)
                btn.Parent = row

                local lstrip = Instance.new("Frame")
                lstrip.Size = UDim2.new(0, 2, 0.5, 0)
                lstrip.Position = UDim2.new(0, 0, 0.25, 0)
                lstrip.BackgroundColor3 = C.DARKRED
                lstrip.BorderSizePixel = 0
                corner(lstrip, 1)
                lstrip.Parent = btn

                mkLabel(btn, {
                    Text = bc.Title or "Button",
                    Size = UDim2.new(1, -36, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextColor3 = C.T1,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local arr = mkLabel(btn, {
                    Text = ">",
                    Size = UDim2.new(0, 18, 1, 0),
                    Position = UDim2.new(1, -20, 0, 0),
                    TextColor3 = C.T3,
                    TextSize = 16,
                    Font = Enum.Font.GothamBold,
                })
                local busy = false
                btn.MouseButton1Click:Connect(function()
                    if busy then return end
                    busy = true

                    tw(btn, {BackgroundColor3 = C.DARKRED}, 0.05)
                    task.delay(0.07, function()
                        tw(btn, {BackgroundColor3 = C.ELEM}, 0.15)
                        busy = false
                    end)

                    if bc.Callback then pcall(bc.Callback) end
                end)
                btn.MouseEnter:Connect(function()
                    tw(btn, {BackgroundColor3 = C.ELEMH}, 0.1)
                    tw(arr, {TextColor3 = C.RED2}, 0.1)
                end)
                btn.MouseLeave:Connect(function()
                    tw(btn, {BackgroundColor3 = C.ELEM}, 0.12)
                    tw(arr, {TextColor3 = C.T3}, 0.12)
                end)
            end
            -- Add Toggle
            function Sec:AddToggle(name, tc)
                if type(name) == "table" then
                    tc = name
                    name = tc.Name
                end
                tc = tc or {}
                ei = ei + 1
                local state = tc.Default or false

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 36)
                row.BackgroundColor3 = C.ELEM
                row.BorderSizePixel = 0
                row.LayoutOrder = ei
                corner(row, 7)
                stroke(row, C.BOR, 1)
                row.Parent = inner

                mkLabel(row, {
                    Text = tc.Title or "Toggle",
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextColor3 = C.T1,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local track = Instance.new("Frame")
                track.Size = UDim2.fromOffset(38, 18)
                track.Position = UDim2.new(1, -46, 0.5, -9)
                track.BackgroundColor3 = state and C.DARKRED or C.DIV
                track.BorderSizePixel = 0
                corner(track, 9)
                local tStr = stroke(track, state and C.RED or C.BOR, 1)
                track.Parent = row
                local knob = Instance.new("Frame")
                knob.Size = UDim2.fromOffset(12, 12)
                knob.Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
                knob.BackgroundColor3 = state and C.RED2 or C.T3
                knob.BorderSizePixel = 0
                corner(knob, 6)
                knob.Parent = track

                local function set(v)
                    state = v
                    if v then
                        tw(track, {BackgroundColor3 = C.DARKRED}, 0.16)
                        tw(knob, {Position = UDim2.new(1, -15, 0.5, -6), BackgroundColor3 = C.RED2}, 0.18)
                        tStr.Color = C.RED
                    else
                        tw(track, {BackgroundColor3 = C.DIV}, 0.16)
                        tw(knob, {Position = UDim2.new(0, 3, 0.5, -6), BackgroundColor3 = C.T3}, 0.18)
                        tStr.Color = C.BOR
                    end
                    if tc.Callback then pcall(tc.Callback, state) end
                end

                row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then set(not state) end
                end)
                row.MouseEnter:Connect(function()
                    tw(row, {BackgroundColor3 = C.ELEMH}, 0.08)
                end)
                row.MouseLeave:Connect(function()
                    tw(row, {BackgroundColor3 = C.ELEM}, 0.1)
                end)

                local ctrl = {
                    Set = set,
                    Get = function() return state end
                }

                if name then
                    Phat.Options[name] = {
                        Type = "Toggle",
                        SetValue = function(v) set(v) end,
                        GetValue = function() return state end,
                        _ctrl = ctrl,
                    }
                end

                return ctrl
            end

            -- AddSlider
            function Sec:AddSlider(sc)
                sc = sc or {}
                ei = ei + 1
                local mn, mx = sc.Min or 0, sc.Max or 100
                local val = sc.Default or mn

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
                sliderFrame.BackgroundColor3 = C.ELEM
                sliderFrame.BorderSizePixel = 0
                sliderFrame.LayoutOrder = ei
                corner(sliderFrame, 7)
                stroke(sliderFrame, C.BOR, 1)
                sliderFrame.Parent = inner

                mkLabel(sliderFrame, {
                    Text = sc.Title or "Slider",
                    Size = UDim2.new(1, -54, 0, 16),
                    Position = UDim2.new(0, 12, 0, 8),
                    TextColor3 = C.T1,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local vLbl = mkLabel(sliderFrame, {
                    Text = tostring(math.round(val)),
                    Size = UDim2.fromOffset(42, 16),
                    Position = UDim2.new(1, -52, 0, 8),
                    TextColor3 = C.RED2,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })

                local tBg = Instance.new("Frame")
                tBg.Size = UDim2.new(1, -24, 0, 4)
                tBg.Position = UDim2.new(0, 12, 1, -12)
                tBg.BackgroundColor3 = C.DIV
                tBg.BorderSizePixel = 0
                corner(tBg, 2)
                tBg.Parent = sliderFrame

                local pct = (val - mn) / (mx - mn)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(pct, 0, 1, 0)
                fill.BackgroundColor3 = C.RED
                fill.BorderSizePixel = 0
                corner(fill, 2)
                fill.Parent = tBg

                local handle = Instance.new("Frame")
                handle.Size = UDim2.fromOffset(14, 14)
                handle.Position = UDim2.new(pct, -7, 0.5, -7)
                handle.BackgroundColor3 = C.RED2
                handle.BorderSizePixel = 0
                corner(handle, 7)
                handle.Parent = tBg

                local dragging = false
                local function update(x)
                    local p = math.clamp((x - tBg.AbsolutePosition.X) / tBg.AbsoluteSize.X, 0, 1)
                    val = math.round(mn + (mx - mn) * p)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    handle.Position = UDim2.new(p, -7, 0.5, -7)
                    vLbl.Text = tostring(val)
                    if sc.Callback then pcall(sc.Callback, val) end
                end

                tBg.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        update(i.Position.X)
                    end
                end)

                UIS.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
                        update(i.Position.X)
                    end
                end)

                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                return {
                    Get = function() return val end,
                    Set = function(v)
                        v = math.clamp(v, mn, mx)
                        val = v
                        local p = (v - mn) / (mx - mn)
                        tw(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.1)
                        tw(handle, {Position = UDim2.new(p, -7, 0.5, -7)}, 0.1)
                        vLbl.Text = tostring(math.round(v))
                    end,
                }
            end

            -- AddInput
            function Sec:AddInput(ic)
                ic = ic or {}
                ei = ei + 1

                local wrap = Instance.new("Frame")
                wrap.Size = UDim2.new(1, 0, 0, 52)
                wrap.BackgroundTransparency = 1
                wrap.LayoutOrder = ei
                wrap.Parent = inner

                mkLabel(wrap, {
                    Text = ic.Title or "Input",
                    Size = UDim2.new(1, 0, 0, 14),
                    TextColor3 = C.T3,
                    TextSize = 10,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1, 0, 0, 32)
                    bg.Position = UDim2.new(0, 0, 0, 18)
                    bg.BackgroundColor3 = C.ELEM
                    bg.BorderSizePixel = 0
                    corner(bg, 7)
                    local iStr = stroke(bg, C.BOR, 1)
                    bg.Parent = wrap

                    local tb = Instance.new("TextBox")
                    tb.Size = UDim2.new(1, -16, 1, 0)
                    tb.Position = UDim2.new(0, 10, 0, 0)
                    tb.BackgroundTransparency = 1
                    tb.Text = ic.Default or ""
                    tb.PlaceholderText = ic.Placeholder or "Type here..."
                    tb.TextColor3 = C.T1
                    tb.PlaceholderColor3 = C.T3
                    tb.TextSize = 12
                    tb.Font = Enum.Font.Gotham
                    tb.TextXAlignment = Enum.TextXAlignment.Left
                    tb.ClearTextOnFocus = ic.ClearOnFocus ~= false
                    tb.Parent = bg

                    tb.Focused:Connect(function()
                        iStr.Color = C.RED
                    end)
                    tb.FocusLost:Connect(function(enter)
                        iStr.Color = C.BOR
                        if ic.Callback then pcall(ic.Callback, tb.Text, enter) end
                    end)

                    local ctrl = {Get = function() return tb.Text end}
                    registerOption(ic.Name, ctrl, "Input",
                        function(v) tb.Text = v end,
                        function() return tb.Text end
                    )

                    return ctrl
                end
                --- AddParagraph
                function Sec:AddTitle(text)
                    ei = ei + 1

                    local titleFrame = Instance.new("Frame")
                    titleFrame.Size = UDim2.new(1, 0, 0, 26)
                    titleFrame.BackgroundTransparency = 1
                    titleFrame.LayoutOrder = ei
                    titleFrame.Parent = inner

                    local titleLbl = mkLabel(titleFrame, {
                        Text = text or "Tiêu đề",
                        Size = UDim2.new(1, -12, 1, 0),
                        AnchorPoint = Vector2.new(0.5, 0),
                        Position = UDim2.new(0.5, 0, 0, 0),
                        TextColor3 = C.T1,
                        TextSize = 14,
                        Font = Enum.Font.GothamBold,
                        TextXAlignment = Enum.TextXAlignment.Center,
                    })

                    return {
                        DatTieuDe = function(t)
                            titleLbl.Text = t or ""
                        end,
                        LayTieuDe = function()
                            return titleLbl.Text
                        end
                    }
                end
            -- AddDropdown
            function Sec:AddDropdown(dc)
                dc = dc or {}
                ei = ei + 1
                local sel, open = dc.Default, false

                local ddw = Instance.new("Frame")
                ddw.Size = UDim2.new(1, 0, 0, 36)
                ddw.BackgroundTransparency = 1
                ddw.LayoutOrder = ei
                ddw.ClipsDescendants = false
                ddw.ZIndex = 20
                ddw.Parent = inner

                local dBtn = Instance.new("TextButton")
                dBtn.Size = UDim2.new(1, 0, 1, 0)
                dBtn.BackgroundColor3 = C.ELEM
                dBtn.Text = ""
                dBtn.BorderSizePixel = 0
                dBtn.ZIndex = 20
                corner(dBtn, 7)
                stroke(dBtn, C.BOR, 1)
                dBtn.Parent = ddw

                local dLbl = mkLabel(dBtn, {
                    Text = sel or dc.Title or "Select...",
                    Size = UDim2.new(1, -32, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextColor3 = sel and C.T1 or C.T3,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 21,
                })

                local dArr = mkLabel(dBtn, {
                    Text = "v",
                    Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -22, 0, 0),
                    TextColor3 = C.T3,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 21,
                })

                local panel = Instance.new("Frame")
                panel.Size = UDim2.new(1, 0, 0, 0)
                panel.Position = UDim2.new(0, 0, 1, 4)
                panel.BackgroundColor3 = C.SEC
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.ZIndex = 60
                corner(panel, 7)
                stroke(panel, C.RED, 1)
                panel.Parent = ddw
                vlist(panel, 2)
                pad(panel, 4, 4, 4, 4)

                local items = dc.Items or {}
                for _, item in ipairs(items) do
                    local opt = Instance.new("TextButton")
                    opt.Size = UDim2.new(1, 0, 0, 26)
                    opt.Text = item
                    opt.BackgroundColor3 = C.ELEM
                    opt.TextColor3 = C.T1
                    opt.TextSize = 11
                    opt.Font = Enum.Font.Gotham
                    opt.BorderSizePixel = 0
                    opt.ZIndex = 61
                    corner(opt, 5)
                    opt.Parent = panel

                    opt.MouseEnter:Connect(function()
                        tw(opt, {BackgroundColor3 = C.ELEMH}, 0.08)
                    end)
                    opt.MouseLeave:Connect(function()
                        tw(opt, {BackgroundColor3 = C.ELEM}, 0.1)
                    end)
                    opt.MouseButton1Click:Connect(function()
                        sel = item
                        dLbl.Text = item
                        dLbl.TextColor3 = C.T1
                        open = false
                        tw(panel, {Size = UDim2.new(1, 0, 0, 0)}, 0.14)
                        tw(dArr, {Rotation = 0}, 0.14)
                        if dc.Callback then pcall(dc.Callback, sel) end
                    end)
                end

                local pH = #items * 30 + 8
                dBtn.MouseButton1Click:Connect(function()
                    open = not open
                    tw(panel, {Size = open and UDim2.new(1, 0, 0, pH) or UDim2.new(1, 0, 0, 0)}, 0.16, Enum.EasingStyle.Quart)
                    tw(dArr, {Rotation = open and 180 or 0}, 0.16)
                end)
                local connection
                connection = UIS.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        if open then
                            local mousePos = i.Position
                            local absPos = ddw.AbsolutePosition
                            local absSize = ddw.AbsoluteSize

                            local inside =
                                mousePos.X >= absPos.X and
                                mousePos.X <= absPos.X + absSize.X and
                                mousePos.Y >= absPos.Y and
                                mousePos.Y <= absPos.Y + absSize.Y

                            if not inside then
                                open = false
                                tw(panel, {Size = UDim2.new(1, 0, 0, 0)}, 0.14)
                                tw(dArr, {Rotation = 0}, 0.14)
                            end
                        end
                    end
                end)
                local ctrl = {
                    Get = function() return sel end,
                    Set = function(v)
                        sel = v
                        dLbl.Text = v
                        dLbl.TextColor3 = C.T1
                    end,
                    Destroy = function()
                        if connection then connection:Disconnect() end
                    end
                }

                registerOption(dc.Name, ctrl, "Dropdown",
                    function(v)
                        sel = v
                        dLbl.Text = v
                        dLbl.TextColor3 = C.T1
                    end,
                    function() return sel end
                )

                return ctrl
            end
            return Sec
        end

        return Tab
    end

    -- Window Controls
    local minimized = false
    local maximized = false
    local origSize = Main.Size
    local origPos = Main.Position

    BtnMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Content.Visible = false
            Sidebar.Visible = false
            tw(Main, {Size = UDim2.new(0, W, 0, 44)}, 0.2, Enum.EasingStyle.Quart)
        else
            local newSize = maximized and UDim2.new(1, -20, 1, -20) or origSize
            tw(Main, {Size = newSize}, 0.2, Enum.EasingStyle.Quart)
            task.delay(0.1, function()
                Content.Visible = true
                Sidebar.Visible = true
            end)
        end
    end)

    BtnMax.MouseButton1Click:Connect(function()
        if minimized then return end
        maximized = not maximized
        if maximized then
            origSize = Main.Size
            origPos = Main.Position
            tw(Main, {Size = UDim2.new(1, -20, 1, -20), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2, Enum.EasingStyle.Quart)
            BtnMax.Text = "❐"
        else
            tw(Main, {Size = origSize, Position = origPos}, 0.2, Enum.EasingStyle.Quart)
            BtnMax.Text = "❐"
        end
    end)

    BtnClose.MouseButton1Click:Connect(function()
        tw(Main, {Size = UDim2.new(0, W, 0, 0), BackgroundTransparency = 1}, 0.18, Enum.EasingStyle.Quart)
        task.delay(0.2, function()
            sg:Destroy()
            ToggleGui:Destroy()
        end)
    end)

    -- Entry animation
    Main.BackgroundTransparency = 1
    Main.Size = UDim2.new(0, W * 0.85, 0, H * 0.85)
    tw(Main, {Size = UDim2.new(0, W, 0, H), BackgroundTransparency = 0}, 0.28, Enum.EasingStyle.Quint)

    return Window
end

return Phat
