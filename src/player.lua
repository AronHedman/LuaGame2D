Player = {}


function Player:load()
    self.x = 200;
    self.y = 200;

    self.width = 12
    self.height = 18

    self.speed = 175
    self.dirX = 0
    self.dirY = 0
    self.facing = "down"
    self.animationSpeed = 0.2
    self.scale = 5
    self.linearDamping = 10

    self.dashCooldown = 0.75

    self.gameState = 1
    -- 1 = accepting input
    -- 0 = not accepting input
    self.gameStateTimer = 0

    self.body = love.physics.newBody(world, self.x, self.y, "dynamic") 
    self.body:setFixedRotation(true)
    self.body:setLinearDamping(self.linearDamping)

    self.shape = love.physics.newRectangleShape(self.width, self.height)

    self.fixture = love.physics.newFixture(self.body, self.shape, 1)


    --temp

    --temp

    self.spritesheet = love.graphics.newImage("assets/testPlayer.png")
    self.grid = anim8.newGrid(self.width, self.height, self.spritesheet:getWidth(), self.spritesheet:getHeight(), 0, 0)
    self.animations = {}
    self.animations.down = anim8.newAnimation(self.grid("1-4", 1), self.animationSpeed)
    self.animations.left = anim8.newAnimation(self.grid("1-4", 2), self.animationSpeed)
    self.animations.right = anim8.newAnimation(self.grid("1-4", 3), self.animationSpeed)
    self.animations.up = anim8.newAnimation(self.grid("1-4", 4), self.animationSpeed)
    self.animation = self.animations.down

end

function Player:update(dt)
    self:updateGameState(dt)

    if self.gameState == 1 then
        self:playerMovement(dt)
    end


    self.x = self.body:getX()
    self.y = self.body:getY()

    self.animation:update(dt)
end

function Player:draw() --draw function
    self.animation:draw(self.spritesheet, self.x, self.y, nil, self.scale, self.scale, self.width / 2,
        self.height / 2)
end

function Player:playerMovement(dt)
    if self.gameState == 1 then
        if love.keyboard.isDown("a") then
            self.dirX = -1
            self.facing = "left"
            self.animation = self.animations.left
        elseif love.keyboard.isDown("d") then
            self.dirX = 1
            self.facing = "right"
            self.animation = self.animations.right
        end
        if love.keyboard.isDown("w") then
            self.dirY = -1
            self.facing = "up"
            self.animation = self.animations.up
        elseif love.keyboard.isDown("s") then
            self.dirY = 1
            self.facing = "down"
            self.animation = self.animations.down
        end
    end

    if self.dirX ~= 0 or self.dirY ~= 0 then
        local vec = vector(self.dirX, self.dirY):normalized() * self.speed
        self.body:setLinearVelocity(vec.x, vec.y)
    end

    if (self.body:getX() + self.width / 2 < 0) then
        self.body:setX(0)
    elseif (self.body:getX() - self.width / 2 > map1.width * map1.tilewidth) then
        self.body:setX(map1.width * map1.tilewidth)
    end
    if (self.body:getY() + self.height / 2 < 0) then
        self.body:setY(0)
    elseif (self.body:getY() - self.height / 2 > map1.height * map1.tileheight) then
        self.body:setY(map1.height * map1.tileheight)
    end


    self.dirX = 0
    self.dirY = 0
end

function Player:dash()
    if self.gameState == 1 then
        self.gameStateTimer = self.dashCooldown --cooldown

        self.body:setLinearVelocity(0, 0)

        local angle = math.atan2(mouse_y - self.y, mouse_x - self.x)

        self:setDir(angle)

        local vec = vector(self.dirX, self.dirY):normalized() * self.speed * 5

        self:setSpeed(vec)

        self.dirX, self.dirY = 0, 0
    end
end

function Player:setDir(direction)
    self.dirX = math.cos(direction)
    self.dirY = math.sin(direction)
end

function Player:setSpeed(vec)
    self.body:setLinearVelocity(vec.x, vec.y)
end

function Player:updateGameState(dt)
    if self.gameStateTimer > 0 then
        self.gameState = 0
        self.gameStateTimer = self.gameStateTimer - dt
    else
        self.gameState = 1
    end
end

function Player:increaseGameStateTimer(time)
    self.gameStateTimer = self.gameStateTimer + time
end

return Player