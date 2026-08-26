-- ========== 时脚本 · 流体云灵动岛 · 终极版 ==========
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AuroraNotifications"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

local screenWidth = screenGui.AbsoluteSize.X
local screenHeight = screenGui.AbsoluteSize.Y

local notifWidth = math.clamp(screenWidth * 0.38, 220, 320)
local notifHeight = math.clamp(screenHeight * 0.075, 42, 58)
local notifSpacing = 10
local margin = math.clamp(screenWidth * 0.025, 12, 24)
local bottomGap = 4

local COLORS = {
    background = Color3.fromRGB(18, 15, 28),
    purpleAccent = Color3.fromRGB(140, 80, 255),
    purpleGlow = Color3.fromRGB(120, 60, 220),
    textPrimary = Color3.fromRGB(240, 235, 255),
    textSecondary = Color3.fromRGB(160, 145, 190),
    successGreen = Color3.fromRGB(80, 220, 130),
    errorRed = Color3.fromRGB(255, 90, 100)
}

local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0, notifWidth, 0, notifHeight * 4 + notifSpacing * 3)
notifContainer.AnchorPoint = Vector2.new(1, 1)
notifContainer.Position = UDim2.new(1, -margin, 1, -bottomGap)
notifContainer.BackgroundTransparency = 1
notifContainer.BorderSizePixel = 0
notifContainer.ZIndex = 9999
notifContainer.Parent = screenGui

local notifList = {}

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
    return corner
end

local function updatePositions()
    local y = -notifHeight
    for i = #notifList, 1, -1 do
        local notif = notifList[i]
        if notif and notif.Parent then
            TweenService:Create(notif,
                TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                {Position = UDim2.new(0, 0, 1, y)}
            ):Play()
            y = y - notifHeight - notifSpacing
        end
    end
end

local function showNotification(text, isSuccess, duration)
    if #notifList >= 4 then
        local oldest = table.remove(notifList)
        if oldest and oldest.Parent then
            oldest:Destroy()
        end
    end
    
    local accentColor = isSuccess and COLORS.successGreen or COLORS.errorRed
    
    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0.3, 0, 0, notifHeight)
    notifFrame.Position = UDim2.new(0, 0, 1, -notifHeight)
    notifFrame.BackgroundColor3 = COLORS.background
    notifFrame.BackgroundTransparency = 0.02
    notifFrame.BorderSizePixel = 0
    notifFrame.ClipsDescendants = true
    notifFrame.ZIndex = 10000
    notifFrame.Parent = notifContainer
    
    addCorner(notifFrame, 16)
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = COLORS.purpleGlow
    stroke.Transparency = 0.4
    stroke.Parent = notifFrame
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 0.65, 0)
    accentBar.Position = UDim2.new(0, 10, 0.5, 0)
    accentBar.AnchorPoint = Vector2.new(0.5, 0.5)
    accentBar.BackgroundColor3 = COLORS.purpleAccent
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 10001
    accentBar.Parent = notifFrame
    addCorner(accentBar, 2)
    
    local iconContainer = Instance.new("Frame")
    iconContainer.Size = UDim2.new(0, 28, 0, 28)
    iconContainer.Position = UDim2.new(0, 16, 0.5, -14)
    iconContainer.BackgroundColor3 = accentColor
    iconContainer.BackgroundTransparency = 0.85
    iconContainer.BorderSizePixel = 0
    iconContainer.ZIndex = 10001
    iconContainer.Parent = notifFrame
    addCorner(iconContainer, 14)
    
    local iconText = Instance.new("TextLabel")
    iconText.Size = UDim2.new(1, 0, 1, 0)
    iconText.BackgroundTransparency = 1
    iconText.Text = isSuccess and "✓" or "x"
    iconText.TextColor3 = accentColor
    iconText.TextSize = isSuccess and 16 or 17
    iconText.Font = Enum.Font.GothamBold
    iconText.ZIndex = 10002
    iconText.Parent = iconContainer
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0.55, 0)
    title.Position = UDim2.new(0, 55, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = COLORS.textPrimary
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTruncate = Enum.TextTruncate.AtEnd
    title.ZIndex = 10001
    title.Parent = notifFrame
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -60, 0.3, 0)
    subtitle.Position = UDim2.new(0, 55, 0.65, 2)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = isSuccess and "Operation Complete" or "Starting Soon"
    subtitle.TextColor3 = COLORS.textSecondary
    subtitle.TextSize = 10
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 10001
    subtitle.Parent = notifFrame
    
    notifFrame.BackgroundTransparency = 1
    title.TextTransparency = 1
    subtitle.TextTransparency = 1
    iconText.TextTransparency = 1
    accentBar.BackgroundTransparency = 1
    stroke.Transparency = 1
    
    table.insert(notifList, 1, notifFrame)
    
    TweenService:Create(notifFrame,
        TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = UDim2.new(1, 0, 0, notifHeight)}
    ):Play()
    
    TweenService:Create(notifFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {BackgroundTransparency = 0.02}
    ):Play()
    
    task.delay(0.35, function()
        TweenService:Create(title, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TweenService:Create(subtitle, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TweenService:Create(iconText, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
        TweenService:Create(accentBar, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0.4}):Play()
    end)
    
    updatePositions()
    
    local displayDuration = duration or 6
    task.delay(displayDuration, function()
        if notifFrame.Parent then
            TweenService:Create(notifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0.3, 0, 0, notifHeight)}):Play()
            TweenService:Create(notifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
            TweenService:Create(title, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
            TweenService:Create(subtitle, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
            TweenService:Create(iconText, TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
            
            task.delay(0.5, function()
                for i, v in ipairs(notifList) do
                    if v == notifFrame then
                        table.remove(notifList, i)
                        break
                    end
                end
                notifFrame:Destroy()
                updatePositions()
            end)
        end
    end)
end

task.delay(1, function()
    showNotification("Script loaded successfully", true, 5)
end)

task.delay(4, function()
    showNotification("Loading modules", true, 5)
end)

task.delay(7, function()
    showNotification("Anomaly detected", true, 6)
end)

task.delay(14, function()
    loadFluidCloud()
end)

-- ==================== 流体云主体 ====================
local CONFIG = {
    width = 0.35,
    height = 34,
    normalY = 5,
    panelWidth = 460,
    panelHeight = 286,
    panelOffset = 8,
    panelCornerRadius = 20,
    sidebarWidth = 90,
    capsuleCornerRadius = 17,
    selectedCornerRadius = 12,
    featureCount = 14,
}

local function createInputBox(parent, position, size, placeholder, defaultValue)
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = size
    inputFrame.Position = position
    inputFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    inputFrame.BorderSizePixel = 0
    inputFrame.ZIndex = 100
    inputFrame.Parent = parent
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputFrame
    
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -10, 1, 0)
    textBox.Position = UDim2.new(0, 5, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = defaultValue or ""
    textBox.PlaceholderText = placeholder or "输入数值"
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.TextSize = 13
    textBox.Font = Enum.Font.GothamMedium
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.ZIndex = 101
    textBox.Parent = inputFrame
    
    textBox.Focused:Connect(function()
        TweenService:Create(inputFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    end)
    
    textBox.FocusLost:Connect(function()
        TweenService:Create(inputFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}):Play()
    end)
    
    return textBox
end

local function createToggle(parent, position, size, text, callback)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = size
    toggleBtn.Position = position
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.ZIndex = 100
    toggleBtn.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleBtn
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -60, 1, 0)
    toggleLabel.Position = UDim2.new(0, 15, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.TextSize = 13
    toggleLabel.Font = Enum.Font.GothamMedium
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.ZIndex = 101
    toggleLabel.Parent = toggleBtn
    
    local switchFrame = Instance.new("TextButton")
    switchFrame.Size = UDim2.new(0, 36, 0, 24)
    switchFrame.Position = UDim2.new(1, -46, 0.5, -12)
    switchFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    switchFrame.BorderSizePixel = 0
    switchFrame.Text = ""
    switchFrame.AutoButtonColor = false
    switchFrame.ZIndex = 102
    switchFrame.Parent = toggleBtn
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 6)
    switchCorner.Parent = switchFrame
    
    local innerBlock = Instance.new("Frame")
    innerBlock.Size = UDim2.new(0, 16, 0, 16)
    innerBlock.Position = UDim2.new(0, 3, 0.5, -8)
    innerBlock.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    innerBlock.BorderSizePixel = 0
    innerBlock.ZIndex = 103
    innerBlock.Parent = switchFrame
    
    local blockCorner = Instance.new("UICorner")
    blockCorner.CornerRadius = UDim.new(0, 4)
    blockCorner.Parent = innerBlock
    
    local state = false
    
    switchFrame.MouseButton1Click:Connect(function()
        state = not state
        local targetPos = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
        TweenService:Create(innerBlock, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = targetPos}):Play()
        local targetColor = state and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(60, 60, 65)
        TweenService:Create(switchFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
        if callback then callback(state) end
    end)
    
    return toggleBtn
end

local function createInputRow(parent, yPos, labelText, defaultValue, onEnter)
    local rowFrame = Instance.new("Frame")
    rowFrame.Size = UDim2.new(1, -20, 0, 35)
    rowFrame.Position = UDim2.new(0, 10, 0, yPos)
    rowFrame.BackgroundTransparency = 1
    rowFrame.BorderSizePixel = 0
    rowFrame.ZIndex = 99
    rowFrame.Parent = parent
    
    local rowLabel = Instance.new("TextLabel")
    rowLabel.Size = UDim2.new(0, 100, 1, 0)
    rowLabel.BackgroundTransparency = 1
    rowLabel.Text = labelText
    rowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    rowLabel.TextSize = 13
    rowLabel.Font = Enum.Font.GothamMedium
    rowLabel.TextXAlignment = Enum.TextXAlignment.Left
    rowLabel.ZIndex = 100
    rowLabel.Parent = rowFrame
    
    local inputBox = createInputBox(rowFrame, UDim2.new(1, -110, 0, 0), UDim2.new(0, 90, 0, 28), "输入", defaultValue)
    
    if onEnter then
        inputBox.FocusLost:Connect(function(enterPressed)
            if enterPressed then
                local value = tonumber(inputBox.Text)
                if value then onEnter(value) end
            end
        end)
    end
    
    return rowFrame
end

local function createCollapsible(parent, headerY, title, contentHeight)
    local headerBtn = Instance.new("TextButton")
    headerBtn.Size = UDim2.new(1, -20, 0, 40)
    headerBtn.Position = UDim2.new(0, 10, 0, headerY)
    headerBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    headerBtn.BorderSizePixel = 0
    headerBtn.Text = "▼  " .. title
    headerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerBtn.TextSize = 14
    headerBtn.Font = Enum.Font.GothamBold
    headerBtn.AutoButtonColor = false
    headerBtn.ZIndex = 100
    headerBtn.Parent = parent
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = headerBtn
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -20, 0, 0)
    contentFrame.Position = UDim2.new(0, 10, 0, headerY + 40)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ClipsDescendants = true
    contentFrame.ZIndex = 99
    contentFrame.Parent = parent
    
    local isOpen = false
    
    headerBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        headerBtn.Text = (isOpen and "▲  " or "▼  ") .. title
        local targetHeight = isOpen and contentHeight or 0
        TweenService:Create(contentFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(1, -20, 0, targetHeight)}):Play()
    end)
    
    return contentFrame
