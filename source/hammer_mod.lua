local localPlayer = game:GetService("Players").LocalPlayer
local network = require(localPlayer.PlayerScripts.Client.Network)

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local namecall_method = getnamecallmethod()

    if namecall_method == "FireServer" then
        local args = {...}

        if type(args[2]) == "string" and args[2] == "HitEntity"  and type(args[4]) == "vector" and _G.Misc.HammerMod then
            for i=0, 3 do
                network.Send("UseItem", "Swing")
                ret = old(self, ...)
            end

            return ret
        end
    end

    return old(self, ...)
end)