player = world:newBSGRectangleCollider(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 50, 50, 10)

player.x = love.graphics.getWidth() / 2
player.y = love.graphics.getHeight() / 2
player.speed = 350
player.dirX = 0
player.dirY = 0
player.facing = "down"
player.linearDamping = 15

player.dashCooldown = 0.75

player.gameState = 1
-- 1 = accepting input
-- 0 = not accepting input
player.gameStateTimer = 0

--temp
player.width = 50
player.height = 50

--temp

--player:setCollisionClass("Player")
player:setFixedRotation(true)
player:setLinearDamping(player.linearDamping)

function player:update(dt)

    self:updateGameState(dt)
    
    if self.gameState == 1 then
        self:playerMovement(dt)
    
    end

    self.x = self:getX()
    self.y = self:getY()

end


function player:draw() --draw function

end

function player:playerMovement(dt)

        if self.gameState == 1 then
        if love.keyboard.isDown("w") then
            self.dirY = -1
            self.facing = "up"
        elseif love.keyboard.isDown("s") then
            self.dirY = 1
            self.facing = "down"
        end
        if love.keyboard.isDown("a") then
            self.dirX = -1
            self.facing = "left"
        elseif love.keyboard.isDown("d") then
            self.dirX = 1
            self.facing = "right"
        end
    end

    if self.dirX ~= 0 or self.dirY ~= 0 then
        local vec = vector(self.dirX, self.dirY):normalized() * self.speed
        self:setLinearVelocity(vec.x, vec.y)
    end

    self.dirX = 0
    self.dirY = 0
end

function player:dash()
    if self.gameState == 1 then
        self.gameStateTimer = self.dashCooldown --cooldown

        self:setLinearVelocity(0, 0)

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
    self:setLinearVelocity(vec.x, vec.y)
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
