local Pathfinder = { list = {} }
Pathfinder.__index = Pathfinder

-- Constructor
function Pathfinder:new(source)
    local obj = setmetatable({}, Pathfinder)

    obj.source = source
    obj.x = source.x
    obj.y = source.y

    obj.oldTarget = nil
    obj.newTarget = nil
    obj.active = true

    table.insert(Pathfinder.list, obj)
    return obj
end

function Pathfinder:update(dt)
    -- keep internal position synced with source
    -- Can be removed if every self.x is changed to self.source.x. This will make more code but fewer update calls so maybe better performance.
    self.x = self.source.x
    self.y = self.source.y

    --if at waypoint then pop waypoint and let next wawypoint be targer
end

------------------------
--Pathfinding functions
function Pathfinder:hasLOS(goalX, goalY)

end

function Pathfinder:setTarget(goalX, goalY)
    --sets target, then calls a hasLOS()...
    --if yes then set direct waypoint
    --if no then call findPath()
end

function Pathfinder:findPath(goalX, goalY)
    --return a array of waypoints or nil
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
