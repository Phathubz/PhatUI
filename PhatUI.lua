--[[
    ██████╗ ██╗  ██╗ █████╗ ████████╗    ██╗   ██╗██╗
    ██╔══██╗██║  ██║██╔══██╗╚══██╔══╝    ██║   ██║██║
    ██████╔╝███████║███████║   ██║       ██║   ██║██║
    ██╔═══╝ ██╔══██║██╔══██║   ██║       ██║   ██║██║
    ██║     ██║  ██║██║  ██║   ██║       ╚██████╔╝██║
    ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝        ╚═════╝ ╚═╝
    
    Phat UI v2.0  —  Neon Noir Edition
    Aesthetic: dark glass · neon accents · clean geometry
--]]

local Phat = {}
Phat.__index = Phat

-- ─────────────────────────────────────────────
--  Services
-- ─────────────────────────────────────────────
local TweenService  = game:GetService("TweenService")
local UIS           = game:GetService("UserInputService")
local Players       = game:GetService("Players")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- ─────────────────────────────────────────────
--  Theme Palette
-- ─────────────────────────────────────────────
local THEME = {
    -- Backgrounds
    BG_MAIN      = Color3.fromRGB(10, 11, 15),
    BG_TOPBAR    = Color3.fromRGB(14, 15, 20),
    BG_SIDEBAR   = Color3.fromRGB(12, 13, 18),
    BG_SECTION   = Color3.fromRGB(18, 20, 28),
    BG_ELEMENT   = Color3.fromRGB(22, 24, 34),
    BG_HOVER     = Color3.fromRGB(30, 33, 48),

    -- Accents (neon cyan)
    ACCENT       = Color3.fromRGB(0, 210, 255),
    ACCENT_DIM   = Color3.fromRGB(0, 130, 160),
    ACCENT_GLOW  = Color3.fromRGB(0, 170, 210),

    -- Secondary accent (neon magenta)
    ACCENT2      = Color3.fromRGB(200, 0, 255),

    -- Status
    SUCCESS      = Color3.fromRGB(0, 230, 130),
    DANGER       = Color3.fromRGB(255, 55, 90),
    WARN         = Color3.fromRGB(255, 180, 0),

    -- Text
    TEXT_PRIMARY   = Color3.fromRGB(220, 230, 255),
    TEXT_SECONDARY = Color3.fromRGB(120, 135, 170),
    TEXT_MUTED     = Color3.fromRGB(65, 75, 105),

    -- Structure
    DIVIDER      = Color3.fromRGB(30, 35, 55),
    BORDER       = Color3.fromRGB(40, 45, 70),
}

-- ─────────────────────────────────────────────
--  Tween helpers
-- ─────────────────────────────────────────────
local function tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
        props
    ):Play()
end

local function hover(btn, normal, hot)
    btn.MouseEnter:Connect(function() tween(btn, {BackgroundColor3 = hot},    0.12) end)
    btn.MouseLeave:Connect(function() tween(btn, {BackgroundColor3 = normal}, 0.15) end)
end

-- ─────────────────────────────────────────────
--  Instance factory helpers
-- ─────────────────────────────────────────────
local function corner(p, r)
    local c = Instance.new("UICorner", p)
    c.CornerRadius = UDim.new(0, r or 8)
    return c
end

local function stroke(p, col, thick, trans)
    local s = Instance.new("UIStroke", p)
    s.Color        = col   or THEME.BORDER
    s.Thickness    = thick or 1
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

local function listLayout(p, fillDir, pad_px, halign, valign)
    local l = Instance.new("UIListLayout", p)
    l.FillDirection        = fillDir or Enum.FillDirection.Vertical
    l.Padding              = UDim.new(0, pad_px or 4)
    l.SortOrder            = Enum.SortOrder.LayoutOrder
    l.HorizontalAlignment  = halign  or Enum.HorizontalAlignment.Left
    l.VerticalAlignment    = valign  or Enum.VerticalAlignment.Top
    return l
end

-- ─────────────────────────────────────────────
--  Notification holder (module-level)
-- ─────────────────────────────────────────────
local NotifHolder

