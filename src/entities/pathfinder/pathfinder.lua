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
    obj.target = nil

    obj.repathCooldown = 0

    table.insert(Pathfinder.list, obj)
    return obj
end

function Pathfinder:update(dt)
    -- keep internal position synced with owner
    -- Can be removed if every self.x is changed to self.owner.x. This will make more code but fewer update calls so maybe better performance.
    self.px = self.owner.x
    self.py = self.owner.y

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
    if #self.path <= 0 then
        self.path = nil
        return
    end

    if self.path ~= nil and #self.path > 0 then
        if self.x == self.path[1].x and self.y == self.path[1].y then
            table.remove(self.path, 1)
            if #self.path <= 0 then return end
        end

        self.targetX, self.targetY = self.path[1].x, self.path[1].y
        -- add movement to next targets, maybe use calculateVec() in functions.lua
        local targetPX, targetPY = tileToPixel(self.targetX, self.targetY)
        self.owner.actionManager:addAction(Actions.moveTowards, self.px, self.py, targetPX, targetPY)
    end
end

function Pathfinder:hasLOS()

end

function Pathfinder:roam()
    if self.owner.activity == "wandering" and self.path == nil and self.repathCooldown <= 0 then
        self.start = AStar:coordToNodeByXY(self.x, self.y)
        while self.target == nil or not self.target.walkable do
            local roamX = math.random(-3, 3)
            local roamY = math.random(-3, 3)
            self.target = AStar:coordToNodeByXY(self.x + roamX, self.y + roamY)
        end

        if self.start and self.target then
            self.target = AStar:path(self.start, self.target)
            self.path = self.target
        end

        self.repathCooldown = 4 --seconds
    end
end

------------------------

-- Draw (debug only)
function Pathfinder:draw()
    -- Add visualisation / debug
end

function Pathfinder.drawPathfinders()
    if not debugMode then return end
    for _, pf in ipairs(Pathfinder.list) do
        pf:draw()
    end
end

return Pathfinder