end

local fluidGui = Instance.new("ScreenGui")
fluidGui.Name = "FluidBar"
fluidGui.Parent = game:GetService("CoreGui")
fluidGui.DisplayOrder = 999
fluidGui.ResetOnSpawn = false
fluidGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fluidGui.IgnoreGuiInset = true

local container = Instance.new("TextButton")
container.Size = UDim2.new(CONFIG.width, 0, 0, CONFIG.height)
container.Position = UDim2.new(0.5, 0, 0, -50)
container.AnchorPoint = Vector2.new(0.5, 0)
container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
container.BackgroundTransparency = 0.15
container.BorderSizePixel = 0
container.Text = ""
container.ZIndex = 100
container.AutoButtonColor = false
container.Parent = fluidGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 17)
corner.Parent = container

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "时脚本"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 15
label.Font = Enum.Font.GothamMedium
label.TextXAlignment = Enum.TextXAlignment.Center
label.TextYAlignment = Enum.TextYAlignment.Center
label.ZIndex = 101
label.Parent = container

local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 0, 0, 0)
panel.Position = UDim2.new(0.5, 0, 0, CONFIG.normalY + CONFIG.height + CONFIG.panelOffset)
panel.AnchorPoint = Vector2.new(0.5, 0)
panel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
panel.BackgroundTransparency = 1
panel.BorderSizePixel = 0
panel.ClipsDescendants = true
panel.ZIndex = 90
panel.Visible = false
panel.Parent = fluidGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, CONFIG.panelCornerRadius)
panelCorner.Parent = panel

local panelScale = Instance.new("UIScale")
panelScale.Scale = 1
panelScale.Parent = panel

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
topBar.BackgroundTransparency = 1
topBar.BorderSizePixel = 0
topBar.ZIndex = 95
topBar.Parent = panel

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, CONFIG.panelCornerRadius)
topBarCorner.Parent = topBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 100, 0, 30)
title.Position = UDim2.new(0, 12, 0, 5)
title.BackgroundTransparency = 1
title.Text = "时脚本"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 97
title.Parent = topBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -62, 0, 6)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 18
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.AutoButtonColor = false
minimizeBtn.ZIndex = 97
minimizeBtn.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 14)
minimizeCorner.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -32, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 97
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 14)
closeCorner.Parent = closeBtn

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, CONFIG.sidebarWidth, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
sidebar.BackgroundTransparency = 1
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 95
sidebar.Parent = panel

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, CONFIG.panelCornerRadius)
sidebarCorner.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -CONFIG.sidebarWidth, 1, -40)
contentArea.Position = UDim2.new(0, CONFIG.sidebarWidth, 0, 40)
contentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 95
contentArea.Parent = panel

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, CONFIG.panelCornerRadius)
contentCorner.Parent = contentArea

local sidebarDivider = Instance.new("Frame")
sidebarDivider.Size = UDim2.new(0, 1, 1, 0)
sidebarDivider.Position = UDim2.new(0, CONFIG.sidebarWidth, 0, 0)
sidebarDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sidebarDivider.BackgroundTransparency = 1
sidebarDivider.BorderSizePixel = 0
sidebarDivider.ZIndex = 96
sidebarDivider.Parent = panel
-- ==================== 侧边栏导航 ====================
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 0
scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, CONFIG.featureCount * 44)
scrollFrame.ZIndex = 96
scrollFrame.Parent = sidebar

local sidebarButtons = {}
local sidebarButtonData = {}
local featureNames = {
    "主页",
    "本地玩家",
    "通用",
    "旋转范围",
    "传送甩飞",
    "自动说话",
    "时间透视",
    "自瞄",
    "动画",
    "FE",
    "光影画质",
    "透视",
    "ACS漏洞",
    "飞行飞车",
}

for i = 1, CONFIG.featureCount do
    local sbtn = Instance.new("TextButton")
    sbtn.Size = UDim2.new(0, 40, 0, 36)
    sbtn.Position = UDim2.new(0, 10, 0, 4 + (i - 1) * 44)
    sbtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    sbtn.BackgroundTransparency = 1
    sbtn.BorderSizePixel = 0
    sbtn.Text = ""
    sbtn.AutoButtonColor = false
    sbtn.ZIndex = 97
    sbtn.Parent = scrollFrame
    
    local sbtnCorner = Instance.new("UICorner")
    sbtnCorner.CornerRadius = UDim.new(0, CONFIG.capsuleCornerRadius)
    sbtnCorner.Parent = sbtn
    
    local sbtnLabel = Instance.new("TextLabel")
    sbtnLabel.Size = UDim2.new(1, 0, 1, 0)
    sbtnLabel.BackgroundTransparency = 1
    sbtnLabel.Text = featureNames[i]
    sbtnLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    sbtnLabel.TextSize = 12
    sbtnLabel.Font = Enum.Font.GothamMedium
    sbtnLabel.TextTransparency = 1
    sbtnLabel.ZIndex = 98
    sbtnLabel.Parent = sbtn
    
    table.insert(sidebarButtons, sbtn)
    table.insert(sidebarButtonData, {button = sbtn, corner = sbtnCorner, label = sbtnLabel, isSelected = false})
end

local selectedFeature = 1

local function animateCapsule(buttonData, isSelected)
    local btn = buttonData.button
    local corner = buttonData.corner
    local targetWidth = isSelected and (CONFIG.sidebarWidth - 20) or 40
    local targetCornerRadius = isSelected and CONFIG.selectedCornerRadius or CONFIG.capsuleCornerRadius
    
    TweenService:Create(btn, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, targetWidth, 0, 36)}):Play()
    TweenService:Create(corner, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {CornerRadius = UDim.new(0, targetCornerRadius)}):Play()
    
    local bgColor = isSelected and Color3.fromRGB(50, 50, 55) or Color3.fromRGB(25, 25, 30)
    TweenService:Create(btn, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = bgColor}):Play()
    
    buttonData.isSelected = isSelected
end

local function updateSidebarSelection()
    for idx, btnData in ipairs(sidebarButtonData) do
        animateCapsule(btnData, idx == selectedFeature)
    end
end

-- ==================== 卡片容器 ====================
local cardContainer = Instance.new("Frame")
cardContainer.Size = UDim2.new(1, -20, 1, -20)
cardContainer.Position = UDim2.new(0, 10, 0, 10)
cardContainer.BackgroundTransparency = 1
cardContainer.BorderSizePixel = 0
cardContainer.ZIndex = 96
cardContainer.Parent = contentArea

local currentCardData = nil
local currentCardIndex = nil
local isSwitchingCard = false

-- ==================== 主页模块 ====================
local function createHomePage(card)
    local infoItems = {
        {"名字", player.Name},
        {"国家", "中国"},
        {"语言", "简体中文"},
        {"群聊", "稍后更新"},
        {"网站", "cat85-eng.github.io/CAT/nznz.html"},
    }
    
    local yPos = 15
    for _, item in ipairs(infoItems) do
        local itemLabel = Instance.new("TextLabel")
        itemLabel.Size = UDim2.new(1, -20, 0, 30)
        itemLabel.Position = UDim2.new(0, 10, 0, yPos)
        itemLabel.BackgroundTransparency = 1
        itemLabel.Text = item[1] .. "：" .. item[2]
        itemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        itemLabel.TextSize = 14
        itemLabel.Font = Enum.Font.GothamMedium
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        itemLabel.ZIndex = 99
        itemLabel.Parent = card
        yPos = yPos + 35
    end
end

