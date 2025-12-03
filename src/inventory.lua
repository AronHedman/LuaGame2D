-- Global activeSlot remains as-is, assuming it's managed by the player or game logic
activeSlot = 1
hotSlot = { inventory = nil, slot = nil } -- {inventory, slot}

Slot = {}                                 -- Metatable for Slot class

function Slot:new(options)
    local self = setmetatable({}, { __index = Slot })

    -- Default options
    local defaults = {
        row = 0,
        col = 0,
        item = nil,
        isHotbar = false -- Flag for hotbar-specific styling/behavior if needed
    }

    -- Merge user options with defaults
    options = options or {}
    for k, v in pairs(defaults) do
        if options[k] == nil then options[k] = v end
    end

    self.row = options.row
    self.col = options.col
    self.item = options.item
    self.isHotbar = options.isHotbar

    return self
end

function Slot:draw(invX, invY, invScale, slotSize, paddingX, paddingY)
    local mx, my = love.mouse.getPosition()
    local g = love.graphics

    g.setColor(mainGrey)
    g.setLineWidth(mediumLine)

    local sx = invX + paddingX / 2 + (self.col * (slotSize + paddingX))
    local sy = invY + paddingY / 2 + (self.row * (slotSize + paddingY))

    g.rectangle("line", sx, sy, slotSize, slotSize, 4 * invScale)

    local hot = mx > sx and mx < sx + slotSize and my > sy and my < sy + slotSize
    if hot then
        g.setColor(transparentGreyHighlight)
        g.rectangle("fill", sx, sy, slotSize, slotSize, 4 * invScale)
    end

    if self.item ~= nil then
        -- Draw item sprites/amounts
    end

    g.setColor(white)
end

function Slot:isHovered(invX, invY, invScale, slotSize, paddingX, paddingY)
    local mx, my = love.mouse.getPosition()

    local sx = invX + paddingX / 2 + (self.col * (slotSize + paddingX))
    local sy = invY + paddingY / 2 + (self.row * (slotSize + paddingY))
    return mx > sx and mx < sx + slotSize and my > sy and my < sy + slotSize
end

function Slot:leftClick()
    if heldItem ~= nil then
        -- Swap or add to stack (add logic if items stack)
        self.item, heldItem = heldItem, self.item
    else
        heldItem = self.item
        self.item = nil
    end
end

function Slot:rightClick()
    --Splitting stacks, alternatively use for some kind of crafting system
end

-- Define the Inventory class
Inventory = {} -- Metatable for Inventory class

function Inventory:new(options)
    local self = setmetatable({}, { __index = Inventory })

    -- Default options
    local defaults = {
        rows = 5,
        cols = 7,
        hasHotbar = false,
        scaleMultiplier = 1.0, -- Optional scale adjustment per inventory
        --type = "chest"  -- Can be "player", "chest", "npc", etc., but mainly used for layout logic
        isActive = false       -- Whether this inventory is currently open
    }

    -- Merge user options with defaults
    options = options or {}
    for k, v in pairs(defaults) do
        if options[k] == nil then options[k] = v end
    end

    self.rows = options.rows
    self.cols = options.cols
    self.hasHotbar = options.hasHotbar
    self.scaleMultiplier = options.scaleMultiplier
    self.type = options.type
    self.isActive = options.isActive

    self.hotbarSize = self.hasHotbar and self.cols or 0
    self.totalSlots = self.rows * self.cols + self.hotbarSize
    self.gridStart = self.hotbarSize + 1

    -- Create slots as Slot instances
    self.slots = {}
    local slotIndex = 1
    -- Hotbar slots (if any)
    for i = 1, self.hotbarSize do
        self.slots[slotIndex] = Slot:new({ row = 0, col = i - 1, isHotbar = true })
        slotIndex = slotIndex + 1
    end
    -- Grid slots
    for row = 0, self.rows - 1 do
        for col = 0, self.cols - 1 do
            self.slots[slotIndex] = Slot:new({ row = row, col = col })
            slotIndex = slotIndex + 1
        end
    end

    return self
end

function Inventory:update()

end

