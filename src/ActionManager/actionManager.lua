local ActionManager = {}
ActionManager.__index = ActionManager

local unpack = table.unpack or unpack
-- unpack sometimes (rarely) crashed for some reason, so added a safety / priority if the different unpack sources collided or something

function ActionManager:new(owner)
    local obj = setmetatable({}, ActionManager)
    obj.owner = owner
    obj.actions = {}
    obj.queue = {} -- stores { action = actionTable, args = { ... } }
    obj.timer = 0
    obj.currentAction = nil
    return obj
end

function ActionManager:update(dt)
    if not self.currentAction and #self.queue > 0 then
        local next = table.remove(self.queue, 1)
        self:start(next.action, next.args)
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

-- queue an action with separate args
function ActionManager:addAction(action, ...)
    if #self.queue < 100 and action ~= self.queue[#self.queue] then --perhaps remove if problems?
        table.insert(self.queue, { action = action, args = { ... } })
    end
end

function ActionManager:start(action, args)
    self.currentAction = action
    self.timer = action.duration or 0
    if self.owner == Player then
        gamestate = 1.5
    end

    if action.start then
        if args and #args > 0 then
            action.start(self.owner, unpack(args))
        else
            action.start(self.owner)
        end
    end
end

return ActionManager