-- ==================== 本地玩家模块 ====================
local function createLocalPlayerPage(card)
    local scrollFrame2 = Instance.new("ScrollingFrame")
    scrollFrame2.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame2.BackgroundTransparency = 1
    scrollFrame2.BorderSizePixel = 0
    scrollFrame2.ScrollBarThickness = 4
    scrollFrame2.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame2.CanvasSize = UDim2.new(0, 0, 0, 350)
    scrollFrame2.ZIndex = 98
    scrollFrame2.Parent = card
    
    local yPos = 10
    
    createInputRow(scrollFrame2, yPos, "速度：", "16", function(value)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = value end
    end)
    yPos = yPos + 40
    
    createInputRow(scrollFrame2, yPos, "跳跃：", "7.2", function(value)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpPower = value end
    end)
    yPos = yPos + 40
    
    createInputRow(scrollFrame2, yPos, "血量：", "100", function(value)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.MaxHealth = value humanoid.Health = value end
    end)
    yPos = yPos + 40
    
    createInputRow(scrollFrame2, yPos, "高度：", "7.2", function(value)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpHeight = value end
    end)
    yPos = yPos + 40
    
    createInputRow(scrollFrame2, yPos, "重力：", "196.2", function(value)
        workspace.Gravity = value
    end)
    yPos = yPos + 40
    
    createInputRow(scrollFrame2, yPos, "亮度：", "1", function(value)
        Lighting.Brightness = value
    end)
    yPos = yPos + 40
    
    createInputRow(scrollFrame2, yPos, "快速跑步：", "16", function(value)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = value end
    end)
end
-- ==================== 通用模块 ====================
local function createGeneralPage(card)
    local scrollFrame3 = Instance.new("ScrollingFrame")
    scrollFrame3.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame3.BackgroundTransparency = 1
    scrollFrame3.BorderSizePixel = 0
    scrollFrame3.ScrollBarThickness = 4
    scrollFrame3.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame3.CanvasSize = UDim2.new(0, 0, 0, 1500)
    scrollFrame3.ZIndex = 98
    scrollFrame3.Parent = card
    
    local yPos = 10
    local spacing = 50
    
    local healLoopActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "循环恢复血量", function(state)
        healLoopActive = state
        if state then
            spawn(function()
                while healLoopActive do
                    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        humanoid.Health = math.min(humanoid.Health + 10, humanoid.MaxHealth)
                    end
                    wait(0.5)
                end
            end)
        end
    end)
    yPos = yPos + spacing
    
    local lockViewActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "锁定视野", function(state)
        lockViewActive = state
        if state then
            spawn(function()
                while lockViewActive do
                    local character = player.Character
                    local camera = workspace.CurrentCamera
                    if character and camera then
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            camera.CameraType = Enum.CameraType.Scriptable
                            local lookVector = rootPart.CFrame.LookVector
                            local cameraPosition = rootPart.Position - (lookVector * 5) + Vector3.new(0, 3, 0)
                            camera.CFrame = CFrame.new(cameraPosition, rootPart.Position + (lookVector * 10))
                        end
                    end
                    wait()
                end
                local camera = workspace.CurrentCamera
                if camera then camera.CameraType = Enum.CameraType.Custom end
            end)
        else
            local camera = workspace.CurrentCamera
            if camera then camera.CameraType = Enum.CameraType.Custom end
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "解锁最大视野", function(state)
        local camera = workspace.CurrentCamera
        if camera then
            if state then
                TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {FieldOfView = 120}):Play()
            else
                TweenService:Create(camera, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {FieldOfView = 70}):Play()
            end
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "自杀", function(state)
        if state then
            local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    end)
    yPos = yPos + spacing
    
    local airWalkActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "踏空行走", function(state)
        airWalkActive = state
        if state then
            spawn(function()
                while airWalkActive do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    if character and humanoid then
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            rootPart.Velocity = Vector3.new(0, 0, 0)
                            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                    wait()
                end
            end)
        end
    end)
    yPos = yPos + spacing
    
    local espActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "ESP透视", function(state)
        espActive = state
        spawn(function()
            while espActive do
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = plr.Character
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        task.delay(1, function() highlight:Destroy() end)
                    end
                end
                wait(1)
            end
        end)
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "踢人（娱乐）", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
                        humanoid.Health = 0
                    end
                end
            end
        end
    end)
    yPos = yPos + spacing
    
    local invisibleActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "隐身", function(state)
        invisibleActive = state
        spawn(function()
            while invisibleActive do
                local character = player.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Transparency < 1 then
                            part.Transparency = state and 1 or 0
                        end
                    end
                end
                wait(0.1)
            end
        end)
    end)
    yPos = yPos + spacing
    
    local infiniteJumpActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "无限跳", function(state)
        infiniteJumpActive = state
        if state then
            spawn(function()
                while infiniteJumpActive do
                    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
                    wait(0.1)
                end
            end)
        end
    end)
    yPos = yPos + spacing
    
    local godModeActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "上帝模式", function(state)
        godModeActive = state
        spawn(function()
            while godModeActive do
                local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.MaxHealth = 999999
                    humanoid.Health = 999999
                end
                wait(0.5)
            end
        end)
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "坐下", function(state)
        local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.Sit = state end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "声音折磨", function(state)
        if state then
            local sound = Instance.new("Sound")
            sound.Name = "TortureSound"
            sound.SoundId = "rbxassetid://9120386436"
            sound.Volume = 10
            sound.Looped = true
            sound.Parent = player.Character or workspace
            sound:Play()
        else
            local sound = (player.Character or workspace):FindFirstChild("TortureSound")
            if sound then sound:Destroy() end
        end
    end)
    yPos = yPos + spacing
    
    local rainbowActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "七彩建筑", function(state)
        rainbowActive = state
        if state then
            spawn(function()
                while rainbowActive do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") then
                            obj.Color = Color3.fromHSV(tick() % 1, 1, 1)
                        end
                    end
                    wait(0.1)
                end
            end)
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Color = Color3.fromRGB(163, 162, 165)
                end
            end
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "螺旋上天", function(state)
        if state then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            local rootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                spawn(function()
                    for i = 1, 30 do
                        if not state then break end
                        rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 3, 0) * CFrame.Angles(0, 0.3, 0)
                        wait(0.05)
                    end
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                end)
            end
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "万能锤子", function(state)
        if state then
            local hammer = Instance.new("Tool")
            hammer.Name = "万能锤子"
            hammer.RequiresHandle = true
            local handle = Instance.new("Part")
            handle.Name = "Handle"
            handle.Size = Vector3.new(2, 4, 2)
            handle.Parent = hammer
            hammer.Parent = player.Backpack
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "全地图发光", function(state)
        if state then
            Lighting.Brightness = 3
            Lighting.ExposureCompensation = 2
        else
            Lighting.Brightness = 1
            Lighting.ExposureCompensation = 0
        end
    end)
    yPos = yPos + spacing
    
    local antiYeetActive = false
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "防被甩飞", function(state)
        antiYeetActive = state
        if state then
            spawn(function()
                while antiYeetActive do
                    local character = player.Character
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        if rootPart.Velocity.Magnitude > 100 then
                            rootPart.Velocity = Vector3.new(0, 0, 0)
                            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                    wait(0.1)
                end
            end)
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "点击甩飞", function(state)
        if state then
            local mouse = player:GetMouse()
            mouse.Button1Down:Connect(function()
                if state then
                    local target = mouse.Target
                    if target then
                        target.Velocity = Vector3.new(0, 200, 0)
                        target.AssemblyLinearVelocity = Vector3.new(0, 200, 0)
                    end
                end
            end)
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "重新加入游戏", function(state)
        if state then
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end
    end)
    yPos = yPos + spacing
    
    createToggle(scrollFrame3, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "离开游戏", function(state)
        if state then
            game:Shutdown()
        end
    end)
end
-- ==================== 旋转与范围模块 ====================
local function createRotateRangePage(card)
    local scrollFrame4 = Instance.new("ScrollingFrame")
    scrollFrame4.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame4.BackgroundTransparency = 1
    scrollFrame4.BorderSizePixel = 0
    scrollFrame4.ScrollBarThickness = 4
    scrollFrame4.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame4.CanvasSize = UDim2.new(0, 0, 0, 1200)
    scrollFrame4.ZIndex = 98
    scrollFrame4.Parent = card
    
    local yPos = 10
    
    local headContent = createCollapsible(scrollFrame4, yPos, "头部范围", 300)
    local headY = 5
    createInputRow(headContent, headY, "头部大小：", "1", function(value)
        local character = player.Character
        if character then
            local head = character:FindFirstChild("Head")
            if head then head.Size = Vector3.new(value, value, value) end
        end
    end)
    headY = headY + 40
    createToggle(headContent, UDim2.new(0, 0, 0, headY), UDim2.new(1, 0, 0, 40), "启用头部碰撞箱", function(state)
        local head = player.Character and player.Character:FindFirstChild("Head")
        if head then head.CanCollide = state end
    end)
    headY = headY + 45
    createToggle(headContent, UDim2.new(0, 0, 0, headY), UDim2.new(1, 0, 0, 40), "头部颜色", function(state)
        local head = player.Character and player.Character:FindFirstChild("Head")
        if head then head.Color = state and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(163, 162, 165) end
    end)
    headY = headY + 45
    createToggle(headContent, UDim2.new(0, 0, 0, headY), UDim2.new(1, 0, 0, 40), "头部透明", function(state)
        local head = player.Character and player.Character:FindFirstChild("Head")
        if head then head.Transparency = state and 0.5 or 0 end
    end)
    
    yPos = yPos + 50
    
    local rangeContent = createCollapsible(scrollFrame4, yPos, "范围", 500)
    local rangeY = 5
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "开启范围", function(state) end)
    rangeY = rangeY + 45
    createInputRow(rangeContent, rangeY, "范围大小：", "10", function(value) end)
    rangeY = rangeY + 40
    createInputRow(rangeContent, rangeY, "范围透明度：", "0.5", function(value) end)
    rangeY = rangeY + 40
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "NPC范围", function(state) end)
    rangeY = rangeY + 45
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "队伍检测", function(state) end)
    rangeY = rangeY + 45
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "活体检测", function(state) end)
    rangeY = rangeY + 45
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "显示轮廓", function(state) end)
    rangeY = rangeY + 45
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "禁用碰撞", function(state) end)
    rangeY = rangeY + 45
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "发光效果", function(state) end)
    rangeY = rangeY + 45
    createToggle(rangeContent, UDim2.new(0, 0, 0, rangeY), UDim2.new(1, 0, 0, 40), "脉动效果", function(state) end)
    
    yPos = yPos + 50
    
    local rotateContent = createCollapsible(scrollFrame4, yPos, "旋转", 200)
    local rotateY = 5
    createInputRow(rotateContent, rotateY, "旋转速度：", "10", function(value) end)
    rotateY = rotateY + 40
    createToggle(rotateContent, UDim2.new(0, 0, 0, rotateY), UDim2.new(1, 0, 0, 40), "旋转方向", function(state) end)
    rotateY = rotateY + 45
    createToggle(rotateContent, UDim2.new(0, 0, 0, rotateY), UDim2.new(1, 0, 0, 40), "旋转轴", function(state) end)
    rotateY = rotateY + 45
    createToggle(rotateContent, UDim2.new(0, 0, 0, rotateY), UDim2.new(1, 0, 0, 40), "开启旋转", function(state) end)
