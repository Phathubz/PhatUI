--[[
    Phat UI Library v2.0
    A premium Roblox UI library with modern design
]]

local Phat = {}
Phat.__index = Phat

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local EASING_STYLE = Enum.EasingStyle.Quad
local EASING_DIR = Enum.EasingDirection.Out

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

local function Tween(obj, props, duration)
    duration = duration or 0.25
    local tween = TweenService:Create(obj, TweenInfo.new(duration, EASING_STYLE, EASING_DIR), props)
    tween:Play()
    return tween
end

local function Dragify(frame)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local absPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Tween(frame, {Position = absPos}, 0.1)
    end

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
            update(input)
        end
    end)
end

local ThemePresets = {
    Dark = {
        Background = Color3.fromRGB(15, 15, 15),
        BackgroundDark = Color3.fromRGB(10, 10, 10),
        BackgroundLight = Color3.fromRGB(20, 20, 20),
        Card = Color3.fromRGB(22, 22, 25),
        CardHover = Color3.fromRGB(28, 28, 32),
        Sidebar = Color3.fromRGB(12, 12, 14),
        Border = Color3.fromRGB(40, 40, 48),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(140, 140, 150),
        Accent = Color3.fromRGB(88, 166, 255),
        AccentDark = Color3.fromRGB(60, 120, 200),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(50, 50, 58),
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        BackgroundDark = Color3.fromRGB(235, 235, 240),
        BackgroundLight = Color3.fromRGB(255, 255, 255),
        Card = Color3.fromRGB(255, 255, 255),
        CardHover = Color3.fromRGB(248, 248, 252),
        Sidebar = Color3.fromRGB(240, 240, 245),
        Border = Color3.fromRGB(220, 220, 230),
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
        Background = Color3.fromRGB(5, 5, 10),
        BackgroundDark = Color3.fromRGB(3, 3, 6),
        BackgroundLight = Color3.fromRGB(10, 10, 15),
        Card = Color3.fromRGB(12, 12, 18),
        CardHover = Color3.fromRGB(18, 18, 25),
        Sidebar = Color3.fromRGB(8, 8, 12),
        Border = Color3.fromRGB(30, 30, 45),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(100, 100, 120),
        Accent = Color3.fromRGB(140, 80, 255),
        AccentDark = Color3.fromRGB(100, 50, 200),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(35, 35, 50),
    },
    Ocean = {
        Background = Color3.fromRGB(10, 20, 35),
        BackgroundDark = Color3.fromRGB(5, 12, 25),
        BackgroundLight = Color3.fromRGB(15, 28, 45),
        Card = Color3.fromRGB(18, 30, 48),
        CardHover = Color3.fromRGB(25, 40, 60),
        Sidebar = Color3.fromRGB(8, 15, 28),
        Border = Color3.fromRGB(35, 60, 90),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(120, 160, 200),
        Accent = Color3.fromRGB(80, 200, 255),
        AccentDark = Color3.fromRGB(50, 150, 220),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(40, 70, 100),
    },
    Sunset = {
        Background = Color3.fromRGB(25, 15, 20),
        BackgroundDark = Color3.fromRGB(18, 10, 14),
        BackgroundLight = Color3.fromRGB(35, 22, 28),
        Card = Color3.fromRGB(38, 25, 32),
        CardHover = Color3.fromRGB(48, 32, 42),
        Sidebar = Color3.fromRGB(20, 12, 16),
        Border = Color3.fromRGB(70, 45, 55),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(180, 140, 150),
        Accent = Color3.fromRGB(255, 120, 150),
        AccentDark = Color3.fromRGB(200, 80, 110),
        Success = Color3.fromRGB(60, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Toggle = Color3.fromRGB(80, 50, 60),
    }
}

function Phat:CreateWindow(config)
    local Window = {}
    Window.Elements = {}
    Window.Flags = {}
    Window.Tabs = {}
    Window.CurrentTab = nil

    local cfg = {
        Title = config.Title or "Phat UI",
        Subtitle = config.Subtitle or "",
        TabWidth = config.TabWidth or 160,
        Size = config.Size or UDim2.fromOffset(620, 480),
        Position = config.Position or UDim2.fromScale(0.5, 0.5),
        Acrylic = config.Acrylic or false,
        Theme = config.Theme or "Dark",
        Accent = config.Accent or nil,
        MinimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl,
        ToggleKey = config.ToggleKey or nil,
        Watermark = config.Watermark or false,
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

    local MainCorner = Create("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    local MainStroke = Create("UIStroke", {Color = Theme.Border, Thickness = 1, Parent = Main})

    if cfg.Acrylic then
        local Blur = Create("ImageLabel", {
            Name = "AcrylicBlur",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 0.95,
            BackgroundColor3 = Theme.Background,
            Image = "rbxassetid://5554236805",
            ImageColor3 = Color3.new(0, 0, 0),
            ImageTransparency = 0.9,
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
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = Theme.BackgroundDark,
        BorderSizePixel = 0,
        Parent = TopBar,
        ZIndex = 3,
    })

    local TitleContainer = Create("Frame", {
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar,
        ZIndex = 4,
    })

    local TitleText = Create("TextLabel", {
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

    local SubtitleText = Create("TextLabel", {
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
        Size = UDim2.new(0, 90, 1, 0),
        Position = UDim2.new(1, -100, 0, 0),
        BackgroundTransparency = 1,
        Parent = TopBar,
        ZIndex = 4,
    })

    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = Controls,
    })

    local function CreateBtn(name, icon, color)
        local btn = Create("TextButton", {
            Size = UDim2.new(0, 32, 0, 32),
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

    local MinBtn = CreateBtn("Minimize", "−", Theme.Text)
    local CloseBtn = CreateBtn("Close", "×", Theme.Error)

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
        Size = UDim2.new(0, 340, 1, -60),
        Position = UDim2.new(1, -10, 0, 56),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Parent = Main,
        ZIndex = 10,
    })

    Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = NotifArea,
    })

    local minimized = false

    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.CardHover}, 0.1)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1)
    end)
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}, 0.1)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Tween(Content, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            Tween(Sidebar, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            Tween(Main, {Size = UDim2.new(0, 350, 0, 48)}, 0.2)
        else
            Tween(Sidebar, {Size = UDim2.new(0, cfg.TabWidth, 1, -52)}, 0.2)
            Tween(Content, {Size = UDim2.new(1, -(cfg.TabWidth + 8), 1, -52)}, 0.2)
            Tween(Main, {Size = cfg.Size}, 0.2)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(Main, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.3)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)

    Tween(Main, {Size = cfg.Size}, 0.35)

    function Window:AddTab(config)
        local Tab = {}
        Tab.Name = config.Title or "Tab"
        Tab.Elements = {}

        local TabBtn = Create("TextButton", {
            Size = UDim2.new(1, -8, 0, 42),
            Position = UDim2.new(0, 4, 0, 0),
            BackgroundColor3 = Theme.BackgroundLight,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = TabScroll,
            ZIndex = 4,
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = TabBtn})

        local TabIcon = Create("TextLabel", {
            Size = UDim2.new(0, 24, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = config.Icon or "■",
            TextColor3 = Theme.TextMuted,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = TabBtn,
            ZIndex = 5,
        })

        local TabLabel = Create("TextLabel", {
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

        Create("UIListLayout", {Padding = UDim.new(0, 14), Parent = TabContent})
        Create("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
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
                Window.CurrentTab.Btn.BackgroundColor3 = Theme.BackgroundLight
                Window.CurrentTab.Btn.Icon.TextColor3 = Theme.TextMuted
                Window.CurrentTab.Btn.Label.TextColor3 = Theme.TextMuted
            end
            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent
            TabIcon.TextColor3 = Color3.new(1, 1, 1)
            TabLabel.TextColor3 = Color3.new(1, 1, 1)
            Window.CurrentTab = {Content = TabContent, Btn = TabBtn, Icon = TabIcon, Label = TabLabel}
        end)

        Tab.Content = TabContent
        Tab.Btn = TabBtn
        Tab.Icon = TabIcon
        Tab.Label = TabLabel

        function Tab:AddSection(name)
            local Section = {}
            Section.Name = name or "Section"
            Section.Elements = {}

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
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundTransparency = 1,
                Parent = SectionFrame,
                ZIndex = 3,
            })

            Create("TextLabel", {
                Size = UDim2.new(1, -24, 1, 0),
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

            Create("UIListLayout", {Padding = UDim.new(0, 6), Parent = SectionFrame})
            Create("UIPadding", {
                PaddingTop = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 14),
                PaddingRight = UDim.new(0, 14),
                PaddingBottom = UDim.new(0, 12),
                Parent = SectionFrame,
            })

            Section.Container = SectionFrame

            function Section:AddLabel(cfg)
                local Label = Create("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Text = cfg.Text or "",
                    TextColor3 = cfg.Color or Theme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = cfg.TextSize or 13,
                    Font = cfg.Font or Enum.Font.Gotham,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })
                return Label
            end

            function Section:AddButton(cfg)
                local btn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 42),
                    BackgroundColor3 = Theme.BackgroundLight,
                    BorderSizePixel = 0,
                    Text = cfg.Title or "Button",
                    TextColor3 = Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    Parent = SectionFrame,
                    ZIndex = 3,
                    AutoButtonColor = false,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 10), Parent = btn})

                btn.MouseEnter:Connect(function()
                    Tween(btn, {BackgroundColor3 = Theme.CardHover}, 0.1)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1)
                end)
                btn.MouseButton1Click:Connect(function()
                    pcall(cfg.Callback)
                end)

                return btn
            end

            function Section:AddToggle(cfg)
                local Toggle = {}
                local state = cfg.Default or false
                Window.Flags[cfg.Flag] = state

                local ToggleFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local ToggleContent = Create("Frame", {
                    Size = UDim2.new(1, -58, 1, 0),
                    BackgroundTransparency = 1,
                    Parent = ToggleFrame,
                    ZIndex = 4,
                })

                Create("TextLabel", {
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
                    Create("TextLabel", {
                        Size = UDim2.new(1, 0, 0, 16),
                        Position = UDim2.new(0, 0, 0, 20),
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
                    Size = UDim2.new(0, 50, 0, 28),
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
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = state and UDim2.new(1, -6, 0.5, 0) or UDim2.new(0, 6, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Parent = ToggleBox,
                    ZIndex = 6,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = ToggleKnob})

                local function update(animate)
                    Window.Flags[cfg.Flag] = state
                    local targetColor = state and Theme.Accent or Theme.Toggle
                    local targetPos = state and UDim2.new(1, -6, 0.5, 0) or UDim2.new(0, 6, 0.5, 0)
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
                    pcall(cfg.Callback, state)
                end)

                function Toggle:Set(val)
                    state = val
                    update(true)
                end
                function Toggle:Get()
                    return state
                end

                return Toggle
            end

            function Section:AddSlider(cfg)
                local Slider = {}
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local value = cfg.Default or min
                local step = cfg.Step or 1
                Window.Flags[cfg.Flag] = value

                local SliderFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 64),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local SliderHeader = Create("Frame", {
                    Size = UDim2.new(1, -56, 0, 22),
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
                    Size = UDim2.new(0, 50, 1, 0),
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
                    Size = UDim2.new(1, 0, 0, 8),
                    Position = UDim2.new(0, 0, 0, 34),
                    BackgroundColor3 = Theme.Toggle,
                    BorderSizePixel = 0,
                    Parent = SliderFrame,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SliderTrack})

                local SliderFill = Create("Frame", {
                    Size = UDim2.new(math.max(0, (value - min) / (max - min)), 0, 1, 0),
                    BackgroundColor3 = Theme.Accent,
                    BorderSizePixel = 0,
                    Parent = SliderTrack,
                    ZIndex = 6,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = SliderFill})

                local SliderKnob = Create("Frame", {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(math.max(0, (value - min) / (max - min)), -10, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Parent = SliderTrack,
                    ZIndex = 7,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 7), Parent = SliderKnob})
                Create("UIStroke", {Color = Theme.Accent, Thickness = 2, Parent = SliderKnob})

                local dragging = false
                local function updateSlider(input)
                    local rel = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                    rel = math.clamp(rel, 0, 1)
                    value = math.floor(min + (max - min) * rel + 0.5)
                    value = math.max(min, math.min(max, value))
                    Window.Flags[cfg.Flag] = value
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
                        pcall(cfg.Callback, value)
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
                        Window.Flags[cfg.Flag] = value
                    else
                        SliderValue.Text = tostring(value)
                    end
                end)

                function Slider:Set(val)
                    value = math.max(min, math.min(max, val))
                    Window.Flags[cfg.Flag] = value
                    local pct = (value - min) / (max - min)
                    Tween(SliderFill, {Size = UDim2.new(pct, 0, 1, 0)}, 0.1)
                    Tween(SliderKnob, {Position = UDim2.new(pct, 0, 0.5, 0)}, 0.1)
                    SliderValue.Text = tostring(value)
                end
                function Slider:Get()
                    return value
                end

                return Slider
            end

            function Section:AddDropdown(cfg)
                local Dropdown = {}
                local items = cfg.Items or {}
                local selected = cfg.Default or nil
                local open = false
                Window.Flags[cfg.Flag] = selected

                local DropdownFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local DropdownContent = Create("Frame", {
                    Size = UDim2.new(1, -46, 1, 0),
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
                    Size = UDim2.new(0, 40, 0, 40),
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
                    Position = UDim2.new(0, 0, 0, 50),
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
                        local h = math.min(#items * 34 + 8, 220)
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, h)}, 0.2, Enum.EasingStyle.Back)
                        Tween(DropdownBtn, {Rotation = 180}, 0.2)
                    else
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        Tween(DropdownBtn, {Rotation = 0}, 0.2)
                    end
                end)

                local function addItem(item, idx)
                    local itemBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
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
                    Create("UIPadding", {PaddingLeft = UDim.new(0, 10), Parent = itemBtn})

                    itemBtn.MouseEnter:Connect(function()
                        Tween(itemBtn, {BackgroundColor3 = Theme.CardHover}, 0.1)
                    end)
                    itemBtn.MouseLeave:Connect(function()
                        Tween(itemBtn, {BackgroundTransparency = 1}, 0.1)
                    end)

                    itemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        Window.Flags[cfg.Flag] = item
                        DropdownValue.Text = item
                        DropdownValue.TextColor3 = Theme.Text
                        open = false
                        Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        Tween(DropdownBtn, {Rotation = 0}, 0.2)
                        task.delay(0.15, function()
                            DropdownList.Visible = false
                        end)
                        pcall(cfg.Callback, item, idx)
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
                    Window.Flags[cfg.Flag] = nil
                    DropdownValue.Text = "Select..."
                    DropdownValue.TextColor3 = Theme.TextMuted
                    for _, c in ipairs(DropdownScroll:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                end
                function Dropdown:Get()
                    return selected
                end
                function Dropdown:Set(val)
                    selected = val
                    Window.Flags[cfg.Flag] = val
                    DropdownValue.Text = val or "Select..."
                    DropdownValue.TextColor3 = val and Theme.Text or Theme.TextMuted
                end

                return Dropdown
            end

            function Section:AddInput(cfg)
                local Input = {}
                Window.Flags[cfg.Flag] = cfg.Default or ""

                local InputFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame,
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
                    Size = UDim2.new(1, 0, 0, 30),
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
                    Size = UDim2.new(0, 40, 0, 40),
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
                    Window.Flags[cfg.Flag] = InputBox.Text
                    pcall(cfg.Callback, InputBox.Text)
                end)

                InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    ClearBtn.Visible = #InputBox.Text > 0 and InputBox:IsFocused()
                end)

                ClearBtn.MouseButton1Click:Connect(function()
                    InputBox.Text = ""
                    ClearBtn.Visible = false
                    Window.Flags[cfg.Flag] = ""
                    pcall(cfg.Callback, "")
                end)

                function Input:Get()
                    return InputBox.Text
                end
                function Input:Set(text)
                    InputBox.Text = text
                    Window.Flags[cfg.Flag] = text
                end

                return Input
            end

            function Section:AddKeybind(cfg)
                local Keybind = {}
                local currentKey = cfg.Default or Enum.KeyCode.Unknown
                Window.Flags[cfg.Flag] = currentKey

                local KeybindFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 46),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame,
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
                    Size = UDim2.new(0, 100, 0, 36),
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
                            Window.Flags[cfg.Flag] = currentKey
                            KeybindBtn.Text = currentKey.Name
                            Tween(KeybindBtn, {BackgroundColor3 = Theme.BackgroundLight}, 0.1)
                            binding = false
                        end
                    elseif input.KeyCode == currentKey and not processed then
                        pcall(cfg.Callback)
                    end
                end)

                function Keybind:Set(key)
                    currentKey = key
                    Window.Flags[cfg.Flag] = key
                    KeybindBtn.Text = key.Name or "None"
                end
                function Keybind:Get()
                    return currentKey
                end

                return Keybind
            end

            function Section:AddColorPicker(cfg)
                local Picker = {}
                local color = cfg.Default or Color3.fromRGB(255, 255, 255)
                Window.Flags[cfg.Flag] = color

                local PickerFrame = Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 56),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                Create("TextLabel", {
                    Size = UDim2.new(1, -56, 0, 22),
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
                    Size = UDim2.new(0, 44, 0, 28),
                    Position = UDim2.new(0, 0, 0, 26),
                    BackgroundColor3 = color,
                    BorderSizePixel = 0,
                    Parent = PickerFrame,
                    ZIndex = 5,
                })
                Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = ColorPreview})

                local HexBox = Create("TextBox", {
                    Size = UDim2.new(1, -56, 1, 0),
                    Position = UDim2.new(0, 50, 0, 26),
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
                    Window.Flags[cfg.Flag] = c
                    ColorPreview.BackgroundColor3 = c
                    HexBox.Text = "#" .. c:ToHex()
                end
                function Picker:Get()
                    return color
                end

                return Picker
            end

            function Section:AddDivider(cfg)
                Create("Frame", {
                    Size = UDim2.new(1, 0, 0, cfg and cfg.Height or 18),
                    BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })
            end

            function Section:AddSeparator()
                Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 1),
                    BackgroundColor3 = Theme.Border,
                    BorderSizePixel = 0,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })
            end

            return Section
        end

        table.insert(Window.Tabs, Tab)
        table.insert(Window.Elements, Tab)

        if #Window.Tabs == 1 then
            TabBtn.BackgroundColor3 = Theme.Accent
            TabIcon.TextColor3 = Color3.new(1, 1, 1)
            TabLabel.TextColor3 = Color3.new(1, 1, 1)
            TabContent.Visible = true
            Window.CurrentTab = {Content = TabContent, Btn = TabBtn, Icon = TabIcon, Label = TabLabel}
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
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 12, 0, 12),
            BackgroundTransparency = 1,
            Text = iconTxt,
            TextColor3 = strokeColor,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            Parent = notif,
            ZIndex = 16,
        })

        Create("TextLabel", {
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 48, 0, 12),
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
            Size = UDim2.new(1, -50, 0, 28),
            Position = UDim2.new(0, 48, 0, 32),
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

        Tween(notif, {Size = UDim2.new(1, 0, 0, 72)}, 0.25, Enum.EasingStyle.Back)

        task.delay(cfg.Duration or 3, function()
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
    end

    function Window:SelectTab(name)
        for _, tab in ipairs(Window.Tabs) do
            if tab.Name == name then
                tab.Btn:ClickButton1()
                break
            end
        end
    end

    Window.Main = Main
    Window.ScreenGui = ScreenGui
    return Window
end

return Phat
