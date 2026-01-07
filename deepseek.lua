-- UIフレームワーク
-- 作成者: AI Assistant
-- 場所: LocalScript (StarterGui or StarterPlayerScripts)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 設定
local UI_CONFIG = {
    DRAG_SENSITIVITY = 1.2,
    MINIMIZE_ANIMATION_DURATION = 0.3,
    MAXIMIZE_ANIMATION_DURATION = 0.3,
    DRAG_ANIMATION_DURATION = 0.15,
    SNAP_THRESHOLD = 20,
    INERTIA_DECAY = 0.9,
    SAFE_AREA_PADDING = 10,
    RESPONSIVE_BREAKPOINTS = {
        MOBILE = 500,
        TABLET = 800
    }
}

-- UI管理クラス
local UIManager = {}
UIManager.__index = UIManager
UIManager.Instances = {}

function UIManager.new(name)
    local self = setmetatable({}, UIManager)
    self.Name = name or "UI_" .. tick()
    self.ScreenGui = nil
    self.MainFrame = nil
    self.IsDragging = false
    self.IsMinimized = false
    self.DragStartPosition = nil
    self.FrameStartPosition = nil
    self.DragVelocity = Vector2.new(0, 0)
    self.LastDragPosition = nil
    self.LastDragTime = nil
    self.MinimizeType = "scale"
    self.OriginalSize = nil
    self.OriginalPosition = nil
    self.OriginalProperties = {}
    self.ActiveTweens = {}
    self.Events = {}
    
    table.insert(UIManager.Instances, self)
    return self
end

-- 基本UI作成
function UIManager:CreateBaseUI()
    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = self.Name
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.DisplayOrder = 10
    self.ScreenGui.Parent = playerGui
    
    -- メインフレーム
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    self.MainFrame.BackgroundTransparency = 0.1
    self.MainFrame.BorderSizePixel = 0
    
    -- 角丸
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = self.MainFrame
    
    -- 枠線
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 150, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = self.MainFrame
    
    -- パディング
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 8)
    padding.PaddingLeft = UDim.new(0, 8)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = self.MainFrame
    
    -- グラデーション
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 45))
    })
    gradient.Rotation = 45
    gradient.Parent = self.MainFrame
    
    -- タイトルバー
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Parent = self.MainFrame
    
    -- タイトルバー角丸
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- タイトルテキスト
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    self.TitleText.Position = UDim2.new(0, 10, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = self.Name
    self.TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleText.TextSize = 18
    self.TitleText.Font = Enum.Font.GothamBold
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Parent = self.TitleBar
    
    -- コントロールボタンコンテナ
    self.ControlButtons = Instance.new("Frame")
    self.ControlButtons.Name = "ControlButtons"
    self.ControlButtons.Size = UDim2.new(0.3, 0, 1, 0)
    self.ControlButtons.Position = UDim2.new(0.7, 0, 0, 0)
    self.ControlButtons.BackgroundTransparency = 1
    self.ControlButtons.Parent = self.TitleBar
    
    -- 最小化ボタン
    self.MinimizeButton = self:CreateButton("MinimizeButton", UDim2.new(0, 30, 0, 30), UDim2.new(0, 5, 0.5, -15), "−")
    self.MinimizeButton.Parent = self.ControlButtons
    self.MinimizeButton.ZIndex = 5
    
    -- 閉じるボタン
    self.CloseButton = self:CreateButton("CloseButton", UDim2.new(0, 30, 0, 30), UDim2.new(0, 40, 0.5, -15), "×")
    self.CloseButton.Parent = self.ControlButtons
    self.CloseButton.ZIndex = 5
    
    -- コンテンツフレーム
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "ContentFrame"
    self.ContentFrame.Size = UDim2.new(1, -16, 1, -56)
    self.ContentFrame.Position = UDim2.new(0, 8, 0, 48)
    self.ContentFrame.BackgroundTransparency = 1
    self.ContentFrame.Parent = self.MainFrame
    
    -- 最小化時のアイコン
    self.MinimizedIcon = Instance.new("ImageButton")
    self.MinimizedIcon.Name = "MinimizedIcon"
    self.MinimizedIcon.Size = UDim2.new(0, 60, 0, 60)
    self.MinimizedIcon.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    self.MinimizedIcon.BackgroundTransparency = 0.2
    self.MinimizedIcon.Image = ""
    self.MinimizedIcon.Visible = false
    self.MinimizedIcon.ZIndex = 20
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 8)
    iconCorner.Parent = self.MinimizedIcon
    
    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = Color3.fromRGB(100, 150, 255)
    iconStroke.Thickness = 1
    iconStroke.Parent = self.MinimizedIcon
    
    self.MinimizedIcon.Parent = self.ScreenGui
    
    -- 元のプロパティを保存
    self.OriginalSize = self.MainFrame.Size
    self.OriginalPosition = self.MainFrame.Position
    self.OriginalProperties.BackgroundTransparency = self.MainFrame.BackgroundTransparency
    self.OriginalProperties.UIStrokeThickness = stroke.Thickness
    self.OriginalProperties.UIStrokeColor = stroke.Color
    
    self.MainFrame.Parent = self.ScreenGui
    
    return self
