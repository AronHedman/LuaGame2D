Player = {}

function Player:load()
    self.x = 200;
    self.y = 200;

    self.sWidth = 12
    self.sHeight = 18

    self.cWidth = 24
    self.cHeight = 24

    self.speed = 175
    self.dirX = 0
    self.dirY = 0
    self.facing = "down"
    self.animationSpeed = 0.2
    self.scale = 5
    self.linearDamping = 10


    self.body = love.physics.newBody(world, self.x, self.y, "dynamic")
    self.body:setFixedRotation(true)
    self.body:setLinearDamping(self.linearDamping)

    self.shape = love.physics.newRectangleShape(self.cWidth, self.cHeight)

    self.fixture = love.physics.newFixture(self.body, self.shape, 1)


    self.spritesheet = love.graphics.newImage("assets/testPlayer.png")
    self.grid = anim8.newGrid(self.spritesheet:getWidth() / 4, self.spritesheet:getHeight() / 4,
        self.spritesheet:getWidth(), self.spritesheet:getHeight(), 0, 0)
    self.animations = {}
    self.animations.down = anim8.newAnimation(self.grid("1-4", 1), self.animationSpeed)
    self.animations.left = anim8.newAnimation(self.grid("1-4", 2), self.animationSpeed)
    self.animations.right = anim8.newAnimation(self.grid("1-4", 3), self.animationSpeed)
    self.animations.up = anim8.newAnimation(self.grid("1-4", 4), self.animationSpeed)
    --self.animations.idle = anim8.newAnimation(self.grid("3-4", 1), self.animationSpeed * 4)
    self.animation = self.animations.down
end

function Player:update(dt)
    self:playerMovement(dt)

    self.x = self.body:getX()
    self.y = self.body:getY()

    self.animation:update(dt)
end

function Player:draw() --draw function
    self.animation:draw(self.spritesheet, self.x, self.y, nil, self.scale, self.scale, self.sWidth / 2,
        self.sHeight * 0.82)
end

function Player:playerMovement()
    -- if not (love.keyboard.isDown("a") or love.keyboard.isDown("d") or love.keyboard.isDown("w") or
    --         love.keyboard.isDown("s")) then
    --     self.animation = self.animations.idle
    -- end
    if love.keyboard.isDown("a") and (self.body:getX() + (self.sWidth / 2) > 0) then
        self.dirX = -1
        self.facing = "left"
        self.animation = self.animations.left
    elseif love.keyboard.isDown("d") and self.body:getX() - self.sWidth / 2 < map1.width * map1.tilewidth then
        self.dirX = 1
        self.facing = "right"
        self.animation = self.animations.right
    elseif (self.body:getX() + self.sWidth / 2 < 0) then
        self.body:setX(0)
    elseif (self.body:getX() - self.sWidth / 2 > map1.width * map1.tilewidth) then
        self.body:setX(map1.width * map1.tilewidth)
    end
    if love.keyboard.isDown("w") and (self.body:getY() + (self.sHeight / 2) > 0) then
        self.dirY = -1
        self.facing = "up"
        self.animation = self.animations.up
    elseif love.keyboard.isDown("s") and (self.body:getY() - (self.sHeight / 2) < map1.height * map1.tileheight) then
        self.dirY = 1
        self.facing = "down"
        self.animation = self.animations.down
    elseif (self.body:getY() + self.sHeight / 2 < 0) then
        self.body:setY(0)
    elseif (self.body:getY() - self.sHeight / 2 > map1.height * map1.tileheight) then
        self.body:setY(map1.height * map1.tileheight)
    end

    if self.dirX ~= 0 or self.dirY ~= 0 then
        local vec = vector(self.dirX, self.dirY):normalized() * self.speed
        self.body:setLinearVelocity(vec.x, vec.y)
    end

    self.dirX = 0
    self.dirY = 0
end

function Player:setDir(dir)
    self.dirX = math.cos(dir)
    self.dirY = math.sin(dir)
end

function Player:setSpeed(vec)
    self.body:setLinearVelocity(vec.x, vec.y)
end
