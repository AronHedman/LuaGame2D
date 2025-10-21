--Keyboard input
function love.keypressed(key)
    if key == "x" then
        love.window.close()
    end
    if key == "tab" then
        debugMode = not debugMode
    end

    if key == "e" then --Gamestate 2 - Inventory
        if inventories["player"].isActive then
            inventories["player"].isActive = false
        else
            inventories["player"].isActive = true
        end
    end

    if key == "escape" then
        if gamestate == 1 or gamestate == 2 then
            gamestate = 0
        elseif gamestate == 0 then
            gamestate = 1
        end
    end

    if key == "f" then
        love.window.setFullscreen(not love.window.getFullscreen())
    end
    if key == "v" then
        local vsync = love.window.getVSync()
        if vsync == 0 then
            love.window.setVSync(1)
        else
            love.window.setVSync(0)
        end
    end
    if key == "i" then
        if inventories["temp"].isActive then
            inventories["temp"].isActive = false
        else
            inventories["temp"].isActive = true
        end
    end
end

--Mouse input

function love.mousepressed(x, y, button)
    if gamestate == 2 then
        for _, inv in pairs(inventories) do
            if inv.isActive then
                if button == 1 then
                    inv:leftClick()
                elseif button == 2 then
                    inv:rightClick()
                end
            end
        end
    end
end
