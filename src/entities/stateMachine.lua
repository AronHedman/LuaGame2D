local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:new(owner)
    local obj = setmetatable({}, StateMachine)

    obj.owner = owner

    return obj
end

function StateMachine:update(dt)

end

function StateMachine.updateNeutralAI(mob, dt)

end

return StateMachine
