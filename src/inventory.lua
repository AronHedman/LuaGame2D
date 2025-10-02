inventory = {}

heldItem = nil

-- 35 slots,    7 x 4 inventory
--              + 7 hotbar (slot 1-7) down-left to top-right
function inventory:load()
    for i = 1, 35 do
        table.insert(inventory, i)
    end
end

function inventory:draw()
    local mx, my = love.mouse.getPosition()

    local invScale = 1.5 * scale
    local slotSize = 32 * invScale
    local padding = 16 * invScale
    local invW, invH = 7 * (slotSize + padding), 4 * (slotSize + padding)


    g.setColor(mainGrey)
    g.setLineWidth(thickLine)
    g.rectangle("line", (screenW / 2 - invW / 2), (screenH / 2 - invH / 2 - 15 * invScale), invW, invH, 8 * invScale)

    g.setColor(transparentGrey)
    g.rectangle("fill", (screenW / 2 - invW / 2), (screenH / 2 - invH / 2 - 15 * invScale), invW, invH, 8 * invScale)

    g.setLineWidth(mediumLine)

    local slotsPerRow = 7 
    local startSlot = 8

    for i = startSlot, #inventory do
        
        g.setColor(mainGrey)

        local slot_num = i - startSlot + 1            -- 1-based position in the grid (1,2,3,...)
        local k = math.floor((slot_num - 1) / slotsPerRow) -- Row (0-based: 0,1,2,3)
        local col = (slot_num - 1) % slotsPerRow       -- Column (0-based: 0 to 6)
        local j = col - 3

        local sx = (screenW / 2 + (j * slotSize) + (j * padding - (slotSize / 2)))
        local sy = (screenH / 2 - invH / 2 + (k * slotSize) + (k * padding) - padding / 2)

        g.rectangle("line", sx, sy, slotSize, slotSize, 4 * invScale)

        local hot = mx > sx and mx < sx + slotSize and my > sy and my < sy + slotSize
        if hot then
            g.setColor(transparentGreyHighlight)
            g.rectangle("fill", sx, sy, slotSize, slotSize, 4 * invScale)
        end
    
        -- Example: Extract and use data from this slot (customize as needed)
        local item = inventory[i]
        if item  ~= nil then
            -- Draw item sprites/amounts here
        end
    end

    if heldItem ~= nil then

    end
    g.setColor(white)
end

function inventory:addItem(item, slot)
    if heldItem ~= nil then
        inventory[slot] = heldItem
        heldItem = nil
    else
        for i = 1, #inventory do
            if inventory[i] == nil then
                inventory[i] = item
                break
            end
        end
    end
end

function inventory:takeItem(slot)
    heldItem = inventory[slot]
    inventory[slot] = nil
end

function drawHotbar()
    local hotbarScale = 1.3 * scale
    local hotbarW, hotbarH = 336 * hotbarScale, 48 * hotbarScale
    local slotSize = 32 * hotbarScale
    local padding = 16 * hotbarScale

    g.setColor(mainGrey)
    g.setLineWidth(thickLine)
    g.rectangle("line", (screenW / 2 - hotbarW / 2), (screenH - hotbarH - 15 * hotbarScale), hotbarW, hotbarH,
        8 * hotbarScale)
    g.setColor(transparentGrey)
    g.rectangle("fill", (screenW / 2 - hotbarW / 2), (screenH - hotbarH - 15 * hotbarScale), hotbarW, hotbarH,
        8 * hotbarScale)

    g.setColor(mainGrey)
    g.setLineWidth(mediumLine)
    for i = -3, 3 do
        g.rectangle("line", (screenW / 2 + (i * slotSize) + (i * padding - (slotSize / 2))),
            (screenH - hotbarH - 15 * hotbarScale + (hotbarH / 2 - slotSize / 2)), slotSize, slotSize, 4 * hotbarScale)
    end

    g.setColor(white)
end
