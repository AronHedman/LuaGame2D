local Pathfinder = { list = {} }
Pathfinder.__index = Pathfinder

-- Constructor
function Pathfinder:new(owner)
    local obj = setmetatable({}, Pathfinder)

    obj.owner = owner
    obj.px = owner.body.x --pixel coordinates
    obj.py = owner.body.y

    obj.x, obj.y = pixelToTile(owner.body:getPosition()) --tile coordinates

    obj.path = nil

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
            self.targetX, self.targetY = self.path[1].x, self.path[1].y

            -- add movement to next targets, maybe use calculateVec() in functions.lua
            local targetPX, targetPY = tileToPixel(self.targetX, self.targetY)
            self.owner.actionManager:addAction(Actions.moveTowards, self.px, self.py, targetPX, targetPY)
        end
    else
        self.path = nil
    end
end

function Pathfinder:hasLOS(goalX, goalY)

end

function Pathfinder:roam()
    if self.owner.activity == "wandering" and self.path == nil and self.repathCooldown <= 0 then
        local roamX = math.random(-5, 5)
        local roamY = math.random(-5, 5)

        local start = AStar:coordToNode(self.x, self.y)
        local goal = AStar:coordToNode(self.x + roamX, self.y + roamY)

        if start and goal then
            local target = AStar:path(start, goal)
            self.path = target
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
