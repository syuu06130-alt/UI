-- GodUI.lua
-- 超神Roblox UIモジュール（一部抜粋実装）

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HapticService = game:GetService("HapticService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- メインFrame（ドラッグ可能）
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(100, 100, 255)
uiStroke.Parent = mainFrame

local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 100)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 60))
}
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

-- HPに応じたグラデーション変化（例）
spawn(function()
	while wait(1) do
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local humanoid = player.Character.Humanoid
			local hpRatio = humanoid.Health / humanoid.MaxHealth
			local r = math.floor(255 * (1 - hpRatio))
			local g = math.floor(255 * hpRatio)
			uiGradient.Color = ColorSequence.new{
				ColorSequenceKeypoint.new(0, Color3.fromRGB(r, g, 100)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(r/2, g/2, 60))
			}
		end
	end
end)

-- ドラッグ機能（境界制限＋磁石スナップ）
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	local delta = input.Position - dragStart
	local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	
	-- 画面外不出（SafeArea考慮）
	local absSize = screenGui.AbsoluteSize
	newPos = UDim2.new(
		0,
		math.clamp(newPos.X.Offset, 0, absSize.X - mainFrame.AbsoluteSize.X),
		0,
		math.clamp(newPos.Y.Offset, 0, absSize.Y - mainFrame.AbsoluteSize.Y)
	)
	
	-- 磁石スナップ（画面端から20px以内）
	if newPos.X.Offset < 20 then newPos = UDim2.new(0, 0, newPos.Y.Scale, newPos.Y.Offset) end
	if newPos.X.Offset > absSize.X - mainFrame.AbsoluteSize.X - 20 then newPos = UDim2.new(1, -mainFrame.AbsoluteSize.X, newPos.Y.Scale, newPos.Y.Offset) end
	if newPos.Y.Offset < 20 then newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset, 0, 0) end
	if newPos.Y.Offset > absSize.Y - mainFrame.AbsoluteSize.Y - 20 then newPos = UDim2.new(newPos.X.Scale, newPos.X.Offset, 1, -mainFrame.AbsoluteSize.Y) end
	
	TweenService:Create(mainFrame, TweenInfo.new(0.15), {Position = newPos}):Play()
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		dragInput = input
		updateInput(input)
	end
end)

-- 神ボタン作成関数
local function createGodButton(text, position)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 200, 0, 60)
	button.Position = position
	button.Text = text
	button.TextSize = 24
	button.Font = Enum.Font.GothamBold
	button.TextColor3 = Color3.new(1,1,1)
	button.BackgroundColor3 = Color3.fromRGB(80, 80, 200)
	button.AutoButtonColor = false
	button.Parent = mainFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 10)
	btnCorner.Parent = button
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 2
	btnStroke.Color = Color3.fromRGB(120, 120, 255)
	btnStroke.Parent = button
	
	-- ホバー演出（拡大＋影）
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 220, 0, 66),
			BackgroundColor3 = Color3.fromRGB(100, 100, 255)
		}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.2), {Thickness = 4}):Play()
	end)
	
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = UDim2.new(0, 200, 0, 60),
			BackgroundColor3 = Color3.fromRGB(80, 80, 200)
		}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.2), {Thickness = 2}):Play()
	end)
	
	-- 波紋エフェクト
	local ripple = Instance.new("Frame")
	ripple.Size = UDim2.new(0, 0, 0, 0)
	ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
	ripple.BackgroundColor3 = Color3.new(1,1,1)
	ripple.BackgroundTransparency = 0.5
	ripple.ZIndex = button.ZIndex + 1
	ripple.Visible = false
	local rippleCorner = Instance.new("UICorner")
	rippleCorner.CornerRadius = UDim.new(1, 0)
	rippleCorner.Parent = ripple
	ripple.Parent = button
	
	button.MouseButton1Down:Connect(function(x, y)
		-- 振動フィードバック（モバイル）
		pcall(function()
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0.8)
			wait(0.1)
			HapticService:SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
		end)
		
		ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Visible = true
		ripple.BackgroundTransparency = 0.3
		
		TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, 300, 0, 300),
			Position = UDim2.new(0.5, -150, 0.5, -150),
			BackgroundTransparency = 1
		}):Play()
	end)
	
	return button
end

-- ボタン作成
local testButton = createGodButton("超神ボタン", UDim2.new(0.5, -100, 0.5, -30))

-- クリックアクション（例：ポップアップ）
testButton.MouseButton1Click:Connect(function()
	local popup = Instance.new("Frame")
	popup.Size = UDim2.new(0, 300, 0, 150)
	popup.Position = UDim2.new(0.5, -150, 1, 0) -- 下から登場
	popup.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	popup.Parent = screenGui
	
	local pCorner = Instance.new("UICorner")
	pCorner.CornerRadius = UDim.new(0, 15)
	pCorner.Parent = popup
	
	local pText = Instance.new("TextLabel")
	pText.Text = "✨ 神機能発動 ✨"
	pText.TextSize = 28
	pText.TextColor3 = Color3.new(1,1,1)
	pText.BackgroundTransparency = 1
	pText.Size = UDim2.new(1,0,1,0)
	pText.Parent = popup
	
	-- バウンスインアニメ
	TweenService:Create(popup, TweenInfo.new(0.8, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -150, 0.5, -75)
	}):Play()
	
	delay(2, function()
		TweenService:Create(popup, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
		TweenService:Create(pText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
		delay(0.4, function() popup:Destroy() end)
	end)
end)

print("GodUI loaded! ✨")
