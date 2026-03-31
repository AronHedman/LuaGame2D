Animation = {}

function Animation.update(owner, dt)
    -- pick animation based on facing + state
    if owner.state == "attacking" or owner.isAttacking then
        if not owner.isAttacking then
            local append = "_1"
            if math.random() < 0.8 then append = "_2" end

            if owner.animations["attack" .. append][owner.facing] then
                owner.animation = owner.animations["attack" .. append][owner.facing]
            end
            owner.isAttacking = true
        end
    elseif owner.state == "moving" then
        owner.isAttacking = false
        owner.animation = owner.animations.walking[owner.facing]
    elseif owner.state == "idle" then
        owner.animation = owner.animations.idle[owner.facing]
    end

    if owner.animation then
        owner.animation:update(dt)
    end
end

return Animation
