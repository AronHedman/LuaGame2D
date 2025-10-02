inventory = {}

-- 35 slots,    7 x 4 inventory
--              + 7 hotbar (slot 1-7) down-left to top-right

function inventory:addItem(item, slot)

end

function inventory:takeItem(slot)

end

function inventory:draw()

    local invScale = 1.5 * scale
    local slotSize = 32 * invScale
    local padding = 16 * invScale
    local invW, invH = 7 * (slotSize + padding), 4 * (slotSize + padding)
    

    g.setColor(mainGrey)
    g.setLineWidth(thickLine)
    g.rectangle("line", (screenW / 2 - invW / 2), (screenH / 2 - invH / 2 - 15 * invScale), invW, invH, 8 * invScale)
    
    g.setColor(transparentGrey)
    g.rectangle("fill", (screenW / 2 - invW / 2), (screenH / 2 - invH / 2 - 15 * invScale), invW, invH, 8 * invScale)

    g.setColor(mainGrey)
    g.setLineWidth(mediumLine)

    for i = 0, 3 do
        for j = -3, 3 do
            g.rectangle("line", (screenW / 2 + (j * slotSize) + (j * padding - (slotSize / 2))), (screenH / 2 - invH / 2 + (i * slotSize) + (i * padding) - padding/2), slotSize, slotSize, 4 * invScale)
        end
    end
    g.setColor(white)
end

function drawHotbar()
    local hotbarScale = 1.3 * scale
    local hotbarW, hotbarH = 336 * hotbarScale, 48 * hotbarScale
    local slotSize = 32 * hotbarScale
    local padding = 16 * hotbarScale

    g.setColor(mainGrey)
    g.setLineWidth(thickLine)
    g.rectangle("line", (screenW / 2 - hotbarW / 2), (screenH - hotbarH - 15 * hotbarScale), hotbarW, hotbarH, 8 * hotbarScale)
    g.setColor(transparentGrey)
    g.rectangle("fill", (screenW / 2 - hotbarW / 2), (screenH - hotbarH - 15 * hotbarScale), hotbarW, hotbarH, 8 * hotbarScale)

    g.setColor(mainGrey)
    g.setLineWidth(mediumLine)
    for i = -3, 3 do
        g.rectangle("line", (screenW / 2 + (i * slotSize) + (i * padding - (slotSize / 2))), (screenH - hotbarH - 15 * hotbarScale + (hotbarH / 2 - slotSize / 2)), slotSize, slotSize, 4 * hotbarScale)
    end

    g.setColor(white)
end