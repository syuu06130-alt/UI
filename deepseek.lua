-- 超神関数数式: UI System Module
-- ファイル名: UIGodFunctions.lua (ModuleScript)

local UIGodFunctions = {}
UIGodFunctions.__index = UIGodFunctions

-- サービス
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local HapticService = game:GetService("HapticService")
local ContentProvider = game:GetService("ContentProvider")

-- 設定
local DEFAULT_TWEEN_INFO = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local SAFE_AREA_OFFSET = 0.05
local MOBILE_BUTTON_SIZE = 50
local MIN_TOUCH_SIZE = 44 -- 最小タッチサイズ

-- 色定数
local COLOR = {
    PRIMARY = Color3.fromRGB(0, 120, 215),
    SECONDARY = Color3.fromRGB(100, 100, 100),
    SUCCESS = Color3.fromRGB(46, 204, 113),
    ERROR = Color3.fromRGB(231, 76, 60),
    WARNING = Color3.fromRGB(241, 196, 15),
    INFO = Color3.fromRGB(52, 152, 219),
    DARK = Color3.fromRGB(30, 30, 30),
    LIGHT = Color3.fromRGB(245, 245, 245)
}

--[[
    ① 画面構成・レイアウト
]]--
function UIGodFunctions.createScreenGui(name, parent)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name
    screenGui.Parent = parent or Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.DisplayOrder = 10
    screenGui.ResetOnSpawn = false
    
    -- SafeArea対応
    if RunService:IsStudio() == false then
        screenGui.SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension
    end
    
    return screenGui
end

function UIGodFunctions.createMainFrame(screenGui, size, position)
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = size or UDim2.new(1, 0, 1, 0)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = COLOR.DARK
    frame.BackgroundTransparency = 0.1
    frame.Parent = screenGui
    
    -- UI装飾
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = frame
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = COLOR.PRIMARY
    uiStroke.Thickness = 2
    uiStroke.Parent = frame
    
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 10)
    uiPadding.PaddingRight = UDim.new(0, 10)
    uiPadding.PaddingTop = UDim.new(0, 10)
    uiPadding.PaddingBottom = UDim.new(0, 10)
    uiPadding.Parent = frame
    
    -- 解像度対応
    local uiScale = Instance.new("UIScale")
    uiScale.Parent = frame
    
    -- アスペクト比制約
    local aspectRatio = Instance.new("UIAspectRatioConstraint")
    aspectRatio.AspectRatio = 1.777 -- 16:9
    aspectRatio.DominantAxis = Enum.DominantAxis.Width
    aspectRatio.Parent = frame
    
    -- ZIndex管理用
    frame:SetAttribute("ZIndex", 1)
    
    return frame
end

function UIGodFunctions.applySafeArea(frame)
    if UserInputService.TouchEnabled then
        local safeArea = GuiService:GetSafeAreaInsets()
        
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.Size = UDim2.new(
            1 - safeArea.X * 2,
            -safeArea.X * 2,
            1 - safeArea.Y * 2,
            -safeArea.Y * 2
        )
    end
end

--[[
    ② ナビゲーション系
]]--
function UIGodFunctions.createNavigationBar(parent, tabs)
    local navBar = Instance.new("Frame")
    navBar.Name = "NavigationBar"
    navBar.Size = UDim2.new(1, 0, 0, 60)
    navBar.BackgroundTransparency = 1
    navBar.Parent = parent
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.FillDirection = Enum.FillDirection.Horizontal
    uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.Parent = navBar
    
    -- タブ作成
    local tabButtons = {}
    for i, tabData in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabData.name .. "Tab"
        tabButton.Size = UserInputService.TouchEnabled and UDim2.new(0, MOBILE_BUTTON_SIZE, 0, MOBILE_BUTTON_SIZE) or UDim2.new(0, 100, 0, 40)
        tabButton.Text = tabData.text or tabData.name
        tabButton.BackgroundColor3 = i == 1 and COLOR.PRIMARY or COLOR.SECONDARY
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Font = Enum.Font.GothamSemibold
        tabButton.Parent = navBar
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 8)
        uiCorner.Parent = tabButton
        
        tabButton.MouseButton1Click:Connect(function()
            UIGodFunctions.selectTab(tabButtons, tabButton, tabData.callback)
        end)
        
        table.insert(tabButtons, {button = tabButton, data = tabData})
    end
    
    return navBar, tabButtons
