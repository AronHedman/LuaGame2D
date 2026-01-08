local Behaviours = {}

Behaviours.neutral = {
    update = function(self, owner, dt)
        if owner.activity == "wandering" then
            if owner.pathfinder.path ~= nil then
                owner.pathfinder:progressPath()
            else
                owner.pathfinder:roam()
            end
        end
    end
}

Behaviours.aggressive = {
    update = function(self, owner, dt)

    end
}

return Behaviours
