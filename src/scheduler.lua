local Scheduler = {}
Scheduler.__index = Scheduler

function Scheduler:new()
    local obj = setmetatable({}, Scheduler)
    obj.tasks = {}
    obj.nextId = 1

    return obj
end

function Scheduler:schedule(time, funct, args)
    local id = self.nextId
    self.nextId = self.nextId + 1
    local task = {
        id = id,
        time = time,
        funct = funct,
        args = args or {}
    }
    table.insert(self.tasks, task)
    return id --if task id needs to be saved for referencing the task in future
end

function Scheduler:cancel(id)
    for i = #self.tasks, 1, -1 do -- reverse iteration
        if self.tasks[i].id == id then
            table.remove(self.tasks, i)
        end
    end
end

function Scheduler:update(dt)
    for i = #self.tasks, 1, -1 do
        local t = self.tasks[i]
        t.time = t.time - dt
        if t.time <= 0 then
            t.fn(table.unpack(t.args or {}))

            table.remove(self.tasks, i)
        end
    end
end

--- How to call:'
--- scheduler:schedule(10 (delay time), function(msg, msg2) print(msg .. " " .. print(msg2)) end, {"this is message", "this is message 2"})
--- add the delay, add the function, add the value of the function-args

return Scheduler
