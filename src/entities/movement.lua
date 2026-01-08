local Movement = {}

function Movement.playerUpdate(owner, dt)
    -- normalize direction
    local dx, dy = 0, 0

    if owner.dirX ~= 0 or owner.dirY ~= 0 then
        dx = owner.dirX
        dy = owner.dirY
        owner.dirX, owner.dirY = 0, 0
    end
    if dx ~= 0 or dy ~= 0 then
        owner.state = "moving"
        local speed = owner.speed or 150
        local vec = vector(dx, dy):normalized() * speed -- add *dt?
        owner.body:setLinearVelocity(vec.x, vec.y)

        -- update facing
        if math.abs(dx) > math.abs(dy) then
            if dx > 0 then
                owner.facing = "right"
            else
                owner.facing = "left"
            end
        else
            if dy > 0 then
                owner.facing = "down"
            else
                owner.facing = "up"
            end
        end
    else
        local dx2, dy2 = owner.body:getLinearVelocity()
        if math.abs(dx2) < 0.2 and math.abs(dy2) < 0.2 then
            owner.body:setLinearVelocity(0, 0)
            owner.state = "idle"
        end
    end
end

function Movement.update(owner, dt)
    local dx, dy = 0, 0

    if owner.dirX ~= 0 or owner.dirY ~= 0 then
        dx = owner.dirX
        dy = owner.dirY
    end
    if dx ~= 0 or dy ~= 0 then
        owner.state = "moving"
        local speed = owner.speed or 150
        local vec = vector(dx, dy):normalized() * speed -- add *dt?
        owner.body:setLinearVelocity(vec.x, vec.y)

        -- update facing
        if math.abs(dx) > math.abs(dy) then
            if dx > 0 then
                owner.facing = "right"
            else
                owner.facing = "left"
            end
        else
            if dy > 0 then
                owner.facing = "down"
            else
                owner.facing = "up"
            end
        end
    else
        local dx2, dy2 = owner.body:getLinearVelocity()
        if math.abs(dx2) < 0.2 and math.abs(dy2) < 0.2 then
            owner.body:setLinearVelocity(0, 0)
            owner.state = "idle"
        end
    end
end

return Movement
