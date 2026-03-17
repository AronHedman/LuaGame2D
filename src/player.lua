Player = {}

Player.IMMUNITY = 0.4

function Player:load()
    self.state = nil --"idle"
    self.facing = "s"

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

    -----

    self.body = p.newBody(world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.body:setLinearDamping(linearDamping)

    self.shape = p.newRectangleShape(self.cWidth, self.cHeight)

    self.fixture = p.newFixture(self.body, self.shape, 1)


    self.spritesheet = g.newImage("assets/PlayerV2.png")
    self.grid = anim8.newGrid(self.spritesheet:getWidth() / 112, self.spritesheet:getHeight(),
        self.spritesheet:getWidth(), self.spritesheet:getHeight(), 0, 0)
    self.animations = {
        s = anim8.newAnimation(self.grid("1-4", 1), self.animationSpeed),
        se = anim8.newAnimation(self.grid("5-8", 1), self.animationSpeed),
        e = anim8.newAnimation(self.grid("9-12", 1), self.animationSpeed),
        ne = anim8.newAnimation(self.grid("13-16", 1), self.animationSpeed),
        n = anim8.newAnimation(self.grid("17-20", 1), self.animationSpeed),
        nw = anim8.newAnimation(self.grid("21-24", 1), self.animationSpeed),
        w = anim8.newAnimation(self.grid("25-28", 1), self.animationSpeed),
        sw = anim8.newAnimation(self.grid("29-32", 1), self.animationSpeed)
    }
    --self.animations.idle = anim8.newAnimation(self.grid("3-4", 1), self.animationSpeed * 4)
    self.animation = self.animations.s

    self.actionManager = ActionManager:new(self)
end

function Player:update(dt)
    if self.immunityCooldown > 0 then
        self.immunityCooldown = self.immunityCooldown - dt
        if self.immunityCooldown < 0 then
            self.immunityCooldown = 0
        end
    end

    self:playerMovement()
    Movement.playerUpdate(self, dt)

    self:checkBoundaries()

    self.x = self.body:getX()
    self.y = self.body:getY()

    Animation.update(self, dt)

    self.actionManager:update(dt)
end

function Player:draw() --draw function
    self.animation:draw(self.spritesheet, self.x, self.y, nil, self.scale, self.scale, self.sWidth, self.sHeight * 1.55)
end

function Player:playerMovement()
    if gamestate == 1.5 then return end
    if love.keyboard.isDown("a") then self.dirX = -1 end
    if love.keyboard.isDown("d") then self.dirX = 1 end
    if love.keyboard.isDown("w") then self.dirY = -1 end
    if love.keyboard.isDown("s") then self.dirY = 1 end
end

function Player:raycast(angle, radius, dVec, duration, rayAmoun, onHit) -- Raycast wrapper for player
    Raycast.raycast(self, angle, radius, dVec, duration, rayAmount, onHit)
end

function Player:checkBoundaries()
    bx, by = self.body:getPosition()
    mx = map1.tilewidth * map1.width
    my = map1.tileheight * map1.height

    if bx <= 0 then self.body:setX(0) end
    if by <= 0 then self.body:setY(0) end
    if bx >= mx then self.body:setX(mx) end
    if by >= my then self.body:setY(my) end
end

function Player:takeDmg(dmg)
    if Player.immunityCooldown == 0 then
        Player.health = Player.health - dmg
        Player.immunityCooldown = Player.IMMUNITY
    end
end
