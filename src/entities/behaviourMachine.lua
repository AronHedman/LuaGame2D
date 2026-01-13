local BehaviourMachine = {}
BehaviourMachine.__index = BehaviourMachine

local Behaviours = require("src.entities.behaviours")

function BehaviourMachine:new(owner)
    local obj = setmetatable({}, BehaviourMachine)

    obj.owner = owner
    obj.behaviour = Behaviours[owner.behaviour] or Behaviours.neutral
    obj.activity = owner.activity or "wandering"

    return obj
end

function BehaviourMachine:update(dt)
    self.behaviour = Behaviours[self.owner.behaviour] or Behaviours.neutral
    self.activity = self.owner.activity or "wandering"

    -- add a shit ton of mechanics here for setting owner activities and stuff eg aggressive owner only in targeting if targetEnt, else wander


    --test
    if not self.owner.doesAction then
        self.behaviour:update(self.owner, dt)
    end
end

return BehaviourMachine
