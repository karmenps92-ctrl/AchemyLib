--[[
    ╔═══════════════════════════════════════════════════╗
    ║       ALCHEMY UI LIBRARY v5.0                     ║
    ║    Extracted UI Engine from Alchemy Hub           ║
    ║    Full pcall protection for all executors        ║
    ╚═══════════════════════════════════════════════════╝
]]

print("[AlchemyLib] Loading library...")

local AlchemyLib = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local Camera = Workspace.CurrentCamera
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Safe CoreGui access
local function GetGuiParent()
    local ok, gui = pcall(function() return game:GetService("CoreGui") end)
    if ok and gui then return gui end
    local ok2, gui2 = pcall(function() return (gethui and gethui()) or Player:WaitForChild("PlayerGui") end)
    if ok2 and gui2 then return gui2 end
    return Player:WaitForChild("PlayerGui")
end

AlchemyLib.Theme = {
    Background = Color3.fromRGB(15, 10, 25),
    BackgroundAlpha = 0.55,
    Secondary = Color3.fromRGB(22, 15, 35),
    SecondaryAlpha = 0.65,
    Tertiary = Color3.fromRGB(30, 20, 45),
    Accent = Color3.fromRGB(170, 60, 255),
    AccentDark = Color3.fromRGB(110, 30, 200),
    AccentLight = Color3.fromRGB(220, 130, 255),
    Text = Color3.fromRGB(255, 245, 255),
    TextDim = Color3.fromRGB(180, 160, 200),
    Success = Color3.fromRGB(50, 255, 150),
    Warning = Color3.fromRGB(255, 180, 50),
    Danger = Color3.fromRGB(255, 60, 90),
    Border = Color3.fromRGB(90, 40, 140),
    ToggleOn = Color3.fromRGB(170, 60, 255),
    ToggleOff = Color3.fromRGB(40, 25, 60),
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.GothamMedium,
}

local Theme = AlchemyLib.Theme

-- ══════════════════════════════════════
--        UTILIDADES UI (con pcall)
-- ══════════════════════════════════════
function AlchemyLib.CreateCorner(parent, radius)
    local ok, corner = pcall(function()
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, radius or 8)
        c.Parent = parent
        return c
    end)
    return ok and corner or nil
end

function AlchemyLib.CreateStroke(parent, color, thickness)
    local ok, stroke = pcall(function()
        local s = Instance.new("UIStroke")
        s.Color = color or Theme.Border
        s.Thickness = thickness or 1
        s.Parent = parent
        return s
    end)
    if not ok then
        -- Fallback: usar un borde visual con un Frame
        pcall(function()
            local border = Instance.new("Frame")
            border.Name = "FallbackBorder"
            border.Size = UDim2.new(1, 2, 1, 2)
            border.Position = UDim2.new(0, -1, 0, -1)
            border.BackgroundColor3 = color or Theme.Border
            border.BackgroundTransparency = 0.7
            border.BorderSizePixel = 0
            border.ZIndex = parent.ZIndex - 1
            border.Parent = parent
            AlchemyLib.CreateCorner(border, 8)
        end)
    end
    return ok and stroke or nil
end

function AlchemyLib.CreateGradient(parent, c1, c2, rotation)
    local ok, gradient = pcall(function()
        local g = Instance.new("UIGradient")
        g.Color = ColorSequence.new(c1, c2)
        g.Rotation = rotation or 90
        g.Parent = parent
        return g
    end)
    return ok and gradient or nil
end

function AlchemyLib.CreateShadow(parent)
    local ok, shadow = pcall(function()
        local s = Instance.new("ImageLabel")
        s.Name = "Shadow"
        s.BackgroundTransparency = 1
        s.Position = UDim2.new(0, -15, 0, -15)
        s.Size = UDim2.new(1, 30, 1, 30)
        s.ZIndex = math.max(parent.ZIndex - 1, 0)
        s.Image = "rbxassetid://5554236805"
        s.ImageColor3 = Color3.fromRGB(0, 0, 0)
        s.ImageTransparency = 0.6
        s.ScaleType = Enum.ScaleType.Slice
        s.SliceCenter = Rect.new(23, 23, 277, 277)
        s.Parent = parent
        return s
    end)
    return ok and shadow or nil
