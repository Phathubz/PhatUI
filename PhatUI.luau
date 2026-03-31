--[[
    Phat UI Library v2.1
    Premium Roblox UI with advanced features
]]

local Phat = {}
Phat.__index = Phat

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local EASING_STYLE = Enum.EasingStyle.Quad

local function Create(class, props, children)
    local inst = Instance.new(class)
    for i, v in pairs(props or {}) do
        if i ~= "Parent" then
            inst[i] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Tween(obj, props, duration, easingStyle)
    duration = duration or 0.25
    easingStyle = easingStyle or EASING_STYLE
    local tween = TweenService:Create(obj, TweenInfo.new(duration, easingStyle, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function Dragify(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            local absPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Tween(frame, {Position = absPos}, 0.08)
        end
    end)
end

local ThemePresets = {
    Dark = {
        Background = Color3.fromRGB(15, 15, 15),
        BackgroundDark = Color3.fromRGB(10, 10, 10),
        BackgroundLight = Color3.fromRGB(22, 22, 25),
        Card = Color3.fromRGB(25, 25, 28),
        CardHover = Color3.fromRGB(32, 32, 36),
        Sidebar = Color3.fromRGB(12, 12, 14),
        Border = Color3.fromRGB(45, 45, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(140, 140, 150),
        Accent = Color3.fromRGB(88, 166, 255),
        AccentDark = Color3.fromRGB(60, 120, 200),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(55, 55, 65),
    },
    Light = {
        Background = Color3.fromRGB(248, 248, 252),
        BackgroundDark = Color3.fromRGB(240, 240, 245),
        BackgroundLight = Color3.fromRGB(255, 255, 255),
        Card = Color3.fromRGB(255, 255, 255),
        CardHover = Color3.fromRGB(245, 245, 250),
        Sidebar = Color3.fromRGB(242, 242, 248),
        Border = Color3.fromRGB(215, 215, 225),
        Text = Color3.fromRGB(20, 20, 25),
        TextMuted = Color3.fromRGB(100, 100, 110),
        Accent = Color3.fromRGB(0, 120, 255),
        AccentDark = Color3.fromRGB(0, 80, 200),
        Success = Color3.fromRGB(40, 180, 80),
        Warning = Color3.fromRGB(255, 180, 0),
        Error = Color3.fromRGB(220, 60, 60),
        Toggle = Color3.fromRGB(200, 200, 210),
    },
    Midnight = {
        Background = Color3.fromRGB(8, 8, 12),
        BackgroundDark = Color3.fromRGB(5, 5, 8),
        BackgroundLight = Color3.fromRGB(15, 15, 20),
        Card = Color3.fromRGB(18, 18, 25),
        CardHover = Color3.fromRGB(25, 25, 35),
        Sidebar = Color3.fromRGB(6, 6, 10),
        Border = Color3.fromRGB(35, 35, 50),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(110, 110, 130),
        Accent = Color3.fromRGB(140, 80, 255),
        AccentDark = Color3.fromRGB(100, 50, 200),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(40, 40, 55),
    },
    Ocean = {
        Background = Color3.fromRGB(10, 20, 35),
        BackgroundDark = Color3.fromRGB(5, 12, 25),
        BackgroundLight = Color3.fromRGB(18, 30, 50),
        Card = Color3.fromRGB(22, 35, 55),
        CardHover = Color3.fromRGB(30, 45, 65),
        Sidebar = Color3.fromRGB(8, 15, 28),
        Border = Color3.fromRGB(40, 65, 95),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(120, 160, 200),
        Accent = Color3.fromRGB(80, 200, 255),
        AccentDark = Color3.fromRGB(50, 150, 220),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(45, 75, 105),
    },
    Sunset = {
        Background = Color3.fromRGB(25, 15, 20),
        BackgroundDark = Color3.fromRGB(18, 10, 14),
        BackgroundLight = Color3.fromRGB(40, 25, 32),
        Card = Color3.fromRGB(45, 28, 36),
        CardHover = Color3.fromRGB(55, 35, 45),
        Sidebar = Color3.fromRGB(20, 12, 16),
        Border = Color3.fromRGB(75, 50, 60),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(180, 140, 150),
        Accent = Color3.fromRGB(255, 120, 150),
        AccentDark = Color3.fromRGB(200, 80, 110),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(85, 55, 65),
    },
}

getgenv().PhatUI = getgenv().PhatUI or {}
local PhatData = getgenv().PhatUI

function Phat:CreateWindow(config)
    local Window = {}
    Window.Elements = {}
    Window.Flags = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Running = true

    local cfg = {
        Title = config.Title or "Phat UI",
        Subtitle = config.Subtitle or "",
        TabWidth = config.TabWidth or 160,
        Size = config.Size or UDim2.fromOffset(620, 480),
        Position = config.Position or UDim2.fromScale(0.5, 0.5),
        Acrylic = config.Acrylic or false,
        Theme = config.Theme or "Dark",
        Accent = config.Accent or nil,
        MinimizeKey = config.MinimizeKey or Enum.KeyCode.F1,
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl,
        Watermark = config.Watermark or false,
        SaveConfig = config.SaveConfig or false,
        ConfigName = config.ConfigName or "PhatConfig",
    }

    local Theme = ThemePresets[cfg.Theme] or ThemePresets.Dark
    if cfg.Accent then
        Theme.Accent = cfg.Accent
        Theme.AccentDark = Color3.fromHSV(cfg.Accent:ToHSV())
    end

    local ScreenGui = Create("ScreenGui", {
        Name = "PhatUI",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })

    local Main = Create("Frame", {
        Name = "Main",
        Size = UDim2.new(0, 0, 0, 0),
        Position = cfg.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ZIndex = 2,
    })

    Dragify(Main)

    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = Main})

    if cfg.Acrylic then
        Create("ImageLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.97,
            BackgroundColor3 = Theme.Background,
            Image = "rbxassetid://5554236805",
            ImageColor3 = Color3.new(0, 0, 0),
            ImageTransparency = 0.92,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.new(0, 180, 0, 180),
            Parent = Main,
            ZIndex = 0,
        })
    end

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.BackgroundDark,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 3,
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = TopBar})
    Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Theme.BackgroundDark,
        BorderSizePixel = 0,
        Parent = TopBar,
        ZIndex = 3,
    })

    local TitleContainer = Create("Frame", {
        Size = UDim2.new(1, -150, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar,
        ZIndex = 4,
    })

    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = cfg.Title,
        TextColor3 = Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        Parent = TitleContainer,
        ZIndex = 4,
    })

    Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = cfg.Subtitle,
        TextColor3 = Theme.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        Parent = TitleContainer,
        ZIndex = 4,
    })

    local Controls = Create("Frame", {
        Size = UDim2.new(0, 130, 1, 0),
        Position = UDim2.new(1, -140, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar,
        ZIndex = 4,
    })

    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = Controls,
    })

    local function CreateBtn(icon, color, tooltip)
        local btn = Create("TextButton", {
            Size = UDim2.new(0, 34, 0, 34),
            BackgroundColor3 = Theme.BackgroundLight,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = Controls,
            ZIndex = 5,
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = btn})
        Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = icon,
            TextColor3 = color,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            Parent = btn,
            ZIndex = 6,
        })
        return btn
    end

    local MinBtn = CreateBtn("−", Theme.Text, "Minimize")
    local MaxBtn = CreateBtn("□", Theme.Text, "Maximize")
    local CloseBtn = CreateBtn("×", Theme.Error, "Close")

    local Sidebar = Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, cfg.TabWidth, 1, -52),
        Position = UDim2.new(0, 0, 0, 48),
        BackgroundColor3 = Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 2,
    })

    Create("UICorner", {CornerRadius = UDim.new(0, 0), Parent = Sidebar})
    Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = Sidebar})

    local TabScroll = Create("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        Parent = Sidebar,
        ZIndex = 3,
    })

    Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = TabScroll})
    Create("UIPadding", {PaddingTop = UDim.new(0, 4), Parent = TabScroll})

    local Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -(cfg.TabWidth + 8), 1, -52),
        Position = UDim2.new(0, cfg.TabWidth, 0, 48),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 2,
        ClipsDescendants = true,
    })

    local NotifArea = Create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 360, 1, -60),
        Position = UDim2.new(1, -10, 0, 56),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Parent = Main,
        ZIndex = 10,
    })

    Create("UIListLayout", {
        Padding = UDim.new(0, 10),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = NotifArea,
    })

    local minimized = false
    local maximized = false
    local originalSize = cfg.Size
    local originalPos = cfg.Position
    local originalSidebarSize = UDim2.new(0, cfg.TabWidth, 1, -52)
    local originalContentSize = UDim2.new(1, -(cfg.TabWidth + 8), 1, -52)

    local function UpdateTheme()
        Main.BackgroundColor3 = Theme.Background
        MainStroke.Color = Theme.Border
        TopBar.BackgroundColor3 = Theme.BackgroundDark
        Sidebar.BackgroundColor3 = Theme.Sidebar
    end

    local function SetTheme(themeName)
        if ThemePresets[themeName] then
            Theme = ThemePresets[themeName]
            if cfg.Accent then
                Theme.Accent = cfg.Accent
            end
            UpdateTheme()
        end
    end

    local function Minimize()
        minimized = true
        Tween(Content, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        Tween(Sidebar, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        Tween(Main, {Size = UDim2.new(0, 350, 0, 48)}, 0.2)
    end

    local function Maximize()
        maximized = not maximized
        if maximized then
            Tween(Main, {Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
            Tween(Content, {Size = UDim2.new(1, -20, 1, -60)}, 0.3)
            Tween(Sidebar, {Size = UDim2.new(0, cfg.TabWidth, 1, -60)}, 0.3)
            MaxBtn.Text = "❐"
        else
            Tween(Main, {Size = originalSize, Position = originalPos}, 0.3)
            Tween(Sidebar, {Size = originalSidebarSize}, 0.3)
            Tween(Content, {Size = originalContentSize}, 0.3)
            MaxBtn.Text = "□"
        end
    end

    local function Close()
        Window.Running = false
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
        Tween(Main, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.25)
        task.delay(0.25, function()
            ScreenGui:Destroy()
        end)
    end

    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.CardHover}, 0.1) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1) end)
    MaxBtn.MouseEnter:Connect(function() Tween(MaxBtn, {BackgroundColor3 = Theme.CardHover}, 0.1) end)
    MaxBtn.MouseLeave:Connect(function() Tween(MaxBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1) end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}, 0.1) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1) end)

    MinBtn.MouseButton1Click:Connect(Minimize)
    MaxBtn.MouseButton1Click:Connect(Maximize)
    CloseBtn.MouseButton1Click:Connect(Close)

    UIS.InputBegan:Connect(function(input, processed)
        if input.KeyCode == cfg.MinimizeKey and not processed then
            if minimized then
                minimized = false
                Tween(Sidebar, {Size = originalSidebarSize}, 0.2)
                Tween(Content, {Size = originalContentSize}, 0.2)
                Tween(Main, {Size = originalSize}, 0.2)
            else
                Minimize()
            end
        end
        if cfg.ToggleKey and input.KeyCode == cfg.ToggleKey and not processed then
            Window:Toggle()
        end
    end)

    Tween(Main, {Size = cfg.Size}, 0.35, Enum.EasingStyle.Back)

    function Window:AddTab(config)
        local Tab = {}
        Tab.Name = config.Title or "Tab"
        Tab.Elements = {}

        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, 44),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundColor3 = Theme.BackgroundLight,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = TabScroll,
            ZIndex = 4,
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabBtn})

        Create("TextLabel", {
            Size = UDim2.new(0, 24, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Icon or "●",
            TextColor3 = Theme.TextMuted,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = TabBtn,
            ZIndex = 5,
        })

        Create("TextLabel", {
            Size = UDim2.new(1, -44, 1, 0),
            Position = UDim2.new(0, 38, 0, 0),
            BackgroundTransparency = 1,
            Text = Tab.Name,
            TextColor3 = Theme.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            Parent = TabBtn,
            ZIndex = 5,
        })

        local TabContent = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Theme.Border,
            ScrollBarImageTransparency = 0.5,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = Content,
            Visible = false,
            ZIndex = 2,
        })

        Create("UIListLayout", {Padding = UDim.new(0, 16), Parent = TabContent})
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 20),
            Parent = TabContent,
        })

        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.Accent then
                Tween(TabBtn, {BackgroundColor3 = Theme.CardHover}, 0.1)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundColor3 ~= Theme.Accent then
                Tween(TabBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1)
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                local children = Window.CurrentTab.Btn:GetChildren()
                for _, c in ipairs(children) do
                    if c:IsA("TextLabel") then
                        c.TextColor3 = Theme.TextMuted
                    end
                end
                Window.CurrentTab.Btn.BackgroundColor3 = Theme.BackgroundLight
            end
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent
            for _, c in ipairs(TabBtn:GetChildren()) do
                if c:IsA("TextLabel") then
                    c.TextColor3 = Color3.new(1, 1, 1)
                end
            end
            Window.CurrentTab = {Content = TabContent, Btn = TabBtn}
        end)

        Tab.Content = TabContent
        Tab.Btn = TabBtn

        function Tab:AddSection(name, config)
            local Section = {}
            Section.Name = name or "Section"
            Section.Elements = {}

            local collapsed = config and config.Collapsible
            local isCollapsed = false

            local SectionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Theme.Card,
                BorderSizePixel = 0,
                Parent = TabContent,
                ZIndex = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = SectionFrame})
            Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = SectionFrame})

            local SectionHeader = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Parent = SectionFrame,
                ZIndex = 3,
            })

            Create("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0),
                BackgroundTransparency = 1,
                Text = Section.Name,
                TextColor3 = Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 15,
                Font = Enum.Font.GothamBold,
                Parent = SectionHeader,
                ZIndex = 3,
            })

            Create("TextLabel", {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(1, -18, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Text = "◆",
                TextColor3 = Theme.Accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Parent = SectionHeader,
                ZIndex = 3,
            })

            if collapsed then
                local collapseBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = SectionHeader,
                    ZIndex = 4,
                })
                collapseBtn.MouseButton1Click:Connect(function()
                    isCollapsed = not isCollapsed
                    for _, c in ipairs(SectionFrame:GetChildren()) do
                        if c ~= SectionHeader and c:IsA("Frame") then
                            c.Visible = not isCollapsed
                        end
                    end
                end)
            end

            local ContentFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                Parent = SectionFrame,
                ZIndex = 3,
                AutomaticSize = Enum.AutomaticSize.Y,
            })

            Create("UIListLayout", {Padding = UDim.new(0, 8), Parent = ContentFrame})
            Create("UIPadding", {
                PaddingTop = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 14),
                PaddingRight = UDim.new(0, 14),
                PaddingBottom = UDim.new(0, 14),
                Parent = ContentFrame,
            })

            Section.Container = SectionFrame
            Section.Content = ContentFrame

            function Section:AddLabel(cfg)
                return Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Text = cfg.Text or "",
                    TextColor3 = cfg.Color or Theme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = cfg.TextSize or 13,
                    Font = cfg.Font or Enum.Font.Gotham,
                    Parent = ContentFrame,
                    ZIndex = 3,
                    TextTruncate = cfg.Truncate,
                })
            end

            function Section:AddButton(cfg)
                local btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 44),
                    BackgroundColor3 = Theme.BackgroundLight,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = btn})

                if cfg.Icon then
                    Create("TextLabel", {
                        Size = UDim2.new(0, 24, 0, 24),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Text = cfg.Icon,
                        TextColor3 = cfg.IconColor or Theme.Accent,
                        TextSize = 16,
                        Font = Enum.Font.GothamBold,
                        Parent = btn,
                        ZIndex = 4,
                    })
                    Create("TextLabel", {
                        Size = UDim2.new(1, -50, 1, 0),
                        Position = UDim2.new(0, 44, 0, 0),
                        BackgroundTransparency = 1,
                        Text = cfg.Title or "Button",
                        TextColor3 = Theme.Text,
                        TextSize = 14,
                        Font = Enum.Font.GothamBold,
                        Parent = btn,
                        ZIndex = 4,
                    })
                else
                    Create("TextLabel", {
                        Size = UDim2.new(1, -16, 1, 0),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Text = cfg.Title or "Button",
                        TextColor3 = Theme.Text,
                        TextSize = 14,
                        Font = Enum.Font.GothamBold,
                        Parent = btn,
                        ZIndex = 4,
                    })
                end

                btn.MouseEnter:Connect(function()
                    Tween(btn, {BackgroundColor3 = Theme.CardHover}, 0.1)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1)
                end)
                btn.MouseButton1Click:Connect(function()
                    if cfg.Callback then
                        pcall(cfg.Callback)
                    end
                end)

                return btn
            end

            function Section:AddToggle(cfg)
                local Toggle = {}
                local state = cfg.Default or false
                local flag = cfg.Flag

                if flag then
                    if cfg.getgenv then
                        getgenv()[flag] = state
                    else
                        Window.Flags[flag] = state
                    end
                end

                local ToggleFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })

                local ToggleContent = Create("Frame", {
                    Size = UDim2.new(1, -60, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = ToggleFrame,
                    ZIndex = 4,
                })

                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text = cfg.Title or "Toggle",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = ToggleContent,
                    ZIndex = 4,
                })

                if cfg.Description then
                    Label.Size = UDim2.new(1, 0, 0, 18)
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 16),
                        Position = UDim2.new(0, 0, 0, 18),
                        BackgroundTransparency = 1,
                        Text = cfg.Description,
                        TextColor3 = Theme.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        Parent = ToggleContent,
                        ZIndex = 4,
                    })
                end

                local ToggleBox = Create("TextButton", {
                    Size = UDim2.new(0, 52, 0, 30),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Theme.Toggle,
                    BorderSizePixel = 0,
                    Text = "",
                    Parent = ToggleFrame,
                    ZIndex = 5,
                    AutoButtonColor = false,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleBox})

                local ToggleKnob = Create("Frame", {
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = state and UDim2.new(1, -7, 0.5, 0) or UDim2.new(0, 7, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Parent = ToggleBox,
                    ZIndex = 6,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = ToggleKnob})

                local function update(animate)
                    if flag then
                        if cfg.getgenv then
                            getgenv()[flag] = state
                        else
                            Window.Flags[flag] = state
                        end
                    end
                    local targetColor = state and Theme.Accent or Theme.Toggle
                    local targetPos = state and UDim2.new(1, -7, 0.5, 0) or UDim2.new(0, 7, 0.5, 0)
                    if animate then
                        Tween(ToggleBox, {BackgroundColor3 = targetColor}, 0.2)
                        Tween(ToggleKnob, {Position = targetPos}, 0.2)
                    else
                        ToggleBox.BackgroundColor3 = targetColor
                        ToggleKnob.Position = targetPos
                    end
                end

                update(false)
                ToggleBox.MouseButton1Click:Connect(function()
                    state = not state
                    update(true)
                    if cfg.Callback then
                        pcall(cfg.Callback, state)
                    end
                end)

                function Toggle:Set(val)
                    state = val
                    update(true)
                end
                function Toggle:Get()
                    return state
                end
                function Toggle:Destroy()
                    ToggleFrame:Destroy()
                end

                return Toggle
            end

            function Section:AddSlider(cfg)
                local Slider = {}
                local min, max = cfg.Min or 0, cfg.Max or 100
                local value = cfg.Default or min
                local step = cfg.Step or 1
                local flag = cfg.Flag

                if flag then
                    Window.Flags[flag] = value
                end

                local SliderFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 68),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })

                local SliderHeader = Create("Frame", {
                    Size = UDim2.new(1, -60, 0, 22),
                    BackgroundTransparency = 1,
                    Parent = SliderFrame,
                    ZIndex = 4,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = cfg.Title or "Slider",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = SliderHeader,
                    ZIndex = 4,
                })

                local SliderValue = Create("TextBox", {
                    Size = UDim2.new(0, 54, 1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Theme.BackgroundDark,
                    BorderSizePixel = 0,
                    Text = tostring(value),
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    Parent = SliderHeader,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SliderValue})

                local SliderTrack = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 10),
                    Position = UDim2.new(0, 0, 0, 36),
                    BackgroundColor3 = Theme.Toggle,
                    BorderSizePixel = 0,
                    Parent = SliderFrame,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = SliderTrack})

                local SliderFill = Create("Frame", {
                    Size = UDim2.new(math.max(0, (value - min) / (max - min)), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = SliderTrack,
                    ZIndex = 6,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = SliderFill})

                local SliderKnob = Create("Frame", {
                    Size = UDim2.new(0, 22, 0, 22),
                    Position = UDim2.new(math.max(0, (value - min) / (max - min)), -11, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Parent = SliderTrack,
                    ZIndex = 7,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = SliderKnob})
                Create("UIStroke", {Color = Theme.Accent, Thickness = 2, Parent = SliderKnob})

                if cfg.Suffix then
                    Create("TextLabel", {
                        Size = UDim2.new(0, 30, 0, 16),
                        Position = UDim2.new(1, -54, 0, 40),
                        AnchorPoint = Vector2.new(1, 0),
                        BackgroundTransparency = 1,
                        Text = cfg.Suffix,
                        TextColor3 = Theme.TextMuted,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        Parent = SliderFrame,
                        ZIndex = 4,
                    })
                end

                local dragging = false
                local function updateSlider(input)
                    local rel = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                    value = math.floor(min + (max - min) * rel + 0.5)
                    value = math.max(min, math.min(max, value))
                    if flag then Window.Flags[flag] = value end
                    local pct = (value - min) / (max - min)
                    SliderFill.Size = UDim2.new(pct, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
                    SliderValue.Text = tostring(value)
                end

                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                        if cfg.Callback then pcall(cfg.Callback, value) end
                    end
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                SliderValue.FocusLost:Connect(function()
                    local n = tonumber(SliderValue.Text)
                    if n then
                        value = math.max(min, math.min(max, math.floor(n)))
                        local pct = (value - min) / (max - min)
                        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
                        SliderKnob.Position = UDim2.new(pct, 0, 0.5, 0)
                        SliderValue.Text = tostring(value)
                        if flag then Window.Flags[flag] = value end
                    else
                        SliderValue.Text = tostring(value)
                    end
                end)

                function Slider:Set(val)
                    value = math.max(min, math.min(max, val))
                    if flag then Window.Flags[flag] = value end
                    local pct = (value - min) / (max - min)
                    Tween(SliderFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
                    Tween(SliderKnob, {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.1)
                    SliderValue.Text = tostring(value)
                end
                function Slider:Get() return value end
                function Slider:Destroy() SliderFrame:Destroy() end

                return Slider
            end

            function Section:AddDropdown(cfg)
                local Dropdown = {}
                local items = cfg.Items or {}
                local selected = cfg.Default or nil
                local open = false
                local flag = cfg.Flag

                if flag then Window.Flags[flag] = selected end

                local DropdownFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })

                local DropdownContent = Create("Frame", {
                    Size = UDim2.new(1, -48, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = DropdownFrame,
                    ZIndex = 4,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text = cfg.Title or "Dropdown",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = DropdownContent,
                    ZIndex = 4,
                })

                local DropdownValue = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = selected or "Select...",
                    TextColor3 = selected and Theme.Text or Theme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    Parent = DropdownContent,
                    ZIndex = 4,
                })

                local DropdownBtn = Create("TextButton", {
                    Size = UDim2.new(0, 42, 0, 42),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Theme.BackgroundLight,
                    BorderSizePixel = 0,
                    Text = "▼",
                    TextColor3 = Theme.TextMuted,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Parent = DropdownFrame,
                    AutoButtonColor = false,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = DropdownBtn})

                local DropdownList = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 52),
                    BackgroundColor3 = Theme.Card,
                    BorderSizePixel = 0,
                    Visible = false,
                    ClipsDescendants = true,
                    Parent = DropdownFrame,
                    ZIndex = 10,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = DropdownList})
                Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = DropdownList})

                local DropdownScroll = Create("ScrollingFrame", {
                    Size = UDim2.new(1, -4, 1, -4),
                    Position = UDim2.new(0, 2, 0, 2),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 0,
                    ScrollBarImageTransparency = 1,
                    Parent = DropdownList,
                    ZIndex = 11,
                })
                Create("UIListLayout", {Padding = UDim.new(0, 2), Parent = DropdownScroll})
                Create("UIPadding", {PaddingAll = UDim.new(0, 4), Parent = DropdownScroll})

                DropdownBtn.MouseButton1Click:Connect(function()
                    open = not open
                    DropdownList.Visible = open
                    if open then
                        local h = math.min(#items * 36 + 8, 240)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, h)}, 0.2, Enum.EasingStyle.Back)
                        Tween(DropdownBtn, {Rotation = 180}, 0.2)
                    else
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        Tween(DropdownBtn, {Rotation = 0}, 0.2)
                    end
                end)

                local function addItem(item, idx)
                    local itemBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 32),
                        BackgroundTransparency = 1,
                        Text = item,
                        TextColor3 = Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 13,
                        Font = Enum.Font.Gotham,
                        Parent = DropdownScroll,
                        ZIndex = 12,
                        AutoButtonColor = false,
                    })
                    Create("UIPadding", {PaddingLeft = UDim.new(0, 12), Parent = itemBtn})

                    itemBtn.MouseEnter:Connect(function()
                        Tween(itemBtn, {BackgroundColor3 = Theme.CardHover}, 0.1)
                    end)
                    itemBtn.MouseLeave:Connect(function()
                        Tween(itemBtn, {BackgroundTransparency = 1}, 0.1)
                    end)

                    itemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        if flag then Window.Flags[flag] = item end
                        DropdownValue.Text = item
                        DropdownValue.TextColor3 = Theme.Text
                        open = false
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        Tween(DropdownBtn, {Rotation = 0}, 0.2)
                        task.delay(0.15, function()
                            DropdownList.Visible = false
                        end)
                        if cfg.Callback then pcall(cfg.Callback, item, idx) end
                    end)
                end

                for i, v in ipairs(items) do
                    addItem(v, i)
                end

                function Dropdown:AddItem(item)
                    table.insert(items, item)
                    addItem(item, #items)
                end
                function Dropdown:Clear()
                    items = {}
                    selected = nil
                    if flag then Window.Flags[flag] = nil end
                    DropdownValue.Text = "Select..."
                    DropdownValue.TextColor3 = Theme.TextMuted
                    for _, c in ipairs(DropdownScroll:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                end
                function Dropdown:Get() return selected end
                function Dropdown:Set(val)
                    selected = val
                    if flag then Window.Flags[flag] = val end
                    DropdownValue.Text = val or "Select..."
                    DropdownValue.TextColor3 = val and Theme.Text or Theme.TextMuted
                end
                function Dropdown:Destroy() DropdownFrame:Destroy() end

                return Dropdown
            end

            function Section:AddInput(cfg)
                local Input = {}
                local flag = cfg.Flag
                if flag then Window.Flags[flag] = cfg.Default or "" end

                local InputFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })

                local InputContent = Create("Frame", {
                    Size = UDim2.new(1, -56, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = InputFrame,
                    ZIndex = 4,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text = cfg.Title or "Input",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = InputContent,
                    ZIndex = 4,
                })

                local InputBox = Create("TextBox", {
                    Size = UDim2.new(1, 0, 0, 32),
                    Position = UDim2.new(0, 0, 0, 22),
                    BackgroundColor3 = Theme.BackgroundDark,
                    BorderSizePixel = 0,
                    Text = cfg.Default or "",
                    PlaceholderText = cfg.Placeholder or "Enter text...",
                    PlaceholderColor3 = Theme.TextMuted,
                    TextColor3 = Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    Parent = InputContent,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = InputBox})

                local InputStroke = Create("UIStroke", {
                    Color = Theme.Accent,
                    Thickness = 0,
                    Parent = InputBox,
                })

                local ClearBtn = Create("TextButton", {
                    Size = UDim2.new(0, 42, 0, 42),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Theme.BackgroundLight,
                    BorderSizePixel = 0,
                    Text = "×",
                    TextColor3 = Theme.TextMuted,
                    TextSize = 18,
                    Font = Enum.Font.GothamBold,
                    Parent = InputFrame,
                    Visible = false,
                    ZIndex = 5,
                    AutoButtonColor = false,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = ClearBtn})

                InputBox.Focused:Connect(function()
                    Tween(InputStroke, {Thickness = 2}, 0.15)
                    ClearBtn.Visible = #InputBox.Text > 0
                end)

                InputBox.FocusLost:Connect(function()
                    Tween(InputStroke, {Thickness = 0}, 0.15)
                    ClearBtn.Visible = false
                    if flag then Window.Flags[flag] = InputBox.Text end
                    if cfg.Callback then pcall(cfg.Callback, InputBox.Text) end
                end)

                InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    ClearBtn.Visible = #InputBox.Text > 0 and InputBox:IsFocused()
                end)

                ClearBtn.MouseButton1Click:Connect(function()
                    InputBox.Text = ""
                    ClearBtn.Visible = false
                    if flag then Window.Flags[flag] = "" end
                    if cfg.Callback then pcall(cfg.Callback, "") end
                end)

                function Input:Get() return InputBox.Text end
                function Input:Set(text)
                    InputBox.Text = text
                    if flag then Window.Flags[flag] = text end
                end
                function Input:Destroy() InputFrame:Destroy() end

                return Input
            end

            function Section:AddKeybind(cfg)
                local Keybind = {}
                local currentKey = cfg.Default or Enum.KeyCode.Unknown
                local flag = cfg.Flag
                if flag then Window.Flags[flag] = currentKey end

                local KeybindFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 48),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })

                local KeybindContent = Create("Frame", {
                    Size = UDim2.new(1, -110, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = KeybindFrame,
                    ZIndex = 4,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22),
                    BackgroundTransparency = 1,
                    Text = cfg.Title or "Keybind",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = KeybindContent,
                    ZIndex = 4,
                })

                if cfg.Description then
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 16),
                        Position = UDim2.new(0, 0, 0, 20),
                        BackgroundTransparency = 1,
                        Text = cfg.Description,
                        TextColor3 = Theme.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        Parent = KeybindContent,
                        ZIndex = 4,
                    })
                end

                local KeybindBtn = Create("TextButton", {
                    Size = UDim2.new(0, 100, 0, 38),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = Theme.BackgroundLight,
                    BorderSizePixel = 0,
                    Text = currentKey.Name or "None",
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Parent = KeybindFrame,
                    AutoButtonColor = false,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = KeybindBtn})

                local binding = false

                KeybindBtn.MouseButton1Click:Connect(function()
                    binding = true
                    KeybindBtn.Text = "..."
                    Tween(KeybindBtn, {BackgroundColor3 = Theme.Accent}, 0.1)
                end)

                UIS.InputBegan:Connect(function(input, processed)
                    if binding then
                        if input.KeyCode ~= Enum.KeyCode.Unknown then
                            currentKey = input.KeyCode
                            if flag then Window.Flags[flag] = currentKey end
                            KeybindBtn.Text = currentKey.Name
                            Tween(KeybindBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1)
                            binding = false
                        end
                    elseif input.KeyCode == currentKey and not processed then
                        if cfg.Callback then pcall(cfg.Callback) end
                    end
                end)

                function Keybind:Set(key)
                    currentKey = key
                    if flag then Window.Flags[flag] = key end
                    KeybindBtn.Text = key.Name or "None"
                end
                function Keybind:Get() return currentKey end
                function Keybind:Destroy() KeybindFrame:Destroy() end

                return Keybind
            end

            function Section:AddColorPicker(cfg)
                local Picker = {}
                local color = cfg.Default or Color3.fromRGB(255, 255, 255)
                local flag = cfg.Flag
                if flag then Window.Flags[flag] = color end

                local PickerFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 58),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, -58, 0, 22),
                    BackgroundTransparency = 1,
                    Text = cfg.Title or "Color",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = PickerFrame,
                    ZIndex = 4,
                })

                local ColorPreview = Create("Frame", {
                    Size = UDim2.new(0, 48, 0, 30),
                    Position = UDim2.new(0, 0, 0, 26),
                    BackgroundColor3 = color,
                    BorderSizePixel = 0,
                    Parent = PickerFrame,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ColorPreview})

                local HexBox = Create("TextBox", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 54, 0, 26),
                    BackgroundColor3 = Theme.BackgroundDark,
                    BorderSizePixel = 0,
                    Text = "#" .. color:ToHex(),
                    TextColor3 = Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    Parent = PickerFrame,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = HexBox})

                function Picker:Set(c)
                    color = c
                    if flag then Window.Flags[flag] = c end
                    ColorPreview.BackgroundColor3 = c
                    HexBox.Text = "#" .. c:ToHex()
                end
                function Picker:Get() return color end
                function Picker:Destroy() PickerFrame:Destroy() end

                return Picker
            end

            function Section:AddLine(cfg)
                Create("Frame", {
                    Size = UDim2.new(1, 0, 0, cfg and cfg.Height or 1),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                })
                if cfg and cfg.Line then
                    Create("Frame", {
                        Size = UDim2.new(1, 0, 0, 1),
                        Position = UDim2.new(0, 0, 0.5, 0),
                        BackgroundColor3 = Theme.Border,
                        BorderSizePixel = 0,
                        Parent = ContentFrame,
                        ZIndex = 4,
                    })
                end
            end

            function Section:AddParagraph(cfg)
                local ParagraphFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = ContentFrame,
                    ZIndex = 3,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    Text = cfg.Title or "",
                    TextColor3 = Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    Parent = ParagraphFrame,
                    ZIndex = 3,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = cfg.Text or "",
                    TextColor3 = Theme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextWrapped = true,
                    Parent = ParagraphFrame,
                    ZIndex = 3,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })

                return ParagraphFrame
            end

            return Section
        end

        table.insert(Window.Tabs, Tab)
        table.insert(Window.Elements, Tab)

        if #Window.Tabs == 1 then
            TabBtn.BackgroundColor3 = Theme.Accent
            for _, c in ipairs(TabBtn:GetChildren()) do
                if c:IsA("TextLabel") then
                    c.TextColor3 = Color3.new(1, 1, 1)
                end
            end
            TabContent.Visible = true
            Window.CurrentTab = {Content = TabContent, Btn = TabBtn}
        end

        return Tab
    end

    function Window:Notify(cfg)
        local notif = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Theme.Card,
            BorderSizePixel = 0,
            Parent = NotifArea,
            ZIndex = 15,
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = notif})

        local strokeColor = Theme.Accent
        if cfg.Type == "Success" then strokeColor = Theme.Success
        elseif cfg.Type == "Warning" then strokeColor = Theme.Warning
        elseif cfg.Type == "Error" then strokeColor = Theme.Error
        end
        Create("UIStroke", {Color = strokeColor, Thickness = 2, Parent = notif})

        local iconTxt = "ℹ"
        if cfg.Type == "Success" then iconTxt = "✓"
        elseif cfg.Type == "Warning" then iconTxt = "⚠"
        elseif cfg.Type == "Error" then iconTxt = "✕"
        end

        Create("TextLabel", {
            Size = UDim2.new(0, 32, 0, 32),
            Position = UDim2.new(0, 12, 0, 12),
            BackgroundTransparency = 1,
            Text = iconTxt,
            TextColor3 = strokeColor,
            TextSize = 20,
            Font = Enum.Font.GothamBold,
            Parent = notif,
            ZIndex = 16,
        })

        Create("TextLabel", {
            Size = UDim2.new(1, -52, 0, 20),
            Position = UDim2.new(0, 50, 0, 12),
            BackgroundTransparency = 1,
            Text = cfg.Title or "Notification",
            TextColor3 = Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = notif,
            ZIndex = 16,
        })

        Create("TextLabel", {
            Size = UDim2.new(1, -52, 0, 28),
            Position = UDim2.new(0, 50, 0, 32),
            BackgroundTransparency = 1,
            Text = cfg.Description or "",
            TextColor3 = Theme.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = notif,
            ZIndex = 16,
        })

        Tween(notif, {Size = UDim2.new(1, 0, 0, 76)}, 0.25, Enum.EasingStyle.Back)

        task.delay(cfg.Duration or 4, function()
            if notif and notif.Parent then
                Tween(notif, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.2)
                for _, c in ipairs(notif:GetChildren()) do
                    if c:IsA("TextLabel") then
                        Tween(c, {TextTransparency = 1}, 0.2)
                    end
                end
                task.delay(0.2, function()
                    if notif then notif:Destroy() end
                end)
            end
        end)

        return notif
    end

    function Window:SelectTab(name)
        for _, tab in ipairs(Window.Tabs) do
            if tab.Name == name then
                tab.Btn:ClickButton1()
                break
            end
        end
    end

    function Window:Toggle()
        minimized = not minimized
        if minimized then
            Minimize()
        else
            Tween(Sidebar, {Size = originalSidebarSize}, 0.2)
            Tween(Content, {Size = originalContentSize}, 0.2)
            Tween(Main, {Size = originalSize}, 0.2)
        end
    end

    function Window:SetTheme(themeName)
        SetTheme(themeName)
    end

    function Window:Minimize()
        Minimize()
    end

    function Window:Maximize()
        Maximize()
    end

    function Window:Close()
        Close()
    end

    function Window:GetFlags()
        return Window.Flags
    end

    function Window:IsRunning()
        return Window.Running
    end

    Window.Main = Main
    Window.ScreenGui = ScreenGui
    Window.Theme = Theme
    return Window
end

return Phat
