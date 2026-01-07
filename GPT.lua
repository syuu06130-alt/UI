--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GodUI"
ScreenGui.IgnoreGuiInset = true -- SafeArea対応
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--// Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromScale(0.35, 0.35) -- 比率ベース
MainFrame.Position = UDim2.fromScale(0.5, 0.5)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.ZIndex = 5
MainFrame.Parent = ScreenGui

--// Corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 16)
Corner.Parent = MainFrame

--// Stroke
local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 1.5
Stroke.Color = Color3.fromRGB(120, 120, 255)
Stroke.Transparency = 0.4
Stroke.Parent = MainFrame

--// Shadow (疑似)
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.fromScale(1,1)
Shadow.Position = UDim2.fromScale(0.02,0.02)
Shadow.BackgroundColor3 = Color3.new(0,0,0)
Shadow.BackgroundTransparency = 0.7
Shadow.ZIndex = 4
Shadow.Parent = ScreenGui

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 18)
ShadowCorner.Parent = Shadow

--// Gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(60,60,120)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,40))
}
Gradient.Parent = MainFrame

--// Minimize Button
local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.fromOffset(36,36)
MinButton.Position = UDim2.fromScale(1,-0.05)
MinButton.AnchorPoint = Vector2.new(1,0)
MinButton.Text = "-"
MinButton.TextScaled = true
MinButton.BackgroundColor3 = Color3.fromRGB(255,200,80)
MinButton.Parent = MainFrame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1,0)
MinCorner.Parent = MinButton

--// Drag System
local dragging = false
local dragStart, startPos

local function Tween(obj, info, props)
	local t = TweenService:Create(obj, info, props)
	t:Play()
	return t
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		-- Drag Start Effects
		Tween(MainFrame, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(40,40,60),
			Size = UDim2.fromScale(0.37,0.37)
		})
		Tween(Stroke, TweenInfo.new(0.2), {
			Thickness = 3,
			Transparency = 0
		})
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false

		-- Drag End Animation
		Tween(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(25,25,30),
			Size = UDim2.fromScale(0.35,0.35)
		})
		Tween(Stroke, TweenInfo.new(0.25), {
			Thickness = 1.5,
			Transparency = 0.4
		})
	end
end)

--// Minimize System
local minimized = false
local originalSize = MainFrame.Size

MinButton.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {
			Size = UDim2.fromScale(0.1,0.08),
			BackgroundTransparency = 0.3
		})
		Tween(Stroke, TweenInfo.new(0.4), {
			Transparency = 1
		})
	else
		Tween(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
			Size = originalSize,
			BackgroundTransparency = 0
		})
		Tween(Stroke, TweenInfo.new(0.4), {
			Transparency = 0.4
		})
	end
end)

--// UI Appear Animation
MainFrame.BackgroundTransparency = 1
Tween(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {
	BackgroundTransparency = 0
})
