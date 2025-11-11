function update(dt)
    for _, inv in pairs(inventories) do
        if inv.isActive then
            gamestate = 2
            break
        elseif gamestate == 2 then
            gamestate = 1
        end
    end

    tempUpdate(dt)

    if gamestate == 0 or gamestate == 3 then return end
    --fetchMousePos()

    world:update(dt)
    Player:update(dt)
    updateRaycasting(dt)



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
