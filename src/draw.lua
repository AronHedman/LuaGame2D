function draw()
    
    --Manual camera transformation in main

    map1:drawLayer(map1.layers["Ground"])

    for i, obj in ipairs(drawables) do
        obj:draw() 
    end

    map1:drawLayer(map1.layers["Toplayer"])

    tempDraw()

    drawDebugPre()


   g.pop() --Reset camera

    drawDebugPost()
end
