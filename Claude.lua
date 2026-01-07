-- Roblox LocalScript - SciFi Lua Editor UI
-- Place this in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Config
local CONFIG = {
	scale = 1,
	autoSave = true,
	darkMode = true,
	colors = {
		bg = Color3.fromRGB(3, 7, 18),
		panel = Color3.fromRGB(17, 24, 39),
		border = Color3.fromRGB(6, 182, 212),
		cyan = Color3.fromRGB(34, 211, 238),
		text = Color3.fromRGB(209, 213, 219),
		success = Color3.fromRGB(34, 197, 94),
		warning = Color3.fromRGB(234, 179, 8),
		error = Color3.fromRGB(239, 68, 68),
		purple = Color3.fromRGB(168, 85, 247)
	}
}

-- State
local state = {
	expandedFolders = {scripts = true, modules = false},
	selectedFile = "MainScript.lua",
	consoleLines = {
		{type = "info", text = "> IDE initialized successfully"},
		{type = "success", text = "✓ Workspace loaded"},
		{type = "warning", text = "⚠ Autosave enabled"}
	}
}

-- File Tree Data
local fileTree = {
	scripts = {"MainScript.lua", "PlayerController.lua", "GameManager.lua"},
	modules = {"Utilities.lua", "DataHandler.lua"}
}

local codeExample = [[-- Roblox LocalScript
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Initialize UI
local function initializeUI()
    print("Initializing player UI...")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainUI"
    screenGui.Parent = player.PlayerGui
    
    return screenGui
end

-- Event handler
local function onPlayerAdded()
    wait(1)
    local ui = initializeUI()
    print("UI ready for:", player.Name)
end

-- Start
onPlayerAdded()]]

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LuaForgeIDE"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Helper Functions
local function createCorner(radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	return corner
end

local function createStroke(color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.7
	return stroke
end

local function createGlow(parent, color, size)
	local glow = Instance.new("ImageLabel")
	glow.Name = "Glow"
	glow.BackgroundTransparency = 1
	glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
	glow.ImageColor3 = color
	glow.ImageTransparency = 0.7
	glow.Size = UDim2.new(1, size, 1, size)
	glow.Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
	glow.ZIndex = 0
	glow.Parent = parent
	return glow
end

local function tweenHover(button, scale)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {Size = button.Size + UDim2.new(0, scale, 0, scale)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2), {Size = button.Size}):Play()
	end)
end

-- Main Container
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = CONFIG.colors.bg
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Cyber Background Effect
local bgEffect1 = Instance.new("ImageLabel")
bgEffect1.BackgroundTransparency = 1
bgEffect1.Size = UDim2.new(0, 400, 0, 400)
bgEffect1.Position = UDim2.new(0.25, 0, 0, 0)
bgEffect1.ImageColor3 = CONFIG.colors.cyan
bgEffect1.ImageTransparency = 0.7
bgEffect1.ZIndex = 0
bgEffect1.Parent = mainFrame

local bgEffect2 = Instance.new("ImageLabel")
bgEffect2.BackgroundTransparency = 1
bgEffect2.Size = UDim2.new(0, 400, 0, 400)
bgEffect2.Position = UDim2.new(0.75, 0, 1, -400)
bgEffect2.ImageColor3 = Color3.fromRGB(59, 130, 246)
bgEffect2.ImageTransparency = 0.7
bgEffect2.ZIndex = 0
bgEffect2.Parent = mainFrame

-- Top Toolbar
local toolbar = Instance.new("Frame")
toolbar.Size = UDim2.new(1, -40, 0, 70)
toolbar.Position = UDim2.new(0, 20, 0, 20)
toolbar.BackgroundColor3 = CONFIG.colors.panel
toolbar.BackgroundTransparency = 0.2
toolbar.BorderSizePixel = 0
toolbar.Parent = mainFrame
createCorner(16).Parent = toolbar
createStroke(CONFIG.colors.border, 1, 0.7).Parent = toolbar