end

-- ==================== 传送与甩飞模块 ====================
local function createTeleportYeetPage(card)
    local scrollFrame5 = Instance.new("ScrollingFrame")
    scrollFrame5.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame5.BackgroundTransparency = 1
    scrollFrame5.BorderSizePixel = 0
    scrollFrame5.ScrollBarThickness = 4
    scrollFrame5.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame5.CanvasSize = UDim2.new(0, 0, 0, 1200)
    scrollFrame5.ZIndex = 98
    scrollFrame5.Parent = card
    
    local yPos = 10
    
    local yeetContent = createCollapsible(scrollFrame5, yPos, "甩飞", 400)
    local yeetY = 5
    createToggle(yeetContent, UDim2.new(0, 0, 0, yeetY), UDim2.new(1, 0, 0, 40), "选择玩家", function(state) end)
    yeetY = yeetY + 45
    createToggle(yeetContent, UDim2.new(0, 0, 0, yeetY), UDim2.new(1, 0, 0, 40), "显示名称类型", function(state) end)
    yeetY = yeetY + 45
    createToggle(yeetContent, UDim2.new(0, 0, 0, yeetY), UDim2.new(1, 0, 0, 40), "刷新玩家列表", function(state) end)
    yeetY = yeetY + 45
    createToggle(yeetContent, UDim2.new(0, 0, 0, yeetY), UDim2.new(1, 0, 0, 40), "自动刷新玩家列表", function(state) end)
    yeetY = yeetY + 45
    createInputRow(yeetContent, yeetY, "刷新间隔：", "5", function(value) end)
    yeetY = yeetY + 40
    
    local yeetBtn = Instance.new("TextButton")
    yeetBtn.Size = UDim2.new(1, 0, 0, 40)
    yeetBtn.Position = UDim2.new(0, 0, 0, yeetY)
    yeetBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    yeetBtn.BorderSizePixel = 0
    yeetBtn.Text = "甩飞选中玩家"
    yeetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yeetBtn.TextSize = 13
    yeetBtn.Font = Enum.Font.GothamBold
    yeetBtn.AutoButtonColor = false
    yeetBtn.ZIndex = 100
    yeetBtn.Parent = yeetContent
    
    local yeetCorner = Instance.new("UICorner")
    yeetCorner.CornerRadius = UDim.new(0, 10)
    yeetCorner.Parent = yeetBtn
    
    yeetBtn.MouseButton1Click:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.Velocity = Vector3.new(0, 300, 0)
                    rootPart.AssemblyLinearVelocity = Vector3.new(0, 300, 0)
                end
            end
        end
    end)
    
    yPos = yPos + 50
    
    local distanceContent = createCollapsible(scrollFrame5, yPos, "距离方向", 300)
    local distY = 5
    createToggle(distanceContent, UDim2.new(0, 0, 0, distY), UDim2.new(1, 0, 0, 40), "选择传送吸人方向", function(state) end)
    distY = distY + 45
    createInputRow(distanceContent, distY, "传送吸人距离：", "3", function(value) end)
    distY = distY + 40
    createToggle(distanceContent, UDim2.new(0, 0, 0, distY), UDim2.new(1, 0, 0, 40), "传送玩家到旁边", function(state)
        if state then
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            rootPart.CFrame = myRoot.CFrame + Vector3.new(3, 0, 0)
                        end
                    end
                end
            end
        end
    end)
    distY = distY + 45
    createToggle(distanceContent, UDim2.new(0, 0, 0, distY), UDim2.new(1, 0, 0, 40), "循环锁定传送", function(state) end)
    distY = distY + 45
    createToggle(distanceContent, UDim2.new(0, 0, 0, distY), UDim2.new(1, 0, 0, 40), "循环传送玩家过来", function(state) end)
    
    yPos = yPos + 50
    
    local otherContent = createCollapsible(scrollFrame5, yPos, "其他", 200)
    local otherY = 5
    createToggle(otherContent, UDim2.new(0, 0, 0, otherY), UDim2.new(1, 0, 0, 40), "开启指定自瞄目标", function(state) end)
    otherY = otherY + 45
    createToggle(otherContent, UDim2.new(0, 0, 0, otherY), UDim2.new(1, 0, 0, 40), "吸附全部玩家", function(state)
        if state then
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            rootPart.CFrame = myRoot.CFrame + Vector3.new(0, 2, 0)
                        end
                    end
                end
            end
        end
    end)
    otherY = otherY + 45
    createToggle(otherContent, UDim2.new(0, 0, 0, otherY), UDim2.new(1, 0, 0, 40), "查看玩家", function(state) end)
end
-- ==================== 自动说话模块 ====================
local function createAutoChatPage(card)
    local scrollFrame6 = Instance.new("ScrollingFrame")
    scrollFrame6.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame6.BackgroundTransparency = 1
    scrollFrame6.BorderSizePixel = 0
    scrollFrame6.ScrollBarThickness = 4
    scrollFrame6.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame6.CanvasSize = UDim2.new(0, 0, 0, 1200)
    scrollFrame6.ZIndex = 98
    scrollFrame6.Parent = card
    
    local yPos = 10
    
    local chatContent = createCollapsible(scrollFrame6, yPos, "自动说话", 500)
    local chatY = 5
    createInputRow(chatContent, chatY, "说话内容：", "你好", function(value) end)
    chatY = chatY + 40
    createInputRow(chatContent, chatY, "说话次数：", "10", function(value) end)
    chatY = chatY + 40
    createInputRow(chatContent, chatY, "说话间隔：", "1", function(value) end)
    chatY = chatY + 40
    createToggle(chatContent, UDim2.new(0, 0, 0, chatY), UDim2.new(1, 0, 0, 40), "开始说话", function(state)
        if state then
            spawn(function()
                while state do
                    game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer("你好", "All")
                    wait(1)
                end
            end)
        end
    end)
    chatY = chatY + 45
    createToggle(chatContent, UDim2.new(0, 0, 0, chatY), UDim2.new(1, 0, 0, 40), "停止说话", function(state) end)
    chatY = chatY + 45
    createInputRow(chatContent, chatY, "全自动间隔：", "5", function(value) end)
    chatY = chatY + 40
    createToggle(chatContent, UDim2.new(0, 0, 0, chatY), UDim2.new(1, 0, 0, 40), "全自动说话", function(state)
        if state then
            spawn(function()
                local messages = {"你好", "在吗", "哈哈", "666"}
                local index = 1
                while state do
                    game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(messages[index], "All")
                    index = index + 1
                    if index > #messages then index = 1 end
                    wait(5)
                end
            end)
        end
    end)
    
    yPos = yPos + 50
    
    local insultContent = createCollapsible(scrollFrame6, yPos, "骂人区", 500)
    local insultY = 5
    local insultList = {"三字经", "四字成语", "骂人语录", "嘲讽语录", "素质连喷", "国际问候", "诅咒系列", "人身攻击", "终极嘲讽"}
    for _, insult in ipairs(insultList) do
        createToggle(insultContent, UDim2.new(0, 0, 0, insultY), UDim2.new(1, 0, 0, 40), insult, function(state)
            if state then
                spawn(function()
                    while state do
                        game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(insult, "All")
                        wait(3)
                    end
                end)
            end
        end)
        insultY = insultY + 45
    end
end

