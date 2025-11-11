local hits = {}

local function rotateVec(vx, vy, radians)
    local cosA = math.cos(radians)
    local sinA = math.sin(radians)
    return vx * cosA - vy * sinA, vx * sinA + vy * cosA
end

function rayCallback(fixture, x, y, xn, yn, fraction)
    local hit = {
        fixture = fixture,
        x = x,
        y = y,
        normalx = xn,
        normaly = yn,
        fraction = fraction
    }
    table.insert(hits, hit)

    return 1 --might change returnvalue (1 - continue, 0 - terminate, -1 - ignore intersection, fraction - clip ray to this point)
end

local function singleRaycast(sx, sy, ex, ey, funct)
    world:rayCast(sx, sy, ex, ey, funct)
end

function doRaycast(source, dVec, radius, angle) --angle in radians (pi is defined in setup)
    -- Origin and direction
    local sx = source.x
    local sy = source.y
    if not sx or not sy then return nil end

    -- Default direction = towards mouse
    local mx, my = love.mouse.getPosition()
    dVec = dVec or { x = mx - sx, y = my - sy }

    -- Normalize direction vector
    local len = math.sqrt(dVec.x ^ 2 + dVec.y ^ 2)
    local normalx, normaly = dVec.x / len, dVec.y / len

    radius = radius or 150

    angle = angle or (math.pi / 4) --default 45 degrees

    local baseAngle = math.atan2(normaly, normalx)
    hits = {}

    --calculate rotations
    local ex, ey
    local steps = 1
    if angle < pi / 16 then
        -- Small angle = single ray
        ex, ey = sx + normalx * radius, sy + normaly * radius

        singleRaycast(sx, sy, ex, ey, rayCallback)
    else
        --offset by half angle
        local startAngle = baseAngle - (angle / 2)

        --calculate steps
        steps = math.ceil(angle / (pi / 16))
        local angleStep = angle / steps

        for i = 1, steps do
            ex, ey = sx + normalx * radius, sy + normaly * radius
            local rotatedx, rotatedy = rotateVec(normalx, normaly, startAngle + (angleStep * i))
            ex, ey = ex + rotatedx * radius, ey + rotatedy * radius
        end
    end

    if not debugMode then return hits end
    -- Debug drawing
    g.line(sx, sy, ex, ey)

    if steps > 1 then
        for i = 0, steps do
            local rayAngle = baseAngle - (angle / 2) + (i * (angle / steps))
            local rayDirX = math.cos(rayAngle)
            local rayDirY = math.sin(rayAngle)
            local rayEndX = sx + rayDirX * radius
            local rayEndY = sy + rayDirY * radius
            g.line(sx, sy, rayEndX, rayEndY)
        end
    end

    return hits
end

function updateRaycasting(dt)
    if not raycasting then return end
end

function raycast(source, dVec, radius, angle)
    raycasting = true

    doRaycast(source, dVec, radius, angle)
end