-- Toolbar Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 60, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LUAFORGE IDE"
title.TextColor3 = CONFIG.colors.cyan
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = toolbar

-- Status Dots
local dotColors = {CONFIG.colors.error, CONFIG.colors.warning, CONFIG.colors.success}
for i, color in ipairs(dotColors) do
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 12, 0, 12)
	dot.Position = UDim2.new(0, 20 + (i-1)*20, 0.5, -6)
	dot.BackgroundColor3 = color
	dot.BorderSizePixel = 0
	dot.Parent = toolbar
	createCorner(6).Parent = dot
end

-- Button Helper Function
local function createButton(parent, text, position, color, icon)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 0, 36)
	btn.Position = position
	btn.BackgroundColor3 = color
	btn.BorderSizePixel = 0
	btn.Text = (icon or "") .. " " .. text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = parent
	createCorner(8).Parent = btn
	
	-- Hover effect
	local originalSize = btn.Size
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {
			Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 4, originalSize.Y.Scale, originalSize.Y.Offset + 4)
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {Size = originalSize}):Play()
	end)
	
	return btn
end

-- Control Buttons
local runBtn = createButton(toolbar, "Run", UDim2.new(1, -330, 0.5, -18), CONFIG.colors.success, "▶")
local debugBtn = createButton(toolbar, "Debug", UDim2.new(1, -220, 0.5, -18), CONFIG.colors.warning, "🐞")
local stopBtn = createButton(toolbar, "Stop", UDim2.new(1, -110, 0.5, -18), CONFIG.colors.error, "■")

-- Left Sidebar - File Explorer
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 250, 1, -180)
sidebar.Position = UDim2.new(0, 20, 0, 110)
sidebar.BackgroundColor3 = CONFIG.colors.panel
sidebar.BackgroundTransparency = 0.2
sidebar.BorderSizePixel = 0
sidebar.Parent = mainFrame
createCorner(16).Parent = sidebar
createStroke(CONFIG.colors.border, 1, 0.8).Parent = sidebar

local sidebarTitle = Instance.new("TextLabel")
sidebarTitle.Size = UDim2.new(1, -20, 0, 40)
sidebarTitle.Position = UDim2.new(0, 10, 0, 10)
sidebarTitle.BackgroundTransparency = 1
sidebarTitle.Text = "📁 EXPLORER"
sidebarTitle.TextColor3 = CONFIG.colors.cyan
sidebarTitle.Font = Enum.Font.GothamBold
sidebarTitle.TextSize = 16
sidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
sidebarTitle.Parent = sidebar

-- File Tree Scroll
local fileScroll = Instance.new("ScrollingFrame")
fileScroll.Size = UDim2.new(1, -20, 1, -60)
fileScroll.Position = UDim2.new(0, 10, 0, 50)
fileScroll.BackgroundTransparency = 1
fileScroll.BorderSizePixel = 0
fileScroll.ScrollBarThickness = 4
fileScroll.ScrollBarImageColor3 = CONFIG.colors.cyan
fileScroll.Parent = sidebar

local fileListLayout = Instance.new("UIListLayout")
fileListLayout.Padding = UDim.new(0, 5)
fileListLayout.Parent = fileScroll

