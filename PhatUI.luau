--[[
    Aurora UI - A premium Roblox UI library
    Features: Smooth animations, modern design, 15+ widget types
]]

local Aurora = {}
Aurora.__index = Aurora

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Blacklist = {["ExtraSmall"] = true, ["Small"] = true, ["Medium"] = true, ["Large"] = true, ["ExtraLarge"] = true, ["HUGE"] = true}

local EASING_STYLES = {
    Sine = Enum.EasingStyle.Sine,
    Quad = Enum.EasingStyle.Quad,
    Cubic = Enum.EasingStyle.Cubic,
    Quint = Enum.EasingStyle.Quint,
    Back = Enum.EasingStyle.Back,
    Bounce = Enum.EasingStyle.Bounce,
    Elastic = Enum.EasingStyle.Elastic,
}

local DEFAULT_EASING = EASING_STYLES.Sine
local DEFAULT_DURATION = 0.25

local Colors = {
    Dark = Color3.fromRGB(10, 10, 12),
    Darker = Color3.fromRGB(8, 8, 10),
    Darkest = Color3.fromRGB(6, 6, 8),
    Accent = Color3.fromRGB(88, 166, 255),
    AccentDark = Color3.fromRGB(60, 120, 200),
    Text = Color3.fromRGB(255, 255, 255),
    TextMuted = Color3.fromRGB(150, 150, 160),
    Border = Color3.fromRGB(40, 40, 50),
    Success = Color3.fromRGB(60, 200, 120),
    Warning = Color3.fromRGB(255, 200, 60),
    Error = Color3.fromRGB(255, 80, 80),
    Card = Color3.fromRGB(22, 22, 28),
    CardHover = Color3.fromRGB(28, 28, 36),
    Sidebar = Color3.fromRGB(16, 16, 20),
    TabActive = Color3.fromRGB(88, 166, 255),
    TabInactive = Color3.fromRGB(30, 30, 38),
}

local Utility = {}

function Utility:Tween(obj, props, duration, easingStyle)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or DEFAULT_DURATION, easingStyle or DEFAULT_EASING, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

function Utility:Create(class, props, children)
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

function Utility:Round(num, bracket)
    bracket = bracket or 1
    return math.floor(num/bracket + 0.5) * bracket
end

function Utility:Dragify(frame, hold)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local absPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        Utility:Tween(frame, {Position = absPos}, 0.15, EASING_STYLES.Quad)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
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

function Utility:PopIn(frame, scale)
    local originalSize = frame.Size
    frame.Size = UDim2.new(0, 0, 0, 0)
    local tween = Utility:Tween(frame, {Size = originalSize}, 0.3, EASING_STYLES.Back)
    return tween
end

function Utility:ShadeColor3(color, percent)
    local h, s, v = color:ToHSV()
    return Color3.fromHSV(h, s, math.clamp(v + percent, 0, 1))
end

