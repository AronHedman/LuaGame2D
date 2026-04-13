Player = {}

Player.IMMUNITY = 0.4

function Player:load()
    self.state = "idle"
    self.facing = "s"
    self.isAttacking = false
    self.doesAction = false

    self.x = 200;
    self.y = 200;

    self.sWidth = 32
    self.sHeight = 32

    self.cWidth = 35 --Collision width
    self.cHeight = 35

    self.speed = 175
    self.dirX = 0
    self.dirY = 0
    self.animationSpeed = 0.2
    self.scale = 3

    ----Game stats

    self.health = 10
    self.immunityCooldown = 0

    self.cooldowns = {}
    self.cooldowns["lungeCooldown"] = 0
    self.cooldowns["attackCooldown"] = 0
    self.cooldowns["immunityCooldown"] = 0

    -----

    self.body = p.newBody(world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.body:setLinearDamping(linearDamping)

    self.shape = p.newRectangleShape(self.cWidth, self.cHeight)

    self.fixture = p.newFixture(self.body, self.shape, 1)


    self.spritesheet = g.newImage("assets/PlayerV3.png")
    self.grid = anim8.newGrid(self.spritesheet:getWidth() / 112, self.spritesheet:getHeight(),
        self.spritesheet:getWidth(), self.spritesheet:getHeight(), 0, 0)
    self.animations = {
        walking = {
            s = anim8.newAnimation(self.grid("1-4", 1), self.animationSpeed),
            se = anim8.newAnimation(self.grid("5-8", 1), self.animationSpeed),
            e = anim8.newAnimation(self.grid("9-12", 1), self.animationSpeed),
            ne = anim8.newAnimation(self.grid("13-16", 1), self.animationSpeed),
            n = anim8.newAnimation(self.grid("17-20", 1), self.animationSpeed),
            nw = anim8.newAnimation(self.grid("21-24", 1), self.animationSpeed),
            w = anim8.newAnimation(self.grid("25-28", 1), self.animationSpeed),
            sw = anim8.newAnimation(self.grid("29-32", 1), self.animationSpeed)
        },
        attack_1 = {
            s = anim8.newAnimation(self.grid("33-36", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
            se = anim8.newAnimation(self.grid("37-40", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
            e = anim8.newAnimation(self.grid("41-44", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
            ne = anim8.newAnimation(self.grid("45-48", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
            n = anim8.newAnimation(self.grid("49-52", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
            nw = anim8.newAnimation(self.grid("53-56", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
            w = anim8.newAnimation(self.grid("57-60", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
            sw = anim8.newAnimation(self.grid("61-64", 1),
                { self.animationSpeed * 1.5, self.animationSpeed * 1.5, self.animationSpeed * 1.25, self.animationSpeed *
                1.25 }),
        },
        attack_2 = {
            s = anim8.newAnimation(self.grid("65-70", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
            se = anim8.newAnimation(self.grid("71-76", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
            e = anim8.newAnimation(self.grid("77-82", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
            ne = anim8.newAnimation(self.grid("83-88", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
            n = anim8.newAnimation(self.grid("89-94", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
            nw = anim8.newAnimation(self.grid("95-100", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
            w = anim8.newAnimation(self.grid("101-106", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
            sw = anim8.newAnimation(self.grid("107-112", 1),
                { self.animationSpeed * 1.25, self.animationSpeed, self.animationSpeed * 1.5, self.animationSpeed, self
                .animationSpeed * 2, self.animationSpeed * 1.25 }),
        },
        idle = {
            s = anim8.newAnimation(self.grid(1, 1, 3, 1), self.animationSpeed * 2),
            se = anim8.newAnimation(self.grid(5, 1, 7, 1), self.animationSpeed * 2),
            e = anim8.newAnimation(self.grid(9, 1, 11, 1), self.animationSpeed * 2),
            ne = anim8.newAnimation(self.grid(13, 1, 15, 1), self.animationSpeed * 2),
            n = anim8.newAnimation(self.grid(17, 1, 19, 1), self.animationSpeed * 2),
            nw = anim8.newAnimation(self.grid(21, 1, 23, 1), self.animationSpeed * 2),
            w = anim8.newAnimation(self.grid(25, 1, 27, 1), self.animationSpeed * 2),
            sw = anim8.newAnimation(self.grid(29, 1, 31, 1), self.animationSpeed * 2)
        }
    }
    self.animation = self.animations.idle.s

    self.actionManager = ActionManager:new(self)
end

function Player:update(dt)
    for name, cd in pairs(self.cooldowns) do
        if cd > 0 then
            cd = cd - dt
            if cd < 0 then cd = 0 end
            self.cooldowns[name] = cd
        end
    end

    self:playerMovement()
    Movement.playerUpdate(self, dt)

    self:checkBoundaries()

    self.x = self.body:getX()
    self.y = self.body:getY()

    self.actionManager:update(dt)

    Animation.update(self, dt)
end

function Player:draw() --draw function
    self.animation:draw(self.spritesheet, self.x, self.y, 0, self.scale, self.scale, self.sWidth, self.sHeight * 1.55)
end

function Player:playerMovement()
    if gamestate == 1.5 then return end
    if love.keyboard.isDown("a") then self.dirX = -1 end
    if love.keyboard.isDown("d") then self.dirX = 1 end
    if love.keyboard.isDown("w") then self.dirY = -1 end
    if love.keyboard.isDown("s") then self.dirY = 1 end
end

function Player:raycast(angle, radius, dVec, duration, rayAmoun, onHit, delay) -- Raycast wrapper for player to be able to write Player:raycast()
    Raycast.raycast(self, angle, radius, dVec, duration, rayAmount, onHit, delay)
end

function Player:checkBoundaries()
    local bx, by = self.body:getPosition()
    local mx = map1.tilewidth * map1.width
    local my = map1.tileheight * map1.height

    if bx <= 0 then self.body:setX(0) end
    if by <= 0 then self.body:setY(0) end
    if bx >= mx then self.body:setX(mx) end
    if by >= my then self.body:setY(my) end
end

function Player:takeDmg(dmg)
    if self.cooldowns["immunityCooldown"] == 0 then
        self.health = self.health - dmg
        self.cooldowns["immunityCooldown"] = self.IMMUNITY
    end
end
