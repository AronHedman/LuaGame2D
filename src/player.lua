Player = {}

function Player:load()
    self.state = nil --"idle"
    self.facing = "down"

    self.x = 200;
    self.y = 200;

    self.sWidth = 12 --Sprite witdth
    self.sHeight = 18

    self.cWidth = 24 --Collision width
    self.cHeight = 24

    self.speed = 175
    self.dirX = 0
    self.dirY = 0
    self.animationSpeed = 0.2
    self.scale = 5
    ----Game stats

    self.health = 10

    -----

    self.body = p.newBody(world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.body:setLinearDamping(linearDamping)

    self.shape = p.newRectangleShape(self.cWidth, self.cHeight)

    self.fixture = p.newFixture(self.body, self.shape, 1)


    self.spritesheet = g.newImage("assets/testPlayer.png")
    self.grid = anim8.newGrid(self.spritesheet:getWidth() / 4, self.spritesheet:getHeight() / 4,
        self.spritesheet:getWidth(), self.spritesheet:getHeight(), 0, 0)
    self.animations = {
        down = anim8.newAnimation(self.grid("1-4", 1), self.animationSpeed),
        left = anim8.newAnimation(self.grid("1-4", 2), self.animationSpeed),
        right = anim8.newAnimation(self.grid("1-4", 3), self.animationSpeed),
        up = anim8.newAnimation(self.grid("1-4", 4), self.animationSpeed)
    }
    --self.animations.idle = anim8.newAnimation(self.grid("3-4", 1), self.animationSpeed * 4)
    self.animation = self.animations.down

    self.actionManager = ActionManager:new(self)
end

function Player:update(dt)
    self:playerMovement()
    Movement.playerUpdate(self, dt)

    self:checkBoundaries()

    self.x = self.body:getX()
    self.y = self.body:getY()

    Animation.update(self, dt)


    self.actionManager:update(dt)
end

function Player:draw() --draw function
    self.animation:draw(self.spritesheet, self.x, self.y, nil, self.scale, self.scale, self.sWidth / 2,
        self.sHeight * 0.82)
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
    sx, sy = self.body:getPosition()
    mx = map1.tilewidth * map1.width
    my = map1.tileheight * map1.height

    if sx <= 0 then self.body:setX(0) end
    if sy <= 0 then self.body:setY(0) end
    if sx >= mx then self.body:setX(mx) end
    if sy >= my then self.body:setY(my) end
end