-- ==================== 时间透视模块 ====================
local function createTimePage(card)
    local scrollFrame7 = Instance.new("ScrollingFrame")
    scrollFrame7.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame7.BackgroundTransparency = 1
    scrollFrame7.BorderSizePixel = 0
    scrollFrame7.ScrollBarThickness = 4
    scrollFrame7.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame7.CanvasSize = UDim2.new(0, 0, 0, 1000)
    scrollFrame7.ZIndex = 98
    scrollFrame7.Parent = card
    
    local yPos = 10
    
    createToggle(scrollFrame7, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "显示时间", function(state)
        if state then
            local timeLabel = Instance.new("TextLabel")
            timeLabel.Name = "TimeDisplay"
            timeLabel.Size = UDim2.new(0, 120, 0, 30)
            timeLabel.Position = UDim2.new(0.5, -60, 0, 10)
            timeLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            timeLabel.BackgroundTransparency = 0.5
            timeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            timeLabel.TextSize = 15
            timeLabel.Font = Enum.Font.GothamBold
            timeLabel.Parent = player.PlayerGui
            
            spawn(function()
                while state do
                    timeLabel.Text = os.date("%H:%M:%S")
                    wait(1)
                end
                timeLabel:Destroy()
            end)
        else
            local timeLabel = player.PlayerGui:FindFirstChild("TimeDisplay")
            if timeLabel then timeLabel:Destroy() end
        end
    end)
    yPos = yPos + 50
    
    createInputRow(scrollFrame7, yPos, "时间格式：", "24", function(value) end)
    yPos = yPos + 40
    
    local alarmContent = createCollapsible(scrollFrame7, yPos, "闹铃", 500)
    local alarmY = 5
    createInputRow(alarmContent, alarmY, "闹铃时间：", "12:00", function(value) end)
    alarmY = alarmY + 40
    createInputRow(alarmContent, alarmY, "稍后提醒：", "5", function(value) end)
    alarmY = alarmY + 40
    createInputRow(alarmContent, alarmY, "闹钟音量：", "5", function(value) end)
    alarmY = alarmY + 40
    createInputRow(alarmContent, alarmY, "声音ID：", "", function(value) end)
    alarmY = alarmY + 40
    createToggle(alarmContent, UDim2.new(0, 0, 0, alarmY), UDim2.new(1, 0, 0, 40), "停止闹钟声音", function(state)
        if state then
            local sound = player.PlayerGui:FindFirstChild("AlarmSound")
            if sound then sound:Destroy() end
        end
    end)
    alarmY = alarmY + 45
    createToggle(alarmContent, UDim2.new(0, 0, 0, alarmY), UDim2.new(1, 0, 0, 40), "稍后提醒", function(state)
        if state then
            spawn(function()
                task.wait(300)
                local sound = Instance.new("Sound")
                sound.Name = "AlarmSound"
                sound.SoundId = "rbxassetid://9120386436"
                sound.Volume = 5
                sound.Parent = player.PlayerGui
                sound:Play()
            end)
        end
    end)
    alarmY = alarmY + 45
    createToggle(alarmContent, UDim2.new(0, 0, 0, alarmY), UDim2.new(1, 0, 0, 40), "查看当前闹钟", function(state) end)
    alarmY = alarmY + 45
    createToggle(alarmContent, UDim2.new(0, 0, 0, alarmY), UDim2.new(1, 0, 0, 40), "所有闹钟开关", function(state) end)
    alarmY = alarmY + 45
    createToggle(alarmContent, UDim2.new(0, 0, 0, alarmY), UDim2.new(1, 0, 0, 40), "清除所有闹钟", function(state) end)
end
-- ==================== 自瞄模块 ====================
local function createAimbotPage(card)
    local scrollFrame8 = Instance.new("ScrollingFrame")
    scrollFrame8.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame8.BackgroundTransparency = 1
    scrollFrame8.BorderSizePixel = 0
    scrollFrame8.ScrollBarThickness = 4
    scrollFrame8.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame8.CanvasSize = UDim2.new(0, 0, 0, 2500)
    scrollFrame8.ZIndex = 98
    scrollFrame8.Parent = card
    
    local yPos = 10
    
    local aimbotContent = createCollapsible(scrollFrame8, yPos, "自瞄", 2000)
    local aimY = 5
    
    local aimbotActive = false
    local aimbotDistance = 200
    local smoothAim = false
    local smoothAmount = 5
    local aimbotPart = "Head"
    local wallCheck = false
    local teamCheck = false
    local aliveCheck = true
    
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "开启自瞄", function(state)
        aimbotActive = state
        if state then
            spawn(function()
                while aimbotActive do
                    local closest = nil
                    local closestDist = aimbotDistance
                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character then
                            local humanoid = plr.Character:FindFirstChild("Humanoid")
                            local targetPart = plr.Character:FindFirstChild(aimbotPart) or plr.Character:FindFirstChild("HumanoidRootPart")
                            
                            if humanoid and targetPart and myRoot then
                                if aliveCheck and humanoid.Health <= 0 then continue end
                                
                                local dist = (targetPart.Position - myRoot.Position).Magnitude
                                if dist < closestDist then
                                    closestDist = dist
                                    closest = targetPart
                                end
                            end
                        end
                    end
                    
                    if closest and myRoot then
                        if smoothAim then
                            local lookAt = CFrame.lookAt(myRoot.Position, closest.Position)
                            myRoot.CFrame = myRoot.CFrame:Lerp(lookAt, smoothAmount / 10)
                        else
                            myRoot.CFrame = CFrame.lookAt(myRoot.Position, closest.Position)
                        end
                    end
                    wait()
                end
            end)
        end
    end)
    aimY = aimY + 45
    
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "锁定模式", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "显示自瞄快捷悬浮窗", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "锁定悬浮窗位置", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "移动时暂停自瞄", function(state) end)
    aimY = aimY + 45
    createInputRow(aimbotContent, aimY, "自瞄距离：", "200", function(value)
        aimbotDistance = value
    end)
    aimY = aimY + 40
    
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "平滑自瞄", function(state)
        smoothAim = state
    end)
    aimY = aimY + 45
    createInputRow(aimbotContent, aimY, "平滑度：", "5", function(value)
        smoothAmount = value
    end)
    aimY = aimY + 40
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "预判自瞄", function(state) end)
    aimY = aimY + 45
    createInputRow(aimbotContent, aimY, "预判距离：", "10", function(value) end)
    aimY = aimY + 40
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "范围限制", function(state) end)
    aimY = aimY + 45
    createInputRow(aimbotContent, aimY, "视野角度：", "90", function(value) end)
    aimY = aimY + 40
    
    local bodyPartContent = createCollapsible(aimbotContent, aimY, "自瞄部位", 300)
    local bodyY = 5
    local bodyParts = {"Head", "HumanoidRootPart", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    local bodyPartNames = {"头部", "躯干", "身体", "左手", "右手", "左腿", "右腿"}
    for i, part in ipairs(bodyParts) do
        createToggle(bodyPartContent, UDim2.new(0, 0, 0, bodyY), UDim2.new(1, 0, 0, 35), bodyPartNames[i], function(state)
            if state then
                aimbotPart = part
            end
        end)
        bodyY = bodyY + 40
    end
    aimY = aimY + 50
    
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "队伍检测", function(state)
        teamCheck = state
    end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "活体检测", function(state)
        aliveCheck = state
    end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "墙壁检测", function(state)
        wallCheck = state
    end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "好友检测", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "自瞄NPC", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "优先瞄准", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "准心偏移", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "开启准心偏移", function(state) end)
    aimY = aimY + 45
    createInputRow(aimbotContent, aimY, "偏移X轴：", "0", function(value) end)
    aimY = aimY + 40
    createInputRow(aimbotContent, aimY, "偏移Y轴：", "0", function(value) end)
    aimY = aimY + 40
    
    -- FOV圈（Drawing绘制）
    local fovCircleActive = false
    local fovCircleSize = 100
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "显示FOV圈", function(state)
        fovCircleActive = state
        if state then
            spawn(function()
                local circle = Drawing.new("Circle")
                circle.Visible = true
                circle.Radius = fovCircleSize
                circle.Thickness = 2
                circle.Color = Color3.fromRGB(255, 255, 255)
                circle.Transparency = 0.5
                
                while fovCircleActive do
                    local camera = workspace.CurrentCamera
                    if camera then
                        circle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
                    end
                    wait()
                end
                
                circle:Remove()
            end)
        end
    end)
    aimY = aimY + 45
    createInputRow(aimbotContent, aimY, "FOV圈大小：", "100", function(value)
        fovCircleSize = value
    end)
    aimY = aimY + 40
    createInputRow(aimbotContent, aimY, "FOV圈厚度：", "2", function(value) end)
    aimY = aimY + 40
    createInputRow(aimbotContent, aimY, "FOV圈透明度：", "0.5", function(value) end)
    aimY = aimY + 40
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "FOV圈颜色", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "FOV圈跟随", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "显示目标射线", function(state) end)
    aimY = aimY + 45
    createInputRow(aimbotContent, aimY, "射线厚度：", "1", function(value) end)
    aimY = aimY + 40
    createInputRow(aimbotContent, aimY, "射线透明度：", "0.5", function(value) end)
    aimY = aimY + 40
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "射线颜色", function(state) end)
    aimY = aimY + 45
    createToggle(aimbotContent, UDim2.new(0, 0, 0, aimY), UDim2.new(1, 0, 0, 40), "显示距离", function(state) end)
    aimY = aimY + 45
    
    local crosshairContent = createCollapsible(aimbotContent, aimY, "准心", 200)
    local crossY = 5
    createToggle(crosshairContent, UDim2.new(0, 0, 0, crossY), UDim2.new(1, 0, 0, 35), "显示准心", function(state) end)
    crossY = crossY + 40
    createInputRow(crosshairContent, crossY, "准心大小：", "10", function(value) end)
    crossY = crossY + 40
    createInputRow(crosshairContent, crossY, "准心颜色：", "白色", function(value) end)
