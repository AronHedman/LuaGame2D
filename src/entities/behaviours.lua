local Behaviours = {}

Behaviours.neutral = {
    update = function(self, owner, dt)
        if owner.activity == "wandering" then
            if owner.pathfinder.path ~= nil then
                owner.pathfinder:progressPath()
            else
                if owner.activity == "idleing" then return end
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
        if distance(owner.x, owner.y, Player.x, Player.y) < 4 * map1.tilewidth then
            owner.activity = "targeting"
            owner.pathfinder.targetEnt = Player
        end
        if owner.activity == "targeting" then
            if distance(owner.x, owner.y, Player.x, Player.y) > 4 * map1.tilewidth then
                owner.activity = "wandering"
                owner.pathfinder.path = nil
            end
            if distance(owner.x, owner.y, Player.x, Player.y) < 2 * map1.tilewidth and not (distance(owner.x, owner.y, Player.x, Player.y) < 1 * map1.tilewidth) and owner.cooldowns["lungeCooldown"] == 0 then
                owner.actionManager:addAction(Actions.lunge)
            elseif distance(owner.x, owner.y, Player.x, Player.y) < 1 * map1.tilewidth and owner.cooldowns["attackCooldown"] == 0 then
                owner.actionManager:addAction(Actions.mobAttack)
            end

            if owner.pathfinder.path ~= nil then
                owner.pathfinder:progressPath()
            else
                owner.pathfinder:pathfindTarget()
            end
        else
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
    end
}

Behaviours.skittish = {
    update = function(self, owner, dt)
        if owner.activity == "fleeing" then
            if distance(owner.x, owner.y, Player.x, Player.y) > 6 * map1.tilewidth then
                owner.activity = "wandering"
                owner.pathfinder.path = nil
            else
                if owner.pathfinder.path ~= nil then
                    owner.pathfinder:progressPath()
                else
                    owner.pathfinder:flee()
                end
            end
        end
        if owner.activity == "wandering" then
            if distance(owner.x, owner.y, Player.x, Player.y) < 4 * map1.tilewidth then
                owner.pathfinder:flee()
            end
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

return Behaviours
