function BeginContact(a, b, coll)
    local aData = a:getUserData()
    local bData = b:getUserData()
end

function raycast(source, ox, oy, dVec, radius, width) -- perhaps remove source, its a test to see if e.g player:raycast() works
    ox = ox or source.x or nil
    oy = oy or source.y or nil

    mx = love.mouse.getX()
    my = love.mouse.getY()

    dVec = dVec or { x = mx - ox, y = my - oy }

    radius = radius or 200
    width = width or pi / 2
end
