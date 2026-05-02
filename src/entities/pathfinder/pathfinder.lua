local Pathfinder = { list = {} }
Pathfinder.__index = Pathfinder

-- Constructor
function Pathfinder:new(owner)
    local obj = setmetatable({}, Pathfinder)

    obj.owner = owner
    obj.px, obj.py = owner.body:getPosition()

    obj.x, obj.y = pixelToTile(owner.body:getPosition()) --tile coordinates

    obj.path = nil
    obj.start = nil
    obj.target = nil    --target node / tile
    obj.targetEnt = nil --entity targeted
    obj.targetPX = nil
    obj.targetPY = nil

    obj.repathCooldown = 0

    table.insert(Pathfinder.list, obj)
    return obj
end

function Pathfinder:update(dt)
    -- keep internal position synced with owner
    -- Can be removed if every self.x is changed to self.owner.x. This will make more code but fewer update calls so maybe better performance.
    self.px = self.owner.x
    self.py = self.owner.y

    --move pathfinder.target to the owner and then maybe add a check here to see if owner.targetEnt or something?

    self.x, self.y = pixelToTile(self.owner.body:getPosition())

    if self.path ~= nil then
        self:progressPath()
        self.repathCooldown = self.repathCooldown - dt
    else
        self.repathCooldown = self.repathCooldown - dt
    end
end

------------------------
--Pathfinding functions

function Pathfinder:progressPath()
    if self.path == nil then
        print("Is this check even neccessary?")
        return
    end
    if #self.path <= 0 then
        self.path = nil
        self.owner:stopMovement()
        return
    end

    --test for more accurate paths / more frequent checking of paths
    if self.repathCooldown <= 0 then
        self:repath()
    end

    if self.path ~= nil and #self.path > 0 then
        if self.x == self.path[1].x and self.y == self.path[1].y then
            table.remove(self.path, 1)
            if #self.path <= 0 then
                self.path = nil
                self.repathCooldown = 0
                self.owner.isMoving = false
                return
            end
        end
        self.targetX, self.targetY = self.path[1].x, self.path[1].y

        self.targetPX, self.targetPY = tileToPixel(self.targetX, self.targetY)

        self.owner.moveTargetX = self.targetPX
        self.owner.moveTargetY = self.targetPY
        self.owner.isMoving = true
    end
end

function Pathfinder:hasLOS()
    if self.repathCooldown > 0 then return end
end

function Pathfinder:repath()
    self.path = nil
    self.owner.isMoving = false
end

function Pathfinder:roam()
    if self.owner.activity == "wandering" and self.path == nil and self.repathCooldown <= 0 then
        self.start = AStar:coordToNodeByXY(self.x, self.y)
        local tile = nil
        while tile == nil or not tile.walkable do
            local roamX = math.random(-15, 15)
            local roamY = math.random(-15, 15)
            tile = AStar:coordToNodeByXY(self.x + roamX, self.y + roamY)
        end

        if self.start and tile then
            self.path = AStar:path(self.start, tile)
            if self.path ~= nil and #self.path > 0 then
                self.targetX, self.targetY = self.path[1].x, self.path[1].y
            else
                self.path = nil
                self.owner.isMoving = false
            end
        end
        self.repathCooldown = 2 --seconds
    end
end

function Pathfinder:flee()
    if self.owner.activity == "fleeing" and self.path == nil and self.repathCooldown <= 0 then
        local startTileX, startTileY = pixelToTile(self.x, self.y)
        self.start = AStar:coordToNodeByXY(startTileX, startTileY)

        local dx = self.x - Player.x
        local dy = self.y - Player.y
        local currentDistPixels = math.sqrt(dx * dx + dy * dy)

        local radius = math.max(1, math.floor(currentDistPixels))
        local minSafeDistancePixels = currentDistPixels * 1.4

        local tile = nil
        local attempts = 0
        local maxAttempts = 50

        while (tile == nil or not tile.walkable) and attempts < maxAttempts do
            local roamX = math.random(-radius, radius)
            local roamY = math.random(-radius, radius)
            local potentialPixelX = self.x + roamX
            local potentialPixelY = self.y + roamY

            local pTileX, pTileY = pixelToTile(potentialPixelX, potentialPixelY)
            tile = AStar:coordToNodeByXY(pTileX, pTileY)

            if tile and tile.walkable then
                local distToPlayer = math.sqrt((potentialPixelX - Player.x) ^ 2 + (potentialPixelY - Player.y) ^ 2)

                if distToPlayer < minSafeDistancePixels then
                    tile = nil --too close try again
                end
            end

            attempts = attempts + 1
        end

        if self.start and tile then
            self.path = AStar:path(self.start, tile)
            if self.path and #self.path > 0 then
                self.targetX, self.targetY = self.path[1].x, self.path[1].y
            end
        end

        self.repathCooldown = 2
    end
end

function Pathfinder:pathfindTarget()
    if self.owner.activity == "targeting" and self.path == nil and self.repathCooldown <= 0 then
        self.start = AStar:coordToNodeByXY(self.x, self.y)
        if not self.targetEnt or not self.targetEnt.x or not self.targetEnt.y then
            self.targetEnt = nil
            return
        end

        local tx, ty = pixelToTile(self.targetEnt.x, self.targetEnt.y)
        self.target = AStar:coordToNodeByXY(tx, ty)

        if self.start and self.target ~= nil and self.start ~= self.target and not (distance(self.start.x, self.start.y, self.target.x, self.target.y) <= 0.5) then
            self.path = AStar:path(self.start, self.target)

            if self.path ~= nil and #self.path > 0 then
                self.targetX, self.targetY = self.path[1].x, self.path[1].y
            else
                self.path = nil
                self.owner.isMoving = false
            end
        end
        self.repathCooldown = 0.5
    end
end

function Pathfinder:draw()
    if not debugMode or self.path == nil or #self.path == 0 then
        return
    end

    love.graphics.setLineWidth(4)

    local currentPX, currentPY = self.px, self.py

    if self.owner.behaviour == "aggressive" then
        love.graphics.setColor(0.8, 0.2, 0.2, 1)
    elseif self.owner.behaviour == "skittish" then
        love.graphics.setColor(0.8, 0.8, 0, 1)
    else
        love.graphics.setColor(0.6, 1, 0.3, 1)
    end

    for i = 1, #self.path do
        local nextPX, nextPY = tileToPixel(self.path[i].x, self.path[i].y)
        love.graphics.line(currentPX, currentPY, nextPX, nextPY)

        currentPX, currentPY = nextPX, nextPY
    end

    local endNode = self.path[#self.path]
    local endPX, endPY = tileToPixel(endNode.x, endNode.y)

    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("fill", endPX, endPY, 8 * scale)

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setLineWidth(1)
end

function Pathfinder.drawPathfinders()
    if not debugMode then return end
    for _, pf in ipairs(Pathfinder.list) do
        pf:draw()
    end
end

return Pathfinder
