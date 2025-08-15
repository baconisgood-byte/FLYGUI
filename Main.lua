-- Admin GUI Script
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Remove old GUI if it exists
local oldGui = playerGui:FindFirstChild("AdminGui")
if oldGui then oldGui:Destroy() end

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "AdminGui"
gui.Parent = playerGui

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.2, 0)
title.BackgroundTransparency = 1
title.Text = "Admin Panel"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0.2, 0)
closeButton.Position = UDim2.new(0.35, 0, 0.8, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Parent = frame

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.8, 0, 0.15, 0)
flyButton.Position = UDim2.new(0.1, 0, 0.25, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
flyButton.Text = "Fly: OFF"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.TextScaled = true
flyButton.Parent = frame

-- Noclip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Size = UDim2.new(0.8, 0, 0.15, 0)
noclipButton.Position = UDim2.new(0.1, 0, 0.45, 0)
noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
noclipButton.Text = "Noclip: OFF"
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.TextScaled = true
noclipButton.Parent = frame

-- Kill Button
local killButton = Instance.new("TextButton")
killButton.Size = UDim2.new(0.8, 0, 0.15, 0)
killButton.Position = UDim2.new(0.1, 0, 0.65, 0)
killButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
killButton.Text = "Kill Player"
killButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killButton.TextScaled = true
killButton.Parent = frame

-- ===== FLY SYSTEM =====
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
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += camCF.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camCF.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camCF.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += camCF.RightVector end
		if move.Magnitude > 0 then move = move.Unit * speed end
		align.CFrame = CFrame.lookAt(root.Position, root.Position + camCF.LookVector)
		vel.VectorVelocity = move
	end
end)

-- ===== NOCLIP SYSTEM =====
local noclip = false
RunService.Stepped:Connect(function()
	if noclip and char then
		for _, part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- ===== BUTTON EVENTS =====
flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
		flyButton.Text = "Fly: OFF"
	else
		startFly()
		flyButton.Text = "Fly: ON"
	end
end)

noclipButton.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipButton.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

killButton.MouseButton1Click:Connect(function()
	local targetName = game:GetService("StarterGui"):Prompt("Enter Player Name to Kill") -- Pseudocode
	-- In Roblox Studio, replace above with your own method to get name
	for _, p in ipairs(Players:GetPlayers()) do
		if p.Name:lower() == targetName:lower() then
			p.Character:BreakJoints()
		end
	end
end)

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
	stopFly()
	noclip = false
end)
