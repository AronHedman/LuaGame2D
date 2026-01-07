function draw()
    cam:attach() --Attach the camera to the screen
    map1:drawLayer(map1.layers["Ground"])

    for i, obj in ipairs(drawables) do
        obj:draw()
    end


    map1:drawLayer(map1.layers["Toplayer"])

    tempDraw()

    drawDebugPre()

    --drawUI()
    cam:detach() --Detach the camera from the screen

    drawDebugPost()

    drawUI()
end