local function notify(title, message, ntype)
    if not NotifHolder then return end
    local colors = {
        info    = THEME.ACCENT,
        success = THEME.SUCCESS,
        error   = THEME.DANGER,
        warn    = THEME.WARN,
    }
    local accent = colors[ntype or "info"] or THEME.ACCENT

    local card = Instance.new("Frame", NotifHolder)
    card.Size             = UDim2.new(1, 0, 0, 58)
    card.BackgroundColor3 = THEME.BG_SECTION
    corner(card, 8)
    stroke(card, accent, 1, 0.45)

    local bar = Instance.new("Frame", card)
    bar.Size  = UDim2.new(0, 3, 1, -12)
    bar.Position = UDim2.new(0, 0, 0, 6)
    bar.BackgroundColor3 = accent
    bar.BorderSizePixel  = 0
    corner(bar, 2)

    local lbl1 = Instance.new("TextLabel", card)
    lbl1.Size              = UDim2.new(1, -14, 0, 18)
    lbl1.Position          = UDim2.new(0, 12, 0, 8)
    lbl1.BackgroundTransparency = 1
    lbl1.Text              = title or ""
    lbl1.TextColor3        = THEME.TEXT_PRIMARY
    lbl1.TextSize          = 13
    lbl1.Font              = Enum.Font.GothamBold
    lbl1.TextXAlignment    = Enum.TextXAlignment.Left

    local lbl2 = Instance.new("TextLabel", card)
    lbl2.Size              = UDim2.new(1, -14, 0, 16)
    lbl2.Position          = UDim2.new(0, 12, 0, 30)
    lbl2.BackgroundTransparency = 1
    lbl2.Text              = message or ""
    lbl2.TextColor3        = THEME.TEXT_SECONDARY
    lbl2.TextSize          = 11
    lbl2.Font              = Enum.Font.Gotham
    lbl2.TextXAlignment    = Enum.TextXAlignment.Left

    card.Position = UDim2.new(1.2, 0, 0, 0)
    tween(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    task.delay(3.5, function()
        tween(card, {Position = UDim2.new(1.2, 0, 0, 0)}, 0.25, Enum.EasingStyle.Quint)
        task.delay(0.28, function() card:Destroy() end)
    end)
end

-- ─────────────────────────────────────────────
--  CreateWindow
-- ─────────────────────────────────────────────
function Phat:CreateWindow(cfg)
    cfg = cfg or {}
    local W, H    = cfg.Width or 600, cfg.Height or 460
    local SIDE_W  = cfg.SidebarWidth or 155

    local Window  = { _tabs = {}, Notify = notify }

    -- ScreenGui
    local sg = Instance.new("ScreenGui", PlayerGui)
    sg.Name           = "PhatUI"
    sg.ResetOnSpawn   = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Notification area
    NotifHolder = Instance.new("Frame", sg)
    NotifHolder.Size                 = UDim2.fromOffset(262, 320)
    NotifHolder.Position             = UDim2.new(1, -278, 1, -328)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.ClipsDescendants     = true
    local nl = listLayout(NotifHolder, Enum.FillDirection.Vertical, 6)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- Main
    local Main = Instance.new("Frame", sg)
    Main.Name             = "Main"
    Main.Size             = UDim2.fromOffset(W, H)
    Main.Position         = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint      = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = THEME.BG_MAIN
    Main.Active           = true
    Main.Draggable        = true
    Main.ClipsDescendants = true
    corner(Main, 12)
    stroke(Main, THEME.BORDER, 1, 0)

    -- ── TopBar ─────────────────────────────────
    local Top = Instance.new("Frame", Main)
    Top.Name             = "TopBar"
    Top.Size             = UDim2.new(1, 0, 0, 46)
    Top.BackgroundColor3 = THEME.BG_TOPBAR
    Top.BorderSizePixel  = 0

    -- gradient accent line at bottom of topbar
    local accentLine = Instance.new("Frame", Top)
    accentLine.Size             = UDim2.new(1, 0, 0, 2)
    accentLine.Position         = UDim2.new(0, 0, 1, -2)
    accentLine.BackgroundColor3 = THEME.ACCENT
    accentLine.BorderSizePixel  = 0
    local aLineGrad = Instance.new("UIGradient", accentLine)
    aLineGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   THEME.ACCENT),
        ColorSequenceKeypoint.new(0.5, THEME.ACCENT2),
        ColorSequenceKeypoint.new(1,   THEME.ACCENT),
    }

    -- small glowing dot logo
    local dot = Instance.new("Frame", Top)
    dot.Size             = UDim2.fromOffset(8, 8)
    dot.Position         = UDim2.new(0, 14, 0.5, -4)
    dot.BackgroundColor3 = THEME.ACCENT
    dot.BorderSizePixel  = 0
    corner(dot, 4)

    -- title
    local titleLbl = Instance.new("TextLabel", Top)
    titleLbl.Text              = cfg.Title or "PHAT UI"
    titleLbl.Size              = UDim2.new(0, 320, 1, 0)
    titleLbl.Position          = UDim2.new(0, 28, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextColor3        = THEME.TEXT_PRIMARY
    titleLbl.TextSize          = 14
    titleLbl.Font              = Enum.Font.GothamBold
    titleLbl.TextXAlignment    = Enum.TextXAlignment.Left

    if cfg.Subtitle then
        local sub = Instance.new("TextLabel", Top)
        sub.Text  = cfg.Subtitle
        sub.Size  = UDim2.new(0, 200, 0, 13)
        sub.Position = UDim2.new(0, 28, 1, -16)
        sub.BackgroundTransparency = 1
        sub.TextColor3 = THEME.ACCENT_DIM
        sub.TextSize   = 10
        sub.Font       = Enum.Font.Gotham
        sub.TextXAlignment = Enum.TextXAlignment.Left
    end

    -- window control buttons
    local function winBtn(xOff, sym, normalC, hoverC)
        local b = Instance.new("TextButton", Top)
        b.Size             = UDim2.fromOffset(28, 28)
        b.Position         = UDim2.new(1, xOff, 0.5, -14)
        b.Text             = sym
        b.TextSize         = 13
        b.Font             = Enum.Font.GothamBold
        b.BackgroundColor3 = normalC
        b.TextColor3       = THEME.TEXT_SECONDARY
        b.BorderSizePixel  = 0
        corner(b, 7)
        hover(b, normalC, hoverC)
        b.MouseEnter:Connect(function() tween(b, {TextColor3 = Color3.new(1,1,1)}, 0.1) end)
        b.MouseLeave:Connect(function() tween(b, {TextColor3 = THEME.TEXT_SECONDARY}, 0.1) end)
        return b
    end
    local CloseBtn = winBtn(-12, "✕", THEME.BG_ELEMENT, THEME.DANGER)
    local MinBtn   = winBtn(-46, "─", THEME.BG_ELEMENT, THEME.BG_HOVER)

    -- ── Sidebar ────────────────────────────────
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Name             = "Sidebar"
    Sidebar.Size             = UDim2.new(0, SIDE_W, 1, -46)
    Sidebar.Position         = UDim2.new(0, 0, 0, 46)
    Sidebar.BackgroundColor3 = THEME.BG_SIDEBAR
    Sidebar.BorderSizePixel  = 0

    local sideDiv = Instance.new("Frame", Sidebar)
    sideDiv.Size             = UDim2.new(0, 1, 1, 0)
    sideDiv.Position         = UDim2.new(1, -1, 0, 0)
    sideDiv.BackgroundColor3 = THEME.DIVIDER
    sideDiv.BorderSizePixel  = 0

    listLayout(Sidebar, Enum.FillDirection.Vertical, 2, Enum.HorizontalAlignment.Center)
    pad(Sidebar, 8, 0, 8, 0)

    -- ── Content (scrolling) ────────────────────
    local Content = Instance.new("ScrollingFrame", Main)
    Content.Name                   = "Content"
    Content.Size                   = UDim2.new(1, -SIDE_W, 1, -46)
    Content.Position               = UDim2.new(0, SIDE_W, 0, 46)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel        = 0
    Content.ScrollBarThickness     = 3
    Content.ScrollBarImageColor3   = THEME.ACCENT_DIM
    Content.CanvasSize             = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize    = Enum.AutomaticSize.Y

    listLayout(Content, Enum.FillDirection.Vertical, 8)
    pad(Content, 10, 10, 10, 10)

    -- ── AddTab ─────────────────────────────────
    local tabIdx = 0

    function Window:AddTab(tabcfg)
        tabcfg = tabcfg or {}
        tabIdx = tabIdx + 1
        local myIdx = tabIdx

        local Tab = {}

        -- Sidebar button
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Name              = "Tab"..myIdx
        TabBtn.Size              = UDim2.new(1, -8, 0, 36)
        TabBtn.BackgroundColor3  = THEME.BG_ELEMENT
        TabBtn.Text              = ""
        TabBtn.BorderSizePixel   = 0
        TabBtn.LayoutOrder       = myIdx
        corner(TabBtn, 8)

        -- inner row
        local inner = Instance.new("Frame", TabBtn)
        inner.Size = UDim2.new(1, 0, 1, 0)
        inner.BackgroundTransparency = 1
        local il = listLayout(inner, Enum.FillDirection.Horizontal, 8,
            Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
        pad(inner, 0, 0, 0, 10)

        if tabcfg.Icon then
            local ico = Instance.new("TextLabel", inner)
            ico.Text              = tabcfg.Icon
            ico.Size              = UDim2.fromOffset(16, 36)
            ico.BackgroundTransparency = 1
            ico.TextColor3        = THEME.TEXT_SECONDARY
            ico.TextSize          = 14
            ico.Font              = Enum.Font.GothamBold
            ico.Name              = "Icon"
        end

        local tabLabel = Instance.new("TextLabel", inner)
        tabLabel.Name              = "Label"
        tabLabel.Text              = tabcfg.Title or ("Tab "..myIdx)
        tabLabel.Size              = UDim2.new(1, 0, 1, 0)
        tabLabel.BackgroundTransparency = 1
        tabLabel.TextColor3        = THEME.TEXT_SECONDARY
        tabLabel.TextSize          = 13
        tabLabel.Font              = Enum.Font.GothamBold
        tabLabel.TextXAlignment    = Enum.TextXAlignment.Left

        local activeBar = Instance.new("Frame", TabBtn)
        activeBar.Size             = UDim2.new(0, 3, 0.55, 0)
        activeBar.Position         = UDim2.new(1, -3, 0.225, 0)
        activeBar.BackgroundColor3 = THEME.ACCENT
        activeBar.BorderSizePixel  = 0
        activeBar.Visible          = false
        corner(activeBar, 2)

        -- Page
        local Page = Instance.new("Frame", Content)
        Page.Name              = "Page"..myIdx
        Page.Size              = UDim2.new(1, 0, 0, 0)
        Page.AutomaticSize     = Enum.AutomaticSize.Y
        Page.BackgroundTransparency = 1
        Page.Visible           = false
        Page.LayoutOrder       = myIdx
        listLayout(Page, Enum.FillDirection.Vertical, 8)

        local function activate()
            for _, t in ipairs(Window._tabs) do
                t._page.Visible = false
                t._btn.BackgroundColor3 = THEME.BG_ELEMENT
                t._abar.Visible = false
                tween(t._lbl, {TextColor3 = THEME.TEXT_SECONDARY}, 0.12)
            end
            Page.Visible = true
            tween(TabBtn, {BackgroundColor3 = THEME.BG_SECTION}, 0.15)
            activeBar.Visible = true
            tween(tabLabel, {TextColor3 = THEME.ACCENT}, 0.15)
        end

        Tab._page = Page
        Tab._btn  = TabBtn
        Tab._abar = activeBar
        Tab._lbl  = tabLabel

        TabBtn.MouseButton1Click:Connect(activate)
        hover(TabBtn, THEME.BG_ELEMENT, THEME.BG_HOVER)

        if tabIdx == 1 then activate() end
        table.insert(Window._tabs, Tab)

        -- ── AddSection ─────────────────────────
        local secIdx = 0

        function Tab:AddSection(title)
            secIdx = secIdx + 1
            local Sec = {}

            local SF = Instance.new("Frame", Page)
            SF.Name             = "Section"..secIdx
            SF.Size             = UDim2.new(1, 0, 0, 0)
            SF.AutomaticSize    = Enum.AutomaticSize.Y
            SF.BackgroundColor3 = THEME.BG_SECTION
            SF.BorderSizePixel  = 0
            SF.LayoutOrder      = secIdx
            corner(SF, 10)
            stroke(SF, THEME.BORDER, 1, 0.35)

            -- left accent strip
            local strip = Instance.new("Frame", SF)
            strip.Size             = UDim2.new(0, 3, 1, -12)
            strip.Position         = UDim2.new(0, 0, 0, 6)
            strip.BackgroundColor3 = THEME.ACCENT_DIM
            strip.BorderSizePixel  = 0
            corner(strip, 2)

            -- header
            local hdr = Instance.new("Frame", SF)
            hdr.Size             = UDim2.new(1, 0, 0, 28)
            hdr.BackgroundTransparency = 1

            local hdrLbl = Instance.new("TextLabel", hdr)
            hdrLbl.Text     = string.upper(title or "Section")
            hdrLbl.Size     = UDim2.new(1, -14, 1, 0)
            hdrLbl.Position = UDim2.new(0, 12, 0, 0)
            hdrLbl.BackgroundTransparency = 1
            hdrLbl.TextColor3 = THEME.ACCENT
            hdrLbl.TextSize   = 10
            hdrLbl.Font       = Enum.Font.GothamBold
            hdrLbl.TextXAlignment = Enum.TextXAlignment.Left

            -- thin divider below header
            local hDiv = Instance.new("Frame", SF)
            hDiv.Size             = UDim2.new(1, -16, 0, 1)
            hDiv.Position         = UDim2.new(0, 8, 0, 28)
            hDiv.BackgroundColor3 = THEME.DIVIDER
            hDiv.BorderSizePixel  = 0

            -- inner content holder
            local inner = Instance.new("Frame", SF)
            inner.Size          = UDim2.new(1, 0, 0, 0)
            inner.AutomaticSize = Enum.AutomaticSize.Y
            inner.BackgroundTransparency = 1
            pad(inner, 36, 10, 10, 10)
            listLayout(inner, Enum.FillDirection.Vertical, 6)

            local elemIdx = 0

            -- ── Button ─────────────────────────
            function Sec:AddButton(bcfg)
                bcfg = bcfg or {}
                elemIdx = elemIdx + 1

                local BtnFrame = Instance.new("Frame", inner)
                BtnFrame.Size          = UDim2.new(1, 0, 0, 34)
                BtnFrame.BackgroundTransparency = 1
                BtnFrame.LayoutOrder   = elemIdx

                local Btn = Instance.new("TextButton", BtnFrame)
                Btn.Size             = UDim2.new(1, 0, 1, 0)
                Btn.Text             = bcfg.Title or "Button"
                Btn.TextSize         = 13
                Btn.Font             = Enum.Font.GothamBold
                Btn.TextColor3       = THEME.TEXT_PRIMARY
                Btn.BackgroundColor3 = THEME.BG_ELEMENT
                Btn.BorderSizePixel  = 0
                Btn.TextXAlignment   = Enum.TextXAlignment.Left
                corner(Btn, 7)
                stroke(Btn, THEME.BORDER, 1, 0)
                pad(Btn, 0, 10, 0, 12)

                local arrow = Instance.new("TextLabel", Btn)
                arrow.Text    = "›"
                arrow.Size    = UDim2.new(0, 20, 1, 0)
                arrow.Position= UDim2.new(1, -22, 0, 0)
                arrow.BackgroundTransparency = 1
                arrow.TextColor3 = THEME.TEXT_MUTED
                arrow.TextSize   = 16
                arrow.Font       = Enum.Font.GothamBold

                hover(Btn, THEME.BG_ELEMENT, THEME.BG_HOVER)
                Btn.MouseEnter:Connect(function() tween(arrow, {TextColor3 = THEME.ACCENT}, 0.1) end)
                Btn.MouseLeave:Connect(function() tween(arrow, {TextColor3 = THEME.TEXT_MUTED}, 0.1) end)

                Btn.MouseButton1Click:Connect(function()
                    tween(Btn, {BackgroundColor3 = Color3.fromRGB(0, 70, 90)}, 0.06)
                    task.delay(0.07, function()
                        tween(Btn, {BackgroundColor3 = THEME.BG_ELEMENT}, 0.2)
                    end)
                    if bcfg.Callback then pcall(bcfg.Callback) end
                end)
            end

            -- ── Toggle ─────────────────────────
            function Sec:AddToggle(tcfg)
                tcfg = tcfg or {}
                elemIdx = elemIdx + 1
                local state = tcfg.Default or false

                local Row = Instance.new("Frame", inner)
                Row.Size             = UDim2.new(1, 0, 0, 34)
                Row.BackgroundColor3 = THEME.BG_ELEMENT
                Row.BorderSizePixel  = 0
                Row.LayoutOrder      = elemIdx
                corner(Row, 7)
                stroke(Row, THEME.BORDER, 1, 0)

                local lbl = Instance.new("TextLabel", Row)
                lbl.Size   = UDim2.new(1, -58, 1, 0)
                lbl.Position = UDim2.new(0, 12, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text   = tcfg.Title or "Toggle"
                lbl.TextColor3 = THEME.TEXT_PRIMARY
                lbl.TextSize   = 13
                lbl.Font       = Enum.Font.Gotham
                lbl.TextXAlignment = Enum.TextXAlignment.Left

                local track = Instance.new("Frame", Row)
                track.Size             = UDim2.fromOffset(42, 22)
                track.Position         = UDim2.new(1, -52, 0.5, -11)
                track.BackgroundColor3 = state and THEME.ACCENT_DIM or THEME.BG_HOVER
                track.BorderSizePixel  = 0
                corner(track, 11)
                local tStroke = stroke(track, state and THEME.ACCENT or THEME.BORDER, 1, 0)

                local knob = Instance.new("Frame", track)
                knob.Size              = UDim2.fromOffset(16, 16)
                knob.Position          = state
                    and UDim2.new(1, -19, 0.5, -8)
                    or  UDim2.new(0,  3, 0.5, -8)
                knob.BackgroundColor3  = state and THEME.ACCENT or THEME.TEXT_MUTED
                knob.BorderSizePixel   = 0
                corner(knob, 8)

                local function set(v)
                    state = v
                    if state then
                        tween(track, {BackgroundColor3 = THEME.ACCENT_DIM}, 0.15)
                        tween(knob,  {Position = UDim2.new(1, -19, 0.5, -8), BackgroundColor3 = THEME.ACCENT}, 0.18)
                        tStroke.Color = THEME.ACCENT
                    else
                        tween(track, {BackgroundColor3 = THEME.BG_HOVER}, 0.15)
                        tween(knob,  {Position = UDim2.new(0, 3, 0.5, -8), BackgroundColor3 = THEME.TEXT_MUTED}, 0.18)
                        tStroke.Color = THEME.BORDER
                    end
                    if tcfg.Callback then pcall(tcfg.Callback, state) end
                end

                Row.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 then set(not state) end
                end)
                hover(Row, THEME.BG_ELEMENT, THEME.BG_HOVER)

                return { Set = set, Get = function() return state end }
            end

            -- ── Slider ─────────────────────────
            function Sec:AddSlider(scfg)
                scfg = scfg or {}
                elemIdx = elemIdx + 1
                local minV, maxV = scfg.Min or 0, scfg.Max or 100
                local value      = scfg.Default or minV

                local SF2 = Instance.new("Frame", inner)
                SF2.Size             = UDim2.new(1, 0, 0, 50)
                SF2.BackgroundColor3 = THEME.BG_ELEMENT
                SF2.BorderSizePixel  = 0
                SF2.LayoutOrder      = elemIdx
                corner(SF2, 7)
                stroke(SF2, THEME.BORDER, 1, 0)

                local sTitle = Instance.new("TextLabel", SF2)
                sTitle.Text     = scfg.Title or "Slider"
                sTitle.Size     = UDim2.new(1, -56, 0, 16)
                sTitle.Position = UDim2.new(0, 12, 0, 8)
                sTitle.BackgroundTransparency = 1
                sTitle.TextColor3 = THEME.TEXT_PRIMARY
                sTitle.TextSize   = 12
                sTitle.Font       = Enum.Font.Gotham
                sTitle.TextXAlignment = Enum.TextXAlignment.Left

                local valLbl = Instance.new("TextLabel", SF2)
                valLbl.Text     = tostring(math.round(value))
                valLbl.Size     = UDim2.new(0, 44, 0, 16)
                valLbl.Position = UDim2.new(1, -56, 0, 8)
                valLbl.BackgroundTransparency = 1
                valLbl.TextColor3 = THEME.ACCENT
                valLbl.TextSize   = 12
                valLbl.Font       = Enum.Font.GothamBold
                valLbl.TextXAlignment = Enum.TextXAlignment.Right

                local trackBG = Instance.new("Frame", SF2)
                trackBG.Size          = UDim2.new(1, -24, 0, 4)
                trackBG.Position      = UDim2.new(0, 12, 1, -14)
                trackBG.BackgroundColor3 = THEME.DIVIDER
                trackBG.BorderSizePixel = 0
                corner(trackBG, 2)

                local fill = Instance.new("Frame", trackBG)
                fill.Size          = UDim2.new((value - minV) / (maxV - minV), 0, 1, 0)
                fill.BackgroundColor3 = THEME.ACCENT
                fill.BorderSizePixel = 0
                corner(fill, 2)

                local handle = Instance.new("Frame", trackBG)
                handle.Size          = UDim2.fromOffset(12, 12)
                handle.Position      = UDim2.new((value - minV) / (maxV - minV), -6, 0.5, -6)
                handle.BackgroundColor3 = Color3.new(1,1,1)
                handle.BorderSizePixel = 0
                corner(handle, 6)

                local dragging = false
                local function upd(x)
                    local p = math.clamp((x - trackBG.AbsolutePosition.X) / trackBG.AbsoluteSize.X, 0, 1)
                    value  = math.round(minV + (maxV - minV) * p)
                    fill.Size    = UDim2.new(p, 0, 1, 0)
                    handle.Position = UDim2.new(p, -6, 0.5, -6)
                    valLbl.Text  = tostring(value)
                    if scfg.Callback then pcall(scfg.Callback, value) end
                end

                trackBG.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; upd(i.Position.X) end
                end)
                UIS.InputChanged:Connect(function(i)
                    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i.Position.X) end
                end)
                UIS.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)

                return {
                    Get = function() return value end,
                    Set = function(v)
                        v = math.clamp(v, minV, maxV)
                        value = v
                        local p = (v - minV) / (maxV - minV)
                        tween(fill,   {Size = UDim2.new(p, 0, 1, 0)}, 0.12)
                        tween(handle, {Position = UDim2.new(p, -6, 0.5, -6)}, 0.12)
                        valLbl.Text = tostring(math.round(v))
                    end,
                }
            end

            -- ── TextInput ──────────────────────
            function Sec:AddInput(icfg)
                icfg = icfg or {}
                elemIdx = elemIdx + 1

                local wrap = Instance.new("Frame", inner)
                wrap.Size          = UDim2.new(1, 0, 0, 54)
                wrap.BackgroundTransparency = 1
                wrap.LayoutOrder   = elemIdx

                local lbl = Instance.new("TextLabel", wrap)
                lbl.Text    = icfg.Title or "Input"
                lbl.Size    = UDim2.new(1, 0, 0, 18)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = THEME.TEXT_SECONDARY
                lbl.TextSize   = 11
                lbl.Font       = Enum.Font.Gotham
                lbl.TextXAlignment = Enum.TextXAlignment.Left

                local bg = Instance.new("Frame", wrap)
                bg.Size             = UDim2.new(1, 0, 0, 32)
                bg.Position         = UDim2.new(0, 0, 0, 20)
                bg.BackgroundColor3 = THEME.BG_ELEMENT
                bg.BorderSizePixel  = 0
                corner(bg, 6)
                local ibStroke = stroke(bg, THEME.BORDER, 1, 0)

                local tb = Instance.new("TextBox", bg)
                tb.Size          = UDim2.new(1, -14, 1, 0)
                tb.Position      = UDim2.new(0, 8, 0, 0)
                tb.BackgroundTransparency = 1
                tb.Text          = icfg.Default or ""
                tb.PlaceholderText = icfg.Placeholder or "..."
                tb.TextColor3    = THEME.TEXT_PRIMARY
                tb.PlaceholderColor3 = THEME.TEXT_MUTED
                tb.TextSize      = 12
                tb.Font          = Enum.Font.Gotham
                tb.TextXAlignment = Enum.TextXAlignment.Left
                tb.ClearTextOnFocus = icfg.ClearOnFocus ~= false

                tb.Focused:Connect(function()    tween(ibStroke, {Color = THEME.ACCENT}, 0.15) end)
                tb.FocusLost:Connect(function(enter)
                    tween(ibStroke, {Color = THEME.BORDER}, 0.15)
                    if icfg.Callback then pcall(icfg.Callback, tb.Text, enter) end
                end)

                return { Get = function() return tb.Text end }
            end

            -- ── Dropdown ───────────────────────
            function Sec:AddDropdown(dcfg)
                dcfg = dcfg or {}
                elemIdx = elemIdx + 1
                local selected, open = dcfg.Default, false

                local DDWrap = Instance.new("Frame", inner)
                DDWrap.Size          = UDim2.new(1, 0, 0, 34)
                DDWrap.BackgroundTransparency = 1
                DDWrap.LayoutOrder   = elemIdx
                DDWrap.ClipsDescendants = false
                DDWrap.ZIndex        = 10

                local DDBtn = Instance.new("TextButton", DDWrap)
                DDBtn.Size             = UDim2.new(1, 0, 1, 0)
                DDBtn.BackgroundColor3 = THEME.BG_ELEMENT
                DDBtn.Text             = ""
                DDBtn.BorderSizePixel  = 0
                DDBtn.ZIndex           = 10
                corner(DDBtn, 7)
                stroke(DDBtn, THEME.BORDER, 1, 0)

                local ddLbl = Instance.new("TextLabel", DDBtn)
                ddLbl.Size   = UDim2.new(1, -34, 1, 0)
                ddLbl.Position = UDim2.new(0, 12, 0, 0)
                ddLbl.BackgroundTransparency = 1
                ddLbl.Text   = selected or dcfg.Title or "Select..."
                ddLbl.TextColor3 = selected and THEME.TEXT_PRIMARY or THEME.TEXT_MUTED
                ddLbl.TextSize   = 13
                ddLbl.Font       = Enum.Font.Gotham
                ddLbl.TextXAlignment = Enum.TextXAlignment.Left
                ddLbl.ZIndex     = 11

                local ddArrow = Instance.new("TextLabel", DDBtn)
                ddArrow.Size   = UDim2.new(0, 24, 1, 0)
                ddArrow.Position = UDim2.new(1, -26, 0, 0)
                ddArrow.BackgroundTransparency = 1
                ddArrow.Text   = "⌄"
                ddArrow.TextColor3 = THEME.TEXT_MUTED
                ddArrow.TextSize   = 14
                ddArrow.Font       = Enum.Font.GothamBold
                ddArrow.ZIndex     = 11

                local panel = Instance.new("Frame", DDWrap)
                panel.Size    = UDim2.new(1, 0, 0, 0)
                panel.Position= UDim2.new(0, 0, 1, 4)
                panel.BackgroundColor3 = THEME.BG_SECTION
                panel.BorderSizePixel  = 0
                panel.ClipsDescendants = true
                panel.ZIndex  = 50
                corner(panel, 7)
                stroke(panel, THEME.ACCENT_DIM, 1, 0.4)

                listLayout(panel, Enum.FillDirection.Vertical, 2)
                pad(panel, 4, 4, 4, 4)

                local items = dcfg.Items or {}
                for _, item in ipairs(items) do
                    local opt = Instance.new("TextButton", panel)
                    opt.Size             = UDim2.new(1, 0, 0, 28)
                    opt.Text             = item
                    opt.BackgroundColor3 = THEME.BG_ELEMENT
                    opt.TextColor3       = THEME.TEXT_PRIMARY
                    opt.TextSize         = 12
                    opt.Font             = Enum.Font.Gotham
                    opt.BorderSizePixel  = 0
                    opt.ZIndex           = 51
                    corner(opt, 5)
                    hover(opt, THEME.BG_ELEMENT, THEME.BG_HOVER)
                    opt.MouseButton1Click:Connect(function()
                        selected = item
                        ddLbl.Text = item
                        ddLbl.TextColor3 = THEME.TEXT_PRIMARY
                        open = false
                        tween(panel, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        tween(ddArrow, {Rotation = 0}, 0.15)
                        if dcfg.Callback then pcall(dcfg.Callback, selected) end
                    end)
                end

                local panH = #items * 32 + 8
                DDBtn.MouseButton1Click:Connect(function()
                    open = not open
                    tween(panel,   {Size = open and UDim2.new(1, 0, 0, panH) or UDim2.new(1, 0, 0, 0)}, 0.18, Enum.EasingStyle.Quart)
                    tween(ddArrow, {Rotation = open and 180 or 0}, 0.18)
                end)

                return {
                    Get = function() return selected end,
                    Set = function(v) selected = v; ddLbl.Text = v; ddLbl.TextColor3 = THEME.TEXT_PRIMARY end,
                }
            end

            return Sec
        end -- AddSection

        return Tab
    end -- AddTab

    -- ── Window controls ────────────────────────
    local minimized = false
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Content.Visible = false
            Sidebar.Visible = false
            tween(Main, {Size = UDim2.fromOffset(W, 46)}, 0.22, Enum.EasingStyle.Quart)
        else
            tween(Main, {Size = UDim2.fromOffset(W, H)}, 0.22, Enum.EasingStyle.Quart)
            task.delay(0.15, function()
                Content.Visible = true
                Sidebar.Visible = true
            end)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        tween(Main, {Size = UDim2.fromOffset(W, 0), BackgroundTransparency = 1}, 0.2, Enum.EasingStyle.Quart)
        task.delay(0.22, function() sg:Destroy() end)
    end)

    -- Entry animation
    Main.Size = UDim2.fromOffset(W * 0.88, H * 0.88)
    Main.BackgroundTransparency = 1
    tween(Main, {Size = UDim2.fromOffset(W, H), BackgroundTransparency = 0}, 0.32, Enum.EasingStyle.Quint)

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
    Subtitle = "v2.0  ·  Neon Noir",
    Width    = 600,
    Height   = 460,
})

-- Tab with optional icon (emoji or symbol)
local t1 = win:AddTab({ Title = "Combat", Icon = "⚔" })
local s1 = t1:AddSection("General")

s1:AddButton({
    Title    = "Kill Aura",
    Callback = function() print("triggered") end,
})

local toggle = s1:AddToggle({
    Title    = "Infinite Jump",
    Default  = false,
    Callback = function(v) print("InfJump:", v) end,
})

local slider = s1:AddSlider({
    Title    = "Walk Speed",
    Min      = 16, Max = 150, Default = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

s1:AddDropdown({
    Title    = "Team",
    Items    = { "Red", "Blue", "Green" },
    Callback = function(v) print("Team:", v) end,
})

-- Notifications
win:Notify("Kill Aura",    "Activated",   "success")
win:Notify("Speed Hack",   "Blocked!",    "error")
win:Notify("Anti-AFK",     "Running…",    "info")

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--]]
