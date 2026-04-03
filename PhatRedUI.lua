--[[
  ╔═══════════════════════════════════════════════════════╗
  ║  PhatUI RED Edition - Modern Roblox UI Library       ║
  ║  Based on REDz HUB Logic + Enhanced Features         ║
  ║  Version 1.0                                         ║
  ╚═══════════════════════════════════════════════════════╝
  
  Features:
  - Notifications System
  - Window with Tabs
  - All Controls: Button, Toggle, Slider, Keybind, TextBox, 
    ColorPicker, Dropdown, TextLabel, ImageLabel, Paragraph, Section
  - Icon Support (Image-based)
  - SetDesc/GetDesc for Paragraph
  - Mobile Toggle Support
  - Draggable Window
  - Key System Support
]]

local PhatUIRed = {}
PhatUIRed.__index = PhatUIRed

-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer

--===========================================================
-- CONFIGURATION
--===========================================================
local Configs = {
    -- Colors (Dark Theme)
    Cor_Hub = Color3.fromRGB(15, 15, 15),
    Cor_Options = Color3.fromRGB(22, 22, 22),
    Cor_Stroke = Color3.fromRGB(55, 55, 55),
    Cor_Text = Color3.fromRGB(245, 245, 245),
    Cor_DarkText = Color3.fromRGB(140, 140, 140),
    Cor_Accent = Color3.fromRGB(28, 120, 212),
    Cor_Hover = Color3.fromRGB(35, 35, 35),
    
    -- Styling
    Corner_Radius = UDim.new(0, 6),
    Text_Font = Enum.Font.GothamBold,
    
    -- Sizes
    Window_Width = 500,
    Window_Height = 320,
    Tab_Height = 32,
    Control_Height = 32,
}

--===========================================================
-- ICON ASSETS (Image IDs from Roblox)
--===========================================================
local Icons = {
    -- Basic Icons
    None = "",
    Home = "rbxassetid://6031091004",
    User = "rbxassetid://6031094678",
    Settings = "rbxassetid://6031091063",
    Search = "rbxassetid://6031099677",
    Bell = "rbxassetid://6031091065",
    Mail = "rbxassetid://6031091066",
    
    -- Actions
    Plus = "rbxassetid://6031094679",
    Minus = "rbxassetid://6031068423",
    Check = "rbxassetid://6031091004",
    Close = "rbxassetid://6031091003",
    Copy = "rbxassetid://6035273419",
    Paste = "rbxassetid://6035273435",
    Refresh = "rbxassetid://6031091273",
    
    -- Navigation
    ArrowLeft = "rbxassetid://6031091113",
    ArrowRight = "rbxassetid://6031091114",
    ChevronLeft = "rbxassetid://6031091090",
    ChevronRight = "rbxassetid://6031091091",
    ChevronDown = "rbxassetid://6031091078",
    ChevronUp = "rbxassetid://6031091077",
    
    -- Status
    Info = "rbxassetid://6031091070",
    Warning = "rbxassetid://6031091072",
    Error = "rbxassetid://6031091071",
    Success = "rbxassetid://6031091004",
    
    -- Media
    Play = "rbxassetid://6031091156",
    Pause = "rbxassetid://6031091154",
    Music = "rbxassetid://6031091150",
    Volume = "rbxassetid://6031091163",
    Video = "rbxassetid://6031091170",
    Image = "rbxassetid://6031091176",
    
    -- Objects
    Star = "rbxassetid://6031091060",
    Heart = "rbxassetid://6031091069",
    Flag = "rbxassetid://6031091116",
    Lock = "rbxassetid://6031091089",
    Unlock = "rbxassetid://6031091088",
    Eye = "rbxassetid://6031091094",
    EyeOff = "rbxassetid://6031091095",
    
    -- Tools
    Hammer = "rbxassetid://6031091124",
    Wrench = "rbxassetid://6031091133",
    Gear = "rbxassetid://6031091063",
    Code = "rbxassetid://6031091286",
    Terminal = "rbxassetid://6031091287",
    TerminalBold = "rbxassetid://15155219405",
    
    -- Misc
    Fire = "rbxassetid://6031091074",
    Lightning = "rbxassetid://6031091073",
    Crown = "rbxassetid://6031091105",
    Shield = "rbxassetid://6031091098",
    Sword = "rbxassetid://6031091145",
    Bomb = "rbxassetid://6031091121",
    
    -- UI Elements
    List = "rbxassetid://6031091003",
    Grid = "rbxassetid://6031091006",
    Menu = "rbxassetid://6031091003",
    Minimise = "rbxassetid://6031091252",
    Maximise = "rbxassetid://6031091253",
    
    -- Social
    Group = "rbxassetid://6031091080",
    Message = "rbxassetid://6031091081",
    Chat = "rbxassetid://6031091082",
}

-- Default button icon
local DefaultIcon = "rbxassetid://15155219405"

--===========================================================
-- UTILITY FUNCTIONS
--===========================================================
local function Create(instance, parent, props)
    local new = Instance.new(instance, parent)
    if props then
        for prop, value in pairs(props) do
            new[prop] = value
        end
    end
    return new
end

local function SetProps(instance, props)
    if instance and props then
        for prop, value in pairs(props) do
            instance[prop] = value
        end
    end
    return instance
end

local function Corner(parent, radius, props)
    local c = Create("UICorner", parent)
    c.CornerRadius = radius or Configs.Corner_Radius
    if props then
        SetProps(c, props)
    end
    return c
end

local function Stroke(parent, props)
    local s = Create("UIStroke", parent)
    s.Color = Configs.Cor_Stroke
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    if props then
        SetProps(s, props)
    end
    return s
end

local function Padding(parent, props)
    local p = Create("UIPadding", parent)
    if props then
        SetProps(p, props)
    end
    return p
end

local function ListLayout(parent, props)
    local l = Create("UIListLayout", parent)
    l.Padding = UDim.new(0, 5)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    if props then
        SetProps(l, props)
    end
    return l
end

local function CreateTween(instance, prop, value, time, callback)
    time = time or 0.2
    local tween = TweenService:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[prop] = value})
    tween:Play()
    if callback then
        tween.Completed:Connect(callback)
    end
    return tween
end

