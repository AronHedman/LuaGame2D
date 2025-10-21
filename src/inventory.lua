-- Global heldItem remains as-is, assuming it's managed by the player or game logic
heldItem = nil

Slot = {} -- Metatable for Slot class

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
        scaleMultiplier = 1.0,
        type = "chest", -- "player", "chest", etc.
        isActive = false
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
        y = screenH / 2 - invH / 2 + 15 * invScale
    else
        x = screenW / 2 - paddingX / 2 + invW / 2
        y = screenH / 2 - 3 * (slotSize + paddingY) + 15 * invScale
    end

    -- Draw background
    g.setColor(mainGrey)
    g.setLineWidth(thickLine)
    g.rectangle("line", x, y, invW + paddingX, invH + paddingY, 8 * invScale)

    g.setColor(transparentGrey)
    g.rectangle("fill", x, y, invW + paddingX, invH + paddingY, 8 * invScale)

    for i = self.gridStart, self.totalSlots do
        local slot = self.slots[i]
        slot:draw(x + paddingX / 2, y + paddingY / 2, invScale, slotSize, paddingX, paddingY)
    end

    -- Draw held item at mouse pos (as in original)
    if heldItem then
        -- Add drawing logic here, e.g., follow mouse
    end
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

    for i = 1, self.hotbarSize do
        local slot = self.slots[i]
        slot:draw(hotbarX, hotbarY, hotbarScale, slotSize, padding, padding)
    end
end

function Inventory:leftClick()
    local clickedSlot = self:getHoveredSlot()
    if clickedSlot then
        clickedSlot:leftClick()
    elseif heldItem then
        --self:dropItem() -- Drop if clicked outside
    end
end

function Inventory:rightClick()
    local clickedSlot = self:getHoveredSlot()
    if clickedSlot then
        clickedSlot:rightClick()
    end
end

function Inventory:getHoveredGridSlot()
    if not self.isActive then return nil end
    local invScale = 1.5 * scale * self.scaleMultiplier
    local slotSize = 32 * invScale
    local paddingX = 10 * invScale
    local paddingY = 10 * invScale
    -- Compute x, y as in draw()... (insert your position logic here)
    -- For example:
    if self.type == "player" then
        x = screenW / 2 - invW / 2 - paddingX / 2
        for i, inv in pairs(inventories) do
            if inv.isActive and inv.type ~= "player" then
                x = x - invW * 2 / 7
                break
            end
        end
        y = screenH / 2 - invH / 2 + 15 * invScale
    else
        x = screenW / 2 - paddingX / 2 + invW / 2
        y = screenH / 2 - 3 * (slotSize + paddingY) + 15 * invScale
    end
    for i = self.gridStart, self.totalSlots do
        local slot = self.slots[i]
        if slot:isHovered(x + paddingX / 2, y + paddingY / 2, invScale, slotSize, paddingX, paddingY) then
            return slot
        end
    end
    return nil
end

--Försök kombinera get..Slot till en funktion
--annars använd hotbarSlot() också...

function Inventory:getHoveredHotbarSlot()
    local hotbarScale = 1.3 * scale * self.scaleMultiplier
    local slotSize = 32 * hotbarScale
    local padding = 16 * hotbarScale
    local hotbarW = (slotSize + padding) * self.hotbarSize - padding
    local hotbarX = screenW / 2 - hotbarW / 2 - padding / 2
    local hotbarY = screenH - (slotSize + padding) - 15 * hotbarScale -- Adjusted from hotbarH

    for i = 1, self.hotbarSize do
        local slot = self.slots[i]
        if slot:isHovered(hotbarX, hotbarY, hotbarScale, slotSize, padding, padding) then
            return slot
        end
    end
    return nil
end

---------------------------

function Inventory:addItem(item)
    if heldItem then
        -- Find empty slot or stack (loop through self.slots)
        for i = 1, self.totalSlots do
            local slot = self.slots[i]
            if slot.item == nil then -- Or check if stackable
                slot.item = heldItem
                heldItem = nil
                return
            end
        end
    else
        -- Similar loop to add directly from ground or loot
        for i = 1, self.totalSlots do
            local slot = self.slots[i]
            if slot.item == nil then
                slot.item = item
                return
            end
        end
    end
end

function Inventory:dropItem()
    -- If outside inventory and click -> drop on ground
    heldItem = nil
    -- Add logic for 'floating' items
end
