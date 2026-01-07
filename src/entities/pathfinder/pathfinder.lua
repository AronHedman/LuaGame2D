local Pathfinder = { list = {} }
Pathfinder.__index = Pathfinder

-- Constructor
function Pathfinder:new(source)
    local obj = setmetatable({}, Pathfinder)

    obj.source = source
    obj.px = source.body.x --pixel coordinates
    obj.py = source.body.y

    obj.x, obj.y = pixelToTile(source.body:getPosition()) --tile coordinates

    obj.path = nil

    obj.repathCooldown = 0

    table.insert(Pathfinder.list, obj)
    return obj
end

function Pathfinder:update(dt)
    -- keep internal position synced with source
    -- Can be removed if every self.x is changed to self.source.x. This will make more code but fewer update calls so maybe better performance.
    self.px = self.source.x
    self.py = self.source.y

    if self.path ~= nil then
        self:progressPath()
        self.repathCooldown = self.repathCooldown - dt
    end
end

------------------------
--Pathfinding functions

function Pathfinder:progressPath()
    if self.path ~= nil and #self.path > 0 then
        if self.x == self.path[1].x and self.y == self.path[1].y then
            table.remove(self.path, 1)
            self.targetX, self.targetY = self.path[1].x, self.path[1].y

            -- add movement to next targets, maybe use calculateVec() in functions.lua
        end
    else
        self.path = nil
    end
end

function Pathfinder:hasLOS(goalX, goalY)

end

function Pathfinder:roam()
    if self.activity == "wandering" and self.path == nil and self.repathCooldown <= 0 then
        local roamX = math.random(-5, 5)
        local roamY = math.random(-5, 5)

        local target = AStar:path({ self.x, self.y }, { self.x + roamX, self.y + roamY })
        self.path = target
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
