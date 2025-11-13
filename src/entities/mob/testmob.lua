local Testmob = { list = {} }
Testmob.__index = Testmob

function Testmob:new(x, y)
    self.x = x
    self.y = y

    self.scale = 5
    self.sWidth = 12 --sprite width
    self.sHeight = 18

    --Add collission size: cWidth & cHeight

    self.body = p.newBody(world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.body:setLinearDamping(linearDamping)

    self.shape = p.newRectangleShape(32, 32)

    self.fixture = p.newFixture(self.body, self.shape, 1)
    self.fixture:setUserData({ type = "TESTMOB" })

    self.spritesheet = g.newImage("assets/testPlayer.png")
    self.grid = anim8.newGrid(self.spritesheet:getWidth() / 4, self.spritesheet:getHeight() / 4,
        self.spritesheet:getWidth(), self.spritesheet:getHeight(), 0, 0)

    self.animations = {}
    self.animations.down = anim8.newAnimation(self.grid("1-4", 1), 0.2)
    self.animations.left = anim8.newAnimation(self.grid("1-4", 2), 0.2)
    self.animations.right = anim8.newAnimation(self.grid("1-4", 3), 0.2)
    self.animations.up = anim8.newAnimation(self.grid("1-4", 4), 0.2)
    self.animation = self.animations.down

    self.alive = true

    return setmetatable({
        x = x,
        y = y,
        alive = true
    }, Testmob)
end

function Testmob:update(dt)
    --pathfinding here

    self.x = self.body:getX()
    self.y = self.body:getY()

    self.animation:update(dt)

    ----Despawn timer. Add conditions, if met, add to despawn timer, if too high then despawn. Eg outside of map.
end

function Testmob:draw()
    self.animation:draw(self.spritesheet, self.x, self.y, nil, self.scale, self.scale, self.sWidth / 2,
        self.sHeight * 0.82)
end

function Testmob:initTestmob(x, y)
    local testmob = Testmob:new(x, y)
    table.insert(Testmob.list, testmob)
end

function Testmob.updateTestmobs(dt)
    for i = #Testmob.list, 1, -1 do
        local mob = Testmob.list[i]
        mob:update(dt)
        if mob.alive == false then
            table.remove(Testmob.list, i)
        end
    end
end

function Testmob.drawTestmobs()
    for i, mob in ipairs(Testmob.list) do
        table.insert(drawables, mob)
    end
end

return Testmob
