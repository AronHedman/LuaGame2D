local Pathfinder = { list = {} }
Pathfinder.__index = Pathfinder

function Pathfinder:new()
    return setmetatable({}, Pathfinder)
end

function Pathfinder:update(dt)

end

function Pathfinder:draw()
end

function Pathfinder:pathfind()

end

function Pathfinder.updatePathfinders(dt)
    for i = #Pathfinder.list, 1, -1 do
        local pathfinder = Pathfinder.list[i]
        pathfinder:update(dt)
    end
end

function Pathfinder.drawPathfinders()
    if not debugMode then return end
    for i, pathfinder in ipairs(Pathfinder.list) do
        pathfinder:draw()
    end
end

return Pathfinder