end

function AlchemyLib.Tween(obj, props, duration, style, direction)
    local ok, tween = pcall(function()
        local ti = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
        local t = TweenService:Create(obj, ti, props)
        t:Play()
        return t
    end)
    return ok and tween or nil
end

function AlchemyLib.BumpyTween(obj, props, duration)
    return AlchemyLib.Tween(obj, props, duration or 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

function AlchemyLib.Ripple(button)
    pcall(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = Theme.AccentLight
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.ZIndex = button.ZIndex + 1
        ripple.Parent = button
        AlchemyLib.CreateCorner(ripple, 100)
        local mousePos = UserInputService:GetMouseLocation()
        local absPos = button.AbsolutePosition
        local relX = mousePos.X - absPos.X
        local relY = mousePos.Y - absPos.Y
        ripple.Position = UDim2.new(0, relX, 0, relY)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
        AlchemyLib.Tween(ripple, {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            Position = UDim2.new(0, relX - maxSize/2, 0, relY - maxSize/2),
            BackgroundTransparency = 1
        }, 0.7, Enum.EasingStyle.Sine)
        task.delay(0.7, function() pcall(function() ripple:Destroy() end) end)
    end)
end

local CreateCorner = AlchemyLib.CreateCorner
local CreateStroke = AlchemyLib.CreateStroke
local CreateGradient = AlchemyLib.CreateGradient
local CreateShadow = AlchemyLib.CreateShadow
local Tween = AlchemyLib.Tween
local BumpyTween = AlchemyLib.BumpyTween
local Ripple = AlchemyLib.Ripple

-- ══════════════════════════════════════
--    COMPONENTES UI
-- ══════════════════════════════════════

function AlchemyLib.CreateToggle(parent, name, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -16, 0, 44)
    holder.BackgroundColor3 = Theme.Tertiary
    holder.BackgroundTransparency = 0.2
    holder.BorderSizePixel = 0
    holder.Parent = parent
    CreateCorner(holder, 8)
    CreateStroke(holder, Theme.Border, 1.5)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextSize = 14
    label.Font = Theme.FontLight
    label.TextColor3 = Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 46, 0, 24)
    toggleBg.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBg.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = holder
    CreateCorner(toggleBg, 12)

    local toggleShadow = Instance.new("ImageLabel")
    toggleShadow.BackgroundTransparency = 1
    toggleShadow.Position = UDim2.new(0, -6, 0, -6)
    toggleShadow.Size = UDim2.new(1, 12, 1, 12)
    toggleShadow.Image = "rbxassetid://5554236805"
    toggleShadow.ImageColor3 = Theme.AccentLight
    toggleShadow.ImageTransparency = default and 0.3 or 1
    toggleShadow.ScaleType = Enum.ScaleType.Slice
    toggleShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    toggleShadow.Parent = toggleBg

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBg
    CreateCorner(toggleCircle, 10)

    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = holder

    btn.MouseButton1Click:Connect(function()
        state = not state
        Ripple(holder)
        Tween(toggleBg, {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff}, 0.35, Enum.EasingStyle.Quart)
        BumpyTween(toggleCircle, {Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)}, 0.5)
        Tween(toggleShadow, {ImageTransparency = state and 0.3 or 1}, 0.35)
        if callback then callback(state) end
    end)

    btn.MouseEnter:Connect(function()
        Tween(holder, {BackgroundTransparency = 0, BackgroundColor3 = Theme.Secondary}, 0.2)
        BumpyTween(holder, {Size = UDim2.new(1, -12, 0, 46)}, 0.3)
    end)
    btn.MouseLeave:Connect(function()
        Tween(holder, {BackgroundTransparency = 0.2, BackgroundColor3 = Theme.Tertiary}, 0.2)
        Tween(holder, {Size = UDim2.new(1, -16, 0, 44)}, 0.3)
    end)

    return holder, function() return state end
end

