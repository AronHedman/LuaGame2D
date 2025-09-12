function drawDebug()
    if not debugMode then return end

    love.graphics.setColor(1, 0, 0, 1) -- Set color to red

    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 30)

    love.graphics.print("Player Position: (" .. Player.body:getX() .. ", " .. Player.body:getY() .. ")", 10, 50)
    love.graphics.print("Player tile coord: (" .. getTileCoords(Player).x .. ", " .. getTileCoords(Player).y .. ")", 10,
        70)

    love.graphics.setColor(1, 1, 1, 1) -- Reset color to white

    for _, body in ipairs(world:getBodies()) do
        for _, fixture in ipairs(body:getFixtures()) do
            local shape = fixture:getShape()
            local stype = shape:getType()

            if stype == "polygon" then
                love.graphics.polygon("line", body:getWorldPoints(shape:getPoints()))
            elseif stype == "circle" then
                local cx, cy = body:getWorldPoints(shape:getPoint())
                local r = shape:getRadius()
                love.graphics.circle("line", cx, cy, r)
            elseif stype == "edge" then
                local x1, y1, x2, y2 = body:getWorldPoints(shape:getPoints())
                love.graphics.line(x1, y1, x2, y2)
            end
        end
    end
end
