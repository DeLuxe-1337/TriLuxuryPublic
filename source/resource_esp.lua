local target = {"StoneOre", "SmallBox", "NitrateOre", "IronOre", "PartsBox", "Backpack", "MilitaryCrate", "DroppedItem", "VendingMachine"}
local draw = {}

local function addTrackingText(object, name)
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Size = 15
    text.Color = Color3.fromRGB(255, 255, 255)

    table.insert(draw, {object, text, name})
end

for i,v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
   if table.find(target, v.Name) then
       for i, o in pairs(v:GetChildren()) do
          addTrackingText(o, v.Name)
       end
       v.ChildAdded:Connect(function(o) addTrackingText(o, v.Name) end)
   end
end

game:GetService("RunService").RenderStepped:Connect(function() 
    for i,v in pairs(draw) do
        local object, text, name = v[1], v[2], v[3]

        if object and object.PrimaryPart and object.PrimaryPart.Position then
            local pos, visible = workspace.CurrentCamera:WorldToViewportPoint(object.PrimaryPart.Position)

            if visible and _G.ESP.Resources then
                text.Position = Vector2.new(pos.X, pos.Y)
                text.Text = name
                text.Visible = true
            else
                text.Visible = false
            end
        else
            text:Remove()
            table.remove(draw, i)
        end
    end
end)