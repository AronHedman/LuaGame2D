local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:new(owner)
    local obj = setmetatable({}, StateMachine)

    obj.owner = owner
    obj.states = owner.states
    obj.currentState = obj.states[1]         -- default to first state
    obj.behaviours = owner.behaviours
    obj.currentBehaviour = obj.behaviours[1] -- default to first behaviour


    return obj
end

function StateMachine:update(dt)

end

-- function StateMachine:switch(newState) end

return StateMachine
