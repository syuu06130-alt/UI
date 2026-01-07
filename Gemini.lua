-- Roblox LocalScript: Advanced UI Framework (Visual & Experience Focused)
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- 1. 基本構造の生成
--------------------------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedFramework"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui

-- 装飾要素
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(60, 60, 80)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainFrame

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

-- 最小化ボタン
local minButton = Instance.new("TextButton")
minButton.Name = "MinimizeButton"
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -40, 0, 10)
minButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minButton.Text = "-"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.AutoButtonColor = false
minButton.Parent = mainFrame
Instance.new("UICorner", minButton).CornerRadius = UDim.new(1, 0)

--------------------------------------------------------------------------------
-- 2. ドラッグ制御ロジック（演出付き）
--------------------------------------------------------------------------------
local dragging, dragInput, dragStart, startPos
local isMinimized = false

local function updateDrag(input)
	local delta = input.Position - dragStart
	local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	
	-- スムーズな追従
	TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {Position = targetPos}):Play()
end

mainFrame.InputBegan:Connect(function(input)
	if isMinimized then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		-- ドラッグ開始時の演出
		TweenService:Create(mainFrame, TweenInfo.new(0.3), {
			Rotation = 2,
			GroupTransparency = 0.2,
			Size = UDim2.new(0, 310, 0, 410)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.3), {Thickness = 4, Color = Color3.fromRGB(100, 150, 255)}):Play()

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				-- 終了時の復元演出
				TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {
					Rotation = 0,
					GroupTransparency = 0,
					Size = UDim2.new(0, 300, 0, 400)
				}):Play()
				TweenService:Create(stroke, TweenInfo.new(0.3), {Thickness = 2, Color = Color3.fromRGB(60, 60, 80)}):Play()
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		updateDrag(input)
	end
end)

--------------------------------------------------------------------------------
-- 3. 最小化・最大化システム（複合アニメーション）
--------------------------------------------------------------------------------
local function toggleMinimize()
	isMinimized = not isMinimized
	
	local targetSize = isMinimized and UDim2.new(0, 40, 0, 40) or UDim2.new(0, 300, 0, 400)
	local targetTransparency = isMinimized and 0.8 or 0
	local targetRotation = isMinimized and 180 or 0
	
	local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
	
	local tween = TweenService:Create(mainFrame, tweenInfo, {
		Size = targetSize,
		Rotation = targetRotation
	})
	
	-- 内部要素を最小化時に隠す
	for _, child in pairs(mainFrame:GetChildren()) do
		if child:IsA("GuiObject") and child ~= minButton then
			child.Visible = not isMinimized
		end
	end
	
	tween:Play()
end

minButton.MouseButton1Click:Connect(toggleMinimize)

-- ホバー演出（ボタン）
minButton.MouseEnter:Connect(function()
	TweenService:Create(minButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100), Size = UDim2.new(0, 35, 0, 35)}):Play()
end)

minButton.MouseLeave:Connect(function()
	TweenService:Create(minButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50), Size = UDim2.new(0, 30, 0, 30)}):Play()
end)

print("Advanced UI Framework Loaded.")
