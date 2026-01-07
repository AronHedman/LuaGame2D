function love.load()
    baseW, baseH = 1024, 576 --16 x 9 tiles of 64x64
    --cW, cH = love.graphics.getDimensions()  (ta bort?)
    scale = 1

    require("src.load")
    load()

    gamestate = 1
    --0 menu (esc)
    --1 playing
    --1.5 playing, not accepting input
    --2 inventories
    --3 paused (frozen)
end

function love.update(dt)
    update(dt)
end

function love.draw()
    draw()
end

function love.resize(w, h)
    scale = h / baseH
    g.setNewFont(14 * scale)

    cam:zoomTo(scale)
end

function camBounds()
    local w = g.getWidth()
    local h = g.getHeight()
    local zoom = scale

    local halfW = (w / zoom) / 2
    local halfH = (h / zoom) / 2


    if cam.x < halfW then
        cam.x = halfW
    elseif cam.x > map1.width * map1.tilewidth - halfW then
        cam.x = map1.width * map1.tilewidth - halfW
    end

    if cam.y < halfH then
        cam.y = halfH
    elseif cam.y > map1.height * map1.tileheight - halfH then
        cam.y = map1.height * map1.tileheight - halfH
    end
end