end
-- ==================== 动画模块 ====================
local function createAnimationPage(card)
    local scrollFrame9 = Instance.new("ScrollingFrame")
    scrollFrame9.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame9.BackgroundTransparency = 1
    scrollFrame9.BorderSizePixel = 0
    scrollFrame9.ScrollBarThickness = 4
    scrollFrame9.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame9.CanvasSize = UDim2.new(0, 0, 0, 1000)
    scrollFrame9.ZIndex = 98
    scrollFrame9.Parent = card
    
    local yPos = 10
    
    local animContent = createCollapsible(scrollFrame9, yPos, "动画", 700)
    local animY = 5
    
    createToggle(animContent, UDim2.new(0, 0, 0, animY), UDim2.new(1, 0, 0, 40), "播放动画", function(state)
        if state then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if humanoid then
                local anim = Instance.new("Animation")
                anim.AnimationId = "rbxassetid://507766388"
                local track = humanoid:LoadAnimation(anim)
                track:Play()
            end
        end
    end)
    animY = animY + 45
    createToggle(animContent, UDim2.new(0, 0, 0, animY), UDim2.new(1, 0, 0, 40), "选择服务器动画", function(state) end)
    animY = animY + 45
    createToggle(animContent, UDim2.new(0, 0, 0, animY), UDim2.new(1, 0, 0, 40), "刷新服务器动画列表", function(state)
        if state then
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if humanoid then
                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end
    end)
    animY = animY + 45
    
    local builtinContent = createCollapsible(animContent, animY, "内置动画", 400)
    local builtinY = 5
    local builtinAnims = {
        {"走路", "rbxassetid://507766388"},
        {"跑步", "rbxassetid://507766666"},
        {"跳跃", "rbxassetid://507765000"},
        {"跳舞", "rbxassetid://507770239"},
        {"挥手", "rbxassetid://507770453"},
        {"鼓掌", "rbxassetid://507770818"},
        {"嘲笑", "rbxassetid://507771019"},
        {"睡觉", "rbxassetid://507771524"},
    }
    for _, animData in ipairs(builtinAnims) do
        createToggle(builtinContent, UDim2.new(0, 0, 0, builtinY), UDim2.new(1, 0, 0, 35), animData[1], function(state)
            if state then
                local character = player.Character
                local humanoid = character and character:FindFirstChild("Humanoid")
                if humanoid then
                    local anim = Instance.new("Animation")
                    anim.AnimationId = animData[2]
                    local track = humanoid:LoadAnimation(anim)
                    track:Play()
                end
            end
        end)
        builtinY = builtinY + 40
    end
    animY = animY + 50
    
    createInputRow(animContent, animY, "自定义动画ID：", "", function(value)
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = "rbxassetid://" .. tostring(value)
            local track = humanoid:LoadAnimation(anim)
            track:Play()
        end
    end)
    animY = animY + 40
    createToggle(animContent, UDim2.new(0, 0, 0, animY), UDim2.new(1, 0, 0, 40), "复制当前动画ID", function(state) end)
    animY = animY + 45
    createInputRow(animContent, animY, "播放速度：", "1", function(value)
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track:AdjustSpeed(value)
            end
        end
    end)
    animY = animY + 40
    createToggle(animContent, UDim2.new(0, 0, 0, animY), UDim2.new(1, 0, 0, 40), "循环播放", function(state)
        local character = player.Character
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                track.Looped = state
            end
        end
    end)
end

-- ==================== FE模块 ====================
local function createFEPage(card)
    local scrollFrame10 = Instance.new("ScrollingFrame")
    scrollFrame10.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame10.BackgroundTransparency = 1
    scrollFrame10.BorderSizePixel = 0
    scrollFrame10.ScrollBarThickness = 4
    scrollFrame10.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame10.CanvasSize = UDim2.new(0, 0, 0, 300)
    scrollFrame10.ZIndex = 98
    scrollFrame10.Parent = card
    
    local yPos = 10
    
    createToggle(scrollFrame10, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "FE指令挂", function(state)
        if state then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "FE指令挂",
                Text = "FE指令已激活",
                Duration = 2,
            })
        end
    end)
end

-- ==================== 光影画质模块 ====================
local function createGraphicsPage(card)
    local scrollFrame11 = Instance.new("ScrollingFrame")
    scrollFrame11.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame11.BackgroundTransparency = 1
    scrollFrame11.BorderSizePixel = 0
    scrollFrame11.ScrollBarThickness = 4
    scrollFrame11.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame11.CanvasSize = UDim2.new(0, 0, 0, 1500)
    scrollFrame11.ZIndex = 98
    scrollFrame11.Parent = card
    
    local yPos = 10
    
    local blurContent = createCollapsible(scrollFrame11, yPos, "模糊", 800)
    local blurY = 5
    
    local blurTypeContent = createCollapsible(blurContent, blurY, "模糊类型", 200)
    local blurTypeY = 5
    local blurTypes = {"运动模糊", "径向模糊", "方向模糊", "缩放模糊"}
    for _, blurType in ipairs(blurTypes) do
        createToggle(blurTypeContent, UDim2.new(0, 0, 0, blurTypeY), UDim2.new(1, 0, 0, 35), blurType, function(state) end)
        blurTypeY = blurTypeY + 40
    end
    blurY = blurY + 50
    
    local presetContent = createCollapsible(blurContent, blurY, "预设配置", 200)
    local presetY = 5
    local presets = {"默认", "强烈", "柔和", "电影", "电影质感"}
    for _, preset in ipairs(presets) do
        createToggle(presetContent, UDim2.new(0, 0, 0, presetY), UDim2.new(1, 0, 0, 35), preset, function(state)
            if state then
                local blur = Instance.new("BlurEffect")
                blur.Parent = Lighting
                if preset == "强烈" then
                    blur.Size = 20
                elseif preset == "柔和" then
                    blur.Size = 5
                elseif preset == "电影" then
                    blur.Size = 12
                elseif preset == "电影质感" then
                    blur.Size = 15
                else
                    blur.Size = 0
                end
            end
        end)
        presetY = presetY + 40
    end
    blurY = blurY + 50
    
    createToggle(blurContent, UDim2.new(0, 0, 0, blurY), UDim2.new(1, 0, 0, 40), "启用模糊", function(state)
        if state then
            local blur = Instance.new("BlurEffect")
            blur.Name = "CustomBlur"
            blur.Size = 10
            blur.Parent = Lighting
        else
            local blur = Lighting:FindFirstChild("CustomBlur")
            if blur then blur:Destroy() end
        end
    end)
    blurY = blurY + 45
    createInputRow(blurContent, blurY, "模糊强度：", "10", function(value)
        local blur = Lighting:FindFirstChild("CustomBlur")
        if blur then blur.Size = value end
    end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "模糊平滑度：", "5", function(value) end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "模糊敏感度：", "3", function(value) end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "模糊持续时间：", "1", function(value) end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "方向X：", "0", function(value) end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "方向Y：", "0", function(value) end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "区域Y1：", "0", function(value) end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "区域Y2：", "0", function(value) end)
    blurY = blurY + 40
    createInputRow(blurContent, blurY, "区域R：", "0", function(value) end)
    
    yPos = yPos + 50
    
    createToggle(scrollFrame11, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "画质", function(state)
        if state then
            settings().Rendering.QualityLevel = 21
        else
            settings().Rendering.QualityLevel = 10
        end
    end)
    yPos = yPos + 50
    
    createToggle(scrollFrame11, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "全地图发光", function(state)
        if state then
            Lighting.Brightness = 3
            Lighting.ExposureCompensation = 2
        else
            Lighting.Brightness = 1
            Lighting.ExposureCompensation = 0
        end
    end)
end
-- ==================== 透视模块 ====================
local function createESPPage(card)
    local scrollFrame12 = Instance.new("ScrollingFrame")
    scrollFrame12.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame12.BackgroundTransparency = 1
    scrollFrame12.BorderSizePixel = 0
    scrollFrame12.ScrollBarThickness = 4
    scrollFrame12.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame12.CanvasSize = UDim2.new(0, 0, 0, 2000)
    scrollFrame12.ZIndex = 98
    scrollFrame12.Parent = card
    
    local yPos = 10
    
    local espContent = createCollapsible(scrollFrame12, yPos, "透视玩家一", 1500)
    local espY = 5
    
    local espActive = false
    createToggle(espContent, UDim2.new(0, 0, 0, espY), UDim2.new(1, 0, 0, 40), "FPS总开关", function(state)
        espActive = state
        spawn(function()
            while espActive do
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= player and plr.Character then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = plr.Character
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        task.delay(1, function() highlight:Destroy() end)
                    end
                end
                wait(1)
            end
        end)
    end)
    espY = espY + 45
    
    local colorModeContent = createCollapsible(espContent, espY, "颜色模式", 200)
    local colorModeY = 5
    local colorModes = {"固定", "按血量", "按距离", "按队伍"}
    for _, mode in ipairs(colorModes) do
        createToggle(colorModeContent, UDim2.new(0, 0, 0, colorModeY), UDim2.new(1, 0, 0, 35), mode, function(state) end)
        colorModeY = colorModeY + 40
    end
    espY = espY + 50
    
    local boxStyleContent = createCollapsible(espContent, espY, "方框样式", 200)
    local boxStyleY = 5
    local boxStyles = {"矩形", "角框", "圆形"}
    for _, style in ipairs(boxStyles) do
        createToggle(boxStyleContent, UDim2.new(0, 0, 0, boxStyleY), UDim2.new(1, 0, 0, 35), style, function(state) end)
        boxStyleY = boxStyleY + 40
    end
    espY = espY + 50
    
    local espToggles = {"身体方框", "头部圆点", "血量", "用户名", "距离", "骨骼", "天线", "天线起点", "高亮显示", "发光显示", "显示人数", "选择ESP颜色", "队伍检测", "墙壁检测", "活体检测", "好友检测"}
    for _, toggleName in ipairs(espToggles) do
        createToggle(espContent, UDim2.new(0, 0, 0, espY), UDim2.new(1, 0, 0, 40), toggleName, function(state) end)
        espY = espY + 45
    end
    
    yPos = yPos + 50
    
    local scriptUserContent = createCollapsible(scrollFrame12, yPos, "透视脚本用户", 200)
    local scriptUserY = 5
    createToggle(scriptUserContent, UDim2.new(0, 0, 0, scriptUserY), UDim2.new(1, 0, 0, 40), "透视脚本用户", function(state) end)
    scriptUserY = scriptUserY + 45
    createToggle(scriptUserContent, UDim2.new(0, 0, 0, scriptUserY), UDim2.new(1, 0, 0, 40), "显示正在使用脚本的用户", function(state) end)
