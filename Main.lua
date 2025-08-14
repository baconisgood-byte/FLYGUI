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

-- Fly variables
local flying = false
local flySpeed = 50
local bodyGyro, bodyVelocity

-- Fly function
local function setFly(state)
	if state and not flying then
		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.PlatformStand = true

		bodyGyro = Instance.new("BodyGyro")
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = hrp.CFrame
		bodyGyro.Parent = hrp

		bodyVelocity = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bodyVelocity.Parent = hrp

		RS.RenderStepped:Connect(function()
			if flying then
				bodyGyro.CFrame = workspace.CurrentCamera.CFrame
				local moveDir = Vector3.zero
				if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += workspace.CurrentCamera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= workspace.CurrentCamera.CFrame.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= workspace.CurrentCamera.CFrame.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += workspace.CurrentCamera.CFrame.RightVector end
				bodyVelocity.Velocity = moveDir * flySpeed
			end
		end)

		flying = true
	elseif not state and flying then
		local char = player.Character or player.CharacterAdded:Wait()
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.PlatformStand = false
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVelocity then bodyVelocity:Destroy() end
		flying = false
	end
end

-- Button events
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	setFly(flying)
	flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")
end)

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
