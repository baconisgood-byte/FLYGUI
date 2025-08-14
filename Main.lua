local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "FlyGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
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

-- Dragging System
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Fly System
local flying = false
local speed = 60
local bv, bg

local function setupFly(char)
	local root = char:WaitForChild("HumanoidRootPart")
	bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Parent = root

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = root.CFrame
	bg.Parent = root

	RS.RenderStepped:Connect(function()
		if flying then
			local camCF = workspace.CurrentCamera.CFrame
			local move = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then move += camCF.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then move -= camCF.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then move -= camCF.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then move += camCF.RightVector end
			bv.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.zero
			bg.CFrame = CFrame.new(root.Position, root.Position + camCF.LookVector)
		else
			bv.Velocity = Vector3.zero
		end
	end)
end

local function startFly()
	flying = true
	flyButton.Text = "Fly: ON"
	player.Character:FindFirstChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Physics)
end

local function stopFly()
	flying = false
	flyButton.Text = "Fly: OFF"
	if bv then bv.Velocity = Vector3.zero end
end

flyButton.MouseButton1Click:Connect(function()
	if flying then
		stopFly()
	else
		startFly()
	end
end)

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

player.CharacterAdded:Connect(setupFly)
if player.Character then
	setupFly(player.Character)
end