function Inventory:draw(x, y)
    local g = love.graphics
    local invScale = 1.5 * scale * self.scaleMultiplier
    local slotSize = 32 * invScale
    local paddingX = 10 * invScale
    local paddingY = 10 * invScale
    local invW = self.cols * (slotSize + paddingX)
    local invH = self.rows * (slotSize + paddingY)

    -- Default/centered position logic
    if self.type == "player" then
        x = screenW / 2 - invW / 2 - paddingX / 2
        for i, inv in pairs(inventories) do
            if inv.isActive and inv.type ~= "player" then
                x = x - invW * 2 / 7
                break
            end
        end
    else
        x = screenW / 2 - paddingX / 2 + invW / 2
    end

    if self.type == "player" then
        y = map1.height / 2 - invH / 2 + 15 * invScale
    else
        y = map1.height / 2 - 3 * (slotSize + paddingY) + 15 * invScale -- Simpler centering above player inventory
    end

    -- Draw background
    g.setColor(mainGrey)
    g.setLineWidth(thickLine)
    g.rectangle("line", x, y, invW + paddingX, invH + paddingY, 8 * invScale)

    g.setColor(transparentGrey)
    g.rectangle("fill", x, y, invW + paddingX, invH + paddingY, 8 * invScale)
    g.setLineWidth(mediumLine)

    local slotsPerRow = self.cols
    local startSlot = (self.hasHotbar and self.type == "player") and self.gridStart or 1
    local endSlot = self.totalSlots
    --local drawRows = self.rows

    for i = startSlot, endSlot do
        g.setColor(mainGrey)

        local slot_num = i - startSlot + 1
        local row = math.floor((slot_num - 1) / slotsPerRow)
        local col = (slot_num - 1) % slotsPerRow
        local j = col - math.floor((self.cols - 1) / 2) -- Center columns (e.g., -3 to 3 for cols=7)

        --slot x/y
        local sx = x + paddingX / 2 + (col * (slotSize + paddingX)) + paddingX / 2
        local sy = y + paddingY / 2 + (row * (slotSize + paddingY)) + paddingY / 2

        g.rectangle("line", sx, sy, slotSize, slotSize, 4 * invScale)

        local hot = mx > sx and mx < sx + slotSize and my > sy and my < sy + slotSize
        if hot then
            g.setColor(transparentGreyHighlight)
            g.rectangle("fill", sx, sy, slotSize, slotSize, 4 * invScale)

            hotSlot.inventory = self
            hotSlot.slot = i
        end

        local item = self.slots[i]
        if item ~= nil then
            g.setColor(white)
            g.draw(item.sprite, sx, sy, 0, invScale, invScale, 0, 0, 0, 0)
        end
    end

    if heldItem ~= nil then
        g.setColor(white)
        g.draw(heldItem.sprite, mx, my, 0, invScale, invScale, 0, 0, 0, 0)
    end

    g.setColor(white)
end

function Inventory:drawHotbar()
    if not self.hasHotbar then return end

    local g = love.graphics
    local hotbarScale = 1.3 * scale * self.scaleMultiplier
    local slotSize = 32 * hotbarScale
    local padding = 16 * hotbarScale
    local hotbarW = (slotSize + padding) * self.hotbarSize - padding
    local hotbarH = slotSize + padding

    local hotbarX = screenW / 2 - hotbarW / 2 - padding / 2
    local hotbarY = screenH - hotbarH - 15 * hotbarScale

    -- Draw hotbar background
    g.setColor(mainGrey)
    g.setLineWidth(thickLine)
    g.rectangle("line", hotbarX, hotbarY, hotbarW + padding, hotbarH, 8 * hotbarScale)

    g.setColor(transparentGrey)
    g.rectangle("fill", hotbarX, hotbarY, hotbarW + padding, hotbarH, 8 * hotbarScale)
    g.setLineWidth(mediumLine)

    local centerOffset = math.ceil(self.cols / 2)
    for slot = 1, self.hotbarSize do
        g.setColor(mainGrey)

        local i = slot - centerOffset -- e.g., -3 to 3 for 7 slots
        local sx = hotbarX + padding / 2 + ((slot - 1) * (slotSize + padding))
        local sy = hotbarY + padding / 2

        g.rectangle("line", sx, sy, slotSize, slotSize, 4 * hotbarScale)

        local hot = mx > sx and mx < sx + slotSize and my > sy and my < sy + slotSize
        if hot then
            g.setColor(transparentGreyHighlight)
            g.rectangle("fill", sx, sy, slotSize, slotSize, 4 * hotbarScale)
            hotSlot.inventory = self
            hotSlot.slot = slot
        end

        if activeSlot == slot then
            g.setColor(brightGrey)
            g.setLineWidth(thickLine)
            g.rectangle("line", sx, sy, slotSize, slotSize, 4 * hotbarScale)
            g.setLineWidth(mediumLine)
        end

        local item = self.slots[slot]
        if item ~= nil then
            g.setColor(white)
            g.draw(item.sprite, sx, sy, 0, hotbarScale, hotbarScale, 0, 0, 0, 0)
        end
    end
end

function Inventory:leftClick()
    local mx, my = love.mouse.getPosition()

    if heldItem ~= nil then
        self:addItem(heldItem, hotSlot.slot)
    else
        self:takeItem(hotSlot.slot)
    end

    print("Left click in " .. hotSlot.inventory.type .. " at slot " .. hotSlot.slot)
end

function Inventory:rightClick()
    local mx, my = love.mouse.getPosition()
    -- Similar to leftClick, perhaps for splitting stacks or other actions

    print("Right click in " .. hotSlot.inventory.type .. " at slot " .. hotSlot.slot)
end

function Inventory:addItem(item, slot)
    if heldItem ~= nil then
        self.slots[slot], heldItem = heldItem, self.slots[slot]
    else
        for i = 1, self.totalSlots do
            if self.slots[i] == nil then
                self.slots[i] = item
                break
            end
        end
    end
end

function Inventory:takeItem(slot)
    heldItem, self.slots[slot] = self.slots[slot], nil
end

function Inventory:dropItem()
    -- If outside inventory and click -> drop on ground
    heldItem = nil
    -- Add logic for 'floating' items
end
