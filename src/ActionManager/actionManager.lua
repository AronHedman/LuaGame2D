local ActionManager = {}
ActionManager.__index = ActionManager

-- Constructor
function ActionManager:new(owner)
    local obj = setmetatable({}, ActionManager)

    obj.owner = owner
    obj.actions = {}
    obj.queue = {}
    obj.timer = 0
    obj.currentAction = nil

    return obj
end

function ActionManager:update(dt)
    if not self.currentAction and #self.queue > 0 then
        local nextAction = table.remove(self.queue, 1)
        self:start(nextAction)
    end

    if self.currentAction then
        self.timer = self.timer - dt
        if self.timer <= 0 then
            if self.currentAction.finish then
                self.currentAction.finish(self.owner)
            end
            self.currentAction = nil
            gamestate = 1
        end
    end
end

function ActionManager:addAction(action)
    table.insert(self.queue, action)
end

function ActionManager:start(action)
    self.currentAction = action
    self.timer = action.duration
    gamestate = 1.5
    if action.start then
        action.start(self.owner)
    end
end

return ActionManager