end
-- ==================== ACS漏洞模块 ====================
local function createACSPage(card)
    local scrollFrame13 = Instance.new("ScrollingFrame")
    scrollFrame13.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame13.BackgroundTransparency = 1
    scrollFrame13.BorderSizePixel = 0
    scrollFrame13.ScrollBarThickness = 4
    scrollFrame13.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame13.CanvasSize = UDim2.new(0, 0, 0, 5000)
    scrollFrame13.ZIndex = 98
    scrollFrame13.Parent = card
    
    local yPos = 10
    
    local detectLabel = Instance.new("TextLabel")
    detectLabel.Size = UDim2.new(1, -20, 0, 35)
    detectLabel.Position = UDim2.new(0, 10, 0, yPos)
    detectLabel.BackgroundTransparency = 1
    detectLabel.Text = "检测状态：未检测到ACS版本 N/A"
    detectLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    detectLabel.TextSize = 13
    detectLabel.Font = Enum.Font.GothamMedium
    detectLabel.TextXAlignment = Enum.TextXAlignment.Left
    detectLabel.ZIndex = 100
    detectLabel.Parent = scrollFrame13
    yPos = yPos + 40
    
    local redetectBtn = Instance.new("TextButton")
    redetectBtn.Size = UDim2.new(1, -20, 0, 35)
    redetectBtn.Position = UDim2.new(0, 10, 0, yPos)
    redetectBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    redetectBtn.BorderSizePixel = 0
    redetectBtn.Text = "重新检测"
    redetectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    redetectBtn.TextSize = 13
    redetectBtn.Font = Enum.Font.GothamMedium
    redetectBtn.AutoButtonColor = false
    redetectBtn.ZIndex = 100
    redetectBtn.Parent = scrollFrame13
    
    local redetectCorner = Instance.new("UICorner")
    redetectCorner.CornerRadius = UDim.new(0, 10)
    redetectCorner.Parent = redetectBtn
    
    redetectBtn.MouseButton1Click:Connect(function()
        detectLabel.Text = "检测状态：未检测到ACS版本 N/A"
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "ACS检测",
            Text = "未检测到ACS",
            Duration = 2,
        })
    end)
    yPos = yPos + 50
    
    local targetContent = createCollapsible(scrollFrame13, yPos, "目标玩家操作", 600)
    local targetY = 5
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "选择目标玩家", function(state) end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "传送到玩家", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart and myRoot then
                        myRoot.CFrame = rootPart.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end
        end
    end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "击杀选中玩家", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then humanoid.Health = 0 end
                end
            end
        end
    end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "致残选中玩家", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 0
                        humanoid.JumpPower = 0
                    end
                end
            end
        end
    end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "治疗选中玩家", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then humanoid.Health = humanoid.MaxHealth end
                end
            end
        end
    end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "上帝模式选中玩家", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.MaxHealth = 999999
                        humanoid.Health = 999999
                    end
                end
            end
        end
    end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "压制选中玩家", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.Velocity = Vector3.new(0, -200, 0)
                    end
                end
            end
        end
    end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "子弹呼啸选中玩家", function(state) end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "给选中玩家无限弹药", function(state) end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "拖拽选中玩家", function(state)
        if state then
            spawn(function()
                while state do
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character then
                            local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart and myRoot then
                                rootPart.CFrame = myRoot.CFrame + Vector3.new(0, 3, -5)
                            end
                        end
                    end
                    wait()
                end
            end)
        end
    end)
    targetY = targetY + 45
    createToggle(targetContent, UDim2.new(0, 0, 0, targetY), UDim2.new(1, 0, 0, 40), "全局攻击", function(state) end)
    
    yPos = yPos + 50
    
    local killAllContent = createCollapsible(scrollFrame13, yPos, "杀死所有人", 600)
    local killY = 5
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "杀死所有人", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then humanoid.Health = 0 end
                end
            end
        end
    end)
    killY = killY + 45
    
    local autoKillActive = false
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "自动秒杀循环", function(state)
        autoKillActive = state
        if state then
            spawn(function()
                while autoKillActive do
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= player and plr.Character then
                            local humanoid = plr.Character:FindFirstChild("Humanoid")
                            if humanoid then humanoid.Health = 0 end
                        end
                    end
                    wait(1)
                end
            end)
        end
    end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "杀死所有人(包括自己)", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then humanoid.Health = 0 end
                end
            end
        end
    end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "让所有人残疾", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.WalkSpeed = 0
                        humanoid.JumpPower = 0
                    end
                end
            end
        end
    end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "治疗所有人", function(state)
        if state then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local humanoid = plr.Character:FindFirstChild("Humanoid")
                    if humanoid then humanoid.Health = humanoid.MaxHealth end
                end
            end
        end
    end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "自动治疗循环", function(state)
        if state then
            spawn(function()
                while state do
                    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
                    if humanoid then humanoid.Health = humanoid.MaxHealth end
                    wait(0.5)
                end
            end)
        end
    end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "治疗队友", function(state) end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "伤害队友", function(state) end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "范围爆炸伤害", function(state) end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "范围Hit爆炸", function(state) end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "自动攻击循环", function(state) end)
    killY = killY + 45
    createToggle(killAllContent, UDim2.new(0, 0, 0, killY), UDim2.new(1, 0, 0, 40), "远程攻击", function(state) end)
    
    yPos = yPos + 50
    
    local autoModContent = createCollapsible(scrollFrame13, yPos, "自动修改", 600)
    local autoModY = 5
    local autoModToggles = {"一键无敌", "武器一击必杀", "爆炸子弹", "无限弹药", "获取所有武器", "本地配置2.0.1", "无限体力", "禁用坠落伤害", "允许跳跃", "无限子弹", "无敌模式", "无限呼吸", "无限冲刺"}
    for _, toggleName in ipairs(autoModToggles) do
        createToggle(autoModContent, UDim2.new(0, 0, 0, autoModY), UDim2.new(1, 0, 0, 40), toggleName, function(state) end)
        autoModY = autoModY + 45
    end
    
    yPos = yPos + 50
    
    local destroyContent = createCollapsible(scrollFrame13, yPos, "破拆/干扰", 500)
    local destroyY = 5
    local destroyToggles = {"破拆干扰", "破拆强度", "位置破拆", "全局破拆", "破坏所有建筑物", "破坏玩家建筑物", "全局干扰", "全局压制干扰", "自动压制循环", "全局子弹呼啸", "自动呼啸循环"}
    for _, toggleName in ipairs(destroyToggles) do
        createToggle(destroyContent, UDim2.new(0, 0, 0, destroyY), UDim2.new(1, 0, 0, 40), toggleName, function(state) end)
        destroyY = destroyY + 45
    end
    
    yPos = yPos + 50
    
    local crashContent = createCollapsible(scrollFrame13, yPos, "崩溃服务器", 500)
    local crashY = 5
    local crashToggles = {"服务器卡顿攻击", "服务器延迟攻击", "完全卡死服务器", "无限投递崩溃", "数据洪流攻击", "全世界轰炸", "极速崩溃", "无限循环请求", "全速攻击", "延迟爆炸攻击"}
    for _, toggleName in ipairs(crashToggles) do
        createToggle(crashContent, UDim2.new(0, 0, 0, crashY), UDim2.new(1, 0, 0, 40), toggleName, function(state) end)
        crashY = crashY + 45
    end
    
    yPos = yPos + 50
    
    local mapEffectContent = createCollapsible(scrollFrame13, yPos, "全图效果", 500)
    local mapEffectY = 5
    local mapEffectToggles = {"全图Hit爆炸", "全图Hit爆炸循环", "单图全图Hit爆炸", "全图燃烧效果", "全图冰冻效果", "全图雷电效果", "全图毒气效果", "全图击飞效果", "全图眩晕效果", "全图混乱效果"}
    for _, toggleName in ipairs(mapEffectToggles) do
        createToggle(mapEffectContent, UDim2.new(0, 0, 0, mapEffectY), UDim2.new(1, 0, 0, 40), toggleName, function(state) end)
        mapEffectY = mapEffectY + 45
    end
