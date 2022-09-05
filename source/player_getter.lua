local function isPlayer(child)
    if child:IsA("Model") and child.Name == "Model" and child:FindFirstChild("Humanoid") then
        return true
    else
        return false
    end
end

local childAdded = {}
Players = {}

function RegisterChildAdded(f)
    table.insert(childAdded, f)
end

workspace.ChildAdded:Connect(function(child)
    if isPlayer(child) then
        for i,v in pairs(childAdded) do
            v(child)
        end
    end
end)

task.spawn(function() 
    while wait(1.5) do
        Players = {}
        for i,v in pairs(game:GetService("Workspace"):GetChildren()) do
            if v:FindFirstChild("Head") and v.Head:FindFirstChild("Nametag") and v.Head.Nametag:FindFirstChild("tag") then
                table.insert(Players, v)
            end
        end
    end
end)