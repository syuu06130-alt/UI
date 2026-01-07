-- Lua Scripting Wizard's Forge - Roblox LocalScript
-- サイバーパンク風コードエディタUI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- メインScreenGui作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LuaScriptingForge"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- メインフレーム
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 1200, 0, 700)
mainFrame.Position = UDim2.new(0.5, -600, 0.5, -350)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- UIコーナー（角丸）
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- ネオングロー効果
local glowStroke = Instance.new("UIStroke")
glowStroke.Color = Color3.fromRGB(6, 182, 212)
glowStroke.Thickness = 2
glowStroke.Transparency = 0.5
glowStroke.Parent = mainFrame

-- タイトルバー
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = Color3.fromRGB(20, 30, 55)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(0, 400, 1, 0)
titleLabel.Position = UDim2.new(0, 60, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Lua Scripting Wizard's Forge"
titleLabel.TextColor3 = Color3.fromRGB(103, 232, 249)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- アイコン装飾
local iconFrame = Instance.new("Frame")
iconFrame.Size = UDim2.new(0, 32, 0, 32)
iconFrame.Position = UDim2.new(0, 15, 0.5, -16)
iconFrame.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
iconFrame.BorderSizePixel = 0
iconFrame.Parent = titleBar

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 6)
iconCorner.Parent = iconFrame

-- 左サイドバー（ファイルツリー）
local leftSidebar = Instance.new("Frame")
leftSidebar.Name = "LeftSidebar"
leftSidebar.Size = UDim2.new(0, 250, 1, -50)
leftSidebar.Position = UDim2.new(0, 0, 0, 50)
leftSidebar.BackgroundColor3 = Color3.fromRGB(20, 30, 48)
leftSidebar.BorderSizePixel = 0
leftSidebar.Parent = mainFrame

local sidebarStroke = Instance.new("UIStroke")
sidebarStroke.Color = Color3.fromRGB(6, 182, 212)
sidebarStroke.Thickness = 1
sidebarStroke.Transparency = 0.7
sidebarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sidebarStroke.Parent = leftSidebar

-- ファイルツリーヘッダー
local treeHeader = Instance.new("TextLabel")
treeHeader.Size = UDim2.new(1, 0, 0, 40)
treeHeader.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
treeHeader.BorderSizePixel = 0
treeHeader.Text = "📁 Project Files"
treeHeader.TextColor3 = Color3.fromRGB(103, 232, 249)
treeHeader.TextSize = 14
treeHeader.Font = Enum.Font.GothamBold
treeHeader.TextXAlignment = Enum.TextXAlignment.Left
treeHeader.Parent = leftSidebar

local treePadding = Instance.new("UIPadding")
treePadding.PaddingLeft = UDim.new(0, 15)
treePadding.Parent = treeHeader

-- ファイルリスト（スクロール可能）
local fileList = Instance.new("ScrollingFrame")
fileList.Name = "FileList"
fileList.Size = UDim2.new(1, 0, 1, -40)
fileList.Position = UDim2.new(0, 0, 0, 40)
fileList.BackgroundTransparency = 1
fileList.BorderSizePixel = 0
fileList.ScrollBarThickness = 4
fileList.ScrollBarImageColor3 = Color3.fromRGB(6, 182, 212)
fileList.CanvasSize = UDim2.new(0, 0, 0, 400)
fileList.Parent = leftSidebar

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = fileList

-- ファイルアイテム作成関数
local function createFileItem(name, icon, indent)
	local fileItem = Instance.new("TextButton")
	fileItem.Size = UDim2.new(1, -10, 0, 30)
	fileItem.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
	fileItem.BackgroundTransparency = 1
	fileItem.BorderSizePixel = 0
	fileItem.Text = icon .. " " .. name
	fileItem.TextColor3 = Color3.fromRGB(163, 230, 250)
	fileItem.TextSize = 12
	fileItem.Font = Enum.Font.Code
	fileItem.TextXAlignment = Enum.TextXAlignment.Left
	fileItem.Parent = fileList
	
	local itemPadding = Instance.new("UIPadding")
	itemPadding.PaddingLeft = UDim.new(0, indent)
	itemPadding.Parent = fileItem
	
	local itemCorner = Instance.new("UICorner")
	itemCorner.CornerRadius = UDim.new(0, 4)
	itemCorner.Parent = fileItem
	
	-- ホバーエフェクト
	fileItem.MouseEnter:Connect(function()
		fileItem.BackgroundTransparency = 0.9
		fileItem.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
	end)
	
	fileItem.MouseLeave:Connect(function()
		fileItem.BackgroundTransparency = 1
	end)
	
	-- クリックエフェクト
	fileItem.MouseButton1Click:Connect(function()
		fileItem.BackgroundTransparency = 0.8
		fileItem.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
		wait(0.1)
		fileItem.BackgroundTransparency = 0.9
		fileItem.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
	end)
	
	return fileItem
