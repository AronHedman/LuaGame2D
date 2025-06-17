function drawDebug()

    if debugMode then


        love.graphics.setColor(1, 0, 0, 1) -- Set color to red

        love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 30)

        love.graphics.print("Player Position: (" .. player.body:getX() .. ", " .. player.body:getY() .. ")", 10, 50)
        love.graphics.print("Player tile coord: (" .. getTileCoords(player).x .. ", " .. getTileCoords(player).y .. ")", 10, 70)

        love.graphics.setColor(1, 1, 1, 1) -- Reset color to white
    end

end