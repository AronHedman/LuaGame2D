
--Keyboard input
function love.keypressed(key)
    if key == "escape" then
        love.window.close()
    end
    if key == "lshift" then
        player:dash()
    end
    if key == "tab" then
        debugMode = not debugMode
    end
end

--Mouse input

--make a mouse vector or something
--for aiming, utelize sin/cos for player facing mouse (enhetscirkeln)

local old_mouse_x, old_mouse_y

function fetchMousePos()
    local l_mouse_x, l_mouse_y = love.mouse.getPosition()

    if l_mouse_x ~= old_mouse_x or l_mouse_y ~= old_mouse_y then

        old_mouse_x, old_mouse_y = l_mouse_x, l_mouse_y

        mouse_x, mouse_y = l_mouse_x, l_mouse_y
    end
end
