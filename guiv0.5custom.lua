local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local zoneGap, titleHeight, bottomHeight = 10, 40, 20
local tabPanelWidth = 120

-- Color System
local Colors = {
    DarkGray = Color3.fromRGB(35, 35, 35),
    MediumGray = Color3.fromRGB(50, 50, 50),
    LightGray = Color3.fromRGB(60, 60, 60),
    Red = Color3.fromRGB(255, 0, 0),
    Green = Color3.fromRGB(0, 255, 0),
    Blue = Color3.fromRGB(0, 100, 255),
    Yellow = Color3.fromRGB(255, 255, 0),
    Purple = Color3.fromRGB(128, 0, 128),
    Orange = Color3.fromRGB(255, 165, 0),
    Pink = Color3.fromRGB(255, 105, 180),
    Cyan = Color3.fromRGB(0, 255, 255),
}

local colorNames = {"DarkGray", "MediumGray", "LightGray", "Red", "Green", "Blue", "Yellow", "Purple", "Orange", "Pink", "Cyan"}

local currentSettings = {
    color1 = "DarkGray",
    color2 = "Blue",
    gradientEnabled = false,
    gradientRotation = 90
}

-- Function to brighten color
local function brightenColor(color, amount)
    amount = amount or 0.2
    local h, s, v = color:ToHSV()
    v = math.clamp(v + amount, 0, 1)
    return Color3.fromHSV(h, s, v)
end

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "Gui script by Georgiy/8"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 6)

-- A — Заголовок (чуть ярче фона)
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, -2 * zoneGap, 0, titleHeight)
titleBar.Position = UDim2.new(0, zoneGap, 0, zoneGap)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Active = true
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 6)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, -140, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Pilgrammed Script by Georgiy/8"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Список вкладок (добавлена последняя Settings)
local tabs = {
    { name = "Main", icon = "🧭" },
    { name = "Movement", icon = "🏃" },
    { name = "ESP", icon = "👁️" },
    { name = "Float", icon = "🪶" },
    { name = "Fishing", icon = "🎣" },
    { name = "Settings", icon = "⚙️" },
}

-- B — Вкладки (ScrollingFrame) с UIListLayout и UIPadding
local tabPanel = Instance.new("ScrollingFrame", mainFrame)
tabPanel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tabPanel.BorderSizePixel = 0
tabPanel.CanvasSize = UDim2.new(0, 0, 0, 0)
tabPanel.ScrollBarThickness = 6
tabPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabPanel.ScrollingDirection = Enum.ScrollingDirection.Y
Instance.new("UICorner", tabPanel).CornerRadius = UDim.new(0, 6)

local padding = Instance.new("UIPadding", tabPanel)
padding.PaddingLeft = UDim.new(0, 6)
padding.PaddingRight = UDim.new(0, 6)
padding.PaddingTop = UDim.new(0, 6)
padding.PaddingBottom = UDim.new(0, 6)

local layout = Instance.new("UIListLayout", tabPanel)
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- D — Контент (адаптивный ScrollingFrame, пустой по умолчанию)
local contentZone = Instance.new("ScrollingFrame", mainFrame)
contentZone.Name = "ContentZone"
contentZone.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
contentZone.BorderSizePixel = 0
contentZone.CanvasSize = UDim2.new(0, 0, 0, 0)
contentZone.ScrollBarThickness = 6
contentZone.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentZone.ScrollingDirection = Enum.ScrollingDirection.Y
Instance.new("UICorner", contentZone).CornerRadius = UDim.new(0, 6)

local contentLayout = Instance.new("UIListLayout", contentZone)
contentLayout.Padding = UDim.new(0, 10)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local contentConstraint = Instance.new("UISizeConstraint", contentZone)
contentConstraint.MaxSize = Vector2.new(2000, 2000)

-- C — Нижняя панель (чуть ярче фона)
local bottomBar = Instance.new("Frame", mainFrame)
bottomBar.Size = UDim2.new(1, -2 * zoneGap, 0, bottomHeight)
bottomBar.Position = UDim2.new(0, zoneGap, 1, -(bottomHeight + zoneGap))
bottomBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
bottomBar.BorderSizePixel = 0
Instance.new("UICorner", bottomBar).CornerRadius = UDim.new(0, 6)

-- Функция применения цветов ко всем GUI элементам
local guiElements = {}
local tabButtons = {} -- Store tab buttons separately