end

-- サンプルファイル追加
createFileItem("game.lua", "📄", 15)
createFileItem("player_scripts", "📁", 15)
createFileItem("movement.lua", "📄", 30)
createFileItem("inventory.lua", "📄", 30)
createFileItem("modules", "📁", 15)
createFileItem("gnode.lua", "📄", 30)
createFileItem("srooklua", "📄", 30)
createFileItem("tnode.lua", "📄", 30)
createFileItem("config.lua", "📄", 15)

-- 中央エディタエリア
local editorArea = Instance.new("Frame")
editorArea.Name = "EditorArea"
editorArea.Size = UDim2.new(1, -570, 1, -50)
editorArea.Position = UDim2.new(0, 250, 0, 50)
editorArea.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
editorArea.BorderSizePixel = 0
editorArea.Parent = mainFrame

-- エディタヘッダー（タブ）
local editorHeader = Instance.new("Frame")
editorHeader.Size = UDim2.new(1, 0, 0, 35)
editorHeader.BackgroundColor3 = Color3.fromRGB(20, 30, 48)
editorHeader.BorderSizePixel = 0
editorHeader.Parent = editorArea

local tabButton = Instance.new("TextLabel")
tabButton.Size = UDim2.new(0, 120, 1, 0)
tabButton.Position = UDim2.new(0, 10, 0, 0)
tabButton.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
tabButton.BackgroundTransparency = 0.8
tabButton.BorderSizePixel = 0
tabButton.Text = "game.lua"
tabButton.TextColor3 = Color3.fromRGB(240, 250, 255)
tabButton.TextSize = 12
tabButton.Font = Enum.Font.Code
tabButton.Parent = editorHeader

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 4)
tabCorner.Parent = tabButton

-- コードエディタ（テキストボックス）
local codeEditor = Instance.new("ScrollingFrame")
codeEditor.Name = "CodeEditor"
codeEditor.Size = UDim2.new(1, 0, 1, -35)
codeEditor.Position = UDim2.new(0, 0, 0, 35)
codeEditor.BackgroundColor3 = Color3.fromRGB(10, 15, 30)
codeEditor.BorderSizePixel = 0
codeEditor.ScrollBarThickness = 6
codeEditor.ScrollBarImageColor3 = Color3.fromRGB(6, 182, 212)
codeEditor.CanvasSize = UDim2.new(0, 0, 0, 600)
codeEditor.Parent = editorArea

-- コード表示用テキストラベル
local codeText = Instance.new("TextLabel")
codeText.Size = UDim2.new(1, -20, 0, 600)
codeText.Position = UDim2.new(0, 10, 0, 10)
codeText.BackgroundTransparency = 1
codeText.Text = [[function initialize()
  testing_rtb_lnsB({
    rotate26_tetPtk = 1
  })
  sosinsl()
end

function update(deltaTime)
  if player.isMoving then
    calculatePosition()
    updateAnimation()
  end
end

function calculatePosition()
  local newPos = Vector3.new()
  return newPos
end]]
codeText.TextColor3 = Color3.fromRGB(163, 230, 250)
codeText.TextSize = 13
codeText.Font = Enum.Font.Code
codeText.TextXAlignment = Enum.TextXAlignment.Left
codeText.TextYAlignment = Enum.TextYAlignment.Top
codeText.Parent = codeEditor

-- 行番号表示
local lineNumbers = Instance.new("TextLabel")
lineNumbers.Size = UDim2.new(0, 40, 1, 0)
lineNumbers.BackgroundColor3 = Color3.fromRGB(8, 12, 25)
lineNumbers.BorderSizePixel = 0
lineNumbers.Text = "1\n2\n3\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n15\n16\n17\n18"
lineNumbers.TextColor3 = Color3.fromRGB(70, 90, 120)
lineNumbers.TextSize = 12
lineNumbers.Font = Enum.Font.Code
lineNumbers.TextXAlignment = Enum.TextXAlignment.Right
lineNumbers.TextYAlignment = Enum.TextYAlignment.Top
lineNumbers.Parent = editorArea

local lineNumPadding = Instance.new("UIPadding")
lineNumPadding.PaddingRight = UDim.new(0, 8)
lineNumPadding.PaddingTop = UDim.new(0, 45)
lineNumPadding.Parent = lineNumbers

