--------------------------------------------------------------------
-- GOD UI FRAMEWORK : EXTREME LONG BASE
-- Author : You
-- Type   : LocalScript
-- Scope  : UI ONLY (NO GAME LOGIC)
-- Goal   : 神ってるUIの土台・拡張前提・演出全振り
--------------------------------------------------------------------

-------------------------
-- SERVICES
-------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

-------------------------
-- PLAYER
-------------------------
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-------------------------
-- CONFIG TABLE
-------------------------
local CONFIG = {
	Colors = {
		Main = Color3.fromRGB(24,24,32),
		Drag = Color3.fromRGB(45,45,70),
		Accent = Color3.fromRGB(120,140,255),
		StrokeIdle = Color3.fromRGB(90,90,130),
		StrokeActive = Color3.fromRGB(180,180,255),
		Minimize = Color3.fromRGB(255,210,90),
		ButtonIdle = Color3.fromRGB(50,50,70),
		ButtonHover = Color3.fromRGB(70,70,100),
		ButtonPress = Color3.fromRGB(90,90,130)
	},

	Animation = {
		DefaultSpeed = 0.35,
		Fast = 0.18,
		Slow = 0.6,
		EaseOut = Enum.EasingStyle.Quint,
		EaseInOut = Enum.EasingStyle.Sine
	},

	Layout = {
		MainScale = Vector2.new(0.36, 0.36),
		MinScale = Vector2.new(0.12, 0.08),
		Corner = 18,
		HeaderHeight = 52
	}
}

-------------------------
-- UTILITY FUNCTIONS
-------------------------
local function Create(class, props)
	local inst = Instance.new(class)
	for k,v in pairs(props) do
		inst[k] = v
	end
	return inst
end

local function Tween(obj, time, style, direction, props)
	local info = TweenInfo.new(
		time or CONFIG.Animation.DefaultSpeed,
		style or CONFIG.Animation.EaseOut,
		direction or Enum.EasingDirection.Out
	)
	local tw = TweenService:Create(obj, info, props)
	tw:Play()
	return tw
end

-------------------------
-- SCREEN GUI
-------------------------
local ScreenGui = Create("ScreenGui",{
	Name = "GodUIFrameworkExtreme",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = PlayerGui
})

-------------------------
-- SHADOW LAYER
-------------------------
local Shadow = Create("Frame",{
	Name = "Shadow",
	AnchorPoint = Vector2.new(0.5,0.5),
	Position = UDim2.fromScale(0.5,0.52),
	Size = UDim2.fromScale(CONFIG.Layout.MainScale.X + 0.02, CONFIG.Layout.MainScale.Y + 0.02),
	BackgroundColor3 = Color3.new(0,0,0),
	BackgroundTransparency = 0.65,
	ZIndex = 1,
	Parent = ScreenGui
})

Create("UICorner",{
	CornerRadius = UDim.new(0, CONFIG.Layout.Corner + 6),
	Parent = Shadow
})

-------------------------
-- MAIN FRAME
-------------------------
local MainFrame = Create("Frame",{
	Name = "MainFrame",
	AnchorPoint = Vector2.new(0.5,0.5),
	Position = UDim2.fromScale(0.5,0.5),
	Size = UDim2.fromScale(CONFIG.Layout.MainScale.X, CONFIG.Layout.MainScale.Y),
	BackgroundColor3 = CONFIG.Colors.Main,
	ZIndex = 2,
	Parent = ScreenGui
})

Create("UICorner",{
	CornerRadius = UDim.new(0, CONFIG.Layout.Corner),
	Parent = MainFrame
})

local Stroke = Create("UIStroke",{
	Color = CONFIG.Colors.StrokeIdle,
	Thickness = 1.5,
	Transparency = 0.35,
	Parent = MainFrame
})

Create("UIPadding",{
	PaddingTop = UDim.new(0,12),
	PaddingBottom = UDim.new(0,12),
	PaddingLeft = UDim.new(0,12),
	PaddingRight = UDim.new(0,12),
	Parent = MainFrame
})

local Gradient = Create("UIGradient",{
	Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Color3.fromRGB(70,70,130)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(25,25,35))
	},
	Rotation = 30,
	Parent = MainFrame
})