local function applyColors()
    if currentSettings.gradientEnabled then
        -- Apply gradient to main elements
        for _, elem in ipairs(guiElements) do
            local gradient = elem:FindFirstChildOfClass("UIGradient")
            if not gradient then
                gradient = Instance.new("UIGradient")
                gradient.Parent = elem
            end
            
            -- Brighten colors for A-D zones
            local brighterColor1 = brightenColor(Colors[currentSettings.color1], 0.15)
            local brighterColor2 = brightenColor(Colors[currentSettings.color2], 0.15)
            
            local colorSequence = ColorSequence.new({
                ColorSequenceKeypoint.new(0, brighterColor1),
                ColorSequenceKeypoint.new(1, brighterColor2)
            })
            
            gradient.Color = colorSequence
            gradient.Rotation = currentSettings.gradientRotation
        end
        
        -- Apply gradient to tab buttons with even brighter tone
        for _, btn in ipairs(tabButtons) do
            local gradient = btn:FindFirstChildOfClass("UIGradient")
            if not gradient then
                gradient = Instance.new("UIGradient")
                gradient.Parent = btn
            end
            
            -- Extra brightness for tabs
            local brighterColor1 = brightenColor(Colors[currentSettings.color1], 0.25)
            local brighterColor2 = brightenColor(Colors[currentSettings.color2], 0.25)
            
            local colorSequence = ColorSequence.new({
                ColorSequenceKeypoint.new(0, brighterColor1),
                ColorSequenceKeypoint.new(1, brighterColor2)
            })
            
            gradient.Color = colorSequence
            gradient.Rotation = currentSettings.gradientRotation
        end
    else
        -- Remove gradients and apply solid color with brightness
        for _, elem in ipairs(guiElements) do
            local gradient = elem:FindFirstChildOfClass("UIGradient")
            if gradient then
                gradient:Destroy()
            end
            elem.BackgroundColor3 = brightenColor(Colors[currentSettings.color1], 0.15)
        end
        
        -- Apply solid color to tabs with extra brightness
        for _, btn in ipairs(tabButtons) do
            local gradient = btn:FindFirstChildOfClass("UIGradient")
            if gradient then
                gradient:Destroy()
            end
            btn.BackgroundColor3 = brightenColor(Colors[currentSettings.color1], 0.25)
        end
    end
end

-- Добавляем элементы которые нужно перекрашивать (A, B, C, D zones)
table.insert(guiElements, mainFrame)
table.insert(guiElements, titleBar)        -- A zone
table.insert(guiElements, tabPanel)        -- B zone
table.insert(guiElements, contentZone)     -- D zone
table.insert(guiElements, bottomBar)       -- C zone

-- Функция обновления размеров и позиций зон
local function updateLayout()
    RunService.Heartbeat:Wait()

    local mainW, mainH = mainFrame.AbsoluteSize.X, mainFrame.AbsoluteSize.Y
    local tabW = tabPanelWidth
    local leftOffset = tabW + zoneGap * 2

    local contentWidth = math.max(0, mainW - leftOffset - zoneGap)
    local contentHeight = math.max(0, mainH - (titleHeight + bottomHeight + zoneGap * 4))

    tabPanel.Size = UDim2.new(0, tabW, 0, contentHeight)
    tabPanel.Position = UDim2.new(0, zoneGap, 0, titleHeight + zoneGap * 2)

    titleBar.Size = UDim2.new(1, -2 * zoneGap, 0, titleHeight)
    titleBar.Position = UDim2.new(0, zoneGap, 0, zoneGap)
    titleLabel.Size = UDim2.new(1, -140, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)

    bottomBar.Size = UDim2.new(0, mainW - 2 * zoneGap, 0, bottomHeight)
    bottomBar.Position = UDim2.new(0, zoneGap, 0, mainH - (bottomHeight + zoneGap))

    contentZone.Position = UDim2.new(0, leftOffset, 0, titleHeight + zoneGap * 2)
    contentZone.Size = UDim2.new(0, contentWidth, 0, contentHeight)

    contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    tabPanel.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
end

mainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)
tabPanel:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLayout)

-- Перетаскивание
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- Ресайз
local resizeHandle = Instance.new("Frame", bottomBar)
resizeHandle.Size = UDim2.new(0, 20, 0, 20)
resizeHandle.Position = UDim2.new(1, -20, 0, 0)
resizeHandle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
resizeHandle.BorderSizePixel = 0
Instance.new("UICorner", resizeHandle).CornerRadius = UDim.new(0, 4)