end

function UIGodFunctions.selectTab(allTabs, selectedTab, callback)
    for _, tab in ipairs(allTabs) do
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(tab.button, tweenInfo, {
            BackgroundColor3 = (tab.button == selectedTab) and COLOR.PRIMARY or COLOR.SECONDARY
        })
        tween:Play()
    end
    
    if callback then
        callback()
    end
end

--[[
    ③ 操作・入力
]]--
function UIGodFunctions.createButton(parent, config)
    local button = Instance.new(config.image and "ImageButton" or "TextButton")
    button.Name = config.name or "Button"
    button.Size = config.size or UDim2.new(0, 100, 0, 40)
    button.Position = config.position or UDim2.new(0, 0, 0, 0)
    button.BackgroundColor3 = config.bgColor or COLOR.PRIMARY
    button.AutoButtonColor = config.autoButtonColor ~= false
    
    if config.image then
        button.Image = config.image
        button.ScaleType = config.scaleType or Enum.ScaleType.Stretch
    else
        button.Text = config.text or "Button"
        button.TextColor3 = config.textColor or Color3.new(1, 1, 1)
        button.Font = config.font or Enum.Font.GothamSemibold
        button.TextSize = config.textSize or 14
    end
    
    -- 基本装飾
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = config.cornerRadius or UDim.new(0, 8)
    uiCorner.Parent = button
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = config.strokeColor or Color3.new(1, 1, 1)
    uiStroke.Thickness = config.strokeThickness or 1
    uiStroke.Parent = button
    
    -- ホバーエフェクト
    local originalColor = button.BackgroundColor3
    local hoverColor = config.hoverColor or Color3.fromRGB(
        math.min(255, originalColor.R * 255 * 1.2),
        math.min(255, originalColor.G * 255 * 1.2),
        math.min(255, originalColor.B * 255 * 1.2)
    )
    
    button.MouseEnter:Connect(function()
        if config.disabled then return end
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = hoverColor,
            Size = button.Size + UDim2.new(0, 4, 0, 4)
        })
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = originalColor,
            Size = button.Size - UDim2.new(0, 4, 0, 4)
        })
        tween:Play()
    end)
    
    -- クリックエフェクト
    button.MouseButton1Down:Connect(function()
        if config.disabled then return end
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.5,
            Size = button.Size - UDim2.new(0, 2, 0, 2)
        })
        tween:Play()
        
        -- 振動フィードバック
        if HapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) then
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0.5)
            task.wait(0.1)
            HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.1), {
            BackgroundTransparency = 0,
            Size = button.Size + UDim2.new(0, 2, 0, 2)
        })
        tween:Play()
    end)
    
    -- クリックコールバック
    if config.onClick then
        button.MouseButton1Click:Connect(function()
            if config.disabled then return end
            config.onClick(button)
        end)
    end
    
    -- ショートカットキー
    if config.hotkey then
        ContextActionService:BindAction(config.name .. "Hotkey", function(actionName, inputState)
            if inputState == Enum.UserInputState.Begin and config.onClick then
                config.onClick(button)
            end
        end, false, config.hotkey)
    end
    
    button.Parent = parent
    return button
end

