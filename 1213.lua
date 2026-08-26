-- ========== 时脚本 · 套娃启动器 ==========
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Starter"
screenGui.Parent = game:GetService("CoreGui")
screenGui.DisplayOrder = 999
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 遮罩
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.ZIndex = 100
overlay.Parent = screenGui

-- 弹窗
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

local popupStroke = Instance.new("UIStroke")
popupStroke.Thickness = 1.5
popupStroke.Color = Color3.fromRGB(60, 60, 60)
popupStroke.Transparency = 0.3
popupStroke.Parent = popup

-- 标题
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 35)
title.Position = UDim2.new(0, 15, 0, 15)
title.BackgroundTransparency = 1
title.Text = "可不可以发送评论？"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 102
title.Parent = popup

-- 确定按钮
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

-- 取消按钮
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

-- 弹出动画
popup.Position = UDim2.new(0.5, -140, 0.5, -100)
popup.BackgroundTransparency = 1
TweenService:Create(popup, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -140, 0.5, -75), BackgroundTransparency = 0}):Play()

-- 发送消息函数
local function sendMessage(msg)
    pcall(function()
        game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(msg, "All")
    end)
end

-- 确定按钮点击
confirmBtn.MouseButton1Click:Connect(function()
    -- 发送消息
    sendMessage("秦始皇是gay")
    wait(1)
    sendMessage("Qin Shi Huang is gay")
    
    -- 关闭弹窗
    screenGui:Destroy()
    
    -- 自动加载2200行脚本
    loadstring(game:HttpGet("loadstring(game:HttpGet("https://raw.githubusercontent.com/CAT85-eng/-_/main/%E6%9C%80%E5%90%8E%E6%9B%B4%E6%96%B0%E4%BA%86%E5%93%A5%E5%87%A0%E4%B8%AA.lua"))()"))()
    
    -- 如果你没有直链，就把2200行代码粘贴在下面
    -- 这里放你的2200行代码
end)

-- 取消按钮点击
cancelBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
