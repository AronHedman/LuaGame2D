function love.load()
    --load stuff
    require("src.gameStart.require")
    loadRequires()

    --set up the game
    setupGame()
end

function love.update(dt)
    
    fetchMousePos()

    world:update(dt) 
    player:update(dt)


    
end

function love.draw()

    player:draw()
    world:draw() --Draws the colliders

end