-- Create File Tree
local yPos = 0
for folderName, files in pairs(fileTree) do
	local folderBtn = Instance.new("TextButton")
	folderBtn.Size = UDim2.new(1, -10, 0, 35)
	folderBtn.BackgroundColor3 = CONFIG.colors.panel
	folderBtn.BackgroundTransparency = 0.5
	folderBtn.BorderSizePixel = 0
	folderBtn.Text = (state.expandedFolders[folderName] and "▼" or "▶") .. " 📁 " .. folderName
	folderBtn.TextColor3 = CONFIG.colors.text
	folderBtn.Font = Enum.Font.Gotham
	folderBtn.TextSize = 14
	folderBtn.TextXAlignment = Enum.TextXAlignment.Left
	folderBtn.Parent = fileScroll
	createCorner(8).Parent = folderBtn
	
	local fileContainer = Instance.new("Frame")
	fileContainer.Size = UDim2.new(1, -10, 0, 0)
	fileContainer.BackgroundTransparency = 1
	fileContainer.Visible = state.expandedFolders[folderName]
	fileContainer.Parent = fileScroll
	
	local fileLayout = Instance.new("UIListLayout")
	fileLayout.Padding = UDim.new(0, 3)
	fileLayout.Parent = fileContainer
	
	for i, fileName in ipairs(files) do
		local fileBtn = Instance.new("TextButton")
		fileBtn.Size = UDim2.new(1, -20, 0, 30)
		fileBtn.Position = UDim2.new(0, 20, 0, 0)
		fileBtn.BackgroundColor3 = state.selectedFile == fileName and CONFIG.colors.cyan or CONFIG.colors.panel
		fileBtn.BackgroundTransparency = state.selectedFile == fileName and 0.8 or 0.7
		fileBtn.BorderSizePixel = 0
		fileBtn.Text = "  📄 " .. fileName
		fileBtn.TextColor3 = state.selectedFile == fileName and CONFIG.colors.cyan or CONFIG.colors.text
		fileBtn.Font = Enum.Font.Gotham
		fileBtn.TextSize = 12
		fileBtn.TextXAlignment = Enum.TextXAlignment.Left
		fileBtn.Parent = fileContainer
		createCorner(6).Parent = fileBtn
		
		fileBtn.MouseButton1Click:Connect(function()
			state.selectedFile = fileName
			-- Refresh UI (simplified)
			fileBtn.BackgroundColor3 = CONFIG.colors.cyan
			fileBtn.BackgroundTransparency = 0.8
		end)
	end
	
	fileContainer.Size = UDim2.new(1, -10, 0, #files * 33)
	
	folderBtn.MouseButton1Click:Connect(function()
		state.expandedFolders[folderName] = not state.expandedFolders[folderName]
		fileContainer.Visible = state.expandedFolders[folderName]
		folderBtn.Text = (state.expandedFolders[folderName] and "▼" or "▶") .. " 📁 " .. folderName
	end)
end

fileScroll.CanvasSize = UDim2.new(0, 0, 0, fileListLayout.AbsoluteContentSize.Y)

-- Code Editor Panel
local editorPanel = Instance.new("Frame")
editorPanel.Size = UDim2.new(1, -600, 1, -260)
editorPanel.Position = UDim2.new(0, 290, 0, 110)
editorPanel.BackgroundColor3 = CONFIG.colors.panel
editorPanel.BackgroundTransparency = 0.2
editorPanel.BorderSizePixel = 0
editorPanel.Parent = mainFrame
createCorner(16).Parent = editorPanel
createStroke(CONFIG.colors.border, 1, 0.8).Parent = editorPanel

-- Editor Header
local editorHeader = Instance.new("Frame")
editorHeader.Size = UDim2.new(1, 0, 0, 40)
editorHeader.BackgroundColor3 = CONFIG.colors.bg
editorHeader.BackgroundTransparency = 0.5
editorHeader.BorderSizePixel = 0
editorHeader.Parent = editorPanel

local editorTitle = Instance.new("TextLabel")
editorTitle.Size = UDim2.new(1, -20, 1, 0)
editorTitle.Position = UDim2.new(0, 10, 0, 0)
editorTitle.BackgroundTransparency = 1
editorTitle.Text = "📄 " .. state.selectedFile
editorTitle.TextColor3 = CONFIG.colors.text
editorTitle.Font = Enum.Font.Gotham
editorTitle.TextSize = 14
editorTitle.TextXAlignment = Enum.TextXAlignment.Left
editorTitle.Parent = editorHeader

-- Code Text Area
local codeScroll = Instance.new("ScrollingFrame")
codeScroll.Size = UDim2.new(1, -20, 1, -60)
codeScroll.Position = UDim2.new(0, 10, 0, 50)
codeScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
codeScroll.BackgroundTransparency = 0.6
codeScroll.BorderSizePixel = 0
codeScroll.ScrollBarThickness = 6
codeScroll.ScrollBarImageColor3 = CONFIG.colors.cyan
codeScroll.Parent = editorPanel
createCorner(8).Parent = codeScroll

local codeText = Instance.new("TextLabel")
codeText.Size = UDim2.new(1, -50, 0, 1000)
codeText.Position = UDim2.new(0, 40, 0, 0)
codeText.BackgroundTransparency = 1
codeText.Text = codeExample
codeText.TextColor3 = CONFIG.colors.text
codeText.Font = Enum.Font.Code
codeText.TextSize = 14
codeText.TextXAlignment = Enum.TextXAlignment.Left
codeText.TextYAlignment = Enum.TextYAlignment.Top
codeText.Parent = codeScroll

-- Line Numbers
local lineNumbers = Instance.new("TextLabel")
lineNumbers.Size = UDim2.new(0, 35, 1, 0)
lineNumbers.BackgroundTransparency = 1
lineNumbers.Text = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18\n19\n20"
lineNumbers.TextColor3 = Color3.fromRGB(100, 100, 100)
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextSize = 14
lineNumbers.TextXAlignment = Enum.TextXAlignment.Right
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Parent = codeScroll

-- Console Panel (Right)
local consolePanel = Instance.new("Frame")
consolePanel.Size = UDim2.new(0, 300, 1, -180)
consolePanel.Position = UDim2.new(1, -320, 0, 110)
consolePanel.BackgroundColor3 = CONFIG.colors.panel
consolePanel.BackgroundTransparency = 0.2
consolePanel.BorderSizePixel = 0
consolePanel.Parent = mainFrame
createCorner(16).Parent = consolePanel
createStroke(CONFIG.colors.border, 1, 0.8).Parent = consolePanel

local consoleTitle = Instance.new("TextLabel")
consoleTitle.Size = UDim2.new(1, -20, 0, 40)
consoleTitle.Position = UDim2.new(0, 10, 0, 10)
consoleTitle.BackgroundTransparency = 1
consoleTitle.Text = "💻 CONSOLE"
consoleTitle.TextColor3 = CONFIG.colors.cyan
consoleTitle.Font = Enum.Font.GothamBold
consoleTitle.TextSize = 16
consoleTitle.TextXAlignment = Enum.TextXAlignment.Left
consoleTitle.Parent = consolePanel

local consoleScroll = Instance.new("ScrollingFrame")
consoleScroll.Size = UDim2.new(1, -20, 1, -60)
consoleScroll.Position = UDim2.new(0, 10, 0, 50)
consoleScroll.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
consoleScroll.BackgroundTransparency = 0.6
consoleScroll.BorderSizePixel = 0
consoleScroll.ScrollBarThickness = 4
consoleScroll.ScrollBarImageColor3 = CONFIG.colors.cyan
consoleScroll.Parent = consolePanel
createCorner(8).Parent = consoleScroll

local consoleLayout = Instance.new("UIListLayout")
consoleLayout.Padding = UDim.new(0, 5)
consoleLayout.Parent = consoleScroll

-- Add Console Lines
local function addConsoleLine(lineType, text)
	local lineColor = CONFIG.colors.text
	if lineType == "error" then lineColor = CONFIG.colors.error
	elseif lineType == "warning" then lineColor = CONFIG.colors.warning
	elseif lineType == "success" then lineColor = CONFIG.colors.success
	end
	
	local line = Instance.new("TextLabel")
	line.Size = UDim2.new(1, -10, 0, 25)
	line.BackgroundTransparency = 1
	line.Text = text
	line.TextColor3 = lineColor
	line.Font = Enum.Font.Code
	line.TextSize = 12
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.Parent = consoleScroll
	
	consoleScroll.CanvasSize = UDim2.new(0, 0, 0, consoleLayout.AbsoluteContentSize.Y)
end

-- Initial console lines
for _, line in ipairs(state.consoleLines) do
	addConsoleLine(line.type, line.text)
end

-- Bottom Controls
local controlPanel = Instance.new("Frame")
controlPanel.Size = UDim2.new(1, -600, 0, 60)
controlPanel.Position = UDim2.new(0, 290, 1, -80)
controlPanel.BackgroundColor3 = CONFIG.colors.panel
controlPanel.BackgroundTransparency = 0.2
controlPanel.BorderSizePixel = 0
controlPanel.Parent = mainFrame
createCorner(16).Parent = controlPanel
createStroke(CONFIG.colors.border, 1, 0.8).Parent = controlPanel

-- UI Scale Slider
local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(0, 80, 1, 0)
scaleLabel.Position = UDim2.new(0, 20, 0, 0)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Text = "UI Scale:"
scaleLabel.TextColor3 = CONFIG.colors.text
scaleLabel.Font = Enum.Font.Gotham
scaleLabel.TextSize = 12
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.Parent = controlPanel

local scaleValue = Instance.new("TextLabel")
scaleValue.Size = UDim2.new(0, 50, 1, 0)
scaleValue.Position = UDim2.new(0, 250, 0, 0)
scaleValue.BackgroundTransparency = 1
scaleValue.Text = "100%"
scaleValue.TextColor3 = CONFIG.colors.cyan
scaleValue.Font = Enum.Font.GothamBold
scaleValue.TextSize = 12
scaleValue.Parent = controlPanel

-- Auto-Save Toggle
local autoSaveLabel = Instance.new("TextLabel")
autoSaveLabel.Size = UDim2.new(0, 80, 1, 0)
autoSaveLabel.Position = UDim2.new(0, 320, 0, 0)
autoSaveLabel.BackgroundTransparency = 1
autoSaveLabel.Text = "Auto-Save:"
autoSaveLabel.TextColor3 = CONFIG.colors.text
autoSaveLabel.Font = Enum.Font.Gotham
autoSaveLabel.TextSize = 12
autoSaveLabel.TextXAlignment = Enum.TextXAlignment.Left
autoSaveLabel.Parent = controlPanel

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 50, 0, 24)
toggleBtn.Position = UDim2.new(0, 410, 0.5, -12)
toggleBtn.BackgroundColor3 = CONFIG.colors.success
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = ""
toggleBtn.Parent = controlPanel
createCorner(12).Parent = toggleBtn

