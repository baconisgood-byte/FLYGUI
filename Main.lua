local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUIs
for _, gui in pairs(playerGui:GetChildren()) do
    if gui.Name == "MyGui" or gui.Name == "AdminGui" then
        gui:Destroy()
    end
end

-- Function to create Admin GUI
local function createAdminGui()
    local adminGui = Instance.new("ScreenGui")
    adminGui.Name = "AdminGui"
    adminGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 240)
    frame.Position = UDim2.new(0.5, -150, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.Parent = adminGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    title.Text = "Admin Panel"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Parent = frame

    -- Kill Me Button
    local killBtn = Instance.new("TextButton")
    killBtn.Size = UDim2.new(0.8, 0, 0, 40)
    killBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
    killBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    killBtn.Text = "Kill Me"
    killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    killBtn.TextScaled = true
    killBtn.Parent = frame

    killBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end
    end)

    -- Fire & Spawn All Button
    local fireSpawnBtn = Instance.new("TextButton")
    fireSpawnBtn.Size = UDim2.new(0.8, 0, 0, 40)
    fireSpawnBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
    fireSpawnBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    fireSpawnBtn.Text = "🔥 Fire & Spawn All"
    fireSpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    fireSpawnBtn.TextScaled = true
    fireSpawnBtn.Parent = frame

    fireSpawnBtn.MouseButton1Click:Connect(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                local char = plr.Character
                -- Add fire effect
                local fire = Instance.new("Fire")
                fire.Parent = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                fire.Size = 10
                fire.Heat = 25

                -- Kill to respawn
                local humanoid = char:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
        end
    end)
end

-- Create First GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MyGui"
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0.6, 0)
label.BackgroundTransparency = 1
label.Text = "Welcome!"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextScaled = true
label.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0.3, 0, 0.3, 0)
closeButton.Position = UDim2.new(0.35, 0, 0.65, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "Close"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    createAdminGui()
end)
