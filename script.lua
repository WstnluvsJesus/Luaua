local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Can't Do Nathan",
   Icon = 0,
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Cant do Nathan",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Big Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false,
})

local MainTab = Window:CreateTab("Main", 4483362458)
local WelcomeSection = MainTab:CreateSection("Welcome to the Hub!")

local ClickButton = MainTab:CreateButton({
    Name = "Click Me",
    Callback = function()
        Rayfield:Notify({
            Title = "Button Clicked",
            Content = "You pressed the button!",
            Duration = 3
        })
    end,
})

-- Team check toggle
local teamCheckEnabled = false
local teamCheckToggle = MainTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheckFlag",
    Callback = function(value)
        teamCheckEnabled = value
    end,
})

-- Aimbot toggle
local aimbotEnabled = false
local aimbotToggle = MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotFlag",
    Callback = function(value)
        aimbotEnabled = value
    end,
})

-- ESP Dot setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "ESP_Dots"
local espDots = {}

local function createESP(player)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 4, 0, 4)
    dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    dot.BorderSizePixel = 0
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Parent = screenGui
    espDots[player] = dot
end

local function removeESP(player)
    if espDots[player] then
        espDots[player]:Destroy()
        espDots[player] = nil
    end
end

local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer

spawn(function()
    while true do
        if aimbotEnabled then
            for _, player in pairs(players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    if not teamCheckEnabled or (player.Team ~= localPlayer.Team) then
                        if not espDots[player] then
                            createESP(player)
                        end
                        local head = player.Character.Head
                        local pos, onScreen = camera:WorldToScreenPoint(head.Position + Vector3.new(0, 0.2, 0))
                        if onScreen then
                            espDots[player].Position = UDim2.new(0, pos.X, 0, pos.Y)
                            espDots[player].Visible = true
                        else
                            espDots[player].Visible = false
                        end
                    else
                        if espDots[player] then
                            espDots[player].Visible = false
                        end
                    end
                else
                    if espDots[player] then
                        removeESP(player)
                    end
                end
            end
        else
            for _, dot in pairs(espDots) do
                if dot then
                    dot.Visible = false
                end
            end
        end
        wait(0.01)
    end
end)

Rayfield:LoadConfiguration()