-- Main Window Class
function Aurora:CreateWindow(config)
    local Window = {}
    Window.Holder = {}
    Window.Flags = {}
    Window.CurrentTab = nil

    local Config = {
        Title = config.Title or "Aurora UI",
        Size = config.Size or UDim2.new(0, 620, 0, 500),
        Position = config.Position or UDim2.new(0.5, 0, 0.5, 0),
        Theme = config.Theme or Colors,
        Accent = config.Accent or Color3.fromRGB(88, 166, 255),
        MinimizeKey = config.MinimizeKey or Enum.KeyCode.RightShift,
        ToggleKey = config.ToggleKey or Enum.KeyCode.F,
    }

    Window.Theme = Config.Theme

    local ScreenGui = Utility:Create("ScreenGui", {
        Name = "AuroraUI",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
    })

    -- Main Container
    local Main = Utility:Create("Frame", {
        Name = "Main",
        Size = Config.Size,
        Position = Config.Position,
        AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Config.Theme.Dark,
        BorderSizePixel = 0,
        Parent = ScreenGui,
        ZIndex = 2,
    })

    Utility:Create("UIGradient", {
        Color = ColorSequence.new(Config.Theme.Darker, Config.Theme.Dark),
        Rotation = 90,
        Parent = Main,
    })

    local MainCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = Main,
    })

    local MainStroke = Utility:Create("UIStroke", {
        Color = Config.Theme.Border,
        Thickness = 1,
        Parent = Main,
    })

    -- Top Bar
    local TopBar = Utility:Create("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Config.Theme.Darker,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 3,
    })

    local TopBarCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 14),
        Parent = TopBar,
    })

    Utility:Create("Frame", {
        Name = "BottomCover",
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Config.Theme.Darker,
        BorderSizePixel = 0,
        Parent = TopBar,
        ZIndex = 3,
    })

    -- Logo/Title
    local LogoContainer = Utility:Create("Frame", {
        Name = "Logo",
        Size = UDim2.new(0, 36, 0, 36),
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Config.Accent,
        BorderSizePixel = 0,
        Parent = TopBar,
        ZIndex = 4,
    })

    Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 10),
        Parent = LogoContainer,
    })

    Utility:Create("UIGradient", {
        Color = ColorSequence.new(Config.Accent, Config.Theme.AccentDark),
        Rotation = 45,
        Parent = LogoContainer,
    })

    local LogoIcon = Utility:Create("TextLabel", {
        Name = "Icon",
        Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
        Text = "A",
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        Parent = LogoContainer,
        ZIndex = 5,
    })

    local TitleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 58, 0, 0),
    BackgroundTransparency = 1,
        Text = Config.Title,
        TextColor3 = Config.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 17,
        Font = Enum.Font.GothamBold,
        Parent = TopBar,
        ZIndex = 4,
    })

    -- Window Controls
    local ControlsContainer = Utility:Create("Frame", {
        Name = "Controls",
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -110, 0, 0),
    BackgroundTransparency = 1,
        Parent = TopBar,
        ZIndex = 4,
    })

    local ControlsLayout = Utility:Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = ControlsContainer,
    })

    local function CreateControlButton(name, icon, color)
        local btn = Utility:Create("TextButton", {
            Name = name,
            Size = UDim2.new(0, 32, 0, 32),
        BackgroundColor3 = Config.Theme.Dark,
            BorderSizePixel = 0,
            Parent = ControlsContainer,
            ZIndex = 5,
            Text = "",
            AutoButtonColor = false,
        })

        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 8),
            Parent = btn,
        })

        local iconLabel = Utility:Create("TextLabel", {
            Name = "Icon",
            Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
            Text = icon,
            TextColor3 = color or Config.Theme.TextMuted,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = btn,
            ZIndex = 6,
        })

        return btn, iconLabel
    end

    local MinimizeBtn = CreateControlButton("Minimize", "−", Config.Theme.Text)
    local CloseBtn = CreateControlButton("Close", "×", Config.Theme.Error)

    -- Sidebar
    local Sidebar = Utility:Create("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, 160, 1, -56),
        Position = UDim2.new(0, 0, 0, 50),
    BackgroundColor3 = Config.Theme.Sidebar,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 2,
    })

    local SidebarCorner = Utility:Create("UICorner", {
        CornerRadius = UDim.new(0, 0),
        Parent = Sidebar,
    })

    local SidebarStroke = Utility:Create("UIStroke", {
        Color = Config.Theme.Border,
        Thickness = 1,
        Parent = Sidebar,
    })

    local TabScroll = Utility:Create("ScrollingFrame", {
        Name = "TabScroll",
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        Parent = Sidebar,
        ZIndex = 3,
    })

    local TabLayout = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 6),
        Parent = TabScroll,
    })

    local TabPadding = Utility:Create("UIPadding", {
        PaddingTop = UDim.new(0, 4),
        Parent = TabScroll,
    })

    -- Content Area
    local Content = Utility:Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -176, 1, -56),
        Position = UDim2.new(0, 168, 0, 50),
    BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = Main,
        ZIndex = 2,
        ClipsDescendants = true,
    })

    -- Notification Area
    local Notifications = Utility:Create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 320, 1, -60),
        Position = UDim2.new(1, -10, 0, 56),
        AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1,
        Parent = Main,
        ZIndex = 10,
    })

    local NotificationLayout = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        Parent = Notifications,
    })

    -- Window state
    local isMinimized = false
    local isHidden = false
    local originalSize = Config.Size
    local originalContentSize = Content.Size

    -- Tab System
    local Tabs = {}

    function Window:AddTab(config)
        local Tab = {}
        Tab.Name = config.Title or "Tab"
        Tab.Elements = {}

        local TabBtn = Utility:Create("TextButton", {
            Name = Tab.Name,
            Size = UDim2.new(1, -8, 0, 38),
            Position = UDim2.new(0, 4, 0, 0),
        BackgroundColor3 = Config.Theme.TabInactive,
            BorderSizePixel = 0,
            Parent = TabScroll,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 4,
        })

        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = TabBtn,
        })

        local TabIcon = Utility:Create("TextLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 22, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
            Text = config.Icon or "●",
            TextColor3 = Config.Theme.TextMuted,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = TabBtn,
            ZIndex = 5,
        })

        local TabLabel = Utility:Create("TextLabel", {
            Name = "Label",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 36, 0, 0),
        BackgroundTransparency = 1,
            Text = Tab.Name,
            TextColor3 = Config.Theme.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 13,
            Font = Enum.Font.GothamMedium,
            Parent = TabBtn,
            ZIndex = 5,
        })

        local TabContent = Utility:Create("ScrollingFrame", {
            Name = "Content",
            Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Config.Theme.Border,
            ScrollBarImageTransparency = 0.5,
            ScrollBarCanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Parent = Content,
            Visible = false,
            ZIndex = 2,
        })

        local TabLayout = Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 12),
            Parent = TabContent,
        })

        local TabPadding = Utility:Create("UIPadding", {
            PaddingTop = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            Parent = TabContent,
        })

        TabBtn.MouseEnter:Connect(function()
            if TabBtn.BackgroundColor3 ~= Config.Theme.TabActive then
                Utility:Tween(TabBtn, {BackgroundColor3 = Config.Theme.CardHover}, 0.15)
            end
        end)

        TabBtn.MouseLeave:Connect(function()
            if TabBtn.BackgroundColor3 ~= Config.Theme.TabActive then
                Utility:Tween(TabBtn, {BackgroundColor3 = Config.Theme.TabInactive}, 0.15)
            end
        end)

        TabBtn.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
                Window.CurrentTab.Button.BackgroundColor3 = Config.Theme.TabInactive
                Window.CurrentTab.Button.Icon.TextColor3 = Config.Theme.TextMuted
                Window.CurrentTab.Button.Label.TextColor3 = Config.Theme.TextMuted
            end

            TabContent.Visible = true
            TabBtn.BackgroundColor3 = Config.Theme.TabActive
            TabIcon.TextColor3 = Config.Accent
            TabLabel.TextColor3 = Config.Theme.Text
            Window.CurrentTab = {Tab = Tab, Content = TabContent, Button = TabBtn, Icon = TabIcon, Label = TabLabel}
        end)

        Tab.Button = TabBtn
        Tab.Content = TabContent
        Tab.Icon = TabIcon
        Tab.Label = TabLabel

        function Tab:AddSection(config)
            local Section = {}
            Section.Name = config.Title or "Section"
            Section.Elements = {}

            local SectionFrame = Utility:Create("Frame", {
                Name = Section.Name,
                Size = UDim2.new(1, 0, 0, 0),
            BackgroundColor3 = Config.Theme.Card,
                BorderSizePixel = 0,
                Parent = TabContent,
                ZIndex = 2,
                AutomaticSize = Enum.AutomaticSize.Y,
            })

            Utility:Create("UICorner", {
                CornerRadius = UDim.new(0, 12),
                Parent = SectionFrame,
            })

            local SectionStroke = Utility:Create("UIStroke", {
                Color = Config.Theme.Border,
                Thickness = 1,
                Parent = SectionFrame,
            })

            local SectionLayout = Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 4),
                Parent = SectionFrame,
            })

            local SectionPadding = Utility:Create("UIPadding", {
                PaddingTop = UDim.new(0, 12),
                PaddingLeft = UDim.new(0, 12),
                PaddingRight = UDim.new(0, 12),
                PaddingBottom = UDim.new(0, 12),
                Parent = SectionFrame,
            })

            local SectionHeader = Utility:Create("Frame", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 26),
            BackgroundTransparency = 1,
                Parent = SectionFrame,
                ZIndex = 3,
            })

            local SectionLabel = Utility:Create("TextLabel", {
                Name = "Label",
                Size = UDim2.new(1, -24, 1, 0),
            BackgroundTransparency = 1,
                Text = Section.Name,
                TextColor3 = Config.Theme.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                Parent = SectionHeader,
                ZIndex = 3,
            })

            local SectionIcon = Utility:Create("TextLabel", {
                Name = "Icon",
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(1, -18, 0, 0),
                AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
                Text = config.Icon or "◆",
                TextColor3 = Config.Accent,
                TextSize = 12,
                Font = Enum.Font.GothamBold,
                Parent = SectionHeader,
                ZIndex = 3,
            })

            Section.Container = SectionFrame

            function Section:AddLabel(config)
                local Label = {}

                local LabelFrame = Utility:Create("Frame", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 24),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local LabelText = Utility:Create("TextLabel", {
                    Name = "Text",
                    Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                    Text = config.Text or "",
                    TextColor3 = config.Color or Config.Theme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = config.TextSize or 13,
                    Font = config.Font or Enum.Font.Gotham,
                    RichText = config.RichText or false,
                    Parent = LabelFrame,
                    ZIndex = 3,
                })

                Label.Frame = LabelFrame
                Label.Text = LabelText
                return Label
            end

            function Section:AddButton(config)
                local Button = {}
                local isEnabled = true

                local ButtonFrame = Utility:Create("Frame", {
                    Name = "Button",
                    Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Config.Theme.TabInactive,
                    BorderSizePixel = 0,
                    Parent = SectionFrame,
                    ZIndex = 3,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = ButtonFrame,
                })

                local ButtonGradient = Utility:Create("UIGradient", {
                    Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1)),
                    Transparency = NumberSequence.new(1),
                    Parent = ButtonFrame,
                })

                local ButtonContent = Utility:Create("TextButton", {
                    Name = "Content",
                    Size = UDim2.new(1, -8, 1, -8),
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                    Text = config.Title or "Button",
                    TextColor3 = Config.Theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    Parent = ButtonFrame,
                    ZIndex = 4,
                    AutoButtonColor = false,
                })

                local ButtonIcon = nil
                if config.Icon then
                    ButtonIcon = Utility:Create("TextLabel", {
                        Name = "Icon",
                        Size = UDim2.new(0, 20, 0, 20),
                        Position = UDim2.new(0, 10, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                        Text = config.Icon,
                        TextColor3 = config.IconColor or Config.Accent,
                        TextSize = 14,
                        Font = Enum.Font.GothamBold,
                        Parent = ButtonContent,
                        ZIndex = 5,
                    })
                    ButtonContent.TextXAlignment = Enum.TextXAlignment.Center
                end

                ButtonFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if isEnabled then
                            Utility:Tween(ButtonFrame, {BackgroundColor3 = Utility:ShadeColor3(Config.Theme.TabActive, -0.1)}, 0.1)
                        end
                    end
                end)

                ButtonFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if isEnabled then
                            Utility:Tween(ButtonFrame, {BackgroundColor3 = Config.Theme.TabInactive}, 0.1)
                        end
                    end
                end)

                ButtonContent.MouseButton1Click:Connect(function()
                    if isEnabled then
                        pcall(function()
                            config.Callback()
                        end)
                    end
                end)

                function Button:SetEnabled(enabled)
                    isEnabled = enabled
                    ButtonFrame.BackgroundColor3 = enabled and Config.Theme.TabInactive or Config.Theme.Darkest
                    ButtonContent.TextColor3 = enabled and Config.Theme.Text or Config.Theme.TextMuted
                end

                Button.Frame = ButtonFrame
                Button.Content = ButtonContent
                return Button
            end

            function Section:AddToggle(config)
                local Toggle = {}
                local state = config.Default or false
                Window.Flags[config.Flag] = state

                local ToggleFrame = Utility:Create("Frame", {
                    Name = "Toggle",
                    Size = UDim2.new(1, 0, 0, 44),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local ToggleContent = Utility:Create("Frame", {
                    Name = "Content",
                    Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                    Parent = ToggleFrame,
                    ZIndex = 4,
                })

                local ToggleLabel = Utility:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                    Text = config.Title or "Toggle",
                    TextColor3 = Config.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = ToggleContent,
                    ZIndex = 4,
                })

                local ToggleDesc = nil
                if config.Description then
                    ToggleDesc = Utility:Create("TextLabel", {
                        Name = "Description",
                        Size = UDim2.new(1, 0, 0, 18),
                        Position = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                        Text = config.Description,
                        TextColor3 = Config.Theme.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        Parent = ToggleContent,
                        ZIndex = 4,
                    })
                end

                local ToggleBox = Utility:Create("TextButton", {
                    Name = "Box",
                    Size = UDim2.new(0, 48, 0, 26),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Config.Theme.Darkest,
                    BorderSizePixel = 0,
                    Parent = ToggleFrame,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = ToggleBox,
                })

                local ToggleKnob = Utility:Create("Frame", {
                    Name = "Knob",
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = state and UDim2.new(1, -5, 0.5, 0) or UDim2.new(0, 5, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Config.Theme.Text,
                    BorderSizePixel = 0,
                    Parent = ToggleBox,
                    ZIndex = 6,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = ToggleKnob,
                })

                local function UpdateToggle(animate)
                    Window.Flags[config.Flag] = state
                    local targetColor = state and Config.Accent or Config.Theme.Darkest
                    local targetPos = state and UDim2.new(1, -5, 0.5, 0) or UDim2.new(0, 5, 0.5, 0)

                    if animate then
                        Utility:Tween(ToggleBox, {BackgroundColor3 = targetColor}, 0.2)
                        Utility:Tween(ToggleKnob, {Position = targetPos, BackgroundColor3 = state and Color3.new(1,1,1) or Config.Theme.Text}, 0.2)
                    else
                        ToggleBox.BackgroundColor3 = targetColor
                        ToggleKnob.Position = targetPos
                        ToggleKnob.BackgroundColor3 = state and Color3.new(1,1,1) or Config.Theme.Text
                    end
                end

                UpdateToggle(false)

                ToggleBox.MouseButton1Click:Connect(function()
                    state = not state
                    UpdateToggle(true)
                    pcall(function()
                        config.Callback(state)
                    end)
                end)

                function Toggle:Set(value)
                    state = value
                    UpdateToggle(true)
                end

                function Toggle:Get()
                    return state
                end

                Toggle.Frame = ToggleFrame
                Toggle.Box = ToggleBox
                Toggle.Knob = ToggleKnob
                return Toggle
            end

            function Section:AddSlider(config)
                local Slider = {}
                local min = config.Min or 0
                local max = config.Max or 100
                local value = config.Default or min
                local step = config.Step or 1
                Window.Flags[config.Flag] = value

                local SliderFrame = Utility:Create("Frame", {
                    Name = "Slider",
                    Size = UDim2.new(1, 0, 0, 60),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local SliderHeader = Utility:Create("Frame", {
                    Name = "Header",
                    Size = UDim2.new(1, -50, 0, 22),
                BackgroundTransparency = 1,
                    Parent = SliderFrame,
                    ZIndex = 4,
                })

                local SliderLabel = Utility:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                    Text = config.Title or "Slider",
                    TextColor3 = Config.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = SliderHeader,
                    ZIndex = 4,
                })

                local SliderValue = Utility:Create("TextBox", {
                    Name = "Value",
                    Size = UDim2.new(0, 50, 1, 0),
                    Position = UDim2.new(1, 0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                BackgroundColor3 = Config.Theme.Darkest,
                    BorderSizePixel = 0,
                    Text = tostring(value),
                    TextColor3 = Config.Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    Parent = SliderHeader,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = SliderValue,
                })

                local SliderTrack = Utility:Create("Frame", {
                    Name = "Track",
                    Size = UDim2.new(1, 0, 0, 8),
                    Position = UDim2.new(0, 0, 0, 32),
                BackgroundColor3 = Config.Theme.Darkest,
                    BorderSizePixel = 0,
                    Parent = SliderFrame,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = SliderTrack,
                })

                local SliderFill = Utility:Create("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Config.Accent,
                    BorderSizePixel = 0,
                    Parent = SliderTrack,
                    ZIndex = 6,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 4),
                    Parent = SliderFill,
                })

                local SliderKnob = Utility:Create("Frame", {
                    Name = "Knob",
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new((value - min) / (max - min), -9, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.new(1, 1, 1),
                    BorderSizePixel = 0,
                    Parent = SliderTrack,
                    ZIndex = 7,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = SliderKnob,
                })

                local SliderStroke = Utility:Create("UIStroke", {
                    Color = Config.Accent,
                    Thickness = 2,
                    Parent = SliderKnob,
                })

                local dragging = false

                local function updateSlider(input)
                    local relativePos = (input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X
                    relativePos = math.clamp(relativePos, 0, 1)
                    value = Utility:Round(min + (max - min) * relativePos, step)
                    Window.Flags[config.Flag] = value
                    SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(relativePos, 0, 0.5, 0)
                    SliderValue.Text = tostring(value)
                end

                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        updateSlider(input)
                    end
                end)

                SliderKnob.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)

                UIS.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        updateSlider(input)
                        pcall(function()
                            config.Callback(value)
                        end)
                    end
                end)

                UIS.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                SliderValue.FocusLost:Connect(function()
                    local newValue = tonumber(SliderValue.Text)
                    if newValue then
                        value = Utility:Round(math.clamp(newValue, min, max), step)
                        Window.Flags[config.Flag] = value
                        local relativePos = (value - min) / (max - min)
                        SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
                        SliderKnob.Position = UDim2.new(relativePos, 0, 0.5, 0)
                        SliderValue.Text = tostring(value)
                    else
                        SliderValue.Text = tostring(value)
                    end
                end)

                function Slider:Set(val)
                    value = Utility:Round(math.clamp(val, min, max), step)
                    Window.Flags[config.Flag] = value
                    local relativePos = (value - min) / (max - min)
                    Utility:Tween(SliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)}, 0.1)
                    Utility:Tween(SliderKnob, {Position = UDim2.new(relativePos, 0, 0.5, 0)}, 0.1)
                    SliderValue.Text = tostring(value)
                end

                function Slider:Get()
                    return value
                end

                Slider.Frame = SliderFrame
                Slider.Value = SliderValue
                return Slider
            end

            function Section:AddDropdown(config)
                local Dropdown = {}
                local items = config.Items or {}
                local selected = config.Default or nil
                local open = false
                Window.Flags[config.Flag] = selected

                local DropdownFrame = Utility:Create("Frame", {
                    Name = "Dropdown",
                    Size = UDim2.new(1, 0, 0, 44),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local DropdownContent = Utility:Create("Frame", {
                    Name = "Content",
                    Size = UDim2.new(1, -40, 1, 0),
                BackgroundTransparency = 1,
                    Parent = DropdownFrame,
                    ZIndex = 4,
                })

                local DropdownLabel = Utility:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                    Text = config.Title or "Dropdown",
                    TextColor3 = Config.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = DropdownContent,
                    ZIndex = 4,
                })

                local DropdownValue = Utility:Create("TextLabel", {
                    Name = "Value",
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.new(0, 0, 0, 20),
                BackgroundTransparency = 1,
                    Text = selected or "Select...",
                    TextColor3 = selected and Config.Theme.Text or Config.Theme.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    Parent = DropdownContent,
                    ZIndex = 4,
                })

                local DropdownButton = Utility:Create("TextButton", {
                    Name = "Button",
                    Size = UDim2.new(0, 36, 0, 36),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Config.Theme.TabInactive,
                    BorderSizePixel = 0,
                    Text = "▼",
                    TextColor3 = Config.Theme.TextMuted,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Parent = DropdownFrame,
                    AutoButtonColor = false,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = DropdownButton,
                })

                local DropdownList = Utility:Create("Frame", {
                    Name = "List",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 48),
                BackgroundColor3 = Config.Theme.Card,
                    BorderSizePixel = 0,
                    Visible = false,
                    ClipsDescendants = true,
                    Parent = DropdownFrame,
                    ZIndex = 10,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = DropdownList,
                })

                local DropdownListStroke = Utility:Create("UIStroke", {
                    Color = Config.Theme.Border,
                    Thickness = 1,
                    Parent = DropdownList,
                })

                local DropdownListLayout = Utility:Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = DropdownList,
                })

                local DropdownListPadding = Utility:Create("UIPadding", {
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    Parent = DropdownList,
                })

                DropdownButton.MouseButton1Click:Connect(function()
                    open = not open
                    DropdownList.Visible = open
                    if open then
                        local listSize = math.min(#items * 34 + 8, 200)
                        Utility:Tween(DropdownList, {Size = UDim2.new(1, 0, 0, listSize)}, 0.2, EASING_STYLES.Back)
                        Utility:Tween(DropdownButton, {Rotation = 180}, 0.2)
                    else
                        Utility:Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.15, EASING_STYLES.Quad)
                        Utility:Tween(DropdownButton, {Rotation = 0}, 0.2)
                    end
                end)

                local function addItem(item, index)
                    local ItemBtn = Utility:Create("TextButton", {
                        Name = item,
                        Size = UDim2.new(1, -8, 0, 30),
                        Position = UDim2.new(0, 4, 0, 0),
                    BackgroundTransparency = 1,
                        Text = item,
                        TextColor3 = Config.Theme.Text,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 13,
                        Font = Enum.Font.Gotham,
                        Parent = DropdownList,
                        ZIndex = 11,
                        AutoButtonColor = false,
                    })

                    local ItemPadding = Utility:Create("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        Parent = ItemBtn,
                    })

                    ItemBtn.MouseEnter:Connect(function()
                        Utility:Tween(ItemBtn, {BackgroundColor3 = Config.Theme.TabInactive}, 0.1)
                    end)

                    ItemBtn.MouseLeave:Connect(function()
                        Utility:Tween(ItemBtn, {BackgroundTransparency = 1}, 0.1)
                    end)

                    ItemBtn.MouseButton1Click:Connect(function()
                        selected = item
                        Window.Flags[config.Flag] = item
                        DropdownValue.Text = item
                        DropdownValue.TextColor3 = Config.Theme.Text
                        open = false
                        Utility:Tween(DropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.15, EASING_STYLES.Quad)
                        Utility:Tween(DropdownButton, {Rotation = 0}, 0.2)
                        task.delay(0.15, function()
                            DropdownList.Visible = false
                        end)
                        pcall(function()
                            config.Callback(item, index)
                        end)
                    end)
                end

                for i, item in ipairs(items) do
                    addItem(item, i)
                end

                function Dropdown:AddItem(item)
                    table.insert(items, item)
                    addItem(item, #items)
                end

                function Dropdown:Clear()
                    items = {}
                    selected = nil
                    Window.Flags[config.Flag] = nil
                    DropdownValue.Text = "Select..."
                    DropdownValue.TextColor3 = Config.Theme.TextMuted
                    for _, child in ipairs(DropdownList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                end

                function Dropdown:Get()
                    return selected
                end

                function Dropdown:Set(value)
                    selected = value
                    Window.Flags[config.Flag] = value
                    DropdownValue.Text = value or "Select..."
                    DropdownValue.TextColor3 = value and Config.Theme.Text or Config.Theme.TextMuted
                end

                Dropdown.Frame = DropdownFrame
                return Dropdown
            end

            function Section:AddInput(config)
                local Input = {}
                local focused = false
                Window.Flags[config.Flag] = config.Default or ""

                local InputFrame = Utility:Create("Frame", {
                    Name = "Input",
                    Size = UDim2.new(1, 0, 0, 44),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local InputContent = Utility:Create("Frame", {
                    Name = "Content",
                    Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                    Parent = InputFrame,
                    ZIndex = 4,
                })

                local InputLabel = Utility:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                    Text = config.Title or "Input",
                    TextColor3 = Config.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = InputContent,
                    ZIndex = 4,
                })

                local InputBox = Utility:Create("TextBox", {
                    Name = "Box",
                    Size = UDim2.new(1, 0, 0, 28),
                    Position = UDim2.new(0, 0, 0, 22),
                BackgroundColor3 = Config.Theme.Darkest,
                    BorderSizePixel = 0,
                    Text = config.Default or "",
                    PlaceholderText = config.Placeholder or "Enter text...",
                    PlaceholderColor3 = Config.Theme.TextMuted,
                    TextColor3 = Config.Theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = InputContent,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = InputBox,
                })

                local InputStroke = Utility:Create("UIStroke", {
                    Color = Config.Accent,
                    Thickness = 0,
                    Parent = InputBox,
                })

                local ClearBtn = Utility:Create("TextButton", {
                    Name = "Clear",
                    Size = UDim2.new(0, 36, 0, 36),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Config.Theme.TabInactive,
                    BorderSizePixel = 0,
                    Text = "×",
                    TextColor3 = Config.Theme.TextMuted,
                    TextSize = 16,
                    Font = Enum.Font.GothamBold,
                    Parent = InputFrame,
                    AutoButtonColor = false,
                    Visible = false,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 10),
                    Parent = ClearBtn,
                })

                InputBox.Focused:Connect(function()
                    focused = true
                    Utility:Tween(InputStroke, {Thickness = 2}, 0.15)
                    if InputBox.Text ~= "" then
                        ClearBtn.Visible = true
                    end
                end)

                InputBox.FocusLost:Connect(function()
                    focused = false
                    Utility:Tween(InputStroke, {Thickness = 0}, 0.15)
                    ClearBtn.Visible = false
                    Window.Flags[config.Flag] = InputBox.Text
                    pcall(function()
                        config.Callback(InputBox.Text)
                    end)
                end)

                InputBox:GetPropertyChangedSignal("Text"):Connect(function()
                    ClearBtn.Visible = #InputBox.Text > 0 and focused
                end)

                ClearBtn.MouseButton1Click:Connect(function()
                    InputBox.Text = ""
                    ClearBtn.Visible = false
                    Window.Flags[config.Flag] = ""
                    pcall(function()
                        config.Callback("")
                    end)
                end)

                function Input:Get()
                    return InputBox.Text
                end

                function Input:Set(text)
                    InputBox.Text = text
                    Window.Flags[config.Flag] = text
                end

                Input.Frame = InputFrame
                Input.Box = InputBox
                return Input
            end

            function Section:AddKeybind(config)
                local Keybind = {}
                local bound = false
                local currentKey = config.Default or Enum.KeyCode.Unknown
                Window.Flags[config.Flag] = currentKey

                local KeybindFrame = Utility:Create("Frame", {
                    Name = "Keybind",
                    Size = UDim2.new(1, 0, 0, 44),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local KeybindContent = Utility:Create("Frame", {
                    Name = "Content",
                    Size = UDim2.new(1, -110, 1, 0),
                BackgroundTransparency = 1,
                    Parent = KeybindFrame,
                    ZIndex = 4,
                })

                local KeybindLabel = Utility:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                    Text = config.Title or "Keybind",
                    TextColor3 = Config.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = KeybindContent,
                    ZIndex = 4,
                })

                local KeybindDesc = nil
                if config.Description then
                    KeybindDesc = Utility:Create("TextLabel", {
                        Name = "Description",
                        Size = UDim2.new(1, 0, 0, 16),
                        Position = UDim2.new(0, 0, 0, 20),
                    BackgroundTransparency = 1,
                        Text = config.Description,
                        TextColor3 = Config.Theme.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        Parent = KeybindContent,
                        ZIndex = 4,
                    })
                end

                local KeybindButton = Utility:Create("TextButton", {
                    Name = "Button",
                    Size = UDim2.new(0, 100, 0, 34),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Config.Theme.TabInactive,
                    BorderSizePixel = 0,
                    Text = currentKey.Name or "None",
                    TextColor3 = Config.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Parent = KeybindFrame,
                    AutoButtonColor = false,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = KeybindButton,
                })

                local binding = false

                KeybindButton.MouseButton1Click:Connect(function()
                    binding = true
                    KeybindButton.Text = "..."
                    KeybindButton.BackgroundColor3 = Config.Accent
                end)

                UIS.InputBegan:Connect(function(input, gameProcessed)
                    if binding then
                        if input.KeyCode ~= Enum.KeyCode.Unknown then
                            currentKey = input.KeyCode
                            Window.Flags[config.Flag] = currentKey
                            KeybindButton.Text = currentKey.Name
                            KeybindButton.BackgroundColor3 = Config.Theme.TabInactive
                            binding = false
                        end
                    elseif input.KeyCode == currentKey and not gameProcessed then
                        pcall(function()
                            config.Callback()
                        end)
                    end
                end)

                function Keybind:Set(key)
                    currentKey = key
                    Window.Flags[config.Flag] = key
                    KeybindButton.Text = key.Name or "None"
                end

                function Keybind:Get()
                    return currentKey
                end

                Keybind.Frame = KeybindFrame
                return Keybind
            end

            function Section:AddColorPicker(config)
                local ColorPicker = {}
                local currentColor = config.Default or Color3.fromRGB(255, 255, 255)
                Window.Flags[config.Flag] = currentColor

                local ColorPickerFrame = Utility:Create("Frame", {
                    Name = "ColorPicker",
                    Size = UDim2.new(1, 0, 0, 60),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                local ColorPickerContent = Utility:Create("Frame", {
                    Name = "Content",
                    Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                    Parent = ColorPickerFrame,
                    ZIndex = 4,
                })

                local ColorPickerLabel = Utility:Create("TextLabel", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 22),
                BackgroundTransparency = 1,
                    Text = config.Title or "Color",
                    TextColor3 = Config.Theme.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextSize = 14,
                    Font = Enum.Font.GothamMedium,
                    Parent = ColorPickerContent,
                    ZIndex = 4,
                })

                local ColorPreview = Utility:Create("Frame", {
                    Name = "Preview",
                    Size = UDim2.new(0, 40, 0, 26),
                    Position = UDim2.new(0, 0, 0, 26),
                BackgroundColor3 = currentColor,
                    BorderSizePixel = 0,
                    Parent = ColorPickerContent,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = ColorPreview,
                })

                local ColorHex = Utility:Create("TextBox", {
                    Name = "Hex",
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 46, 0, 26),
                BackgroundColor3 = Config.Theme.Darkest,
                    BorderSizePixel = 0,
                    Text = "#" .. currentColor:ToHex(),
                    TextColor3 = Config.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    Parent = ColorPickerContent,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 6),
                    Parent = ColorHex,
                })

                local ColorPickerBtn = Utility:Create("TextButton", {
                    Name = "Button",
                    Size = UDim2.new(0, 50, 0, 34),
                    Position = UDim2.new(1, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = Config.Theme.TabInactive,
                    BorderSizePixel = 0,
                    Text = "Pick",
                    TextColor3 = Config.Theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Parent = ColorPickerFrame,
                    AutoButtonColor = false,
                    ZIndex = 5,
                })

                Utility:Create("UICorner", {
                    CornerRadius = UDim.new(0, 8),
                    Parent = ColorPickerBtn,
                })

                function ColorPicker:Set(color)
                    currentColor = color
                    Window.Flags[config.Flag] = color
                    ColorPreview.BackgroundColor3 = color
                    ColorHex.Text = "#" .. color:ToHex()
                end

                function ColorPicker:Get()
                    return currentColor
                end

                ColorPicker.Frame = ColorPickerFrame
                return ColorPicker
            end

            function Section:AddDivider(config)
                local DividerFrame = Utility:Create("Frame", {
                    Name = "Divider",
                    Size = UDim2.new(1, 0, 0, config.Height or 16),
                BackgroundTransparency = 1,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })

                if config.Line then
                    local Line = Utility:Create("Frame", {
                        Name = "Line",
                        Size = UDim2.new(1, 0, 0, 1),
                        Position = UDim2.new(0, 0, 0.5, 0),
                    BackgroundColor3 = Config.Theme.Border,
                        BorderSizePixel = 0,
                        Parent = DividerFrame,
                        ZIndex = 4,
                    })
                end

                return DividerFrame
            end

            function Section:AddSeparator(config)
                local SeparatorFrame = Utility:Create("Frame", {
                    Name = "Separator",
                    Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Config.Theme.Border,
                    BorderSizePixel = 0,
                    Parent = SectionFrame,
                    ZIndex = 3,
                })
                return SeparatorFrame
            end

            return Section
        end

        table.insert(Tabs, Tab)
        table.insert(Window.Holder, Tab)

        if #Tabs == 1 then
            TabBtn.BackgroundColor3 = Config.Theme.TabActive
            TabIcon.TextColor3 = Config.Accent
            TabLabel.TextColor3 = Config.Theme.Text
            TabContent.Visible = true
            Window.CurrentTab = {Tab = Tab, Content = TabContent, Button = TabBtn, Icon = TabIcon, Label = TabLabel}
        end

        return Tab
    end

    function Window:Notify(config)
        local Notification = {}

        local NotifFrame = Utility:Create("Frame", {
            Name = "Notification",
            Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Config.Theme.Card,
            BorderSizePixel = 0,
            ZIndex = 15,
        })

        Utility:Create("UICorner", {
            CornerRadius = UDim.new(0, 10),
            Parent = NotifFrame,
        })

        local NotifStroke = Utility:Create("UIStroke", {
            Color = config.Type == "Success" and Config.Theme.Success or 
                    config.Type == "Warning" and Config.Theme.Warning or 
                    config.Type == "Error" and Config.Theme.Error or Config.Theme.Accent,
            Thickness = 2,
            Parent = NotifFrame,
        })

        local NotifIcon = Utility:Create("TextLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(0, 12, 0, 12),
        BackgroundTransparency = 1,
            Text = config.Type == "Success" and "✓" or 
                   config.Type == "Warning" and "⚠" or 
                   config.Type == "Error" and "✕" or "ℹ",
            TextColor3 = config.Type == "Success" and Config.Theme.Success or 
                         config.Type == "Warning" and Config.Theme.Warning or 
                         config.Type == "Error" and Config.Theme.Error or Config.Theme.Accent,
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            Parent = NotifFrame,
            ZIndex = 16,
        })

        local NotifTitle = Utility:Create("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -50, 0, 20),
            Position = UDim2.new(0, 50, 0, 12),
        BackgroundTransparency = 1,
            Text = config.Title or "Notification",
            TextColor3 = Config.Theme.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 14,
            Font = Enum.Font.GothamBold,
            Parent = NotifFrame,
            ZIndex = 16,
        })

        local NotifDesc = Utility:Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, -50, 0, 28),
            Position = UDim2.new(0, 50, 0, 30),
        BackgroundTransparency = 1,
            Text = config.Description or "",
            TextColor3 = Config.Theme.TextMuted,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 11,
            Font = Enum.Font.Gotham,
            Parent = NotifFrame,
            ZIndex = 16,
            TextTruncate = Enum.TextTruncate.AtEnd,
        })

        NotifFrame.Size = UDim2.new(1, 0, 0, 0)
        Utility:Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 70)}, 0.25, EASING_STYLES.Back)

        NotifFrame.Parent = Notifications

        task.delay(config.Duration or 3, function()
            if NotifFrame and NotifFrame.Parent then
                Utility:Tween(NotifFrame, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.2, EASING_STYLES.Quad)
                for _, child in ipairs(NotifFrame:GetChildren()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        Utility:Tween(child, {TextTransparency = 1}, 0.2)
                    end
                end
                Utility:Tween(NotifStroke, {Thickness = 0}, 0.2)
                task.delay(0.2, function()
                    if NotifFrame then
                        NotifFrame:Destroy()
                    end
                end)
            end
        end)

        return Notification
    end

    function Window:SelectTab(tabName)
        for _, tab in ipairs(Tabs) do
            if tab.Name == tabName then
                tab.Button:ClickButton1()
                break
            end
        end
    end

    -- Window Controls
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Utility:Tween(Content, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, EASING_STYLES.Quad)
            Utility:Tween(Sidebar, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, EASING_STYLES.Quad)
            Utility:Tween(Main, {Size = UDim2.new(0, 400, 0, 46)}, 0.25, EASING_STYLES.Quad)
        else
            Utility:Tween(Sidebar, {Size = UDim2.new(0, 160, 1, -56)}, 0.25, EASING_STYLES.Quad)
            Utility:Tween(Content, {Size = UDim2.new(1, -176, 1, -56)}, 0.25, EASING_STYLES.Quad)
            Utility:Tween(Main, {Size = originalSize}, 0.25, EASING_STYLES.Quad)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Utility:Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, EASING_STYLES.Quad)
        Utility:Tween(Main, {Position = UDim2.new(0.5, 0, 1.5, 0)}, 0.3, EASING_STYLES.Quad)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)

    MinimizeBtn.MouseEnter:Connect(function()
        Utility:Tween(MinimizeBtn, {BackgroundColor3 = Config.Theme.CardHover}, 0.1)
    end)

    MinimizeBtn.MouseLeave:Connect(function()
        Utility:Tween(MinimizeBtn, {BackgroundColor3 = Config.Theme.Dark}, 0.1)
    end)

    CloseBtn.MouseEnter:Connect(function()
        Utility:Tween(CloseBtn, {BackgroundColor3 = Utility:ShadeColor3(Config.Theme.Error, 0.2)}, 0.1)
    end)

    CloseBtn.MouseLeave:Connect(function()
        Utility:Tween(CloseBtn, {BackgroundColor3 = Config.Theme.Dark}, 0.1)
    end)

    Utility:Dragify(Main)

    Main.Size = UDim2.new(0, 0, 0, 0)
    Utility:Tween(Main, {Size = Config.Size}, 0.35, EASING_STYLES.Back)

    Window.Main = Main
    Window.ScreenGui = ScreenGui
    return Window
end

return Aurora


