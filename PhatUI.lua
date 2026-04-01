local Phat = {}
Phat.__index = Phat

--// Services
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Tween cache
local TI_FAST = TweenInfo.new(0.1, Enum.EasingStyle.Quad)
local TI_SMOOTH = TweenInfo.new(0.18, Enum.EasingStyle.Quart)
local TI_SLOW = TweenInfo.new(0.25, Enum.EasingStyle.Quint)

local function tw(o, p, ti)
    local t = TweenService:Create(o, ti or TI_SMOOTH, p)
    t:Play()
    return t
end

--// UI helper
local function create(class, props, parent)
    local o = Instance.new(class)
    for k,v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function corner(p, r)
    return create("UICorner", {CornerRadius = UDim.new(0, r or 8)}, p)
end

local function stroke(p, col)
    return create("UIStroke", {Color = col, Thickness = 1}, p)
end

--// Colors
local C = {
    WIN = Color3.fromRGB(17,17,22),
    TOP = Color3.fromRGB(14,14,18),
    ELEM = Color3.fromRGB(26,26,32),
    RED = Color3.fromRGB(255,60,60),
    RED2 = Color3.fromRGB(255,100,100),
    TEXT = Color3.fromRGB(230,230,230),
    SUB = Color3.fromRGB(150,150,150)
}

--// Notification
local NotificationHolder
local MAX_NOTIFY = 5

local function notify(title, msg, duration)
    duration = duration or 3

    if not NotificationHolder then return end

    if #NotificationHolder:GetChildren() >= MAX_NOTIFY then
        NotificationHolder:GetChildren()[1]:Destroy()
    end

    local card = create("Frame", {
        Size = UDim2.new(1,0,0,60),
        BackgroundColor3 = C.WIN
    }, NotificationHolder)
    corner(card,8)
    stroke(card,C.RED)

    create("TextLabel", {
        Text = title,
        Size = UDim2.new(1,-10,0,20),
        Position = UDim2.new(0,10,0,5),
        TextColor3 = C.TEXT,
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    create("TextLabel", {
        Text = msg,
        Size = UDim2.new(1,-10,0,20),
        Position = UDim2.new(0,10,0,25),
        TextColor3 = C.SUB,
        BackgroundTransparency = 1,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    card.Position = UDim2.new(1,0,0,0)
    tw(card,{Position = UDim2.new(0,0,0,0)}, TI_SLOW)

    task.delay(duration,function()
        tw(card,{Position = UDim2.new(1,0,0,0)}, TI_FAST)
        task.wait(0.2)
        card:Destroy()
    end)
end

--// Main Window
function Phat:CreateWindow(cfg)
    cfg = cfg or {}

    local Window = {_visible = true, _tabs = {}}
    Window.Notify = notify

    local sg = create("ScreenGui", {
        Name = "PhatUI",
        ResetOnSpawn = false
    }, PlayerGui)

    -- Notification holder
    NotificationHolder = create("Frame", {
        Size = UDim2.new(0,280,0,300),
        Position = UDim2.new(1,-300,1,-320),
        BackgroundTransparency = 1
    }, sg)

    create("UIListLayout",{Padding = UDim.new(0,6)},NotificationHolder)

    -- Main
    local Main = create("Frame", {
        Size = UDim2.new(0,600,0,450),
        Position = UDim2.new(0.5,0,0.5,0),
        AnchorPoint = Vector2.new(0.5,0.5),
        BackgroundColor3 = C.WIN
    }, sg)
    corner(Main,10)

    -- TopBar
    local Top = create("Frame", {
        Size = UDim2.new(1,0,0,40),
        BackgroundColor3 = C.TOP
    }, Main)

    -- Title
    create("TextLabel", {
        Text = cfg.Title or "PHAT UI",
        Size = UDim2.new(1,-100,1,0),
        Position = UDim2.new(0,10,0,0),
        BackgroundTransparency = 1,
        TextColor3 = C.TEXT,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Top)

    -- Toggle Button
    local Toggle = create("TextButton", {
        Size = UDim2.new(0,50,0,50),
        Position = UDim2.new(0,20,0.5,-25),
        Text = "P",
        BackgroundColor3 = C.ELEM,
        TextColor3 = C.TEXT
    }, sg)
    corner(Toggle,10)

    -- States
    local drag = {}
    local resizing = nil
    local btnDrag = {}

    -- Drag window
    Top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag.active = true
            drag.start = i.Position
            drag.pos = Main.Position
        end
    end)

    Toggle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            btnDrag.active = true
            btnDrag.start = i.Position
            btnDrag.pos = Toggle.Position
        end
    end)

    -- Global input handler (OPTIMIZED)
    UIS.InputChanged:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        if drag.active then
            local d = i.Position - drag.start
            Main.Position = drag.pos + UDim2.fromOffset(d.X,d.Y)
        end

        if btnDrag.active then
            local d = i.Position - btnDrag.start
            Toggle.Position = btnDrag.pos + UDim2.fromOffset(d.X,d.Y)
        end

        if resizing then
            local d = i.Position - resizing.start
            Main.Size = UDim2.new(0,math.max(400,resizing.size.X.Offset + d.X),
                                 0,math.max(300,resizing.size.Y.Offset + d.Y))
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag.active = false
            btnDrag.active = false
            resizing = nil
        end
    end)

    -- Toggle UI
    Toggle.MouseButton1Click:Connect(function()
        Window._visible = not Window._visible
        Main.Visible = Window._visible
    end)

    -- Add Tab
    function Window:AddTab(name)
        local Tab = {}
        local Page = create("Frame", {
            Size = UDim2.new(1,0,1,-40),
            Position = UDim2.new(0,0,0,40),
            BackgroundTransparency = 1,
            Visible = false
        }, Main)

        function Tab:Show()
            for _,t in pairs(Window._tabs) do
                t.Page.Visible = false
            end
            Page.Visible = true
        end

        Tab.Page = Page
        table.insert(Window._tabs, Tab)

        if #Window._tabs == 1 then
            Tab:Show()
        end

        return Tab
    end

    return Window
end

return Phat
