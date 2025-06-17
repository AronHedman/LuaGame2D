function love.load()
    --load stuff
    require("src.gameStart.setup")
    setup()
end



function love.update(dt)
    fetchMousePos()

    world:update(dt)
    player:update(dt)

    cam:lookAt(player.x, player.y) --Make the camera follow the player
    --Prevents viewing outside of the map

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

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

function love.draw()
    cam:attach() --Attach the camera to the screen
        map1:drawLayer(map1.layers["ground"])
        map1:drawLayer(map1.layers["objects"])
        player:draw()
        --world:draw() --Draws the colliders
    cam:detach() --Detach the camera from the screen
    
    
    drawDebug()
end
