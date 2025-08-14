-- FLYGUI Example: Simple Fly Button for Roblox

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local flying = false
local speed = 50

-- Create the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player.PlayerGui

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 120, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.Text = "Toggle Fly"
flyButton.Parent = screenGui

-- Fly function
function fly()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local humanoidRootPart = character.HumanoidRootPart
    local bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
    bodyVelocity.MaxForce = Vector3.new(400000,400000,400000)
    bodyVelocity.Velocity = Vector3.new(0,0,0)

    flying = true
    while flying do
        bodyVelocity.Velocity = ((mouse.Hit.p - humanoidRootPart.Position).unit * speed)
        wait()
    end
    bodyVelocity:Destroy()
end

function stopFlying()
    flying = false
end

-- Button click handler
flyButton.MouseButton1Click:Connect(function()
    if not flying then
        flyButton.Text = "Stop Flying"
        fly()
    else
        flyButton.Text = "Toggle Fly"
        stopFlying()
    end
end)
