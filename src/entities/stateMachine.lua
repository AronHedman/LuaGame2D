local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:new(owner)
    local obj = setmetatable({}, StateMachine)

    obj.owner = owner
    obj.behaviour = owner.behaviour or "neutral"
    obj.activity = owner.activity or "wandering"


    return obj
end

function StateMachine:update(dt)
    if self.behaviour == "neutral" then
        self:updateNeutral(dt)
    end
end

function StateMachine:updateNeutral(dt)
    if self.activity == "wandering" then
        Pathfinder:roam()
    end
end

return StateMachine
