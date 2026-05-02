local Testmob2 = { list = {} }
Testmob2.__index = Testmob2

-- Constructor
function Testmob2:new(x, y)
    local obj = setmetatable({}, Testmob2)

    obj.x = x
    obj.y = y

    obj.dirX = 0
    obj.dirY = 0
    obj.speed = 100

    obj.isMoving = false
    obj.isAttacking = false
    obj.facing = "down"
    obj.moveTargetX = nil
    obj.moveTargetY = nil

    obj.doesAction = false

    obj.alive = true

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
        walking = {
            down  = anim8.newAnimation(obj.grid("1-4", 1), 0.2),
            left  = anim8.newAnimation(obj.grid("1-4", 2), 0.2),
            right = anim8.newAnimation(obj.grid("1-4", 3), 0.2),
            up    = anim8.newAnimation(obj.grid("1-4", 4), 0.2)
        },
        attack_1 = {
            down  = anim8.newAnimation(obj.grid("1-4", 1), 0.2),
            left  = anim8.newAnimation(obj.grid("1-4", 2), 0.2),
            right = anim8.newAnimation(obj.grid("1-4", 3), 0.2),
            up    = anim8.newAnimation(obj.grid("1-4", 4), 0.2)
        },
        attack_2 = {
            down  = anim8.newAnimation(obj.grid("1-4", 1), 0.2),
            left  = anim8.newAnimation(obj.grid("1-4", 2), 0.2),
            right = anim8.newAnimation(obj.grid("1-4", 3), 0.2),
            up    = anim8.newAnimation(obj.grid("1-4", 4), 0.2)
        },
        idle = {
            down  = anim8.newAnimation(obj.grid("1-4", 1), 0.2),
            left  = anim8.newAnimation(obj.grid("1-4", 2), 0.2),
            right = anim8.newAnimation(obj.grid("1-4", 3), 0.2),
            up    = anim8.newAnimation(obj.grid("1-4", 4), 0.2)
        }
    }

    obj.animation = obj.animations.walking.down

    obj.state = 1 -- 1, 'normal', 2, performing task (not refreshing behaviourmachine), 3, dead/schedueld for removal
    --state needs reworking, currently a mix of different systems

    obj.behaviour = "aggressive" --"neutral", "aggressive", "skittish"
    obj.activity =
    "wandering"                  --"wandering", "targeting", "fleeing"       Predefined states, more can be applied by the actionManager

    -- AI state
    obj.behaviourMachine = BehaviourMachine:new(obj)
    obj.pathfinder = Pathfinder:new(obj)
    obj.actionManager = ActionManager:new(obj)

    -- Attack / Movement related
    obj.health = 10
    obj.attack = 1

    obj.cooldowns = {}
    obj.cooldowns["lungeCooldown"] = 0
    obj.cooldowns["attackCooldown"] = 0

    return obj
end

function Testmob2:update(dt)
    -- sync physics → logical position
    self.x = self.body:getX()
    self.y = self.body:getY()

    for name, cd in pairs(self.cooldowns) do
        if cd > 0 then
            cd = cd - dt
            if cd < 0 then cd = 0 end
            self.cooldowns[name] = cd
        end
    end

    -- run 'AI'
    self.behaviourMachine:update(dt)
    self.pathfinder:update(dt)
    self.actionManager:update(dt)

    -- movement + animations
    Movement.update(self, dt)
    Animation.update(self, dt)
end

function Testmob2:draw()
    --temp
    if self.activity == "targeting" then
        g.setColor(1, 0.3, 0.3, 1)
    elseif self.activity == "wandering" then
        g.setColor(1, 1, 0.3, 1)
    end

    self.animation:draw(
        self.spritesheet,
        self.x, self.y,
        0,
        self.scale, self.scale,
        self.sWidth / 2,
        self.sHeight * 0.82
    )

    g.setColor(1, 1, 1, 1)
end

-- Entry point for Testmob2
function Testmob2:initTestmob(x, y, behaviour)
    local mob = Testmob2:new(x, y)
    mob.behaviour = behaviour or "neutral"

    table.insert(Testmob2.list, mob)
    return mob
end

function Testmob2.updateTestmobs(dt)
    for i = #Testmob2.list, 1, -1 do
        local mob = Testmob2.list[i]
        mob:update(dt)
        if not mob.alive then
            table.remove(Testmob2.list, i)
        end
    end
end

function Testmob2.drawTestmobs()
    for _, mob in ipairs(Testmob2.list) do
        table.insert(drawables, mob)
    end
end

function Testmob2:stopMovement()
    self.isMoving = false
    self.moveTargetX = nil
    self.moveTargetY = nil
    self.body:setLinearVelocity(0, 0)
end

return Testmob2
