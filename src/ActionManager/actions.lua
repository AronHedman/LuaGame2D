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
    duration = 0.7,
    start = function(owner)
        owner.state = "attacking"
        -- set up mob attack logic
    end,
    finish = function(owner)
        owner.state = "idle"
        -- clean up mob attack state
    end
}

Actions.lunge = {
    duration = 0.3,
    start = function(owner)
        local dir = vector(owner.dirX, owner.dirY)
        if dir:len() == 0 then dir = vector(0, 0) end
        owner.body:setLinearVelocity(dir.x * owner.speed * 6, dir.y * owner.speed * 6)
        owner.state = "lunge"
    end,
    finish = function(owner)
        owner.body:setLinearVelocity(0, 0)
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
