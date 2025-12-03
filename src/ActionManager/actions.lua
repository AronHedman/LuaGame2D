local Actions = {}

Actions.idle = {
    duration = 1.0,
    start = function(owner)
        owner.state = "idle"
    end,
    finish = function(owner)
        -- nothing to do
    end
}

Actions.playerAttack = {
    duration = 0.5,
    start = function(owner)
        owner.state = "attacking"
        owner:raycast(math.pi / 8, 100, nil, 2, 32, function(hit)
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
        if dir:len() == 0 then dir = vector(0, 1) end
        owner.body:setLinearVelocity(dir.x * 600, dir.y * 600)
        owner.state = "lunge"
    end,
    finish = function(owner)
        owner.body:setLinearVelocity(0, 0)
        owner.state = "idle"
    end
}

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
