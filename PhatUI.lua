--[[
  ██████╗ ██╗  ██╗ █████╗ ████████╗    ██╗   ██╗██╗
  Phat UI v4.0  ·  Red & Black
  Fixes:
    • Không có subtitle (bỏ hoàn toàn)
    • TopBar full width, nút X không bị cắt
    • Kéo chỉ bằng TopBar
    • Thông báo có đếm ngược + progress bar
    • Màu đỏ đen ngầu
--]]

local Phat = {}
Phat.__index = Phat

local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ─── Palette: Red & Black ─────────────────────
local C = {
    WIN     = Color3.fromRGB(17,  17, 22),
    TOP     = Color3.fromRGB(14,  14, 18),
    SIDE    = Color3.fromRGB(12,  12, 16),
    SEC     = Color3.fromRGB(22,  22, 28),
    ELEM    = Color3.fromRGB(26,  26, 32),
    ELEMH   = Color3.fromRGB(34,  22, 22),

    RED     = Color3.fromRGB(204,  34,  34),
    RED2    = Color3.fromRGB(255,  68,  68),
    DARKRED = Color3.fromRGB(102,  10,  10),

    -- status
    GREEN   = Color3.fromRGB( 34, 204, 100),
    BLUE    = Color3.fromRGB( 51, 153, 255),
    AMBER   = Color3.fromRGB(204, 136,   0),

    -- text
    T1 = Color3.fromRGB(238, 238, 238),
    T2 = Color3.fromRGB(170, 155, 155),
    T3 = Color3.fromRGB( 90,  70,  70),

    -- structure
    DIV  = Color3.fromRGB(30, 20, 20),
    BOR  = Color3.fromRGB(42, 21, 21),
}

-- ─── Helpers ──────────────────────────────────
local function tw(o, p, t, s, d)
    TweenService:Create(o, TweenInfo.new(
        t or .18, s or Enum.EasingStyle.Quart, d or Enum.EasingDirection.Out
    ), p):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke", p)
    s.Color = col or C.BOR; s.Thickness = th or 1
    return s
end

local function pad(p, t, r, b, l)
    local u = Instance.new("UIPadding", p)
    u.PaddingTop    = UDim.new(0, t or 6)
    u.PaddingRight  = UDim.new(0, r or 8)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft   = UDim.new(0, l or 8)
end

local function vlist(p, px)
    local l = Instance.new("UIListLayout", p)
    l.FillDirection = Enum.FillDirection.Vertical
    l.Padding = UDim.new(0, px or 4)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    return l
end

local function hov(b, n, h)
    b.MouseEnter:Connect(function() tw(b, {BackgroundColor3 = h}, .1) end)
    b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = n}, .14) end)
end

local function mkLabel(parent, props)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.RichText = false
    for k, v in pairs(props) do l[k] = v end
    return l
end

-- ─── Custom TopBar drag ───────────────────────
local function attachDrag(Main, TopBar)
    Main.Draggable = false
    local drag, ds, sp = false, nil, nil
    TopBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; ds = i.Position; sp = Main.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            Main.Position = UDim2.new(
                sp.X.Scale, sp.X.Offset + d.X,
                sp.Y.Scale, sp.Y.Offset + d.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)
end

-- ─── Notification system ──────────────────────
-- Duration: số giây hiển thị (default 4)
local _nh  -- holder

