local Actions = {}

Actions.idle = {
    duration = math.random(1, 5),
    start = function(owner)
        owner.state = "idle"
        owner.dirX, owner.dirY = 0, 0
    end,
    finish = function(owner)
        -- nothing to do
    end
}

Actions.moveTowards = {
    duration = 0,
    start = function(owner, x1, y1, x2, y2)
        owner.state = "moving"

        --calculate direction vectors, then movement.lua does the rest
        local dirX, dirY = calculateVecComponent(x1, y1, x2, y2)
        owner.dirX = dirX
        owner.dirY = dirY
    end,
    finish = function(owner)
        owner.state = "idle"
    end
}

Actions.playerAttack = {
    duration = 2,
    start = function(owner)
        owner.state = "attacking"
        owner:raycast(math.pi / 8, 100, nil, Actions.playerAttack.duration, 32, function(hit)
            local data = hit.data
            if data and data.type == "TESTMOB" then
                Player.health = Player.health - 1 --Apply to player to visualise/test
            end
        end)
    end,
    finish = function(owner)
        owner.state = "idle"
    end
}

Actions.mobAttack = {
    duration = 0.5,
    start = function(owner)
        owner.state = "attacking"
        owner.cooldowns["attackCooldown"] = 1
        print("Surpriseattack")

        if distance(owner.x, owner.y, Player.x, Player.y) < 1 * map1.tilewidth then
            Player:takeDmg(owner.attack)
        end

        -- set up mob attack logic
    end,
    finish = function(owner)
        owner.state = "idle"
        -- clean up mob attack state
    end
}

Actions.lunge = {
    duration = 0.4,
    start = function(owner)
        local dir = vector(calculateVecComponent(owner.x, owner.y, owner.moveTargetX, owner.moveTargetY))
        if dir:len() == 0 then
            dir = vector(0, 0)
        end
        owner.body:setLinearDamping(5)
        owner.body:applyLinearImpulse(dir.x * owner.speed, dir.y * owner.speed)
        owner.cooldowns["lungeCooldown"] = 3
        owner.state = "lunge"
    end,
    finish = function(owner)
        owner.body:setLinearVelocity(0, 0)
        owner.body:setLinearDamping(linearDamping)
        owner.state = "idle"
    end
}


--ta bort?
Actions.jump = {
    duration = 0.6,
    start = function(owner)
        owner.state = "jumping"
        owner.jumpHeight = 0
    end,
    update = function(owner, dt, timer)
        -- simple parabola: rise then fall
        local progress = 1 - (timer / 0.6)
        owner.jumpHeight = math.sin(progress * math.pi) * 50
    end,
    finish = function(owner)
        owner.jumpHeight = 0
        owner.state = "idle"
    end
}

return Actions