end

-- ボタン作成ヘルパー関数
function UIManager:CreateButton(name, size, position, text)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    button.BackgroundTransparency = 0.2
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 20
    button.Font = Enum.Font.GothamBold
    button.AutoButtonColor = false
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 150, 255)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = button
    
    -- ホバーエフェクト
    self:AddButtonEffects(button)
    
    return button
end

-- ボタンエフェクト追加
function UIManager:AddButtonEffects(button)
    local originalSize = button.Size
    local originalBackgroundColor = button.BackgroundColor3
    local originalStrokeThickness = button.UIStroke.Thickness
    
    -- マウスエンター
    button.MouseEnter:Connect(function()
        self:CancelTween(button, "Hover")
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goals = {
            BackgroundColor3 = Color3.fromRGB(80, 120, 220),
            BackgroundTransparency = 0.1
        }
        
        local tween = TweenService:Create(button, tweenInfo, goals)
        tween:Play()
        self.ActiveTweens[button] = self.ActiveTweens[button] or {}
        self.ActiveTweens[button]["Hover"] = tween
    end)
    
    -- マウスリーブ
    button.MouseLeave:Connect(function()
        self:CancelTween(button, "Hover")
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goals = {
            BackgroundColor3 = originalBackgroundColor,
            BackgroundTransparency = 0.2
        }
        
        local tween = TweenService:Create(button, tweenInfo, goals)
        tween:Play()
        self.ActiveTweens[button] = self.ActiveTweens[button] or {}
        self.ActiveTweens[button]["Hover"] = tween
    end)
    
    -- マウスダウン
    button.MouseButton1Down:Connect(function()
        self:CancelTween(button, "Press")
        
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local goals = {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset * 0.9, 
                            originalSize.Y.Scale, originalSize.Y.Offset * 0.9),
            BackgroundColor3 = Color3.fromRGB(100, 150, 255)
        }
        
        local tween = TweenService:Create(button, tweenInfo, goals)
        tween:Play()
        self.ActiveTweens[button] = self.ActiveTweens[button] or {}
        self.ActiveTweens[button]["Press"] = tween
    end)
    
    -- マウスアップ
    button.MouseButton1Up:Connect(function()
        self:CancelTween(button, "Press")
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
        local goals = {
            Size = originalSize,
            BackgroundColor3 = Color3.fromRGB(80, 120, 220)
        }
        
        local tween = TweenService:Create(button, tweenInfo, goals)
        tween:Play()
        self.ActiveTweens[button] = self.ActiveTweens[button] or {}
        self.ActiveTweens[button]["Press"] = tween
    end)
end