function AlchemyLib.CreateSlider(parent, name, min, max, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -16, 0, 58)
    holder.BackgroundColor3 = Theme.Tertiary
    holder.BackgroundTransparency = 0.2
    holder.BorderSizePixel = 0
    holder.Parent = parent
    CreateCorner(holder, 8)
    CreateStroke(holder, Theme.Border, 1.5)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.6, -12, 0, 20)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextSize = 14
    label.Font = Theme.FontLight
    label.TextColor3 = Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.4, -12, 0, 20)
    valueLabel.Position = UDim2.new(0.6, 0, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextSize = 14
    valueLabel.Font = Theme.Font
    valueLabel.TextColor3 = Theme.AccentLight
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = holder

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 8)
    sliderBg.Position = UDim2.new(0, 12, 0, 36)
    sliderBg.BackgroundColor3 = Theme.ToggleOff
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = holder
    CreateCorner(sliderBg, 4)

    local rel = (default - min) / (max - min)
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(rel, 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    CreateCorner(sliderFill, 4)
    CreateGradient(sliderFill, Theme.AccentDark, Theme.AccentLight, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(1, -8, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = sliderFill
    CreateCorner(knob, 8)

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 1, 20)
    sliderBtn.Position = UDim2.new(0, 0, 0, -10)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local dragging = false

    local function update(input)
        local relX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * relX)
        Tween(sliderFill, {Size = UDim2.new(relX, 0, 1, 0)}, 0.1, Enum.EasingStyle.Sine)
        valueLabel.Text = tostring(val)
        if callback then callback(val) end
    end

    sliderBtn.MouseButton1Down:Connect(function(input)
        dragging = true
        BumpyTween(knob, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -11, 0.5, -11)}, 0.3)
        Tween(sliderBg, {Size = UDim2.new(1, -24, 0, 10)}, 0.2)
        update(input)
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            BumpyTween(knob, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(1, -8, 0.5, -8)}, 0.4)
            Tween(sliderBg, {Size = UDim2.new(1, -24, 0, 8)}, 0.2)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then update(input) end
    end)

    sliderBtn.MouseEnter:Connect(function() Tween(knob, {BackgroundColor3 = Theme.AccentLight}, 0.2) end)
    sliderBtn.MouseLeave:Connect(function() Tween(knob, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.2) end)

    return holder
end

function AlchemyLib.CreateButton(parent, name, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -16, 0, 42)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.Position = UDim2.new(0.5, 0, 0.5, 0)
    btn.BackgroundColor3 = Theme.Accent
    btn.BackgroundTransparency = 0.1
    btn.Text = name
    btn.TextSize = 14
    btn.TextColor3 = Theme.Text
    btn.Font = Theme.Font
    btn.BorderSizePixel = 0
    btn.Parent = btnFrame
    CreateCorner(btn, 8)
    CreateGradient(btn, Theme.AccentDark, Theme.AccentLight, -45)

    local glow = CreateShadow(btn)
    if glow then
        glow.ImageColor3 = Theme.AccentLight
        glow.ImageTransparency = 0.5
        glow.Size = UDim2.new(1, 24, 1, 24)
        glow.Position = UDim2.new(0, -12, 0, -12)
    end

    btn.MouseButton1Down:Connect(function()
        Tween(btn, {Size = UDim2.new(0.92, 0, 0.8, 0)}, 0.15)
    end)
    btn.MouseButton1Up:Connect(function()
        BumpyTween(btn, {Size = UDim2.new(1, 0, 1, 0)}, 0.5)
    end)
    btn.MouseButton1Click:Connect(function()
        Ripple(btn)
        if callback then callback() end
    end)
    btn.MouseEnter:Connect(function()
        Tween(btn, {BackgroundTransparency = 0}, 0.2)
        if glow then Tween(glow, {ImageTransparency = 0.2, Size = UDim2.new(1, 36, 1, 36), Position = UDim2.new(0, -18, 0, -18)}, 0.3) end
    end)
    btn.MouseLeave:Connect(function()
        Tween(btn, {BackgroundTransparency = 0.1, Size = UDim2.new(1, 0, 1, 0)}, 0.2)
        if glow then Tween(glow, {ImageTransparency = 0.5, Size = UDim2.new(1, 24, 1, 24), Position = UDim2.new(0, -12, 0, -12)}, 0.3) end
    end)
    return btnFrame
