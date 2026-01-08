local Testmob = { list = {} }
Testmob.__index = Testmob

-- Constructor
function Testmob:new(x, y)
    local obj = setmetatable({}, Testmob)

    obj.x = x
    obj.y = y

    obj.dirX = 0
    obj.dirY = 0
    obj.speed = 150

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

    obj.state = 1 -- 1, 'normal', 2, performing task (not refreshing statemachine), 3, dead/schedueld for removal
    --state needs reworking, currently a mix of different systems

    obj.behaviour = "neutral"  --"aggressive", "skittish"
    obj.activity = "wandering" --"targeting", "fleeing"       Predefined states, more can be applied by the actionManager

    obj.alive = true

    -- AI state
    obj.behaviourMachine = BehaviourMachine:new(obj)
    obj.pathfinder = Pathfinder:new(obj)
    obj.actionManager = ActionManager:new(obj)

    return obj
end

function Testmob:update(dt)
    -- sync physics → logical position
    self.x = self.body:getX()
    self.y = self.body:getY()

    Movement.update(self, dt)

    -- run 'AI'
    self.behaviourMachine:update(dt)
    self.pathfinder:update(dt)
    self.actionManager:update(dt)


    -- animations
    Animation.update(self, dt)
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
