local Behaviours = {}

Behaviours.neutral = {
    update = function(self, owner, dt)
        if owner.activity == "wandering" then
            if owner.pathfinder.path ~= nil then
                owner.pathfinder:progressPath()
            else
                local rand = math.random(1, 10)
                if rand >= 3 then
                    owner.pathfinder:roam()
                else
                    owner.actionManager:addAction(Actions.idle)
                end
            end
        end
    end
}

Behaviours.aggressive = {
    update = function(self, owner, dt)

    end
}

return Behaviours