end

function AlchemyLib.CreateSection(parent, title)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, -16, 0, 32)
    sec.BackgroundTransparency = 1
    sec.Text = " " .. string.upper(title)
    sec.TextSize = 13
    sec.Font = Theme.Font
    sec.TextColor3 = Theme.AccentLight
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.TextYAlignment = Enum.TextYAlignment.Bottom
    sec.Parent = parent
    return sec
end

function AlchemyLib.CreateKeybind(parent, name, configTable, configKey)
    local btn = AlchemyLib.CreateButton(parent, name .. ": " .. tostring(configTable[configKey] and configTable[configKey].Name or "?"), function() end)
    local isBinding = false
    local textBtn = btn:FindFirstChildOfClass("TextButton")
    if textBtn then
        textBtn.MouseButton1Click:Connect(function()
            if isBinding then return end
            isBinding = true
            textBtn.Text = "... PRESIONANDO ..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.Keyboard then
                    configTable[configKey] = i.KeyCode
                    textBtn.Text = name .. ": " .. i.KeyCode.Name
                    isBinding = false
                    conn:Disconnect()
                end
            end)
        end)
    end
    return btn
end

function AlchemyLib.CreateTextBox(parent, labelText, placeholder, callback)
    local nameHolder = Instance.new("Frame")
    nameHolder.Size = UDim2.new(1, -16, 0, 62)
    nameHolder.BackgroundColor3 = Theme.Tertiary
    nameHolder.BorderSizePixel = 0
    nameHolder.Parent = parent
    CreateCorner(nameHolder, 8)
    CreateStroke(nameHolder, Theme.Border, 1.5)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -16, 0, 18)
    nameLabel.Position = UDim2.new(0, 8, 0, 6)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = labelText
    nameLabel.TextSize = 13
    nameLabel.Font = Theme.Font
    nameLabel.TextColor3 = Theme.AccentLight
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = nameHolder

    local nameBox = Instance.new("TextBox")
    nameBox.Size = UDim2.new(1, -16, 0, 30)
    nameBox.Position = UDim2.new(0, 8, 0, 26)
    nameBox.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    nameBox.BorderSizePixel = 0
    nameBox.Text = ""
    nameBox.PlaceholderText = placeholder or "..."
    nameBox.TextSize = 14
    nameBox.Font = Theme.FontLight
    nameBox.TextColor3 = Theme.Text
    nameBox.PlaceholderColor3 = Theme.TextDim
    nameBox.ClearTextOnFocus = false
    nameBox.Parent = nameHolder
    CreateCorner(nameBox, 6)
    CreateStroke(nameBox, Theme.Accent, 1)

    if callback then
        nameBox:GetPropertyChangedSignal("Text"):Connect(function()
            callback(nameBox.Text)
        end)
    end

    return nameHolder, nameBox
end