local resizing = false
resizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then resizing = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mouse = UserInputService:GetMouseLocation()
        local inset = GuiService:GetGuiInset()
        local newWidth = math.clamp(mouse.X - mainFrame.AbsolutePosition.X, 300, 1000)
        local newHeight = math.clamp(mouse.Y - mainFrame.AbsolutePosition.Y - inset.Y, 200, 800)
        mainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Восстановление
local restoreGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
restoreGui.ResetOnSpawn = false
restoreGui.Name = "RestoreButtonGui"
restoreGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
restoreGui.DisplayOrder = 1000
restoreGui.Enabled = false

local restoreButton = Instance.new("TextButton", restoreGui)
restoreButton.Size = UDim2.new(0, 100, 0, 40)
restoreButton.Position = UDim2.new(0, 20, 1, -60)
restoreButton.BackgroundColor3 = Color3.fromRGB(255, 200, 40)
restoreButton.Text = "Открыть GUI"
restoreButton.Font = Enum.Font.GothamBold
restoreButton.TextSize = 16
restoreButton.TextColor3 = Color3.fromRGB(0, 0, 0)
restoreButton.BorderSizePixel = 0
Instance.new("UICorner", restoreButton).CornerRadius = UDim.new(0, 6)

restoreButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    restoreGui.Enabled = false
end)

-- Кнопки управления окном
local isMaximized = false
local prevSize = mainFrame.Size
local prevPos = mainFrame.Position

local function createTitleButton(txt, offset, callback)
    local btn = Instance.new("TextButton", titleBar)
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, -offset, 0, 5)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = txt
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
end

createTitleButton("_", 100, function()
    mainFrame.Visible = false
    restoreGui.Enabled = true
end)

createTitleButton("□", 65, function()
    if not isMaximized then
        prevSize = mainFrame.Size
        prevPos = mainFrame.Position
        mainFrame.Size = UDim2.new(1, -40, 1, -40)
        mainFrame.Position = UDim2.new(0, 20, 0, 20)
        isMaximized = true
    else
        mainFrame.Size = prevSize
        mainFrame.Position = prevPos
        isMaximized = false
    end
end)

createTitleButton("X", 30, function()
    gui:Destroy()
    restoreGui:Destroy()
end)

