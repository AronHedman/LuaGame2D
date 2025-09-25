--Keyboard input
function love.keypressed(key)
    if key == "x" then
        love.window.close()
    end
    if key == "tab" then
        debugMode = not debugMode
    end

    if key == "e" then --Gamestate 2 - Inventory
        if      gamestate == 1 then gamestate = 2
        elseif  gamestate == 2 then gamestate = 1
        end
    end

    if key == "escape" then
        if      gamestate == 1 then gamestate = 0
        elseif  gamestate == 0 then gamestate = 1
        end
    end

    if key == "f" then
        local fs = not love.window.getFullscreen()
        love.window.setFullscreen(fs, "desktop")
        computeScaleAndOffset()
    end
    if key == "i" then
        integerScaling = not integerScaling
        computeScaleAndOffset()
    end
    if key == "v" then
        local vs
        if love.window.getVSync() == 1 then vs = 0 else vs = 1 end
        love.window.setVSync(vs)
    end
    
end

--Mouse input

--make a mouse vector or something
--for aiming, utelize sin/cos for player facing mouse (enhetscirkeln)

local old_mouse_x, old_mouse_y
local mouse_x, mouse_y -- virtual mouse coords

function fetchMousePos()
    local l_mouse_x, l_mouse_y = love.mouse.getPosition()

    if l_mouse_x ~= old_mouse_x or l_mouse_y ~= old_mouse_y then
        old_mouse_x, old_mouse_y = l_mouse_x, l_mouse_y

        -- convert to virtual coords here
        local vx, vy = screenToVirtual(l_mouse_x, l_mouse_y)
        mouse_x, mouse_y = vx, vy
    end
end
