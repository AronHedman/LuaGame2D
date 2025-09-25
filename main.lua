local BASE_W, BASE_H = 854, 480 -- virtual resolution (change if you want)
local scale = 1
local offsetX, offsetY = 0, 0
local windowW, windowH = 0, 0
local integerScaling = false -- toggle for pixel-perfect scaling


function love.load()
    require("src.load")
    load()

    computeScaleAndOffset()

    gamestate = 1
    --0 paused
    --1 playing
    --2 inventory
    --3 menu
end

function love.update(dt)
    update(dt)
end

function love.draw()
    love.graphics.clear(0.06, 0.06, 0.07)

    local halfW, halfH = BASE_W * 0.5, BASE_H * 0.5

    -- compute the raw virtual translation
    local rawTx = cam.x - halfW
    local rawTy = cam.y - halfH

    -- Round to nearest 1/scale virtual unit so (rawTx * scale) is integer
    local quant = 1 / scale
    local qTx = math.floor(rawTx / quant + 0.5) * quant -- + 0.5 to always round up with math.floor()
    local qTy = math.floor(rawTy / quant + 0.5) * quant

    -- camera transform to apply (negative because you move the world)
    local camTransX = -qTx
    local camTransY = -qTy


    love.graphics.push()
    love.graphics.translate(offsetX, offsetY)
    love.graphics.scale(scale, scale)

    love.graphics.translate(camTransX, camTransY)

    draw()

    --Draw here for unscaled stuff (UI)

    love.graphics.setColor(1, 1, 1)
end

function love.resize(w, h)
    -- Note: love.graphics.getWidth/getHeight reflect framebuffer size; we still call compute.
    computeScaleAndOffset()
end

function camBounds()
    local w = BASE_W
    local h = BASE_H

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

function computeScaleAndOffset()
    -- Use drawable window size (framebuffer pixels)
    windowW, windowH    = love.graphics.getWidth(), love.graphics.getHeight()

    local scaleByHeight = windowH / BASE_H
    local scaleByWidth  = windowW / BASE_W

    -- Height-first but clamp to width = uniform scale: min(heightScale, widthScale)
    local s             = math.min(scaleByHeight, scaleByWidth)

    if integerScaling then
        s = math.max(1, math.floor(s + 0.0001))
    end

    scale = s

    local scaledW, scaledH = BASE_W * scale, BASE_H * scale
    offsetX = math.floor((windowW - scaledW) / 2 + 0.5)
    offsetY = math.floor((windowH - scaledH) / 2 + 0.5)
end

function screenToVirtual(sx, sy)
    -- Converts real screen coords (love.mouse.getPosition) -> virtual game coords
    local vx = (sx - offsetX) / scale
    local vy = (sy - offsetY) / scale
    return vx, vy
end

function virtualToScreen(vx, vy)
    local sx = vx * scale + offsetX
    local sy = vy * scale + offsetY
    return sx, sy
end
