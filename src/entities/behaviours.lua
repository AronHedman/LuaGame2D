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
        if owner.activity == "targeting" then
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


return Behaviours
