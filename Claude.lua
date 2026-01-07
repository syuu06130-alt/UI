-- ===================================
-- Roblox 超高機能UIフレームワーク
-- LocalScript - StarterPlayer > StarterPlayerScripts に配置
-- ===================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===================================
-- 設定
-- ===================================
local CONFIG = {
	-- アニメーション設定
	ANIMATION_TIME = 0.3,
	DRAG_ANIMATION_TIME = 0.15,
	MINIMIZE_ANIMATION_TIME = 0.5,
	
	-- Easing設定
	DEFAULT_EASING = Enum.EasingStyle.Quint,
	DEFAULT_DIRECTION = Enum.EasingDirection.Out,
	MINIMIZE_EASING = Enum.EasingStyle.Back,
	
	-- ドラッグ設定
	DRAG_SCALE_MULTIPLIER = 1.05,
	DRAG_ROTATION = 2,
	DRAG_TRANSPARENCY = 0.1,
	DRAG_STROKE_THICKNESS = 4,
	DRAG_INERTIA_DAMPENING = 0.92,
	
	-- 最小化設定
	MINIMIZE_SCALE = 0.15,
	MINIMIZE_ICON_SIZE = UDim2.new(0, 60, 0, 60),
	
	-- 色設定
	PRIMARY_COLOR = Color3.fromRGB(88, 101, 242),
	SECONDARY_COLOR = Color3.fromRGB(114, 137, 218),
	ACCENT_COLOR = Color3.fromRGB(255, 115, 250),
	BACKGROUND_COLOR = Color3.fromRGB(32, 34, 37),
	HOVER_COLOR = Color3.fromRGB(64, 68, 75),
	ACTIVE_COLOR = Color3.fromRGB(255, 255, 255),
	
	-- 視覚効果
	SHADOW_TRANSPARENCY = 0.7,
	GLOW_TRANSPARENCY = 0.5,
	NEON_INTENSITY = 1.5,
}

-- ===================================
-- UIフレームワーククラス
-- ===================================
local UIFramework = {}
UIFramework.__index = UIFramework

function UIFramework.new(title, size, position)
	local self = setmetatable({}, UIFramework)
	
	self.title = title or "UI Window"
	self.size = size or UDim2.new(0, 400, 0, 300)
	self.position = position or UDim2.new(0.5, -200, 0.5, -150)
	self.isMinimized = false
	self.isDragging = false
	self.dragOffset = Vector2.new(0, 0)
	self.dragVelocity = Vector2.new(0, 0)
	self.originalSize = self.size
	self.originalPosition = self.position
	self.minimizeStyle = "scale" -- scale, fade, slide, rotate, fold
	
	self:CreateUI()
	self:SetupDragging()
	self:SetupMinimize()
	self:SetupAnimations()
	
	return self
end