function UIGodFunctions.createSlider(parent, config)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = config.name or "Slider"
    sliderFrame.Size = config.size or UDim2.new(0.8, 0, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 6)
    track.Position = UDim2.new(0, 0, 0.5, -3)
    track.BackgroundColor3 = COLOR.SECONDARY
    track.Parent = sliderFrame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new((config.value or 0.5), 0, 1, 0)
    fill.BackgroundColor3 = config.fillColor or COLOR.PRIMARY
    fill.Parent = track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, 20, 0, 20)
    thumb.Position = UDim2.new((config.value or 0.5), -10, 0.5, -10)
    thumb.BackgroundColor3 = Color3.new(1, 1, 1)
    thumb.Parent = sliderFrame
    
    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(1, 0)
    thumbCorner.Parent = thumb
    
    local valueText = Instance.new("TextLabel")
    valueText.Name = "ValueText"
    valueText.Size = UDim2.new(0, 50, 0, 20)
    valueText.Position = UDim2.new(0.5, -25, 0, -25)
    valueText.Text = string.format("%.0f%%", (config.value or 0.5) * 100)
    valueText.TextColor3 = Color3.new(1, 1, 1)
    valueText.BackgroundTransparency = 1
    valueText.Font = Enum.Font.Gotham
    valueText.TextSize = 14
    valueText.Parent = sliderFrame
    
    -- ドラッグ機能
    local isDragging = false
    
    local function updateSlider(input)
        local absolutePosition = track.AbsolutePosition.X
        local absoluteSize = track.AbsoluteSize.X
        
        local relativeX = math.clamp((input.Position.X - absolutePosition) / absoluteSize, 0, 1)
        
        fill.Size = UDim2.new(relativeX, 0, 1, 0)
        thumb.Position = UDim2.new(relativeX, -10, 0.5, -10)
        valueText.Text = string.format("%.0f%%", relativeX * 100)
        
        if config.onChange then
            config.onChange(relativeX)
        end
    end
    
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            local tween = TweenService:Create(thumb, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 24, 0, 24)
            })
            tween:Play()
        end
    end)
    
    thumb.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            local tween = TweenService:Create(thumb, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 20, 0, 20)
            })
            tween:Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                           input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return sliderFrame
end

--[[
    ④ フィードバック・状態
]]--
function UIGodFunctions.showLoading(parent, message)
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(1, 0, 1, 0)
    loadingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    loadingFrame.BackgroundTransparency = 0.5
    loadingFrame.ZIndex = 100
    loadingFrame.Parent = parent
    
    local spinner = Instance.new("Frame")
    spinner.Size = UDim2.new(0, 60, 0, 60)
    spinner.Position = UDim2.new(0.5, -30, 0.5, -30)
    spinner.BackgroundTransparency = 1
    spinner.Parent = loadingFrame
    
    local rotateValue = Instance.new("NumberValue")
    rotateValue.Value = 0
    
    local connection = RunService.RenderStepped:Connect(function(deltaTime)
        rotateValue.Value = (rotateValue.Value + deltaTime * 360) % 360
        spinner.Rotation = rotateValue.Value
    end)
    
    -- 回転アニメーション用パーツ
    for i = 1, 8 do
        local part = Instance.new("Frame")
        part.Size = UDim2.new(0, 8, 0, 20)
        part.Position = UDim2.new(0.5, -4, 0, 10)
        part.BackgroundColor3 = COLOR.PRIMARY
        part.AnchorPoint = Vector2.new(0.5, 0)
        part.Rotation = (i - 1) * 45
        part.Parent = spinner
        
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 4)
        uiCorner.Parent = part
    end
    
    if message then
        local messageLabel = Instance.new("TextLabel")
        messageLabel.Size = UDim2.new(1, 0, 0, 30)
        messageLabel.Position = UDim2.new(0, 0, 0.6, 0)
        messageLabel.Text = message
        messageLabel.TextColor3 = Color3.new(1, 1, 1)
        messageLabel.BackgroundTransparency = 1
        messageLabel.Font = Enum.Font.Gotham
        messageLabel.TextSize = 16
        messageLabel.Parent = loadingFrame
    end
    
    return loadingFrame, function()
        connection:Disconnect()
        loadingFrame:Destroy()
    end
end

