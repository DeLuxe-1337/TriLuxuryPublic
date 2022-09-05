local camera = workspace.CurrentCamera
local localPlayer = game:GetService("Players").LocalPlayer
local network = require(localPlayer.PlayerScripts.Client.Network)
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local function isPlayer(child)
    if child:IsA("Model") and child.Name == "Model" and child:FindFirstChild("Humanoid") then
        return true
    else
        return false
    end
end

local function PlayerInfo(player)
    return {
        Username = player.Head.Nametag.tag.Text
    }
end

local function viewportPoint(ret, ...)
    if type(ret) == "boolean" then
        local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(...)
        return pos
    else
        return workspace.CurrentCamera:WorldToViewportPoint(ret, ...)
    end
end

local function GetPlayer()
    local last_distance = math.huge
    local target = nil

    for i, v in pairs(Players) do

        local info = PlayerInfo(v)

        if localPlayer.Name ~= info.Username and game.Players:FindFirstChild(info.Username) ~= nil then
            local sp, visible = viewportPoint(v:WaitForChild("HumanoidRootPart", math.huge).Position)
            local mouse_loc = UserInputService:GetMouseLocation()
            local distance = (Vector2.new(mouse_loc.X, mouse_loc.Y) - Vector2.new(sp.X, sp.Y)).Magnitude

            if last_distance > distance and visible then
                target = v
                last_distance = distance
            end
        end

    end

    return target
end

local Aiming = false

UserInputService.InputBegan:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
        Aiming = true
    end
end)

UserInputService.InputEnded:Connect(function(inputObject)
    if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
        Aiming = false
    end
end)

local default_sens = 0.20015

local delt_sensitivity = default_sens / UserGameSettings.MouseSensitivity
local old = UserInputService.MouseDeltaSensitivity

UserGameSettings:GetPropertyChangedSignal("MouseSensitivity"):Connect(function()
    if _G.Aimbot.Enabled then
        delt_sensitivity = default_sens / UserGameSettings.MouseSensitivity
        UserInputService.MouseDeltaSensitivity = delt_sensitivity
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.Aimbot.Enabled and Aiming then
        local p = GetPlayer()

        if p ~= nil then
            local pos = viewportPoint(p.Head.Position)
            local mouse_loc = game:GetService("UserInputService"):GetMouseLocation()

            mousemoverel((pos.X - mouse_loc.X) * .25, (pos.Y - mouse_loc.Y) * .25)
        end
    end
end)