-- ===================================
-- UI作成
-- ===================================
function UIFramework:CreateUI()
	-- ScreenGui
	self.screenGui = Instance.new("ScreenGui")
	self.screenGui.Name = "SuperUI_" .. self.title
	self.screenGui.ResetOnSpawn = false
	self.screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	-- 影レイヤー（疑似シャドウ）
	self.shadow = Instance.new("Frame")
	self.shadow.Name = "Shadow"
	self.shadow.Size = UDim2.new(1, 10, 1, 10)
	self.shadow.Position = UDim2.new(0, 5, 0, 5)
	self.shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	self.shadow.BackgroundTransparency = CONFIG.SHADOW_TRANSPARENCY
	self.shadow.BorderSizePixel = 0
	self.shadow.ZIndex = 1
	self.shadow.Parent = self.screenGui
	
	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 12)
	shadowCorner.Parent = self.shadow
	
	-- メインフレーム
	self.mainFrame = Instance.new("Frame")
	self.mainFrame.Name = "MainFrame"
	self.mainFrame.Size = self.size
	self.mainFrame.Position = self.position
	self.mainFrame.BackgroundColor3 = CONFIG.BACKGROUND_COLOR
	self.mainFrame.BorderSizePixel = 0
	self.mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	self.mainFrame.ZIndex = 2
	self.mainFrame.Parent = self.screenGui
	
	-- 角丸
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 12)
	mainCorner.Parent = self.mainFrame
	
	-- グラデーション背景
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, CONFIG.BACKGROUND_COLOR),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 42, 46))
	}
	gradient.Rotation = 45
	gradient.Parent = self.mainFrame
	
	-- 枠線
	self.stroke = Instance.new("UIStroke")
	self.stroke.Color = CONFIG.PRIMARY_COLOR
	self.stroke.Thickness = 2
	self.stroke.Transparency = 0.3
	self.stroke.Parent = self.mainFrame
	
	-- ヘッダー
	self.header = Instance.new("Frame")
	self.header.Name = "Header"
	self.header.Size = UDim2.new(1, 0, 0, 40)
	self.header.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
	self.header.BorderSizePixel = 0
	self.header.Parent = self.mainFrame
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 12)
	headerCorner.Parent = self.header
	
	-- ヘッダーグラデーション
	local headerGradient = Instance.new("UIGradient")
	headerGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, CONFIG.PRIMARY_COLOR),
		ColorSequenceKeypoint.new(1, CONFIG.SECONDARY_COLOR)
	}
	headerGradient.Rotation = 90
	headerGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.7),
		NumberSequenceKeypoint.new(1, 0.9)
	}
	headerGradient.Parent = self.header
	
	-- タイトルテキスト
	self.titleLabel = Instance.new("TextLabel")
	self.titleLabel.Name = "Title"
	self.titleLabel.Size = UDim2.new(1, -100, 1, 0)
	self.titleLabel.Position = UDim2.new(0, 15, 0, 0)
	self.titleLabel.BackgroundTransparency = 1
	self.titleLabel.Text = self.title
	self.titleLabel.TextColor3 = CONFIG.ACTIVE_COLOR
	self.titleLabel.TextSize = 18
	self.titleLabel.Font = Enum.Font.GothamBold
	self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	self.titleLabel.Parent = self.header
	
	-- 最小化ボタン
	self.minimizeButton = self:CreateButton("−", UDim2.new(1, -80, 0.5, 0), UDim2.new(0, 30, 0, 30))
	self.minimizeButton.Parent = self.header
	
	-- 閉じるボタン
	self.closeButton = self:CreateButton("✕", UDim2.new(1, -40, 0.5, 0), UDim2.new(0, 30, 0, 30))
	self.closeButton.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
	self.closeButton.Parent = self.header
	
	-- コンテンツエリア
	self.content = Instance.new("Frame")
	self.content.Name = "Content"
	self.content.Size = UDim2.new(1, -20, 1, -60)
	self.content.Position = UDim2.new(0, 10, 0, 50)
	self.content.BackgroundTransparency = 1
	self.content.Parent = self.mainFrame
	
	-- デモコンテンツ
	self:CreateDemoContent()
	
	self.screenGui.Parent = playerGui
end

-- ===================================
-- ボタン作成ヘルパー
-- ===================================
function UIFramework:CreateButton(text, position, size)
	local button = Instance.new("TextButton")
	button.Size = size
	button.Position = position
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.BackgroundColor3 = CONFIG.HOVER_COLOR
	button.BorderSizePixel = 0
	button.Text = text
	button.TextColor3 = CONFIG.ACTIVE_COLOR
	button.TextSize = 20
	button.Font = Enum.Font.GothamBold
	button.AutoButtonColor = false
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = button
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = CONFIG.PRIMARY_COLOR
	stroke.Thickness = 1
	stroke.Transparency = 0.5
	stroke.Parent = button
	
	-- ホバーエフェクト
	button.MouseEnter:Connect(function()
		self:AnimateButton(button, {
			BackgroundColor3 = CONFIG.PRIMARY_COLOR,
			Size = size + UDim2.new(0, 4, 0, 4)
		}, 0.15)
		stroke.Transparency = 0
	end)
	
	button.MouseLeave:Connect(function()
		self:AnimateButton(button, {
			BackgroundColor3 = CONFIG.HOVER_COLOR,
			Size = size
		}, 0.15)
		stroke.Transparency = 0.5
	end)
	
	-- 押下エフェクト
	button.MouseButton1Down:Connect(function()
		self:AnimateButton(button, {
			Size = size - UDim2.new(0, 2, 0, 2),
			BackgroundColor3 = CONFIG.SECONDARY_COLOR
		}, 0.05)
		self:CreateRipple(button)
	end)
	
	button.MouseButton1Up:Connect(function()
		self:AnimateButton(button, {
			Size = size + UDim2.new(0, 4, 0, 4),
			BackgroundColor3 = CONFIG.PRIMARY_COLOR
		}, 0.1)
	end)
	
	return button
end

