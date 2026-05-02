function draw()
    if gamestate == 5 then
        Menu:draw()
        return
    end

    cam:attach() --Attach the camera to the screen
    map1:drawLayer(map1.layers["Ground"])

    drawShadows()

    for i, obj in ipairs(drawables) do
        obj:draw()
    end


    map1:drawLayer(map1.layers["Toplayer"])

    tempDraw()

    drawDebugPre()
    Pathfinder.drawPathfinders()

    --drawUI()
    cam:detach() --Detach the camera from the screen

    drawDebugPost()

    drawUI()

    if gamestate == 0 then
        GameMenu:draw()
    end
end

function drawShadows()
    for i, obj in ipairs(drawables) do
        if obj.type ~= "tree" then
            local width = obj.sWidth * obj.scale / 3
            local height = width / 3

            g.setColor(0, 0, 0, 0.35)
            g.ellipse("fill", obj.x, obj.y + obj.sHeight / 2.2, width, height)
            g.setColor(1, 1, 1, 1)
        end
    end
end