-- ══════════════════════════════════════
--     SISTEMA DE VENTANA COMPLETO
-- ══════════════════════════════════════
function AlchemyLib:CreateHub(config)
    config = config or {}
    local hubName = config.Name or "AlchemyHub"
    local hubTitle = config.Title or "ALCHEMY HUB"
    local hubVersion = config.Version or "v5.0"
    local hubAuthor = config.Author or "By Alchemy Studios"
    local hubIcon = config.Icon or "rbxassetid://131779754659128"
    local guiKey = config.GuiKey or Enum.KeyCode.Y
    local lowGFX = config.LowGFX or false

    print("[AlchemyLib] Creating Hub: " .. hubTitle)

    local Hub = {}
    Hub.GUI_Open = true
    Hub.TabButtons = {}
    Hub.TabPages = {}
    Hub.ActiveTab = config.DefaultTab or nil

    -- Destruir GUI anterior
    local guiParent = GetGuiParent()
    pcall(function() if guiParent:FindFirstChild(hubName) then guiParent:FindFirstChild(hubName):Destroy() end end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = hubName
    ScreenGui.ResetOnSpawn = false
    pcall(function() ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
    ScreenGui.Parent = guiParent

    Hub.ScreenGui = ScreenGui

    print("[AlchemyLib] ScreenGui created in: " .. guiParent.Name)

    -- Ventana Principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 650, 0, 460)
    MainFrame.Position = UDim2.new(0.5, -325, 0.5, -230)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = Theme.BackgroundAlpha
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    CreateCorner(MainFrame, 14)

    Hub.MainFrame = MainFrame

    -- Stroke del borde principal (con pcall)
    local MainStroke = nil
    local MainStrokeGradient = nil
    pcall(function()
        MainStroke = Instance.new("UIStroke")
        MainStroke.Color = Theme.Accent
        MainStroke.Thickness = 2
        MainStroke.Transparency = 0.1
        MainStroke.Parent = MainFrame
        MainStrokeGradient = CreateGradient(MainStroke, Theme.AccentDark, Theme.AccentLight, 0)
    end)

    local MainShadow = CreateShadow(MainFrame)
    if MainShadow then
        MainShadow.ImageColor3 = Theme.AccentDark
        MainShadow.ImageTransparency = 0.4
        MainShadow.Size = UDim2.new(1, 40, 1, 40)
        MainShadow.Position = UDim2.new(0, -20, 0, -20)
    end

    -- Particulas Flotantes
    local ParticleHolder = Instance.new("Frame")
    ParticleHolder.Size = UDim2.new(1, 0, 1, 0)
    ParticleHolder.BackgroundTransparency = 1
    ParticleHolder.ZIndex = 0
    ParticleHolder.Parent = MainFrame

    -- Animacion del borde
    if MainStrokeGradient then
        task.spawn(function()
            local rot = 0
            while task.wait(0.02) do
                if not lowGFX and MainFrame and MainFrame.Parent then
                    rot = (rot + 1) % 360
                    pcall(function() MainStrokeGradient.Rotation = rot end)
                end
            end
        end)
    end

    -- Barra de titulo
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.Position = UDim2.new(0, 0, 0, 0)
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.BackgroundTransparency = Theme.SecondaryAlpha
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = MainFrame

    pcall(function()
        local TitleIcon = Instance.new("ImageLabel")
        TitleIcon.Size = UDim2.new(0, 32, 0, 32)
        TitleIcon.Position = UDim2.new(0, 15, 0.5, -16)
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.Image = hubIcon
        TitleIcon.Parent = TitleBar
    end)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 55, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = hubTitle
    TitleLabel.TextSize = 17
    TitleLabel.Font = Theme.Font
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 50, 1, 0)
    VersionLabel.Position = UDim2.new(0, 210, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = hubVersion
    VersionLabel.TextSize = 12
    VersionLabel.Font = Theme.FontLight
    VersionLabel.TextColor3 = Theme.AccentLight
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TitleBar

    local AuthorLabel = Instance.new("TextLabel")
    AuthorLabel.Size = UDim2.new(0, 150, 1, 0)
    AuthorLabel.Position = UDim2.new(0, 250, 0, 0)
    AuthorLabel.BackgroundTransparency = 1
    AuthorLabel.Text = hubAuthor
    AuthorLabel.TextSize = 11
    AuthorLabel.Font = Theme.FontLight
    AuthorLabel.TextColor3 = Theme.TextDim
    AuthorLabel.TextXAlignment = Enum.TextXAlignment.Left
    AuthorLabel.Parent = TitleBar

    -- Botones ventana
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -45, 0.5, -16)
    CloseBtn.BackgroundColor3 = Theme.Danger
    CloseBtn.BackgroundTransparency = 0.8
    CloseBtn.Text = "X"
    CloseBtn.TextSize = 14
    CloseBtn.Font = Theme.Font
    CloseBtn.TextColor3 = Theme.Text
    CloseBtn.Parent = TitleBar
    CreateCorner(CloseBtn, 8)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 32, 0, 32)
    MinBtn.Position = UDim2.new(1, -85, 0.5, -16)
    MinBtn.BackgroundColor3 = Theme.Warning
    MinBtn.BackgroundTransparency = 0.8
    MinBtn.Text = "-"
    MinBtn.TextSize = 14
    MinBtn.Font = Theme.Font
    MinBtn.TextColor3 = Theme.Text
    MinBtn.ZIndex = 3
    MinBtn.Parent = TitleBar
    CreateCorner(MinBtn, 8)

    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0.3}, 0.2) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundTransparency = 0.8}, 0.2) end)
    MinBtn.MouseEnter:Connect(function() Tween(MinBtn, {BackgroundTransparency = 0.3}, 0.2) end)
    MinBtn.MouseLeave:Connect(function() Tween(MinBtn, {BackgroundTransparency = 0.8}, 0.2) end)

    -- Linea separadora
    local TitleLine = Instance.new("Frame")
    TitleLine.Size = UDim2.new(1, 0, 0, 1)
    TitleLine.Position = UDim2.new(0, 0, 1, 0)
    TitleLine.BackgroundColor3 = Theme.Accent
    TitleLine.BackgroundTransparency = 0.3
    TitleLine.BorderSizePixel = 0
    TitleLine.ZIndex = 3
    TitleLine.Parent = TitleBar

    -- Sidebar
    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 160, 1, -51)
    Sidebar.Position = UDim2.new(0, 0, 0, 51)
    Sidebar.BackgroundColor3 = Theme.Secondary
    Sidebar.BackgroundTransparency = Theme.SecondaryAlpha + 0.15
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 2
    Sidebar.Parent = MainFrame

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Name = "SidebarScroll"
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 2
    SidebarScroll.ScrollBarImageColor3 = Theme.AccentLight
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    SidebarScroll.Parent = Sidebar

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.Parent = SidebarScroll

    local SidebarPad = Instance.new("UIPadding")
    SidebarPad.PaddingTop = UDim.new(0, 10)
    SidebarPad.PaddingLeft = UDim.new(0, 8)
    SidebarPad.PaddingRight = UDim.new(0, 8)
    SidebarPad.Parent = SidebarScroll

    -- Contenedor de contenido
    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -160, 1, -51)
    ContentArea.Position = UDim2.new(0, 160, 0, 51)
    ContentArea.BackgroundColor3 = Theme.Background
    ContentArea.BackgroundTransparency = 1
    ContentArea.BorderSizePixel = 0
    ContentArea.ClipsDescendants = true
    ContentArea.ZIndex = 2
    ContentArea.Parent = MainFrame

    -- Dragging
    local dragToggle, dragInput, dragStart, startPos = nil, nil, nil, nil
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
        end
    end)
    TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle GUI
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == guiKey then
            Hub.GUI_Open = not Hub.GUI_Open
            if Hub.GUI_Open then MainFrame.Visible = true; BumpyTween(MainFrame, {Size = UDim2.new(0, 650, 0, 460), BackgroundTransparency = Theme.BackgroundAlpha}, 0.6)
            else Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 350), BackgroundTransparency = 1}, 0.3); task.delay(0.3, function() if not Hub.GUI_Open then MainFrame.Visible = false end end) end
        end
    end)

    -- Close & Minimize
    CloseBtn.MouseButton1Click:Connect(function()
        Hub.GUI_Open = false; Tween(MainFrame, {Size = UDim2.new(0, 400, 0, 300), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function() pcall(function() ScreenGui:Destroy() end) end)
    end)
    MinBtn.MouseButton1Click:Connect(function()
        Hub.GUI_Open = false; Tween(MainFrame, {Size = UDim2.new(0, 500, 0, 350), BackgroundTransparency = 1}, 0.25)
        task.delay(0.25, function() if not Hub.GUI_Open then MainFrame.Visible = false end end)
    end)

    -- Animacion de entrada
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    if MainStroke then pcall(function() MainStroke.Transparency = 1 end) end

    Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 460), BackgroundTransparency = Theme.BackgroundAlpha}, 0.8, Enum.EasingStyle.Exponential)
    if MainStroke then pcall(function() Tween(MainStroke, {Transparency = 0.1}, 1, Enum.EasingStyle.Quad) end) end

    -- Particulas flotantes
    task.spawn(function()
        while task.wait(1.5) do
            if not lowGFX and MainFrame and MainFrame.Parent then
                pcall(function()
                    local orb = Instance.new("Frame")
                    orb.BackgroundColor3 = Theme.AccentLight; orb.BorderSizePixel = 0
                    orb.Size = UDim2.new(0, math.random(4, 9), 0, math.random(4, 9))
                    orb.Position = UDim2.new(math.random(), 0, 1.2, 0)
                    orb.BackgroundTransparency = 0.4
                    CreateCorner(orb, 100); orb.Parent = ParticleHolder
                    Tween(orb, {Position = UDim2.new(math.random(), 0, -0.2, 0), BackgroundTransparency = 1}, math.random(5, 10), Enum.EasingStyle.Linear)
                    task.delay(10, function() pcall(function() orb:Destroy() end) end)
                end)
            end
        end
    end)

    -- Crear Tab
    function Hub:CreateTab(tabName, tabIcon, order)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName
        tabBtn.Size = UDim2.new(1, 0, 0, 38)
        tabBtn.BackgroundColor3 = Theme.Accent
        tabBtn.BackgroundTransparency = 1
        tabBtn.Text = (tabIcon or "") .. "  " .. tabName
        tabBtn.TextSize = 14
        tabBtn.Font = Theme.Font
        tabBtn.TextColor3 = Theme.TextDim
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.BorderSizePixel = 0
        tabBtn.LayoutOrder = order or (#Hub.TabButtons + 1)
        tabBtn.Parent = SidebarScroll
        CreateCorner(tabBtn, 8)

        local tabPad = Instance.new("UIPadding")
        tabPad.PaddingLeft = UDim.new(0, 12)
        tabPad.Parent = tabBtn

        local page = Instance.new("ScrollingFrame")
        page.Name = tabName .. "Page"
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1; page.BorderSizePixel = 0
        page.ScrollBarThickness = 4; page.ScrollBarImageColor3 = Theme.AccentLight
        page.Visible = false
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Parent = ContentArea

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.SortOrder = Enum.SortOrder.LayoutOrder; pageLayout.Padding = UDim.new(0, 6); pageLayout.Parent = page

        local pagePad = Instance.new("UIPadding")
        pagePad.PaddingTop = UDim.new(0, 6); pagePad.PaddingLeft = UDim.new(0, 8)
        pagePad.PaddingRight = UDim.new(0, 8); pagePad.PaddingBottom = UDim.new(0, 10)
        pagePad.Parent = page

        Hub.TabButtons[tabName] = tabBtn
        Hub.TabPages[tabName] = page

        if not Hub.ActiveTab then
            Hub.ActiveTab = tabName; tabBtn.BackgroundTransparency = 0.6; tabBtn.TextColor3 = Theme.Text; page.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(function()
            if Hub.ActiveTab == tabName then return end
            Hub.ActiveTab = tabName
            for n, b in pairs(Hub.TabButtons) do
                local isActive = (n == tabName)
                Tween(b, {BackgroundTransparency = isActive and 0.6 or 1}, 0.25)
                b.TextColor3 = isActive and Theme.Text or Theme.TextDim
            end
            for n, p in pairs(Hub.TabPages) do
                if n == tabName then p.Visible = true; p.Position = UDim2.new(0, 40, 0, 0); Tween(p, {Position = UDim2.new(0, 0, 0, 0)}, 0.5, Enum.EasingStyle.Quart)
                else p.Visible = false end
            end
            Ripple(tabBtn)
        end)

        return page
    end

    function Hub:Destroy()
        Hub.GUI_Open = false
        Tween(MainFrame, {Size = UDim2.new(0, 400, 0, 300), BackgroundTransparency = 1}, 0.3)
        task.delay(0.3, function() pcall(function() ScreenGui:Destroy() end) end)
    end

    print("[AlchemyLib] Hub created successfully!")
    return Hub
end

print("[AlchemyLib] Library loaded successfully!")
return AlchemyLib
