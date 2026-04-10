--[[
    🧪 ALCHEMY UI LIBRARY v1.2 - PROFESSIONAL EDITION
    Modern, Modular, and Aesthetics UI Engine.
    Created by Alchemy Studios.
]]

local AlchemyLib = {}

-- ══════════════════════════════════════
--          SERVICIOS PRINCIPALES
-- ══════════════════════════════════════
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- ══════════════════════════════════════
--             CONFIGURACIÓN THEME
-- ══════════════════════════════════════
local Theme = {
    Background = Color3.fromRGB(12, 8, 20),
    Secondary = Color3.fromRGB(18, 12, 30),
    Tertiary = Color3.fromRGB(25, 18, 40),
    Accent = Color3.fromRGB(170, 60, 255),
    AccentLight = Color3.fromRGB(220, 130, 255),
    AccentDark = Color3.fromRGB(110, 30, 200),
    Text = Color3.fromRGB(255, 245, 255),
    TextDim = Color3.fromRGB(180, 160, 200),
    Border = Color3.fromRGB(90, 40, 140),
    Danger = Color3.fromRGB(255, 60, 90),
    Warning = Color3.fromRGB(255, 180, 50),
    Success = Color3.fromRGB(50, 255, 150),
    BackgroundAlpha = 0.5,
    SecondaryAlpha = 0.6,
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.GothamMedium,
}

-- ══════════════════════════════════════
--           UTILIDADES INTERNAS
-- ══════════════════════════════════════
local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, trans)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = trans or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, c1, c2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(c1, c2)
    gradient.Rotation = rotation or 90
    gradient.Parent = parent
    return gradient
end

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.Parent = parent
    return shadow
end

local function Tween(obj, props, duration, style, direction)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local twin = TweenService:Create(obj, info, props)
    twin:Play()
    return twin
end

local function Ripple(button)
    task.spawn(function()
        local ripple = Instance.new("Frame")
        ripple.Name = "Ripple"
        ripple.BackgroundColor3 = Theme.AccentLight
        ripple.BackgroundTransparency = 0.6
        ripple.BorderSizePixel = 0
        ripple.ZIndex = button.ZIndex + 1
        ripple.Parent = button
        CreateCorner(ripple, 100)

        local mousePos = UserInputService:GetMouseLocation()
        local absPos = button.AbsolutePosition
        local relX = mousePos.X - absPos.X
        local relY = mousePos.Y - absPos.Y
        ripple.Position = UDim2.new(0, relX, 0, relY)
        ripple.Size = UDim2.new(0, 0, 0, 0)

        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
        Tween(ripple, {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            Position = UDim2.new(0, relX - maxSize/2, 0, relY - maxSize/2),
            BackgroundTransparency = 1
        }, 0.7, Enum.EasingStyle.Sine)
        task.wait(0.7)
        ripple:Destroy()
    end)
end