local function TweenSize(instance, size, time, callback)
    CreateTween(instance, "Size", size, time or 0.2, callback)
end

local function TweenPos(instance, pos, time, callback)
    CreateTween(instance, "Position", pos, time or 0.2, callback)
end

local function TweenColor(instance, prop, color, time, callback)
    CreateTween(instance, prop, color, time or 0.2, callback)
end

--===========================================================
-- ICON RESOLVER
--===========================================================
local function GetIcon(iconName)
    if not iconName or iconName == "" or iconName == "None" then
        return ""
    end
    if Icons[iconName] then
        return Icons[iconName]
    end
    return iconName
end

--===========================================================
-- NOTIFICATION SYSTEM
--===========================================================
local NotificationContainer

local function CreateNotificationContainer()
    if NotificationContainer then return NotificationContainer end
    
    NotificationContainer = Create("Frame", CoreGui, {
        Name = "PhatUIRed_Notifications",
        Size = UDim2.new(0, 320, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        ZIndex = 9999,
    })
    
    Padding(NotificationContainer, {
        PaddingLeft = UDim.new(0, 15),
        PaddingTop = UDim.new(0, 15),
        PaddingBottom = UDim.new(0, 50),
    })
    
    ListLayout(NotificationContainer, {
        Padding = UDim.new(0, 10),
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
    })
    
    return NotificationContainer
end

function PhatUIRed:Notify(title, text, duration)
    duration = duration or 5
    local container = CreateNotificationContainer()
    
    local mainFrame = Create("Frame", container, {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 10000,
    })
    
    local contentFrame = Create("Frame", mainFrame, {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Configs.Cor_Hub,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 10001,
    })
    Corner(contentFrame)
    Stroke(contentFrame, {Thickness = 1})
    
    Padding(contentFrame, {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
    })
    
    local titleLabel = Create("TextLabel", contentFrame, {
        Name = "Title",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = title or "Notification",
        TextColor3 = Configs.Cor_Text,
        TextSize = 14,
        Font = Configs.Text_Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 10002,
    })
    
    local textLabel = Create("TextLabel", contentFrame, {
        Name = "Text",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = text or "",
        TextColor3 = Configs.Cor_DarkText,
        TextSize = 12,
        Font = Configs.Text_Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = 10002,
    })
    
    local progressBar = Create("Frame", contentFrame, {
        Name = "Progress",
        Size = UDim2.new(1, 0, 0, 3),
        BackgroundColor3 = Configs.Cor_Accent,
        ZIndex = 10002,
    })
    
    -- Animation
    contentFrame.Position = UDim2.new(0, 20, 0, 0)
    TweenPos(contentFrame, UDim2.new(0, 0, 0, 0), 0.3)
    
    -- Progress bar animation
    task.spawn(function()
        CreateTween(progressBar, "Size", UDim2.new(0, 0, 1, 0), duration)
    end)
    
    -- Auto destroy
    task.spawn(function()
        task.wait(duration + 0.3)
        if mainFrame and mainFrame.Parent then
            TweenPos(contentFrame, UDim2.new(0, 20, 0, 0), 0.2, function()
                mainFrame:Destroy()
            end)
        end
    end)
    
    return mainFrame
end

--===========================================================
-- MAIN WINDOW
--===========================================================
local function MakeWindow(configs)
    configs = configs or {}
    
    local windowConfig = configs.Window or {}
    local keyConfig = configs.Key or {}
    
    local title = windowConfig.Title or "PhatUI RED"
    local subtitle = windowConfig.Subtitle or ""
    
    -- Key System
    local keyEnabled = keyConfig.Enabled or false
    local keyTitle = keyConfig.Title or "Key System"
    local keyDesc = keyConfig.Description or "Enter your key to continue"
    local keyList = keyConfig.Keys or {"123"}
    local keyLink = keyConfig.KeyLink or ""
    
    -- Create ScreenGui
    local ScreenGui = Create("ScreenGui", CoreGui, {
        Name = "PhatUIRed",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    
    -- Check for existing
    local existing = CoreGui:FindFirstChild("PhatUIRed")
    if existing then
        existing:Destroy()
    end
    
    -- Key System Window
    if keyEnabled then
        local keyFrame = Create("Frame", ScreenGui, {
            Name = "KeyFrame",
            Size = UDim2.new(0, 380, 0, 200),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Configs.Cor_Hub,
            ZIndex = 1000,
        })
        Corner(keyFrame)
        Stroke(keyFrame)
        
        local keyTitleLabel = Create("TextLabel", keyFrame, {
            Name = "Title",
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 15, 0, 15),
            BackgroundTransparency = 1,
            Text = keyTitle,
            TextColor3 = Configs.Cor_Text,
            TextSize = 18,
            Font = Configs.Text_Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 1001,
        })
        
        local keyDescLabel = Create("TextLabel", keyFrame, {
            Name = "Description",
            Size = UDim2.new(1, -30, 0, 30),
            Position = UDim2.new(0, 15, 0, 45),
            BackgroundTransparency = 1,
            Text = keyDesc,
            TextColor3 = Configs.Cor_DarkText,
            TextSize = 12,
            Font = Configs.Text_Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 1001,
        })
        
        local keyTextBox = Create("TextBox", keyFrame, {
            Name = "KeyInput",
            Size = UDim2.new(1, -30, 0, 40),
            Position = UDim2.new(0, 15, 0, 80),
            BackgroundColor3 = Configs.Cor_Options,
            PlaceholderText = "Enter your key...",
            PlaceholderColor3 = Configs.Cor_DarkText,
            Text = "",
            TextColor3 = Configs.Cor_Text,
            TextSize = 16,
            Font = Configs.Text_Font,
            ZIndex = 1001,
        })
        Corner(keyTextBox)
        Stroke(keyTextBox)
        
        local confirmBtn = Create("TextButton", keyFrame, {
            Name = "Confirm",
            Size = UDim2.new(0.45, 0, 0, 35),
            Position = UDim2.new(0.05, 15, 1, -50),
            BackgroundColor3 = Configs.Cor_Options,
            Text = "Confirm",
            TextColor3 = Configs.Cor_Text,
            TextSize = 14,
            Font = Configs.Text_Font,
            ZIndex = 1001,
        })
        Corner(confirmBtn)
        Stroke(confirmBtn)
        
        local getKeyBtn = Create("TextButton", keyFrame, {
            Name = "GetKey",
            Size = UDim2.new(0.45, 0, 0, 35),
            Position = UDim2.new(0.55, 0, 1, -50),
            BackgroundColor3 = Configs.Cor_Options,
            Text = "Get Key",
            TextColor3 = Configs.Cor_Text,
            TextSize = 14,
            Font = Configs.Text_Font,
            ZIndex = 1001,
        })
        Corner(getKeyBtn)
        Stroke(getKeyBtn)
        
        local keyVerified = false
        
        confirmBtn.MouseButton1Click:Connect(function()
            local inputKey = keyTextBox.Text
            for _, validKey in ipairs(keyList) do
                if inputKey == validKey then
                    keyVerified = true
                    break
                end
            end
            
            if keyVerified then
                TweenSize(keyFrame, UDim2.new(0, 0, 0, 0), 0.3, function()
                    keyFrame:Destroy()
                end)
            else
                TweenColor(keyTextBox, "BorderColor3", Color3.fromRGB(255, 50, 50), 0.2)
                task.wait(0.2)
                Stroke(keyTextBox, {Color = Configs.Cor_Stroke})
            end
        end)
        
        getKeyBtn.MouseButton1Click:Connect(function()
            if keyLink ~= "" then
                setclipboard(keyLink)
                PhatUIRed:Notify("Copied!", "Key link copied to clipboard", 3)
            end
        end)
        
        repeat task.wait() until keyVerified
    end
    
    -- Main Window
    local MainFrame = Create("Frame", ScreenGui, {
        Name = "MainWindow",
        Size = UDim2.new(0, Configs.Window_Width, 0, Configs.Window_Height),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Configs.Cor_Hub,
        Active = true,
        Draggable = true,
    })
    Corner(MainFrame)
    Stroke(MainFrame)
    
    -- Title Bar
    local TitleBar = Create("Frame", MainFrame, {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        ZIndex = 2,
    })
    
    local titleLabel = Create("TextLabel", TitleBar, {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Configs.Cor_Text,
        TextSize = 15,
        Font = Configs.Text_Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
    })
    
    if subtitle ~= "" then
        titleLabel.Text = title .. "  |  " .. subtitle
        titleLabel.TextColor3 = Configs.Cor_DarkText
    end
    
    local buttonContainer = Create("Frame", TitleBar, {
        Name = "Buttons",
        Size = UDim2.new(0, 70, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 3,
    })
    
    local minimizeBtn = Create("TextButton", buttonContainer, {
        Name = "Minimize",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -65, 0.5, -14),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Configs.Cor_Options,
        Text = "−",
        TextColor3 = Configs.Cor_Text,
        TextSize = 18,
        Font = Configs.Text_Font,
        ZIndex = 4,
    })
    Corner(minimizeBtn, UDim.new(0, 4))
    
    local closeBtn = Create("TextButton", buttonContainer, {
        Name = "Close",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -10, 0.5, -14),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Configs.Cor_Options,
        Text = "×",
        TextColor3 = Configs.Cor_Text,
        TextSize = 18,
        Font = Configs.Text_Font,
        ZIndex = 4,
    })
    Corner(closeBtn, UDim.new(0, 4))
    
    -- Minimize/Restore functionality
    local isMinimized = false
    local normalSize = MainFrame.Size
    local normalPos = MainFrame.Position
    
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            TweenSize(MainFrame, UDim2.new(0, Configs.Window_Width, 0, 36), 0.2)
            minimizeBtn.Text = "+"
        else
            TweenSize(MainFrame, normalSize, 0.2)
            minimizeBtn.Text = "−"
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenSize(MainFrame, UDim2.new(0, 0, 0, 0), 0.3, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Tab Container (Left Sidebar)
    local TabContainer = Create("Frame", MainFrame, {
        Name = "TabContainer",
        Size = UDim2.new(0, 130, 1, -40),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
    })
    
    local TabScroll = Create("ScrollingFrame", TabContainer, {
        Name = "TabScroll",
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ZIndex = 1,
    })
    
    ListLayout(TabScroll, {
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
    })
    
    Padding(TabScroll, {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 5),
    })
    
    -- Content Container (Right Side)
    local ContentContainer = Create("Frame", MainFrame, {
        Name = "ContentContainer",
        Size = UDim2.new(1, -140, 1, -40),
        Position = UDim2.new(1, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1,
    })
    
    -- Separator Line
    local separator = Create("Frame", MainFrame, {
        Name = "Separator",
        Size = UDim2.new(0, 1, 1, -40),
        Position = UDim2.new(0, 130, 0, 36),
        BackgroundColor3 = Configs.Cor_Stroke,
        BorderSizePixel = 0,
        ZIndex = 1,
    })
    
    local Window = {
        _tabs = {},
        _currentTab = nil,
        _isOpen = true,
        _ScreenGui = ScreenGui,
    }
    
    -- Tab Functions
    function Window:AddTab(configs)
        configs = configs or {}
        local tabName = configs.Name or "Tab"
        local tabIcon = configs.Icon or "None"
        
        local TabFrame = Create("Frame", TabScroll, {
            Name = tabName,
            Size = UDim2.new(1, -10, 0, Configs.Tab_Height),
            BackgroundColor3 = Configs.Cor_Options,
            ZIndex = 2,
        })
        Corner(TabFrame, UDim.new(0, 4))
        
        local TabBtn = Create("TextButton", TabFrame, {
            Name = "Button",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            ZIndex = 3,
        })
        
        local TabIcon = Create("ImageLabel", TabBtn, {
            Name = "Icon",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 8, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            Image = GetIcon(tabIcon),
            ImageColor3 = Configs.Cor_DarkText,
            ZIndex = 4,
        })
        
        local TabLabel = Create("TextLabel", TabBtn, {
            Name = "Label",
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Configs.Cor_DarkText,
            TextSize = 12,
            Font = Configs.Text_Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 4,
        })
        
        -- Content Frame for this tab
        local TabContent = Create("ScrollingFrame", ContentContainer, {
            Name = tabName .. "_Content",
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Configs.Cor_Stroke,
            Visible = false,
            ZIndex = 1,
        })
        
        Padding(TabContent, {
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
        })
        
        ListLayout(TabContent, {
            Padding = UDim.new(0, 8),
        })
        
        local TabObj = {
            _content = TabContent,
            _frame = TabFrame,
            _label = TabLabel,
            _icon = TabIcon,
            _elements = {},
        }
        
        function TabObj:AddSection(configs)
            configs = configs or {}
            local sectionName = configs.Name or "Section"
            local sectionIcon = configs.Icon or "None"
            
            local SectionHeader = Create("Frame", TabContent, {
                Name = sectionName,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                ZIndex = 2,
            })
            
            local SectionLabel = Create("TextLabel", SectionHeader, {
                Name = "Label",
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = (sectionIcon ~= "None" and "" or "") .. sectionName,
                TextColor3 = Configs.Cor_Accent,
                TextSize = 13,
                Font = Configs.Text_Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 3,
            })
            
            if sectionIcon ~= "None" then
                local sectionIconImg = Create("ImageLabel", SectionHeader, {
                    Name = "Icon",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundTransparency = 1,
                    Image = GetIcon(sectionIcon),
                    ImageColor3 = Configs.Cor_Accent,
                    ZIndex = 3,
                })
            end
            
            local SectionContent = Create("Frame", TabContent, {
                Name = sectionName .. "_Content",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundColor3 = Configs.Cor_Hub,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 2,
            })
            Corner(SectionContent)
            
            local SectionInner = Create("Frame", SectionContent, {
                Name = "Inner",
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                AutomaticSize = Enum.AutomaticSize.Y,
                ZIndex = 3,
            })
            
            Padding(SectionInner, {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                PaddingTop = UDim.new(0, 10),
                PaddingBottom = UDim.new(0, 10),
            })
            
            ListLayout(SectionInner, {
                Padding = UDim.new(0, 6),
            })
            
            local Sec = {
                _content = SectionInner,
                _elements = {},
            }
            
            -- Add Button
            function Sec:AddButton(configs)
                configs = configs or {}
                local btnName = configs.Name or "Button"
                local btnIcon = configs.Icon or "None"
                local btnCallback = configs.Callback or function() end
                
                local BtnFrame = Create("Frame", SectionInner, {
                    Name = btnName,
                    Size = UDim2.new(1, 0, 0, Configs.Control_Height),
                    BackgroundColor3 = Configs.Cor_Options,
                    ZIndex = 4,
                })
                Corner(BtnFrame)
                
                local Btn = Create("TextButton", BtnFrame, {
                    Name = "Button",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                })
                
                if btnIcon ~= "None" then
                    local BtnIcon = Create("ImageLabel", Btn, {
                        Name = "Icon",
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Image = GetIcon(btnIcon),
                        ImageColor3 = Configs.Cor_Accent,
                        ZIndex = 6,
                    })
                end
                
                local BtnLabel = Create("TextLabel", Btn, {
                    Name = "Label",
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = btnIcon ~= "None" and UDim2.new(0, 40, 0, 0) or UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = btnName,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                })
                
                Btn.MouseButton1Click:Connect(function()
                    btnCallback()
                end)
                
                Btn.MouseEnter:Connect(function()
                    TweenColor(BtnFrame, "BackgroundColor3", Configs.Cor_Hover, 0.15)
                end)
                
                Btn.MouseLeave:Connect(function()
                    TweenColor(BtnFrame, "BackgroundColor3", Configs.Cor_Options, 0.15)
                end)
                
                return BtnFrame
            end
            
            -- Add Toggle
            function Sec:AddToggle(configs)
                configs = configs or {}
                local toggleName = configs.Name or "Toggle"
                local toggleIcon = configs.Icon or "None"
                local toggleDefault = configs.Default or false
                local toggleCallback = configs.Callback or function() end
                
                local ToggleFrame = Create("Frame", SectionInner, {
                    Name = toggleName,
                    Size = UDim2.new(1, 0, 0, Configs.Control_Height),
                    BackgroundColor3 = Configs.Cor_Options,
                    ZIndex = 4,
                })
                Corner(ToggleFrame)
                
                local Toggle = Create("TextButton", ToggleFrame, {
                    Name = "Toggle",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                })
                
                if toggleIcon ~= "None" then
                    local ToggleIcon = Create("ImageLabel", Toggle, {
                        Name = "Icon",
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Image = GetIcon(toggleIcon),
                        ImageColor3 = Configs.Cor_DarkText,
                        ZIndex = 6,
                    })
                end
                
                local ToggleLabel = Create("TextLabel", Toggle, {
                    Name = "Label",
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = toggleIcon ~= "None" and UDim2.new(0, 40, 0, 0) or UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = toggleName,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                })
                
                local ToggleBox = Create("Frame", Toggle, {
                    Name = "Box",
                    Size = UDim2.new(0, 44, 0, 22),
                    Position = UDim2.new(1, -56, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Configs.Cor_Stroke,
                    ZIndex = 6,
                })
                Corner(ToggleBox, UDim.new(1, 0))
                
                local ToggleKnob = Create("Frame", ToggleBox, {
                    Name = "Knob",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Configs.Cor_DarkText,
                    ZIndex = 7,
                })
                Corner(ToggleKnob, UDim.new(1, 0))
                
                local isOn = toggleDefault
                
                local function UpdateToggle(state)
                    isOn = state
                    if isOn then
                        TweenColor(ToggleBox, "BackgroundColor3", Configs.Cor_Accent, 0.2)
                        TweenColor(ToggleKnob, "BackgroundColor3", Configs.Cor_Text, 0.2)
                        TweenPos(ToggleKnob, UDim2.new(0, 25, 0.5, 0), 0.2)
                        ToggleLabel.TextColor3 = Configs.Cor_Accent
                    else
                        TweenColor(ToggleBox, "BackgroundColor3", Configs.Cor_Stroke, 0.2)
                        TweenColor(ToggleKnob, "BackgroundColor3", Configs.Cor_DarkText, 0.2)
                        TweenPos(ToggleKnob, UDim2.new(0, 3, 0.5, 0), 0.2)
                        ToggleLabel.TextColor3 = Configs.Cor_Text
                    end
                    toggleCallback(isOn)
                end
                
                Toggle.MouseButton1Click:Connect(function()
                    UpdateToggle(not isOn)
                end)
                
                Toggle.MouseEnter:Connect(function()
                    TweenColor(ToggleFrame, "BackgroundColor3", Configs.Cor_Hover, 0.15)
                end)
                
                Toggle.MouseLeave:Connect(function()
                    TweenColor(ToggleFrame, "BackgroundColor3", Configs.Cor_Options, 0.15)
                end)
                
                -- Initialize
                if toggleDefault then
                    UpdateToggle(true)
                end
                
                local ToggleObj = {
                    _box = ToggleBox,
                    _knob = ToggleKnob,
                    _label = ToggleLabel,
                    _isOn = isOn,
                    Get = function() return isOn end,
                    Set = function(v) UpdateToggle(v) end,
                }
                
                return ToggleObj
            end
            
            -- Add Slider
            function Sec:AddSlider(configs)
                configs = configs or {}
                local sliderName = configs.Name or "Slider"
                local sliderIcon = configs.Icon or "None"
                local sliderMin = configs.Min or 0
                local sliderMax = configs.Max or 100
                local sliderDefault = configs.Default or ((sliderMax - sliderMin) / 2)
                local sliderCallback = configs.Callback or function() end
                
                local SliderFrame = Create("Frame", SectionInner, {
                    Name = sliderName,
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Configs.Cor_Options,
                    ZIndex = 4,
                })
                Corner(SliderFrame)
                
                local SliderTop = Create("Frame", SliderFrame, {
                    Name = "Top",
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 0, 5),
                    BackgroundTransparency = 1,
                    ZIndex = 5,
                })
                
                if sliderIcon ~= "None" then
                    local SliderIcon = Create("ImageLabel", SliderTop, {
                        Name = "Icon",
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(0, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Image = GetIcon(sliderIcon),
                        ImageColor3 = Configs.Cor_Accent,
                        ZIndex = 6,
                    })
                end
                
                local SliderLabel = Create("TextLabel", SliderTop, {
                    Name = "Label",
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = sliderIcon ~= "None" and UDim2.new(0, 25, 0, 0) or UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = sliderName,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 12,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                })
                
                local SliderValue = Create("TextLabel", SliderTop, {
                    Name = "Value",
                    Size = UDim2.new(0, 40, 1, 0),
                    Position = UDim2.new(1, -40, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(sliderDefault),
                    TextColor3 = Configs.Cor_Accent,
                    TextSize = 12,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 6,
                })
                
                local SliderBarBg = Create("Frame", SliderFrame, {
                    Name = "BarBg",
                    Size = UDim2.new(1, -20, 0, 6),
                    Position = UDim2.new(0, 10, 1, -14),
                    BackgroundColor3 = Configs.Cor_Stroke,
                    ZIndex = 5,
                })
                Corner(SliderBarBg, UDim.new(1, 0))
                
                local SliderBarFill = Create("Frame", SliderBarBg, {
                    Name = "Fill",
                    Size = UDim2.new(0.5, 0, 1, 0),
                    BackgroundColor3 = Configs.Cor_Accent,
                    ZIndex = 6,
                })
                Corner(SliderBarFill, UDim.new(1, 0))
                
                local SliderKnob = Create("Frame", SliderBarBg, {
                    Name = "Knob",
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0.5, -7, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundColor3 = Configs.Cor_Text,
                    ZIndex = 7,
                })
                Corner(SliderKnob, UDim.new(1, 0))
                
                local currentValue = sliderDefault
                local dragging = false
                
                local function UpdateSlider(value)
                    currentValue = math.clamp(value, sliderMin, sliderMax)
                    local percent = (currentValue - sliderMin) / (sliderMax - sliderMin)
                    SliderBarFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(percent, 0, 0.5, 0)
                    SliderValue.Text = tostring(math.floor(currentValue))
                    sliderCallback(currentValue)
                end
                
                SliderFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        local mousePos = UserInputService:GetMouseLocation()
                        local barPos = SliderBarBg.AbsolutePosition
                        local barSize = SliderBarBg.AbsoluteSize
                        local percent = math.clamp((mousePos.X - barPos.X) / barSize.X, 0, 1)
                        UpdateSlider(sliderMin + percent * (sliderMax - sliderMin))
                    end
                end)
                
                SliderFrame.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mousePos = UserInputService:GetMouseLocation()
                        local barPos = SliderBarBg.AbsolutePosition
                        local barSize = SliderBarBg.AbsoluteSize
                        local percent = math.clamp((mousePos.X - barPos.X) / barSize.X, 0, 1)
                        UpdateSlider(sliderMin + percent * (sliderMax - sliderMin))
                    end
                end)
                
                SliderFrame.MouseEnter:Connect(function()
                    TweenColor(SliderFrame, "BackgroundColor3", Configs.Cor_Hover, 0.15)
                end)
                
                SliderFrame.MouseLeave:Connect(function()
                    TweenColor(SliderFrame, "BackgroundColor3", Configs.Cor_Options, 0.15)
                end)
                
                UpdateSlider(sliderDefault)
                
                local SliderObj = {
                    _fill = SliderBarFill,
                    _knob = SliderKnob,
                    _value = SliderValue,
                    Get = function() return currentValue end,
                    Set = function(v) UpdateSlider(v) end,
                }
                
                return SliderObj
            end
            
            -- Add TextBox
            function Sec:AddTextBox(configs)
                configs = configs or {}
                local boxName = configs.Name or "TextBox"
                local boxIcon = configs.Icon or "None"
                local boxPlaceholder = configs.Placeholder or ""
                local boxDefault = configs.Default or ""
                local boxCallback = configs.Callback or function() end
                
                local BoxFrame = Create("Frame", SectionInner, {
                    Name = boxName,
                    Size = UDim2.new(1, 0, 0, Configs.Control_Height),
                    BackgroundColor3 = Configs.Cor_Options,
                    ZIndex = 4,
                })
                Corner(BoxFrame)
                
                local Box = Create("TextBox", BoxFrame, {
                    Name = "Input",
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = boxDefault,
                    PlaceholderText = boxPlaceholder,
                    PlaceholderColor3 = Configs.Cor_DarkText,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false,
                    ZIndex = 5,
                })
                
                if boxIcon ~= "None" then
                    local BoxIcon = Create("ImageLabel", BoxFrame, {
                        Name = "Icon",
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(1, -25, 0.5, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        BackgroundTransparency = 1,
                        Image = GetIcon(boxIcon),
                        ImageColor3 = Configs.Cor_DarkText,
                        ZIndex = 6,
                    })
                end
                
                Box.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        boxCallback(Box.Text, true)
                    else
                        boxCallback(Box.Text, false)
                    end
                end)
                
                Box.MouseEnter:Connect(function()
                    TweenColor(BoxFrame, "BackgroundColor3", Configs.Cor_Hover, 0.15)
                end)
                
                Box.MouseLeave:Connect(function()
                    TweenColor(BoxFrame, "BackgroundColor3", Configs.Cor_Options, 0.15)
                end)
                
                local BoxObj = {
                    _box = Box,
                    Get = function() return Box.Text end,
                    Set = function(v) Box.Text = v end,
                }
                
                return BoxObj
            end
            
            -- Add Dropdown
            function Sec:AddDropdown(configs)
                configs = configs or {}
                local ddName = configs.Name or "Dropdown"
                local ddIcon = configs.Icon or "None"
                local ddOptions = configs.Options or {"Option 1", "Option 2", "Option 3"}
                local ddDefault = configs.Default or ddOptions[1]
                local ddCallback = configs.Callback or function() end
                
                local DdFrame = Create("Frame", SectionInner, {
                    Name = ddName,
                    Size = UDim2.new(1, 0, 0, Configs.Control_Height),
                    BackgroundColor3 = Configs.Cor_Options,
                    ZIndex = 4,
                })
                Corner(DdFrame)
                
                local Dd = Create("TextButton", DdFrame, {
                    Name = "Dropdown",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                })
                
                if ddIcon ~= "None" then
                    local DdIcon = Create("ImageLabel", Dd, {
                        Name = "Icon",
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Image = GetIcon(ddIcon),
                        ImageColor3 = Configs.Cor_Accent,
                        ZIndex = 6,
                    })
                end
                
                local DdLabel = Create("TextLabel", Dd, {
                    Name = "Label",
                    Size = UDim2.new(1, -70, 1, 0),
                    Position = ddIcon ~= "None" and UDim2.new(0, 40, 0, 0) or UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = ddName,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                })
                
                local DdValue = Create("TextLabel", Dd, {
                    Name = "Value",
                    Size = UDim2.new(0, 80, 1, 0),
                    Position = UDim2.new(1, -90, 0, 0),
                    BackgroundTransparency = 1,
                    Text = ddDefault or "Select...",
                    TextColor3 = Configs.Cor_DarkText,
                    TextSize = 12,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 6,
                })
                
                local DdArrow = Create("ImageLabel", Dd, {
                    Name = "Arrow",
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -20, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Image = GetIcon("ChevronDown"),
                    ImageColor3 = Configs.Cor_DarkText,
                    ZIndex = 6,
                })
                
                local DdList = Create("Frame", DdFrame, {
                    Name = "List",
                    Size = UDim2.new(1, -10, 0, 0),
                    Position = UDim2.new(0, 5, 1, 4),
                    BackgroundColor3 = Configs.Cor_Hub,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 10,
                })
                Corner(DdList)
                Stroke(DdList, {Thickness = 1})
                
                local DdListInner = Create("Frame", DdList, {
                    Name = "Inner",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 11,
                })
                
                Padding(DdListInner, {
                    PaddingTop = UDim.new(0, 5),
                    PaddingBottom = UDim.new(0, 5),
                })
                
                ListLayout(DdListInner, {
                    Padding = UDim.new(0, 3),
                })
                
                local isOpen = false
                local selectedValue = ddDefault
                
                local function AddOption(optionName)
                    local OptFrame = Create("Frame", DdListInner, {
                        Name = optionName,
                        Size = UDim2.new(1, -10, 0, 28),
                        BackgroundColor3 = Configs.Cor_Options,
                        ZIndex = 12,
                    })
                    Corner(OptFrame, UDim.new(0, 4))
                    
                    local Opt = Create("TextButton", OptFrame, {
                        Name = "Option",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                        ZIndex = 13,
                    })
                    
                    local OptLabel = Create("TextLabel", Opt, {
                        Name = "Label",
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = optionName,
                        TextColor3 = Configs.Cor_Text,
                        TextSize = 12,
                        Font = Configs.Text_Font,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 14,
                    })
                    
                    Opt.MouseButton1Click:Connect(function()
                        selectedValue = optionName
                        DdValue.Text = optionName
                        DdValue.TextColor3 = Configs.Cor_Text
                        ddCallback(optionName)
                        
                        -- Close dropdown
                        isOpen = false
                        TweenSize(DdList, UDim2.new(1, -10, 0, 0), 0.2)
                        TweenColor(DdArrow, "ImageColor3", Configs.Cor_DarkText, 0.2)
                    end)
                    
                    Opt.MouseEnter:Connect(function()
                        TweenColor(OptFrame, "BackgroundColor3", Configs.Cor_Hover, 0.1)
                    end)
                    
                    Opt.MouseLeave:Connect(function()
                        TweenColor(OptFrame, "BackgroundColor3", Configs.Cor_Options, 0.1)
                    end)
                end
                
                for _, opt in ipairs(ddOptions) do
                    AddOption(opt)
                end
                
                Dd.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        local listHeight = #ddOptions * 31 + 10
                        TweenSize(DdList, UDim2.new(1, -10, 0, listHeight), 0.2)
                        TweenColor(DdArrow, "ImageColor3", Configs.Cor_Accent, 0.2)
                        TweenPos(DdArrow, UDim2.new(1, -20, 0.5, 0), 0.2)
                    else
                        TweenSize(DdList, UDim2.new(1, -10, 0, 0), 0.2)
                        TweenColor(DdArrow, "ImageColor3", Configs.Cor_DarkText, 0.2)
                    end
                end)
                
                DdFrame.MouseEnter:Connect(function()
                    TweenColor(DdFrame, "BackgroundColor3", Configs.Cor_Hover, 0.15)
                end)
                
                DdFrame.MouseLeave:Connect(function()
                    TweenColor(DdFrame, "BackgroundColor3", Configs.Cor_Options, 0.15)
                end)
                
                local DdObj = {
                    _list = DdList,
                    _value = DdValue,
                    _options = ddOptions,
                    Get = function() return selectedValue end,
                    Set = function(v)
                        selectedValue = v
                        DdValue.Text = v
                        ddCallback(v)
                    end,
                    Refresh = function(newOptions)
                        -- Clear old options
                        for _, child in ipairs(DdListInner:GetChildren()) do
                            if child:IsA("Frame") then
                                child:Destroy()
                            end
                        end
                        ddOptions = newOptions
                        for _, opt in ipairs(newOptions) do
                            AddOption(opt)
                        end
                    end,
                }
                
                return DdObj
            end
            
            -- Add Paragraph (NEW! with SetDesc/GetDesc)
            function Sec:AddParagraph(configs)
                configs = configs or {}
                local paraTitle = configs.Title or "Paragraph"
                local paraContent = configs.Content or ""
                local paraIcon = configs.Icon or "None"
                
                local ParaFrame = Create("Frame", SectionInner, {
                    Name = paraTitle,
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = Configs.Cor_Options,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 4,
                })
                Corner(ParaFrame)
                
                local ParaInner = Create("Frame", ParaFrame, {
                    Name = "Inner",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 5,
                })
                
                Padding(ParaInner, {
                    PaddingLeft = UDim.new(0, 12),
                    PaddingRight = UDim.new(0, 12),
                    PaddingTop = UDim.new(0, 8),
                    PaddingBottom = UDim.new(0, 8),
                })
                
                ListLayout(ParaInner, {
                    Padding = UDim.new(0, 4),
                })
                
                local ParaHeader = Create("Frame", ParaInner, {
                    Name = "Header",
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    ZIndex = 6,
                })
                
                local ParaHeaderInner = Create("Frame", ParaHeader, {
                    Name = "Inner",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    ZIndex = 7,
                })
                
                ListLayout(ParaHeaderInner, {
                    Padding = UDim.new(0, 6),
                })
                
                if paraIcon ~= "None" then
                    local ParaIcon = Create("ImageLabel", ParaHeaderInner, {
                        Name = "Icon",
                        Size = UDim2.new(0, 16, 0, 16),
                        BackgroundTransparency = 1,
                        Image = GetIcon(paraIcon),
                        ImageColor3 = Configs.Cor_Accent,
                        ZIndex = 8,
                    })
                end
                
                local ParaTitleLabel = Create("TextLabel", ParaHeaderInner, {
                    Name = "Title",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Text = paraTitle,
                    TextColor3 = Configs.Cor_Accent,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                })
                
                local ParaContentLabel = Create("TextLabel", ParaInner, {
                    Name = "Content",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Text = paraContent,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 12,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true,
                    ZIndex = 6,
                })
                
                local ParaObj = {
                    _title = ParaTitleLabel,
                    _content = ParaContentLabel,
                    _frame = ParaFrame,
                    SetTitle = function(text)
                        ParaTitleLabel.Text = text or ""
                    end,
                    GetTitle = function()
                        return ParaTitleLabel.Text
                    end,
                    SetDesc = function(text)
                        ParaContentLabel.Text = text or ""
                    end,
                    GetDesc = function()
                        return ParaContentLabel.Text
                    end,
                }
                
                return ParaObj
            end
            
            -- Add Label
            function Sec:AddLabel(configs)
                configs = configs or {}
                local labelText = configs.Text or "Label"
                local labelIcon = configs.Icon or "None"
                
                local LabelFrame = Create("Frame", SectionInner, {
                    Name = labelText,
                    Size = UDim2.new(1, 0, 0, 28),
                    BackgroundTransparency = 1,
                    ZIndex = 4,
                })
                
                if labelIcon ~= "None" then
                    local LabelIcon = Create("ImageLabel", LabelFrame, {
                        Name = "Icon",
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(0, 0, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundTransparency = 1,
                        Image = GetIcon(labelIcon),
                        ImageColor3 = Configs.Cor_Accent,
                        ZIndex = 5,
                    })
                end
                
                local Label = Create("TextLabel", LabelFrame, {
                    Name = "Text",
                    Size = UDim2.new(1, labelIcon ~= "None" and -25 or 0, 1, 0),
                    Position = labelIcon ~= "None" and UDim2.new(0, 22, 0, 0) or UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = labelText,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                })
                
                local LabelObj = {
                    _label = Label,
                    Set = function(text) Label.Text = text end,
                    Get = function() return Label.Text end,
                }
                
                return LabelObj
            end
            
            -- Add Keybind
            function Sec:AddKeybind(configs)
                configs = configs or {}
                local keyName = configs.Name or "Keybind"
                local keyDefault = configs.Default or Enum.KeyCode.E
                local keyCallback = configs.Callback or function() end
                
                local KeyFrame = Create("Frame", SectionInner, {
                    Name = keyName,
                    Size = UDim2.new(1, 0, 0, Configs.Control_Height),
                    BackgroundColor3 = Configs.Cor_Options,
                    ZIndex = 4,
                })
                Corner(KeyFrame)
                
                local Key = Create("TextButton", KeyFrame, {
                    Name = "Keybind",
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                })
                
                local KeyLabel = Create("TextLabel", Key, {
                    Name = "Label",
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = keyName,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                })
                
                local KeyDisplay = Create("TextLabel", Key, {
                    Name = "Key",
                    Size = UDim2.new(0, 50, 0, 26),
                    Position = UDim2.new(1, -60, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Configs.Cor_Hub,
                    Text = tostring(keyDefault):split(".")[#tostring(keyDefault):split(".")],
                    TextColor3 = Configs.Cor_Accent,
                    TextSize = 12,
                    Font = Configs.Text_Font,
                    ZIndex = 6,
                })
                Corner(KeyDisplay, UDim.new(0, 4))
                Stroke(KeyDisplay, {Thickness = 1})
                
                local currentKey = keyDefault
                local listening = false
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    if listening then
                        currentKey = input.KeyCode
                        KeyDisplay.Text = tostring(input.KeyCode):split(".")[#tostring(input.KeyCode):split(".")]
                        listening = false
                        KeyDisplay.BackgroundColor3 = Configs.Cor_Hub
                    else
                        if input.KeyCode == currentKey then
                            keyCallback(true)
                        end
                    end
                end)
                
                KeyDisplay.MouseButton1Click:Connect(function()
                    listening = true
                    KeyDisplay.BackgroundColor3 = Configs.Cor_Accent
                    KeyDisplay.Text = "..."
                end)
                
                Key.MouseEnter:Connect(function()
                    TweenColor(KeyFrame, "BackgroundColor3", Configs.Cor_Hover, 0.15)
                end)
                
                Key.MouseLeave:Connect(function()
                    TweenColor(KeyFrame, "BackgroundColor3", Configs.Cor_Options, 0.15)
                end)
                
                local KeyObj = {
                    _display = KeyDisplay,
                    Get = function() return currentKey end,
                    Set = function(k)
                        currentKey = k
                        KeyDisplay.Text = tostring(k):split(".")[#tostring(k):split(".")]
                    end,
                }
                
                return KeyObj
            end
            
            -- Add ColorPicker
            function Sec:AddColorPicker(configs)
                configs = configs or {}
                local pickerName = configs.Name or "ColorPicker"
                local pickerDefault = configs.Default or Color3.fromRGB(255, 255, 255)
                local pickerCallback = configs.Callback or function() end
                
                local PickerFrame = Create("Frame", SectionInner, {
                    Name = pickerName,
                    Size = UDim2.new(1, 0, 0, Configs.Control_Height + 30),
                    BackgroundColor3 = Configs.Cor_Options,
                    ZIndex = 4,
                })
                Corner(PickerFrame)
                
                local Picker = Create("TextButton", PickerFrame, {
                    Name = "Picker",
                    Size = UDim2.new(1, 0, 0, Configs.Control_Height),
                    BackgroundTransparency = 1,
                    Text = "",
                    ZIndex = 5,
                })
                
                local PickerLabel = Create("TextLabel", Picker, {
                    Name = "Label",
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = pickerName,
                    TextColor3 = Configs.Cor_Text,
                    TextSize = 13,
                    Font = Configs.Text_Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                })
                
                local PickerPreview = Create("Frame", Picker, {
                    Name = "Preview",
                    Size = UDim2.new(0, 30, 0, 22),
                    Position = UDim2.new(1, -45, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = pickerDefault,
                    ZIndex = 6,
                })
                Corner(PickerPreview)
                Stroke(PickerPreview, {Thickness = 1})
                
                local ColorSlider = Create("Frame", PickerFrame, {
                    Name = "Slider",
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 10, 1, -25),
                    BackgroundTransparency = 1,
                    ZIndex = 5,
                })
                
                local SliderHue = Create("Frame", ColorSlider, {
                    Name = "Hue",
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    ZIndex = 6,
                })
                
                -- Hue gradient would be complex, simplified version
                local HueLabel = Create("TextLabel", SliderHue, {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "🎨 Hue Slider",
                    TextColor3 = Configs.Cor_DarkText,
                    TextSize = 11,
                    Font = Configs.Text_Font,
                    ZIndex = 7,
                })
                
                pickerCallback(pickerDefault)
                
                local PickerObj = {
                    _preview = PickerPreview,
                    _frame = PickerFrame,
                    Get = function() return PickerPreview.BackgroundColor3 end,
                    Set = function(c)
                        PickerPreview.BackgroundColor3 = c
                        pickerCallback(c)
                    end,
                }
                
                return PickerObj
            end
            
            table.insert(self._elements, Sec)
            return Sec
        end
        
        -- Tab Click Handler
        TabBtn.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for _, tab in ipairs(Window._tabs) do
                tab._content.Visible = false
                tab._frame.BackgroundColor3 = Configs.Cor_Options
                tab._label.TextColor3 = Configs.Cor_DarkText
                tab._icon.ImageColor3 = Configs.Cor_DarkText
            end
            
            -- Show this tab
            TabContent.Visible = true
            TabFrame.BackgroundColor3 = Configs.Cor_Hover
            TabLabel.TextColor3 = Configs.Cor_Text
            TabIcon.ImageColor3 = Configs.Cor_Accent
            
            Window._currentTab = TabObj
        end)
        
        -- Add to window tabs
        table.insert(Window._tabs, TabObj)
        
        -- Auto-select first tab
        if #Window._tabs == 1 then
            TabContent.Visible = true
            TabFrame.BackgroundColor3 = Configs.Cor_Hover
            TabLabel.TextColor3 = Configs.Cor_Text
            TabIcon.ImageColor3 = Configs.Cor_Accent
            Window._currentTab = TabObj
        end
        
        return TabObj
    end
    
    -- Window Controls
    function Window:Hide()
        self._isOpen = false
        TweenSize(MainFrame, UDim2.new(0, 0, 0, 0), 0.2)
    end
    
    function Window:Show()
        self._isOpen = true
        TweenSize(MainFrame, normalSize, 0.2)
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    return Window
end

--===========================================================
-- MOBILE TOGGLE BUTTON
--===========================================================
function PhatUIRed:CreateMobileToggle(configs)
    configs = configs or {}
    local toggleName = configs.Name or "Toggle"
    local toggleCallback = configs.Callback or function() end
    local togglePosition = configs.Position or Vector2.new(0.8, 0, 0.8)
    local toggleIcon = configs.Icon or "Menu"
    
    local ToggleBtn = Create("ImageButton", CoreGui, {
        Name = "MobileToggle_" .. toggleName,
        Size = UDim2.new(0, 50, 0, 50),
        Position = UDim2.new(togglePosition.X, 0, togglePosition.Y, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Configs.Cor_Hub,
        Image = GetIcon(toggleIcon),
        ImageColor3 = Configs.Cor_Text,
        Active = true,
        Draggable = true,
        ZIndex = 9998,
    })
    Corner(ToggleBtn)
    Stroke(ToggleBtn)
    
    return ToggleBtn
end

--===========================================================
-- RETURN MODULE
--===========================================================
return PhatUIRed
