local old_head_info = {}

local function ExtendHitbox(player, size)
    local head = player.Head

    if not old_head_info.Head then
        old_head_info.Size = head.Size
    end

    if player:FindFirstChild("FakeHead") == nil then
        local hclo = head:Clone()
        hclo.Parent = head.Parent
        hclo.Name = "FakeHead"
    end

    if _G.Misc.Hitbox.Silent then
        head.Size = Vector3.new(size, size, size)
        head.Transparency = 1
        head.CanCollide = false
    else
        head.Size = Vector3.new(size, size, size)
        head.Transparency = .5
    end

    for i, v in pairs(head:GetDescendants()) do
        if v:IsA("Decal") then
            v:Destroy()
        end
    end
end

function ToggleHitbox(state)
    _G.Misc.Hitbox.Enabled = state

    for i, v in pairs(Players) do
        if _G.Misc.Hitbox.Enabled == false then
            if v:FindFirstChild("Head") then
                local head = v.Head

                head.Size = old_head_info.Size
                head.Transparency = 0
            end
        end
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    if _G.Misc.Hitbox.Enabled then
        for i, v in pairs(Players) do
            if v:FindFirstChild("Head") then
                ExtendHitbox(v, _G.Misc.Hitbox.Size)
            end
        end
    end
end)