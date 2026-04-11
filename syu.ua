--[[
╔══════════════════════════════════════════════════════════════════╗
║                                                                  ║
║    ███████╗██╗   ██╗██╗   ██╗    ██╗  ██╗██╗   ██╗██████╗      ║
║    ██╔════╝╚██╗ ██╔╝██║   ██║    ██║  ██║██║   ██║██╔══██╗     ║
║    ███████╗ ╚████╔╝ ██║   ██║    ███████║██║   ██║██████╔╝     ║
║    ╚════██║  ╚██╔╝  ██║   ██║    ██╔══██║██║   ██║██╔══██╗     ║
║    ███████║   ██║   ╚██████╔╝    ██║  ██║╚██████╔╝██████╔╝     ║
║    ╚══════╝   ╚═╝    ╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚═════╝      ║
║                                                                  ║
║                      Version 2.0.0                              ║
║              Sleek Dark • Smooth Animations                     ║
╚══════════════════════════════════════════════════════════════════╝

  使用方法:
      local Syu = loadstring(game:HttpGet("https://raw.githubusercontent.com/syuu06130-alt/UI/main/sub.ua"))()
      local Win = Syu:CreateWindow({ Title = "Syu_hub", SubTitle = "v2.0" })
      local Tab = Win:CreateTab("Main", "★")
      Tab:CreateButton({ Name = "Test", Callback = function() end })

  キーバインド:
      RightControl  → UIを表示/非表示
      RightShift    → UIを最小化/展開
]]

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Services
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Players       = game:GetService("Players")
local UserInput     = game:GetService("UserInputService")
local TweenService  = game:GetService("TweenService")
local RunService    = game:GetService("RunService")
local CoreGui       = game:GetService("CoreGui")
local LocalPlayer   = Players.LocalPlayer

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Theme
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Theme = {
    -- ベース (Obsidian Black)
    BG              = Color3.fromRGB(6,   5,   5),
    BGSec           = Color3.fromRGB(12,  9,   9),
    BGTer           = Color3.fromRGB(20,  13,  13),
    BGHover         = Color3.fromRGB(32,  18,  18),

    -- アクセント (Crimson Red)
    Accent          = Color3.fromRGB(215, 30,  30),
    AccentDark      = Color3.fromRGB(145, 15,  15),
    AccentLight     = Color3.fromRGB(255, 80,  80),
    AccentGlow      = Color3.fromRGB(255, 50,  50),

    -- 2nd アクセント (Deep Ember)
    Cyan            = Color3.fromRGB(255, 130, 60),
    CyanDark        = Color3.fromRGB(185, 70,  20),

    -- テキスト
    TextPri         = Color3.fromRGB(255, 232, 232),
    TextSec         = Color3.fromRGB(180, 140, 140),
    TextMut         = Color3.fromRGB(88,  58,  58),

    -- ボーダー
    Border          = Color3.fromRGB(45,  22,  22),
    BorderBright    = Color3.fromRGB(120, 45,  45),

    -- セマンティック
    Success         = Color3.fromRGB(50,  215, 130),
    Warning         = Color3.fromRGB(255, 190, 60),
    Error           = Color3.fromRGB(240, 60,  60),
    Info            = Color3.fromRGB(255, 100, 100),

    -- Toggle
    TogOn           = Color3.fromRGB(215, 30,  30),
    TogOff          = Color3.fromRGB(38,  18,  18),
    TogKnob         = Color3.fromRGB(255, 255, 255),

    -- Pill / TopBar
    PillBG          = Color3.fromRGB(10,  6,   6),
    PillBorder      = Color3.fromRGB(215, 30,  30),
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Config
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Cfg = {
    W               = 480,
    H               = 320,
    TabW            = 100,
    HeaderH         = 46,
    DragH           = 20,
    Radius          = UDim.new(0, 6),
    AnimSpd         = 0.26,
    SpringStyle     = Enum.EasingStyle.Back,
    QuartOut        = TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    Font            = Enum.Font.GothamMedium,
    FontBold        = Enum.Font.GothamBold,
    FontSemiBold    = Enum.Font.GothamSemibold,
    NotifW          = 260,
    PillW           = 160,
    PillH           = 22,
    CornerSize      = 12,
    CornerThick     = 2,
}

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Utility
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Util = {}

function Util.Tween(obj, props, info)
    local t = TweenService:Create(obj, info or Cfg.QuartOut, props)
    t:Play()
    return t
end

function Util.Spring(obj, props, dur, dampening)
    local info = TweenInfo.new(
        dur or Cfg.AnimSpd,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

function Util.FadeIn(obj, dur)
    obj.BackgroundTransparency = 1
    return Util.Tween(obj, { BackgroundTransparency = 0 }, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
end

function Util.New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then inst[k] = v end
    end
    for _, c in ipairs(children or {}) do c.Parent = inst end
    if props and props.Parent then inst.Parent = props.Parent end
    return inst
end

function Util.Corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = r or Cfg.Radius
    c.Parent = p
    return c
end

function Util.Stroke(p, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color         = col or Theme.Border
    s.Thickness     = thick or 1
    s.Transparency  = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

function Util.Pad(p, t, r, b, l)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop    = UDim.new(0, t or 0)
    pad.PaddingRight  = UDim.new(0, r or 0)
    pad.PaddingBottom = UDim.new(0, b or 0)
    pad.PaddingLeft   = UDim.new(0, l or 0)
    pad.Parent = p
    return pad
end

function Util.List(p, dir, spacing, align)
    local l = Instance.new("UIListLayout")
    l.FillDirection       = dir or Enum.FillDirection.Vertical
    l.Padding             = UDim.new(0, spacing or 0)
    l.HorizontalAlignment = align or Enum.HorizontalAlignment.Left
    l.SortOrder           = Enum.SortOrder.LayoutOrder
    l.Parent = p
    return l
end

-- ドラッグ
function Util.Draggable(handle, target)
    local dragging, start, startPos = false, nil, nil
    handle.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            start     = inp.Position
            startPos  = target.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInput.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - start
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Rippleエフェクト（ボタン押下時の波紋）
function Util.Ripple(parent, x, y)
    local size  = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.2
    local relX  = x - parent.AbsolutePosition.X
    local relY  = y - parent.AbsolutePosition.Y
    local ripple = Util.New("Frame", {
        Name  = "Ripple",
        Size  = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0, relX, 0, relY),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = parent.ZIndex + 5,
        Parent = parent,
    })
    Util.Corner(ripple, UDim.new(0, size / 2))
    Util.Tween(ripple, { Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1 },
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
    task.delay(0.55, function() ripple:Destroy() end)
end

-- コーナーデコレーター（軍事系UI風 L字ブラケット）
function Util.CornerDeco(parent, col, zidx)
    local c   = col   or Theme.Accent
    local z   = zidx  or 11
    local s   = Cfg.CornerSize
    local t   = Cfg.CornerThick
    local defs = {
        -- top-left
        { UDim2.new(0, 0,   0, 0),    UDim2.new(0, s, 0, t) },
        { UDim2.new(0, 0,   0, 0),    UDim2.new(0, t, 0, s) },
        -- top-right
        { UDim2.new(1, -s,  0, 0),    UDim2.new(0, s, 0, t) },
        { UDim2.new(1, -t,  0, 0),    UDim2.new(0, t, 0, s) },
        -- bottom-left
        { UDim2.new(0, 0,   1, -t),   UDim2.new(0, s, 0, t) },
        { UDim2.new(0, 0,   1, -s),   UDim2.new(0, t, 0, s) },
        -- bottom-right
        { UDim2.new(1, -s,  1, -t),   UDim2.new(0, s, 0, t) },
        { UDim2.new(1, -t,  1, -s),   UDim2.new(0, t, 0, s) },
    }
    for _, d in ipairs(defs) do
        Util.New("Frame", {
            Position = d[1], Size = d[2],
            BackgroundColor3 = c,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = z,
            Parent = parent,
        })
    end
end

-- スキャンライン効果
function Util.ScanLines(parent, zidx, spacing, alpha)
    local z  = zidx   or 11
    local sp = spacing or 6
    local a  = alpha   or 0.96
    for i = 0, 80 do
        Util.New("Frame", {
            Position = UDim2.new(0, 0, 0, i * sp),
            Size     = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = a,
            BorderSizePixel = 0,
            ZIndex = z,
            Parent = parent,
        })
    end
end

-- 赤いグロウボーダーライン
function Util.GlowLine(parent, horizontal, col, zidx)
    local c = col or Theme.Accent
    local z = zidx or 12
    local glow = Util.New("Frame", {
        Size     = horizontal and UDim2.new(1, 0, 0, 1) or UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = c,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = z,
        Parent = parent,
    })
    -- グロウ幅
    local outer = Util.New("Frame", {
        Size     = horizontal and UDim2.new(1, 0, 0, 3) or UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = c,
        BackgroundTransparency = 0.72,
        BorderSizePixel = 0,
        ZIndex = z - 1,
        Parent = parent,
    })
    return glow, outer
end
    local glow = Util.New("Frame", {
        Name = "Glow",
        Size  = UDim2.new(1, 12, 1, 12),
        Position = UDim2.new(0, -6, 0, -6),
        BackgroundColor3 = col or Theme.Accent,
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        ZIndex = frame.ZIndex - 1,
        Parent = frame,
    })
    Util.Corner(glow, UDim.new(0, 16))

    local function pulse()
        Util.Tween(glow, { BackgroundTransparency = 0.82 }, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
        task.wait(1.2)
        Util.Tween(glow, { BackgroundTransparency = 0.62 }, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut))
        task.wait(1.2)
    end

    task.spawn(function()
        while glow.Parent do pulse() end
    end)
    return glow
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Notification System (v2)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local NotifGui = Util.New("ScreenGui", {
    Name = "SyuHub_Notif_v2",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
pcall(function() NotifGui.Parent = CoreGui end)
if not NotifGui.Parent then NotifGui.Parent = LocalPlayer.PlayerGui end

local NotifHolder = Util.New("Frame", {
    Name = "Holder",
    Size = UDim2.new(0, Cfg.NotifW, 1, 0),
    Position = UDim2.new(1, -(Cfg.NotifW + 14), 0, 0),
    BackgroundTransparency = 1,
    Parent = NotifGui,
})
Util.List(NotifHolder, Enum.FillDirection.Vertical, 8)
Util.Pad(NotifHolder, 14, 0, 14, 0)

local NotifIcons = {
    Success = "✔",
    Warning = "⚠",
    Error   = "✖",
    Info    = "ℹ",
}

local function SendNotification(opts)
    opts = opts or {}
    local title   = opts.Title    or "Syu_hub"
    local content = opts.Content  or ""
    local dur     = opts.Duration or 4
    local ntype   = opts.Type     or "Info"
    local typeCol = ({ Success = Theme.Success, Warning = Theme.Warning, Error = Theme.Error, Info = Theme.Info })[ntype] or Theme.Info

    -- カード
    local card = Util.New("Frame", {
        Name = "Notif",
        Size = UDim2.new(1, 0, 0, 74),
        BackgroundColor3 = Theme.BGSec,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotifHolder,
    })
    Util.Corner(card, UDim.new(0, 12))
    Util.Stroke(card, typeCol, 1, 0.5)

    -- 左アクセントバー
    Util.New("Frame", {
        Name = "Bar",
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = typeCol,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = card,
    })

    -- アイコン背景
    local iconBg = Util.New("Frame", {
        Name = "IconBG",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(0, 14, 0, 22),
        BackgroundColor3 = typeCol,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = card,
    })
    Util.Corner(iconBg, UDim.new(0, 8))
    Util.New("TextLabel", {
        Text = NotifIcons[ntype] or "ℹ",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = typeCol,
        TextSize = 13,
        Font = Cfg.FontBold,
        ZIndex = 3,
        Parent = iconBg,
    })

    -- タイトル
    Util.New("TextLabel", {
        Text = title,
        Size = UDim2.new(1, -60, 0, 18),
        Position = UDim2.new(0, 52, 0, 12),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextPri,
        TextSize = 14,
        Font = Cfg.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2,
        Parent = card,
    })

    -- 説明
    Util.New("TextLabel", {
        Text = content,
        Size = UDim2.new(1, -62, 0, 28),
        Position = UDim2.new(0, 52, 0, 32),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextSec,
        TextSize = 12,
        Font = Cfg.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        ZIndex = 2,
        Parent = card,
    })

    -- プログレスバー
    local bar = Util.New("Frame", {
        Name = "Progress",
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = typeCol,
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = card,
    })

    -- 入場アニメーション
    card.Position = UDim2.new(0, Cfg.NotifW, 0, 0)
    card.BackgroundTransparency = 0.04
    Util.Tween(card, { Position = UDim2.new(0, 0, 0, 0) }, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
    Util.Tween(bar, { Size = UDim2.new(0, 0, 0, 3) }, TweenInfo.new(dur, Enum.EasingStyle.Linear, Enum.EasingDirection.Out))

    -- 退場
    task.delay(dur, function()
        Util.Tween(card, { Position = UDim2.new(0, Cfg.NotifW + 20, 0, 0), BackgroundTransparency = 1 },
            TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
        task.wait(0.32)
        card:Destroy()
    end)

    return card
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  LoadingScreen
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local function ShowLoadingScreen(gui, titleText, callback)
    local overlay = Util.New("Frame", {
        Name = "LoadingScreen",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Theme.BG,
        BorderSizePixel = 0,
        ZIndex = 100,
        Parent = gui,
    })

    -- ロゴ
    local logoFrame = Util.New("Frame", {
        Name = "Logo",
        Size = UDim2.new(0, 64, 0, 64),
        Position = UDim2.new(0.5, -32, 0.5, -58),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = overlay,
    })
    Util.Corner(logoFrame, UDim.new(0, 16))

    local logoText = Util.New("TextLabel", {
        Text = "S",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 30,
        Font = Cfg.FontBold,
        ZIndex = 102,
        Parent = logoFrame,
    })

    local titleLabel = Util.New("TextLabel", {
        Text = titleText,
        Size = UDim2.new(0, 220, 0, 24),
        Position = UDim2.new(0.5, -110, 0.5, -4),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextPri,
        TextSize = 16,
        Font = Cfg.FontBold,
        ZIndex = 101,
        Parent = overlay,
    })

    local subLabel = Util.New("TextLabel", {
        Text = "読み込み中...",
        Size = UDim2.new(0, 220, 0, 18),
        Position = UDim2.new(0.5, -110, 0.5, 20),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMut,
        TextSize = 11,
        Font = Cfg.Font,
        ZIndex = 101,
        Parent = overlay,
    })

    -- プログレスバー背景
    local barBG = Util.New("Frame", {
        Name = "BarBG",
        Size = UDim2.new(0, 200, 0, 4),
        Position = UDim2.new(0.5, -100, 0.5, 48),
        BackgroundColor3 = Theme.BGTer,
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = overlay,
    })
    Util.Corner(barBG, UDim.new(0, 2))

    local barFill = Util.New("Frame", {
        Name = "BarFill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 102,
        Parent = barBG,
    })
    Util.Corner(barFill, UDim.new(0, 2))

    -- ロゴ登場
    logoFrame.BackgroundTransparency = 1
    Util.Spring(logoFrame, { Size = UDim2.new(0, 64, 0, 64), BackgroundTransparency = 0 }, 0.4)
    task.wait(0.15)

    -- プログレスアニメーション
    Util.Tween(barFill, { Size = UDim2.new(1, 0, 1, 0) }, TweenInfo.new(0.9, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
    task.wait(0.5)
    subLabel.Text = "UIを構築中..."
    task.wait(0.5)
    subLabel.Text = "完了！"
    task.wait(0.25)

    -- フェードアウト
    Util.Tween(overlay, { BackgroundTransparency = 1 }, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
    task.wait(0.38)
    overlay:Destroy()

    if callback then callback() end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  Main Library
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local SyuHub = {}
SyuHub.__index    = SyuHub
SyuHub.Flags      = {}
SyuHub.Theme      = Theme
SyuHub.Config     = Cfg
SyuHub.Notification = SendNotification

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  CreateWindow
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

function SyuHub:CreateWindow(opts)
    opts = opts or {}
    local Title     = opts.Title    or "Syu_hub"
    local SubTitle  = opts.SubTitle or "v2.0"
    local Key       = opts.ToggleKey or Enum.KeyCode.RightControl

    -- ScreenGui
    local gui = Util.New("ScreenGui", {
        Name = "SyuHub_" .. Title,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then gui.Parent = LocalPlayer.PlayerGui end

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  常時表示トグルバー（画面最上部中央）
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local Pill = Util.New("TextButton", {
        Name = "Pill",
        Text = "",
        Size = UDim2.new(0, Cfg.PillW, 0, Cfg.PillH),
        Position = UDim2.new(0.5, -(Cfg.PillW / 2), 0, 0),
        BackgroundColor3 = Theme.BGSec,
        BorderSizePixel = 0,
        Visible = true,
        ZIndex = 50,
        Parent = gui,
    })
    -- 角丸なし（シャープな四角）
    Util.Stroke(Pill, Theme.Accent, 1, 0)

    -- トグルバー：左右の赤ライン
    Util.New("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, ZIndex = 52, Parent = Pill,
    })
    Util.New("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        Position = UDim2.new(1, -4, 0, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, ZIndex = 52, Parent = Pill,
    })

    -- ステータスドット
    local PillDot = Util.New("Frame", {
        Name = "Dot",
        Size = UDim2.new(0, 5, 0, 5),
        Position = UDim2.new(0, 10, 0.5, -2),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 52,
        Parent = Pill,
    })
    Util.Corner(PillDot, UDim.new(0, 3))

    -- タイトル
    Util.New("TextLabel", {
        Text = Title,
        Size = UDim2.new(1, -34, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextSec,
        TextSize = 9,
        Font = Cfg.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 52,
        Parent = Pill,
    })

    -- ▼ トグルインジケーター
    local PillArrow = Util.New("TextLabel", {
        Text = "▼",
        Size = UDim2.new(0, 14, 1, 0),
        Position = UDim2.new(1, -18, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Theme.Accent,
        TextSize = 7,
        Font = Cfg.FontBold,
        ZIndex = 52,
        Parent = Pill,
    })

    -- 下部グロウ（Pillの下から光が垂れる）
    local PillGlow = Util.New("Frame", {
        Size = UDim2.new(1, 4, 0, 8),
        Position = UDim2.new(0, -2, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ZIndex = 49,
        Parent = Pill,
    })
    Util.Corner(PillGlow, UDim.new(0, 3))

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  MainFrame
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local Main = Util.New("Frame", {
        Name = "Main",
        Size = UDim2.new(0, Cfg.W, 0, Cfg.H),
        Position = UDim2.new(0.5, -(Cfg.W / 2), 0.5, -(Cfg.H / 2)),
        BackgroundColor3 = Theme.BG,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        ZIndex = 10,
        Parent = gui,
    })
    Util.Corner(Main, UDim.new(0, 4))
    Util.Stroke(Main, Theme.BorderBright, 1, 0)

    -- 外側レッドグロウ（2重）
    local outerGlow1 = Util.New("Frame", {
        Name = "OuterGlow1",
        Size  = UDim2.new(1, 8, 1, 8),
        Position = UDim2.new(0, -4, 0, -4),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.82,
        BorderSizePixel = 0,
        ZIndex = 9,
        Parent = Main,
    })
    Util.Corner(outerGlow1, UDim.new(0, 8))

    local outerGlow2 = Util.New("Frame", {
        Name = "OuterGlow2",
        Size  = UDim2.new(1, 18, 1, 18),
        Position = UDim2.new(0, -9, 0, -9),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.93,
        BorderSizePixel = 0,
        ZIndex = 8,
        Parent = Main,
    })
    Util.Corner(outerGlow2, UDim.new(0, 12))

    -- スキャンライン（全体）
    Util.ScanLines(Main, 10, 7, 0.965)

    -- コーナーデコレーター
    Util.CornerDeco(Main, Theme.Accent, 20)

    -- (BGデコ省略 - コーナーデコに統一)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  ヘッダー
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local Header = Util.New("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, Cfg.HeaderH),
        BackgroundColor3 = Theme.BGSec,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = Main,
    })
    Util.Corner(Header, UDim.new(0, 4))
    -- 下半角を消す
    Util.New("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Theme.BGSec,
        BorderSizePixel = 0,
        ZIndex = 11,
        Parent = Header,
    })

    -- ヘッダー左側の縦レッドライン（太め）
    Util.New("Frame", {
        Name = "LeftBar",
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 13,
        Parent = Header,
    })

    -- ヘッダー下ボーダーライン（赤グロウ）
    local accentLine = Util.New("Frame", {
        Name = "AccentLine",
        Size = UDim2.new(0, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 14,
        Parent = Header,
    })
    -- グロウ
    Util.New("Frame", {
        Size = UDim2.new(1, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.65,
        BorderSizePixel = 0,
        ZIndex = 13,
        Parent = Header,
    })

    -- タイトル背景タグ（四角いバッジ）
    local TitleTag = Util.New("Frame", {
        Name = "TitleTag",
        Size = UDim2.new(0, 6, 0.7, 0),
        Position = UDim2.new(0, 10, 0.15, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 13,
        Parent = Header,
    })
    Util.Corner(TitleTag, UDim.new(0, 2))

    -- タイトルテキスト
    Util.New("TextLabel", {
        Text = Title,
        Size = UDim2.new(0, 160, 0, 18),
        Position = UDim2.new(0, 22, 0, 7),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextPri,
        TextSize = 13,
        Font = Cfg.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
        Parent = Header,
    })

    Util.New("TextLabel", {
        Text = SubTitle,
        Size = UDim2.new(0, 160, 0, 12),
        Position = UDim2.new(0, 22, 0, 27),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMut,
        TextSize = 9,
        Font = Cfg.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
        Parent = Header,
    })

    -- 右側 システムラベル風テキスト
    Util.New("TextLabel", {
        Text = "[ SYS_ACTIVE ]",
        Size = UDim2.new(0, 120, 0, 12),
        Position = UDim2.new(0.5, -60, 0, 8),
        BackgroundTransparency = 1,
        TextColor3 = Theme.AccentDark,
        TextSize = 8,
        Font = Cfg.Font,
        ZIndex = 13,
        Parent = Header,
    })
    Util.New("TextLabel", {
        Text = "SECURE_CONN ● ONLINE",
        Size = UDim2.new(0, 140, 0, 12),
        Position = UDim2.new(0.5, -70, 0, 22),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMut,
        TextSize = 8,
        Font = Cfg.Font,
        ZIndex = 13,
        Parent = Header,
    })

    -- ヘッダーボタン（右側）
    local HBtns = Util.New("Frame", {
        Name = "HBtns",
        Size = UDim2.new(0, 60, 0, 26),
        Position = UDim2.new(1, -68, 0.5, -13),
        BackgroundTransparency = 1,
        ZIndex = 13,
        Parent = Header,
    })
    Util.List(HBtns, Enum.FillDirection.Horizontal, 4)

    local function MakeHBtn(text, size)
        local btn = Util.New("TextButton", {
            Text = text,
            Size = UDim2.new(0, size or 26, 0, 26),
            BackgroundColor3 = Theme.BGTer,
            BorderSizePixel = 0,
            TextColor3 = Theme.TextSec,
            TextSize = size and 9 or 11,
            Font = Cfg.Font,
            ZIndex = 14,
            ClipsDescendants = true,
            Parent = HBtns,
        })
        Util.Corner(btn, UDim.new(0, 4))
        Util.Stroke(btn, Theme.Border, 1, 0)
        btn.MouseEnter:Connect(function()
            Util.Tween(btn, { BackgroundColor3 = Theme.Accent, TextColor3 = Theme.TextPri })
        end)
        btn.MouseLeave:Connect(function()
            Util.Tween(btn, { BackgroundColor3 = Theme.BGTer, TextColor3 = Theme.TextSec })
        end)
        btn.MouseButton1Down:Connect(function(x, y) Util.Ripple(btn, x, y) end)
        return btn
    end

    local SettingsBtn  = MakeHBtn("⚙", 26)
    local MinimizeBtn  = MakeHBtn("—", 26)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  コンテンツエリア
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local ContentArea = Util.New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, -(Cfg.HeaderH + Cfg.DragH)),
        Position = UDim2.new(0, 0, 0, Cfg.HeaderH),
        BackgroundTransparency = 1,
        ZIndex = 11,
        Parent = Main,
    })

    -- タブサイドバー
    local Sidebar = Util.New("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, Cfg.TabW, 1, 0),
        BackgroundColor3 = Theme.BGSec,
        BorderSizePixel = 0,
        ZIndex = 12,
        Parent = ContentArea,
    })

    -- サイドバー右ボーダー（赤グロウ）
    Util.New("Frame", {
        Name = "SBorderGlow",
        Size = UDim2.new(0, 2, 1, 0),
        Position = UDim2.new(1, -2, 0, 0),
        BackgroundColor3 = Theme.Accent,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 13,
        Parent = Sidebar,
    })
    Util.New("Frame", {
        Name = "SBorder",
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        ZIndex = 14,
        Parent = Sidebar,
    })

    local TabList = Util.New("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(1, 0, 1, -10),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 13,
        Parent = Sidebar,
    })
    Util.List(TabList, Enum.FillDirection.Vertical, 3)
    Util.Pad(TabList, 0, 8, 0, 8)

    -- タブコンテンツ
    local TabContent = Util.New("Frame", {
        Name = "TabContent",
        Size = UDim2.new(1, -(Cfg.TabW + 1), 1, 0),
        Position = UDim2.new(0, Cfg.TabW + 1, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 12,
        Parent = ContentArea,
    })

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  ドラッグバー（下）
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local DragBar = Util.New("Frame", {
        Name = "DragBar",
        Size = UDim2.new(1, 0, 0, Cfg.DragH),
        Position = UDim2.new(0, 0, 1, -Cfg.DragH),
        BackgroundColor3 = Theme.BGSec,
        BorderSizePixel = 0,
        ZIndex = 15,
        Parent = Main,
    })
    Util.Corner(DragBar, UDim.new(0, 4))
    Util.New("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        BackgroundColor3 = Theme.BGSec,
        BorderSizePixel = 0, ZIndex = 15, Parent = DragBar,
    })

    -- ドラッグピル（中央ノッチ）
    local DragPill = Util.New("Frame", {
        Name = "DragPill",
        Size = UDim2.new(0, 28, 0, 3),
        Position = UDim2.new(0.5, -14, 0.5, -1),
        BackgroundColor3 = Theme.BorderBright,
        BorderSizePixel = 0,
        ZIndex = 16,
        Parent = DragBar,
    })
    Util.Corner(DragPill, UDim.new(0, 2))

    -- ドラッグバー上ライン（赤）
    Util.New("Frame", {
        Size = UDim2.new(0.4, 0, 0, 1),
        Position = UDim2.new(0.3, 0, 0, 0),
        BackgroundColor3 = Theme.AccentDark,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
        ZIndex = 16,
        Parent = DragBar,
    })

    Util.Draggable(DragBar, Main)
    Util.Draggable(Header, Main)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  設定パネル
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local SettingsPanel = Util.New("Frame", {
        Name = "Settings",
        Size = UDim2.new(1, -32, 1, -(Cfg.HeaderH + Cfg.DragH + 16)),
        Position = UDim2.new(0, 16, 0, Cfg.HeaderH + 8),
        BackgroundColor3 = Theme.BGSec,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 30,
        Parent = Main,
    })
    Util.Corner(SettingsPanel)
    Util.Stroke(SettingsPanel, Theme.Border, 1, 0)

    local SPad = Util.New("Frame", {
        Name = "Inner",
        Size = UDim2.new(1, -28, 1, -50),
        Position = UDim2.new(0, 14, 0, 50),
        BackgroundTransparency = 1,
        ZIndex = 31,
        Parent = SettingsPanel,
    })

    Util.New("TextLabel", {
        Text = "⚙   Settings",
        Size = UDim2.new(1, -80, 0, 28),
        Position = UDim2.new(0, 16, 0, 10),
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextPri,
        TextSize = 14,
        Font = Cfg.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 31,
        Parent = SettingsPanel,
    })

    local SScroll = Util.New("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 32,
        Parent = SPad,
    })
    Util.List(SScroll, Enum.FillDirection.Vertical, 8)

    local function AddSRow(label, desc)
        local row = Util.New("Frame", {
            Size = UDim2.new(1, 0, 0, 52),
            BackgroundColor3 = Theme.BGTer,
            BorderSizePixel = 0,
            ZIndex = 33,
            Parent = SScroll,
        })
        Util.Corner(row, UDim.new(0, 8))
        Util.Pad(row, 0, 12, 0, 12)
        Util.New("TextLabel", {
            Text = label,
            Size = UDim2.new(1, 0, 0, 18),
            Position = UDim2.new(0, 0, 0, 8),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextPri,
            TextSize = 13,
            Font = Cfg.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 34,
            Parent = row,
        })
        Util.New("TextLabel", {
            Text = desc or "",
            Size = UDim2.new(1, 0, 0, 14),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextMut,
            TextSize = 10,
            Font = Cfg.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 34,
            Parent = row,
        })
        return row
    end

    local SCloseBtn = Util.New("TextButton", {
        Text = "✕",
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, -40, 0, 8),
        BackgroundColor3 = Theme.BGTer,
        BorderSizePixel = 0,
        TextColor3 = Theme.TextSec,
        TextSize = 12,
        Font = Cfg.Font,
        ZIndex = 34,
        Parent = SettingsPanel,
    })
    Util.Corner(SCloseBtn, UDim.new(0, 8))
    SCloseBtn.MouseEnter:Connect(function() Util.Tween(SCloseBtn, { BackgroundColor3 = Theme.Error }) end)
    SCloseBtn.MouseLeave:Connect(function() Util.Tween(SCloseBtn, { BackgroundColor3 = Theme.BGTer }) end)

    AddSRow("Theme", "Dark (default)")
    AddSRow("Accent Color", "Electric Purple #7C5CFF")
    AddSRow("Animation Speed", "0.28s")
    AddSRow("Notifications", "Enabled")
    AddSRow("Font", "Gotham Medium / Bold")
    AddSRow("Toggle Key", tostring(Key))

    -- 設定パネル表示/非表示
    local settingsOpen = false
    SettingsBtn.MouseButton1Click:Connect(function()
        settingsOpen = not settingsOpen
        if settingsOpen then
            SettingsPanel.BackgroundTransparency = 1
            SettingsPanel.Visible = true
            Util.Tween(SettingsPanel, { BackgroundTransparency = 0 }, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        else
            Util.Tween(SettingsPanel, { BackgroundTransparency = 1 }, TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
            task.wait(0.17)
            SettingsPanel.Visible = false
        end
    end)

    SCloseBtn.MouseButton1Click:Connect(function()
        settingsOpen = false
        SettingsPanel.Visible = false
    end)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  最小化 / 展開
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local minimized = false

    local function Minimize()
        minimized = true
        settingsOpen = false
        SettingsPanel.Visible = false
        Util.Tween(Main, { Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1 },
            TweenInfo.new(Cfg.AnimSpd, Enum.EasingStyle.Back, Enum.EasingDirection.In))
        task.wait(Cfg.AnimSpd)
        Main.Visible = false
        -- Pillの色を「閉じている状態」に変更
        Util.Tween(Pill,      { BackgroundColor3 = Theme.BGTer })
        Util.Tween(PillDot,   { BackgroundColor3 = Theme.AccentLight })
        PillArrow.Text = "▲"
        Util.Tween(PillArrow, { TextColor3 = Theme.AccentLight })
    end

    local function Expand()
        minimized = false
        Util.Tween(Pill,      { BackgroundColor3 = Theme.BGSec })
        Util.Tween(PillDot,   { BackgroundColor3 = Theme.Accent })
        PillArrow.Text = "▼"
        Util.Tween(PillArrow, { TextColor3 = Theme.Accent })
        Main.Visible = true
        Main.Size = UDim2.new(0, 0, 0, 0)
        Main.BackgroundTransparency = 1
        Util.Spring(Main, { Size = UDim2.new(0, Cfg.W, 0, Cfg.H), BackgroundTransparency = 0 }, Cfg.AnimSpd + 0.05)
        accentLine.Size = UDim2.new(0, 0, 0, 1)
        task.wait(0.1)
        Util.Tween(accentLine, { Size = UDim2.new(1, 0, 0, 1) },
            TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
    end

    MinimizeBtn.MouseButton1Click:Connect(Minimize)

    -- ★ MouseButton1Click のみ（タッチ誤反応完全防止）
    Pill.MouseButton1Click:Connect(function()
        if minimized then
            Expand()
        else
            Minimize()
        end
    end)

    Pill.MouseEnter:Connect(function()
        Util.Tween(Pill, { BackgroundColor3 = Theme.BGHover })
    end)
    Pill.MouseLeave:Connect(function()
        Util.Tween(Pill, { BackgroundColor3 = minimized and Theme.BGTer or Theme.BGSec })
    end)

    -- キーバインド (トグル表示)
    UserInput.InputBegan:Connect(function(inp, gpe)
        if gpe then return end
        if inp.KeyCode == Key then
            if not minimized then Minimize() else Expand() end
        end
    end)

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  Window オブジェクト
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    local Tabs       = {}
    local ActiveTab  = nil

    local Window     = {}
    Window._gui      = gui
    Window._main     = Main
    Window._pill     = Pill

    function Window:Notify(o)  return SendNotification(o) end
    function Window:Minimize() Minimize() end
    function Window:Expand()   Expand() end
    function Window:Destroy()  gui:Destroy() end

    function Window:AddSettingRow(label, desc)
        return AddSRow(label, desc)
    end

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  CreateTab
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    function Window:CreateTab(name, icon)
        -- サイドバーボタン
        local btn = Util.New("TextButton", {
            Name = "Tab_" .. name,
            Text = "",
            Size = UDim2.new(1, -4, 0, 32),
            BackgroundColor3 = Theme.BGSec,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 14,
            ClipsDescendants = true,
            Parent = TabList,
        })
        Util.Corner(btn, UDim.new(0, 3))

        -- アクティブ時の左バー（赤）
        local accent = Util.New("Frame", {
            Name = "Accent",
            Size = UDim2.new(0, 2, 0.7, 0),
            Position = UDim2.new(0, 2, 0.15, 0),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 15,
            Parent = btn,
        })
        Util.Corner(accent, UDim.new(0, 1))

        local iconLbl = Util.New("TextLabel", {
            Name = "Icon",
            Text = icon or "☰",
            Size = UDim2.new(0, 22, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextMut,
            TextSize = 13,
            Font = Cfg.Font,
            ZIndex = 15,
            Parent = btn,
        })

        local nameLbl = Util.New("TextLabel", {
            Name = "Name",
            Text = name,
            Size = UDim2.new(1, -36, 1, 0),
            Position = UDim2.new(0, 32, 0, 0),
            BackgroundTransparency = 1,
            TextColor3 = Theme.TextMut,
            TextSize = 12,
            Font = Cfg.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 15,
            Parent = btn,
        })

        -- ページ
        local page = Util.New("ScrollingFrame", {
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
        Util.List(page, Enum.FillDirection.Vertical, 8)
        Util.Pad(page, 12, 12, 12, 12)

        -- タブ選択
        local function Select()
            if ActiveTab then
                local a = ActiveTab
                Util.Tween(a._btn,    { BackgroundTransparency = 1 })
                Util.Tween(a._accent, { BackgroundTransparency = 1 })
                Util.Tween(a._name,   { TextColor3 = Theme.TextMut })
                Util.Tween(a._icon,   { TextColor3 = Theme.TextMut })
                a._page.Visible = false
            end

            ActiveTab = { _btn = btn, _accent = accent, _name = nameLbl, _icon = iconLbl, _page = page }

            Util.Tween(btn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.BGHover })
            Util.Tween(accent, { BackgroundTransparency = 0 })
            Util.Tween(nameLbl, { TextColor3 = Theme.TextPri })
            Util.Tween(iconLbl, { TextColor3 = Theme.AccentLight })
            page.Visible = true

            -- ページのフェードイン
            page.Position = UDim2.new(0, 12, 0, 0)
            Util.Tween(page, { Position = UDim2.new(0, 0, 0, 0) }, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))
        end

        btn.MouseButton1Click:Connect(Select)
        btn.MouseButton1Down:Connect(function(x, y) Util.Ripple(btn, x, y) end)

        btn.MouseEnter:Connect(function()
            if not (ActiveTab and ActiveTab._btn == btn) then
                Util.Tween(btn, { BackgroundTransparency = 0.5, BackgroundColor3 = Theme.BGHover })
            end
        end)
        btn.MouseLeave:Connect(function()
            if not (ActiveTab and ActiveTab._btn == btn) then
                Util.Tween(btn, { BackgroundTransparency = 1 })
            end
        end)

        if #Tabs == 0 then Select() end
        table.insert(Tabs, { name = name, btn = btn, page = page })

        -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        --  Tab Components
        -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

        local Tab = {}
        Tab._page = page

        -- ラベル
        function Tab:CreateLabel(opts)
            opts = opts or {}
            local lbl = Util.New("TextLabel", {
                Text = opts.Name or "Label",
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                TextColor3 = opts.Color or Theme.TextSec,
                TextSize = opts.Size or 12,
                Font = opts.Bold and Cfg.FontBold or Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 14,
                Parent = page,
            })
            Util.Pad(lbl, 0, 0, 0, 4)
            return lbl
        end

        -- パラグラフ
        function Tab:CreateParagraph(opts)
            opts = opts or {}
            local h   = opts.Height or 50
            local cont = Util.New("Frame", {
                Name = "Para",
                Size = UDim2.new(1, 0, 0, h),
                BackgroundColor3 = Theme.BGTer,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 8))
            Util.Pad(cont, 8, 10, 8, 10)
            Util.New("TextLabel", {
                Text = opts.Content or "",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextSec,
                TextSize = 12,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                ZIndex = 15,
                Parent = cont,
            })
            return cont
        end

        -- セパレーター
        function Tab:CreateSeparator()
            local f = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = page,
            })
            return f
        end

        -- セクション
        function Tab:CreateSection(opts)
            opts = opts or {}
            local row = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                ZIndex = 14,
                Parent = page,
            })
            Util.New("TextLabel", {
                Text = (opts.Name or "SECTION"):upper(),
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                TextColor3 = Theme.Accent,
                TextSize = 10,
                Font = Cfg.FontBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = row,
            })
            -- アニメーション付きライン
            local line = Util.New("Frame", {
                Name = "Line",
                Size = UDim2.new(1, -80, 0, 1),
                Position = UDim2.new(0, 80, 0.5, 0),
                BackgroundColor3 = Theme.Border,
                BorderSizePixel = 0,
                ZIndex = 15,
                Parent = row,
            })
            return row
        end

        -- ボタン
        function Tab:CreateButton(opts)
            opts = opts or {}
            local hasDesc = opts.Description ~= nil
            local h       = hasDesc and 58 or 46

            local cont = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, h),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                ClipsDescendants = true,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 9))
            Util.Pad(cont, 0, 10, 0, 14)

            -- ホバー時の左アクセントライン
            local hoverLine = Util.New("Frame", {
                Name = "HoverLine",
                Size = UDim2.new(0, 2, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = cont,
            })

            local nameLbl = Util.New("TextLabel", {
                Text = opts.Name or "Button",
                Size = UDim2.new(1, -100, 0, 18),
                Position = UDim2.new(0, 0, 0, hasDesc and 9 or 14),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPri,
                TextSize = 13,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = cont,
            })

            if hasDesc then
                Util.New("TextLabel", {
                    Text = opts.Description,
                    Size = UDim2.new(1, -100, 0, 14),
                    Position = UDim2.new(0, 0, 0, 32),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.TextMut,
                    TextSize = 10,
                    Font = Cfg.Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 15,
                    Parent = cont,
                })
            end

            local execBtn = Util.New("TextButton", {
                Text = opts.ButtonText or "Run",
                Size = UDim2.new(0, 72, 0, 28),
                Position = UDim2.new(1, -72, 0.5, -14),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 12,
                Font = Cfg.FontSemiBold,
                ZIndex = 15,
                ClipsDescendants = true,
                Parent = cont,
            })
            Util.Corner(execBtn, UDim.new(0, 8))

            execBtn.MouseEnter:Connect(function()
                Util.Tween(execBtn, { BackgroundColor3 = Theme.AccentLight })
                Util.Tween(hoverLine, { BackgroundTransparency = 0 })
            end)
            execBtn.MouseLeave:Connect(function()
                Util.Tween(execBtn, { BackgroundColor3 = Theme.Accent })
                Util.Tween(hoverLine, { BackgroundTransparency = 1 })
            end)

            execBtn.MouseButton1Down:Connect(function(x, y)
                Util.Ripple(execBtn, x, y)
                Util.Tween(execBtn, { Size = UDim2.new(0, 68, 0, 26), Position = UDim2.new(1, -70, 0.5, -13) },
                    TweenInfo.new(0.08, Enum.EasingStyle.Quart))
            end)
            execBtn.MouseButton1Up:Connect(function()
                Util.Spring(execBtn, { Size = UDim2.new(0, 72, 0, 28), Position = UDim2.new(1, -72, 0.5, -14) }, 0.2)
            end)
            execBtn.MouseButton1Click:Connect(function()
                if opts.Callback then task.spawn(opts.Callback) end
                if opts.Flag then SyuHub.Flags[opts.Flag] = { Type = "Button" } end
            end)

            cont.MouseEnter:Connect(function()
                Util.Tween(cont, { BackgroundColor3 = Theme.BGTer })
            end)
            cont.MouseLeave:Connect(function()
                Util.Tween(cont, { BackgroundColor3 = Theme.BGSec })
            end)

            return cont
        end

        -- トグル
        function Tab:CreateToggle(opts)
            opts = opts or {}
            local val     = opts.CurrentValue or false
            local hasDesc = opts.Description ~= nil
            local h       = hasDesc and 58 or 46

            local cont = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, h),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                ClipsDescendants = true,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 9))
            Util.Pad(cont, 0, 10, 0, 14)

            Util.New("TextLabel", {
                Text = opts.Name or "Toggle",
                Size = UDim2.new(1, -66, 0, 18),
                Position = UDim2.new(0, 0, 0, hasDesc and 9 or 14),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPri,
                TextSize = 13,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = cont,
            })

            if hasDesc then
                Util.New("TextLabel", {
                    Text = opts.Description,
                    Size = UDim2.new(1, -66, 0, 14),
                    Position = UDim2.new(0, 0, 0, 32),
                    BackgroundTransparency = 1,
                    TextColor3 = Theme.TextMut,
                    TextSize = 10,
                    Font = Cfg.Font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 15,
                    Parent = cont,
                })
            end

            -- トグルトラック
            local track = Util.New("Frame", {
                Name = "Track",
                Size = UDim2.new(0, 44, 0, 24),
                Position = UDim2.new(1, -44, 0.5, -12),
                BackgroundColor3 = val and Theme.TogOn or Theme.TogOff,
                BorderSizePixel = 0,
                ZIndex = 15,
                Parent = cont,
            })
            Util.Corner(track, UDim.new(0, 12))

            local knob = Util.New("Frame", {
                Name = "Knob",
                Size = UDim2.new(0, 18, 0, 18),
                Position = val and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                BackgroundColor3 = Theme.TogKnob,
                BorderSizePixel = 0,
                ZIndex = 16,
                Parent = track,
            })
            Util.Corner(knob, UDim.new(0, 9))

            -- knobの影（擬似）
            local knobGlow = Util.New("Frame", {
                Name = "KnobGlow",
                Size = UDim2.new(1, 6, 1, 6),
                Position = UDim2.new(0, -3, 0, -3),
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = val and 0.7 or 1,
                BorderSizePixel = 0,
                ZIndex = 15,
                Parent = knob,
            })
            Util.Corner(knobGlow, UDim.new(0, 12))

            local clickArea = Util.New("TextButton", {
                Text = "",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                ZIndex = 17,
                Parent = cont,
            })

            local function SetVal(v)
                val = v
                Util.Tween(track, { BackgroundColor3 = v and Theme.TogOn or Theme.TogOff })
                Util.Tween(knob, { Position = v and UDim2.new(0, 23, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) })
                Util.Tween(knobGlow, { BackgroundTransparency = v and 0.7 or 1 })
                if opts.Flag then SyuHub.Flags[opts.Flag] = { Type = "Toggle", Value = v, Set = SetVal } end
                if opts.Callback then task.spawn(opts.Callback, v) end
            end

            clickArea.MouseButton1Click:Connect(function() SetVal(not val) end)
            cont.MouseEnter:Connect(function() Util.Tween(cont, { BackgroundColor3 = Theme.BGTer }) end)
            cont.MouseLeave:Connect(function() Util.Tween(cont, { BackgroundColor3 = Theme.BGSec }) end)

            if opts.Flag then SyuHub.Flags[opts.Flag] = { Type = "Toggle", Value = val, Set = SetVal } end

            local Obj = {}
            function Obj:Set(v) SetVal(v) end
            function Obj:Get() return val end
            return Obj
        end

        -- スライダー
        function Tab:CreateSlider(opts)
            opts = opts or {}
            local range   = opts.Range        or { 0, 100 }
            local inc     = opts.Increment    or 1
            local current = opts.CurrentValue or range[1]
            local suffix  = opts.Suffix       or ""

            local cont = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 60),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                ClipsDescendants = false,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 9))
            Util.Pad(cont, 0, 12, 0, 14)

            -- 上段（名前 + 値バッジ）
            local topRow = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 20),
                Position = UDim2.new(0, 0, 0, 10),
                BackgroundTransparency = 1,
                ZIndex = 15,
                Parent = cont,
            })

            Util.New("TextLabel", {
                Text = opts.Name or "Slider",
                Size = UDim2.new(1, -60, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPri,
                TextSize = 13,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = topRow,
            })

            local valBadge = Util.New("TextLabel", {
                Name = "ValBadge",
                Text = tostring(current) .. suffix,
                Size = UDim2.new(0, 52, 1, 0),
                Position = UDim2.new(1, -52, 0, 0),
                BackgroundColor3 = Theme.BGTer,
                TextColor3 = Theme.AccentLight,
                TextSize = 12,
                Font = Cfg.FontBold,
                ZIndex = 15,
                Parent = topRow,
            })
            Util.Corner(valBadge, UDim.new(0, 7))

            -- トラック
            local track = Util.New("Frame", {
                Name = "Track",
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 0, 40),
                BackgroundColor3 = Theme.BGTer,
                BorderSizePixel = 0,
                ZIndex = 15,
                Parent = cont,
            })
            Util.Corner(track, UDim.new(0, 3))

            local fill = Util.New("Frame", {
                Name = "Fill",
                Size = UDim2.new((current - range[1]) / (range[2] - range[1]), 0, 1, 0),
                BackgroundColor3 = Theme.Accent,
                BorderSizePixel = 0,
                ZIndex = 16,
                Parent = track,
            })
            Util.Corner(fill, UDim.new(0, 3))

            local knob = Util.New("Frame", {
                Name = "Knob",
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((current - range[1]) / (range[2] - range[1]), -8, 0.5, -8),
                BackgroundColor3 = Theme.AccentLight,
                BorderSizePixel = 0,
                ZIndex = 17,
                Parent = track,
            })
            Util.Corner(knob, UDim.new(0, 8))

            -- ノブグロウ
            local knobGlow = Util.New("Frame", {
                Size = UDim2.new(1, 8, 1, 8),
                Position = UDim2.new(0, -4, 0, -4),
                BackgroundColor3 = Theme.Accent,
                BackgroundTransparency = 0.65,
                BorderSizePixel = 0,
                ZIndex = 16,
                Parent = knob,
            })
            Util.Corner(knobGlow, UDim.new(0, 12))

            local dragSlider = false

            local function Update(x)
                local rect  = track.AbsolutePosition.X
                local width = track.AbsoluteSize.X
                local ratio = math.clamp((x - rect) / width, 0, 1)
                local raw   = range[1] + ratio * (range[2] - range[1])
                local val   = math.clamp(math.round(raw / inc) * inc, range[1], range[2])
                local pct   = (val - range[1]) / (range[2] - range[1])
                fill.Size           = UDim2.new(pct, 0, 1, 0)
                knob.Position       = UDim2.new(pct, -8, 0.5, -8)
                valBadge.Text       = tostring(val) .. suffix
                current             = val
                if opts.Flag     then SyuHub.Flags[opts.Flag] = { Type = "Slider", Value = val } end
                if opts.Callback then task.spawn(opts.Callback, val) end
            end

            track.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    dragSlider = true
                    Update(inp.Position.X)
                    Util.Spring(knob, { Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(knob.Position.X.Scale, -9, 0.5, -9) }, 0.15)
                end
            end)
            UserInput.InputChanged:Connect(function(inp)
                if dragSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
                    Update(inp.Position.X)
                end
            end)
            UserInput.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                    if dragSlider then
                        dragSlider = false
                        Util.Spring(knob, { Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(knob.Position.X.Scale, -8, 0.5, -8) }, 0.15)
                    end
                end
            end)

            if opts.Flag then SyuHub.Flags[opts.Flag] = { Type = "Slider", Value = current } end

            local Obj = {}
            function Obj:Set(v)
                v = math.clamp(v, range[1], range[2])
                local pct = (v - range[1]) / (range[2] - range[1])
                fill.Size     = UDim2.new(pct, 0, 1, 0)
                knob.Position = UDim2.new(pct, -8, 0.5, -8)
                valBadge.Text = tostring(v) .. suffix
                current       = v
            end
            function Obj:Get() return current end
            return Obj
        end

        -- テキストボックス
        function Tab:CreateTextBox(opts)
            opts = opts or {}
            local cont = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 56),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 9))
            Util.Pad(cont, 0, 10, 0, 14)

            Util.New("TextLabel", {
                Text = opts.Name or "Input",
                Size = UDim2.new(1, 0, 0, 16),
                Position = UDim2.new(0, 0, 0, 6),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextSec,
                TextSize = 11,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = cont,
            })

            local box = Util.New("TextBox", {
                Name = "Input",
                PlaceholderText = opts.Placeholder or "Type here...",
                Text = opts.Default or "",
                Size = UDim2.new(1, 0, 0, 26),
                Position = UDim2.new(0, 0, 0, 24),
                BackgroundColor3 = Theme.BGTer,
                BorderSizePixel = 0,
                TextColor3 = Theme.TextPri,
                PlaceholderColor3 = Theme.TextMut,
                TextSize = 12,
                Font = Cfg.Font,
                ClearTextOnFocus = opts.ClearOnFocus ~= false,
                ZIndex = 15,
                Parent = cont,
            })
            Util.Corner(box, UDim.new(0, 7))
            Util.Pad(box, 0, 8, 0, 8)

            local stroke = Util.Stroke(box, Theme.Border, 1, 0)

            box.Focused:Connect(function()
                Util.Tween(stroke, { Color = Theme.Accent, Thickness = 1.5 })
            end)
            box.FocusLost:Connect(function(enter)
                Util.Tween(stroke, { Color = Theme.Border, Thickness = 1 })
                if opts.Callback then task.spawn(opts.Callback, box.Text, enter) end
                if opts.Flag then SyuHub.Flags[opts.Flag] = { Type = "TextBox", Value = box.Text } end
            end)

            local Obj = {}
            function Obj:Set(v) box.Text = v end
            function Obj:Get() return box.Text end
            return Obj
        end

        -- ドロップダウン
        function Tab:CreateDropdown(opts)
            opts = opts or {}
            local options  = opts.Options       or {}
            local selected = opts.CurrentOption or (options[1] or "Select...")
            local isOpen   = false

            local cont = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                ClipsDescendants = false,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 9))
            Util.Pad(cont, 0, 10, 0, 14)

            Util.New("TextLabel", {
                Text = opts.Name or "Dropdown",
                Size = UDim2.new(0.5, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPri,
                TextSize = 13,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = cont,
            })

            local display = Util.New("TextButton", {
                Name = "Display",
                Text = selected .. "  ▾",
                Size = UDim2.new(0, 140, 0, 28),
                Position = UDim2.new(1, -140, 0.5, -14),
                BackgroundColor3 = Theme.BGTer,
                BorderSizePixel = 0,
                TextColor3 = Theme.TextSec,
                TextSize = 12,
                Font = Cfg.Font,
                ZIndex = 15,
                ClipsDescendants = true,
                Parent = cont,
            })
            Util.Corner(display, UDim.new(0, 8))

            local dropList = Util.New("Frame", {
                Name = "DropList",
                Size = UDim2.new(0, 140, 0, 0),
                Position = UDim2.new(1, -140, 0, 38),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                Visible = false,
                ZIndex = 40,
                Parent = cont,
            })
            Util.Corner(dropList, UDim.new(0, 9))
            Util.Stroke(dropList, Theme.BorderBright, 1, 0)
            Util.List(dropList, Enum.FillDirection.Vertical, 2)
            Util.Pad(dropList, 4, 4, 4, 4)

            local targetH = 0

            local function Close()
                isOpen = false
                Util.Tween(dropList, { Size = UDim2.new(0, 140, 0, 0) },
                    TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In))
                task.wait(0.2)
                dropList.Visible = false
                Util.Tween(display, { TextColor3 = Theme.TextSec })
            end

            local function BuildOpts()
                for _, c in ipairs(dropList:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                targetH = #options * 28 + 8
                for _, opt in ipairs(options) do
                    local isSelected = (opt == selected)
                    local item = Util.New("TextButton", {
                        Text = opt,
                        Size = UDim2.new(1, 0, 0, 26),
                        BackgroundColor3 = isSelected and Theme.BGHover or Theme.BGSec,
                        BackgroundTransparency = isSelected and 0 or 1,
                        TextColor3 = isSelected and Theme.TextPri or Theme.TextSec,
                        TextSize = 12,
                        Font = isSelected and Cfg.FontSemiBold or Cfg.Font,
                        ZIndex = 41,
                        ClipsDescendants = true,
                        Parent = dropList,
                    })
                    Util.Corner(item, UDim.new(0, 6))
                    item.MouseEnter:Connect(function()
                        if opt ~= selected then Util.Tween(item, { BackgroundTransparency = 0, BackgroundColor3 = Theme.BGTer }) end
                    end)
                    item.MouseLeave:Connect(function()
                        if opt ~= selected then Util.Tween(item, { BackgroundTransparency = 1 }) end
                    end)
                    item.MouseButton1Click:Connect(function()
                        selected = opt
                        display.Text = opt .. "  ▾"
                        if opts.Flag     then SyuHub.Flags[opts.Flag] = { Type = "Dropdown", Value = opt } end
                        if opts.Callback then task.spawn(opts.Callback, opt) end
                        Close()
                        BuildOpts()
                    end)
                end
            end
            BuildOpts()

            display.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    dropList.Visible = true
                    dropList.Size = UDim2.new(0, 140, 0, 0)
                    Util.Tween(dropList, { Size = UDim2.new(0, 140, 0, targetH) },
                        TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
                    Util.Tween(display, { TextColor3 = Theme.AccentLight })
                else
                    Close()
                end
            end)

            display.MouseEnter:Connect(function() Util.Tween(display, { BackgroundColor3 = Theme.BGHover }) end)
            display.MouseLeave:Connect(function() Util.Tween(display, { BackgroundColor3 = Theme.BGTer  }) end)

            local Obj = {}
            function Obj:Set(v)     selected = v; display.Text = v .. "  ▾"; BuildOpts() end
            function Obj:Get()      return selected end
            function Obj:Refresh(n) options = n; BuildOpts() end
            return Obj
        end

        -- カラーピッカー（シンプル版）
        function Tab:CreateColorPicker(opts)
            opts = opts or {}
            local colors = {
                Color3.fromRGB(124,92,255),   -- Purple
                Color3.fromRGB(80,175,255),   -- Blue
                Color3.fromRGB(80,220,255),   -- Cyan
                Color3.fromRGB(50,215,130),   -- Green
                Color3.fromRGB(255,190,60),   -- Yellow
                Color3.fromRGB(240,100,80),   -- Red
                Color3.fromRGB(220,100,180),  -- Pink
                Color3.fromRGB(200,200,220),  -- White
            }
            local current = opts.Default or colors[1]

            local cont = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 9))
            Util.Pad(cont, 0, 10, 0, 14)

            Util.New("TextLabel", {
                Text = opts.Name or "Color",
                Size = UDim2.new(0.4, 0, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPri,
                TextSize = 13,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = cont,
            })

            local swatchHolder = Util.New("Frame", {
                Name = "Swatches",
                Size = UDim2.new(0, 0, 0, 22),
                AutomaticSize = Enum.AutomaticSize.X,
                Position = UDim2.new(1, -172, 0.5, -11),
                BackgroundTransparency = 1,
                ZIndex = 15,
                Parent = cont,
            })
            Util.List(swatchHolder, Enum.FillDirection.Horizontal, 5)

            local selectedSwatch = nil

            for i, col in ipairs(colors) do
                local sw = Util.New("TextButton", {
                    Name = "Swatch_" .. i,
                    Size = UDim2.new(0, 22, 0, 22),
                    BackgroundColor3 = col,
                    BorderSizePixel = 0,
                    Text = "",
                    ZIndex = 16,
                    Parent = swatchHolder,
                })
                Util.Corner(sw, UDim.new(0, 5))

                if col == current then
                    Util.Stroke(sw, Color3.fromRGB(255,255,255), 2, 0)
                    selectedSwatch = sw
                end

                sw.MouseButton1Click:Connect(function()
                    current = col
                    if selectedSwatch then
                        for _, c in ipairs(selectedSwatch:GetChildren()) do
                            if c:IsA("UIStroke") then c:Destroy() end
                        end
                    end
                    Util.Stroke(sw, Color3.fromRGB(255,255,255), 2, 0)
                    Util.Spring(sw, { Size = UDim2.new(0, 24, 0, 24) }, 0.15)
                    task.wait(0.15)
                    Util.Spring(sw, { Size = UDim2.new(0, 22, 0, 22) }, 0.15)
                    selectedSwatch = sw
                    if opts.Flag     then SyuHub.Flags[opts.Flag] = { Type = "ColorPicker", Value = col } end
                    if opts.Callback then task.spawn(opts.Callback, col) end
                end)
            end

            if opts.Flag then SyuHub.Flags[opts.Flag] = { Type = "ColorPicker", Value = current } end

            local Obj = {}
            function Obj:Get() return current end
            return Obj
        end

        -- キーバインドピッカー
        function Tab:CreateKeybind(opts)
            opts = opts or {}
            local key     = opts.Default   or Enum.KeyCode.F
            local waiting = false

            local cont = Util.New("Frame", {
                Size = UDim2.new(1, 0, 0, 46),
                BackgroundColor3 = Theme.BGSec,
                BorderSizePixel = 0,
                ZIndex = 14,
                ClipsDescendants = true,
                Parent = page,
            })
            Util.Corner(cont, UDim.new(0, 9))
            Util.Pad(cont, 0, 10, 0, 14)

            Util.New("TextLabel", {
                Text = opts.Name or "Keybind",
                Size = UDim2.new(1, -100, 1, 0),
                BackgroundTransparency = 1,
                TextColor3 = Theme.TextPri,
                TextSize = 13,
                Font = Cfg.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 15,
                Parent = cont,
            })

            local badge = Util.New("TextButton", {
                Text = tostring(key):gsub("Enum.KeyCode.", ""),
                Size = UDim2.new(0, 80, 0, 28),
                Position = UDim2.new(1, -80, 0.5, -14),
                BackgroundColor3 = Theme.BGTer,
                BorderSizePixel = 0,
                TextColor3 = Theme.AccentLight,
                TextSize = 12,
                Font = Cfg.FontBold,
                ZIndex = 15,
                Parent = cont,
            })
            Util.Corner(badge, UDim.new(0, 8))
            Util.Stroke(badge, Theme.BorderBright, 1, 0)

            badge.MouseButton1Click:Connect(function()
                if waiting then return end
                waiting = true
                badge.Text = "..."
                Util.Tween(badge, { BackgroundColor3 = Theme.Accent, TextColor3 = Color3.fromRGB(255,255,255) })

                local conn
                conn = UserInput.InputBegan:Connect(function(inp, gpe)
                    if gpe then return end
                    if inp.UserInputType == Enum.UserInputType.Keyboard then
                        key = inp.KeyCode
                        badge.Text = tostring(key):gsub("Enum.KeyCode.", "")
                        Util.Tween(badge, { BackgroundColor3 = Theme.BGTer, TextColor3 = Theme.AccentLight })
                        waiting = false
                        conn:Disconnect()
                        if opts.Flag     then SyuHub.Flags[opts.Flag] = { Type = "Keybind", Value = key } end
                        if opts.Callback then task.spawn(opts.Callback, key) end
                    end
                end)
            end)

            if opts.Flag then SyuHub.Flags[opts.Flag] = { Type = "Keybind", Value = key } end

            local Obj = {}
            function Obj:Get() return key end
            return Obj
        end

        return Tab
    end -- CreateTab

    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    --  ローディングアニメーション
    -- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.BackgroundTransparency = 1

    task.spawn(function()
        ShowLoadingScreen(gui, Title, function()
            Util.Spring(Main, {
                Size = UDim2.new(0, Cfg.W, 0, Cfg.H),
                BackgroundTransparency = 0,
            }, Cfg.AnimSpd + 0.1)

            -- アクセントライン入場アニメーション
            accentLine.Size = UDim2.new(0, 0, 0, 2)
            task.wait(0.15)
            Util.Tween(accentLine, { Size = UDim2.new(1, 0, 0, 2) },
                TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out))

            task.wait(0.4)
            SendNotification({
                Title   = "Syu_hub v2.0",
                Content = "UIがロードされました！RightCtrlで表示切替。",
                Type    = "Success",
                Duration = 4,
            })
        end)
    end)

    return Window
