function update(dt)
    --fetchMousePos()

    world:update(dt)
    Player:update(dt)


    tempUpdate(dt)


    drawables = {};

    table.insert(drawables, Player)

    for i, obj in ipairs(getTrees()) do
        table.insert(drawables, obj)
    end


    table.sort(drawables, function(a, b) return a.y < b.y end)

    cam:lookAt(Player.x, Player.y) --Make the camera follow the Player
    --Prevents viewing outside of the map
    camBounds()
end