-- ドラッグ機能設定
function UIManager:MakeDraggable()
    local frame = self.MainFrame
    local dragInput, dragStart, startPos
    
    -- ドラッグ開始
    local function onDragStart(input)
        if not self.IsMinimized then
            self.IsDragging = true
            self.DragStartPosition = input.Position
            self.FrameStartPosition = frame.Position
            self.LastDragPosition = input.Position
            self.LastDragTime = tick()
            self.DragVelocity = Vector2.new(0, 0)
            
            -- ドラッグ開始エフェクト
            self:ApplyDragEffects(true)
            
            -- ドラッグ開始SE（オプション）
            -- self:PlaySound("DragStart")
        end
    end
    
    -- ドラッグ中
    local function onDrag(input)
        if self.IsDragging and not self.IsMinimized then
            local delta = input.Position - self.DragStartPosition
            local newPosition = UDim2.new(
                self.FrameStartPosition.X.Scale,
                self.FrameStartPosition.X.Offset + delta.X,
                self.FrameStartPosition.Y.Scale,
                self.FrameStartPosition.Y.Offset + delta.Y
            )
            
            -- 画面内制限
            newPosition = self:ApplyDragConstraints(newPosition)
            frame.Position = newPosition
            
            -- 速度計算
            local currentTime = tick()
            local deltaTime = currentTime - self.LastDragTime
            
            if deltaTime > 0 then
                local deltaPos = input.Position - self.LastDragPosition
                self.DragVelocity = deltaPos / deltaTime
            end
            
            self.LastDragPosition = input.Position
            self.LastDragTime = currentTime
        end
    end
    
    -- ドラッグ終了
    local function onDragEnd(input)
        if self.IsDragging then
            self.IsDragging = false
            
            -- ドラッグ終了エフェクト
            self:ApplyDragEffects(false)
            
            -- 慣性効果
            if self.DragVelocity.Magnitude > 10 then
                self:ApplyInertia()
            end
            
            -- スナップ効果
            self:ApplySnapToEdges()
            
            -- ドラッグ終了SE（オプション）
            -- self:PlaySound("DragEnd")
        end
    end
    
    -- 入力接続
    self.Events.DragStarted = self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            onDragStart(input)
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    onDragEnd(input)
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    self.Events.DragChanged = self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or 
           input.UserInputType == Enum.UserInputType.Touch then
            onDrag(input)
        end
    end)
    
    -- グローバル入力監視
    self.Events.GlobalInputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            onDragEnd(input)
        end
    end)
end

-- ドラッグ制限適用
function UIManager:ApplyDragConstraints(position)
    local frame = self.MainFrame
    local absoluteSize = frame.AbsoluteSize
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    -- 画面内に収める
    local minX = 0
    local maxX = viewportSize.X - absoluteSize.X
    local minY = 0
    local maxY = viewportSize.Y - absoluteSize.Y
    
    -- SafeArea対応（モバイル向け）
    local safeMinX = UI_CONFIG.SAFE_AREA_PADDING
    local safeMaxX = viewportSize.X - absoluteSize.X - UI_CONFIG.SAFE_AREA_PADDING
    local safeMinY = UI_CONFIG.SAFE_AREA_PADDING
    local safeMaxY = viewportSize.Y - absoluteSize.Y - UI_CONFIG.SAFE_AREA_PADDING
    
    -- SafeAreaが適用可能な場合
    if safeMaxX > safeMinX and safeMaxY > safeMinY then
        minX, maxX = safeMinX, safeMaxX
        minY, maxY = safeMinY, safeMaxY
    end
    
    -- 位置を制限
    local offsetX = math.clamp(position.X.Offset, minX, maxX)
    local offsetY = math.clamp(position.Y.Offset, minY, maxY)
    
    return UDim2.new(position.X.Scale, offsetX, position.Y.Scale, offsetY)
end

