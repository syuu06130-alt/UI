----------------------------------------------------------------
-- GOD UI FRAMEWORK BASE
-- LocalScript / UI ONLY / EXTENSIBLE
----------------------------------------------------------------

--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Player
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

----------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------
local CONFIG = {
	MainColor = Color3.fromRGB(25,25,30),
	DragColor = Color3.fromRGB(45,45,65),
	AccentColor = Color3.fromRGB(120,120,255),
	MinimizeColor = Color3.fromRGB(255,200,90),
	AnimationSpeed = 0.35,
	CornerRadius = 18
}

----------------------------------------------------------------
-- UTILITY
----------------------------------------------------------------
local function Create(class, props)
	local obj = Instance.new(class)
	for k,v in pairs(props) do
		obj[k] = v
	end
	return obj
end

local function Tween(obj, time, style, direction, props)
	local info = TweenInfo.new(
		time or CONFIG.AnimationSpeed,
		style or Enum.EasingStyle.Quint,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(obj, info, props)
	tween:Play()
	return tween
end

----------------------------------------------------------------
-- SCREEN GUI
----------------------------------------------------------------
local ScreenGui = Create("ScreenGui", {
	Name = "GodUIFramework",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = PlayerGui
})

----------------------------------------------------------------
-- SHADOW
----------------------------------------------------------------
local Shadow = Create("Frame", {
	Name = "Shadow",
	Size = UDim2.fromScale(0.36,0.36),
	Position = UDim2.fromScale(0.51,0.52),
	AnchorPoint = Vector2.new(0.5,0.5),
	BackgroundColor3 = Color3.new(0,0,0),
	BackgroundTransparency = 0.65,
	ZIndex = 1,
	Parent = ScreenGui
})

Create("UICorner", {
	CornerRadius = UDim.new(0, CONFIG.CornerRadius + 4),
	Parent = Shadow
})

----------------------------------------------------------------
-- MAIN FRAME
----------------------------------------------------------------
local MainFrame = Create("Frame", {
	Name = "MainFrame",
	Size = UDim2.fromScale(0.35,0.35),
	Position = UDim2.fromScale(0.5,0.5),
	AnchorPoint = Vector2.new(0.5,0.5),
	BackgroundColor3 = CONFIG.MainColor,
	ZIndex = 2,
	Parent = ScreenGui
})

-- Corner
Create("UICorner", {
	CornerRadius = UDim.new(0, CONFIG.CornerRadius),
	Parent = MainFrame
})

-- Stroke
local Stroke = Create("UIStroke", {
	Color = CONFIG.AccentColor,
	Thickness = 1.5,
	Transparency = 0.35,
	Parent = MainFrame
})

-- Padding
Create("UIPadding", {
	PaddingTop = UDim.new(0,12),
	PaddingBottom = UDim.new(0,12),
	PaddingLeft = UDim.new(0,12),
	PaddingRight = UDim.new(0,12),
	Parent = MainFrame
})

-- Gradient
local Gradient = Create("UIGradient", {
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(60,60,120)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(25,25,35))
	},
	Rotation = 45,
	Parent = MainFrame
})

----------------------------------------------------------------
-- HEADER
----------------------------------------------------------------
local Header = Create("Frame", {
	Name = "Header",
	Size = UDim2.new(1,0,0,48),
	BackgroundTransparency = 1,
	Parent = MainFrame
})

local Title = Create("TextLabel", {
	Text = "GOD UI FRAMEWORK",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	TextXAlignment = Left,
	TextColor3 = Color3.new(1,1,1),
	BackgroundTransparency = 1,
	Size = UDim2.new(1,-80,1,0),
	Parent = Header
})

----------------------------------------------------------------
-- BUTTONS
----------------------------------------------------------------
local MinButton = Create("TextButton", {
	Name = "Minimize",
	Size = UDim2.fromOffset(32,32),
	Position = UDim2.new(1,-40,0,8),
	BackgroundColor3 = CONFIG.MinimizeColor,
	Text = "-",
	TextScaled = true,
	ZIndex = 3,
	Parent = Header
})

Create("UICorner", {
	CornerRadius = UDim.new(1,0),
	Parent = MinButton
})

----------------------------------------------------------------
-- DRAG SYSTEM
----------------------------------------------------------------
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		-- Drag Visuals
		Tween(MainFrame,0.2,nil,nil,{
			BackgroundColor3 = CONFIG.DragColor,
			Size = UDim2.fromScale(0.37,0.37)
		})
		Tween(Stroke,0.2,nil,nil,{
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

		Shadow.Position = MainFrame.Position + UDim2.fromOffset(8,8)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false

		-- Drag End
		Tween(MainFrame,0.3,Enum.EasingStyle.Back,nil,{
			BackgroundColor3 = CONFIG.MainColor,
			Size = UDim2.fromScale(0.35,0.35)
		})
		Tween(Stroke,0.3,nil,nil,{
			Thickness = 1.5,
			Transparency = 0.35
		})
	end
end)

----------------------------------------------------------------
-- MINIMIZE SYSTEM (BASE)
----------------------------------------------------------------
local minimized = false
local originalSize = MainFrame.Size

MinButton.MouseEnter:Connect(function()
	Tween(MinButton,0.15,nil,nil,{BackgroundColor3 = Color3.fromRGB(255,220,130)})
end)

MinButton.MouseLeave:Connect(function()
	Tween(MinButton,0.15,nil,nil,{BackgroundColor3 = CONFIG.MinimizeColor})
end)

MinButton.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		-- Scale + Fade minimize
		Tween(MainFrame,0.45,Enum.EasingStyle.Exponential,nil,{
			Size = UDim2.fromScale(0.12,0.08),
			BackgroundTransparency = 0.25
		})
		Tween(Shadow,0.45,nil,nil,{
			BackgroundTransparency = 1
		})
	else
		Tween(MainFrame,0.45,Enum.EasingStyle.Back,nil,{
			Size = originalSize,
			BackgroundTransparency = 0
		})
		Tween(Shadow,0.45,nil,nil,{
			BackgroundTransparency = 0.65
		})
	end
end)

----------------------------------------------------------------
-- APPEAR ANIMATION
----------------------------------------------------------------
MainFrame.BackgroundTransparency = 1
Shadow.BackgroundTransparency = 1

Tween(MainFrame,0.6,nil,nil,{BackgroundTransparency = 0})
Tween(Shadow,0.6,nil,nil,{BackgroundTransparency = 0.65})

----------------------------------------------------------------
-- PLACEHOLDER CONTENT (UI ONLY)
----------------------------------------------------------------
for i = 1,5 do
	local Item = Create("Frame",{
		Size = UDim2.new(1,0,0,40),
		BackgroundColor3 = Color3.fromRGB(40,40,55),
		BackgroundTransparency = 0.2,
		Parent = MainFrame
	})
	Create("UICorner",{CornerRadius = UDim.new(0,10),Parent = Item})
end
