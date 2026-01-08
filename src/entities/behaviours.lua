local Behaviours = {}

Behaviours.neutral = {
    update = function(self, owner, dt)
        if owner.activity == "wandering" then
            --print(10)
            if owner.pathfinder.path ~= nil then
                -- print(15)
                owner.pathfinder:progressPath()
            else
                -- print(20)
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
