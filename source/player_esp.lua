local draw = {}

local function addTrackingBox(name, ...)
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 1
    box.Transparency = 1
    box.Color = Color3.fromRGB(255, 255, 255)
    box.Filled = false

    table.insert(draw, {
        type = "Box",
        user = name,
        {...},
        box
    })
end

local function addTrackingText(name, object)
    local text = Drawing.new("Text")
    text.Visible = false
    text.Center = true
    text.Outline = true
    text.Size = 15
    text.Color = Color3.fromRGB(255, 255, 255)

    table.insert(draw, {
        type = "Text",
        object,
        text,
        user = name
    })
end

local function addEspToPlayer(player)
    if player:FindFirstChild("Head") then
        local name = player.Head.Nametag.tag.Text
        addTrackingBox(name, player.Head, player.HumanoidRootPart, player.LeftLowerLeg)
        addTrackingText(name, player.Head)
    end
end

RegisterChildAdded(function(v)
    addEspToPlayer(v)
end)

for i, v in pairs(Players) do
    addEspToPlayer(v)
end

local function viewportPoint(ret, ...)
    if type(ret) == "boolean" then
        local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(...)
        return pos
    else
        return workspace.CurrentCamera:WorldToViewportPoint(ret, ...)
    end
end

task.spawn(function()
    while wait(30) do
        for i, v in pairs(draw) do
            if v[2] then
                v[2].Visible = false
                v[2]:Remove()
            end
        end

        draw = {}

        for i, v in pairs(Players) do
            addEspToPlayer(v)
        end

    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    for i, v in pairs(draw) do
        local type, user, object, drawObject = v.type, v.user, v[1], v[2]

        if object and game.Players:FindFirstChild(user) ~= nil then
            if type == "Box" then
                local opos, visible = viewportPoint(object[1].Position)
                local head, hrp, lfoot = object[1], object[2], object[3]
                local vpHead, vpHrp, vpLfoot = viewportPoint(true, head.Position + Vector3.new(0, 1, 0)),
                    viewportPoint(true, hrp.Position), viewportPoint(true, lfoot.Position + Vector3.new(0, 1, 0))

                if visible and _G.ESP.Box then
                    drawObject.Visible = true
                    drawObject.Size = Vector2.new(1500 / vpHrp.Z, vpHead.Y - vpLfoot.Y)
                    drawObject.Position = Vector2.new(vpHrp.X - (drawObject.Size.X / 2),
                        vpHrp.Y - (drawObject.Size.Y / 2))
                else
                    drawObject.Visible = false
                end
            elseif type == "Text" and _G.ESP.Names then
                local pos, visible = viewportPoint(object.Position)

                if visible then
                    drawObject.Position = Vector2.new(pos.X, pos.Y)
                    drawObject.Text = user
                    drawObject.Visible = true
                else
                    drawObject.Visible = false
                end
            else
                drawObject.Visible = false
            end
        else
            drawObject.Visible = false
            drawObject:Remove()
            table.remove(draw, i)
        end
    end
end)