-- ===================================
-- リップルエフェクト
-- ===================================
function UIFramework:CreateRipple(button)
	local ripple = Instance.new("Frame")
	ripple.Size = UDim2.new(0, 0, 0, 0)
	ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
	ripple.AnchorPoint = Vector2.new(0.5, 0.5)
	ripple.BackgroundColor3 = CONFIG.ACTIVE_COLOR
	ripple.BackgroundTransparency = 0.5
	ripple.BorderSizePixel = 0
	ripple.ZIndex = button.ZIndex + 1
	ripple.Parent = button
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = ripple
	
	local tween = TweenService:Create(ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(2, 0, 2, 0),
		BackgroundTransparency = 1
	})
	tween:Play()
	
	tween.Completed:Connect(function()
		ripple:Destroy()
	end)
end

-- ===================================
-- ドラッグ機能
-- ===================================
function UIFramework:SetupDragging()
	local dragStart = nil
	local startPos = nil
	local lastPos = Vector2.new(0, 0)
	
	self.header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self.isDragging = true
			dragStart = input.Position
			startPos = self.mainFrame.Position
			lastPos = Vector2.new(input.Position.X, input.Position.Y)
			
			-- ドラッグ開始エフェクト
			self:AnimateFrame(self.mainFrame, {
				Size = self.mainFrame.Size * CONFIG.DRAG_SCALE_MULTIPLIER,
				Rotation = CONFIG.DRAG_ROTATION
			}, CONFIG.DRAG_ANIMATION_TIME)
			
			self:AnimateFrame(self.stroke, {
				Thickness = CONFIG.DRAG_STROKE_THICKNESS,
				Transparency = 0,
				Color = CONFIG.ACCENT_COLOR
			}, CONFIG.DRAG_ANIMATION_TIME)
			
			self:AnimateFrame(self.shadow, {
				BackgroundTransparency = CONFIG.SHADOW_TRANSPARENCY - 0.2,
				Size = UDim2.new(1, 20, 1, 20)
			}, CONFIG.DRAG_ANIMATION_TIME)
		end
	end)
	
	UserInputService.InputChanged:Connect(function(input)
		if self.isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			local currentPos = Vector2.new(input.Position.X, input.Position.Y)
			self.dragVelocity = (currentPos - lastPos) * 0.5
			lastPos = currentPos
			
			self.mainFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
			
			-- 影も追従
			self.shadow.Position = UDim2.new(
				self.mainFrame.Position.X.Scale,
				self.mainFrame.Position.X.Offset + 5,
				self.mainFrame.Position.Y.Scale,
				self.mainFrame.Position.Y.Offset + 5
			)
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and self.isDragging then
			self.isDragging = false
			
			-- ドラッグ慣性
			if self.dragVelocity.Magnitude > 0 then
				self:ApplyInertia()
			end
			
			-- ドラッグ終了エフェクト
			self:AnimateFrame(self.mainFrame, {
				Size = self.originalSize,
				Rotation = 0
			}, CONFIG.ANIMATION_TIME)
			
			self:AnimateFrame(self.stroke, {
				Thickness = 2,
				Transparency = 0.3,
				Color = CONFIG.PRIMARY_COLOR
			}, CONFIG.ANIMATION_TIME)
			
			self:AnimateFrame(self.shadow, {
				BackgroundTransparency = CONFIG.SHADOW_TRANSPARENCY,
				Size = UDim2.new(1, 10, 1, 10)
			}, CONFIG.ANIMATION_TIME)
		end
	end)
end

-- ===================================
-- ドラッグ慣性
-- ===================================
function UIFramework:ApplyInertia()
	local connection
	connection = RunService.Heartbeat:Connect(function()
		if self.dragVelocity.Magnitude < 0.5 then
			connection:Disconnect()
			return
		end
		
		self.dragVelocity = self.dragVelocity * CONFIG.DRAG_INERTIA_DAMPENING
		
		local currentPos = self.mainFrame.Position
		self.mainFrame.Position = UDim2.new(
			currentPos.X.Scale,
			currentPos.X.Offset + self.dragVelocity.X,
			currentPos.Y.Scale,
			currentPos.Y.Offset + self.dragVelocity.Y
		)
		
		self.shadow.Position = UDim2.new(
			self.mainFrame.Position.X.Scale,
			self.mainFrame.Position.X.Offset + 5,
			self.mainFrame.Position.Y.Scale,
			self.mainFrame.Position.Y.Offset + 5
		)
	end)
end

-- ===================================
-- 最小化機能
-- ===================================
function UIFramework:SetupMinimize()
	self.minimizeButton.MouseButton1Click:Connect(function()
		if self.isMinimized then
			self:Maximize()
		else
			self:Minimize()
		end
	end)
	
	self.closeButton.MouseButton1Click:Connect(function()
		self:Close()
	end)
end

