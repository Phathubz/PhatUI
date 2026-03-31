local Phat = {}
Phat.__index = Phat

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Create base GUI
function Phat:CreateWindow(cfg)
    local Window = {}
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false
    
    local Main = Instance.new("Frame")
    Main.Size = cfg.Size or UDim2.fromOffset(580, 460)
    Main.Position = UDim2.fromScale(0.5,0.5)
    Main.AnchorPoint = Vector2.new(0.5,0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
    Main.Parent = ScreenGui
    Main.Active = true
    Main.Draggable = true
    
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

    -- TopBar
    local Top = Instance.new("Frame", Main)
    Top.Size = UDim2.new(1,0,0,40)
    Top.BackgroundColor3 = Color3.fromRGB(25,25,25)

    local Title = Instance.new("TextLabel", Top)
    Title.Text = cfg.Title or "Phat UI"
    Title.Size = UDim2.new(1, -120, 1, 0)
    Title.Position = UDim2.new(0,10,0,0)
    Title.TextXAlignment = "Left"
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.new(1,1,1)

    -- Buttons (Minimize / Close)
    local Min = Instance.new("TextButton", Top)
    Min.Size = UDim2.fromOffset(30,30)
    Min.Position = UDim2.new(1,-70,0,5)
    Min.Text = "-"

    local Close = Instance.new("TextButton", Top)
    Close.Size = UDim2.fromOffset(30,30)
    Close.Position = UDim2.new(1,-35,0,5)
    Close.Text = "X"

    -- Sidebar
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0,150,1,-40)
    Sidebar.Position = UDim2.new(0,0,0,40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(22,22,22)

    local TabLayout = Instance.new("UIListLayout", Sidebar)
    TabLayout.Padding = UDim.new(0,5)

    -- Content
    local Content = Instance.new("Frame", Main)
    Content.Size = UDim2.new(1,-150,1,-40)
    Content.Position = UDim2.new(0,150,0,40)
    Content.BackgroundTransparency = 1

    local Tabs = {}

    function Window:AddTab(tabcfg)
        local Tab = {}

        local Btn = Instance.new("TextButton", Sidebar)
        Btn.Size = UDim2.new(1,0,0,40)
        Btn.Text = tabcfg.Title
        Btn.BackgroundColor3 = Color3.fromRGB(35,35,35)

        local Frame = Instance.new("Frame", Content)
        Frame.Size = UDim2.new(1,0,1,0)
        Frame.Visible = false

        local Layout = Instance.new("UIListLayout", Frame)
        Layout.Padding = UDim.new(0,6)

        Btn.MouseButton1Click:Connect(function()
            for _,v in pairs(Content:GetChildren()) do
                if v:IsA("Frame") then v.Visible = false end
            end
            Frame.Visible = true
        end)

        function Tab:AddSection(title)
            local Section = {}

            local Holder = Instance.new("Frame", Frame)
            Holder.Size = UDim2.new(1,-10,0,100)
            Holder.BackgroundColor3 = Color3.fromRGB(30,30,30)

            local UIList = Instance.new("UIListLayout", Holder)
            UIList.Padding = UDim.new(0,5)

            local Label = Instance.new("TextLabel", Holder)
            Label.Text = title
            Label.BackgroundTransparency = 1
            Label.TextColor3 = Color3.new(1,1,1)

            function Section:AddButton(cfg)
                local Btn = Instance.new("TextButton", Holder)
                Btn.Size = UDim2.new(1,0,0,30)
                Btn.Text = cfg.Title
                Btn.BackgroundColor3 = Color3.fromRGB(50,50,50)

                Btn.MouseButton1Click:Connect(function()
                    cfg.Callback()
                end)
            end

            function Section:AddToggle(cfg)
                local Toggle = Instance.new("TextButton", Holder)
                Toggle.Size = UDim2.new(1,0,0,30)
                Toggle.Text = cfg.Title .. " : OFF"
                Toggle.BackgroundColor3 = Color3.fromRGB(50,50,50)

                local state = cfg.Default or false

                Toggle.MouseButton1Click:Connect(function()
                    state = not state
                    Toggle.Text = cfg.Title.." : "..(state and "ON" or "OFF")
                    cfg.Callback(state)
                end)
            end

            return Section
        end

        return Tab
    end

    -- Minimize
    local minimized = false
    Min.MouseButton1Click:Connect(function()
        minimized = not minimized
        Content.Visible = not minimized
        Sidebar.Visible = not minimized
        Main.Size = minimized and UDim2.fromOffset(300,40) or cfg.Size
    end)

    -- Close
    Close.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    return Window
end

return Phat