function UIGodFunctions.showPopup(parent, config)
    local popup = Instance.new("Frame")
    popup.Name = "Popup"
    popup.Size = config.size or UDim2.new(0, 300, 0, 200)
    popup.Position = UDim2.new(0.5, -150, 0.5, -100)
    popup.BackgroundColor3 = COLOR.DARK
    popup.ZIndex = 90
    popup.Parent = parent
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 12)
    uiCorner.Parent = popup
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = config.type == "error" and COLOR.ERROR or 
                    config.type == "warning" and COLOR.WARNING or 
                    config.type == "success" and COLOR.SUCCESS or
                    COLOR.PRIMARY
    uiStroke.Thickness = 3
    uiStroke.Parent = popup
    
    -- タイトル
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.Text = config.title or "通知"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = popup
    
    -- メッセージ
    local message = Instance.new("TextLabel")
    message.Size = UDim2.new(1, -20, 1, -120)
    message.Position = UDim2.new(0, 10, 0, 60)
    message.Text = config.message or ""
    message.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    message.BackgroundTransparency = 1
    message.Font = Enum.Font.Gotham
    message.TextSize = 14
    message.TextWrapped = true
    message.Parent = popup
    
    -- ボタン
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, 0, 0, 50)
    buttonFrame.Position = UDim2.new(0, 0, 1, -50)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = popup
    
    local okButton = UIGodFunctions.createButton(buttonFrame, {
        name = "OKButton",
        text = config.buttonText or "OK",
        size = UDim2.new(0.4, 0, 0.8, 0),
        position = UDim2.new(0.5, -70, 0.1, 0),
        onClick = function()
            if config.onConfirm then
                config.onConfirm()
            end
            UIGodFunctions.hideWithAnimation(popup)
        end
    })
    
    if config.showCancel then
        local cancelButton = UIGodFunctions.createButton(buttonFrame, {
            name = "CancelButton",
            text = "キャンセル",
            size = UDim2.new(0.4, 0, 0.8, 0),
            position = UDim2.new(0.05, 0, 0.1, 0),
            bgColor = COLOR.SECONDARY,
            onClick = function()
                if config.onCancel then
                    config.onCancel()
                end
                UIGodFunctions.hideWithAnimation(popup)
            end
        })
    end
    
    -- 表示アニメーション
    popup.Size = UDim2.new(0, 10, 0, 10)
    popup.Position = UDim2.new(0.5, -5, 0.5, -5)
    
    local showTween = TweenService:Create(popup, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = config.size or UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, -150, 0.5, -100)
    })
    showTween:Play()
    
    return popup
end

--[[
    ⑤ 情報表示
]]--
function UIGodFunctions.createStatusBar(parent, config)
    local barFrame = Instance.new("Frame")
    barFrame.Name = config.name or "StatusBar"
    barFrame.Size = config.size or UDim2.new(1, 0, 0, 30)
    barFrame.BackgroundColor3 = config.bgColor or Color3.fromRGB(50, 50, 50)
    barFrame.Parent = parent
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = barFrame
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(config.value or 1, 0, 1, 0)
    fill.BackgroundColor3 = config.fillColor or COLOR.PRIMARY
    fill.Parent = barFrame
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill
    
    -- グラデーションエフェクト
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, fill.BackgroundColor3),
        ColorSequenceKeypoint.new(1, Color3.new(
            math.min(1, fill.BackgroundColor3.R * 1.3),
            math.min(1, fill.BackgroundColor3.G * 1.3),
            math.min(1, fill.BackgroundColor3.B * 1.3)
        ))
    })
    gradient.Rotation = 90
    gradient.Parent = fill
    
    -- テキスト表示
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = config.text or string.format("%.0f/%.0f", (config.value or 1) * (config.max or 100), config.max or 100)
    textLabel.TextColor3 = config.textColor or Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.Parent = barFrame
    
    -- 更新関数
    function barFrame:Update(value, maxValue)
        local newSize = math.clamp(value / (maxValue or 100), 0, 1)
        local tween = TweenService:Create(fill, TweenInfo.new(0.5), {
            Size = UDim2.new(newSize, 0, 1, 0)
        })
        tween:Play()
        
        textLabel.Text = config.text or string.format("%.0f/%.0f", value, maxValue or 100)
    end
    
    -- アニメーション（脈動）
    if config.animate then
        local pulseConnection
        pulseConnection = RunService.Heartbeat:Connect(function()
            local time = tick()
            local pulse = math.sin(time * 3) * 0.1 + 1
            fill.Size = UDim2.new((config.value or 1) * pulse, 0, 1, 0)
        end)
        
        -- クリーンアップ用
        barFrame:SetAttribute("PulseConnection", pulseConnection)
    end
    
    return barFrame
end