local function notify(title, msg, ntype, duration)
    if not _nh then return end
    duration = duration or 4

    local accent = ({
        info    = C.BLUE,
        success = C.GREEN,
        error   = C.RED,
        warn    = C.AMBER,
    })[ntype or "info"] or C.RED

    -- Card
    local card = Instance.new("Frame", _nh)
    card.Size             = UDim2.new(1, 0, 0, 64)
    card.BackgroundColor3 = C.WIN
    card.BorderSizePixel  = 0
    corner(card, 9)
    stroke(card, accent, 1)

    -- left colour strip
    local strip = Instance.new("Frame", card)
    strip.Size             = UDim2.new(0, 3, 1, -14)
    strip.Position         = UDim2.new(0, 0, 0, 7)
    strip.BackgroundColor3 = accent
    strip.BorderSizePixel  = 0
    corner(strip, 2)

    -- type badge
    local badge = Instance.new("TextLabel", card)
    badge.Size             = UDim2.fromOffset(58, 14)
    badge.Position         = UDim2.new(0, 10, 0, 8)
    badge.BackgroundColor3 = accent
    badge.BackgroundTransparency = 0.75
    badge.Text             = string.upper(ntype or "info")
    badge.TextColor3       = accent
    badge.TextSize         = 9
    badge.Font             = Enum.Font.GothamBold
    badge.TextXAlignment   = Enum.TextXAlignment.Center
    badge.BorderSizePixel  = 0
    corner(badge, 3)

    -- countdown label
    local countdown = Instance.new("TextLabel", card)
    countdown.Size             = UDim2.fromOffset(28, 14)
    countdown.Position         = UDim2.new(1, -32, 0, 8)
    countdown.BackgroundTransparency = 1
    countdown.Text             = tostring(duration) .. "s"
    countdown.TextColor3       = C.T3
    countdown.TextSize         = 9
    countdown.Font             = Enum.Font.GothamBold
    countdown.TextXAlignment   = Enum.TextXAlignment.Right

    -- title
    mkLabel(card, {
        Text = title or "",
        Size = UDim2.new(1, -14, 0, 18),
        Position = UDim2.new(0, 10, 0, 24),
        TextColor3 = C.T1, TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- message
    mkLabel(card, {
        Text = msg or "",
        Size = UDim2.new(1, -14, 0, 14),
        Position = UDim2.new(0, 10, 0, 44),
        TextColor3 = C.T2, TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- progress bar track
    local pTrack = Instance.new("Frame", card)
    pTrack.Size             = UDim2.new(1, 0, 0, 2)
    pTrack.Position         = UDim2.new(0, 0, 1, -2)
    pTrack.BackgroundColor3 = C.DIV
    pTrack.BorderSizePixel  = 0

    local pFill = Instance.new("Frame", pTrack)
    pFill.Size             = UDim2.new(1, 0, 1, 0)
    pFill.BackgroundColor3 = accent
    pFill.BorderSizePixel  = 0

    -- slide in
    card.Position = UDim2.new(1.15, 0, 0, 0)
    tw(card, {Position = UDim2.new(0, 0, 0, 0)}, .28, Enum.EasingStyle.Quint)

    -- animate progress bar
    tw(pFill, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear)

    -- countdown tick
    local remaining = duration
    local function tick()
        remaining = remaining - 1
        if countdown and countdown.Parent then
            countdown.Text = math.max(0, remaining) .. "s"
        end
    end
    for i = 1, duration do
        task.delay(i, tick)
    end

    -- auto dismiss
    task.delay(duration, function()
        tw(card, {Position = UDim2.new(1.15, 0, 0, 0)}, .24, Enum.EasingStyle.Quint)
        task.delay(.26, function() card:Destroy() end)
    end)
end

-- ═════════════════════════════════════════════
--  CreateWindow
-- ═════════════════════════════════════════════
function Phat:CreateWindow(cfg)
    cfg = cfg or {}
    local W  = cfg.Width  or 640
    local H  = cfg.Height or 500
    local SW = cfg.SidebarWidth or 160

    local Window = { _tabs = {}, Notify = notify }

    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name = "PhatUI"; sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- notification holder (bottom-right)
    _nh = Instance.new("Frame", sg)
    _nh.Size     = UDim2.fromOffset(280, 360)
    _nh.Position = UDim2.new(1, -294, 1, -376)
    _nh.BackgroundTransparency = 1
    _nh.ClipsDescendants = true
    local nl = vlist(_nh, 7)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- ── Main window ────────────────────────────
    local Main = Instance.new("Frame", sg)
    Main.Name             = "Main"
    Main.Size             = UDim2.fromOffset(W, H)
    Main.Position         = UDim2.fromScale(.5, .5)
    Main.AnchorPoint      = Vector2.new(.5, .5)
    Main.BackgroundColor3 = C.WIN
    Main.ClipsDescendants = true
    corner(Main, 12)
    stroke(Main, C.BOR, 1.5)

    -- ── TopBar ─────────────────────────────────
    -- PENTING: ukuran tepat, ClipsDescendants=false agar tombol tidak terpotong
    local TopBar = Instance.new("Frame", Main)
    TopBar.Name             = "TopBar"
    TopBar.Size             = UDim2.new(1, 0, 0, 48)
    TopBar.Position         = UDim2.new(0, 0, 0, 0)
    TopBar.BackgroundColor3 = C.TOP
    TopBar.BorderSizePixel  = 0
    TopBar.ZIndex           = 5
    TopBar.ClipsDescendants = false

    -- bottom accent line
    local aLine = Instance.new("Frame", TopBar)
    aLine.Size             = UDim2.new(1, 0, 0, 2)
    aLine.Position         = UDim2.new(0, 0, 1, -2)
    aLine.BackgroundColor3 = C.RED
    aLine.BorderSizePixel  = 0
    aLine.ZIndex           = 6
    local ag = Instance.new("UIGradient", aLine)
    ag.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(60,  0,  0)),
        ColorSequenceKeypoint.new(0.3, C.RED),
        ColorSequenceKeypoint.new(0.7, C.RED2),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(60,  0,  0)),
    }

    -- dot logo
    local dot = Instance.new("Frame", TopBar)
    dot.Size             = UDim2.fromOffset(9, 9)
    dot.Position         = UDim2.new(0, 14, .5, -4)
    dot.BackgroundColor3 = C.RED
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 6
    corner(dot, 5)

    -- title only (NO subtitle)
    mkLabel(TopBar, {
        Text  = cfg.Title or "PHAT UI",
        Size  = UDim2.new(1, -130, 1, 0),
        Position = UDim2.new(0, 30, 0, 0),
        TextColor3 = C.T1, TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6,
    })

    -- window control buttons — fixed positions dari kanan
    local function wBtn(xOff, sym, nc, hc, tc)
        local b = Instance.new("TextButton", TopBar)
        b.Size             = UDim2.fromOffset(28, 28)
        b.Position         = UDim2.new(1, xOff, .5, -14)
        b.Text             = sym
        b.TextSize         = 13
        b.Font             = Enum.Font.GothamBold
        b.BackgroundColor3 = nc
        b.TextColor3       = tc or C.T3
        b.BorderSizePixel  = 0
        b.ZIndex           = 10
        b.ClipsDescendants = false
        corner(b, 7)
        hov(b, nc, hc)
        b.MouseEnter:Connect(function() tw(b, {TextColor3 = Color3.new(1,1,1)}, .1) end)
        b.MouseLeave:Connect(function() tw(b, {TextColor3 = tc or C.T3}, .12) end)
        return b
    end

    -- Spacing: Close at -12, Max at -46, Min at -80
    local BClose = wBtn(-12, "✕", Color3.fromRGB(50,14,14), C.RED,   C.RED)
    local BMax   = wBtn(-46, "□", C.ELEM, C.ELEMH, C.T3)
    local BMin   = wBtn(-80, "─", C.ELEM, C.ELEMH, C.T3)

    attachDrag(Main, TopBar)

    -- ── Sidebar ────────────────────────────────
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Name             = "Sidebar"
    Sidebar.Size             = UDim2.new(0, SW, 1, -48)
    Sidebar.Position         = UDim2.new(0, 0, 0, 48)
    Sidebar.BackgroundColor3 = C.SIDE
    Sidebar.BorderSizePixel  = 0

    -- right divider
    local sd = Instance.new("Frame", Sidebar)
    sd.Size = UDim2.new(0, 1, 1, 0); sd.Position = UDim2.new(1, -1, 0, 0)
    sd.BackgroundColor3 = C.DIV; sd.BorderSizePixel = 0

    -- sidebar header
    mkLabel(Sidebar, {
        Text = "NAVIGATE",
        Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 14, 0, 10),
        TextColor3 = Color3.fromRGB(68, 34, 34),
        TextSize = 9, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local tabFrame = Instance.new("Frame", Sidebar)
    tabFrame.Size     = UDim2.new(1, 0, 1, -32)
    tabFrame.Position = UDim2.new(0, 0, 0, 30)
    tabFrame.BackgroundTransparency = 1
    vlist(tabFrame, 3)
    pad(tabFrame, 2, 6, 6, 6)

    -- ── Content ────────────────────────────────
    local Content = Instance.new("ScrollingFrame", Main)
    Content.Name                   = "Content"
    Content.Size                   = UDim2.new(1, -SW, 1, -48)
    Content.Position               = UDim2.new(0, SW, 0, 48)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel        = 0
    Content.ScrollBarThickness     = 3
    Content.ScrollBarImageColor3   = C.RED
    Content.CanvasSize             = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize    = Enum.AutomaticSize.Y
    vlist(Content, 8)
    pad(Content, 10, 10, 10, 10)

    -- ── AddTab ─────────────────────────────────
    local tabIdx = 0

    function Window:AddTab(tabcfg)
        tabcfg = tabcfg or {}
        tabIdx = tabIdx + 1
        local mi = tabIdx
        local Tab = {}

        local TBtn = Instance.new("TextButton", tabFrame)
        TBtn.Name             = "Tab"..mi
        TBtn.Size             = UDim2.new(1, 0, 0, 40)
        TBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        TBtn.BackgroundTransparency = 1
        TBtn.Text             = ""
        TBtn.BorderSizePixel  = 0
        TBtn.LayoutOrder      = mi
        corner(TBtn, 8)

        -- left active bar
        local lBar = Instance.new("Frame", TBtn)
        lBar.Size             = UDim2.new(0, 3, .6, 0)
        lBar.Position         = UDim2.new(0, 0, .2, 0)
        lBar.BackgroundColor3 = C.RED
        lBar.BorderSizePixel  = 0
        lBar.Visible          = false
        corner(lBar, 2)

        -- icon bg
        local icoBG = Instance.new("Frame", TBtn)
        icoBG.Size             = UDim2.fromOffset(26, 26)
        icoBG.Position         = UDim2.new(0, 10, .5, -13)
        icoBG.BackgroundColor3 = C.DARKRED
        icoBG.BackgroundTransparency = 0.5
        icoBG.BorderSizePixel  = 0
        corner(icoBG, 7)

        mkLabel(icoBG, {
            Text = tabcfg.Icon or "●",
            Size = UDim2.new(1, 0, 1, 0),
            TextColor3 = C.T2, TextSize = 13,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Center,
        })

        local tLbl = mkLabel(TBtn, {
            Text = tabcfg.Title or ("Tab "..mi),
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 44, 0, 0),
            TextColor3 = C.T3, TextSize = 12,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local Page = Instance.new("Frame", Content)
        Page.Name           = "Page"..mi
        Page.Size           = UDim2.new(1, 0, 0, 0)
        Page.AutomaticSize  = Enum.AutomaticSize.Y
        Page.BackgroundTransparency = 1
        Page.Visible        = false
        Page.LayoutOrder    = mi
        vlist(Page, 8)

        local function activate()
            for _, t in ipairs(Window._tabs) do
                t._page.Visible = false
                tw(t._btn, {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 1}, .14)
                t._lbar.Visible = false
                tw(t._lbl, {TextColor3 = C.T3}, .14)
            end
            Page.Visible = true
            tw(TBtn, {BackgroundColor3 = C.ELEMH, BackgroundTransparency = 0}, .14)
            lBar.Visible = true
            tw(tLbl, {TextColor3 = C.RED2}, .14)
        end

        Tab._page = Page; Tab._btn = TBtn; Tab._lbar = lBar; Tab._lbl = tLbl
        TBtn.MouseButton1Click:Connect(activate)
        TBtn.MouseEnter:Connect(function()
            if not Page.Visible then
                tw(TBtn, {BackgroundColor3 = Color3.fromRGB(28,14,14), BackgroundTransparency = 0}, .1)
            end
        end)
        TBtn.MouseLeave:Connect(function()
            if not Page.Visible then
                tw(TBtn, {BackgroundTransparency = 1}, .14)
            end
        end)
        if tabIdx == 1 then task.defer(activate) end
        table.insert(Window._tabs, Tab)

        -- ── AddSection ─────────────────────────
        local secIdx = 0
        function Tab:AddSection(title)
            secIdx = secIdx + 1
            local Sec = {}

            local SF = Instance.new("Frame", Page)
            SF.Name             = "Sec"..secIdx
            SF.Size             = UDim2.new(1, 0, 0, 0)
            SF.AutomaticSize    = Enum.AutomaticSize.Y
            SF.BackgroundColor3 = C.SEC
            SF.BorderSizePixel  = 0
            SF.LayoutOrder      = secIdx
            corner(SF, 10)
            stroke(SF, C.BOR, 1)

            -- top accent line
            local tl = Instance.new("Frame", SF)
            tl.Size             = UDim2.new(1, 0, 0, 1)
            tl.BackgroundColor3 = C.RED
            tl.BorderSizePixel  = 0
            local tlg = Instance.new("UIGradient", tl)
            tlg.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, C.DARKRED),
                ColorSequenceKeypoint.new(.5, C.RED),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0)),
            }

            -- header
            local hRow = Instance.new("Frame", SF)
            hRow.Size             = UDim2.new(1, 0, 0, 34)
            hRow.BackgroundTransparency = 1

            local sdot = Instance.new("Frame", hRow)
            sdot.Size             = UDim2.fromOffset(6, 6)
            sdot.Position         = UDim2.new(0, 13, .5, -3)
            sdot.BackgroundColor3 = C.RED
            sdot.BorderSizePixel  = 0
            corner(sdot, 3)

            mkLabel(hRow, {
                Text = title or "Section",
                Size = UDim2.new(1, -30, 1, 0),
                Position = UDim2.new(0, 26, 0, 0),
                TextColor3 = C.T2, TextSize = 11,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
            })

            -- divider
            local div = Instance.new("Frame", SF)
            div.Size             = UDim2.new(1, -18, 0, 1)
            div.Position         = UDim2.new(0, 9, 0, 34)
            div.BackgroundColor3 = C.DIV
            div.BorderSizePixel  = 0

            local inner = Instance.new("Frame", SF)
            inner.Size          = UDim2.new(1, 0, 0, 0)
            inner.AutomaticSize = Enum.AutomaticSize.Y
            inner.BackgroundTransparency = 1
            pad(inner, 40, 10, 10, 10)
            vlist(inner, 5)

            local ei = 0

            -- ── AddButton ──────────────────────
            function Sec:AddButton(bc)
                bc = bc or {}; ei = ei + 1
                local row = Instance.new("Frame", inner)
                row.Size = UDim2.new(1, 0, 0, 36)
                row.BackgroundTransparency = 1
                row.LayoutOrder = ei

                local Btn = Instance.new("TextButton", row)
                Btn.Size             = UDim2.new(1, 0, 1, 0)
                Btn.BackgroundColor3 = C.ELEM
                Btn.Text             = ""
                Btn.BorderSizePixel  = 0
                corner(Btn, 7)
                stroke(Btn, C.BOR, 1)

                local lstrip = Instance.new("Frame", Btn)
                lstrip.Size             = UDim2.new(0, 2, .5, 0)
                lstrip.Position         = UDim2.new(0, 0, .25, 0)
                lstrip.BackgroundColor3 = C.DARKRED
                lstrip.BorderSizePixel  = 0
                corner(lstrip, 1)

                mkLabel(Btn, {
                    Text = bc.Title or "Button",
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextColor3 = C.T1, TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local arr = mkLabel(Btn, {
                    Text = "›", Size = UDim2.new(0, 20, 1, 0),
                    Position = UDim2.new(1, -22, 0, 0),
                    TextColor3 = C.T3, TextSize = 17,
                    Font = Enum.Font.GothamBold,
                })

                hov(Btn, C.ELEM, C.ELEMH)
                Btn.MouseEnter:Connect(function() tw(arr, {TextColor3 = C.RED2}, .1) end)
                Btn.MouseLeave:Connect(function() tw(arr, {TextColor3 = C.T3}, .12) end)
                Btn.MouseButton1Click:Connect(function()
                    tw(Btn, {BackgroundColor3 = C.DARKRED}, .06)
                    task.delay(.08, function() tw(Btn, {BackgroundColor3 = C.ELEM}, .2) end)
                    if bc.Callback then pcall(bc.Callback) end
                end)
            end

            -- ── AddToggle ──────────────────────
            function Sec:AddToggle(tc)
                tc = tc or {}; ei = ei + 1
                local state = tc.Default or false

                local Row = Instance.new("Frame", inner)
                Row.Size             = UDim2.new(1, 0, 0, 36)
                Row.BackgroundColor3 = C.ELEM
                Row.BorderSizePixel  = 0
                Row.LayoutOrder      = ei
                corner(Row, 7)
                stroke(Row, C.BOR, 1)

                mkLabel(Row, {
                    Text = tc.Title or "Toggle",
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    TextColor3 = C.T1, TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })

                local sLbl = mkLabel(Row, {
                    Text = state and "ON" or "OFF",
                    Size = UDim2.fromOffset(28, 36),
                    Position = UDim2.new(1, -84, 0, 0),
                    TextColor3 = state and C.RED2 or C.T3,
                    TextSize = 10, Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Center,
                })

                local track = Instance.new("Frame", Row)
                track.Size             = UDim2.fromOffset(40, 20)
                track.Position         = UDim2.new(1, -50, .5, -10)
                track.BackgroundColor3 = state and C.DARKRED or C.DIV
                track.BorderSizePixel  = 0
                corner(track, 10)
                local tStr = stroke(track, state and C.RED or C.BOR, 1)

                local knob = Instance.new("Frame", track)
                knob.Size             = UDim2.fromOffset(14, 14)
                knob.Position         = state and UDim2.new(1, -17, .5, -7) or UDim2.new(0, 3, .5, -7)
                knob.BackgroundColor3 = state and C.RED2 or C.T3
                knob.BorderSizePixel  = 0
                corner(knob, 7)

                local function set(v)
                    state = v
                    if v then
                        tw(track, {BackgroundColor3 = C.DARKRED}, .18)
                        tw(knob,  {Position = UDim2.new(1,-17,.5,-7), BackgroundColor3 = C.RED2}, .2)
                        tStr.Color = C.RED
                        sLbl.Text = "ON"; tw(sLbl, {TextColor3 = C.RED2}, .12)
                    else
                        tw(track, {BackgroundColor3 = C.DIV}, .18)
                        tw(knob,  {Position = UDim2.new(0,3,.5,-7), BackgroundColor3 = C.T3}, .2)
                        tStr.Color = C.BOR
                        sLbl.Text = "OFF"; tw(sLbl, {TextColor3 = C.T3}, .12)
                    end
                    if tc.Callback then pcall(tc.Callback, state) end
                end

                Row.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then set(not state) end
                end)
                hov(Row, C.ELEM, C.ELEMH)
                return { Set = set, Get = function() return state end }
            end

            -- ── AddSlider ──────────────────────
            function Sec:AddSlider(sc)
                sc = sc or {}; ei = ei + 1
                local mn, mx = sc.Min or 0, sc.Max or 100
                local val    = sc.Default or mn

                local SF2 = Instance.new("Frame", inner)
                SF2.Size             = UDim2.new(1, 0, 0, 52)
                SF2.BackgroundColor3 = C.ELEM
                SF2.BorderSizePixel  = 0
                SF2.LayoutOrder      = ei
                corner(SF2, 7)
                stroke(SF2, C.BOR, 1)

                mkLabel(SF2, {
                    Text = sc.Title or "Slider",
                    Size = UDim2.new(1,-58,0,18),
                    Position = UDim2.new(0,12,0,8),
                    TextColor3 = C.T1, TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                local vLbl = mkLabel(SF2, {
                    Text = tostring(math.round(val)),
                    Size = UDim2.new(0,46,0,18),
                    Position = UDim2.new(1,-56,0,8),
                    TextColor3 = C.RED2, TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                })

                local tBG = Instance.new("Frame", SF2)
                tBG.Size             = UDim2.new(1,-24,0,4)
                tBG.Position         = UDim2.new(0,12,1,-14)
                tBG.BackgroundColor3 = C.DIV
                tBG.BorderSizePixel  = 0
                corner(tBG, 2)

                local pct0 = (val-mn)/(mx-mn)
                local fillF = Instance.new("Frame", tBG)
                fillF.Size             = UDim2.new(pct0,0,1,0)
                fillF.BackgroundColor3 = C.RED
                fillF.BorderSizePixel  = 0
                corner(fillF, 2)

                local handleF = Instance.new("Frame", tBG)
                handleF.Size             = UDim2.fromOffset(12,12)
                handleF.Position         = UDim2.new(pct0,-6,.5,-6)
                handleF.BackgroundColor3 = C.RED2
                handleF.BorderSizePixel  = 0
                corner(handleF, 6)

                local dragging = false
                local function upd(x)
                    local p = math.clamp((x-tBG.AbsolutePosition.X)/tBG.AbsoluteSize.X,0,1)
                    val = math.round(mn+(mx-mn)*p)
                    fillF.Size   = UDim2.new(p,0,1,0)
                    handleF.Position = UDim2.new(p,-6,.5,-6)
                    vLbl.Text = tostring(val)
                    if sc.Callback then pcall(sc.Callback,val) end
                end
                tBG.InputBegan:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; upd(i.Position.X) end
                end)
                UIS.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i.Position.X) end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
                end)
                return {
                    Get = function() return val end,
                    Set = function(v)
                        v = math.clamp(v,mn,mx); val=v
                        local p=(v-mn)/(mx-mn)
                        tw(fillF,   {Size=UDim2.new(p,0,1,0)}, .12)
                        tw(handleF, {Position=UDim2.new(p,-6,.5,-6)}, .12)
                        vLbl.Text = tostring(math.round(v))
                    end,
                }
            end

            -- ── AddInput ───────────────────────
            function Sec:AddInput(ic)
                ic = ic or {}; ei = ei + 1
                local wrap = Instance.new("Frame", inner)
                wrap.Size = UDim2.new(1,0,0,56)
                wrap.BackgroundTransparency = 1
                wrap.LayoutOrder = ei

                mkLabel(wrap, {
                    Text = ic.Title or "Input",
                    Size = UDim2.new(1,0,0,16),
                    TextColor3 = C.T3, TextSize = 10,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                local bg = Instance.new("Frame", wrap)
                bg.Size             = UDim2.new(1,0,0,34)
                bg.Position         = UDim2.new(0,0,0,20)
                bg.BackgroundColor3 = C.ELEM
                bg.BorderSizePixel  = 0
                corner(bg, 7)
                local iStr = stroke(bg, C.BOR, 1)

                local tb = Instance.new("TextBox", bg)
                tb.Size   = UDim2.new(1,-16,1,0)
                tb.Position = UDim2.new(0,10,0,0)
                tb.BackgroundTransparency = 1
                tb.Text   = ic.Default or ""
                tb.PlaceholderText = ic.Placeholder or "Type here..."
                tb.TextColor3 = C.T1; tb.PlaceholderColor3 = C.T3
                tb.TextSize = 12; tb.Font = Enum.Font.Gotham
                tb.TextXAlignment = Enum.TextXAlignment.Left
                tb.ClearTextOnFocus = ic.ClearOnFocus ~= false
                tb.Focused:Connect(function() iStr.Color = C.RED end)
                tb.FocusLost:Connect(function(enter)
                    iStr.Color = C.BOR
                    if ic.Callback then pcall(ic.Callback, tb.Text, enter) end
                end)
                return { Get = function() return tb.Text end }
            end

            -- ── AddDropdown ────────────────────
            function Sec:AddDropdown(dc)
                dc = dc or {}; ei = ei + 1
                local sel, open = dc.Default, false

                local DDW = Instance.new("Frame", inner)
                DDW.Size = UDim2.new(1,0,0,36)
                DDW.BackgroundTransparency = 1
                DDW.LayoutOrder = ei
                DDW.ClipsDescendants = false
                DDW.ZIndex = 20

                local DBt = Instance.new("TextButton", DDW)
                DBt.Size             = UDim2.new(1,0,1,0)
                DBt.BackgroundColor3 = C.ELEM
                DBt.Text             = ""
                DBt.BorderSizePixel  = 0
                DBt.ZIndex           = 20
                corner(DBt, 7); stroke(DBt, C.BOR, 1)

                local dLbl = mkLabel(DBt, {
                    Text = sel or dc.Title or "Select...",
                    Size = UDim2.new(1,-36,1,0), Position = UDim2.new(0,12,0,0),
                    TextColor3 = sel and C.T1 or C.T3, TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 21,
                })
                local dArr = mkLabel(DBt, {
                    Text = "⌄", Size = UDim2.new(0,22,1,0),
                    Position = UDim2.new(1,-24,0,0),
                    TextColor3 = C.T3, TextSize = 13,
                    Font = Enum.Font.GothamBold, ZIndex = 21,
                })

                local panel = Instance.new("Frame", DDW)
                panel.Size             = UDim2.new(1,0,0,0)
                panel.Position         = UDim2.new(0,0,1,4)
                panel.BackgroundColor3 = C.SEC
                panel.BorderSizePixel  = 0
                panel.ClipsDescendants = true
                panel.ZIndex           = 60
                corner(panel, 7); stroke(panel, C.RED, 1)

                vlist(panel, 2); pad(panel,4,4,4,4)

                local items = dc.Items or {}
                for _, item in ipairs(items) do
                    local opt = Instance.new("TextButton", panel)
                    opt.Size             = UDim2.new(1,0,0,28)
                    opt.Text             = item
                    opt.BackgroundColor3 = C.ELEM
                    opt.TextColor3       = C.T1
                    opt.TextSize         = 12
                    opt.Font             = Enum.Font.Gotham
                    opt.BorderSizePixel  = 0
                    opt.ZIndex           = 61
                    corner(opt, 5)
                    hov(opt, C.ELEM, C.ELEMH)
                    opt.MouseButton1Click:Connect(function()
                        sel = item; dLbl.Text = item; dLbl.TextColor3 = C.T1
                        open = false
                        tw(panel, {Size = UDim2.new(1,0,0,0)}, .15)
                        tw(dArr,  {Rotation = 0}, .15)
                        if dc.Callback then pcall(dc.Callback, sel) end
                    end)
                end

                local pH = #items * 32 + 8
                DBt.MouseButton1Click:Connect(function()
                    open = not open
                    tw(panel, {Size = open and UDim2.new(1,0,0,pH) or UDim2.new(1,0,0,0)}, .18, Enum.EasingStyle.Quart)
                    tw(dArr,  {Rotation = open and 180 or 0}, .18)
                end)

                return {
                    Get = function() return sel end,
                    Set = function(v) sel=v; dLbl.Text=v; dLbl.TextColor3=C.T1 end,
                }
            end

            return Sec
        end -- AddSection
        return Tab
    end -- AddTab

    -- ── Window controls ────────────────────────
    local minimized = false; local maximized = false
    local sSize = UDim2.fromOffset(W,H); local sPos = Main.Position

    BMin.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Content.Visible = false; Sidebar.Visible = false
            tw(Main, {Size = UDim2.fromOffset(W, 48)}, .22, Enum.EasingStyle.Quart)
        else
            tw(Main, {Size = maximized and UDim2.fromScale(1,1) or sSize}, .22, Enum.EasingStyle.Quart)
            task.delay(.12, function() Content.Visible=true; Sidebar.Visible=true end)
        end
    end)

    BMax.MouseButton1Click:Connect(function()
        if minimized then return end
        maximized = not maximized
        if maximized then
            sSize = Main.Size; sPos = Main.Position
            tw(Main, {Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(.5,.5)}, .22, Enum.EasingStyle.Quart)
            BMax.Text = "❐"
        else
            tw(Main, {Size = sSize, Position = sPos}, .22, Enum.EasingStyle.Quart)
            BMax.Text = "□"
        end
    end)

    BClose.MouseButton1Click:Connect(function()
        tw(Main, {Size = UDim2.fromOffset(W,0), BackgroundTransparency=1}, .2, Enum.EasingStyle.Quart)
        task.delay(.22, function() sg:Destroy() end)
    end)

    -- Entry animation
    Main.BackgroundTransparency = 1
    Main.Size = UDim2.fromOffset(W*.86, H*.86)
    tw(Main, {Size = UDim2.fromOffset(W,H), BackgroundTransparency=0}, .3, Enum.EasingStyle.Quint)

    return Window
end

return Phat

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  USAGE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local UI = loadstring(game:HttpGet("URL"))()

local win = UI:CreateWindow({
    Title  = "PHAT UI",   -- Chỉ title, không subtitle
    Width  = 640,
    Height = 500,
})

local t1 = win:AddTab({ Title = "Combat",   Icon = "⚔" })
local t2 = win:AddTab({ Title = "Player",   Icon = "👤" })
local t3 = win:AddTab({ Title = "Settings", Icon = "⚙" })

local s1 = t1:AddSection("General")

s1:AddButton({
    Title    = "Kill Aura",
    Callback = function()
        win:Notify("Kill Aura", "Đã kích hoạt", "success", 4)
    end,
})

s1:AddToggle({
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v)
        win:Notify("Infinite Jump", v and "Bật" or "Tắt",
                   v and "success" or "warn", 3)
    end,
})

s1:AddSlider({
    Title = "Walk Speed", Min = 16, Max = 150, Default = 16,
    Callback = function(v)
        local c = game.Players.LocalPlayer.Character
        if c then c.Humanoid.WalkSpeed = v end
    end,
})

s1:AddDropdown({
    Title = "Target", Items = {"Nearest","Lowest HP","Random"},
    Callback = function(v) print(v) end,
})

-- Notify(title, message, type, duration_seconds)
-- type: "info" | "success" | "error" | "warn"
win:Notify("Loaded", "PhatUI v4.0 sẵn sàng", "info", 5)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]
