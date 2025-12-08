local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine:new(owner)
    local obj = setmetatable({}, StateMachine)

    obj.owner = owner
    obj.activities = owner
        .activity                            -- default activities a mob can perform eg testmob has "idle","wandering", "targeting", "attacking" "fleeing"
    -- This will probably change when mobs only have one behaviour
    obj.currentActivity = obj.activities[1]  -- default to first state
    obj.behaviours = owner.behaviours        -- default behaviours eg testmob has "neutral", "aggressive", "skittish"
    obj.currentBehaviour = obj.behaviours[1] -- default to first behaviour

    obj.target = nil                         -- save target

    return obj
end

function StateMachine:update(dt)

end

function StateMachine.updateNeutralAI(mob, dt)

end

return StateMachine