-------------------------
-- HEADER (DRAG AREA)
-------------------------
local Header = Create("Frame",{
	Name = "Header",
	Size = UDim2.new(1,0,0,CONFIG.Layout.HeaderHeight),
	BackgroundTransparency = 1,
	Parent = MainFrame
})

local Title = Create("TextLabel",{
	Text = "GOD UI FRAMEWORK : EXTREME",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = Color3.fromRGB(230,230,255),
	BackgroundTransparency = 1,
	Size = UDim2.new(1,-120,1,0),
	Parent = Header
})

-------------------------
-- BUTTON BASE FUNCTION
-------------------------
local function CreateButton(text, pos)
	local btn = Create("TextButton",{
		Text = text,
		Font = Enum.Font.GothamBold,
		TextScaled = true,
		BackgroundColor3 = CONFIG.Colors.ButtonIdle,
		Size = UDim2.fromOffset(34,34),
		Position = pos,
		ZIndex = 3,
		Parent = Header
	})

	Create("UICorner",{CornerRadius = UDim.new(1,0), Parent = btn})

	btn.MouseEnter:Connect(function()
		Tween(btn,CONFIG.Animation.Fast,nil,nil,{
			BackgroundColor3 = CONFIG.Colors.ButtonHover,
			Size = UDim2.fromOffset(38,38)
		})
	end)

	btn.MouseLeave:Connect(function()
		Tween(btn,CONFIG.Animation.Fast,nil,nil,{
			BackgroundColor3 = CONFIG.Colors.ButtonIdle,
			Size = UDim2.fromOffset(34,34)
		})
	end)

	btn.MouseButton1Down:Connect(function()
		Tween(btn,0.08,nil,nil,{
			BackgroundColor3 = CONFIG.Colors.ButtonPress
		})
	end)

	return btn
end

-------------------------
-- MIN / MAX BUTTON
-------------------------
local MinButton = CreateButton("-", UDim2.new(1,-44,0,8))

-------------------------
-- DRAG SYSTEM (ADVANCED)
-------------------------
local dragging = false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		Tween(MainFrame,0.2,nil,nil,{
			BackgroundColor3 = CONFIG.Colors.Drag,
			Size = UDim2.fromScale(CONFIG.Layout.MainScale.X + 0.02, CONFIG.Layout.MainScale.Y + 0.02)
		})

		Tween(Stroke,0.2,nil,nil,{
			Thickness = 3,
			Color = CONFIG.Colors.StrokeActive,
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

		Shadow.Position = MainFrame.Position + UDim2.fromOffset(10,10)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false

		Tween(MainFrame,0.35,Enum.EasingStyle.Back,nil,{
			BackgroundColor3 = CONFIG.Colors.Main,
			Size = UDim2.fromScale(CONFIG.Layout.MainScale.X, CONFIG.Layout.MainScale.Y)
		})

		Tween(Stroke,0.35,nil,nil,{
			Thickness = 1.5,
			Color = CONFIG.Colors.StrokeIdle,
			Transparency = 0.35
		})
	end
end)

-------------------------
-- MINIMIZE SYSTEM (STATE BASE)
-------------------------
local minimized = false
local originalSize = MainFrame.Size

MinButton.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		Tween(MainFrame,0.45,Enum.EasingStyle.Exponential,nil,{
			Size = UDim2.fromScale(CONFIG.Layout.MinScale.X, CONFIG.Layout.MinScale.Y),
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

-------------------------
-- UI APPEAR ANIMATION
-------------------------
MainFrame.BackgroundTransparency = 1
Shadow.BackgroundTransparency = 1

Tween(MainFrame,0.7,nil,nil,{BackgroundTransparency = 0})
Tween(Shadow,0.7,nil,nil,{BackgroundTransparency = 0.65})

-------------------------
-- PLACEHOLDER CONTENT
-------------------------
for i = 1,8 do
	local Item = Create("Frame",{
		Size = UDim2.new(1,0,0,42),
		BackgroundColor3 = Color3.fromRGB(45,45,65),
		BackgroundTransparency = 0.15,
		LayoutOrder = i,
		Parent = MainFrame
	})
	Create("UICorner",{CornerRadius = UDim.new(0,12), Parent = Item})
end