-- 右サイドバー（コンソール）
local rightSidebar = Instance.new("Frame")
rightSidebar.Name = "RightSidebar"
rightSidebar.Size = UDim2.new(0, 320, 1, -50)
rightSidebar.Position = UDim2.new(1, -320, 0, 50)
rightSidebar.BackgroundColor3 = Color3.fromRGB(20, 30, 48)
rightSidebar.BorderSizePixel = 0
rightSidebar.Parent = mainFrame

local rightStroke = Instance.new("UIStroke")
rightStroke.Color = Color3.fromRGB(6, 182, 212)
rightStroke.Thickness = 1
rightStroke.Transparency = 0.7
rightStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
rightStroke.Parent = rightSidebar

-- コンソールヘッダー
local consoleHeader = Instance.new("TextLabel")
consoleHeader.Size = UDim2.new(1, 0, 0, 40)
consoleHeader.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
consoleHeader.BorderSizePixel = 0
consoleHeader.Text = "⚡ Console"
consoleHeader.TextColor3 = Color3.fromRGB(103, 232, 249)
consoleHeader.TextSize = 14
consoleHeader.Font = Enum.Font.GothamBold
consoleHeader.TextXAlignment = Enum.TextXAlignment.Left
consoleHeader.Parent = rightSidebar

local consolePadding = Instance.new("UIPadding")
consolePadding.PaddingLeft = UDim.new(0, 15)
consolePadding.Parent = consoleHeader

-- コンソール出力エリア
local consoleOutput = Instance.new("ScrollingFrame")
consoleOutput.Name = "ConsoleOutput"
consoleOutput.Size = UDim2.new(1, -20, 1, -180)
consoleOutput.Position = UDim2.new(0, 10, 0, 50)
consoleOutput.BackgroundTransparency = 1
consoleOutput.BorderSizePixel = 0
consoleOutput.ScrollBarThickness = 4
consoleOutput.ScrollBarImageColor3 = Color3.fromRGB(6, 182, 212)
consoleOutput.CanvasSize = UDim2.new(0, 0, 0, 300)
consoleOutput.Parent = rightSidebar

local consoleLayout = Instance.new("UIListLayout")
consoleLayout.Padding = UDim.new(0, 5)
consoleLayout.Parent = consoleOutput

-- コンソールログ作成関数
local function createLog(message, logType)
	local logFrame = Instance.new("Frame")
	logFrame.Size = UDim2.new(1, 0, 0, 50)
	logFrame.BorderSizePixel = 0
	logFrame.Parent = consoleOutput
	
	local logColor, strokeColor
	if logType == "error" then
		logColor = Color3.fromRGB(40, 10, 10)
		strokeColor = Color3.fromRGB(220, 38, 38)
	elseif logType == "warning" then
		logColor = Color3.fromRGB(40, 35, 10)
		strokeColor = Color3.fromRGB(234, 179, 8)
	elseif logType == "success" then
		logColor = Color3.fromRGB(10, 40, 20)
		strokeColor = Color3.fromRGB(34, 197, 94)
	else
		logColor = Color3.fromRGB(10, 25, 40)
		strokeColor = Color3.fromRGB(6, 182, 212)
	end
	
	logFrame.BackgroundColor3 = logColor
	
	local logCorner = Instance.new("UICorner")
	logCorner.CornerRadius = UDim.new(0, 4)
	logCorner.Parent = logFrame
	
	local logStroke = Instance.new("UIStroke")
	logStroke.Color = strokeColor
	logStroke.Thickness = 1
	logStroke.Transparency = 0.5
	logStroke.Parent = logFrame
	
	local logText = Instance.new("TextLabel")
	logText.Size = UDim2.new(1, -10, 1, -10)
	logText.Position = UDim2.new(0, 5, 0, 5)
	logText.BackgroundTransparency = 1
	logText.Text = message
	logText.TextColor3 = strokeColor
	logText.TextSize = 11
	logText.Font = Enum.Font.Code
	logText.TextXAlignment = Enum.TextXAlignment.Left
	logText.TextYAlignment = Enum.TextYAlignment.Top
	logText.TextWrapped = true
	logText.Parent = logFrame
	
	return logFrame
end

-- サンプルログ追加
createLog("[SUCCESS] Script loaded successfully", "success")
createLog("[INFO] Connecting to game server...", "info")
createLog("[ERROR] Nil value at line 23", "error")
createLog("[WARNING] Deprecated function usage", "warning")

-- コントロールパネル
local controlPanel = Instance.new("Frame")
controlPanel.Size = UDim2.new(1, -20, 0, 120)
controlPanel.Position = UDim2.new(0, 10, 1, -130)
controlPanel.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
controlPanel.BorderSizePixel = 0
controlPanel.Parent = rightSidebar

local controlCorner = Instance.new("UICorner")
controlCorner.CornerRadius = UDim.new(0, 8)
controlCorner.Parent = controlPanel

