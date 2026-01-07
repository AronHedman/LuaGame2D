local Movement = {}

function Movement.update(owner, dt)
    -- normalize direction

    local dx, dy = 0, 0

    if owner.dirX ~= 0 or owner.dirY ~= 0 then
        dx = owner.dirX
        dy = owner.dirY

        owner.dirX, owner.dirY = 0, 0
    elseif owner.vector and (owner.vector.x ~= 0 or owner.vector.y ~= 0) then
        dx = owner.vector.x
        dy = owner.vector.y

        owner.vector = { 0, 0 }
    end

    if dx ~= 0 or dy ~= 0 then
        owner.state = "moving"
        local vec = vector(dx, dy):normalized() * owner.speed -- add *dt?
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
    -- reset input direction for next frame
end

return Movement
