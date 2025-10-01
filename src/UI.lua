local white = { 1, 1, 1, 1 }
local black = { 0, 0, 0, 1 }
local mainGrey = { 0.5, 0.5, 0.45, 1 }
local brightGrey = { 0.7, 0.7, 0.65, 1 }
local transparentGrey = { 0.3, 0.3, 0.3, 0.6 }

function drawUI()
    screenW, screenH = g.getDimensions()

    drawHUD()

    if gamestate == 2 then
        --inventory:draw()
    end
    if gamestate == 0 then
        drawMenu()
    end
end

function drawHUD()
    drawHP()
    drawHotbar()
end

function drawMenu()
    g.setColor(1, 1, 1, 1)
    g.print("Menu", 40 * scale, 60 * scale)
end

function drawHotbar()
    local hotbarW, hotbarH = 336 * scale, 48 * scale

    g.setColor(mainGrey)
    g.rectangle("line", (screenW / 2 - hotbarW / 2), (screenH - hotbarH - 20 * scale), hotbarW, hotbarH, 8 * scale)
    g.setColor(transparentGrey)
    g.rectangle("fill", (screenW / 2 - hotbarW / 2), (screenH - hotbarH - 20 * scale), hotbarW, hotbarH, 8 * scale)



    g.setColor(white)
end

function drawHP()
    local heartsImg = g.newImage("assets/heart.png")
    local fullHeart = g.newQuad(0, 0, 16, 16, heartsImg)
    local halfHeart = g.newQuad(16, 0, 16, 16, heartsImg)
    local emptyHeart = g.newQuad(32, 0, 16, 16, heartsImg)

    local heartX, heartY = 800 * scale, 10 * scale

    local playerHP = Player.health
    local drawnHearts = 0
    local hScale = 4 * scale

    while drawnHearts < 5 do
        if playerHP - 2 >= 0 then
            g.draw(heartsImg, fullHeart, heartX, heartY, nil, hScale, hScale)
            heartX = heartX + 10 * hScale
            playerHP = playerHP - 2
            drawnHearts = drawnHearts + 1
        elseif playerHP - 1 >= 0 then
            g.draw(heartsImg, halfHeart, heartX, heartY, nil, hScale, hScale)
            heartX = heartX + 10 * hScale
            playerHP = playerHP - 1
            drawnHearts = drawnHearts + 1
        else
            g.draw(heartsImg, emptyHeart, heartX, heartY, nil, hScale, hScale)
            heartX = heartX + 10 * hScale
            drawnHearts = drawnHearts + 1
        end
    end
end