-- ══════════════════════════════════════
--           MOTOR DE LA LIBRERÍA
-- ══════════════════════════════════════
function AlchemyLib:CreateWindow(config)
    config = config or {}
    local TitleText = config.Title or "ALCHEMY HUB"
    local VersionText = config.Version or "v1.2"
    local LogoID = config.Logo or "rbxassetid://131779754659128"
    local ToggleKey = config.Keybind or Enum.KeyCode.Y
    
    local gui_open = true
    local active_tab = nil
    
    -- Destruir anterior
    if CoreGui:FindFirstChild("AlchemyUI") then CoreGui.AlchemyUI:Destroy() end

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AlchemyUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = (RunService:IsStudio() and game.Players.LocalPlayer:WaitForChild("PlayerGui")) or CoreGui

    -- Main Frame
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
    local MainStroke = CreateStroke(MainFrame, Theme.Accent, 2, 0.2)
    local MainGradient = CreateGradient(MainStroke, Theme.AccentDark, Theme.AccentLight, 0)
    CreateShadow(MainFrame)

    -- Particle Effect
    local ParticleHolder = Instance.new("Frame")
    ParticleHolder.Size = UDim2.new(1, 0, 1, 0)
    ParticleHolder.BackgroundTransparency = 1
    ParticleHolder.ZIndex = 0
    ParticleHolder.Parent = MainFrame

    task.spawn(function()
        while MainFrame.Parent do
            local p = Instance.new("Frame")
            p.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
            p.Position = UDim2.new(math.random(), 0, 1.1, 0)
            p.BackgroundColor3 = Theme.AccentLight
            p.BackgroundTransparency = 0.5
            p.BorderSizePixel = 0
            p.Parent = ParticleHolder
            CreateCorner(p, 100)
            Tween(p, {Position = UDim2.new(p.Position.X.Scale, 0, -0.1, 0), BackgroundTransparency = 1}, math.random(5, 10))
            task.delay(10, function() p:Destroy() end)
            task.wait(0.4)
        end
    end)

    -- Animated Border
    task.spawn(function()
        local rot = 0
        while MainFrame.Parent do
            rot = (rot + 1) % 360
            MainGradient.Rotation = rot
            task.wait(0.02)
        end
    end)

    -- Dragging
    local dragging, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.BackgroundTransparency = Theme.SecondaryAlpha
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleIcon = Instance.new("ImageLabel")
    TitleIcon.Size = UDim2.new(0, 32, 0, 32)
    TitleIcon.Position = UDim2.new(0, 15, 0.5, -16)
    TitleIcon.BackgroundTransparency = 1
    TitleIcon.Image = LogoID
    TitleIcon.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, 55, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = TitleText
    TitleLabel.TextSize = 17
    TitleLabel.Font = Theme.Font
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 50, 1, 0)
    VersionLabel.Position = UDim2.new(0, 210, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = VersionText
    VersionLabel.TextSize = 12
    VersionLabel.Font = Theme.FontLight
    VersionLabel.TextColor3 = Theme.AccentLight
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TitleBar

    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -45, 0.5, -16)
    CloseBtn.BackgroundColor3 = Theme.Danger
    CloseBtn.BackgroundTransparency = 0.8
    CloseBtn.Text = "❌"
    CloseBtn.Font = Theme.Font
    CloseBtn.Parent = TitleBar
    CreateCorner(CloseBtn, 8)
    CloseBtn.MouseButton1Click:Connect(function() 
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = MainFrame.Position + UDim2.new(0, 325, 0, 230)}, 0.4)
        task.delay(0.4, function() ScreenGui:Destroy() end)
    end)

    -- Toggle Logic
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            gui_open = not gui_open
            if gui_open then
                MainFrame.Visible = true; Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 460)}, 0.5, Enum.EasingStyle.Back)
            else
                Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 0)}, 0.3)
                task.delay(0.3, function() if not gui_open then MainFrame.Visible = false end end)
            end
        end
    end)

    -- Panels
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -50)
    Sidebar.Position = UDim2.new(0, 0, 0, 50)
    Sidebar.BackgroundColor3 = Theme.Secondary
    Sidebar.BackgroundTransparency = Theme.SecondaryAlpha + 0.1
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarScroll.Parent = Sidebar
    Instance.new("UIListLayout", SidebarScroll).Padding = UDim.new(0, 4)
    Instance.new("UIPadding", SidebarScroll).PaddingLeft = UDim.new(0, 8); SidebarScroll.UIPadding.PaddingRight = UDim.new(0, 8); SidebarScroll.UIPadding.PaddingTop = UDim.new(0, 10)

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -160, 1, -50)
    ContentArea.Position = UDim2.new(0, 160, 0, 50)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame

    -- Methods
    local Window = {}

    function Window:CreateTab(name, emoji)
        local Tab = {}
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 38)
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.BackgroundTransparency = 1
        TabButton.Text = (emoji or "📂") .. "  " .. name
        TabButton.TextSize = 14
        TabButton.Font = Theme.Font
        TabButton.TextColor3 = Theme.TextDim
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = SidebarScroll
        CreateCorner(TabButton, 8)
        Instance.new("UIPadding", TabButton).PaddingLeft = UDim.new(0, 12)

        local Page = Instance.new("ScrollingFrame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.AccentLight
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Parent = ContentArea
        local pl = Instance.new("UIListLayout", Page); pl.Padding = UDim.new(0, 6); pl.SortOrder = Enum.SortOrder.LayoutOrder
        Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 12); Page.UIPadding.PaddingRight = UDim.new(0, 12); Page.UIPadding.PaddingTop = UDim.new(0, 10); Page.UIPadding.PaddingBottom = UDim.new(0, 10)

        local function Select()
            for _, btn in pairs(SidebarScroll:GetChildren()) do if btn:IsA("TextButton") then Tween(btn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}, 0.2) end end
            for _, pg in pairs(ContentArea:GetChildren()) do if pg:IsA("ScrollingFrame") then pg.Visible = false end end
            active_tab = name; Tween(TabButton, {BackgroundTransparency = 0.6, TextColor3 = Theme.Text}, 0.2)
            Page.Visible = true; Page.Position = UDim2.new(0, 20, 0, 0); Tween(Page, {Position = UDim2.new(0, 0, 0, 0)}, 0.4)
        end
        TabButton.MouseButton1Click:Connect(Select)
        if not active_tab then Select() end

        -- Tab UI Elements
        function Tab:CreateSection(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 35)
            label.BackgroundTransparency = 1
            label.Text = string.upper(text)
            label.TextSize = 13
            label.Font = Theme.Font
            label.TextColor3 = Theme.AccentLight
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.TextYAlignment = Enum.TextYAlignment.Bottom
            label.LayoutOrder = #Page:GetChildren()
            label.Parent = Page
        end

        function Tab:CreateToggle(name, default, callback)
            local state = default or false
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 44); holder.BackgroundColor3 = Theme.Tertiary; holder.BackgroundTransparency = 0.2; holder.LayoutOrder = #Page:GetChildren(); holder.Parent = Page
            CreateCorner(holder, 8); CreateStroke(holder, Theme.Border, 1.5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -60, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.BackgroundTransparency = 1
            l.Text = name; l.TextSize = 14; l.Font = Theme.FontLight; l.TextColor3 = Theme.Text; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = holder

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 46, 0, 24); bg.Position = UDim2.new(1, -56, 0.5, -12); bg.BackgroundColor3 = state and Theme.Accent or Theme.Secondary; bg.Parent = holder
            CreateCorner(bg, 100)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 20, 0, 20); knob.Position = UDim2.new(0, state and 24 or 2, 0.5, -10); knob.BackgroundColor3 = Theme.Text; knob.Parent = bg
            CreateCorner(knob, 100)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = holder
            btn.MouseButton1Click:Connect(function()
                state = not state
                Tween(bg, {BackgroundColor3 = state and Theme.Accent or Theme.Secondary}, 0.3)
                Tween(knob, {Position = UDim2.new(0, state and 24 or 2, 0.5, -10)}, 0.3)
                Ripple(holder)
                if callback then callback(state) end
            end)
            return {Set = function(v) state = v; Tween(bg, {BackgroundColor3 = state and Theme.Accent or Theme.Secondary}, 0.3); Tween(knob, {Position = UDim2.new(0, state and 24 or 2, 0.5, -10)}, 0.3) end}
        end

        function Tab:CreateButton(name, callback)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 44); holder.BackgroundTransparency = 1; holder.LayoutOrder = #Page:GetChildren(); holder.Parent = Page
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0); b.BackgroundColor3 = Theme.Accent; b.Text = name; b.TextSize = 14; b.TextColor3 = Theme.Text; b.Font = Theme.Font; b.Parent = holder
            CreateCorner(b, 8); CreateGradient(b, Theme.AccentDark, Theme.AccentLight, -45); CreateShadow(b)
            b.MouseButton1Click:Connect(function() Ripple(b); if callback then callback() end end)
        end

        function Tab:CreateSlider(name, min, max, default, callback)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 60); holder.BackgroundColor3 = Theme.Tertiary; holder.BackgroundTransparency = 0.2; holder.LayoutOrder = #Page:GetChildren(); holder.Parent = Page
            CreateCorner(holder, 8); CreateStroke(holder, Theme.Border, 1.5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(0.6, 0, 0, 25); l.Position = UDim2.new(0, 12, 0, 5); l.BackgroundTransparency = 1; l.Text = name; l.TextSize = 14; l.Font = Theme.FontLight; l.TextColor3 = Theme.Text; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = holder
            
            local v = Instance.new("TextLabel")
            v.Size = UDim2.new(0.4, 0, 0, 25); v.Position = UDim2.new(0.6, -12, 0, 5); v.BackgroundTransparency = 1; v.Text = tostring(default); v.TextSize = 14; v.Font = Theme.Font; v.TextColor3 = Theme.AccentLight; v.TextXAlignment = Enum.TextXAlignment.Right; v.Parent = holder

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, -24, 0, 6); bg.Position = UDim2.new(0, 12, 0, 42); bg.BackgroundColor3 = Theme.Secondary; bg.Parent = holder; CreateCorner(bg, 100)
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; fill.Parent = bg; CreateCorner(fill, 100)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 14, 0, 14); knob.Position = UDim2.new(1, -7, 0.5, -7); knob.BackgroundColor3 = Theme.Text; knob.Parent = fill; CreateCorner(knob, 100)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 2, 0); btn.Position = UDim2.new(0, 0, -0.5, 0); btn.BackgroundTransparency = 1; btn.Text = ""; btn.Parent = bg

            local function update(input)
                local per = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * per)
                fill.Size = UDim2.new(per, 0, 1, 0)
                v.Text = tostring(val)
                if callback then callback(val) end
            end

            local dragging = false
            btn.MouseButton1Down:Connect(function(input) dragging = true; update(input) end)
            UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
            UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then update(i) end end)
        end

        function Tab:CreateTextBox(name, placeholder, callback)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 68); holder.BackgroundColor3 = Theme.Tertiary; holder.BackgroundTransparency = 0.2; holder.LayoutOrder = #Page:GetChildren(); holder.Parent = Page
            CreateCorner(holder, 8); CreateStroke(holder, Theme.Border, 1.5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -24, 0, 25); l.Position = UDim2.new(0, 12, 0, 5); l.BackgroundTransparency = 1; l.Text = name; l.TextSize = 13; l.Font = Theme.Font; l.TextColor3 = Theme.AccentLight; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = holder

            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -24, 0, 32); box.Position = UDim2.new(0, 12, 0, 30); box.BackgroundColor3 = Theme.Secondary; box.Text = ""; box.PlaceholderText = placeholder or "..."; box.TextColor3 = Theme.Text; box.Font = Theme.FontLight; box.TextSize = 14; box.Parent = holder
            CreateCorner(box, 6); CreateStroke(box, Theme.Accent, 1)

            box.FocusLost:Connect(function(enter) if callback then callback(box.Text, enter) end end)
        end

        function Tab:CreateKeybind(name, default, callback)
            local holder = Instance.new("Frame")
            holder.Size = UDim2.new(1, 0, 0, 44); holder.BackgroundColor3 = Theme.Tertiary; holder.BackgroundTransparency = 0.2; holder.LayoutOrder = #Page:GetChildren(); holder.Parent = Page
            CreateCorner(holder, 8); CreateStroke(holder, Theme.Border, 1.5)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -120, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.BackgroundTransparency = 1
            l.Text = name; l.TextSize = 14; l.Font = Theme.FontLight; l.TextColor3 = Theme.Text; l.TextXAlignment = Enum.TextXAlignment.Left; l.Parent = holder

            local binder = Instance.new("TextButton")
            binder.Size = UDim2.new(0, 90, 0, 28); binder.Position = UDim2.new(1, -102, 0.5, -14); binder.BackgroundColor3 = Theme.Secondary; binder.Text = default.Name; binder.TextSize = 12; binder.Font = Theme.Font; binder.TextColor3 = Theme.AccentLight; binder.Parent = holder
            CreateCorner(binder, 6); CreateStroke(binder, Theme.Accent, 1)

            local isBinding = false
            binder.MouseButton1Click:Connect(function()
                isBinding = true; binder.Text = "..."; Ripple(binder)
                local conn; conn = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        binder.Text = i.KeyCode.Name; isBinding = false; conn:Disconnect()
                        if callback then callback(i.KeyCode) end
                    end
                end)
            end)
        end

        return Tab
    end

    return Window
end

return AlchemyLib
