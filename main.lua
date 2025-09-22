function love.load()
    require("src.load")
    load()
end
    
function love.update(dt)
    update(dt)
end

function love.draw()
    draw()
end

function camBounds()
    local w = g.getWidth()
    local h = g.getHeight()

    if cam.x < w / 2 then
        cam.x = w / 2
    elseif cam.x > map1.width * map1.tilewidth - w / 2 then
        cam.x = map1.width * map1.tilewidth - w / 2
    end

    if cam.y < h / 2 then
        cam.y = h / 2
    elseif cam.y > map1.height * map1.tileheight - h / 2 then
        cam.y = map1.height * map1.tileheight - h / 2
    end
end