--[[
    ⑥ 特有必須機能
]]--
function UIGodFunctions.createViewportFrame(parent, model, size)
    local viewportFrame = Instance.new("ViewportFrame")
    viewportFrame.Size = size or UDim2.new(0, 200, 0, 200)
    viewportFrame.BackgroundTransparency = 1
    viewportFrame.Parent = parent
    
    if model then
        local modelClone = model:Clone()
        modelClone.Parent = viewportFrame
        
        -- カメラ設定
        local camera = Instance.new("Camera")
        camera.CFrame = CFrame.new(Vector3.new(0, 0, 5), Vector3.new(0, 0, 0))
        camera.Parent = viewportFrame
        viewportFrame.CurrentCamera = camera
        
        -- モデルを中央に配置
        local boundingBox = modelClone:GetBoundingBox()
        local size = boundingBox.Size
        local center = boundingBox.CFrame.Position
        
        camera.CFrame = CFrame.new(center + Vector3.new(0, 0, size.Magnitude * 2), center)
    end
    
    return viewportFrame
end

function UIGodFunctions.manageZIndex(uiObject, baseZIndex)
    local function updateChildrenZIndex(object, offset)
        if object:IsA("GuiObject") then
            object.ZIndex = baseZIndex + offset
        end
        
        for _, child in ipairs(object:GetChildren()) do
            updateChildrenZIndex(child, offset + 1)
        end
    end
    
    updateChildrenZIndex(uiObject, 0)
end

--[[
    ⑦ 見た目・演出（神機能）
]]--
function UIGodFunctions.applyRippleEffect(button)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.new(1, 1, 1)
    ripple.BackgroundTransparency = 0.5
    ripple.Parent = button
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = ripple
    
    local tween1 = TweenService:Create(ripple, TweenInfo.new(0.5), {
        Size = UDim2.new(2, 0, 2, 0),
        BackgroundTransparency = 1
    })
    
    tween1:Play()
    tween1.Completed:Connect(function()
        ripple:Destroy()
    end)
end

function UIGodFunctions.createDynamicGradientBackground(parent)
    local gradientFrame = Instance.new("Frame")
    gradientFrame.Size = UDim2.new(1, 0, 1, 0)
    gradientFrame.BackgroundTransparency = 0
    gradientFrame.Parent = parent
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHSV(tick() % 5 / 5, 0.7, 0.5)),
        ColorSequenceKeypoint.new(0.5, Color3.fromHSV((tick() + 1) % 5 / 5, 0.7, 0.6)),
        ColorSequenceKeypoint.new(1, Color3.fromHSV((tick() + 2) % 5 / 5, 0.7, 0.5))
    })
    gradient.Rotation = 45
    gradient.Parent = gradientFrame
    
    -- アニメーション
    local connection = RunService.Heartbeat:Connect(function()
        local time = tick()
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(time % 5 / 5, 0.7, 0.5)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV((time + 1) % 5 / 5, 0.7, 0.6)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV((time + 2) % 5 / 5, 0.7, 0.5))
        })
    end)
    
    gradientFrame:SetAttribute("Connection", connection)
    
    return gradientFrame
end

--[[
    ⑧ 操作性・快適さ
]]--
function UIGodFunctions.makeDraggable(gui, handle)
    handle = handle or gui
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

function UIGodFunctions.saveUIPosition(gui, saveKey)
    local dataStore = game:GetService("DataStoreService"):GetDataStore("UIPositions")
    
    -- 保存
    gui:GetPropertyChangedSignal("Position"):Connect(function()
        task.defer(function()
            local success, err = pcall(function()
                dataStore:SetAsync(saveKey, {
                    ScaleX = gui.Position.X.Scale,
                    OffsetX = gui.Position.X.Offset,
                    ScaleY = gui.Position.Y.Scale,
                    OffsetY = gui.Position.Y.Offset
                })
            end)
        end)
    end)
    
    -- 読み込み
    task.spawn(function()
        local success, data = pcall(function()
            return dataStore:GetAsync(saveKey)
        end)
        
        if success and data then
            gui.Position = UDim2.new(
                data.ScaleX or 0,
                data.OffsetX or 0,
                data.ScaleY or 0,
                data.OffsetY or 0
            )
        end
    end)
end

