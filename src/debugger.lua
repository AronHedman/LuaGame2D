function drawDebugPre()
    if not debugMode then return end

    g.setColor(1, 1, 1, 1)
    g.setLineWidth(3)

    -- Draw all physics shapes
    for _, body in ipairs(world:getBodies()) do
        for _, fixture in ipairs(body:getFixtures()) do
            local shape = fixture:getShape()
            local stype = shape:getType()

            if stype == "polygon" then
                g.polygon("line", body:getWorldPoints(shape:getPoints()))
            elseif stype == "circle" then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                local r = shape:getRadius()
                g.circle("line", cx, cy, r)
            elseif stype == "edge" then
                local x1, y1, x2, y2 = body:getWorldPoints(shape:getPoints())
                g.line(x1, y1, x2, y2)
            end
        end
    end

    Raycast.drawRaycasters()
    Pathfinder.drawPathfinders()

    -- Draw debug points (your existing list)
    for i, obj in ipairs(drawables) do
        g.circle("fill", obj.x, obj.y, 5)
    end

    g.setColor(1, 1, 1)

    if moreDebug then
        drawMoreDebug()
    end
end

function drawMoreDebug()
    AStar:drawWalkableNodes()
end

function drawDebugPost()
    if not debugMode then return end

    g.setColor(1, 0, 0, 1) -- Set color to red

    g.print("FPS: " .. love.timer.getFPS(), 10, 30)

    g.print("Player Position: (" .. Player.body:getX() .. ", " .. Player.body:getY() .. ")", 10, 50)
    g.print(
        "Player tile coord: (" .. select(1, getTileCoords(Player)) .. ", " .. select(2, getTileCoords(Player)) .. ")", 10,
        70)

    g.print("VSync: " .. love.window.getVSync(), 10, 90)

    g.setColor(1, 1, 1, 1) -- Reset color to white
end
