-- Fly GUI Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI if it exists
if playerGui:FindFirstChild("FlyGUI") then
    playerGui.FlyGUI:Destroy()
end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Create main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- UI Corner
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Fly GUI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-- Fly button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -20, 0, 30)
flyBtn.Position = UDim2.new(0, 10, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyBtn.Text = "Toggle Fly"
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.SourceSansBold
flyBtn.TextSize = 18
flyBtn.Parent = frame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 8)
flyCorner.Parent = flyBtn

-- Noclip button
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(1, -20, 0, 30)
noclipBtn.Position = UDim2.new(0, 10, 0, 80)
noclipBtn.BackgroundColor3 = Color3.fromRGB(178, 34, 34)
noclipBtn.Text = "Toggle Noclip"
noclipBtn.TextColor3 = Color3.new(1,1,1)
noclipBtn.Font = Enum.Font.SourceSansBold
noclipBtn.TextSize = 18
noclipBtn.Parent = frame

local noclipCorner = Instance.new("UICorner")
noclipCorner.CornerRadius = UDim.new(0, 8)
noclipCorner.Parent = noclipBtn

-- Fly logic
local flying = false
local flySpeed = 50
local bodyGyro, bodyVel

local function startFlying()
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart")
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.new(0,0,0)
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Parent = root

    RunService.RenderStepped:Connect(function()
        if flying and root and bodyVel and bodyGyro then
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
            end
            bodyVel.Velocity = moveDir * flySpeed
        end
    end)
end

local function stopFlying()
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
end

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        startFlying()
        flyBtn.Text = "Flying..."
    else
        stopFlying()
        flyBtn.Text = "Toggle Fly"
    end
end)

-- Noclip logic
local noclip = false

local function toggleNoclip()
    noclip = not noclip
    if noclip then
        noclipBtn.Text = "Noclip ON"
        RunService.Stepped:Connect(function()
            if noclip then
                local char = player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "Toggle Noclip"
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

noclipBtn.MouseButton1Click:Connect(toggleNoclip)
