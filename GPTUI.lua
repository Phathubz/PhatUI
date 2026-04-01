--// PHAT UI v8 - ULTRA PREMIUM

local Phat = {}
Phat.__index = Phat

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// COLORS (Glass + Neon)
local C = {
    BG = Color3.fromRGB(10,10,12),
    GLASS = Color3.fromRGB(25,25,30),

    RED = Color3.fromRGB(255,60,60),
    RED2 = Color3.fromRGB(255,100,100),

    TEXT = Color3.fromRGB(240,240,240),
    TEXT2 = Color3.fromRGB(160,160,160),

    BORDER = Color3.fromRGB(255,60,60)
}

--// BLUR
pcall(function()
    if not Lighting:FindFirstChild("PhatBlur") then
        local blur = Instance.new("BlurEffect")
        blur.Name = "PhatBlur"
        blur.Size = 18
        blur.Parent = Lighting
    end
end)

--// TWEEN
local function tw(o,p,t)
    TweenService:Create(o,TweenInfo.new(t or 0.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),p):Play()
end

--// UI CORNER
local function corner(p,r)
    local c = Instance.new("UICorner",p)
    c.CornerRadius = UDim.new(0,r or 10)
end

--// SHADOW
local function shadow(p)
    local s = Instance.new("ImageLabel")
    s.Size = UDim2.new(1,40,1,40)
    s.Position = UDim2.new(0.5,0,0.5,0)
    s.AnchorPoint = Vector2.new(0.5,0.5)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://1316045217"
    s.ImageTransparency = 0.7
    s.ZIndex = 0
    s.Parent = p
end

--// NOTIFY
local function notify(holder,title,msg,timee)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1,0,0,0)
    card.BackgroundColor3 = C.GLASS
    card.BackgroundTransparency = 1
    card.Parent = holder
    corner(card,10)

    local lbl = Instance.new("TextLabel",card)
    lbl.Size = UDim2.new(1,-20,1,-10)
    lbl.Position = UDim2.new(0,10,0,5)
    lbl.BackgroundTransparency = 1
    lbl.Text = title.."\n"..msg
    lbl.TextColor3 = C.TEXT
    lbl.TextSize = 12
    lbl.Font = Enum.Font.GothamBold
    lbl.TextWrapped = true

    tw(card,{Size = UDim2.new(1,0,0,60),BackgroundTransparency=0},0.25)

    task.delay(timee or 4,function()
        tw(card,{Size = UDim2.new(1,0,0,0),BackgroundTransparency=1},0.25)
        task.wait(0.3)
        card:Destroy()
    end)
end

--// CREATE WINDOW
function Phat:CreateWindow(cfg)
    cfg = cfg or {}

    local sg = Instance.new("ScreenGui",PlayerGui)
    sg.Name = "PhatUI_v8"
    sg.ResetOnSpawn = false

    local Main = Instance.new("Frame",sg)
    Main.Size = UDim2.new(0,700,0,500)
    Main.Position = UDim2.new(0.5,0,0.5,0)
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.BackgroundColor3 = C.GLASS
    Main.BackgroundTransparency = 0.15
    Main.BorderSizePixel = 0
    corner(Main,14)
    shadow(Main)

    -- gradient
    local grad = Instance.new("UIGradient",Main)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,Color3.fromRGB(30,30,35)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(10,10,15))
    }
    grad.Rotation = 90

    -- topbar
    local Top = Instance.new("Frame",Main)
    Top.Size = UDim2.new(1,0,0,40)
    Top.BackgroundTransparency = 1

    local title = Instance.new("TextLabel",Top)
    title.Size = UDim2.new(1,0,1,0)
    title.BackgroundTransparency = 1
    title.Text = cfg.Title or "PHAT UI v8"
    title.TextColor3 = C.TEXT
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14

    -- glow line
    local glow = Instance.new("Frame",Top)
    glow.Size = UDim2.new(1,0,0,2)
    glow.Position = UDim2.new(0,0,1,-2)
    glow.BackgroundColor3 = C.RED

    local ggrad = Instance.new("UIGradient",glow)
    ggrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0,C.RED),
        ColorSequenceKeypoint.new(1,C.RED2)
    }

    -- content
    local Content = Instance.new("Frame",Main)
    Content.Size = UDim2.new(1,0,1,-40)
    Content.Position = UDim2.new(0,0,0,40)
    Content.BackgroundTransparency = 1

    -- notification holder
    local Holder = Instance.new("Frame",sg)
    Holder.Size = UDim2.new(0,260,0,300)
    Holder.Position = UDim2.new(1,-270,1,-310)
    Holder.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout",Holder)
    layout.Padding = UDim.new(0,6)
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

    -- drag
    local dragging=false
    local dragStart, startPos

    Top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging=true
            dragStart=i.Position
            startPos=Main.Position
        end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
            local delta=i.Position-dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset+delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset+delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dragging=false
        end
    end)

    -- toggle button
    local ToggleGui = Instance.new("ScreenGui",game.CoreGui)
    local Btn = Instance.new("TextButton",ToggleGui)
    Btn.Size = UDim2.new(0,50,0,50)
    Btn.Position = UDim2.new(0,20,0.5,-25)
    Btn.Text = "P"
    Btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Btn.TextColor3 = Color3.new(1,1,1)
    Btn.Font = Enum.Font.GothamBlack
    Btn.TextScaled = true
    corner(Btn,10)

    local stroke = Instance.new("UIStroke",Btn)
    stroke.Color = C.RED
    stroke.Thickness = 2

    local visible = true
    Btn.MouseButton1Click:Connect(function()
        visible = not visible
        Main.Visible = visible
    end)

    -- API
    local Window = {}

    function Window:Notify(t,m,d)
        notify(Holder,t,m,d)
    end

    function Window:AddButton(text,callback)
        local b = Instance.new("TextButton",Content)
        b.Size = UDim2.new(0,200,0,40)
        b.Position = UDim2.new(0,20,0,20)
        b.BackgroundColor3 = Color3.fromRGB(35,35,40)
        b.Text = text
        b.TextColor3 = C.TEXT
        b.Font = Enum.Font.GothamBold
        corner(b,8)

        b.MouseEnter:Connect(function()
            tw(b,{BackgroundColor3 = Color3.fromRGB(60,30,30)},0.1)
        end)
        b.MouseLeave:Connect(function()
            tw(b,{BackgroundColor3 = Color3.fromRGB(35,35,40)},0.1)
        end)

        b.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)
    end

    return Window
end

return Phat
