Animation = {}

function Animation.update(owner, dt)
    -- pick animation based on facing + state
    if owner.state == "idle" then
        -- optional: idle animation
        -- owner.animation = owner.animations.idle
    else
        owner.animation = owner.animations[owner.facing]
    end

    -- advance the current animation
    if owner.animation then
        owner.animation:update(dt)
    end
end

return Animation
