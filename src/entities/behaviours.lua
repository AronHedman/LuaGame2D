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
            elseif owner.pathfinder.targetX ~= nil and owner.pathfinder.targetY ~= nil then
                owner.pathfinder.path = AStar:path(AStar:coordToNodeByXY(pixelToTile(owner.body:getPosition())),
                    nodeByXY[owner.pathfinder.targetX][owner.pathfinder.targetY])
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