end -- CreateWindow

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

return SyuHub

--[[
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  使用例
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

local Syu = loadstring(game:HttpGet("https://raw.githubusercontent.com/syuu06130-alt/UI/main/sub.ua"))()

local Win = Syu:CreateWindow({
    Title      = "Syu_hub",
    SubTitle   = "v2.0 by You",
    ToggleKey  = Enum.KeyCode.RightControl,
})

local Tab = Win:CreateTab("Main", "★")
local Settings = Win:CreateTab("Settings", "⚙")

Tab:CreateSection({ Name = "Combat" })

Tab:CreateButton({
    Name        = "Kill Aura",
    Description = "Near players take damage",
    ButtonText  = "Run",
    Flag        = "KillAura",
    Callback    = function()
        Win:Notify({ Title="Kill Aura", Content="Activated!", Type="Success" })
    end,
})

local speedToggle = Tab:CreateToggle({
    Name         = "Speed Hack",
    Description  = "Modify walk speed",
    CurrentValue = false,
    Flag         = "SpeedHack",
    Callback     = function(v) print("Speed:", v) end,
})

local speedSlider = Tab:CreateSlider({
    Name         = "Walk Speed",
    Range        = {16, 500},
    Increment    = 1,
    CurrentValue = 16,
    Suffix       = " sp",
    Flag         = "WalkSpeed",
    Callback     = function(v)
        -- game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end,
})

Tab:CreateSection({ Name = "Visual" })

Tab:CreateColorPicker({
    Name     = "Accent Color",
    Flag     = "AccentColor",
    Callback = function(col) print(col) end,
})

Settings:CreateKeybind({
    Name     = "Toggle UI",
    Default  = Enum.KeyCode.RightControl,
    Flag     = "UIKey",
    Callback = function(key) print("New key:", key) end,
})

Settings:CreateTextBox({
    Name        = "Player Name",
    Placeholder = "Enter name...",
    Flag        = "TargetName",
    Callback    = function(text) print("Target:", text) end,
})

Settings:CreateDropdown({
    Name          = "Game Mode",
    Options       = { "Default", "Rage", "Legit", "Ghost" },
    CurrentOption = "Default",
    Flag          = "GameMode",
    Callback      = function(opt) print("Mode:", opt) end,
})

-- フラグから値を取得
-- print(Syu.Flags["WalkSpeed"].Value)
-- speedSlider:Set(100)
-- speedToggle:Set(true)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
]]
