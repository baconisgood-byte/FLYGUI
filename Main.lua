-- Fly GUI Script
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Remove old GUI if it exists
local oldGui = playerGui:FindFirstChild("FlyGui")
if oldGui then
    oldGui:Destroy()
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGui"
screenGui.Parent = playerGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Label
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.3, 0)
label.BackgroundTransparency = 1
label.Text = "Fly Menu"
label.Font = Enum.Font.SourceSansBold
label.TextSize = 20
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Parent = frame

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.8, 0, 0.3, 0)
flyButton.Position = UDim2.new(0.1, 0, 0.35, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0.3, 0)
closeButton.Position = UDim2.new(0.35, 0, 0.7, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Parent = frame

-- Fly system
local flying = false
local speed = 60

local vel = Instance.new("LinearVelocity")
vel.Attachment0 = Instance.new("Attachment", root)
vel.MaxForce = math.huge
vel.RelativeTo = Enum.ActuatorRelativeTo.World

local align = Instance.new("AlignOrientation")
align.Attachment0 = Instance.new("Attachment", root)
align.Mode = Enum.OrientationAlignmentMode.OneAttachment
align.MaxAngularVelocity = math.huge
align.MaxTorque = math.huge

vel.Parent = root
align.Parent = root

local function startFly()
    flying = true
    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end

local function stopFly()
    flying = false
    vel.VectorVelocity = Vector3.zero
end

RunService.RenderStepped:Connect(function()
    if flying then
        local camCF = workspace.CurrentCamera.CFrame
        local move = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            move += camCF.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            move -= camCF.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            move -= camCF.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            move += camCF.RightVector
        end

        if move.Magnitude > 0 then
            move = move.Unit * speed
        end

        align.CFrame = CFrame.lookAt(root.Position, root.Position + camCF.LookVector)
        vel.VectorVelocity = move
    end
end)

-- Fly button event
flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFly()
        flyButton.Text = "Fly: OFF"
    else
        startFly()
        flyButton.Text = "Fly: ON"
    end
end)

-- Close button event
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    stopFly()
end)