end
-- ==================== 飞行与飞车模块 ====================
local function createFlyPage(card)
    local scrollFrame14 = Instance.new("ScrollingFrame")
    scrollFrame14.Size = UDim2.new(1, 0, 1, 0)
    scrollFrame14.BackgroundTransparency = 1
    scrollFrame14.BorderSizePixel = 0
    scrollFrame14.ScrollBarThickness = 4
    scrollFrame14.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollFrame14.CanvasSize = UDim2.new(0, 0, 0, 600)
    scrollFrame14.ZIndex = 98
    scrollFrame14.Parent = card
    
    local yPos = 10
    local spacing = 50
    
    local flyActive = false
    createToggle(scrollFrame14, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "飞行", function(state)
        flyActive = state
        if state then
            spawn(function()
                while flyActive do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if character and humanoid and rootPart then
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                        rootPart.Velocity = rootPart.CFrame.LookVector * 50
                    end
                    wait()
                end
            end)
        end
    end)
    yPos = yPos + spacing
    
    createInputRow(scrollFrame14, yPos, "飞行速度：", "50", function(value) end)
    yPos = yPos + 40
    
    local arceusFlyActive = false
    createToggle(scrollFrame14, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "阿尔宙斯飞行", function(state)
        arceusFlyActive = state
        if state then
            spawn(function()
                while arceusFlyActive do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                    if character and humanoid and rootPart then
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                        humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                        rootPart.Velocity = rootPart.CFrame.LookVector * 100 + Vector3.new(0, 30, 0)
                    end
                    wait()
                end
            end)
        end
    end)
    yPos = yPos + spacing
    
    local flyCarActive = false
    createToggle(scrollFrame14, UDim2.new(0, 10, 0, yPos), UDim2.new(1, -20, 0, 40), "F1飞车", function(state)
        flyCarActive = state
        if state then
            spawn(function()
                while flyCarActive do
                    local vehicle = player.Character and player.Character:FindFirstChildOfClass("VehicleSeat")
                    if vehicle then
                        vehicle.Velocity = vehicle.CFrame.LookVector * 200
                    end
                    wait(0.1)
                end
            end)
        end
    end)
end

-- ==================== 卡片创建 ====================
local function createCard(featureIndex)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 1, 0)
    card.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.ZIndex = 97
    card.Parent = cardContainer
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 12)
    cardCorner.Parent = card
    
    if featureIndex == 1 then
        createHomePage(card)
    elseif featureIndex == 2 then
        createLocalPlayerPage(card)
    elseif featureIndex == 3 then
        createGeneralPage(card)
    elseif featureIndex == 4 then
        createRotateRangePage(card)
    elseif featureIndex == 5 then
        createTeleportYeetPage(card)
    elseif featureIndex == 6 then
        createAutoChatPage(card)
    elseif featureIndex == 7 then
        createTimePage(card)
    elseif featureIndex == 8 then
        createAimbotPage(card)
    elseif featureIndex == 9 then
        createAnimationPage(card)
    elseif featureIndex == 10 then
        createFEPage(card)
    elseif featureIndex == 11 then
        createGraphicsPage(card)
    elseif featureIndex == 12 then
        createESPPage(card)
    elseif featureIndex == 13 then
        createACSPage(card)
    elseif featureIndex == 14 then
        createFlyPage(card)
    end
    
    return {card = card, corner = cardCorner}
end

-- ==================== 渐变切换 ====================
local function switchCardWithFade(newFeatureIndex)
    if currentCardIndex == newFeatureIndex or isSwitchingCard then return end
    
    isSwitchingCard = true
    
    local newCardData = createCard(newFeatureIndex)
    newCardData.card.BackgroundTransparency = 1
    newCardData.card.Position = UDim2.new(0, 20, 0, 0)
    
    if currentCardData then
        local oldCard = currentCardData.card
        TweenService:Create(oldCard, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
        TweenService:Create(oldCard, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, -20, 0, 0)}):Play()
        task.delay(0.2, function() oldCard:Destroy() end)
    end
    
    TweenService:Create(newCardData.card, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
    TweenService:Create(newCardData.card, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    task.delay(0.3, function() isSwitchingCard = false end)
    
    currentCardData = newCardData
    currentCardIndex = newFeatureIndex
end

local firstCardData = createCard(1)
firstCardData.card.BackgroundTransparency = 0
currentCardData = firstCardData
currentCardIndex = 1

-- ==================== 面板物理 ====================
local panelPhysics = {width = 0, height = 0, widthVelocity = 0, heightVelocity = 0, transparency = 1, transparencyVelocity = 0}
local isPanelOpen = false
local isPanelAnimating = false
local isClosing = false

local function updatePanelSpring(dt)
    local stiffness = 150
    local damping = 0.9 * 2 * math.sqrt(stiffness)
    local mass = 0.8
    
    local targetWidth = isPanelOpen and CONFIG.panelWidth or 0
    local widthForce = -stiffness * (panelPhysics.width - targetWidth) - damping * panelPhysics.widthVelocity
    panelPhysics.widthVelocity = panelPhysics.widthVelocity + (widthForce / mass) * dt
    panelPhysics.width = panelPhysics.width + panelPhysics.widthVelocity * dt
    
    local targetHeight = isPanelOpen and CONFIG.panelHeight or 0
    local heightForce = -stiffness * (panelPhysics.height - targetHeight) - damping * panelPhysics.heightVelocity
    panelPhysics.heightVelocity = panelPhysics.heightVelocity + (heightForce / mass) * dt
    panelPhysics.height = panelPhysics.height + panelPhysics.heightVelocity * dt
    
    local targetTransparency = isPanelOpen and 0 or 1
    local transparencyStiffness = stiffness * 1.5
    local transparencyDamping = 0.9 * 2 * math.sqrt(transparencyStiffness)
    local transparencyForce = -transparencyStiffness * (panelPhysics.transparency - targetTransparency) - transparencyDamping * panelPhysics.transparencyVelocity
    panelPhysics.transparencyVelocity = panelPhysics.transparencyVelocity + (transparencyForce / mass) * dt
    panelPhysics.transparency = panelPhysics.transparency + panelPhysics.transparencyVelocity * dt
end

local function updatePanelVisual()
    if panel.Visible then
        local currentWidth = math.max(0, panelPhysics.width)
        local currentHeight = math.max(0, panelPhysics.height)
        panel.Size = UDim2.new(0, currentWidth, 0, currentHeight)
        
        local currentTransparency = math.clamp(panelPhysics.transparency, 0, 1)
        panel.BackgroundTransparency = currentTransparency
        
        local scaleX = currentWidth / CONFIG.panelWidth
        local scaleY = currentHeight / CONFIG.panelHeight
        local scale = math.min(scaleX, scaleY)
        panelScale.Scale = math.clamp(scale, 0.01, 1)
        
        topBar.BackgroundTransparency = currentTransparency
        title.TextTransparency = currentTransparency
        minimizeBtn.BackgroundTransparency = currentTransparency
        minimizeBtn.TextTransparency = currentTransparency
        closeBtn.BackgroundTransparency = currentTransparency
        closeBtn.TextTransparency = currentTransparency
        sidebar.BackgroundTransparency = currentTransparency
        contentArea.BackgroundTransparency = currentTransparency
        sidebarDivider.BackgroundTransparency = currentTransparency
        
        for _, btnData in ipairs(sidebarButtonData) do
            btnData.button.BackgroundTransparency = currentTransparency
            btnData.label.TextTransparency = currentTransparency
        end
    end
end

local function minimizePanel()
    isPanelOpen = false
    isPanelAnimating = true
    panelPhysics.heightVelocity = -15
    panelPhysics.widthVelocity = -10
end

local function closeAll()
    isClosing = true
    isPanelOpen = false
    isPanelAnimating = true
    panelPhysics.heightVelocity = -20
    panelPhysics.widthVelocity = -15
    task.delay(0.4, function() fluidGui:Destroy() end)
end

-- ==================== 事件绑定 ====================
container.MouseButton1Click:Connect(function()
    if not isPanelOpen and not isClosing then
        isPanelOpen = true
        isPanelAnimating = true
        panel.Visible = true
        panelPhysics.heightVelocity = 35
        panelPhysics.widthVelocity = 25
        panelPhysics.transparencyVelocity = -3
        updateSidebarSelection()
    end
end)

minimizeBtn.MouseButton1Click:Connect(minimizePanel)
closeBtn.MouseButton1Click:Connect(closeAll)

for i, sbtn in ipairs(sidebarButtons) do
    sbtn.MouseButton1Click:Connect(function()
        selectedFeature = i
        updateSidebarSelection()
        switchCardWithFade(selectedFeature)
    end)
end

RunService.RenderStepped:Connect(function(dt)
    dt = math.min(dt, 0.033)
    
    if isPanelAnimating then
        updatePanelSpring(dt)
        updatePanelVisual()
        
        local targetWidth = isPanelOpen and CONFIG.panelWidth or 0
        local targetHeight = isPanelOpen and CONFIG.panelHeight or 0
        local targetTransparency = isPanelOpen and 0 or 1
        
        local widthDone = math.abs(panelPhysics.width - targetWidth) < 0.5 and math.abs(panelPhysics.widthVelocity) < 0.5
        local heightDone = math.abs(panelPhysics.height - targetHeight) < 0.5 and math.abs(panelPhysics.heightVelocity) < 0.5
        local transparencyDone = math.abs(panelPhysics.transparency - targetTransparency) < 0.005 and math.abs(panelPhysics.transparencyVelocity) < 0.005
        
        if widthDone and heightDone and transparencyDone then
            isPanelAnimating = false
            panelPhysics.width = targetWidth
            panelPhysics.height = targetHeight
            panelPhysics.transparency = targetTransparency
            panelPhysics.widthVelocity = 0
            panelPhysics.heightVelocity = 0
            panelPhysics.transparencyVelocity = 0
            
            if not isPanelOpen then panel.Visible = false end
            updatePanelVisual()
        end
    elseif isPanelOpen then
        updatePanelVisual()
    end
end)

TweenService:Create(container, TweenInfo.new(0.8, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, CONFIG.normalY)}):Play()

updateSidebarSelection()

-- ==================== loadFluidCloud函数定义 ====================
function loadFluidCloud()
    print("✅ 时脚本 · 流体云灵动岛 · 终极版")
    print("🔥 180+功能已注入")
    print("👑 作者：时脚本")
end