-- ドラッグエフェクト適用
function UIManager:ApplyDragEffects(isDragging)
    local frame = self.MainFrame
    local stroke = frame:FindFirstChildOfClass("UIStroke")
    local gradient = frame:FindFirstChildOfClass("UIGradient")
    
    self:CancelTween(frame, "DragEffect")
    
    local tweenInfo = TweenInfo.new(
        UI_CONFIG.DRAG_ANIMATION_DURATION,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local goals = {}
    
    if isDragging then
        -- ドラッグ中の視覚変化
        goals.BackgroundTransparency = 0.05
        goals.Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset * 1.02,
                              frame.Size.Y.Scale, frame.Size.Y.Offset * 1.02)
        
        if stroke then
            goals.UIStrokeThickness = 4
            goals.UIStrokeColor = Color3.fromRGB(150, 200, 255)
            goals.UIStrokeTransparency = 0.1
        end
        
        -- 影効果（疑似）
        if gradient then
            goals.UIGradientRotation = 90
        end
    else
        -- 通常状態に戻す
        goals.BackgroundTransparency = self.OriginalProperties.BackgroundTransparency or 0.1
        goals.Size = self.OriginalSize
        
        if stroke then
            goals.UIStrokeThickness = self.OriginalProperties.UIStrokeThickness or 2
            goals.UIStrokeColor = self.OriginalProperties.UIStrokeColor or Color3.fromRGB(100, 150, 255)
            goals.UIStrokeTransparency = 0.3
        end
        
        if gradient then
            goals.UIGradientRotation = 45
        end
    end
    
    -- 複数プロパティのトゥイーン
    for goalName, goalValue in pairs(goals) do
        if goalName == "UIStrokeThickness" and stroke then
            local tween = TweenService:Create(stroke, tweenInfo, {Thickness = goalValue})
            tween:Play()
        elseif goalName == "UIStrokeColor" and stroke then
            local tween = TweenService:Create(stroke, tweenInfo, {Color = goalValue})
            tween:Play()
        elseif goalName == "UIStrokeTransparency" and stroke then
            local tween = TweenService:Create(stroke, tweenInfo, {Transparency = goalValue})
            tween:Play()
        elseif goalName == "UIGradientRotation" and gradient then
            local tween = TweenService:Create(gradient, tweenInfo, {Rotation = goalValue})
            tween:Play()
        else
            -- フレームのプロパティ
            local tween = TweenService:Create(frame, tweenInfo, {[goalName] = goalValue})
            tween:Play()
        end
    end
end

-- 慣性効果
function UIManager:ApplyInertia()
    local frame = self.MainFrame
    local velocity = self.DragVelocity * UI_CONFIG.DRAG_SENSITIVITY
    
    -- 慣性減衰
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        velocity = velocity * UI_CONFIG.INERTIA_DECAY
        
        if velocity.Magnitude < 1 then
            connection:Disconnect()
            return
        end
        
        local currentPos = frame.Position
        local newPos = UDim2.new(
            currentPos.X.Scale,
            currentPos.X.Offset + velocity.X * dt,
            currentPos.Y.Scale,
            currentPos.Y.Offset + velocity.Y * dt
        )
        
        newPos = self:ApplyDragConstraints(newPos)
        frame.Position = newPos
    end)
    
    table.insert(self.Events, connection)
end

-- 端スナップ
function UIManager:ApplySnapToEdges()
    local frame = self.MainFrame
    local position = frame.Position
    local absoluteSize = frame.AbsoluteSize
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    local edges = {
        left = {position = 0, current = position.X.Offset},
        top = {position = 0, current = position.Y.Offset},
        right = {position = viewportSize.X - absoluteSize.X, current = position.X.Offset},
        bottom = {position = viewportSize.Y - absoluteSize.Y, current = position.Y.Offset}
    }
    
    local snapThreshold = UI_CONFIG.SNAP_THRESHOLD
    local snapTo = nil
    
    -- 最も近い端を検出
    for edgeName, edgeData in pairs(edges) do
        if math.abs(edgeData.current - edgeData.position) < snapThreshold then
            snapTo = edgeName
            break
        end
    end
    
    if snapTo then
        local targetPosition
        if snapTo == "left" then
            targetPosition = UDim2.new(0, edges.left.position, position.Y.Scale, position.Y.Offset)
        elseif snapTo == "top" then
            targetPosition = UDim2.new(position.X.Scale, position.X.Offset, 0, edges.top.position)
        elseif snapTo == "right" then
            targetPosition = UDim2.new(0, edges.right.position, position.Y.Scale, position.Y.Offset)
        elseif snapTo == "bottom" then
            targetPosition = UDim2.new(position.X.Scale, position.X.Offset, 0, edges.bottom.position)
        end
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(frame, tweenInfo, {Position = targetPosition})
        tween:Play()
    end