function UIFramework:Minimize()
	self.isMinimized = true
	
	-- 最小化スタイル別処理
	if self.minimizeStyle == "scale" then
		self:MinimizeScale()
	elseif self.minimizeStyle == "fade" then
		self:MinimizeFade()
	elseif self.minimizeStyle == "slide" then
		self:MinimizeSlide()
	elseif self.minimizeStyle == "rotate" then
		self:MinimizeRotate()
	elseif self.minimizeStyle == "fold" then
		self:MinimizeFold()
	end
	
	-- ボタンテキスト変更
	self.minimizeButton.Text = "□"
end

function UIFramework:MinimizeScale()
	local targetSize = UDim2.new(
		self.originalSize.X.Scale * CONFIG.MINIMIZE_SCALE,
		self.originalSize.X.Offset * CONFIG.MINIMIZE_SCALE,
		self.originalSize.Y.Scale * CONFIG.MINIMIZE_SCALE,
		self.originalSize.Y.Offset * CONFIG.MINIMIZE_SCALE
	)
	
	local targetPos = UDim2.new(0.9, 0, 0.9, 0)
	
	self:AnimateFrame(self.mainFrame, {
		Size = targetSize,
		Position = targetPos,
		Rotation = 360
	}, CONFIG.MINIMIZE_ANIMATION_TIME, CONFIG.MINIMIZE_EASING)
	
	self:AnimateFrame(self.content, {
		BackgroundTransparency = 1
	}, CONFIG.MINIMIZE_ANIMATION_TIME * 0.5)
	
	self:AnimateFrame(self.shadow, {
		BackgroundTransparency = 1
	}, CONFIG.MINIMIZE_ANIMATION_TIME)
	
	self:AnimateFrame(self.stroke, {
		Color = CONFIG.ACCENT_COLOR,
		Thickness = 3
	}, CONFIG.MINIMIZE_ANIMATION_TIME)
end

function UIFramework:MinimizeFade()
	local targetPos = UDim2.new(0.9, 0, 0.9, 0)
	
	self:AnimateFrame(self.mainFrame, {
		Position = targetPos,
		Size = CONFIG.MINIMIZE_ICON_SIZE,
		BackgroundTransparency = 0.5
	}, CONFIG.MINIMIZE_ANIMATION_TIME)
	
	self:AnimateFrame(self.content, {
		BackgroundTransparency = 1
	}, CONFIG.MINIMIZE_ANIMATION_TIME * 0.3)
end

function UIFramework:MinimizeSlide()
	local targetPos = UDim2.new(1.2, 0, 0.9, 0)
	
	self:AnimateFrame(self.mainFrame, {
		Position = targetPos,
		Rotation = 90
	}, CONFIG.MINIMIZE_ANIMATION_TIME, Enum.EasingStyle.Back)
end

function UIFramework:MinimizeRotate()
	self:AnimateFrame(self.mainFrame, {
		Rotation = 720,
		Size = CONFIG.MINIMIZE_ICON_SIZE,
		Position = UDim2.new(0.9, 0, 0.9, 0)
	}, CONFIG.MINIMIZE_ANIMATION_TIME * 1.5, Enum.EasingStyle.Exponential)
end

function UIFramework:MinimizeFold()
	-- 折りたたみ風アニメーション
	self:AnimateFrame(self.mainFrame, {
		Size = UDim2.new(self.originalSize.X.Scale, self.originalSize.X.Offset, 0, 40),
		Position = UDim2.new(0.5, 0, 0, 50)
	}, CONFIG.MINIMIZE_ANIMATION_TIME)
	
	self:AnimateFrame(self.content, {
		BackgroundTransparency = 1
	}, CONFIG.MINIMIZE_ANIMATION_TIME * 0.3)
end

function UIFramework:Maximize()
	self.isMinimized = false
	
	self:AnimateFrame(self.mainFrame, {
		Size = self.originalSize,
		Position = self.originalPosition,
		Rotation = 0,
		BackgroundTransparency = 0
	}, CONFIG.MINIMIZE_ANIMATION_TIME, CONFIG.MINIMIZE_EASING)
	
	task.wait(CONFIG.MINIMIZE_ANIMATION_TIME * 0.5)
	
	self:AnimateFrame(self.content, {
		BackgroundTransparency = 0
	}, CONFIG.MINIMIZE_ANIMATION_TIME * 0.5)
	
	self:AnimateFrame(self.shadow, {
		BackgroundTransparency = CONFIG.SHADOW_TRANSPARENCY
	}, CONFIG.MINIMIZE_ANIMATION_TIME)
	
	self:AnimateFrame(self.stroke, {
		Color = CONFIG.PRIMARY_COLOR,
		Thickness = 2
	}, CONFIG.MINIMIZE_ANIMATION_TIME)
	
	self.minimizeButton.Text = "−"
