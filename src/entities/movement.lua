local Movement = {}

function Movement.update(owner, dt)
    -- normalize direction
    if owner.dirX ~= 0 or owner.dirY ~= 0 then
        owner.state = "moving"
        local vec = vector(owner.dirX, owner.dirY):normalized() * owner.speed -- add *dt?
        owner.body:setLinearVelocity(vec.x, vec.y)

        -- update facing
        if math.abs(owner.dirX) > math.abs(owner.dirY) then
            if owner.dirX > 0 then
                owner.facing = "right"
            else
                owner.facing = "left"
            end
        else
            if owner.dirY > 0 then
                owner.facing = "down"
            else
                owner.facing = "up"
            end
        end
    else
        local dx, dy = owner.body:getLinearVelocity()
        if math.abs(dx) < 0.2 and math.abs(dy) < 0.2 then
            owner.body:setLinearVelocity(0, 0)
            owner.state = "idle"
        end
    end
    -- reset input direction for next frame
    owner.dirX, owner.dirY = 0, 0
end

return Movement
