# FLYGUI--// Services
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

--// GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 25)
title.BackgroundTransparency = 1
title.Text = "Fly Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -25, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Parent = frame

-- Fly Button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(1, -20, 0, 40)
flyBtn.Position = UDim2.new(0, 10, 0, 35)
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyBtn.Parent = frame

--// Fly logic
local flying = false
local speed = 50
local bodyGyro, bodyVel

local function startFly()
    flying = true
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.Velocity = Vector3.zero
    bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVel.Parent = rootPart

    RunService.RenderStepped:Connect(function()
        if flying then
            local camCF = workspace.CurrentCamera.CFrame
            local moveDir = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + camCF.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - camCF.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - camCF.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + camCF.RightVector
            end

            bodyGyro.CFrame = camCF
            bodyVel.Velocity = moveDir * speed
        end
    end)
end

local function stopFly()
    flying = false
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVel then bodyVel:Destroy() end
end

--// Button events
flyBtn.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyBtn.Text = "Fly: OFF"
    else
        startFly()
        flyBtn.Text = "Fly: ON"
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    stopFly()
end)
