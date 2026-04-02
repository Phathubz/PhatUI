--[[
  ██████╗ ██╗  ██╗ █████╗ ████████╗    ██╗   ██╗██╗
  Phat UI v8.0  ·  Red & Black
  Modern Vertical Layout
--]]

local Phat = {}
Phat.__index = Phat

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Palette: Red & Black (Refined)
local C = {
    WIN = Color3.fromRGB(18, 18, 24),
    TOP = Color3.fromRGB(14, 14, 20),
    SIDE = Color3.fromRGB(12, 12, 17),
    SEC = Color3.fromRGB(24, 24, 32),
    ELEM = Color3.fromRGB(28, 28, 38),
    ELEMH = Color3.fromRGB(36, 24, 24),

    RED = Color3.fromRGB(210, 40, 40),
    RED2 = Color3.fromRGB(255, 70, 70),
    RED3 = Color3.fromRGB(255, 100, 100),
    DARKRED = Color3.fromRGB(100, 15, 15),

    GREEN = Color3.fromRGB(40, 200, 100),
    BLUE = Color3.fromRGB(60, 160, 255),
    AMBER = Color3.fromRGB(200, 140, 20),

    T1 = Color3.fromRGB(245, 245, 245),
    T2 = Color3.fromRGB(100, 15, 15),
    T3 = Color3.fromRGB(100, 15, 15),

    DIV = Color3.fromRGB(35, 25, 25),
    BOR = Color3.fromRGB(50, 30, 30),
}

local function tw(o, p, t, s, d)
    local ti = TweenInfo.new(t or 0.18, s or Enum.EasingStyle.Quad, d or Enum.EasingDirection.Out)
    local tween = TweenService:Create(o, ti, p)
    tween:Play()
    return tween
end

local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end

local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.BOR
    s.Thickness = th or 1
    s.Transparency = tr or 0
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

local function hlist(p, px)
    local l = Instance.new("UIListLayout", p)
    l.FillDirection = Enum.FillDirection.Horizontal
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

local function mkBtn(parent, props)
    local l = Instance.new("TextButton", parent)
    l.BackgroundTransparency = 1
    for k, v in pairs(props) do l[k] = v end
    return l
end

-- Notification System
local NotificationHolder = nil