end

function UIFramework:Close()
	-- 閉じるアニメーション
	self:AnimateFrame(self.mainFrame, {
		Size = UDim2.new(0, 0, 0, 0),
		Rotation = 180,
		BackgroundTransparency = 1
	}, CONFIG.ANIMATION_TIME, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	
	self:AnimateFrame(self.shadow, {
		BackgroundTransparency = 1
	}, CONFIG.ANIMATION_TIME)
	
	task.wait(CONFIG.ANIMATION_TIME)
	self.screenGui:Destroy()
end

-- ===================================
-- アニメーションヘルパー
-- ===================================
function UIFramework:AnimateFrame(frame, properties, time, easing, direction)
	local tweenInfo = TweenInfo.new(
		time or CONFIG.ANIMATION_TIME,
		easing or CONFIG.DEFAULT_EASING,
		direction or CONFIG.DEFAULT_DIRECTION
	)
	local tween = TweenService:Create(frame, tweenInfo, properties)
	tween:Play()
	return tween
end

function UIFramework:AnimateButton(button, properties, time)
	local tweenInfo = TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tween = TweenService:Create(button, tweenInfo, properties)
	tween:Play()
	return tween
end

-- ===================================
-- 追加アニメーション効果
-- ===================================
function UIFramework:SetupAnimations()
	-- グラデーションアニメーション
	spawn(function()
		local gradient = self.mainFrame:FindFirstChildOfClass("UIGradient")
		if gradient then
			while self.mainFrame.Parent do
				self:AnimateFrame(gradient, {Rotation = 405}, 3, Enum.EasingStyle.Linear)
				task.wait(3)
				gradient.Rotation = 45
			end
		end
	end)
	
	-- ネオンパルス効果
	spawn(function()
		while self.mainFrame.Parent do
			self:AnimateFrame(self.stroke, {
				Transparency = 0
			}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1)
			self:AnimateFrame(self.stroke, {
				Transparency = 0.5
			}, 1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1)
		end
	end)
end

-- ===================================
-- デモコンテンツ
-- ===================================
function UIFramework:CreateDemoContent()
	local demoText = Instance.new("TextLabel")
	demoText.Size = UDim2.new(1, -20, 0, 100)
	demoText.Position = UDim2.new(0, 10, 0, 10)
	demoText.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
	demoText.BackgroundTransparency = 0.5
	demoText.BorderSizePixel = 0
	demoText.Text = "🎨 超高機能UIフレームワーク\n\nドラッグ・最小化・リップルエフェクト\nグラデーション・ネオンパルス対応"
	demoText.TextColor3 = CONFIG.ACTIVE_COLOR
	demoText.TextSize = 16
	demoText.Font = Enum.Font.Gotham
	demoText.TextWrapped = true
	demoText.Parent = self.content
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = demoText
	
	-- スタイル切替ボタン
	local styleButton = self:CreateButton("スタイル変更", UDim2.new(0.5, 0, 0, 150), UDim2.new(0, 150, 0, 40))
	styleButton.Parent = self.content
	
	local styles = {"scale", "fade", "slide", "rotate", "fold"}
	local currentStyleIndex = 1
	
	styleButton.MouseButton1Click:Connect(function()
		currentStyleIndex = currentStyleIndex % #styles + 1
		self.minimizeStyle = styles[currentStyleIndex]
		styleButton.Text = "スタイル: " .. self.minimizeStyle
	end)
end

-- ===================================
-- 実行
-- ===================================
-- 複数のUIウィンドウを作成
local ui1 = UIFramework.new("神ってるUI #1", UDim2.new(0, 400, 0, 300), UDim2.new(0.3, 0, 0.3, 0))
local ui2 = UIFramework.new("神ってるUI #2", UDim2.new(0, 350, 0, 250), UDim2.new(0.6, 0, 0.5, 0))
ui2.minimizeStyle = "rotate"

-- 出現アニメーション
ui1.mainFrame.Size = UDim2.new(0, 0, 0, 0)
ui1.mainFrame.Rotation = -180
ui1:AnimateFrame(ui1.mainFrame, {
	Size = ui1.originalSize,
	Rotation = 0
}, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

task.wait(0.2)

ui2.mainFrame.Size = UDim2.new(0, 0, 0, 0)
ui2.mainFrame.Rotation = 180
ui2:AnimateFrame(ui2.mainFrame, {
	Size = ui2.originalSize,
	Rotation = 0
}, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

print("✨ 超高機能UIフレームワーク ロード完了！")
