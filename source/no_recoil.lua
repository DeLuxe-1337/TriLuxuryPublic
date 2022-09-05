local camera = require(game:GetService("Players").LocalPlayer.PlayerScripts.Client.Camera)

old = hookfunction(camera.Recoil, LPH_HOOK_FIX(function(...)
    if _G.Misc.Recoil then
        return old(...)
    else
        return nil;
    end
end))