local toggleIndicator = Instance.new("Frame")
toggleIndicator.Size = UDim2.new(0, 20, 0, 20)
toggleIndicator.Position = UDim2.new(1, -22, 0.5, -10)
toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleIndicator.BorderSizePixel = 0
toggleIndicator.Parent = toggleBtn
createCorner(10).Parent = toggleIndicator

toggleBtn.MouseButton1Click:Connect(function()
	CONFIG.autoSave = not CONFIG.autoSave
	if CONFIG.autoSave then
		toggleBtn.BackgroundColor3 = CONFIG.colors.success
		TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
	else
		toggleBtn.BackgroundColor3 = Color3.fromRGB(75, 85, 99)
		TweenService:Create(toggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
	end
end)

-- Button Events
runBtn.MouseButton1Click:Connect(function()
	addConsoleLine("info", "> Running script...")
	wait(0.5)
	addConsoleLine("success", "✓ Script executed successfully")
end)

debugBtn.MouseButton1Click:Connect(function()
	addConsoleLine("info", "> Debug mode activated")
	addConsoleLine("warning", "⚠ Breakpoint set at line 12")
end)

stopBtn.MouseButton1Click:Connect(function()
	addConsoleLine("error", "■ Script stopped")
end)

print("LuaForge IDE loaded successfully!")
