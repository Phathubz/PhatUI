--[[
  ██████╗ ██╗  ██╗ █████╗ ████████╗    ██╗   ██╗██╗
  ██╔══██╗██║  ██║██╔══██╗╚══██╔══╝    ██║   ██║██║
  ██████╔╝███████║███████║   ██║       ██║   ██║██║
  ██╔═══╝ ██╔══██║██╔══██║   ██║       ██║   ██║██║
  ██║     ██║  ██║██║  ██║   ██║       ╚██████╔╝██║
  ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝ ╚═╝

  Phat UI v2.1  ·  Glass Edition
  • Trong suốt / glass morphism
  • Chữ rõ, tab nổi bật
  • Kéo cửa sổ chỉ bằng TopBar (không bị drag lung tung)
  • Nút: Thu nhỏ / Phóng to / Đóng
  • Thông báo đủ màu, chữ đọc được
--]]

local Phat = {}
Phat.__index = Phat

-- ─── Services ─────────────────────────────────
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ─── Theme ────────────────────────────────────
local T = {
    -- glass backgrounds (semi-transparent)
    BG_WIN     = Color3.fromRGB(15, 17, 26),       -- cửa sổ chính
    BG_TOP     = Color3.fromRGB(20, 22, 34),       -- topbar
    BG_SIDE    = Color3.fromRGB(17, 19, 30),       -- sidebar
    BG_SECTION = Color3.fromRGB(25, 28, 42),       -- section
    BG_ELEM    = Color3.fromRGB(30, 34, 52),       -- button/toggle row
    BG_HOVER   = Color3.fromRGB(42, 47, 70),       -- hover state
    BG_NOTIF   = Color3.fromRGB(22, 25, 38),       -- notification card

    -- accents
    CYAN       = Color3.fromRGB(60, 200, 255),
    CYAN_DIM   = Color3.fromRGB(30, 130, 175),
    MAGENTA    = Color3.fromRGB(210, 60, 255),
    GREEN      = Color3.fromRGB(50, 220, 140),
    RED        = Color3.fromRGB(255, 70, 90),
    AMBER      = Color3.fromRGB(255, 190, 40),

    -- text — sáng hơn nhiều so với v2.0
    TEXT1      = Color3.fromRGB(235, 240, 255),    -- primary: gần trắng
    TEXT2      = Color3.fromRGB(170, 185, 220),    -- secondary: xanh nhạt
    TEXT3      = Color3.fromRGB(100, 115, 155),    -- muted

    -- borders
    BORDER     = Color3.fromRGB(55, 62, 95),
    DIVIDER    = Color3.fromRGB(40, 46, 72),
}

-- transparencies
local TR = {
    WIN   = 0.10,   -- cửa sổ chính
    TOP   = 0.12,
    SIDE  = 0.14,
    SEC   = 0.08,
    ELEM  = 0.05,
}

-- ─── Helpers ──────────────────────────────────
local function tw(obj, props, t, sty, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18, sty or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props):Play()
end

local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
end

local function stroke(p, col, thick, trans)
    local s = Instance.new("UIStroke", p)
    s.Color = col or T.BORDER
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    return s
end

local function pad(p, t, r, b, l)
    local u = Instance.new("UIPadding", p)
    u.PaddingTop    = UDim.new(0, t or 6)
    u.PaddingRight  = UDim.new(0, r or 8)
    u.PaddingBottom = UDim.new(0, b or 6)
    u.PaddingLeft   = UDim.new(0, l or 8)
end

local function list(p, fill, px, ha, va)
    local l = Instance.new("UIListLayout", p)
    l.FillDirection       = fill or Enum.FillDirection.Vertical
    l.Padding             = UDim.new(0, px or 4)
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment = ha   or Enum.HorizontalAlignment.Left
    l.VerticalAlignment   = va   or Enum.VerticalAlignment.Top
    return l
end

local function lbl(parent, text, size, font, color, xa)
    local l = Instance.new("TextLabel", parent)
    l.BackgroundTransparency = 1
    l.Text      = text  or ""
    l.TextSize  = size  or 13
    l.Font      = font  or Enum.Font.Gotham
    l.TextColor3 = color or T.TEXT1
    l.TextXAlignment = xa or Enum.TextXAlignment.Left
    l.Size = UDim2.new(1, 0, 1, 0)
    return l
end

local function hoverFX(btn, norm, hot)
    btn.MouseEnter:Connect(function() tw(btn, {BackgroundColor3 = hot},  0.12) end)
    btn.MouseLeave:Connect(function() tw(btn, {BackgroundColor3 = norm}, 0.15) end)
end

