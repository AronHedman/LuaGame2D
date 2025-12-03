local Testmob = { list = {} }
Testmob.__index = Testmob

-- Constructor
function Testmob:new(x, y)
    local obj = setmetatable({}, Testmob)

    obj.x = x
    obj.y = y

    obj.scale = 5
    obj.sWidth = 12
    obj.sHeight = 18

    -- physics
    obj.body = p.newBody(world, x, y, "dynamic")
    obj.body:setFixedRotation(true)
    obj.body:setLinearDamping(linearDamping)

    obj.shape = p.newRectangleShape(32, 32) -- match collision size
    obj.fixture = p.newFixture(obj.body, obj.shape, 1)
    obj.fixture:setUserData({ type = "TESTMOB" })

    -- sprite + animations
    obj.spritesheet = g.newImage("assets/testPlayer.png")

    obj.grid = anim8.newGrid(
        obj.spritesheet:getWidth() / 4,
        obj.spritesheet:getHeight() / 4,
        obj.spritesheet:getWidth(),
        obj.spritesheet:getHeight()
    )

    obj.animations = {
        down  = anim8.newAnimation(obj.grid("1-4", 1), 0.2),
        left  = anim8.newAnimation(obj.grid("1-4", 2), 0.2),
        right = anim8.newAnimation(obj.grid("1-4", 3), 0.2),
        up    = anim8.newAnimation(obj.grid("1-4", 4), 0.2)
    }

    obj.animation = obj.animations.down

    -- AI state
    obj.state = 1 -- 1, 'normal', 2, performing task (not refreshing statemachine), 3, dead/schedueld for removal

    obj.behaviours = { "neutral", "aggressive", "skittish" }
    obj.activity = { "wandering", "targeting", "fleeing" } --Predefined states, more can be applied by the actionManager
    obj.target = { x = obj.x, y = obj.y }

    obj.alive = true
    obj.stateMachine = StateMachine:new(obj)
    obj.pathfinder = nil

    return obj
end

function Testmob:update(dt)
    -- sync physics → logical position
    self.x = self.body:getX()
    self.y = self.body:getY()

    -- animations
    self.animation:update(dt)

    -- run 'AI'
    self.pathfinder:update(dt)
    self.stateMachine:update(dt)
end

function Testmob:draw()
    self.animation:draw(
        self.spritesheet,
        self.x, self.y,
        nil,
        self.scale, self.scale,
        self.sWidth / 2,
        self.sHeight * 0.82
    )
end

-- Entry point for Testmob
function Testmob:initTestmob(x, y)
    local mob = Testmob:new(x, y)

    mob.pathfinder = Pathfinder:new(mob)

    table.insert(Testmob.list, mob)
    return mob
end

function Testmob.updateTestmobs(dt)
    for i = #Testmob.list, 1, -1 do
        local mob = Testmob.list[i]
        mob:update(dt)
        if not mob.alive then
            table.remove(Testmob.list, i)
        end
    end
end

function Testmob.drawTestmobs()
    for _, mob in ipairs(Testmob.list) do
        table.insert(drawables, mob)
    end
end

return Testmob