end

-- 最小化機能
function UIManager:SetupMinimize()
    self.MinimizeButton.MouseButton1Click:Connect(function()
        if self.IsMinimized then
            self:Maximize()
        else
            self:Minimize()
        end
    end)
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    -- 最小化アイコンクリックで最大化
    self.MinimizedIcon.MouseButton1Click:Connect(function()
        if self.IsMinimized then
            self:Maximize()
        end
    end)
end

-- 最小化実行
function UIManager:Minimize(minimizeType)
    if self.IsMinimized then return end
    
    self.IsMinimized = true
    self.MinimizeType = minimizeType or self.MinimizeType
    
    -- 全てのアクティブなトゥイーンをキャンセル
    self:CancelAllActiveTweens()
    
    -- 最小化タイプに応じたアニメーション
    if self.MinimizeType == "scale" then
        self:MinimizeScale()
    elseif self.MinimizeType == "fade" then
        self:MinimizeFade()
    elseif self.MinimizeType == "slide" then
        self:MinimizeSlide()
    elseif self.MinimizeType == "rotate" then
        self:MinimizeRotate()
    elseif self.MinimizeType == "fold" then
        self:MinimizeFold()
    elseif self.MinimizeType == "icon" then
        self:MinimizeToIcon()
    else
        self:MinimizeScale() -- デフォルト
    end
    
    -- 最小化SE（オプション）
    -- self:PlaySound("Minimize")
end