-- ─── Custom drag (chỉ TopBar mới kéo được) ────
local function attachDrag(Main, TopBar)
    -- Tắt Draggable mặc định — tự viết drag
    Main.Draggable = false

    local dragging = false
    local dragStart, startPos

    TopBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = inp.Position
            startPos  = Main.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService = UIS
    UIS.InputChanged:Connect(function(inp)
        if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- ─── Notification holder (module-level) ───────
local NotifHolder

local function notify(title, message, ntype)
    if not NotifHolder then return end

    local accent = ({
        info    = T.CYAN,
        success = T.GREEN,
        error   = T.RED,
        warn    = T.AMBER,
    })[ntype or "info"] or T.CYAN

    local card = Instance.new("Frame", NotifHolder)
    card.Size              = UDim2.new(1, 0, 0, 62)
    card.BackgroundColor3  = T.BG_NOTIF
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel   = 0
    corner(card, 9)
    stroke(card, accent, 1, 0.25)

    -- left color bar
    local bar = Instance.new("Frame", card)
    bar.Size             = UDim2.new(0, 3, 1, -14)
    bar.Position         = UDim2.new(0, 0, 0, 7)
    bar.BackgroundColor3 = accent
    bar.BorderSizePixel  = 0
    corner(bar, 2)

    -- type tag
    local tag = Instance.new("TextLabel", card)
    tag.Size     = UDim2.new(0, 60, 0, 16)
    tag.Position = UDim2.new(0, 12, 0, 8)
    tag.BackgroundTransparency = 1
    tag.Text      = string.upper(ntype or "INFO")
    tag.TextColor3 = accent
    tag.TextSize   = 10
    tag.Font       = Enum.Font.GothamBold
    tag.TextXAlignment = Enum.TextXAlignment.Left

    -- title
    local t1 = Instance.new("TextLabel", card)
    t1.Size     = UDim2.new(1, -18, 0, 18)
    t1.Position = UDim2.new(0, 12, 0, 22)
    t1.BackgroundTransparency = 1
    t1.Text      = title or ""
    t1.TextColor3 = T.TEXT1          -- gần trắng, đọc rõ
    t1.TextSize   = 13
    t1.Font       = Enum.Font.GothamBold
    t1.TextXAlignment = Enum.TextXAlignment.Left

    -- message
    local t2 = Instance.new("TextLabel", card)
    t2.Size     = UDim2.new(1, -18, 0, 14)
    t2.Position = UDim2.new(0, 12, 0, 42)
    t2.BackgroundTransparency = 1
    t2.Text      = message or ""
    t2.TextColor3 = T.TEXT2          -- xanh nhạt, đủ sáng
    t2.TextSize   = 11
    t2.Font       = Enum.Font.Gotham
    t2.TextXAlignment = Enum.TextXAlignment.Left

    -- slide in từ phải
    card.Position = UDim2.new(1.2, 0, 0, 0)
    tw(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    task.delay(4, function()
        tw(card, {Position = UDim2.new(1.2, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
        task.delay(0.28, function() card:Destroy() end)
    end)
end

-- ─────────────────────────────────────────────
--  CreateWindow
-- ─────────────────────────────────────────────
function Phat:CreateWindow(cfg)
    cfg = cfg or {}
    local W       = cfg.Width        or 620
    local H       = cfg.Height       or 480
    local SIDE_W  = cfg.SidebarWidth or 158

    local Window = { _tabs = {}, Notify = notify }

    -- ScreenGui
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name           = "PhatUI"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Notification area (kéo ra màn hình rộng hơn)
    NotifHolder = Instance.new("Frame", sg)
    NotifHolder.Name   = "NotifHolder"
    NotifHolder.Size   = UDim2.fromOffset(280, 340)
    NotifHolder.Position = UDim2.new(1, -296, 1, -352)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.ClipsDescendants = true
    local nl = list(NotifHolder, Enum.FillDirection.Vertical, 7)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- ── Main window ────────────────────────────
    local Main = Instance.new("Frame", sg)
    Main.Name              = "Main"
    Main.Size              = UDim2.fromOffset(W, H)
    Main.Position          = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint       = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3  = T.BG_WIN
    Main.BackgroundTransparency = TR.WIN
    Main.ClipsDescendants  = true
    corner(Main, 12)
    stroke(Main, T.BORDER, 1, 0.1)

    -- ── TopBar ─────────────────────────────────
    local TopBar = Instance.new("Frame", Main)
    TopBar.Name             = "TopBar"
    TopBar.Size             = UDim2.new(1, 0, 0, 46)
    TopBar.BackgroundColor3 = T.BG_TOP
    TopBar.BackgroundTransparency = TR.TOP
    TopBar.BorderSizePixel  = 0
    TopBar.ZIndex           = 5

    -- accent gradient line dưới topbar
    local aLine = Instance.new("Frame", TopBar)
    aLine.Size             = UDim2.new(1, 0, 0, 2)
    aLine.Position         = UDim2.new(0, 0, 1, -2)
    aLine.BackgroundColor3 = T.CYAN
    aLine.BorderSizePixel  = 0
    aLine.ZIndex           = 6
    local aGrad = Instance.new("UIGradient", aLine)
    aGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   T.CYAN),
        ColorSequenceKeypoint.new(0.5, T.MAGENTA),
        ColorSequenceKeypoint.new(1,   T.CYAN),
    }

    -- dot logo
    local dot = Instance.new("Frame", TopBar)
    dot.Size             = UDim2.fromOffset(8, 8)
    dot.Position         = UDim2.new(0, 14, 0.5, -4)
    dot.BackgroundColor3 = T.CYAN
    dot.BorderSizePixel  = 0
    dot.ZIndex           = 6
    corner(dot, 4)

    -- title
    local titleL = Instance.new("TextLabel", TopBar)
    titleL.Text     = cfg.Title or "PHAT UI"
    titleL.Size     = UDim2.new(0, 260, 1, -4)
    titleL.Position = UDim2.new(0, 28, 0, 2)
    titleL.BackgroundTransparency = 1
    titleL.TextColor3 = T.TEXT1          -- gần trắng
    titleL.TextSize   = 15
    titleL.Font       = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.ZIndex     = 6

    if cfg.Subtitle then
        local subL = Instance.new("TextLabel", TopBar)
        subL.Text   = cfg.Subtitle
        subL.Size   = UDim2.new(0, 200, 0, 14)
        subL.Position = UDim2.new(0, 28, 1, -18)
        subL.BackgroundTransparency = 1
        subL.TextColor3 = T.CYAN_DIM
        subL.TextSize   = 10
        subL.Font       = Enum.Font.Gotham
        subL.TextXAlignment = Enum.TextXAlignment.Left
        subL.ZIndex = 6
    end

    -- ── Window control buttons ──────────────────
    -- Đóng / Phóng to / Thu nhỏ
    local function winBtn(xOff, sym, normC, hotC, textC)
        local b = Instance.new("TextButton", TopBar)
        b.Size             = UDim2.fromOffset(28, 28)
        b.Position         = UDim2.new(1, xOff, 0.5, -14)
        b.Text             = sym
        b.TextSize         = 13
        b.Font             = Enum.Font.GothamBold
        b.BackgroundColor3 = normC
        b.TextColor3       = textC or T.TEXT2
        b.BorderSizePixel  = 0
        b.ZIndex           = 10
        corner(b, 7)
        hoverFX(b, normC, hotC)
        b.MouseEnter:Connect(function() tw(b, {TextColor3 = T.TEXT1}, 0.1) end)
        b.MouseLeave:Connect(function() tw(b, {TextColor3 = textC or T.TEXT2}, 0.1) end)
        return b
    end

    local CloseBtn = winBtn(-12,  "✕", Color3.fromRGB(55,28,30), T.RED,    T.RED)
    local MaxBtn   = winBtn(-46,  "□", T.BG_ELEM,                T.BG_HOVER, T.TEXT2)
    local MinBtn   = winBtn(-80,  "─", T.BG_ELEM,                T.BG_HOVER, T.TEXT2)

    -- Gắn drag chỉ vào TopBar
    attachDrag(Main, TopBar)

    -- ── Sidebar ────────────────────────────────
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Name             = "Sidebar"
    Sidebar.Size             = UDim2.new(0, SIDE_W, 1, -46)
    Sidebar.Position         = UDim2.new(0, 0, 0, 46)
    Sidebar.BackgroundColor3 = T.BG_SIDE
    Sidebar.BackgroundTransparency = TR.SIDE
    Sidebar.BorderSizePixel  = 0

    -- divider sidebar | content
    local sDiv = Instance.new("Frame", Sidebar)
    sDiv.Size             = UDim2.new(0, 1, 1, 0)
    sDiv.Position         = UDim2.new(1, -1, 0, 0)
    sDiv.BackgroundColor3 = T.DIVIDER
    sDiv.BorderSizePixel  = 0

    list(Sidebar, Enum.FillDirection.Vertical, 3, Enum.HorizontalAlignment.Center)
    pad(Sidebar, 8, 0, 8, 0)

    -- ── Content area ───────────────────────────
    local Content = Instance.new("ScrollingFrame", Main)
    Content.Name                   = "Content"
    Content.Size                   = UDim2.new(1, -SIDE_W, 1, -46)
    Content.Position               = UDim2.new(0, SIDE_W, 0, 46)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel        = 0
    Content.ScrollBarThickness     = 3
    Content.ScrollBarImageColor3   = T.CYAN_DIM
    Content.CanvasSize             = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize    = Enum.AutomaticSize.Y

    list(Content, Enum.FillDirection.Vertical, 8)
    pad(Content, 10, 10, 10, 10)

    -- ── AddTab ─────────────────────────────────
    local tabIdx = 0

    function Window:AddTab(tabcfg)
        tabcfg = tabcfg or {}
        tabIdx = tabIdx + 1
        local myIdx = tabIdx
        local Tab   = {}

        -- sidebar button
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Name             = "Tab"..myIdx
        TabBtn.Size             = UDim2.new(1, -10, 0, 38)
        TabBtn.BackgroundColor3 = T.BG_ELEM
        TabBtn.BackgroundTransparency = 0.1
        TabBtn.Text             = ""
        TabBtn.BorderSizePixel  = 0
        TabBtn.LayoutOrder      = myIdx
        corner(TabBtn, 8)

        -- inner row (icon + label)
        local inner = Instance.new("Frame", TabBtn)
        inner.Size = UDim2.new(1, 0, 1, 0)
        inner.BackgroundTransparency = 1
        local il = list(inner, Enum.FillDirection.Horizontal, 7,
            Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
        pad(inner, 0, 6, 0, 10)

        if tabcfg.Icon then
            local ico = Instance.new("TextLabel", inner)
            ico.Text  = tabcfg.Icon
            ico.Size  = UDim2.fromOffset(18, 38)
            ico.BackgroundTransparency = 1
            ico.TextColor3 = T.TEXT2
            ico.TextSize   = 15
            ico.Font       = Enum.Font.GothamBold
            ico.Name       = "Icon"
        end

        local tabLbl = Instance.new("TextLabel", inner)
        tabLbl.Name  = "Label"
        tabLbl.Text  = tabcfg.Title or ("Tab "..myIdx)
        tabLbl.Size  = UDim2.new(1, 0, 1, 0)
        tabLbl.BackgroundTransparency = 1
        tabLbl.TextColor3 = T.TEXT2       -- mặc định: xanh nhạt, đọc rõ
        tabLbl.TextSize   = 13
        tabLbl.Font       = Enum.Font.GothamBold
        tabLbl.TextXAlignment = Enum.TextXAlignment.Left

        -- active bar (cạnh phải)
        local aBar = Instance.new("Frame", TabBtn)
        aBar.Size             = UDim2.new(0, 3, 0.55, 0)
        aBar.Position         = UDim2.new(1, -3, 0.225, 0)
        aBar.BackgroundColor3 = T.CYAN
        aBar.BorderSizePixel  = 0
        aBar.Visible          = false
        corner(aBar, 2)

        -- Page
        local Page = Instance.new("Frame", Content)
        Page.Name              = "Page"..myIdx
        Page.Size              = UDim2.new(1, 0, 0, 0)
        Page.AutomaticSize     = Enum.AutomaticSize.Y
        Page.BackgroundTransparency = 1
        Page.Visible           = false
        Page.LayoutOrder       = myIdx
        list(Page, Enum.FillDirection.Vertical, 8)

        local function activate()
            for _, t in ipairs(Window._tabs) do
                t._page.Visible = false
                tw(t._btn, {BackgroundColor3 = T.BG_ELEM}, 0.14)
                t._abar.Visible = false
                tw(t._lbl, {TextColor3 = T.TEXT2}, 0.14)
            end
            Page.Visible = true
            tw(TabBtn, {BackgroundColor3 = Color3.fromRGB(35, 40, 65)}, 0.14)
            aBar.Visible = true
            tw(tabLbl, {TextColor3 = T.CYAN}, 0.14)  -- aktif: cyan neon, rất dễ thấy
        end

        Tab._page = Page; Tab._btn = TabBtn; Tab._abar = aBar; Tab._lbl = tabLbl
        TabBtn.MouseButton1Click:Connect(activate)
        hoverFX(TabBtn, T.BG_ELEM, T.BG_HOVER)
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
            SF.BackgroundColor3 = T.BG_SECTION
            SF.BackgroundTransparency = TR.SEC
            SF.BorderSizePixel  = 0
            SF.LayoutOrder      = secIdx
            corner(SF, 10)
            stroke(SF, T.BORDER, 1, 0.25)

            -- left accent strip
            local strip = Instance.new("Frame", SF)
            strip.Size             = UDim2.new(0, 3, 1, -14)
            strip.Position         = UDim2.new(0, 0, 0, 7)
            strip.BackgroundColor3 = T.CYAN_DIM
            strip.BorderSizePixel  = 0
            corner(strip, 2)

            -- section header
            local hRow = Instance.new("Frame", SF)
            hRow.Size             = UDim2.new(1, 0, 0, 30)
            hRow.BackgroundTransparency = 1

            local hLbl = Instance.new("TextLabel", hRow)
            hLbl.Text   = string.upper(title or "Section")
            hLbl.Size   = UDim2.new(1, -14, 1, 0)
            hLbl.Position = UDim2.new(0, 12, 0, 0)
            hLbl.BackgroundTransparency = 1
            hLbl.TextColor3 = T.CYAN         -- section title: cyan sáng, dễ đọc
            hLbl.TextSize   = 11
            hLbl.Font       = Enum.Font.GothamBold
            hLbl.TextXAlignment = Enum.TextXAlignment.Left

            -- divider dưới header
            local hDiv = Instance.new("Frame", SF)
            hDiv.Size             = UDim2.new(1, -16, 0, 1)
            hDiv.Position         = UDim2.new(0, 8, 0, 30)
            hDiv.BackgroundColor3 = T.DIVIDER
            hDiv.BorderSizePixel  = 0

            -- inner content
            local inner = Instance.new("Frame", SF)
            inner.Size          = UDim2.new(1, 0, 0, 0)
            inner.AutomaticSize = Enum.AutomaticSize.Y
            inner.BackgroundTransparency = 1
            pad(inner, 36, 10, 10, 10)
            list(inner, Enum.FillDirection.Vertical, 6)

            local elemIdx = 0

            -- ── AddButton ──────────────────────
            function Sec:AddButton(bcfg)
                bcfg = bcfg or {}
                elemIdx = elemIdx + 1

                local row = Instance.new("Frame", inner)
                row.Size = UDim2.new(1, 0, 0, 34)
                row.BackgroundTransparency = 1
                row.LayoutOrder = elemIdx

                local Btn = Instance.new("TextButton", row)
                Btn.Size             = UDim2.new(1, 0, 1, 0)
                Btn.Text             = bcfg.Title or "Button"
                Btn.TextSize         = 13
                Btn.Font             = Enum.Font.GothamBold
                Btn.TextColor3       = T.TEXT1   -- gần trắng
                Btn.BackgroundColor3 = T.BG_ELEM
                Btn.BackgroundTransparency = TR.ELEM
                Btn.BorderSizePixel  = 0
                Btn.TextXAlignment   = Enum.TextXAlignment.Left
                corner(Btn, 7)
                stroke(Btn, T.BORDER, 1, 0.2)
                pad(Btn, 0, 10, 0, 12)

                local arrow = Instance.new("TextLabel", Btn)
                arrow.Text   = "›"
                arrow.Size   = UDim2.new(0, 20, 1, 0)
                arrow.Position = UDim2.new(1, -22, 0, 0)
                arrow.BackgroundTransparency = 1
                arrow.TextColor3 = T.TEXT3
                arrow.TextSize   = 17
                arrow.Font       = Enum.Font.GothamBold

                hoverFX(Btn, T.BG_ELEM, T.BG_HOVER)
                Btn.MouseEnter:Connect(function() tw(arrow, {TextColor3 = T.CYAN}, 0.1) end)
                Btn.MouseLeave:Connect(function() tw(arrow, {TextColor3 = T.TEXT3}, 0.1) end)
                Btn.MouseButton1Click:Connect(function()
                    tw(Btn, {BackgroundColor3 = Color3.fromRGB(0, 80, 110)}, 0.06)
                    task.delay(0.08, function() tw(Btn, {BackgroundColor3 = T.BG_ELEM}, 0.2) end)
                    if bcfg.Callback then pcall(bcfg.Callback) end
                end)
            end

            -- ── AddToggle ──────────────────────
            function Sec:AddToggle(tcfg)
                tcfg = tcfg or {}
                elemIdx = elemIdx + 1
                local state = tcfg.Default or false

                local Row = Instance.new("Frame", inner)
                Row.Size             = UDim2.new(1, 0, 0, 34)
                Row.BackgroundColor3 = T.BG_ELEM
                Row.BackgroundTransparency = TR.ELEM
                Row.BorderSizePixel  = 0
                Row.LayoutOrder      = elemIdx
                corner(Row, 7)
                stroke(Row, T.BORDER, 1, 0.2)

                local tl = Instance.new("TextLabel", Row)
                tl.Size   = UDim2.new(1, -62, 1, 0)
                tl.Position = UDim2.new(0, 12, 0, 0)
                tl.BackgroundTransparency = 1
                tl.Text   = tcfg.Title or "Toggle"
                tl.TextColor3 = T.TEXT1   -- gần trắng, đọc rõ
                tl.TextSize   = 13
                tl.Font       = Enum.Font.Gotham
                tl.TextXAlignment = Enum.TextXAlignment.Left

                local track = Instance.new("Frame", Row)
                track.Size             = UDim2.fromOffset(44, 22)
                track.Position         = UDim2.new(1, -54, 0.5, -11)
                track.BackgroundColor3 = state and T.CYAN_DIM or T.BG_HOVER
                track.BorderSizePixel  = 0
                corner(track, 11)
                local tStr = stroke(track, state and T.CYAN or T.BORDER, 1, 0)

                local knob = Instance.new("Frame", track)
                knob.Size             = UDim2.fromOffset(16, 16)
                knob.Position         = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                knob.BackgroundColor3 = state and T.CYAN or T.TEXT3
                knob.BorderSizePixel  = 0
                corner(knob, 8)

                -- ON / OFF label kế bên track
                local stateLbl = Instance.new("TextLabel", Row)
                stateLbl.Size   = UDim2.fromOffset(28, 34)
                stateLbl.Position = UDim2.new(1, -88, 0, 0)
                stateLbl.BackgroundTransparency = 1
                stateLbl.Text   = state and "ON" or "OFF"
                stateLbl.TextColor3 = state and T.CYAN or T.TEXT3
                stateLbl.TextSize   = 10
                stateLbl.Font       = Enum.Font.GothamBold
                stateLbl.TextXAlignment = Enum.TextXAlignment.Center

                local function set(v)
                    state = v
                    if state then
                        tw(track, {BackgroundColor3 = T.CYAN_DIM}, 0.15)
                        tw(knob,  {Position = UDim2.new(1,-19,0.5,-8), BackgroundColor3 = T.CYAN}, 0.18)
                        tStr.Color = T.CYAN
                        stateLbl.Text = "ON"
                        tw(stateLbl, {TextColor3 = T.CYAN}, 0.12)
                    else
                        tw(track, {BackgroundColor3 = T.BG_HOVER}, 0.15)
                        tw(knob,  {Position = UDim2.new(0,3,0.5,-8), BackgroundColor3 = T.TEXT3}, 0.18)
                        tStr.Color = T.BORDER
                        stateLbl.Text = "OFF"
                        tw(stateLbl, {TextColor3 = T.TEXT3}, 0.12)
                    end
                    if tcfg.Callback then pcall(tcfg.Callback, state) end
                end

                Row.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then set(not state) end
                end)
                hoverFX(Row, T.BG_ELEM, T.BG_HOVER)
                return { Set = set, Get = function() return state end }
            end

            -- ── AddSlider ──────────────────────
            function Sec:AddSlider(scfg)
                scfg = scfg or {}
                elemIdx = elemIdx + 1
                local minV, maxV = scfg.Min or 0, scfg.Max or 100
                local value      = scfg.Default or minV

                local SF2 = Instance.new("Frame", inner)
                SF2.Size             = UDim2.new(1, 0, 0, 52)
                SF2.BackgroundColor3 = T.BG_ELEM
                SF2.BackgroundTransparency = TR.ELEM
                SF2.BorderSizePixel  = 0
                SF2.LayoutOrder      = elemIdx
                corner(SF2, 7)
                stroke(SF2, T.BORDER, 1, 0.2)

                local sT = Instance.new("TextLabel", SF2)
                sT.Text   = scfg.Title or "Slider"
                sT.Size   = UDim2.new(1,-58,0,18)
                sT.Position = UDim2.new(0,12,0,8)
                sT.BackgroundTransparency = 1
                sT.TextColor3 = T.TEXT1   -- gần trắng
                sT.TextSize   = 12
                sT.Font       = Enum.Font.Gotham
                sT.TextXAlignment = Enum.TextXAlignment.Left

                local vL = Instance.new("TextLabel", SF2)
                vL.Text   = tostring(math.round(value))
                vL.Size   = UDim2.new(0,46,0,18)
                vL.Position = UDim2.new(1,-58,0,8)
                vL.BackgroundTransparency = 1
                vL.TextColor3 = T.CYAN    -- số: cyan
                vL.TextSize   = 13
                vL.Font       = Enum.Font.GothamBold
                vL.TextXAlignment = Enum.TextXAlignment.Right

                local trackBG = Instance.new("Frame", SF2)
                trackBG.Size          = UDim2.new(1,-24,0,5)
                trackBG.Position      = UDim2.new(0,12,1,-14)
                trackBG.BackgroundColor3 = T.DIVIDER
                trackBG.BorderSizePixel  = 0
                corner(trackBG, 3)

                local fill = Instance.new("Frame", trackBG)
                fill.Size          = UDim2.new((value-minV)/(maxV-minV),0,1,0)
                fill.BackgroundColor3 = T.CYAN
                fill.BorderSizePixel = 0
                corner(fill, 3)

                local handle = Instance.new("Frame", trackBG)
                handle.Size          = UDim2.fromOffset(13, 13)
                handle.Position      = UDim2.new((value-minV)/(maxV-minV),-6,0.5,-6)
                handle.BackgroundColor3 = Color3.new(1,1,1)
                handle.BorderSizePixel  = 0
                corner(handle, 7)

                local dragging = false
                local function upd(x)
                    local p = math.clamp((x - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
                    value = math.round(minV + (maxV - minV) * p)
                    fill.Size    = UDim2.new(p,0,1,0)
                    handle.Position = UDim2.new(p,-6,0.5,-6)
                    vL.Text = tostring(value)
                    if scfg.Callback then pcall(scfg.Callback, value) end
                end
                trackBG.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true; upd(i.Position.X) end
                end)
                UIS.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i.Position.X) end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
                end)
                return {
                    Get = function() return value end,
                    Set = function(v)
                        v = math.clamp(v, minV, maxV)
                        value = v
                        local p = (v-minV)/(maxV-minV)
                        tw(fill,   {Size = UDim2.new(p,0,1,0)}, 0.12)
                        tw(handle, {Position = UDim2.new(p,-6,0.5,-6)}, 0.12)
                        vL.Text = tostring(math.round(v))
                    end,
                }
            end

            -- ── AddInput ───────────────────────
            function Sec:AddInput(icfg)
                icfg = icfg or {}
                elemIdx = elemIdx + 1

                local wrap = Instance.new("Frame", inner)
                wrap.Size = UDim2.new(1,0,0,54)
                wrap.BackgroundTransparency = 1
                wrap.LayoutOrder = elemIdx

                local lbl2 = Instance.new("TextLabel", wrap)
                lbl2.Text   = icfg.Title or "Input"
                lbl2.Size   = UDim2.new(1,0,0,18)
                lbl2.BackgroundTransparency = 1
                lbl2.TextColor3 = T.TEXT2   -- sáng đủ
                lbl2.TextSize   = 11
                lbl2.Font       = Enum.Font.Gotham
                lbl2.TextXAlignment = Enum.TextXAlignment.Left

                local bg = Instance.new("Frame", wrap)
                bg.Size             = UDim2.new(1,0,0,32)
                bg.Position         = UDim2.new(0,0,0,20)
                bg.BackgroundColor3 = T.BG_ELEM
                bg.BackgroundTransparency = TR.ELEM
                bg.BorderSizePixel  = 0
                corner(bg, 6)
                local iStr = stroke(bg, T.BORDER, 1, 0.2)

                local tb = Instance.new("TextBox", bg)
                tb.Size   = UDim2.new(1,-14,1,0)
                tb.Position = UDim2.new(0,8,0,0)
                tb.BackgroundTransparency = 1
                tb.Text   = icfg.Default or ""
                tb.PlaceholderText = icfg.Placeholder or "..."
                tb.TextColor3 = T.TEXT1
                tb.PlaceholderColor3 = T.TEXT3
                tb.TextSize = 12
                tb.Font     = Enum.Font.Gotham
                tb.TextXAlignment = Enum.TextXAlignment.Left
                tb.ClearTextOnFocus = icfg.ClearOnFocus ~= false
                tb.Focused:Connect(function() iStr.Color = T.CYAN end)
                tb.FocusLost:Connect(function(enter)
                    iStr.Color = T.BORDER
                    if icfg.Callback then pcall(icfg.Callback, tb.Text, enter) end
                end)
                return { Get = function() return tb.Text end }
            end

            -- ── AddDropdown ────────────────────
            function Sec:AddDropdown(dcfg)
                dcfg = dcfg or {}
                elemIdx = elemIdx + 1
                local selected, open = dcfg.Default, false

                local DDWrap = Instance.new("Frame", inner)
                DDWrap.Size = UDim2.new(1,0,0,34)
                DDWrap.BackgroundTransparency = 1
                DDWrap.LayoutOrder = elemIdx
                DDWrap.ClipsDescendants = false
                DDWrap.ZIndex = 10

                local DDBtn = Instance.new("TextButton", DDWrap)
                DDBtn.Size             = UDim2.new(1,0,1,0)
                DDBtn.BackgroundColor3 = T.BG_ELEM
                DDBtn.BackgroundTransparency = TR.ELEM
                DDBtn.Text             = ""
                DDBtn.BorderSizePixel  = 0
                DDBtn.ZIndex           = 10
                corner(DDBtn, 7)
                stroke(DDBtn, T.BORDER, 1, 0.2)

                local ddL = Instance.new("TextLabel", DDBtn)
                ddL.Size   = UDim2.new(1,-34,1,0)
                ddL.Position = UDim2.new(0,12,0,0)
                ddL.BackgroundTransparency = 1
                ddL.Text   = selected or dcfg.Title or "Select..."
                ddL.TextColor3 = selected and T.TEXT1 or T.TEXT3
                ddL.TextSize   = 13
                ddL.Font       = Enum.Font.Gotham
                ddL.TextXAlignment = Enum.TextXAlignment.Left
                ddL.ZIndex = 11

                local ddA = Instance.new("TextLabel", DDBtn)
                ddA.Size   = UDim2.new(0,24,1,0)
                ddA.Position = UDim2.new(1,-26,0,0)
                ddA.BackgroundTransparency = 1
                ddA.Text   = "⌄"
                ddA.TextColor3 = T.TEXT3
                ddA.TextSize   = 14
                ddA.Font       = Enum.Font.GothamBold
                ddA.ZIndex = 11

                local panel = Instance.new("Frame", DDWrap)
                panel.Size    = UDim2.new(1,0,0,0)
                panel.Position= UDim2.new(0,0,1,4)
                panel.BackgroundColor3 = T.BG_SECTION
                panel.BackgroundTransparency = 0.05
                panel.BorderSizePixel  = 0
                panel.ClipsDescendants = true
                panel.ZIndex = 50
                corner(panel, 7)
                stroke(panel, T.CYAN_DIM, 1, 0.35)

                list(panel, Enum.FillDirection.Vertical, 2)
                pad(panel, 4,4,4,4)

                local items = dcfg.Items or {}
                for _, item in ipairs(items) do
                    local opt = Instance.new("TextButton", panel)
                    opt.Size             = UDim2.new(1,0,0,28)
                    opt.Text             = item
                    opt.BackgroundColor3 = T.BG_ELEM
                    opt.TextColor3       = T.TEXT1   -- gần trắng
                    opt.TextSize         = 12
                    opt.Font             = Enum.Font.Gotham
                    opt.BorderSizePixel  = 0
                    opt.ZIndex           = 51
                    corner(opt, 5)
                    hoverFX(opt, T.BG_ELEM, T.BG_HOVER)
                    opt.MouseButton1Click:Connect(function()
                        selected = item
                        ddL.Text = item
                        ddL.TextColor3 = T.TEXT1
                        open = false
                        tw(panel, {Size = UDim2.new(1,0,0,0)}, 0.15)
                        tw(ddA, {Rotation = 0}, 0.15)
                        if dcfg.Callback then pcall(dcfg.Callback, selected) end
                    end)
                end

                local panH = #items * 32 + 8
                DDBtn.MouseButton1Click:Connect(function()
                    open = not open
                    tw(panel, {Size = open and UDim2.new(1,0,0,panH) or UDim2.new(1,0,0,0)}, 0.18, Enum.EasingStyle.Quart)
                    tw(ddA, {Rotation = open and 180 or 0}, 0.18)
                end)

                return {
                    Get = function() return selected end,
                    Set = function(v) selected=v; ddL.Text=v; ddL.TextColor3=T.TEXT1 end,
                }
            end

            return Sec
        end -- AddSection

        return Tab
    end -- AddTab

    -- ── Window controls logic ───────────────────
    local minimized  = false
    local maximized  = false
    local savedSize  = UDim2.fromOffset(W, H)
    local savedPos   = Main.Position

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Content.Visible = false
            Sidebar.Visible = false
            tw(Main, {Size = UDim2.fromOffset(W, 46)}, 0.22, Enum.EasingStyle.Quart)
        else
            tw(Main, {Size = maximized and UDim2.fromScale(1,1) or savedSize}, 0.22, Enum.EasingStyle.Quart)
            task.delay(0.12, function()
                Content.Visible = true
                Sidebar.Visible = true
            end)
        end
    end)

    MaxBtn.MouseButton1Click:Connect(function()
        if minimized then return end
        maximized = not maximized
        if maximized then
            savedSize = Main.Size
            savedPos  = Main.Position
            tw(Main, {Size = UDim2.fromScale(1,1), Position = UDim2.fromScale(0.5,0.5)}, 0.22, Enum.EasingStyle.Quart)
            MaxBtn.Text = "❐"
        else
            tw(Main, {Size = savedSize, Position = savedPos}, 0.22, Enum.EasingStyle.Quart)
            MaxBtn.Text = "□"
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tw(Main, {Size = UDim2.fromOffset(W, 0), BackgroundTransparency = 1}, 0.2, Enum.EasingStyle.Quart)
        task.delay(0.22, function() sg:Destroy() end)
    end)

    -- Entry animation
    Main.BackgroundTransparency = 1
    Main.Size = UDim2.fromOffset(W * 0.88, H * 0.88)
    tw(Main, {Size = UDim2.fromOffset(W, H), BackgroundTransparency = TR.WIN}, 0.32, Enum.EasingStyle.Quint)

    return Window
end

return Phat

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  USAGE EXAMPLE
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local UI = loadstring(game:HttpGet("..."))()

local win = UI:CreateWindow({
    Title    = "PHAT UI",
    Subtitle = "v2.1  ·  Glass",
    Width    = 620,
    Height   = 480,
})

local t1 = win:AddTab({ Title = "Combat",   Icon = "⚔" })
local t2 = win:AddTab({ Title = "Settings", Icon = "⚙" })

local s1 = t1:AddSection("General")

s1:AddButton({
    Title    = "Kill Aura",
    Callback = function() win:Notify("Kill Aura", "Đã bật", "success") end,
})

local tog = s1:AddToggle({
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v)
        win:Notify("Infinite Jump", v and "ON" or "OFF", v and "success" or "warn")
    end,
})

local sl = s1:AddSlider({
    Title    = "Walk Speed",
    Min = 16, Max = 150, Default = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

s1:AddDropdown({
    Title = "Team",
    Items = {"Red","Blue","Green"},
    Callback = function(v) print("Team:", v) end,
})

local s2 = t2:AddSection("Keybinds")
s2:AddInput({ Title = "Toggle Key", Placeholder = "e.g. F1" })

-- Notifications
win:Notify("Loaded",     "PhatUI v2.1 sẵn sàng", "info")
win:Notify("Kill Aura",  "Đã kích hoạt",          "success")
win:Notify("Anti-Cheat", "Phát hiện!",             "error")
win:Notify("Speed",      "Giới hạn 150",           "warn")

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]
