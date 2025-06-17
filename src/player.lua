player = {}
player.x = 200;
player.y = 200;

player.width = 12
player.height = 18

player.speed = 175
player.dirX = 0
player.dirY = 0
player.facing = "down"
player.animationSpeed = 0.2
player.scale = 5
player.linearDamping = 10

player.dashCooldown = 0.75

player.gameState = 1
-- 1 = accepting input
-- 0 = not accepting input
player.gameStateTimer = 0

player.body = love.physics.newBody(world, player.x, player.y, "dynamic") 
player.body:setFixedRotation(true)
player.body:setLinearDamping(player.linearDamping)

player.shape = love.physics.newRectangleShape(player.width, player.height)

player.fixture = love.physics.newFixture(player.body, player.shape, 1)


--temp

--temp

player.spritesheet = love.graphics.newImage("assets/testPlayer.png")
player.grid = anim8.newGrid(player.width, player.height, player.spritesheet:getWidth(), player.spritesheet:getHeight(), 0, 0)
player.animations = {}
player.animations.down = anim8.newAnimation(player.grid("1-4", 1), player.animationSpeed)
player.animations.left = anim8.newAnimation(player.grid("1-4", 2), player.animationSpeed)
player.animations.right = anim8.newAnimation(player.grid("1-4", 3), player.animationSpeed)
player.animations.up = anim8.newAnimation(player.grid("1-4", 4), player.animationSpeed)
player.animation = player.animations.down


function player:update(dt)
    self:updateGameState(dt)

    if self.gameState == 1 then
        self:playerMovement(dt)
    end


    self.x = self.body:getX()
    self.y = self.body:getY()

    self.animation:update(dt)
end

function player:draw() --draw function
    player.animation:draw(player.spritesheet, self.x, self.y, nil, player.scale, player.scale, player.width / 2,
        player.height / 2)
end

function player:playerMovement(dt)
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

function player:dash()
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

function player:setDir(direction)
    self.dirX = math.cos(direction)
    self.dirY = math.sin(direction)
end

function player:setSpeed(vec)
    self.body:setLinearVelocity(vec.x, vec.y)
end

function player:updateGameState(dt)
    if self.gameStateTimer > 0 then
        self.gameState = 0
        self.gameStateTimer = self.gameStateTimer - dt
    else
        self.gameState = 1
    end
end

function player:increaseGameStateTimer(time)
    self.gameStateTimer = self.gameStateTimer + time
end