--[[
    ⑨ 賢いUI
]]--
function UIGodFunctions.createSmartTooltip(parent, target, content)
    local tooltip = Instance.new("Frame")
    tooltip.Name = "Tooltip"
    tooltip.Size = UDim2.new(0, 200, 0, 100)
    tooltip.BackgroundColor3 = COLOR.DARK
    tooltip.BackgroundTransparency = 0.1
    tooltip.Visible = false
    tooltip.ZIndex = 1000
    tooltip.Parent = parent
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = tooltip
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = COLOR.PRIMARY
    uiStroke.Thickness = 2
    uiStroke.Parent = tooltip
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.Text = content
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.TextWrapped = true
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextSize = 12
    textLabel.Parent = tooltip
    
    -- 表示/非表示
    local showConnection, hideConnection
    
    local function showTooltip()
        tooltip.Visible = true
        
        -- マウス位置に追従
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        tooltip.Position = UDim2.new(
            0, mouse.X + 20,
            0, mouse.Y + 20
        )
    end
    
    local function hideTooltip()
        tooltip.Visible = false
    end
    
    if target:IsA("GuiObject") then
        showConnection = target.MouseEnter:Connect(showTooltip)
        hideConnection = target.MouseLeave:Connect(hideTooltip)
    end
    
    -- クリーンアップ関数
    return tooltip, function()
        if showConnection then showConnection:Disconnect() end
        if hideConnection then hideConnection:Disconnect() end
        tooltip:Destroy()
    end
end

--[[
    ユーティリティ関数
]]--
function UIGodFunctions.hideWithAnimation(guiObject)
    local tween = TweenService:Create(guiObject, TweenInfo.new(0.3), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, -5, 0.5, -5)
    })
    
    tween:Play()
    tween.Completed:Connect(function()
        if guiObject and guiObject.Parent then
            guiObject:Destroy()
        end
    end)
end

function UIGodFunctions.detectInputDevice()
    if UserInputService.TouchEnabled then
        return "Mobile"
    elseif UserInputService.GamepadEnabled then
        return "Gamepad"
    elseif UserInputService.KeyboardEnabled then
        return "Keyboard"
    else
        return "Unknown"
    end
end

function UIGodFunctions.adaptForMobile(guiObject)
    if UserInputService.TouchEnabled then
        -- 最小タッチサイズを確保
        if guiObject:IsA("GuiButton") then
            local currentSize = guiObject.AbsoluteSize
            if currentSize.X < MIN_TOUCH_SIZE or currentSize.Y < MIN_TOUCH_SIZE then
                local scaleX = math.max(MIN_TOUCH_SIZE / currentSize.X, 1)
                local scaleY = math.max(MIN_TOUCH_SIZE / currentSize.Y, 1)
                guiObject.Size = UDim2.new(
                    guiObject.Size.X.Scale * scaleX,
                    guiObject.Size.X.Offset * scaleX,
                    guiObject.Size.Y.Scale * scaleY,
                    guiObject.Size.Y.Offset * scaleY
                )
            end
        end
        
        -- パディング追加
        local uiPadding = Instance.new("UIPadding")
        uiPadding.PaddingBottom = UDim.new(0, 5)
        uiPadding.PaddingTop = UDim.new(0, 5)
        uiPadding.PaddingLeft = UDim.new(0, 5)
        uiPadding.PaddingRight = UDim.new(0, 5)
        uiPadding.Parent = guiObject
    end
end

--[[
    初期化関数
]]--
function UIGodFunctions.init(player)
    -- グローバルUIスタイル設定
    local style = {
        Font = Enum.Font.Gotham,
        TextSize = 14,
        ButtonColor = COLOR.PRIMARY,
        BackgroundColor = COLOR.DARK,
        TextColor = Color3.new(1, 1, 1)
    }
    
    -- 入力デバイスに応じた設定
    local device = UIGodFunctions.detectInputDevice()
    print("Input device detected:", device)
    
    -- カメラ固定中でもUI操作可能にする
    if player then
        player.CameraMode = Enum.CameraMode.Classic
    end
    
    return {
        Style = style,
        Device = device,
        Version = "1.0.0",
        Author = "超神関数数式"
    }
end

return UIGodFunctions
