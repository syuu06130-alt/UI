--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║                         Syu_hub UI                           ║
    ║              Rayfield-Inspired Roblox UI Library             ║
    ║                     Version 1.0.0                            ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    使用方法:
        local Syu = loadstring(game:HttpGet("your_url"))()
        
        local Window = Syu:CreateWindow({
            Title = "Syu_hub",
            SubTitle = "by You",
        })
        
        local Tab = Window:CreateTab("Main", "rbxassetid://...")
        
        Tab:CreateButton({ Name = "ボタン", Callback = function() end })
        Tab:CreateToggle({ Name = "トグル", CurrentValue = false, Callback = function(v) end })
        Tab:CreateSlider({ Name = "スライダー", Range = {0, 100}, Increment = 1, CurrentValue = 50, Callback = function(v) end })
        Tab:CreateLabel({ Name = "ラベル" })
        Tab:CreateSeparator()
]]

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Services
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Players        = game:GetService("Players")
local UserInput      = game:GetService("UserInputService")
local TweenService   = game:GetService("TweenService")
local RunService     = game:GetService("RunService")
local CoreGui        = game:GetService("CoreGui")
local LocalPlayer    = Players.LocalPlayer
local Mouse          = LocalPlayer:GetMouse()

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Theme / Design Tokens
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Theme = {
    -- ベース
    Background       = Color3.fromRGB(15, 15, 20),
    BackgroundSec    = Color3.fromRGB(22, 22, 30),
    BackgroundTer    = Color3.fromRGB(30, 30, 40),

    -- アクセント
    Accent           = Color3.fromRGB(100, 80, 255),
    AccentDark       = Color3.fromRGB(70, 55, 200),
    AccentLight      = Color3.fromRGB(130, 110, 255),

    -- テキスト
    TextPrimary      = Color3.fromRGB(240, 240, 255),
    TextSecondary    = Color3.fromRGB(150, 150, 170),
    TextMuted        = Color3.fromRGB(90, 90, 110),

    -- ボーダー
    Border           = Color3.fromRGB(50, 50, 70),
    BorderLight      = Color3.fromRGB(70, 70, 100),

    -- UI状態
    Success          = Color3.fromRGB(60, 200, 120),
    Warning          = Color3.fromRGB(230, 180, 60),
    Error            = Color3.fromRGB(220, 80, 80),
    Info             = Color3.fromRGB(80, 160, 240),

    -- トグル
    ToggleOn         = Color3.fromRGB(100, 80, 255),
    ToggleOff        = Color3.fromRGB(50, 50, 70),
    ToggleKnob       = Color3.fromRGB(240, 240, 255),

    -- ドラッグバー
    DragBar          = Color3.fromRGB(20, 20, 28),
    DragBarAccent    = Color3.fromRGB(100, 80, 255),

    -- 最小化ピル
    PillBackground   = Color3.fromRGB(22, 22, 30),
    PillBorder       = Color3.fromRGB(100, 80, 255),
    PillText         = Color3.fromRGB(240, 240, 255),
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Config
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Config = {
    WindowWidth      = 560,
    WindowHeight     = 380,
    TabWidth         = 130,
    HeaderHeight     = 50,
    DragBarHeight    = 28,
    CornerRadius     = UDim.new(0, 12),
    AnimSpeed        = 0.25,
    PillWidth        = 130,
    PillHeight       = 34,
    NotifDuration    = 3.5,
    Font             = Enum.Font.GothamMedium,
    FontBold         = Enum.Font.GothamBold,
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Utility Functions
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Util = {}

function Util.Tween(obj, props, duration, style, dir)
    local info = TweenInfo.new(
        duration or Config.AnimSpeed,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

function Util.Create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            inst[k] = v
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

function Util.Corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = radius or Config.CornerRadius
    c.Parent = parent
    return c
end

function Util.Stroke(parent, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or Theme.Border
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

function Util.Padding(parent, top, right, bottom, left)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top    or 0)
    p.PaddingRight  = UDim.new(0, right  or 0)
    p.PaddingBottom = UDim.new(0, bottom or 0)
    p.PaddingLeft   = UDim.new(0, left   or 0)
    p.Parent = parent
    return p
end

function Util.ListLayout(parent, direction, spacing, align)
    local l = Instance.new("UIListLayout")
    l.FillDirection  = direction or Enum.FillDirection.Vertical
    l.Padding        = UDim.new(0, spacing or 0)
    l.HorizontalAlignment = align or Enum.HorizontalAlignment.Left
    l.SortOrder      = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

function Util.MakeDraggable(dragHandle, dragTarget)
    local dragging    = false
    local dragStart   = nil
    local startPos    = nil

    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        dragTarget.Position = newPos
    end

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = dragTarget.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInput.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            updateDrag(input)
        end
    end)
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Notification System
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local NotifGui = Util.Create("ScreenGui", {
    Name = "SyuHub_Notifications",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
pcall(function() NotifGui.Parent = CoreGui end)
if not NotifGui.Parent then NotifGui.Parent = LocalPlayer.PlayerGui end

local NotifHolder = Util.Create("Frame", {
    Name = "NotifHolder",
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(1, -310, 0, 0),
    BackgroundTransparency = 1,
    Parent = NotifGui,
})
Util.ListLayout(NotifHolder, Enum.FillDirection.Vertical, 8)
Util.Padding(NotifHolder, 10, 0, 10, 0)

local function SendNotification(opts)
    local title   = opts.Title   or "Syu_hub"
    local desc    = opts.Content or ""
    local dur     = opts.Duration or Config.NotifDuration
    local ntype   = opts.Type    or "Info"  -- "Info" | "Success" | "Warning" | "Error"

    local typeColor = ({
        Info    = Theme.Info,
        Success = Theme.Success,
        Warning = Theme.Warning,
        Error   = Theme.Error,
    })[ntype] or Theme.Info

    local card = Util.Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Theme.BackgroundSec,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    Util.Corner(card, UDim.new(0, 10))
    Util.Stroke(card, typeColor, 1, 0.4)

    local accent = Util.Create("Frame", {
        Name = "Accent",
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = typeColor,
        BorderSizePixel = 0,
        Parent = card,
    })
    Util.Corner(accent, UDim.new(0, 4))

    local titleLabel = Util.Create("TextLabel", {
        Name = "Title",
        Text = title,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        Font = Config.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })

    local descLabel = Util.Create("TextLabel", {
        Name = "Desc",
        Text = desc,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 14, 0, 30),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Config.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = card,
    })

    -- progress bar
    local bar = Util.Create("Frame", {
        Name = "ProgressBar",
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, -2),
        BackgroundColor3 = typeColor,
        BorderSizePixel = 0,
        Parent = card,
    })

    card.Position = UDim2.new(0, 20, 0, 0)
    card.BackgroundTransparency = 1
    Util.Tween(card, { BackgroundTransparency = 0.05 }, 0.3)
    Util.Tween(card.Position ~= nil and card or card, {}, 0)  -- dummy

    Util.Tween(bar, { Size = UDim2.new(0, 0, 0, 2) }, dur, Enum.EasingStyle.Linear)

    task.delay(dur, function()
        Util.Tween(card, { BackgroundTransparency = 1 }, 0.3)
        task.wait(0.35)
        card:Destroy()
    end)

    return card
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Main Library
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local SyuHub = {}
SyuHub.__index = SyuHub

SyuHub.Flags       = {}
SyuHub.Theme       = Theme
SyuHub.Config      = Config
SyuHub.Notification = SendNotification

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  CreateWindow
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function SyuHub:CreateWindow(opts)
    opts = opts or {}
    local Title    = opts.Title    or "Syu_hub"
    local SubTitle = opts.SubTitle or "v1.0"
    local LoadingTitle = opts.LoadingTitle or Title

    -- ScreenGui
    local gui = Util.Create("ScreenGui", {
        Name = "SyuHub_" .. Title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then gui.Parent = LocalPlayer.PlayerGui end

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  最小化ピル（Rayfield-style pill）
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local Pill = Util.Create("Frame", {
        Name = "MinimizedPill",
        Size = UDim2.new(0, Config.PillWidth, 0, Config.PillHeight),
        Position = UDim2.new(0.5, -(Config.PillWidth / 2), 0, 6),
        AnchorPoint = Vector2.new(0, 0),
        BackgroundColor3 = Theme.PillBackground,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 20,
        Parent = gui,
    })
    Util.Corner(Pill, UDim.new(0, Config.PillHeight / 2))
    Util.Stroke(Pill, Theme.PillBorder, 1, 0)

    local PillGlow = Util.Create("Frame", {
        Name = "PillGlow",
        Size = UDim2.new(1, 6, 1, 6),
        Position = UDim2.new(0, -3, 0, -3),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        ZIndex = 19,
        Parent = Pill,
    })
    Util.Corner(PillGlow, UDim.new(0, (Config.PillHeight + 6) / 2))

    local PillDot = Util.Create("Frame", {
        Name = "Dot",
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0, 10, 0.5, -4),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 21,
        Parent = Pill,
    })
    Util.Corner(PillDot, UDim.new(0, 4))

    local PillLabel = Util.Create("TextLabel", {
        Name = "Label",
        Text = "Syu_hub",
        Size = UDim2.new(1, -32, 1, 0),
        Position = UDim2.new(0, 26, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.PillText,
        TextSize = 13,
        Font = Config.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
        Parent = Pill,
    })

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  メインウィンドウ
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local MainFrame = Util.Create("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, Config.WindowWidth, 0, Config.WindowHeight),
        Position = UDim2.new(0.5, -(Config.WindowWidth / 2), 0.5, -(Config.WindowHeight / 2)),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        ZIndex = 10,
        Parent = gui,
    })
    Util.Corner(MainFrame)
    Util.Stroke(MainFrame, Theme.Border, 1, 0)

    -- ウィンドウ背景グラデーション（疑似）
    local BgTop = Util.Create("Frame", {
        Name = "BgTop",
        Size = UDim2.new(1, 0, 0, 120),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.9,
        BorderSizePixel = 0,
        ZIndex = 10,
        Parent = MainFrame,
    })
    Util.Corner(BgTop)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  ヘッダー
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local Header = Util.Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, Config.HeaderHeight),
        BackgroundTransparency = 1,
        ZIndex = 11,
        Parent = MainFrame,
    })

    local LogoFrame = Util.Create("Frame", {
        Name = "LogoFrame",
        Size = UDim2.new(0, 32, 0, 32),
        Position = UDim2.new(0, 12, 0.5, -16),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = Header,
    })
    Util.Corner(LogoFrame, UDim.new(0, 8))

    local LogoText = Util.Create("TextLabel", {
        Name = "LogoText",
        Text = "S",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Config.FontBold,
        ZIndex = 13,
        Parent = LogoFrame,
    })

    local TitleLabel = Util.Create("TextLabel", {
        Name = "Title",
        Text = Title,
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 52, 0, 8),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextPrimary,
        TextSize = 15,
        Font = Config.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
        Parent = Header,
    })

    local SubLabel = Util.Create("TextLabel", {
        Name = "SubTitle",
        Text = SubTitle,
        Size = UDim2.new(0, 200, 0, 16),
        Position = UDim2.new(0, 52, 0, 28),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMuted,
        TextSize = 11,
        Font = Config.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 12,
        Parent = Header,
    })

    -- 右側ボタン群
    local HeaderButtons = Util.Create("Frame", {
        Name = "HeaderButtons",
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -80, 0.5, -15),
        BackgroundTransparency = 1,
        ZIndex = 12,
        Parent = Header,
    })
    Util.ListLayout(HeaderButtons, Enum.FillDirection.Horizontal, 6)

    -- 設定ボタン（📡）
    local SettingsBtn = Util.Create("TextButton", {
        Name = "SettingsBtn",
        Text = "⚙",
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Theme.BackgroundTer,
        BorderSizePixel = 0,
        TextColor3 = Theme.TextSecondary,
        TextSize = 14,
        Font = Config.Font,
        ZIndex = 13,
        Parent = HeaderButtons,
    })
    Util.Corner(SettingsBtn, UDim.new(0, 8))

    -- 最小化ボタン（×）
    local MinimizeBtn = Util.Create("TextButton", {
        Name = "MinimizeBtn",
        Text = "❌",
        Size = UDim2.new(0, 30, 0, 30),
        BackgroundColor3 = Theme.BackgroundTer,
        BorderSizePixel = 0,
        TextColor3 = Theme.TextSecondary,
        TextSize = 11,
        Font = Config.Font,
        ZIndex = 13,
        Parent = HeaderButtons,
    })
    Util.Corner(MinimizeBtn, UDim.new(0, 8))

    -- ヘッダー区切り線
    local HeaderLine = Util.Create("Frame", {
        Name = "HeaderLine",
        Size = UDim2.new(1, -24, 0, 1),
        Position = UDim2.new(0, 12, 0, Config.HeaderHeight - 1),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = MainFrame,
    })

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  コンテンツエリア（タブバー + タブ内容）
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local ContentArea = Util.Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, 0, 1, -(Config.HeaderHeight + Config.DragBarHeight)),
        Position = UDim2.new(0, 0, 0, Config.HeaderHeight),
        BackgroundTransparency = 1,
        ZIndex = 11,
        Parent = MainFrame,
    })

    -- タブサイドバー
    local TabBar = Util.Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(0, Config.TabWidth, 1, 0),
        BackgroundColor3 = Theme.BackgroundSec,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = ContentArea,
    })
    Util.Corner(TabBar, UDim.new(0, 0))
    local tabBarStroke = Util.Stroke(TabBar, Theme.Border, 1, 0)

    -- タブバー下部のラウンド
    local TabBarBotLeft = Util.Create("Frame", {
        Name = "TabBarBotLeft",
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Theme.BackgroundSec,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = ContentArea,
    })
    Util.Corner(TabBarBotLeft, UDim.new(0, 12))

    local TabList = Util.Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 13,
        Parent = TabBar,
    })
    Util.ListLayout(TabList, Enum.FillDirection.Vertical, 4)
    Util.Padding(TabList, 0, 6, 0, 6)

    -- タブコンテンツエリア
    local TabContent = Util.Create("Frame", {
        Name = "TabContent",
        Size = UDim2.new(1, -(Config.TabWidth + 1), 1, 0),
        Position = UDim2.new(0, Config.TabWidth + 1, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 12,
        Parent = ContentArea,
    })

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  ドラッグバー（下）
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local DragBar = Util.Create("Frame", {
        Name = "DragBar",
        Size = UDim2.new(1, 0, 0, Config.DragBarHeight),
        Position = UDim2.new(0, 0, 1, -Config.DragBarHeight),
        BackgroundColor3 = Theme.DragBar,
        BorderSizePixel = 0,
        ZIndex = 15,
        Parent = MainFrame,
    })
    Util.Corner(DragBar, UDim.new(0, 10))

    -- ドラッグバー上部を四角にする（下半分のみ丸め）
    local DragBarTopFill = Util.Create("Frame", {
        Name = "DragBarTopFill",
        Size = UDim2.new(1, 0, 0, 14),
        BackgroundColor3 = Theme.DragBar,
        BorderSizePixel = 0,
        ZIndex = 15,
        Parent = DragBar,
    })

    local DragBarLine = Util.Create("Frame", {
        Name = "DragBarLine",
        Size = UDim2.new(0, 40, 0, 3),
        Position = UDim2.new(0.5, -20, 0.5, -1),
        BackgroundColor3 = Theme.BorderLight,
        BorderSizePixel = 0,
        ZIndex = 16,
        Parent = DragBar,
    })
    Util.Corner(DragBarLine, UDim.new(0, 3))

    local DragBarText = Util.Create("TextLabel", {
        Name = "DragBarText",
        Text = "⠿  ドラッグして移動",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMuted,
        TextSize = 10,
        Font = Config.Font,
        ZIndex = 16,
        Parent = DragBar,
    })

    -- ドラッグ可能にする
    Util.MakeDraggable(DragBar, MainFrame)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  設定パネル
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local SettingsPanel = Util.Create("Frame", {
        Name = "SettingsPanel",
        Size = UDim2.new(1, -40, 1, -(Config.HeaderHeight + Config.DragBarHeight + 20)),
        Position = UDim2.new(0, 20, 0, Config.HeaderHeight + 10),
        BackgroundColor3 = Theme.BackgroundSec,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 20,
        Parent = MainFrame,
    })
    Util.Corner(SettingsPanel)
    Util.Stroke(SettingsPanel, Theme.Border, 1, 0)
    Util.Padding(SettingsPanel, 14, 14, 14, 14)

    local SettingsTitle = Util.Create("TextLabel", {
        Name = "Title",
        Text = "⚙  設定",
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextPrimary,
        TextSize = 14,
        Font = Config.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 21,
        Parent = SettingsPanel,
    })

    local SettingsLine = Util.Create("Frame", {
        Name = "Line",
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0, 32),
        BackgroundColor3 = Theme.Border,
        BorderSizePixel = 0,
        ZIndex = 21,
        Parent = SettingsPanel,
    })

    local SettingsScroll = Util.Create("ScrollingFrame", {
        Name = "SettingsScroll",
        Size = UDim2.new(1, 0, 1, -44),
        Position = UDim2.new(0, 0, 0, 44),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 21,
        Parent = SettingsPanel,
    })
    Util.ListLayout(SettingsScroll, Enum.FillDirection.Vertical, 10)

    local SettingsCloseBtn = Util.Create("TextButton", {
        Name = "CloseBtn",
        Text = "✕  閉じる",
        Size = UDim2.new(0, 90, 0, 28),
        Position = UDim2.new(1, -94, 0, 2),
        BackgroundColor3 = Theme.BackgroundTer,
        BorderSizePixel = 0,
        TextColor3 = Theme.TextSecondary,
        TextSize = 12,
        Font = Config.Font,
        ZIndex = 22,
        Parent = SettingsPanel,
    })
    Util.Corner(SettingsCloseBtn, UDim.new(0, 7))

    -- 設定パネルにデフォルト項目を追加
    local function AddSettingsItem(labelText, descText)
        local row = Util.Create("Frame", {
            Name = "SettingsRow",
            Size = UDim2.new(1, 0, 0, 48),
            BackgroundColor3 = Theme.BackgroundTer,
            BorderSizePixel = 0,
            ZIndex = 22,
            Parent = SettingsScroll,
        })
        Util.Corner(row, UDim.new(0, 8))
        Util.Padding(row, 0, 12, 0, 12)

        Util.Create("TextLabel", {
            Name = "Label",
            Text = labelText,
            Size = UDim2.new(1, -60, 0, 20),
            Position = UDim2.new(0, 0, 0, 6),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextPrimary,
            TextSize = 13,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 23,
            Parent = row,
        })

        Util.Create("TextLabel", {
            Name = "Desc",
            Text = descText or "",
            Size = UDim2.new(1, -60, 0, 14),
            Position = UDim2.new(0, 0, 0, 28),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextMuted,
            TextSize = 10,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 23,
            Parent = row,
        })

        return row
    end

    AddSettingsItem("UIテーマ", "デフォルト: ダーク (将来変更可能)")
    AddSettingsItem("アクセントカラー", "現在: パープル")
    AddSettingsItem("アニメーション速度", "0.25秒 (デフォルト)")
    AddSettingsItem("通知の表示", "有効 (デフォルト)")
    AddSettingsItem("フォントスタイル", "Gotham Medium")

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  ボタンイベント：設定
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local settingsOpen = false
    SettingsBtn.MouseButton1Click:Connect(function()
        settingsOpen = not settingsOpen
        SettingsPanel.Visible = settingsOpen
        if settingsOpen then
            SettingsPanel.BackgroundTransparency = 1
            Util.Tween(SettingsPanel, { BackgroundTransparency = 0 }, 0.2)
        end
    end)

    SettingsCloseBtn.MouseButton1Click:Connect(function()
        settingsOpen = false
        SettingsPanel.Visible = false
    end)

    -- ボタンホバーエフェクト
    for _, btn in ipairs({ SettingsBtn, MinimizeBtn, SettingsCloseBtn }) do
        btn.MouseEnter:Connect(function()
            Util.Tween(btn, { BackgroundColor3 = Theme.BackgroundSec }, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Util.Tween(btn, { BackgroundColor3 = Theme.BackgroundTer }, 0.15)
        end)
    end

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  最小化 / 展開ロジック
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local minimized = false

    local function Minimize()
        minimized = true
        settingsOpen = false
        SettingsPanel.Visible = false
        Util.Tween(MainFrame, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 }, Config.AnimSpeed)
        task.wait(Config.AnimSpeed)
        MainFrame.Visible = false
        Pill.Visible = true
        Pill.Size = UDim2.new(0, 0, 0, Config.PillHeight)
        Pill.BackgroundTransparency = 1
        Util.Tween(Pill, { Size = UDim2.new(0, Config.PillWidth, 0, Config.PillHeight), BackgroundTransparency = 0 }, Config.AnimSpeed)
    end

    local function Expand()
        minimized = false
        Util.Tween(Pill, { Size = UDim2.new(0, 0, 0, Config.PillHeight), BackgroundTransparency = 1 }, Config.AnimSpeed - 0.05)
        task.wait(Config.AnimSpeed - 0.05)
        Pill.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.BackgroundTransparency = 1
        Util.Tween(MainFrame, {
            Size = UDim2.new(0, Config.WindowWidth, 0, Config.WindowHeight),
            BackgroundTransparency = 0,
        }, Config.AnimSpeed)
    end

    MinimizeBtn.MouseButton1Click:Connect(Minimize)

    Pill.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            Expand()
        end
    end)

    Pill.MouseEnter:Connect(function()
        Util.Tween(Pill, { BackgroundColor3 = Theme.BackgroundTer }, 0.15)
        Util.Tween(PillGlow, { BackgroundTransparency = 0.75 }, 0.15)
    end)
    Pill.MouseLeave:Connect(function()
        Util.Tween(Pill, { BackgroundColor3 = Theme.PillBackground }, 0.15)
        Util.Tween(PillGlow, { BackgroundTransparency = 0.85 }, 0.15)
    end)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  Tab管理
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local Tabs = {}
    local ActiveTab = nil

    local Window = {}
    Window._gui         = gui
    Window._mainFrame   = MainFrame
    Window._pill        = Pill
    Window._settings    = SettingsPanel
    Window._settingsScroll = SettingsScroll

    function Window:AddSettingRow(label, desc)
        return AddSettingsItem(label, desc)
    end

    function Window:Notify(opts)
        return SendNotification(opts)
    end

    function Window:Minimize()
        Minimize()
    end

    function Window:Expand()
        Expand()
    end

    function Window:Destroy()
        gui:Destroy()
    end

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  CreateTab
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    function Window:CreateTab(name, icon)
        -- サイドバーボタン
        local tabBtn = Util.Create("TextButton", {
            Name = "Tab_" .. name,
            Text = "",
            Size = UDim2.new(1, 0, 0, 36),
            BackgroundColor3 = Theme.BackgroundTer,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 14,
            Parent = TabList,
        })
        Util.Corner(tabBtn, UDim.new(0, 8))

        local tabBtnLayout = Util.Create("Frame", {
            Name = "Layout",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ZIndex = 14,
            Parent = tabBtn,
        })
        Util.Padding(tabBtnLayout, 0, 0, 0, 8)

        local tabAccent = Util.Create("Frame", {
            Name = "Accent",
            Size = UDim2.new(0, 3, 0, 18),
            Position = UDim2.new(0, 0, 0.5, -9),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 15,
            Parent = tabBtn,
        })
        Util.Corner(tabAccent, UDim.new(0, 2))

        local tabIcon = Util.Create("TextLabel", {
            Name = "Icon",
            Text = icon or "☰",
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextMuted,
            TextSize = 13,
            Font = Config.Font,
            ZIndex = 15,
            Parent = tabBtn,
        })

        local tabLabel = Util.Create("TextLabel", {
            Name = "Label",
            Text = name,
            Size = UDim2.new(1, -34, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextMuted,
            TextSize = 12,
            Font = Config.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15,
            Parent = tabBtn,
        })

        -- スクロールビュー（タブコンテンツ）
        local tabPage = Util.Create("ScrollingFrame", {
            Name = "Page_" .. name,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme.Accent,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            ZIndex = 13,
            Parent = TabContent,
        })
        Util.ListLayout(tabPage, Enum.FillDirection.Vertical, 8)
        Util.Padding(tabPage, 10, 10, 10, 10)

        -- タブ選択関数
        local function SelectTab()
            if ActiveTab then
                -- 前のタブを非アクティブ化
                Util.Tween(ActiveTab._btn, { BackgroundTransparency = 1 }, 0.15)
                Util.Tween(ActiveTab._accent, { BackgroundTransparency = 1 }, 0.15)
                Util.Tween(ActiveTab._label, { TextColor3 = Theme.TextMuted }, 0.15)
                Util.Tween(ActiveTab._icon, { TextColor3 = Theme.TextMuted }, 0.15)
                ActiveTab._page.Visible = false
            end

            ActiveTab = { _btn = tabBtn, _accent = tabAccent, _label = tabLabel, _icon = tabIcon, _page = tabPage }

            Util.Tween(tabBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.BackgroundTer }, 0.15)
            Util.Tween(tabAccent, { BackgroundTransparency = 0 }, 0.15)
            Util.Tween(tabLabel, { TextColor3 = Theme.TextPrimary }, 0.15)
            Util.Tween(tabIcon, { TextColor3 = Theme.AccentLight }, 0.15)
            tabPage.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(SelectTab)

        tabBtn.MouseEnter:Connect(function()
            if ActiveTab and ActiveTab._btn ~= tabBtn then
                Util.Tween(tabBtn, { BackgroundTransparency = 0.6 }, 0.12)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if ActiveTab and ActiveTab._btn ~= tabBtn then
                Util.Tween(tabBtn, { BackgroundTransparency = 1 }, 0.12)
            end
        end)

        -- 最初のタブを自動選択
        if #Tabs == 0 then
            SelectTab()
        end

        table.insert(Tabs, { name = name, btn = tabBtn, page = tabPage })

        -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        --  Tab Object (コンポーネント追加API)
        -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

        local Tab = {}
        Tab._page = tabPage

        -- ラベル
        function Tab:CreateLabel(opts)
            opts = opts or {}
            local label = Util.Create("TextLabel", {
                Name = "Label",
                Text = opts.Name or "Label",
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextColor3 = opts.Color or Theme.TextSecondary,
                TextSize = opts.Size or 12,
                Font = opts.Bold and Config.FontBold or Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 14,
                Parent = tabPage,
            })
            Util.Padding(label, 0, 0, 0, 4)
            return label
        end

        -- セパレーター
        function Tab:CreateSeparator()
            local sep = Util.Create("Frame", {
                Name = "Separator",
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = tabPage,
            })
            return sep
        end

        -- ボタン
        function Tab:CreateButton(opts)
            opts = opts or {}
            local container = Util.Create("Frame", {
                Name = "ButtonContainer",
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.BackgroundSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = tabPage,
            })
            Util.Corner(container, UDim.new(0, 8))
            Util.Padding(container, 0, 10, 0, 12)

            local label = Util.Create("TextLabel", {
                Name = "Label",
                Text = opts.Name or "ボタン",
                Size = UDim2.new(1, -90, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = container,
            })

            if opts.Description then
                container.Size = UDim2.new(1, 0, 0, 56)
                label.Size = UDim2.new(1, -90, 0, 18)
                label.Position = UDim2.new(0, 0, 0, 8)
                Util.Create("TextLabel", {
                    Name = "Desc",
                    Text = opts.Description,
                    Size = UDim2.new(1, -90, 0, 14),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 10,
                    Font = Config.Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 15,
                    Parent = container,
                })
            end

            local btn = Util.Create("TextButton", {
                Name = "Btn",
                Text = opts.ButtonText or "実行",
                Size = UDim2.new(0, 70, 0, 28),
                Position = UDim2.new(1, -70, 0.5, -14),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                Font = Config.Font,
                ZIndex = 15,
                Parent = container,
            })
            Util.Corner(btn, UDim.new(0, 7))

            btn.MouseButton1Click:Connect(function()
                Util.Tween(btn, { BackgroundColor3 = Theme.AccentDark, Size = UDim2.new(0, 66, 0, 26), Position = UDim2.new(1, -68, 0.5, -13) }, 0.07)
                task.wait(0.07)
                Util.Tween(btn, { BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 70, 0, 28), Position = UDim2.new(1, -70, 0.5, -14) }, 0.12)
                if opts.Callback then
                    task.spawn(opts.Callback)
                end
            end)

            btn.MouseEnter:Connect(function()
                Util.Tween(btn, { BackgroundColor3 = Theme.AccentLight }, 0.12)
            end)
            btn.MouseLeave:Connect(function()
                Util.Tween(btn, { BackgroundColor3 = Theme.Accent }, 0.12)
            end)

            if opts.Flag then
                SyuHub.Flags[opts.Flag] = { Type = "Button", Element = btn }
            end

            return container
        end

        -- トグル
        function Tab:CreateToggle(opts)
            opts = opts or {}
            local value = opts.CurrentValue or false

            local container = Util.Create("Frame", {
                Name = "ToggleContainer",
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.BackgroundSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = tabPage,
            })
            Util.Corner(container, UDim.new(0, 8))
            Util.Padding(container, 0, 10, 0, 12)

            local label = Util.Create("TextLabel", {
                Name = "Label",
                Text = opts.Name or "トグル",
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = container,
            })

            if opts.Description then
                container.Size = UDim2.new(1, 0, 0, 56)
                label.Size = UDim2.new(1, -60, 0, 18)
                label.Position = UDim2.new(0, 0, 0, 8)
                Util.Create("TextLabel", {
                    Name = "Desc",
                    Text = opts.Description,
                    Size = UDim2.new(1, -60, 0, 14),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.TextMuted,
                    TextSize = 10,
                    Font = Config.Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 15,
                    Parent = container,
                })
            end

            -- トグルスイッチ外枠
            local toggleTrack = Util.Create("Frame", {
                Name = "Track",
                Size = UDim2.new(0, 42, 0, 24),
                Position = UDim2.new(1, -42, 0.5, -12),
                BackgroundColor3 = value and Theme.ToggleOn or Theme.ToggleOff,
                BorderSizePixel = 0,
                ZIndex = 15,
                Parent = container,
            })
            Util.Corner(toggleTrack, UDim.new(0, 12))

            local toggleKnob = Util.Create("Frame", {
                Name = "Knob",
                Size = UDim2.new(0, 18, 0, 18),
                Position = value and UDim2.new(0, 21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Theme.ToggleKnob,
                BorderSizePixel = 0,
                ZIndex = 16,
                Parent = toggleTrack,
            })
            Util.Corner(toggleKnob, UDim.new(0, 9))

            -- クリック領域
            local clickArea = Util.Create("TextButton", {
                Name = "ClickArea",
                Text = "",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ZIndex = 17,
                Parent = container,
            })

            local function SetValue(v)
                value = v
                Util.Tween(toggleTrack, { BackgroundColor3 = v and Theme.ToggleOn or Theme.ToggleOff }, 0.18)
                Util.Tween(toggleKnob, { Position = v and UDim2.new(0, 21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.18)
                if opts.Flag then
                    SyuHub.Flags[opts.Flag] = { Type = "Toggle", Value = v, Element = toggleTrack }
                end
                if opts.Callback then
                    task.spawn(opts.Callback, v)
                end
            end

            clickArea.MouseButton1Click:Connect(function()
                SetValue(not value)
            end)

            if opts.Flag then
                SyuHub.Flags[opts.Flag] = { Type = "Toggle", Value = value, Element = toggleTrack, Set = SetValue }
            end

            local ToggleObj = {}
            function ToggleObj:Set(v) SetValue(v) end
            function ToggleObj:Get() return value end
            return ToggleObj
        end

        -- スライダー
        function Tab:CreateSlider(opts)
            opts = opts or {}
            local range   = opts.Range     or { 0, 100 }
            local inc     = opts.Increment or 1
            local current = opts.CurrentValue or range[1]

            local container = Util.Create("Frame", {
                Name = "SliderContainer",
                Size = UDim2.new(1, 0, 0, 56),
                BackgroundColor3 = Theme.BackgroundSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = tabPage,
            })
            Util.Corner(container, UDim.new(0, 8))
            Util.Padding(container, 0, 10, 0, 12)

            local topRow = Util.Create("Frame", {
                Name = "TopRow",
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, 8),
                BackgroundTransparency = 1,
                ZIndex = 15,
                Parent = container,
            })

            Util.Create("TextLabel", {
                Name = "Label",
                Text = opts.Name or "スライダー",
                Size = UDim2.new(1, -50, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = topRow,
            })

            local valueLabel = Util.Create("TextLabel", {
                Name = "Value",
                Text = tostring(current),
                Size = UDim2.new(0, 46, 1, 0),
                Position = UDim2.new(1, -46, 0, 0),
                BackgroundColor3 = Theme.BackgroundTer,
                TextColor3 = Theme.AccentLight,
                TextSize = 12,
                Font = Config.FontBold,
                ZIndex = 15,
                Parent = topRow,
            })
            Util.Corner(valueLabel, UDim.new(0, 6))

            -- スライダートラック
            local track = Util.Create("Frame", {
                Name = "Track",
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 0, 38),
                BackgroundColor3 = Theme.BackgroundTer,
                BorderSizePixel = 0,
                ZIndex = 15,
                Parent = container,
            })
            Util.Corner(track, UDim.new(0, 3))

            local fill = Util.Create("Frame", {
                Name = "Fill",
                Size = UDim2.new((current - range[1]) / (range[2] - range[1]), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 16,
                Parent = track,
            })
            Util.Corner(fill, UDim.new(0, 3))

            local knob = Util.Create("Frame", {
                Name = "Knob",
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new((current - range[1]) / (range[2] - range[1]), -7, 0.5, -7),
                BackgroundColor3 = Theme.AccentLight,
                BorderSizePixel = 0,
                ZIndex = 17,
                Parent = track,
            })
            Util.Corner(knob, UDim.new(0, 7))
            Util.Stroke(knob, Color3.fromRGB(255, 255, 255), 1, 0.6)

            -- ドラッグ処理
            local draggingSlider = false

            local function UpdateSlider(inputX)
                local trackPos   = track.AbsolutePosition.X
                local trackWidth = track.AbsoluteSize.X
                local rel = math.clamp((inputX - trackPos) / trackWidth, 0, 1)
                local rawVal = range[1] + rel * (range[2] - range[1])
                local stepped = math.round(rawVal / inc) * inc
                stepped = math.clamp(stepped, range[1], range[2])
                local ratio = (stepped - range[1]) / (range[2] - range[1])
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                knob.Position = UDim2.new(ratio, -7, 0.5, -7)
                valueLabel.Text = tostring(stepped)
                current = stepped
                if opts.Flag then
                    SyuHub.Flags[opts.Flag] = { Type = "Slider", Value = stepped }
                end
                if opts.Callback then
                    task.spawn(opts.Callback, stepped)
                end
            end

            track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    UpdateSlider(input.Position.X)
                end
            end)

            UserInput.InputChanged:Connect(function(input)
                if draggingSlider and (
                    input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
                ) then
                    UpdateSlider(input.Position.X)
                end
            end)

            UserInput.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = false
                end
            end)

            if opts.Flag then
                SyuHub.Flags[opts.Flag] = { Type = "Slider", Value = current }
            end

            local SliderObj = {}
            function SliderObj:Set(v)
                v = math.clamp(v, range[1], range[2])
                local ratio = (v - range[1]) / (range[2] - range[1])
                fill.Size = UDim2.new(ratio, 0, 1, 0)
                knob.Position = UDim2.new(ratio, -7, 0.5, -7)
                valueLabel.Text = tostring(v)
                current = v
            end
            function SliderObj:Get() return current end
            return SliderObj
        end

        -- テキストボックス
        function Tab:CreateTextBox(opts)
            opts = opts or {}
            local container = Util.Create("Frame", {
                Name = "TextBoxContainer",
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = Theme.BackgroundSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = tabPage,
            })
            Util.Corner(container, UDim.new(0, 8))
            Util.Padding(container, 0, 10, 0, 12)

            Util.Create("TextLabel", {
                Name = "Label",
                Text = opts.Name or "テキスト入力",
                Size = UDim2.new(1, 0, 0, 16),
                Position = UDim2.new(0, 0, 0, 6),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPrimary,
                TextSize = 12,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = container,
            })

            local box = Util.Create("TextBox", {
                Name = "Input",
                PlaceholderText = opts.Placeholder or "入力してください...",
                Text = opts.Default or "",
                Size = UDim2.new(1, 0, 0, 24),
                Position = UDim2.new(0, 0, 0, 24),
                BackgroundColor3 = Theme.BackgroundTer,
                BorderSizePixel = 0,
                TextColor3 = Theme.TextPrimary,
                PlaceholderColor3 = Theme.TextMuted,
                TextSize = 12,
                Font = Config.Font,
                ClearTextOnFocus = opts.ClearOnFocus ~= false,
                ZIndex = 15,
                Parent = container,
            })
            Util.Corner(box, UDim.new(0, 6))
            Util.Padding(box, 0, 6, 0, 8)

            box.Focused:Connect(function()
                Util.Stroke(box, Theme.Accent, 1, 0)
            end)
            box.FocusLost:Connect(function(enter)
                pcall(function()
                    for _, s in ipairs(box:GetChildren()) do
                        if s:IsA("UIStroke") then s:Destroy() end
                    end
                end)
                if opts.Callback then
                    task.spawn(opts.Callback, box.Text, enter)
                end
                if opts.Flag then
                    SyuHub.Flags[opts.Flag] = { Type = "TextBox", Value = box.Text }
                end
            end)

            local TBObj = {}
            function TBObj:Set(v) box.Text = v end
            function TBObj:Get() return box.Text end
            return TBObj
        end

        -- ドロップダウン
        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local options  = opts.Options or {}
            local selected = opts.CurrentOption or (options[1] or "選択してください")
            local isOpen   = false

            local container = Util.Create("Frame", {
                Name = "DropdownContainer",
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundColor3 = Theme.BackgroundSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = tabPage,
                ClipsDescendants = false,
            })
            Util.Corner(container, UDim.new(0, 8))
            Util.Padding(container, 0, 10, 0, 12)

            Util.Create("TextLabel", {
                Name = "Label",
                Text = opts.Name or "ドロップダウン",
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPrimary,
                TextSize = 13,
                Font = Config.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = container,
            })

            local display = Util.Create("TextButton", {
                Name = "Display",
                Text = selected .. "  ▾",
                Size = UDim2.new(0, 130, 0, 28),
                Position = UDim2.new(1, -130, 0.5, -14),
                BackgroundColor3 = Theme.BackgroundTer,
                BorderSizePixel = 0,
                TextColor3 = Theme.TextSecondary,
                TextSize = 12,
                Font = Config.Font,
                ZIndex = 15,
                Parent = container,
            })
            Util.Corner(display, UDim.new(0, 7))

            -- ドロップダウンリスト
            local dropList = Util.Create("Frame", {
                Name = "DropList",
                Size = UDim2.new(0, 130, 0, 0),
                Position = UDim2.new(1, -130, 0, 36),
                BackgroundColor3 = Theme.BackgroundSec,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 30,
                Parent = container,
            })
            Util.Corner(dropList, UDim.new(0, 8))
            Util.Stroke(dropList, Theme.Border, 1, 0)
            Util.ListLayout(dropList, Enum.FillDirection.Vertical, 2)
            Util.Padding(dropList, 4, 4, 4, 4)

            local function CloseDropdown()
                isOpen = false
                Util.Tween(dropList, { Size = UDim2.new(0, 130, 0, 0) }, 0.15)
                task.wait(0.15)
                dropList.Visible = false
            end

            local function BuildOptions()
                for _, child in ipairs(dropList:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, opt in ipairs(options) do
                    local item = Util.Create("TextButton", {
                        Name = "Option_" .. opt,
                        Text = opt,
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = opt == selected and Theme.BackgroundTer or Color3.fromRGB(0,0,0),
                        BackgroundTransparency = opt == selected and 0 or 1,
                        TextColor3 = opt == selected and Theme.TextPrimary or Theme.TextSecondary,
                        TextSize = 12,
                        Font = Config.Font,
                        ZIndex = 31,
                        Parent = dropList,
                    })
                    Util.Corner(item, UDim.new(0, 6))
                    item.MouseButton1Click:Connect(function()
                        selected = opt
                        display.Text = opt .. "  ▾"
                        if opts.Flag then
                            SyuHub.Flags[opts.Flag] = { Type = "Dropdown", Value = opt }
                        end
                        if opts.Callback then
                            task.spawn(opts.Callback, opt)
                        end
                        CloseDropdown()
                        BuildOptions()
                    end)
                end
                dropList.Size = UDim2.new(0, 130, 0, #options * 28 + 8)
            end

            BuildOptions()

            display.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropList.Visible = true
                    dropList.Size = UDim2.new(0, 130, 0, 0)
                    Util.Tween(dropList, { Size = UDim2.new(0, 130, 0, #options * 28 + 8) }, 0.18)
                else
                    CloseDropdown()
                end
            end)

            local DDObj = {}
            function DDObj:Set(v)
                selected = v
                display.Text = v .. "  ▾"
                BuildOptions()
            end
            function DDObj:Get() return selected end
            function DDObj:Refresh(newOpts)
                options = newOpts
                BuildOptions()
            end
            return DDObj
        end

        -- セクションヘッダー（見出し）
        function Tab:CreateSection(opts)
            opts = opts or {}
            local row = Util.Create("Frame", {
                Name = "Section",
                Size = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                ZIndex = 14,
                Parent = tabPage,
            })

            Util.Create("TextLabel", {
                Name = "Title",
                Text = (opts.Name or "セクション"):upper(),
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.Accent,
                TextSize = 10,
                Font = Config.FontBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = row,
            })

            Util.Create("Frame", {
                Name = "Line",
                Size = UDim2.new(0.46, 0, 0, 1),
                Position = UDim2.new(0.54, 0, 0.5, 0),
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                ZIndex = 15,
                Parent = row,
            })

            return row
        end

        return Tab
    end

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  読み込みアニメーション（オープニング）
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    task.wait(0.1)
    Util.Tween(MainFrame, {
        Size = UDim2.new(0, Config.WindowWidth, 0, Config.WindowHeight),
        BackgroundTransparency = 0,
    }, Config.AnimSpeed + 0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- ウェルカム通知
    task.delay(Config.AnimSpeed + 0.3, function()
        SendNotification({
            Title   = "Syu_hub",
            Content = "UIが正常にロードされました！",
            Type    = "Success",
            Duration = 3,
        })
    end)

    return Window
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  グローバル公開
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

return SyuHub

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  使用例（別スクリプトから呼び出す場合）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local SyuHub = require(path_to_module)   -- またはloadstringで取得

local Win = SyuHub:CreateWindow({
    Title    = "Syu_hub",
    SubTitle = "v1.0 by あなた",
})

local Tab1 = Win:CreateTab("メイン", "★")
local Tab2 = Win:CreateTab("設定", "⚙")

Tab1:CreateSection({ Name = "基本機能" })

Tab1:CreateButton({
    Name        = "テストボタン",
    Description = "クリックすると何かが起こる",
    ButtonText  = "実行",
    Flag        = "TestButton",
    Callback = function()
        Win:Notify({ Title = "ボタン", Content = "押されました！", Type = "Info" })
    end,
})

local myToggle = Tab1:CreateToggle({
    Name         = "スピードハック",
    Description  = "移動速度を変更する",
    CurrentValue = false,
    Flag         = "SpeedHack",
    Callback = function(val)
        -- val = true/false
        print("トグル:", val)
    end,
})

local mySlider = Tab1:CreateSlider({
    Name          = "ウォークスピード",
    Range         = { 16, 500 },
    Increment     = 1,
    CurrentValue  = 16,
    Flag          = "WalkSpeed",
    Callback = function(val)
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
        print("スピード:", val)
    end,
})

Tab2:CreateTextBox({
    Name        = "ターゲット名",
    Placeholder = "プレイヤー名を入力...",
    Flag        = "TargetName",
    Callback = function(text)
        print("入力:", text)
    end,
})

Tab2:CreateDropdown({
    Name          = "チームカラー",
    Options       = { "赤", "青", "緑", "黄" },
    CurrentOption = "赤",
    Flag          = "TeamColor",
    Callback = function(opt)
        print("選択:", opt)
    end,
})

-- フラグから値を取得する例
-- print(SyuHub.Flags["WalkSpeed"].Value)
-- print(SyuHub.Flags["SpeedHack"].Value)
-- myToggle:Set(true)
-- mySlider:Set(100)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]
