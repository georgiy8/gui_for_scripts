local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local zoneGap, titleHeight, bottomHeight = 10, 40, 20
local tabPanelWidth = 120

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
    { name = "Settings", icon = "⚙️" }, -- новая вкладка последняя
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

-- Функция обновления размеров и позиций зон (использует AbsoluteSize и RunService.Heartbeat:Wait())
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

-- Кнопки управления окном (максимизация/восстановление/закрыть)
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

-- Создание кнопок вкладок (растягиваются по ширине); только последняя показывает текст
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

    btn.MouseButton1Click:Connect(function()
        clearContentZone()
        contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
    end)
end

-- Инициализация layout после создания всех элементов
wait()
updateLayout()
contentZone.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
tabPanel.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