-- Функция создания Settings контента
local function createSettingsContent()
    local padding = Instance.new("UIPadding", contentZone)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.PaddingTop = UDim.new(0, 10)
    
    -- Заголовок Color Settings
    local titleLabel = Instance.new("TextLabel", contentZone)
    titleLabel.Size = UDim2.new(1, -20, 0, 30)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "🎨 Color Settings"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 20
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.LayoutOrder = 1
    
    -- Color 1 Section
    local color1Frame = Instance.new("Frame", contentZone)
    color1Frame.Size = UDim2.new(1, -20, 0, 200)
    color1Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    color1Frame.BorderSizePixel = 0
    color1Frame.LayoutOrder = 2
    Instance.new("UICorner", color1Frame).CornerRadius = UDim.new(0, 6)
    
    local color1Title = Instance.new("TextLabel", color1Frame)
    color1Title.Size = UDim2.new(1, -20, 0, 25)
    color1Title.Position = UDim2.new(0, 10, 0, 10)
    color1Title.BackgroundTransparency = 1
    color1Title.Text = "Primary Color"
    color1Title.Font = Enum.Font.GothamBold
    color1Title.TextSize = 16
    color1Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    color1Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local color1Grid = Instance.new("Frame", color1Frame)
    color1Grid.Size = UDim2.new(1, -20, 0, 155)
    color1Grid.Position = UDim2.new(0, 10, 0, 40)
    color1Grid.BackgroundTransparency = 1
    
    local gridLayout1 = Instance.new("UIGridLayout", color1Grid)
    gridLayout1.CellSize = UDim2.new(0, 45, 0, 45)
    gridLayout1.CellPadding = UDim2.new(0, 5, 0, 5)
    
    -- Color 2 Section
    local color2Frame = Instance.new("Frame", contentZone)
    color2Frame.Size = UDim2.new(1, -20, 0, 200)
    color2Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    color2Frame.BorderSizePixel = 0
    color2Frame.LayoutOrder = 3
    Instance.new("UICorner", color2Frame).CornerRadius = UDim.new(0, 6)
    
    local color2Title = Instance.new("TextLabel", color2Frame)
    color2Title.Size = UDim2.new(1, -20, 0, 25)
    color2Title.Position = UDim2.new(0, 10, 0, 10)
    color2Title.BackgroundTransparency = 1
    color2Title.Text = "Secondary Color (Gradient)"
    color2Title.Font = Enum.Font.GothamBold
    color2Title.TextSize = 16
    color2Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    color2Title.TextXAlignment = Enum.TextXAlignment.Left
    
    local color2Grid = Instance.new("Frame", color2Frame)
    color2Grid.Size = UDim2.new(1, -20, 0, 155)
    color2Grid.Position = UDim2.new(0, 10, 0, 40)
    color2Grid.BackgroundTransparency = 1
    
    local gridLayout2 = Instance.new("UIGridLayout", color2Grid)
    gridLayout2.CellSize = UDim2.new(0, 45, 0, 45)
    gridLayout2.CellPadding = UDim2.new(0, 5, 0, 5)
    
    -- Gradient Toggle Button
    local gradientButton = Instance.new("TextButton", contentZone)
    gradientButton.Size = UDim2.new(1, -20, 0, 50)
    gradientButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    gradientButton.Text = "🎨 Gradient Mode: OFF"
    gradientButton.Font = Enum.Font.GothamBold
    gradientButton.TextSize = 18
    gradientButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    gradientButton.BorderSizePixel = 0
    gradientButton.LayoutOrder = 4
    Instance.new("UICorner", gradientButton).CornerRadius = UDim.new(0, 6)
    
    -- Create color buttons
    local selectedButtons1 = {}
    local selectedButtons2 = {}
    
    for i, colorName in ipairs(colorNames) do
        -- Color 1 button
        local btn1 = Instance.new("TextButton", color1Grid)
        btn1.BackgroundColor3 = Colors[colorName]
        btn1.Text = ""
        btn1.BorderSizePixel = 2
        btn1.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn1.BorderMode = Enum.BorderMode.Inset
        Instance.new("UICorner", btn1).CornerRadius = UDim.new(0, 6)
        
        if colorName == currentSettings.color1 then
            btn1.BorderSizePixel = 4
        end
        
        selectedButtons1[colorName] = btn1
        
        btn1.MouseButton1Click:Connect(function()
            for name, button in pairs(selectedButtons1) do
                button.BorderSizePixel = 2
            end
            btn1.BorderSizePixel = 4
            currentSettings.color1 = colorName
            applyColors()
        end)
        
        -- Color 2 button
        local btn2 = Instance.new("TextButton", color2Grid)
        btn2.BackgroundColor3 = Colors[colorName]
        btn2.Text = ""
        btn2.BorderSizePixel = 2
        btn2.BorderColor3 = Color3.fromRGB(255, 255, 255)
        btn2.BorderMode = Enum.BorderMode.Inset
        Instance.new("UICorner", btn2).CornerRadius = UDim.new(0, 6)
        
        if colorName == currentSettings.color2 then
            btn2.BorderSizePixel = 4
        end
        
        selectedButtons2[colorName] = btn2
        
        btn2.MouseButton1Click:Connect(function()
            for name, button in pairs(selectedButtons2) do
                button.BorderSizePixel = 2
            end
            btn2.BorderSizePixel = 4
            currentSettings.color2 = colorName
            if currentSettings.gradientEnabled then
                applyColors()
            end
        end)
    end
    
    -- Gradient button functionality
    gradientButton.MouseButton1Click:Connect(function()
        currentSettings.gradientEnabled = not currentSettings.gradientEnabled
        if currentSettings.gradientEnabled then
            gradientButton.Text = "🎨 Gradient Mode: ON"
            gradientButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        else
            gradientButton.Text = "🎨 Gradient Mode: OFF"
            gradientButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        end
        applyColors()
    end)
end

-- Создание кнопок вкладок
local function clearContentZone()
    for _, child in ipairs(contentZone:GetChildren()) do
        if child ~= contentLayout and child ~= contentConstraint then
            if child:IsA("GuiObject") then child:Destroy() end
        end
    end
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton", tabPanel)
    btn.LayoutOrder = i
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    if i == #tabs then
        btn.Text = tab.icon .. " " .. tab.name
    else
        btn.Text = ""
    end
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.Position = UDim2.new(0, 0, 0, 0)
    
    -- Add tab button to the list for coloring
    table.insert(tabButtons, btn)

    btn.MouseButton1Click:Connect(function()
        clearContentZone()
        
        -- Если это вкладка Settings, создаем контент
        if tab.name == "Settings" then
            createSettingsContent()
        end
        
        contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- Инициализация
wait()
updateLayout()
contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
tabPanel.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
