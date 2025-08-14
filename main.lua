function love.load()
    --load stuff
    require("src.gameStart.setup")
    setup()
    Player:load()
end



function love.update(dt)
    
    
    fetchMousePos()

    world:update(dt)
    Player:update(dt)

    cam:lookAt(Player.x, Player.y) --Make the camera follow the Player
    --Prevents viewing outside of the map

    camBounds()
    

end

function love.draw()
    cam:attach() --Attach the camera to the screen
        map1:drawLayer(map1.layers["ground"])
        map1:drawLayer(map1.layers["onGround"])
        Player:draw()
        map1:drawLayer(map1.layers["aboveGround"])

        --world:draw() --Draws the colliders
    cam:detach() --Detach the camera from the screen
    
    
    drawDebug()
end

function camBounds()
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
