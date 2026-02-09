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
        else
            if owner.activity == "targeting" then
                if distance(owner.x, owner.y, Player.x, Player.y) < 2 * map1.tilewidth and not (distance(owner.x, owner.y, Player.x, Player.y) < 1) then
                    owner.actionManager:addAction(Actions.lunge)
                    print("ling")
                end
                if owner.pathfinder.path ~= nil then
                    owner.pathfinder:progressPath()
                else
                    owner.pathfinder:pathfindTarget()
                end
            end
        end
    end
}

return Behaviours
