local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- Fly state
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

		align.CFrame = CFrame.lookAt(root.Position, root.Position + camCF.LookVector)
		vel.VectorVelocity = move.Unit * speed
	end
end)

-- Example toggle (replace with your button click event)
UIS.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.F then
		if flying then
			stopFly()
		else
			startFly()
		end
	end
end)