local function notify(title, msg, ntype, duration)
    duration = math.max(1, duration or 4)
    
    if not NotificationHolder then return end

    local accent = ({
        info = C.BLUE,
        success = C.GREEN,
        error = C.RED,
        warn = C.AMBER,
    })[ntype or "info"] or C.RED

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, -8, 0, 72)
    card.BackgroundColor3 = C.WIN
    card.BackgroundTransparency = 0.05
    card.BorderSizePixel = 0
    corner(card, 12)
    stroke(card, accent, 1.5)
    card.Parent = NotificationHolder

    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.fromOffset(36, 36)
    iconBg.Position = UDim2.new(0, 10, 0, 18)
    iconBg.BackgroundColor3 = accent
    iconBg.BackgroundTransparency = 0.85
    iconBg.BorderSizePixel = 0
    corner(iconBg, 10)
    iconBg.Parent = card

    local icon = mkLabel(iconBg, {
        Text = ({info = "i", success = "✓", error = "✕", warn = "⚠"})[ntype] or "i",
        Size = UDim2.new(1, 0, 1, 0),
        TextColor3 = accent,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
    })

    mkLabel(card, {
        Text = title or "",
        Size = UDim2.new(1, -70, 0, 18),
        Position = UDim2.new(0, 54, 0, 14),
        TextColor3 = C.T1,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    mkLabel(card, {
        Text = msg or "",
        Size = UDim2.new(1, -70, 0, 28),
        Position = UDim2.new(0, 54, 0, 34),
        TextColor3 = C.T2,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
    })

    local progressTrack = Instance.new("Frame")
    progressTrack.Size = UDim2.new(1, 0, 0, 3)
    progressTrack.Position = UDim2.new(0, 0, 1, -3)
    progressTrack.BackgroundColor3 = accent
    progressTrack.BackgroundTransparency = 0.7
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = card

    local progressFill = Instance.new("Frame")
    progressFill.Size = UDim2.new(1, 0, 1, 0)
    progressFill.BackgroundColor3 = accent
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressTrack

    card.Position = UDim2.new(1.1, 0, 0, 0)
    tw(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    tw(progressFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)

    task.delay(duration + 0.05, function()
        if card and card.Parent then
            tw(card, {Position = UDim2.new(1.1, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
            task.wait(0.26)
            if card and card.Parent then card:Destroy() end
        end
    end)

    return card
end

-- CreateWindow
function Phat:CreateWindow(cfg)
    cfg = cfg or {}
    local W = cfg.Width or 580
    local H = cfg.Height or 480
    local SW = cfg.SidebarWidth or 56

    local Window = {
        _tabs = {},
        Notify = notify,
        _visible = true,
        _width = W,
        _height = H,
    }

    local sg = Instance.new("ScreenGui")
    sg.Name = "PhatUI_v8"
    sg.Parent = PlayerGui
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Size = UDim2.new(0, 320, 0, 400)
    NotificationHolder.Position = UDim2.new(1, -340, 1, -420)
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
    corner(Main, 16)
    stroke(Main, C.BOR, 1.5)

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, SW, 1, 0)
    Sidebar.Position = UDim2.new(0, 0, 0, 0)
    Sidebar.BackgroundColor3 = C.SIDE
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main

    local sideAccent = Instance.new("Frame")
    sideAccent.Size = UDim2.new(0, 3, 1, 0)
    sideAccent.Position = UDim2.new(1, -3, 0, 0)
    sideAccent.BackgroundColor3 = C.RED
    sideAccent.BackgroundTransparency = 0.5
    sideAccent.BorderSizePixel = 0
    sideAccent.Parent = Sidebar

    local logoArea = Instance.new("Frame")
    logoArea.Size = UDim2.new(1, 0, 0, 50)
    logoArea.BackgroundTransparency = 1
    logoArea.Parent = Sidebar

    local logoBg = Instance.new("Frame")
    logoBg.Size = UDim2.fromOffset(36, 36)
    logoBg.Position = UDim2.new(0.5, -18, 0, 7)
    logoBg.BackgroundColor3 = C.RED
    logoBg.BorderSizePixel = 0
    corner(logoBg, 10)
    logoBg.Parent = logoArea

    mkLabel(logoBg, {
        Text = "P",
        Size = UDim2.new(1, 0, 1, 0),
        TextColor3 = C.T1,
        TextSize = 18,
        Font = Enum.Font.GothamBlack,
    })

    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, -8, 1, -58)
    tabContainer.Position = UDim2.new(0, 4, 0, 54)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = Sidebar
    vlist(tabContainer, 6)

    local ctrlArea = Instance.new("Frame")
    ctrlArea.Size = UDim2.new(1, -SW - 16, 0, 28)
    ctrlArea.Position = UDim2.new(0, SW + 8, 0, 8)
    ctrlArea.BackgroundTransparency = 1
    ctrlArea.Parent = Main

    local titleLbl = mkLabel(ctrlArea, {
        Text = cfg.Title or "PHAT UI",
        Size = UDim2.new(1, -90, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        TextColor3 = C.T2,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local ctrlBtns = Instance.new("Frame")
    ctrlBtns.Size = UDim2.new(0, 80, 1, 0)
    ctrlBtns.Position = UDim2.new(1, -80, 0, 0)
    ctrlBtns.BackgroundTransparency = 1
    ctrlBtns.Parent = ctrlArea
    hlist(ctrlBtns, 6)

    local function makeCtrlBtn(txt, nc, hc, tc)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(24, 24)
        btn.Text = txt
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.BackgroundColor3 = nc
        btn.TextColor3 = tc or C.T3
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        corner(btn, 6)
        btn.Parent = ctrlBtns

        btn.MouseEnter:Connect(function()
            tw(btn, {BackgroundColor3 = hc}, 0.1)
        end)
        btn.MouseLeave:Connect(function()
            tw(btn, {BackgroundColor3 = nc}, 0.1)
        end)

        return btn
    end

    local BtnMin = makeCtrlBtn("−", C.ELEM, C.ELEMH, C.T2)
    local BtnMax = makeCtrlBtn("□", C.ELEM, C.ELEMH, C.T2)
    local BtnClose = makeCtrlBtn("X", Color3.fromRGB(50, 20, 20), C.RED, C.RED2)

    local drag = {active = false, startPos = nil, startMainPos = nil}
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 44)
    TopBar.Position = UDim2.new(0, 0, 0, 0)
    TopBar.BackgroundTransparency = 1
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main

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
            Main.Position = UDim2.new(drag.startMainPos.X.Scale, drag.startMainPos.X.Offset + delta.X, drag.startMainPos.Y.Scale, drag.startMainPos.Y.Offset + delta.Y)
        end
    end)

    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -SW - 16, 1, -60)
    Content.Position = UDim2.new(0, SW + 8, 0, 52)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = C.RED
    Content.ScrollBarImageTransparency = 0.5
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.Parent = Main
    vlist(Content, 12)
    pad(Content, 8, 12, 12, 0)

    local EDGE_SIZE = 8
    local function createEdgeHitbox(name, pos, size)
        local hitbox = Instance.new("Frame")
        hitbox.Name = "Edge_" .. name
        hitbox.Size = size
        hitbox.Position = pos
        hitbox.BackgroundTransparency = 1
        hitbox.BorderSizePixel = 0
        hitbox.ZIndex = 100
        hitbox.Parent = Main

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

        return hitbox
    end

    createEdgeHitbox("Right", UDim2.new(1, -EDGE_SIZE, 0, 0), UDim2.new(0, EDGE_SIZE, 1, 0))
    createEdgeHitbox("Bottom", UDim2.new(0, 0, 1, -EDGE_SIZE), UDim2.new(1, 0, 0, EDGE_SIZE))
    local resizing = nil

    UIS.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        if not resizing then return end

        local delta = input.Position - resizing.startPos
        local newSize = resizing.startSize
        local newPos = resizing.startPosUDim

        if resizing.edge == "Right" then
            newSize = UDim2.new(0, math.max(500, resizing.startSize.X.Offset + delta.X), 0, resizing.startSize.Y.Offset)
        elseif resizing.edge == "Bottom" then
            newSize = UDim2.new(0, resizing.startSize.X.Offset, 0, math.max(350, resizing.startSize.Y.Offset + delta.Y))
        end

        Main.Size = newSize
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = nil
        end
    end)

    local ToggleGui = Instance.new("ScreenGui")
    ToggleGui.Name = "PhatToggle_v8"
    ToggleGui.Parent = PlayerGui
    ToggleGui.ResetOnSpawn = false
    ToggleGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
    ToggleBtn.Position = UDim2.new(0, 16, 0.5, -24)
    ToggleBtn.BackgroundColor3 = Color3.fromrgb(25, 25, 32)
    ToggleBtn.Text = "P"
    ToggleBtn.TextScaled = true
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.TextColor3 = C.T1
    ToggleBtn.AutoButtonColor = false
    corner(ToggleBtn, 14)
    ToggleBtn.Parent = ToggleGui
    stroke(ToggleBtn, C.RED, 2, 0.7)

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
            ToggleBtn.Position = UDim2.new(btnDrag.orig.X.Scale, btnDrag.orig.X.Offset + delta.X, btnDrag.orig.Y.Scale, btnDrag.orig.Y.Offset + delta.Y)
        end
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        Window._visible = not Window._visible
        Main.Visible = Window._visible
        stroke(ToggleBtn, C.RED, 2, Window._visible and 0.7 or 0)
    end)

    ToggleBtn.MouseEnter:Connect(function()
        tw(ToggleBtn, {Size = UDim2.new(0, 56, 0, 56)}, 0.12)
        stroke(ToggleBtn, C.RED2, 2, 0)
    end)
    ToggleBtn.MouseLeave:Connect(function()
        tw(ToggleBtn, {Size = UDim2.new(0, 48, 0, 48)}, 0.12)
        stroke(ToggleBtn, C.RED, 2, Window._visible and 0.7 or 0)
    end)

    function Window:Toggle()
        self._visible = not self._visible
        Main.Visible = self._visible
        stroke(ToggleBtn, C.RED, 2, self._visible and 0.7 or 0)
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

    local tabIdx = 0

    function Window:AddTab(cfg)
        cfg = cfg or {}
        tabIdx = tabIdx + 1
        local mi = tabIdx
        local Tab = {
            _elements = {},
        }

        local TBtn = Instance.new("TextButton")
        TBtn.Name = "Tab" .. mi
        TBtn.Size = UDim2.new(1, -8, 0, 46)
        TBtn.Position = UDim2.new(0, 4, 0, 0)
        TBtn.BackgroundTransparency = 1
        TBtn.Text = ""
        TBtn.BorderSizePixel = 0
        TBtn.LayoutOrder = mi
        corner(TBtn, 12)
        TBtn.Parent = tabContainer

        local iconBg = Instance.new("Frame")
        iconBg.Size = UDim2.fromOffset(32, 32)
        iconBg.Position = UDim2.new(0.5, -16, 0.5, -16)
        iconBg.BackgroundColor3 = C.RED
        iconBg.BackgroundTransparency = 1
        iconBg.BorderSizePixel = 0
        iconBg.Parent = TBtn

        local tLbl = mkLabel(TBtn, {
            Text = cfg.Title or ("Tab " .. mi),
            Size = UDim2.new(1, -4, 0, 14),
            Position = UDim2.new(0, 2, 0.5, -7),
            TextColor3 = C.T2,
            TextSize = 11,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
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
                tw(t._iconBg, {BackgroundTransparency = 1}, 0.15)
                tw(t._lbl, {TextColor3 = C.T3}, 0.15)
            end
            Page.Visible = true
            tw(Page, {BackgroundTransparency = 0}, 0.2)
            tw(iconBg, {BackgroundTransparency = 0}, 0.15)
            tw(tLbl, {TextColor3 = C.RED2}, 0.15)
        end

        Tab._page = Page
        Tab._btn = TBtn
        Tab._iconBg = iconBg
        Tab._lbl = tLbl

        TBtn.MouseButton1Click:Connect(activate)
        TBtn.MouseEnter:Connect(function()
            if not Page.Visible then
                tw(iconBg, {BackgroundTransparency = 0.5}, 0.08)
            end
        end)
        TBtn.MouseLeave:Connect(function()
            if not Page.Visible then
                tw(iconBg, {BackgroundTransparency = 1}, 0.1)
            end
        end)

        if tabIdx == 1 then task.defer(activate) end
        table.insert(Window._tabs, Tab)

        -- ============ AddButton ============
        function Tab:AddButton(bc)
            bc = bc or {}
            local elementId = #self._elements + 1

            local btnFrame = Instance.new("Frame")
            btnFrame.Size = UDim2.new(1, 0, 0, 0)
            btnFrame.AutomaticSize = Enum.AutomaticSize.Y
            btnFrame.BackgroundTransparency = 1
            btnFrame.LayoutOrder = elementId
            btnFrame.Parent = Page

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 0)
            btn.AutomaticSize = Enum.AutomaticSize.Y
            btn.BackgroundColor3 = C.ELEM
            btn.Text = ""
            btn.BorderSizePixel = 0
            corner(btn, 10)
            stroke(btn, C.BOR, 1, 0.5)
            btn.Parent = btnFrame
            pad(btn, 10, 12, 10, 12)

            mkLabel(btn, {
                Text = bc.Title or "Button",
                TextColor3 = C.T1,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
            })

            local busy = false
            btn.MouseButton1Click:Connect(function()
                if busy then return end
                busy = true
                tw(btn, {BackgroundColor3 = C.DARKRED}, 0.05)
                task.delay(0.08, function()
                    tw(btn, {BackgroundColor3 = C.ELEM}, 0.15)
                    busy = false
                end)
                if bc.Callback then pcall(bc.Callback) end
            end)
            btn.MouseEnter:Connect(function()
                tw(btn, {BackgroundColor3 = C.ELEMH}, 0.1)
                stroke(btn, C.RED, 1, 0)
            end)
            btn.MouseLeave:Connect(function()
                tw(btn, {BackgroundColor3 = C.ELEM}, 0.12)
                stroke(btn, C.BOR, 1, 0.5)
            end)

            table.insert(self._elements, btnFrame)
            return btnFrame
        end

        -- ============ AddToggle ============
        function Tab:AddToggle(tc)
            tc = tc or {}
            local state = tc.Default or false
            local elementId = #self._elements + 1

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 0)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.BackgroundColor3 = C.SEC
            row.BorderSizePixel = 0
            row.LayoutOrder = elementId
            corner(row, 12)
            stroke(row, C.BOR, 1, 0.5)
            row.Parent = Page
            pad(row, 10, 12, 10, 12)

            mkLabel(row, {
                Text = tc.Title or "Toggle",
                TextColor3 = C.T1,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                AutomaticSize = Enum.AutomaticSize.Y,
            })

            local track = Instance.new("Frame")
            track.Size = UDim2.fromOffset(44, 24)
            track.BackgroundColor3 = C.DIV
            track.BorderSizePixel = 0
            corner(track, 12)
            stroke(track, state and C.RED or C.BOR, 2, state and 0 or 0.5)
            track.Parent = row

            local knob = Instance.new("Frame")
            knob.Size = UDim2.fromOffset(18, 18)
            knob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            knob.BackgroundColor3 = state and C.RED2 or C.T3
            knob.BorderSizePixel = 0
            corner(knob, 9)
            knob.Parent = track

            local layout = hlist(row, 8)
            layout.VerticalAlignment = Enum.VerticalAlignment.Center

            local contentWrap = Instance.new("Frame")
            contentWrap.Size = UDim2.new(1, -52, 1, 0)
            contentWrap.AutomaticSize = Enum.AutomaticSize.Y
            contentWrap.BackgroundTransparency = 1
            contentWrap.Parent = row
            contentWrap.LayoutOrder = 1

            local trackWrap = Instance.new("Frame")
            trackWrap.Size = UDim2.new(0, 44, 0, 24)
            trackWrap.BackgroundTransparency = 1
            trackWrap.Parent = row
            trackWrap.LayoutOrder = 2

            local function set(v)
                state = v
                if v then
                    tw(track, {BackgroundColor3 = C.DARKRED}, 0.15)
                    tw(knob, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = C.RED2}, 0.18)
                    stroke(track, C.RED, 2, 0)
                else
                    tw(track, {BackgroundColor3 = C.DIV}, 0.15)
                    tw(knob, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = C.T3}, 0.18)
                    stroke(track, C.BOR, 2, 0.5)
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
                tw(row, {BackgroundColor3 = C.SEC}, 0.1)
            end)

            set(state)
            table.insert(self._elements, row)

            return {
                Set = set,
                Get = function() return state end
            }
        end

        -- ============ AddSlider ============
        function Tab:AddSlider(sc)
            sc = sc or {}
            local mn, mx = sc.Min or 0, sc.Max or 100
            local val = sc.Default or mn
            local elementId = #self._elements + 1

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 0)
            sliderFrame.AutomaticSize = Enum.AutomaticSize.Y
            sliderFrame.BackgroundColor3 = C.SEC
            sliderFrame.BorderSizePixel = 0
            sliderFrame.LayoutOrder = elementId
            corner(sliderFrame, 12)
            stroke(sliderFrame, C.BOR, 1, 0.5)
            sliderFrame.Parent = Page

            local innerWrap = Instance.new("Frame")
            innerWrap.Size = UDim2.new(1, 0, 0, 0)
            innerWrap.AutomaticSize = Enum.AutomaticSize.Y
            innerWrap.BackgroundTransparency = 1
            innerWrap.Parent = sliderFrame
            vlist(innerWrap, 8)
            pad(innerWrap, 12, 12, 12, 12)

            mkLabel(innerWrap, {
                Text = sc.Title or "Slider",
                TextColor3 = C.T1,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.Y,
            })

            local vLbl = mkLabel(innerWrap, {
                Text = tostring(math.round(val)),
                Size = UDim2.fromOffset(50, 20),
                TextColor3 = C.RED2,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
                AutomaticSize = Enum.AutomaticSize.Y,
            })

            local headerRow = Instance.new("Frame")
            headerRow.Size = UDim2.new(1, 0, 0, 20)
            headerRow.BackgroundTransparency = 1
            headerRow.Parent = innerWrap

            mkLabel(headerRow, {
                Text = sc.Title or "Slider",
                Size = UDim2.new(1, -56, 1, 0),
                TextColor3 = C.T1,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            mkLabel(headerRow, {
                Text = tostring(math.round(val)),
                Size = UDim2.fromOffset(50, 20),
                Position = UDim2.new(1, -54, 0, 0),
                TextColor3 = C.RED2,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Right,
            })

            local tBg = Instance.new("Frame")
            tBg.Size = UDim2.new(1, 0, 0, 6)
            tBg.BackgroundColor3 = C.DIV
            tBg.BorderSizePixel = 0
            corner(tBg, 3)
            tBg.Parent = innerWrap

            local pct = (val - mn) / (mx - mn)
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new(pct, 0, 1, 0)
            fill.BackgroundColor3 = C.RED
            fill.BackgroundTransparency = 0.3
            fill.BorderSizePixel = 0
            corner(fill, 3)
            fill.Parent = tBg

            local handle = Instance.new("Frame")
            handle.Size = UDim2.fromOffset(16, 16)
            handle.Position = UDim2.new(pct, -8, 0.5, -8)
            handle.BackgroundColor3 = C.RED2
            handle.BorderSizePixel = 0
            corner(handle, 8)
            stroke(handle, C.RED, 2, 0.3)
            handle.Parent = tBg

            local dragging = false
            local function update(x)
                local p = math.clamp((x - tBg.AbsolutePosition.X) / tBg.AbsoluteSize.X, 0, 1)
                val = math.round(mn + (mx - mn) * p)
                fill.Size = UDim2.new(p, 0, 1, 0)
                handle.Position = UDim2.new(p, -8, 0.5, -8)
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

            sliderFrame.MouseEnter:Connect(function()
                tw(sliderFrame, {BackgroundColor3 = C.ELEMH}, 0.08)
            end)
            sliderFrame.MouseLeave:Connect(function()
                tw(sliderFrame, {BackgroundColor3 = C.SEC}, 0.1)
            end)

            table.insert(self._elements, sliderFrame)

            return {
                Get = function() return val end,
                Set = function(v)
                    v = math.clamp(v, mn, mx)
                    val = v
                    local p = (v - mn) / (mx - mn)
                    tw(fill, {Size = UDim2.new(p, 0, 1, 0)}, 0.1)
                    tw(handle, {Position = UDim2.new(p, -8, 0.5, -8)}, 0.1)
                    vLbl.Text = tostring(math.round(v))
                end,
            }
        end

        -- ============ AddInput ============
        function Tab:AddInput(cfg)
            cfg = cfg or {}
            local elementId = #self._elements + 1

            local wrap = Instance.new("Frame")
            wrap.Size = UDim2.new(1, 0, 0, 0)
            wrap.AutomaticSize = Enum.AutomaticSize.Y
            wrap.BackgroundTransparency = 1
            wrap.LayoutOrder = elementId
            wrap.Parent = Page

            mkLabel(wrap, {
                Text = cfg.Title or "Input",
                TextColor3 = C.T3,
                TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutomaticSize = Enum.AutomaticSize.Y,
            })

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, 0, 0, 38)
            bg.BackgroundColor3 = C.ELEM
            bg.BorderSizePixel = 0
            corner(bg, 10)
            stroke(bg, C.BOR, 1.5, 0.5)
            bg.Parent = wrap

            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(1, -20, 1, 0)
            tb.Position = UDim2.new(0, 12, 0, 0)
            tb.BackgroundTransparency = 1
            tb.Text = cfg.Default or ""
            tb.PlaceholderText = cfg.Placeholder or "Type here..."
            tb.TextColor3 = C.T1
            tb.PlaceholderColor3 = C.T3
            tb.TextSize = 13
            tb.Font = Enum.Font.Gotham
            tb.TextXAlignment = Enum.TextXAlignment.Left
            tb.ClearTextOnFocus = cfg.ClearOnFocus ~= false
            tb.Parent = bg

            tb.Focused:Connect(function()
                stroke(bg, C.RED, 1.5, 0)
            end)
            tb.FocusLost:Connect(function(enter)
                stroke(bg, C.BOR, 1.5, 0.5)
                if cfg.Callback then pcall(cfg.Callback, tb.Text, enter) end
            end)

            bg.MouseEnter:Connect(function()
                tw(bg, {BackgroundColor3 = C.ELEMH}, 0.08)
            end)
            bg.MouseLeave:Connect(function()
                tw(bg, {BackgroundColor3 = C.ELEM}, 0.1)
            end)

            table.insert(self._elements, wrap)

            return {
                Get = function() return tb.Text end,
                Set = function(v) tb.Text = v end,
            }
        end

        -- ============ AddDropdown ============
        function Tab:AddDropdown(dc)
            dc = dc or {}
            local sel, open = dc.Default, false
            local elementId = #self._elements + 1

            local ddw = Instance.new("Frame")
            ddw.Size = UDim2.new(1, 0, 0, 52)
            ddw.BackgroundTransparency = 1
            ddw.LayoutOrder = elementId
            ddw.ClipsDescendants = false
            ddw.ZIndex = 20
            ddw.Parent = Page

            local dBtn = Instance.new("TextButton")
            dBtn.Size = UDim2.new(1, 0, 1, 0)
            dBtn.BackgroundColor3 = C.ELEM
            dBtn.Text = ""
            dBtn.BorderSizePixel = 0
            dBtn.ZIndex = 20
            corner(dBtn, 10)
            stroke(dBtn, C.BOR, 1.5, 0.5)
            dBtn.Parent = ddw
            pad(dBtn, 0, 40, 0, 12)

            local dLbl = mkLabel(dBtn, {
                Text = sel or dc.Title or "Select...",
                Size = UDim2.new(1, 0, 1, 0),
                TextColor3 = sel and C.T1 or C.T3,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                ZIndex = 21,
            })

            local dArr = mkLabel(dBtn, {
                Text = "⌄",
                Size = UDim2.fromOffset(20, 20),
                Position = UDim2.new(1, -32, 0.5, -10),
                TextColor3 = C.T3,
                TextSize = 16,
                Font = Enum.Font.GothamBold,
                ZIndex = 21,
            })

            local panel = Instance.new("Frame")
            panel.Size = UDim2.new(1, -12, 0, 0)
            panel.Position = UDim2.new(0, 6, 1, 4)
            panel.BackgroundColor3 = C.WIN
            panel.BorderSizePixel = 0
            panel.ClipsDescendants = true
            panel.ZIndex = 60
            corner(panel, 10)
            stroke(panel, C.RED, 1, 0.3)
            panel.Parent = ddw
            vlist(panel, 4)
            pad(panel, 6, 6, 6, 6)

            local items = dc.Items or {}
            for _, item in ipairs(items) do
                local opt = Instance.new("TextButton")
                opt.Size = UDim2.new(1, 0, 0, 30)
                opt.Text = ""
                opt.BackgroundColor3 = C.ELEM
                opt.BorderSizePixel = 0
                opt.ZIndex = 61
                corner(opt, 8)
                opt.Parent = panel

                mkLabel(opt, {
                    Text = item,
                    Size = UDim2.new(1, 0, 1, 0),
                    TextColor3 = C.T1,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ZIndex = 62,
                })

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
                    tw(panel, {Size = UDim2.new(1, -12, 0, 0)}, 0.14)
                    tw(dArr, {Rotation = 0}, 0.14)
                    if dc.Callback then pcall(dc.Callback, sel) end
                end)
            end

            local pH = #items * 34 + 12
            dBtn.MouseButton1Click:Connect(function()
                open = not open
                tw(panel, {Size = open and UDim2.new(1, -12, 0, pH) or UDim2.new(1, -12, 0, 0)}, 0.16)
                tw(dArr, {Rotation = open and 180 or 0}, 0.16)
                if open then stroke(panel, C.RED, 1, 0) else stroke(panel, C.RED, 1, 0.3) end
            end)

            local connection
            connection = UIS.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 and open then
                    local mousePos = i.Position
                    local absPos = ddw.AbsolutePosition
                    local absSize = ddw.AbsoluteSize
                    if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                        open = false
                        tw(panel, {Size = UDim2.new(1, -12, 0, 0)}, 0.14)
                        tw(dArr, {Rotation = 0}, 0.14)
                        stroke(panel, C.RED, 1, 0.3)
                    end
                end
            end)

            ddw.MouseEnter:Connect(function()
                tw(dBtn, {BackgroundColor3 = C.ELEMH}, 0.08)
            end)
            ddw.MouseLeave:Connect(function()
                tw(dBtn, {BackgroundColor3 = C.ELEM}, 0.1)
            end)

            table.insert(self._elements, ddw)

            return {
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
        end

        -- ============ AddSection ============
        function Tab:AddSection(title)
            local Sec = {}
            local secId = #self._elements + 1

            local secFrame = Instance.new("Frame")
            secFrame.Size = UDim2.new(1, 0, 0, 0)
            secFrame.AutomaticSize = Enum.AutomaticSize.Y
            secFrame.BackgroundTransparency = 1
            secFrame.LayoutOrder = secId
            secFrame.Parent = Page

            if title then
                local header = Instance.new("Frame")
                header.Size = UDim2.new(1, 0, 0, 24)
                header.BackgroundTransparency = 1
                header.Parent = secFrame

                local dot = Instance.new("Frame")
                dot.Size = UDim2.fromOffset(6, 6)
                dot.Position = UDim2.new(0, 4, 0.5, -3)
                dot.BackgroundColor3 = C.RED
                dot.BorderSizePixel = 0
                corner(dot, 3)
                dot.Parent = header

                mkLabel(header, {
                    Text = title:upper(),
                    Size = UDim2.new(1, -18, 1, 0),
                    Position = UDim2.new(0, 16, 0, 0),
                    TextColor3 = C.T3,
                    TextSize = 10,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
            end

            local inner = Instance.new("Frame")
            inner.Size = UDim2.new(1, 0, 0, 0)
            inner.AutomaticSize = Enum.AutomaticSize.Y
            inner.BackgroundTransparency = 1
            vlist(inner, 8)
            inner.Parent = secFrame

            local ei = 0

            function Sec:AddButton(bc)
                bc = bc or {}
                ei = ei + 1

                local btnFrame = Instance.new("Frame")
                btnFrame.Size = UDim2.new(1, 0, 0, 0)
                btnFrame.AutomaticSize = Enum.AutomaticSize.Y
                btnFrame.BackgroundTransparency = 1
                btnFrame.LayoutOrder = ei
                btnFrame.Parent = inner

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 0)
                btn.AutomaticSize = Enum.AutomaticSize.Y
                btn.BackgroundColor3 = C.ELEM
                btn.Text = ""
                btn.BorderSizePixel = 0
                corner(btn, 10)
                stroke(btn, C.BOR, 1, 0.5)
                btn.Parent = btnFrame
                pad(btn, 10, 12, 10, 12)

                mkLabel(btn, {
                    Text = bc.Title or "Button",
                    TextColor3 = C.T1,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })

                local busy = false
                btn.MouseButton1Click:Connect(function()
                    if busy then return end
                    busy = true
                    tw(btn, {BackgroundColor3 = C.DARKRED}, 0.05)
                    task.delay(0.08, function()
                        tw(btn, {BackgroundColor3 = C.ELEM}, 0.15)
                        busy = false
                    end)
                    if bc.Callback then pcall(bc.Callback) end
                end)
                btn.MouseEnter:Connect(function()
                    tw(btn, {BackgroundColor3 = C.ELEMH}, 0.1)
                    stroke(btn, C.RED, 1, 0)
                end)
                btn.MouseLeave:Connect(function()
                    tw(btn, {BackgroundColor3 = C.ELEM}, 0.12)
                    stroke(btn, C.BOR, 1, 0.5)
                end)
            end

            function Sec:AddToggle(tc)
                tc = tc or {}
                ei = ei + 1
                local state = tc.Default or false

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 0)
                row.AutomaticSize = Enum.AutomaticSize.Y
                row.BackgroundColor3 = C.SEC
                row.BorderSizePixel = 0
                row.LayoutOrder = ei
                corner(row, 10)
                stroke(row, C.BOR, 1, 0.5)
                row.Parent = inner
                pad(row, 10, 12, 10, 12)

                mkLabel(row, {
                    Text = tc.Title or "Toggle",
                    TextColor3 = C.T1,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })

                local track = Instance.new("Frame")
                track.Size = UDim2.fromOffset(44, 24)
                track.BackgroundColor3 = C.DIV
                track.BorderSizePixel = 0
                corner(track, 12)
                stroke(track, state and C.RED or C.BOR, 2, state and 0 or 0.5)
                track.Parent = row

                local knob = Instance.new("Frame")
                knob.Size = UDim2.fromOffset(18, 18)
                knob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                knob.BackgroundColor3 = state and C.RED2 or C.T3
                knob.BorderSizePixel = 0
                corner(knob, 9)
                knob.Parent = track

                local function set(v)
                    state = v
                    if v then
                        tw(track, {BackgroundColor3 = C.DARKRED}, 0.15)
                        tw(knob, {Position = UDim2.new(1, -21, 0.5, -9), BackgroundColor3 = C.RED2}, 0.18)
                        stroke(track, C.RED, 2, 0)
                    else
                        tw(track, {BackgroundColor3 = C.DIV}, 0.15)
                        tw(knob, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = C.T3}, 0.18)
                        stroke(track, C.BOR, 2, 0.5)
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
                    tw(row, {BackgroundColor3 = C.SEC}, 0.1)
                end)

                set(state)
                return {Set = set, Get = function() return state end}
            end

            function Sec:AddSlider(sc)
                sc = sc or {}
                ei = ei + 1
                local mn, mx = sc.Min or 0, sc.Max or 100
                local val = sc.Default or mn

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 0)
                sliderFrame.AutomaticSize = Enum.AutomaticSize.Y
                sliderFrame.BackgroundColor3 = C.SEC
                sliderFrame.BorderSizePixel = 0
                sliderFrame.LayoutOrder = ei
                corner(sliderFrame, 10)
                stroke(sliderFrame, C.BOR, 1, 0.5)
                sliderFrame.Parent = inner

                local innerWrap = Instance.new("Frame")
                innerWrap.Size = UDim2.new(1, 0, 0, 0)
                innerWrap.AutomaticSize = Enum.AutomaticSize.Y
                innerWrap.BackgroundTransparency = 1
                innerWrap.Parent = sliderFrame
                vlist(innerWrap, 8)
                pad(innerWrap, 12, 12, 12, 12)

                local headerRow = Instance.new("Frame")
                headerRow.Size = UDim2.new(1, 0, 0, 20)
                headerRow.BackgroundTransparency = 1
                headerRow.Parent = innerWrap

                mkLabel(headerRow, {
                    Text = sc.Title or "Slider",
                    Size = UDim2.new(1, -56, 1, 0),
                    TextColor3 = C.T1,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local vLbl = mkLabel(headerRow, {
                    Text = tostring(math.round(val)),
                    Size = UDim2.fromOffset(50, 20),
                    Position = UDim2.new(1, -54, 0, 0),
                    TextColor3 = C.RED2,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })

                local tBg = Instance.new("Frame")
                tBg.Size = UDim2.new(1, 0, 0, 6)
                tBg.BackgroundColor3 = C.DIV
                tBg.BorderSizePixel = 0
                corner(tBg, 3)
                tBg.Parent = innerWrap

                local pct = (val - mn) / (mx - mn)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(pct, 0, 1, 0)
                fill.BackgroundColor3 = C.RED
                fill.BackgroundTransparency = 0.3
                fill.BorderSizePixel = 0
                corner(fill, 3)
                fill.Parent = tBg

                local handle = Instance.new("Frame")
                handle.Size = UDim2.fromOffset(16, 16)
                handle.Position = UDim2.new(pct, -8, 0.5, -8)
                handle.BackgroundColor3 = C.RED2
                handle.BorderSizePixel = 0
                corner(handle, 8)
                handle.Parent = tBg

                local dragging = false
                local function update(x)
                    local p = math.clamp((x - tBg.AbsolutePosition.X) / tBg.AbsoluteSize.X, 0, 1)
                    val = math.round(mn + (mx - mn) * p)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    handle.Position = UDim2.new(p, -8, 0.5, -8)
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
                        tw(handle, {Position = UDim2.new(p, -8, 0.5, -8)}, 0.1)
                        vLbl.Text = tostring(math.round(v))
                    end,
                }
            end

            function Sec:AddInput(ic)
                ic = ic or {}
                ei = ei + 1

                local wrap = Instance.new("Frame")
                wrap.Size = UDim2.new(1, 0, 0, 0)
                wrap.AutomaticSize = Enum.AutomaticSize.Y
                wrap.BackgroundTransparency = 1
                wrap.LayoutOrder = ei
                wrap.Parent = inner

                mkLabel(wrap, {
                    Text = ic.Title or "Input",
                    TextColor3 = C.T3,
                    TextSize = 10,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })

                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(1, 0, 0, 34)
                bg.BackgroundColor3 = C.ELEM
                bg.BorderSizePixel = 0
                corner(bg, 8)
                stroke(bg, C.BOR, 1.5, 0.5)
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
                    stroke(bg, C.RED, 1.5, 0)
                end)
                tb.FocusLost:Connect(function(enter)
                    stroke(bg, C.BOR, 1.5, 0.5)
                    if ic.Callback then pcall(ic.Callback, tb.Text, enter) end
                end)

                return {Get = function() return tb.Text end}
            end

            function Sec:AddDropdown(dc)
                dc = dc or {}
                local sel, open = dc.Default, false
                ei = ei + 1

                local ddw = Instance.new("Frame")
                ddw.Size = UDim2.new(1, 0, 0, 44)
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
                corner(dBtn, 10)
                stroke(dBtn, C.BOR, 1.5, 0.5)
                dBtn.Parent = ddw
                pad(dBtn, 0, 40, 0, 12)

                local dLbl = mkLabel(dBtn, {
                    Text = sel or dc.Title or "Select...",
                    Size = UDim2.new(1, 0, 1, 0),
                    TextColor3 = sel and C.T1 or C.T3,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    ZIndex = 21,
                })

                local dArr = mkLabel(dBtn, {
                    Text = "⌄",
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -32, 0.5, -10),
                    TextColor3 = C.T3,
                    TextSize = 16,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 21,
                })

                local panel = Instance.new("Frame")
                panel.Size = UDim2.new(1, -12, 0, 0)
                panel.Position = UDim2.new(0, 6, 1, 4)
                panel.BackgroundColor3 = C.WIN
                panel.BorderSizePixel = 0
                panel.ClipsDescendants = true
                panel.ZIndex = 60
                corner(panel, 10)
                stroke(panel, C.RED, 1, 0.3)
                panel.Parent = ddw
                vlist(panel, 4)
                pad(panel, 6, 6, 6, 6)

                local items = dc.Items or {}
                for _, item in ipairs(items) do
                    local opt = Instance.new("TextButton")
                    opt.Size = UDim2.new(1, 0, 0, 28)
                    opt.Text = ""
                    opt.BackgroundColor3 = C.ELEM
                    opt.BorderSizePixel = 0
                    opt.ZIndex = 61
                    corner(opt, 6)
                    opt.Parent = panel

                    mkLabel(opt, {
                        Text = item,
                        Size = UDim2.new(1, 0, 1, 0),
                        TextColor3 = C.T1,
                        TextSize = 12,
                        Font = Enum.Font.Gotham,
                        ZIndex = 62,
                    })

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
                        tw(panel, {Size = UDim2.new(1, -12, 0, 0)}, 0.14)
                        tw(dArr, {Rotation = 0}, 0.14)
                        if dc.Callback then pcall(dc.Callback, sel) end
                    end)
                end

                local pH = #items * 32 + 12
                dBtn.MouseButton1Click:Connect(function()
                    open = not open
                    tw(panel, {Size = open and UDim2.new(1, -12, 0, pH) or UDim2.new(1, -12, 0, 0)}, 0.16)
                    tw(dArr, {Rotation = open and 180 or 0}, 0.16)
                end)

                local connection
                connection = UIS.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 and open then
                        local mousePos = i.Position
                        local absPos = ddw.AbsolutePosition
                        local absSize = ddw.AbsoluteSize
                        if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y) then
                            open = false
                            tw(panel, {Size = UDim2.new(1, -12, 0, 0)}, 0.14)
                            tw(dArr, {Rotation = 0}, 0.14)
                        end
                    end
                end)

                return {
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
            end

            table.insert(self._elements, secFrame)
            return Sec
        end

        return Tab
    end

    local minimized = false
    local maximized = false
    local origSize = Main.Size
    local origPos = Main.Position

    BtnMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Content.Visible = false
            Sidebar.Visible = false
            tw(Main, {Size = UDim2.new(0, W, 0, 44)}, 0.2)
        else
            local newSize = maximized and UDim2.new(1, -16, 1, -16) or origSize
            tw(Main, {Size = newSize}, 0.2)
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
            tw(Main, {Size = UDim2.new(1, -16, 1, -16), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.2)
            BtnMax.Text = "❐"
        else
            tw(Main, {Size = origSize, Position = origPos}, 0.2)
            BtnMax.Text = "□"
        end
    end)

    BtnClose.MouseButton1Click:Connect(function()
        tw(Main, {Size = UDim2.new(0, W, 0, 0), BackgroundTransparency = 1}, 0.18)
        task.delay(0.2, function()
            sg:Destroy()
            ToggleGui:Destroy()
        end)
    end)

    Main.BackgroundTransparency = 1
    Main.Size = UDim2.new(0, W * 0.9, 0, H * 0.9)
    tw(Main, {Size = UDim2.new(0, W, 0, H), BackgroundTransparency = 0}, 0.3, Enum.EasingStyle.Quint)

    return Window
end

return Phat
