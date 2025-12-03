function drawUI()
    screenW, screenH = g.getDimensions()

    hotSlot = { inventory = nil, slot = nil }

    drawHUD()

    inventory:drawHotbar()

    if gamestate == 2 then
        inventory.isActive = true
    else
        inventory.isActive = false
    end

    for i, inv in pairs(inventories) do
        if inv.isActive then
            inv:draw()
        end
    end

    if gamestate == 0 then
        drawMenu()
    end
end

function drawHUD()
    drawHP()
end

function drawMenu()
    g.setColor(1, 1, 1, 1)
    g.print("Menu", 40 * scale, 60 * scale)
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
