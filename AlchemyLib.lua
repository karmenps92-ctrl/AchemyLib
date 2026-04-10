--[[
    ╔═══════════════════════════════════════════════════╗
    ║                 ALCHEMY UI LIBRARY                ║
    ║           Modular UI System for Roblox            ║
    ║           Created by Alchemy Studios              ║
    ╚═══════════════════════════════════════════════════╝
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
    Background = Color3.fromRGB(10, 10, 15),
    Secondary = Color3.fromRGB(15, 15, 25),
    Tertiary = Color3.fromRGB(20, 20, 35),
    Accent = Color3.fromRGB(80, 50, 240),      -- Púrpura principal
    AccentLight = Color3.fromRGB(130, 90, 255),
    AccentDark = Color3.fromRGB(50, 30, 150),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 200),
    Border = Color3.fromRGB(40, 40, 60),
    Danger = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 200, 80),
    Success = Color3.fromRGB(80, 255, 150),
    BackgroundAlpha = 0.15,
    SecondaryAlpha = 0.2,
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.Gotham,
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
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
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

local function BumpyTween(obj, props, duration)
    return Tween(obj, props, duration or 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
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
    local TitleText = config.Title or "Alchemy Hub"
    local VersionText = config.Version or "v1.0"
    local AuthorText = config.Author or "By Alchemy Studios"
    local LogoID = config.Logo or ""
    local ToggleKey = config.Keybind or Enum.KeyCode.Y
    
    local gui_open = true
    local active_tab = nil
    local tabs = {}
    local pages = {}

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
    local MainStroke = CreateStroke(MainFrame, Theme.Accent, 2, 0.1)
    local MainGradient = CreateGradient(MainStroke, Theme.AccentDark, Theme.AccentLight, 0)
    CreateShadow(MainFrame)

    -- Floating Particles
    local ParticleHolder = Instance.new("Frame")
    ParticleHolder.Size = UDim2.new(1, 0, 1, 0)
    ParticleHolder.BackgroundTransparency = 1
    ParticleHolder.ZIndex = 0
    ParticleHolder.Parent = MainFrame

    local function CreateParticle()
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, math.random(2, 5), 0, math.random(2, 5))
        p.Position = UDim2.new(math.random(), 0, 1, 10)
        p.BackgroundColor3 = Theme.AccentLight
        p.BackgroundTransparency = math.random(4, 8)/10
        p.BorderSizePixel = 0
        p.ZIndex = 0
        p.Parent = ParticleHolder
        CreateCorner(p, 100)
        local drift = (math.random() - 0.5) * 0.2
        Tween(p, {Position = UDim2.new(p.Position.X.Scale + drift, 0, -0.1, 0), BackgroundTransparency = 1}, math.random(4, 8))
        task.delay(8, function() p:Destroy() end)
    end
    task.spawn(function()
        while MainFrame.Parent do
            CreateParticle()
            task.wait(0.3)
        end
    end)

    -- Dynamic Border Animation
    task.spawn(function()
        local rot = 0
        while MainFrame.Parent do
            rot = (rot + 1) % 360
            MainGradient.Rotation = rot
            task.wait(0.02)
        end
    end)

    -- Dragging Logic
    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 50)
    TitleBar.BackgroundColor3 = Theme.Secondary
    TitleBar.BackgroundTransparency = Theme.SecondaryAlpha
    TitleBar.BorderSizePixel = 0
    TitleBar.ZIndex = 2
    TitleBar.Parent = MainFrame

    if LogoID ~= "" then
        local TitleIcon = Instance.new("ImageLabel")
        TitleIcon.Size = UDim2.new(0, 32, 0, 32)
        TitleIcon.Position = UDim2.new(0, 15, 0.5, -16)
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.Image = LogoID
        TitleIcon.Parent = TitleBar
    end

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(0, 200, 1, 0)
    TitleLabel.Position = UDim2.new(0, (LogoID ~= "" and 55 or 15), 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = string.upper(TitleText)
    TitleLabel.TextSize = 17
    TitleLabel.Font = Theme.Font
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0, 50, 1, 0)
    VersionLabel.Position = UDim2.new(0, (LogoID ~= "" and 210 or 170), 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = VersionText
    VersionLabel.TextSize = 12
    VersionLabel.Font = Theme.FontLight
    VersionLabel.TextColor3 = Theme.AccentLight
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = TitleBar

    -- Window Buttons
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -45, 0.5, -16)
    CloseBtn.BackgroundColor3 = Theme.Danger
    CloseBtn.BackgroundTransparency = 0.8
    CloseBtn.Text = "❌"
    CloseBtn.TextSize = 14
    CloseBtn.Font = Theme.Font
    CloseBtn.Parent = TitleBar
    CreateCorner(CloseBtn, 8)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 32, 0, 32)
    MinBtn.Position = UDim2.new(1, -85, 0.5, -16)
    MinBtn.BackgroundColor3 = Theme.Warning
    MinBtn.BackgroundTransparency = 0.8
    MinBtn.Text = "➖"
    MinBtn.TextSize = 14
    MinBtn.Font = Theme.Font
    MinBtn.Parent = TitleBar
    CreateCorner(MinBtn, 8)

    local isMinimized = false
    MinBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 50)}, 0.4)
        else
            BumpyTween(MainFrame, {Size = UDim2.new(0, 650, 0, 460)}, 0.4)
        end
    end)

    -- Separator
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
    Sidebar.Size = UDim2.new(0, 160, 1, -51)
    Sidebar.Position = UDim2.new(0, 0, 0, 51)
    Sidebar.BackgroundColor3 = Theme.Secondary
    Sidebar.BackgroundTransparency = Theme.SecondaryAlpha + 0.15
    Sidebar.BorderSizePixel = 0
    Sidebar.ZIndex = 2
    Sidebar.Parent = MainFrame

    local SidebarScroll = Instance.new("ScrollingFrame")
    SidebarScroll.Size = UDim2.new(1, 0, 1, 0)
    SidebarScroll.BackgroundTransparency = 1
    SidebarScroll.BorderSizePixel = 0
    SidebarScroll.ScrollBarThickness = 0
    SidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    SidebarScroll.Parent = Sidebar

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 4)
    SidebarLayout.Parent = SidebarScroll

    local SidebarPad = Instance.new("UIPadding")
    SidebarPad.PaddingTop = UDim.new(0, 10)
    SidebarPad.PaddingLeft = UDim.new(0, 8)
    SidebarPad.PaddingRight = UDim.new(0, 8)
    SidebarPad.Parent = SidebarScroll

    -- Content Area
    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, -160, 1, -51)
    ContentArea.Position = UDim2.new(0, 160, 0, 51)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.ZIndex = 2
    ContentArea.Parent = MainFrame

    -- Toggle visibility
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            gui_open = not gui_open
            if gui_open then
                MainFrame.Visible = true
                BumpyTween(MainFrame, {Size = UDim2.new(0, 650, 0, 460)}, 0.5)
            else
                Tween(MainFrame, {Size = UDim2.new(0, 650, 0, 0)}, 0.3)
                task.delay(0.3, function() if not gui_open then MainFrame.Visible = false end end)
            end
        end
    end)

    -- Window Object
    local Window = {}
    
    function Window:CreateTab(name, emoji)
        emoji = emoji or "📁"
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "Tab"
        TabButton.Size = UDim2.new(1, 0, 0, 38)
        TabButton.BackgroundColor3 = Theme.Accent
        TabButton.BackgroundTransparency = 1
        TabButton.Text = emoji .. "  " .. name
        TabButton.TextSize = 14
        TabButton.Font = Theme.Font
        TabButton.TextColor3 = Theme.TextDim
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = SidebarScroll
        CreateCorner(TabButton, 8)
        local btnPad = Instance.new("UIPadding")
        btnPad.PaddingLeft = UDim.new(0, 12)
        btnPad.Parent = TabButton

        local Page = Instance.new("ScrollingFrame")
        Page.Name = name .. "Page"
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 2
        Page.ScrollBarImageColor3 = Theme.AccentLight
        Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Page.Parent = ContentArea
        
        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = Page
        
        local PagePad = Instance.new("UIPadding")
        PagePad.PaddingTop = UDim.new(0, 10)
        PagePad.PaddingLeft = UDim.new(0, 15)
        PagePad.PaddingRight = UDim.new(0, 15)
        PagePad.Parent = Page

        local function Select()
            active_tab = name
            for _, btn in pairs(SidebarScroll:GetChildren()) do
                if btn:IsA("TextButton") then
                    Tween(btn, {BackgroundTransparency = 1, TextColor3 = Theme.TextDim}, 0.2)
                end
            end
            for _, pg in pairs(ContentArea:GetChildren()) do
                if pg:IsA("ScrollingFrame") then pg.Visible = false end
            end
            
            Tween(TabButton, {BackgroundTransparency = 0.6, TextColor3 = Theme.Text}, 0.2)
            Page.Visible = true
        end

        TabButton.MouseButton1Click:Connect(Select)
        if not active_tab then Select() end

        -- Tab Methods
        local Tab = {}
        
        function Tab:CreateSection(title)
            local sec = Instance.new("TextLabel")
            sec.Size = UDim2.new(1, 0, 0, 32)
            sec.BackgroundTransparency = 1
            sec.Text = string.upper(title)
            sec.TextSize = 13
            sec.Font = Theme.Font
            sec.TextColor3 = Theme.AccentLight
            sec.TextXAlignment = Enum.TextXAlignment.Left
            sec.TextYAlignment = Enum.TextYAlignment.Bottom
            sec.Parent = Page
            return sec
        end

        function Tab:CreateButton(name, callback)
            local btnFrame = Instance.new("Frame")
            btnFrame.Size = UDim2.new(1, 0, 0, 42)
            btnFrame.BackgroundTransparency = 1
            btnFrame.Parent = Page
            
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3 = Theme.Tertiary
            btn.Text = name
            btn.TextSize = 14
            btn.TextColor3 = Theme.Text
            btn.Font = Theme.Font
            btn.Parent = btnFrame
            CreateCorner(btn, 8)
            CreateStroke(btn, Theme.Border, 1)

            btn.MouseButton1Click:Connect(function()
                Ripple(btn)
                if callback then callback() end
            end)
            return btn
        end

        function Tab:CreateToggle(name, default, callback)
            local toggleEnabled = default or false
            local tFrame = Instance.new("Frame")
            tFrame.Size = UDim2.new(1, 0, 0, 42)
            tFrame.BackgroundColor3 = Theme.Tertiary
            tFrame.Parent = Page
            CreateCorner(tFrame, 8)
            CreateStroke(tFrame, Theme.Border, 1)

            local tLabel = Instance.new("TextLabel")
            tLabel.Size = UDim2.new(1, -60, 1, 0)
            tLabel.Position = UDim2.new(0, 12, 0, 0)
            tLabel.BackgroundTransparency = 1
            tLabel.Text = name
            tLabel.TextSize = 14
            tLabel.Font = Theme.FontLight
            tLabel.TextColor3 = Theme.Text
            tLabel.TextXAlignment = Enum.TextXAlignment.Left
            tLabel.Parent = tFrame

            local switch = Instance.new("Frame")
            switch.Size = UDim2.new(0, 36, 0, 20)
            switch.Position = UDim2.new(1, -48, 0.5, -10)
            switch.BackgroundColor3 = toggleEnabled and Theme.Accent or Theme.Secondary
            switch.Parent = tFrame
            CreateCorner(switch, 100)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 16, 0, 16)
            circle.Position = UDim2.new(0, toggleEnabled and 18 or 2, 0.5, -8)
            circle.BackgroundColor3 = Theme.Text
            circle.Parent = switch
            CreateCorner(circle, 100)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = tFrame

            btn.MouseButton1Click:Connect(function()
                toggleEnabled = not toggleEnabled
                Tween(switch, {BackgroundColor3 = toggleEnabled and Theme.Accent or Theme.Secondary}, 0.2)
                Tween(circle, {Position = UDim2.new(0, toggleEnabled and 18 or 2, 0.5, -8)}, 0.2)
                if callback then callback(toggleEnabled) end
            end)
        end

        function Tab:CreateSlider(name, min, max, default, callback)
            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, 0, 0, 50)
            sFrame.BackgroundColor3 = Theme.Tertiary
            sFrame.Parent = Page
            CreateCorner(sFrame, 8)
            CreateStroke(sFrame, Theme.Border, 1)

            local sLabel = Instance.new("TextLabel")
            sLabel.Size = UDim2.new(1, -80, 0, 25)
            sLabel.Position = UDim2.new(0, 12, 0, 5)
            sLabel.BackgroundTransparency = 1
            sLabel.Text = name
            sLabel.TextSize = 14
            sLabel.Font = Theme.FontLight
            sLabel.TextColor3 = Theme.Text
            sLabel.TextXAlignment = Enum.TextXAlignment.Left
            sLabel.Parent = sFrame

            local vaLabel = Instance.new("TextLabel")
            vaLabel.Size = UDim2.new(0, 60, 0, 25)
            vaLabel.Position = UDim2.new(1, -72, 0, 5)
            vaLabel.BackgroundTransparency = 1
            vaLabel.Text = tostring(default)
            vaLabel.TextSize = 14
            vaLabel.Font = Theme.Font
            vaLabel.TextColor3 = Theme.AccentLight
            vaLabel.TextXAlignment = Enum.TextXAlignment.Right
            vaLabel.Parent = sFrame

            local barBG = Instance.new("Frame")
            barBG.Size = UDim2.new(1, -24, 0, 4)
            barBG.Position = UDim2.new(0, 12, 0, 35)
            barBG.BackgroundColor3 = Theme.Secondary
            barBG.Parent = sFrame
            CreateCorner(barBG, 100)

            local barFill = Instance.new("Frame")
            barFill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            barFill.BackgroundColor3 = Theme.Accent
            barFill.Parent = barBG
            CreateCorner(barFill, 100)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 12, 0, 12)
            circle.Position = UDim2.new(1, -6, 0.5, -6)
            circle.BackgroundColor3 = Theme.Text
            circle.Parent = barFill
            CreateCorner(circle, 100)

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.Parent = barBG

            local function Update(input)
                local pos = math.clamp((input.Position.X - barBG.AbsolutePosition.X) / barBG.AbsoluteSize.X, 0, 1)
                barFill.Size = UDim2.new(pos, 0, 1, 0)
                local val = math.floor(min + (max - min) * pos)
                vaLabel.Text = tostring(val)
                if callback then callback(val) end
            end

            local sliding = false
            btn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
            end)
            btn.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then Update(input) end
            end)
        end

        function Tab:CreateKeybind(name, default, callback)
            local kFrame = Instance.new("Frame")
            kFrame.Size = UDim2.new(1, 0, 0, 42)
            kFrame.BackgroundColor3 = Theme.Tertiary
            kFrame.Parent = Page
            CreateCorner(kFrame, 8)
            CreateStroke(kFrame, Theme.Border, 1)

            local kLabel = Instance.new("TextLabel")
            kLabel.Size = UDim2.new(1, -120, 1, 0)
            kLabel.Position = UDim2.new(0, 12, 0, 0)
            kLabel.BackgroundTransparency = 1
            kLabel.Text = name
            kLabel.TextSize = 14
            kLabel.Font = Theme.FontLight
            kLabel.TextColor3 = Theme.Text
            kLabel.TextXAlignment = Enum.TextXAlignment.Left
            kLabel.Parent = kFrame

            local binder = Instance.new("TextButton")
            binder.Size = UDim2.new(0, 90, 0, 26)
            binder.Position = UDim2.new(1, -102, 0.5, -13)
            binder.BackgroundColor3 = Theme.Secondary
            binder.Text = default.Name
            binder.TextSize = 12
            binder.Font = Theme.Font
            binder.TextColor3 = Theme.AccentLight
            binder.Parent = kFrame
            CreateCorner(binder, 6)
            CreateStroke(binder, Theme.Accent, 1)

            local isBinding = false
            binder.MouseButton1Click:Connect(function()
                isBinding = true
                binder.Text = "..."
                local connection
                connection = UserInputService.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.Keyboard then
                        binder.Text = i.KeyCode.Name
                        isBinding = false
                        connection:Disconnect()
                        if callback then callback(i.KeyCode) end
                    end
                end)
            end)
        end

        return Tab
    end

    function Window:SelectTab(name)
        for _, btn in pairs(SidebarScroll:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name == name .. "Tab" then
                btn.MouseButton1Click:Fire()
                break
            end
        end
    end

    function Window:Notify(title, text, duration)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title or "Alchemy",
            Text = text or "Notificación",
            Duration = duration or 3
        })
    end

    return Window
end

return AlchemyLib
