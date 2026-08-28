-- ========== Time Script TS 🕐 · 套娃启动器 ==========
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Starter"
screenGui.Parent = game:GetService("CoreGui")
screenGui.DisplayOrder = 99999
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.ZIndex = 100
overlay.Parent = screenGui

local popup = Instance.new("Frame")
popup.Size = UDim2.new(0, 280, 0, 150)
popup.Position = UDim2.new(0.5, -140, 0.5, -75)
popup.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
popup.BorderSizePixel = 0
popup.ZIndex = 101
popup.Parent = screenGui

local popupCorner = Instance.new("UICorner")
popupCorner.CornerRadius = UDim.new(0, 16)
popupCorner.Parent = popup

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 35)
title.Position = UDim2.new(0, 15, 0, 15)
title.BackgroundTransparency = 1
title.Text = "可不可以发送"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 102
title.Parent = popup

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -30, 0, 20)
subtitle.Position = UDim2.new(0, 15, 0, 50)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Time Script TS 🕐"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextSize = 11
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.ZIndex = 102
subtitle.Parent = popup

local confirmBtn = Instance.new("TextButton")
confirmBtn.Size = UDim2.new(0, 100, 0, 36)
confirmBtn.Position = UDim2.new(0, 25, 1, -50)
confirmBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
confirmBtn.BorderSizePixel = 0
confirmBtn.Text = "确定"
confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmBtn.TextSize = 14
confirmBtn.Font = Enum.Font.GothamBold
confirmBtn.AutoButtonColor = false
confirmBtn.ZIndex = 102
confirmBtn.Parent = popup

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 18)
confirmCorner.Parent = confirmBtn

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0, 100, 0, 36)
cancelBtn.Position = UDim2.new(1, -125, 1, -50)
cancelBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
cancelBtn.BorderSizePixel = 0
cancelBtn.Text = "取消"
cancelBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
cancelBtn.TextSize = 14
cancelBtn.Font = Enum.Font.GothamBold
cancelBtn.AutoButtonColor = false
cancelBtn.ZIndex = 102
cancelBtn.Parent = popup

local cancelCorner = Instance.new("UICorner")
cancelCorner.CornerRadius = UDim.new(0, 18)
cancelCorner.Parent = cancelBtn

local function sendMessage(msg)
    pcall(function()
        local textChat = game:GetService("TextChatService")
        local channel = textChat:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
        if channel then
            channel:SendAsync(msg)
        end
    end)
end

confirmBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    
    task.wait(1)
    sendMessage("秦始皇是给")
    task.wait(2)
    sendMessage("Time Script TS 🕐")
    task.wait(1)
    
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CAT85-eng/-_/main/%E6%9C%80%E5%90%8E%E6%9B%B4%E6%96%B0%E4%BA%86%E5%93%A5%E5%87%A0%E4%B8%AA.lua"))()
end)

cancelBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

print("✅ Time Script TS 🕐 套娃启动器已加载")
