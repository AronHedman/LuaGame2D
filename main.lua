function love.load()
    --load stuff
    require("src.gameStart.setup")
    setup()
    Player:load()

    tempLoad()
end

function love.update(dt)
    --fetchMousePos()

    world:update(dt)
    Player:update(dt)



    tempUpdate(dt)


    -- drawing test
    drawables = {};

    table.insert(drawables, Player)

    for i, obj in ipairs(getTreeDrawables()) do
        table.insert(drawables, obj)
    end


    table.sort(drawables, function(a, b) return a.y < b.y end)

    cam:lookAt(Player.x, Player.y) --Make the camera follow the Player
    --Prevents viewing outside of the map
    camBounds()
end

function love.draw()
    cam:attach() --Attach the camera to the screen
    map1:drawLayer(map1.layers["Ground"])

    for i, obj in ipairs(drawables) do
        obj:draw()
    end

    map1:drawLayer(map1.layers["Toplayer"])

    tempDraw()
    
    drawDebug()
    
    
    cam:detach() --Detach the camera from the screen

    
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