-- Runボタン
local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(0.48, 0, 0, 40)
runButton.Position = UDim2.new(0.02, 0, 0.05, 0)
runButton.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
runButton.BorderSizePixel = 0
runButton.Text = "▶ Run"
runButton.TextColor3 = Color3.fromRGB(15, 23, 42)
runButton.TextSize = 14
runButton.Font = Enum.Font.GothamBold
runButton.Parent = controlPanel

local runCorner = Instance.new("UICorner")
runCorner.CornerRadius = UDim.new(0, 6)
runCorner.Parent = runButton

-- グロー効果
local runStroke = Instance.new("UIStroke")
runStroke.Color = Color3.fromRGB(6, 182, 212)
runStroke.Thickness = 0
runStroke.Transparency = 0.5
runStroke.Parent = runButton

-- Debugボタン
local debugButton = Instance.new("TextButton")
debugButton.Size = UDim2.new(0.48, 0, 0, 40)
debugButton.Position = UDim2.new(0.5, 0, 0.05, 0)
debugButton.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
debugButton.BackgroundTransparency = 0.7
debugButton.BorderSizePixel = 0
debugButton.Text = "🐛 Debug"
debugButton.TextColor3 = Color3.fromRGB(220, 180, 255)
debugButton.TextSize = 14
debugButton.Font = Enum.Font.GothamBold
debugButton.Parent = controlPanel

local debugCorner = Instance.new("UICorner")
debugCorner.CornerRadius = UDim.new(0, 6)
debugCorner.Parent = debugButton

local debugStroke = Instance.new("UIStroke")
debugStroke.Color = Color3.fromRGB(168, 85, 247)
debugStroke.Thickness = 1
debugStroke.Transparency = 0.5
debugStroke.Parent = debugButton

-- UIスケールラベル
local scaleLabel = Instance.new("TextLabel")
scaleLabel.Size = UDim2.new(0.6, 0, 0, 20)
scaleLabel.Position = UDim2.new(0.02, 0, 0.5, 0)
scaleLabel.BackgroundTransparency = 1
scaleLabel.Text = "UI Scale: 100%"
scaleLabel.TextColor3 = Color3.fromRGB(163, 230, 250)
scaleLabel.TextSize = 11
scaleLabel.Font = Enum.Font.Gotham
scaleLabel.TextXAlignment = Enum.TextXAlignment.Left
scaleLabel.Parent = controlPanel

-- Auto-Save トグル
local autoSaveLabel = Instance.new("TextLabel")
autoSaveLabel.Size = UDim2.new(0.5, 0, 0, 20)
autoSaveLabel.Position = UDim2.new(0.02, 0, 0.75, 0)
autoSaveLabel.BackgroundTransparency = 1
autoSaveLabel.Text = "Auto-Save"
autoSaveLabel.TextColor3 = Color3.fromRGB(163, 230, 250)
autoSaveLabel.TextSize = 11
autoSaveLabel.Font = Enum.Font.Gotham
autoSaveLabel.TextXAlignment = Enum.TextXAlignment.Left
autoSaveLabel.Parent = controlPanel

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 40, 0, 20)
toggleButton.Position = UDim2.new(0.55, 0, 0.75, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
toggleButton.BorderSizePixel = 0
toggleButton.Text = ""
toggleButton.Parent = controlPanel

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleButton

local toggleCircle = Instance.new("Frame")
toggleCircle.Size = UDim2.new(0, 16, 0, 16)
toggleCircle.Position = UDim2.new(0, 22, 0.5, -8)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle.BorderSizePixel = 0
toggleCircle.Parent = toggleButton

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = toggleCircle

-- トグル機能
local isToggled = true
toggleButton.MouseButton1Click:Connect(function()
	isToggled = not isToggled
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
	if isToggled then
		local tween = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 22, 0.5, -8)})
		tween:Play()
		toggleButton.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
	else
		local tween = TweenService:Create(toggleCircle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -8)})
		tween:Play()
		toggleButton.BackgroundColor3 = Color3.fromRGB(71, 85, 105)
	end
end)

-- ボタンホバーエフェクト
runButton.MouseEnter:Connect(function()
	runButton.BackgroundColor3 = Color3.fromRGB(14, 165, 233)
end)

runButton.MouseLeave:Connect(function()
	runButton.BackgroundColor3 = Color3.fromRGB(6, 182, 212)
end)

debugButton.MouseEnter:Connect(function()
	debugButton.BackgroundTransparency = 0.5
end)

debugButton.MouseLeave:Connect(function()
	debugButton.BackgroundTransparency = 0.7
end)

-- ドラッグ可能にする
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
	local delta = input.Position - mousePos
	mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

print("✨ Lua Scripting Wizard's Forge loaded successfully!")
