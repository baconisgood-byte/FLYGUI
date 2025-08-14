-- LocalScript inside StarterPlayerScripts or StarterGui

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 80, 0, 30)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 10)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = frame

-- Fly system
local flying = false
local speed = 60
local vel, align

local function setupFly(char)
    local humanoid = char:WaitForChild("Humanoid")
    local root = char:WaitForChild("HumanoidRootPart")

    vel = Instance.new("LinearVelocity")
    vel.Attachment0 = Instance.new("Attachment", root)
    vel.MaxForce = math.huge
    vel.RelativeTo = Enum.ActuatorRelativeTo.World
    vel.Parent = root

    align = Instance.new("AlignOrientation")
    align.Attachment0 = Instance.new("Attachment", root)
    align.Mode = Enum.OrientationAlignmentMode.OneAttachment
    align.MaxAngularVelocity = math.huge
    align.MaxTorque = math.huge
    align.Parent = root

    RunService.RenderStepped:Connect(function()
        if flying then
            local camCF = workspace.CurrentCamera.CFrame
				
