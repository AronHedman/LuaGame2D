function love.load()
    require("src.load")
    load()
end
    
function love.update(dt)
    update(dt)
end

function love.draw()
    cam:attach() --Attach the camera to the screen
    map1:drawLayer(map1.layers["Ground"])

    for i, obj in ipairs(drawables) do
        obj:draw()
    end

    map1:drawLayer(map1.layers["Toplayer"])

    tempDraw()
    
    drawDebugPre()
    
    
    cam:detach() --Detach the camera from the screen

    drawDebugPost()
    
end

function camBounds()
    local w = g.getWidth()
    local h = g.getHeight()

    if cam.x < w / 2 then
        cam.x = w / 2
    elseif cam.x > map1.width * map1.tilewidth - w / 2 then
        cam.x = map1.width * map1.tilewidth - w / 2
    end

    if cam.y < h / 2 then
        cam.y = h / 2
    elseif cam.y > map1.height * map1.tileheight - h / 2 then
        cam.y = map1.height * map1.tileheight - h / 2
    end
end
