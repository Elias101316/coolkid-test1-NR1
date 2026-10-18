-- Erstellt die UI im erlaubten PlayerGui (Verhindert den CoreGui-Block von Roblox)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- WICHTIG: Wartet, bis der Charakter im Spiel wirklich da ist, bevor die Buttons geladen werden!
local character = player.Character or player.CharacterAdded:Wait()

-- Verhindert, dass das Script doppelt geladen wird
if playerGui:FindFirstChild("C00lkiddHub") then
    playerGui:FindFirstChild("C00lkiddHub"):Destroy()
end

-- Haupt-Screengui
local sg = Instance.new("ScreenGui")
sg.Name = "C00lkiddHub"
sg.ResetOnSpawn = false -- Sorgt dafür, dass das Menü beim Sterben NICHT verschwindet
sg.Parent = playerGui

-- Das Hauptfenster (Schwarz mit rotem Rand)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0.4, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true -- Macht das Fenster verschiebbar
frame.Parent = sg

-- Titel-Zeile
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.BorderColor3 = Color3.fromRGB(255, 0, 0)
title.Text = "c00lkidd hub v2"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

-- Container für Buttons
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -10, 1, -50)
container.Position = UDim2.new(0, 5, 0, 45)
container.BackgroundTransparency = 1
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y
container.ScrollBarThickness = 4
container.Parent = frame

-- Liste für automatische Anordnung
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

-- FUNKTION: Buttons einfach erstellen
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    
    btn.MouseButton1Click:Connect(callback)
    btn.Parent = container
end

-- ========================================================
-- FEATURE-LOGIK & BUTTONS (Werden jetzt sicher geladen)
-- ========================================================

-- 1. Super Speed
createButton("Super Speed", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 120
    end
end)

-- 2. Mega Jump
createButton("Mega Jump", function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = 150
    end
end)

-- 3. Fast Spin
local spinning = false
createButton("Fast Spin (Toggle)", function()
    spinning = not spinning
    task.spawn(function()
        while spinning and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(45), 0)
            task.wait()
        end
    end)
end)

-- 4. Infinite Jump
local infJumpActive = false
createButton("Infinite Jump (Toggle)", function()
    infJumpActive = not infJumpActive
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpActive and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 5. Low Gravity
local normalGravity = workspace.Gravity
local lowGravActive = false
createButton("Low Gravity (Toggle)", function()
    lowGravActive = not lowGravActive
    if lowGravActive then
        workspace.Gravity = 30
    else
        workspace.Gravity = normalGravity
    end
end)

-- 6. Visuelle Nacht
createButton("Set Night Time", function()
    Lighting.ClockTime = 0
end)

-- 7. Visueller Roter Himmel
createButton("Red Skybox", function()
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj:IsA("Sky") then obj:Destroy() end
    end
    local sky = Instance.new("Sky")
    sky.SkyboxBk = "rbxassetid://260253139"
    sky.SkyboxDn = "rbxassetid://260253139"
    sky.SkyboxFt = "rbxassetid://260253139"
    sky.SkyboxLf = "rbxassetid://260253139"
    sky.SkyboxRt = "rbxassetid://260253139"
    sky.SkyboxUp = "rbxassetid://260253139"
    sky.Parent = Lighting
end)

-- ========================================================
-- MENÜ-STEUERUNG
-- ========================================================
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        frame.Visible = not frame.Visible
    end
end)
