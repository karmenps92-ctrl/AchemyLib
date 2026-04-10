-- ==========================================
-- 🧪 ALCHEMY UI LIBRARY v1.0
-- Motor gráfico para interfaces modernas
-- ==========================================
local AlchemyUI = {}
local TweenService = game:GetService("TweenService")

-- Tema de la UI original
AlchemyUI.Theme = {
    Background = Color3.fromRGB(15, 10, 25),
    BackgroundAlpha = 0.55,
    Secondary = Color3.fromRGB(22, 15, 35),
    Tertiary = Color3.fromRGB(30, 20, 45),
    Accent = Color3.fromRGB(170, 60, 255),
    AccentDark = Color3.fromRGB(110, 30, 200),
    AccentLight = Color3.fromRGB(220, 130, 255),
    Text = Color3.fromRGB(255, 245, 255),
    TextDim = Color3.fromRGB(180, 160, 200),
    ToggleOn = Color3.fromRGB(170, 60, 255),
    ToggleOff = Color3.fromRGB(40, 25, 60),
    Font = Enum.Font.GothamBold,
    FontLight = Enum.Font.GothamMedium,
}

function AlchemyUI:CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

function AlchemyUI:Tween(obj, props, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

-- ==========================================
-- CONSTRUCTORES DE ELEMENTOS
-- ==========================================

function AlchemyUI:CreateToggle(parent, name, default, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -16, 0, 44)
    holder.BackgroundColor3 = self.Theme.Tertiary
    holder.BackgroundTransparency = 0.2
    holder.BorderSizePixel = 0
    holder.Parent = parent
    self:CreateCorner(holder, 8)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = self.Theme.FontLight
    label.TextColor3 = self.Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = holder

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 46, 0, 24)
    toggleBg.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBg.BackgroundColor3 = default and self.Theme.ToggleOn or self.Theme.ToggleOff
    toggleBg.Parent = holder
    self:CreateCorner(toggleBg, 12)

    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 20, 0, 20)
    toggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.Parent = toggleBg
    self:CreateCorner(toggleCircle, 10)

    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = holder

    btn.MouseButton1Click:Connect(function()
        state = not state
        self:Tween(toggleBg, {BackgroundColor3 = state and self.Theme.ToggleOn or self.Theme.ToggleOff}, 0.35)
        self:Tween(toggleCircle, {Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)}, 0.3)
        if callback then callback(state) end
    end)

    return holder
end

function AlchemyUI:CreateButton(parent, name, callback)
    local btnFrame = Instance.new("Frame")
    btnFrame.Size = UDim2.new(1, -16, 0, 42)
    btnFrame.BackgroundTransparency = 1
    btnFrame.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundColor3 = self.Theme.Accent
    btn.BackgroundTransparency = 0.1
    btn.Text = name
    btn.TextColor3 = self.Theme.Text
    btn.Font = self.Theme.Font
    btn.Parent = btnFrame
    self:CreateCorner(btn, 8)

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return btnFrame
end

-- ESTA LÍNEA DEBE ESTAR HASTA ABAJO
return AlchemyUI
