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
end

-- Draw (debug only)
function Pathfinder:draw()
    -- Add visualisation
end

-- Pathfinding entry point

-- Use LOS or A* ?
-- Change return values of raycast?

function Pathfinder:pathfind()

end

function Pathfinder.drawPathfinders()
    if not debugMode then return end
    for _, pf in ipairs(Pathfinder.list) do
        pf:draw()
    end
end

return Pathfinder
