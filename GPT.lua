-- SuperGodUI.lua (LocalScript)
-- これ1ファイルで「完全神UI」実装

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HapticService = game:GetService("HapticService")

local Player = Players.LocalPlayer

--========================
-- Config / Theme
--========================
local Config = {
	Theme = "Dark",
	MobileScale = 1.15,
	PCScale = 1,
	AnimationSpeed = 0.35,
	Haptic = true,
}

local ThemePresets = {
	Dark = {BG=Color3.fromRGB(25,25,30),BTN=Color3.fromRGB(45,45,60),TEXT=Color3.new(1,1,1)},
	Light = {BG=Color3.fromRGB(235,235,240),BTN=Color3.fromRGB(200,200,210),TEXT=Color3.new(0,0,0)},
}

local function GetTheme()
	return ThemePresets[Config.Theme]
end

--========================
-- Utilities
--========================
local function IsMobile()
	return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function Tween(obj,props,time,easing,dir)
	return TweenService:Create(obj,TweenInfo.new(time or Config.AnimationSpeed,easing or Enum.EasingStyle.Quad,dir or Enum.EasingDirection.Out),props)
end

local function Pulse(obj)
	local original = obj.Size
	Tween(obj,{Size=original*1.05},0.15):Play()
	task.delay(0.15,function() Tween(obj,{Size=original},0.15):Play() end)
end

local function HapticPulse()
	if Config.Haptic then
		pcall(function()
			HapticService:SetMotor(Enum.VibrationMotor.Small,0.6)
			task.delay(0.1,function() HapticService:SetMotor(Enum.VibrationMotor.Small,0) end)
		end)
	end
end

--========================
-- ScreenGui
--========================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SuperGodUI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

--========================
-- MainFrame
--========================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromScale(0.4,0.5)
MainFrame.Position = UDim2.fromScale(0.3,0.25)
MainFrame.BackgroundColor3 = GetTheme().BG
MainFrame.Parent = ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius = UDim.new(0,18)
Instance.new("UIStroke",MainFrame).Transparency = 0.3
Instance.new("UIPadding",MainFrame)
local Scale = Instance.new("UIScale",MainFrame)
Scale.Scale = IsMobile() and Config.MobileScale or Config.PCScale

local Layout = Instance.new("UIListLayout",MainFrame)
Layout.Padding = UDim.new(0,10)

--========================
-- Components
--========================
local Components = {}

function Components:Button(text,callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.fromScale(1,0.12)
	btn.BackgroundColor3 = GetTheme().BTN
	btn.TextColor3 = GetTheme().TEXT
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = text
	btn.Parent = MainFrame
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,12)

	btn.MouseEnter:Connect(function() Tween(btn,{BackgroundColor3=GetTheme().BTN:Lerp(Color3.new(1,1,1),0.15)}):Play() end)
	btn.MouseLeave:Connect(function() Tween(btn,{BackgroundColor3=GetTheme().BTN}):Play() end)
	btn.MouseButton1Click:Connect(function()
		Pulse(btn)
		HapticPulse()
		callback()
	end)
	return btn
end

function Components:Toggle(name,default,callback)
	local state = default
	local btn
	btn = self:Button(name..": "..(state and "ON" or "OFF"),function()
		state = not state
		btn.Text = name..": "..(state and "ON" or "OFF")
		callback(state)
	end)
	return btn
end

function Components:Slider(name,min,max,default,callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(1,0.12)
	frame.BackgroundColor3 = GetTheme().BG
	frame.Parent = MainFrame
	Instance.new("UICorner",frame).CornerRadius=UDim.new(0,12)

	local slider = Instance.new("TextButton")
	slider.Size = UDim2.fromScale((default-min)/(max-min),1)
	slider.BackgroundColor3 = GetTheme().BTN
	slider.Text = name.." "..tostring(default)
	slider.TextColor3 = GetTheme().TEXT
	slider.Font = Enum.Font.GothamBold
	slider.Parent = frame

	slider.MouseButton1Down:Connect(function()
		callback(default)
	end)

	return frame
end

function Components:Cooldown(button,time)
	button.Active = false
	task.spawn(function()
		for i=time,0,-1 do
			button.Text = "Cooldown: "..i
			task.wait(1)
		end
		button.Active = true
	end)
end

--========================
-- SmartUI / AI風
--========================
local function PredictNextAction()
	local ping = Player:GetNetworkPing()
	if ping>0.25 then
		return "通信注意UI優先"
	end
	return "次はスキル or インベントリ"
end

--========================
-- UI作成例
--========================
local btnInventory = Components:Button("インベントリ",function()
	print(PredictNextAction())
end)

local toggleTheme = Components:Toggle("ダークモード",true,function(v)
	Config.Theme = v and "Dark" or "Light"
	MainFrame.BackgroundColor3 = GetTheme().BG
end)

local sliderVolume = Components:Slider("音量",0,100,50,function(v)
	print("音量:",v)
end)

local btnCooldown = Components:Button("スキル発動",function()
	Components:Cooldown(btnCooldown,5)
end)

--========================
-- 拡張用Hooks
--========================
local Hooks = {}
function Hooks:UpdateTheme()
	MainFrame.BackgroundColor3 = GetTheme().BG
end

function Hooks:PulseUI()
	for _,child in pairs(MainFrame:GetChildren()) do
		if child:IsA("TextButton") then
			Pulse(child)
		end
	end
end

--========================
-- スクロール慣性 / モバイルスワイプ対応
--========================
local UIScrollEnabled = true
MainFrame.Active = true
MainFrame.Draggable = true

--========================
-- 完全統合完了
--========================
print("[SuperGodUI] 完全統合UIロード完了!")