-- 最大化実行
function UIManager:Maximize()
    if not self.IsMinimized then return end
    
    self.IsMinimized = false
    
    -- 全てのアクティブなトゥイーンをキャンセル
    self:CancelAllActiveTweens()
    
    -- 最小化アイコンを非表示
    if self.MinimizeType == "icon" then
        self.MinimizedIcon.Visible = false
    end
    
    -- 最大化アニメーション
    local frame = self.MainFrame
    frame.Visible = true
    
    local tweenInfo = TweenInfo.new(
        UI_CONFIG.MAXIMIZE_ANIMATION_DURATION,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    
    local goals = {
        Size = self.OriginalSize,
        Position = self.OriginalPosition,
        BackgroundTransparency = self.OriginalProperties.BackgroundTransparency or 0.1,
        Rotation = 0
    }
    
    local tween = TweenService:Create(frame, tweenInfo, goals)
    tween:Play()
    
    -- UIStrokeも戻す
    local stroke = frame:FindFirstChildOfClass("UIStroke")
    if stroke then
        local strokeTweenInfo = TweenInfo.new(
            UI_CONFIG.MAXIMIZE_ANIMATION_DURATION,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )
        
        local strokeGoals = {
            Thickness = self.OriginalProperties.UIStrokeThickness or 2,
            Color = self.OriginalProperties.UIStrokeColor or Color3.fromRGB(100, 150, 255),
            Transparency = 0.3
        }
        
        local strokeTween = TweenService:Create(stroke, strokeTweenInfo, strokeGoals)
        strokeTween:Play()
    end
    
    -- 最大化SE（オプション）
    -- self:PlaySound("Maximize")
end

-- スケール最小化
function UIManager:MinimizeScale()
    local frame = self.MainFrame
    
    local tweenInfo = TweenInfo.new(
        UI_CONFIG.MINIMIZE_ANIMATION_DURATION,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )
    
    local goals = {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }
    
    local tween = TweenService:Create(frame, tweenInfo, goals)
    tween:Play()
    
    tween.Completed:Connect(function()
        frame.Visible = false
    end)
end

-- フェード最小化
function UIManager:MinimizeFade()
    local frame = self.MainFrame
    
    local tweenInfo = TweenInfo.new(
        UI_CONFIG.MINIMIZE_ANIMATION_DURATION,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local goals = {
        BackgroundTransparency = 1
    }
    
    local tween = TweenService:Create(frame, tweenInfo, goals)
    tween:Play()
    
    -- 子要素もフェードアウト
    for _, child in ipairs(frame:GetDescendants()) do
        if child:IsA("GuiObject") then
            local childTween = TweenService:Create(child, tweenInfo, {BackgroundTransparency = 1})
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                childTween = TweenService:Create(child, tweenInfo, {TextTransparency = 1})
            end
            childTween:Play()
        end
    end
    
    tween.Completed:Connect(function()
        frame.Visible = false
    end)
end

-- スライド最小化
function UIManager:MinimizeSlide()
    local frame = self.MainFrame
    local viewportSize = workspace.CurrentCamera.ViewportSize
    
    local tweenInfo = TweenInfo.new(
        UI_CONFIG.MINIMIZE_ANIMATION_DURATION,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )
    
    local goals = {
        Position = UDim2.new(0, -frame.AbsoluteSize.X, frame.Position.Y.Scale, frame.Position.Y.Offset)
    }
    
    local tween = TweenService:Create(frame, tweenInfo, goals)
    tween:Play()
    
    tween.Completed:Connect(function()
        frame.Visible = false
    end)
end

-- 回転最小化
function UIManager:MinimizeRotate()
    local frame = self.MainFrame
    
    local tweenInfo = TweenInfo.new(
        UI_CONFIG.MINIMIZE_ANIMATION_DURATION,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )
    
    local goals = {
        Rotation = 180,
        Size = UDim2.new(0, 0, 0, 0)
    }
    
    local tween = TweenService:Create(frame, tweenInfo, goals)
    tween:Play()
    
    tween.Completed:Connect(function()
        frame.Visible = false
    end)
end

-- 折りたたみ最小化
function UIManager:MinimizeFold()
    local frame = self.MainFrame
    
    local tweenInfo1 = TweenInfo.new(
        UI_CONFIG.MINIMIZE_ANIMATION_DURATION / 2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    
    local tweenInfo2 = TweenInfo.new(
        UI_CONFIG.MINIMIZE_ANIMATION_DURATION / 2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    )
    
    -- まず高さを縮める
    local goals1 = {
        Size = UDim2.new(frame.Size.X.Scale, frame.Size.X.Offset, 0, 40)
    }
    
    local tween1 = TweenService:Create(frame, tweenInfo1, goals1)
    tween1:Play()
    
    tween1.Completed:Connect(function()
        -- 次に幅を縮める
        local goals2 = {
            Size = UDim2.new(0, 0, 0, 40),
            BackgroundTransparency = 1
        }
        
        local tween2 = TweenService:Create(frame, tweenInfo2, goals2)
        tween2:Play()
        
        tween2.Completed:Connect(function()
            frame.Visible = false
        end)
    end)
end

-- アイコン化最小化
function UIManager:MinimizeToIcon()
    local frame = self.MainFrame
    
    -- 最小化アイコンの位置を設定
    self.MinimizedIcon.Position = UDim2.new(
        0, frame.AbsolutePosition.X,
        0, frame.AbsolutePosition.Y
    )
    
    self.MinimizedIcon.Visible = true
    
    -- アイコンにUIのスクリーンショットを設定（実際の実装ではより高度な処理が必要）
    self.MinimizedIcon.Text = self.Name:sub(1, 3)
    
    local tweenInfo = TweenInfo.new(
        UI_CONFIG.MINIMIZE_ANIMATION_DURATION,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )
    
    -- フレームを縮小してアイコンの位置に移動
    local goals = {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, frame.AbsolutePosition.X, 0, frame.AbsolutePosition.Y),
        BackgroundTransparency = 1
    }
    
    local tween = TweenService:Create(frame, tweenInfo, goals)
    tween:Play()
    
    tween.Completed:Connect(function()
        frame.Visible = false
    end)
end

-- 閉じる
function UIManager:Close()
    -- 閉じるアニメーション
    local frame = self.MainFrame
    
    local tweenInfo = TweenInfo.new(
        0.3,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    )
    
    local goals = {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Rotation = 45
    }
    
    local tween = TweenService:Create(frame, tweenInfo, goals)
    tween:Play()
    
    tween.Completed:Connect(function()
        self:Destroy()
    end)
    
    -- 閉じるSE（オプション）
    -- self:PlaySound("Close")
end

-- トゥイーンキャンセル
function UIManager:CancelTween(object, key)
    if self.ActiveTweens[object] and self.ActiveTweens[object][key] then
        self.ActiveTweens[object][key]:Cancel()
        self.ActiveTweens[object][key] = nil
    end
end

function UIManager:CancelAllActiveTweens()
    for object, tweens in pairs(self.ActiveTweens) do
        for key, tween in pairs(tweens) do
            tween:Cancel()
        end
    end
    self.ActiveTweens = {}
end

-- サウンド再生（オプション）
function UIManager:PlaySound(soundName)
    -- サウンド実装例
    -- local sound = Instance.new("Sound")
    -- sound.SoundId = "rbxassetid://" .. SOUND_IDS[soundName]
    -- sound.Parent = SoundService
    -- sound:Play()
    -- game:GetService("Debris"):AddItem(sound, 3)
end

-- レスポンシブUI対応
function UIManager:SetupResponsive()
    local camera = workspace.CurrentCamera
    
    local function updateResponsive()
        local viewportSize = camera.ViewportSize
        
        if viewportSize.X <= UI_CONFIG.RESPONSIVE_BREAKPOINTS.MOBILE then
            -- モバイル向けサイズ
            self.MainFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
        elseif viewportSize.X <= UI_CONFIG.RESPONSIVE_BREAKPOINTS.TABLET then
            -- タブレット向けサイズ
            self.MainFrame.Size = UDim2.new(0.8, 0, 0.6, 0)
        else
            -- デスクトップ向けサイズ
            self.MainFrame.Size = self.OriginalSize
        end
        
        -- 中央揃え
        self.MainFrame.Position = UDim2.new(0.5, -self.MainFrame.AbsoluteSize.X/2, 
                                           0.5, -self.MainFrame.AbsoluteSize.Y/2)
    end
    
    -- 初期設定
    updateResponsive()
    
    -- 画面サイズ変更時に更新
    self.Events.ViewportSizeChanged = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateResponsive)
end

-- 破棄
function UIManager:Destroy()
    -- イベント切断
    for _, connection in pairs(self.Events) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    
    -- トゥイーンキャンセル
    self:CancelAllActiveTweens()
    
    -- UI削除
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
    
    -- インスタンスリストから削除
    for i, instance in ipairs(UIManager.Instances) do
        if instance == self then
            table.remove(UIManager.Instances, i)
            break
        end
    end
end

-- 視覚効果：パルスアニメーション
function UIManager:AddPulseEffect(object, interval, minTransparency, maxTransparency)
    local originalTransparency = object.BackgroundTransparency
    
    local pulseConnection
    local isPulsing = true
    local time = 0
    
    pulseConnection = RunService.Heartbeat:Connect(function(dt)
        if not isPulsing then
            pulseConnection:Disconnect()
            return
        end
        
        time = time + dt
        local sine = math.sin(time * math.pi * 2 / interval)
        local transparency = minTransparency + (maxTransparency - minTransparency) * (sine + 1) / 2
        
        if object:IsA("GuiObject") then
            object.BackgroundTransparency = transparency
        end
    end)
    
    table.insert(self.Events, pulseConnection)
    
    return function()
        isPulsing = false
        if object:IsA("GuiObject") then
            object.BackgroundTransparency = originalTransparency
        end
    end
end

-- 視覚効果：グロー効果
function UIManager:AddGlowEffect(object, color, intensity)
    local glow = Instance.new("UIStroke")
    glow.Name = "GlowEffect"
    glow.Color = color or Color3.fromRGB(255, 255, 255)
    glow.Thickness = 3
    glow.Transparency = 0.7
    glow.Parent = object
    
    -- パルスするグロー
    self:AddPulseEffect(glow, 1.5, 0.5, 0.9)
    
    return glow
end

-- 公開API
function UIManager:SetTitle(title)
    if self.TitleText then
        self.TitleText.Text = title
    end
end

function UIManager:SetSize(size)
    self.OriginalSize = size
    self.MainFrame.Size = size
end

function UIManager:SetPosition(position)
    self.OriginalPosition = position
    self.MainFrame.Position = position
end

function UIManager:GetContentFrame()
    return self.ContentFrame
end

function UIManager:SetVisible(visible)
    self.ScreenGui.Enabled = visible
end

function UIManager:IsVisible()
    return self.ScreenGui.Enabled
end

-- フレームワーク初期化関数
local function createAdvancedUI(name)
    local ui = UIManager.new(name)
    ui:CreateBaseUI()
    ui:MakeDraggable()
    ui:SetupMinimize()
    ui:SetupResponsive()
    
    -- サンプルコンテンツ追加
    local contentFrame = ui:GetContentFrame()
    
    local sampleText = Instance.new("TextLabel")
    sampleText.Size = UDim2.new(1, 0, 0, 40)
    sampleText.Position = UDim2.new(0, 0, 0, 0)
    sampleText.BackgroundTransparency = 1
    sampleText.Text = "高度なUIフレームワーク"
    sampleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    sampleText.TextSize = 20
    sampleText.Font = Enum.Font.GothamBold
    sampleText.Parent = contentFrame
    
    local sampleButton = ui:CreateButton("SampleButton", UDim2.new(0, 200, 0, 50), UDim2.new(0.5, -100, 0.5, -25), "クリック！")
    sampleButton.Parent = contentFrame
    
    -- パルス効果をサンプルボタンに追加
    ui:AddPulseEffect(sampleButton, 2, 0.2, 0.5)
    
    -- グロー効果をタイトルに追加
    ui:AddGlowEffect(ui.TitleText, Color3.fromRGB(100, 200, 255))
    
    return ui
end

-- 使用例
local advancedUI = createAdvancedUI("Advanced UI Framework")

-- 最小化タイプ切り替え例（開発用）
local function setupMinimizeTypeSelector(ui)
    local selectorFrame = Instance.new("Frame")
    selectorFrame.Size = UDim2.new(1, 0, 0, 30)
    selectorFrame.Position = UDim2.new(0, 0, 1, 5)
    selectorFrame.BackgroundTransparency = 1
    selectorFrame.Parent = ui.ContentFrame
    
    local types = {"scale", "fade", "slide", "rotate", "fold", "icon"}
    local buttonWidth = 1 / #types
    
    for i, minType in ipairs(types) do
        local button = ui:CreateButton(minType, 
            UDim2.new(buttonWidth, -5, 1, 0), 
            UDim2.new((i-1) * buttonWidth, 2, 0, 0), 
            minType:sub(1, 1):upper())
        button.TextSize = 12
        button.Parent = selectorFrame
        
        button.MouseButton1Click:Connect(function()
            ui:Minimize(minType)
        end)
    end
end

-- セレクターを追加（開発用）
setupMinimizeTypeSelector(advancedUI)

-- グローバルアクセス用（オプション）
return {
    UIManager = UIManager,
    createAdvancedUI = createAdvancedUI
}
