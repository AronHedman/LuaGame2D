GameMenu = {} --Metatable for Inventory class

function GameMenu:new(options)
    local self = setmetatable({}, { __index = GameMenu })
end

function GameMenu:update()

end

local bx = g.getWidth() / 8
local by = g.getHeight() / 8
local bw = g.getWidth() / 4
local bh = g.getHeight() / 8

function GameMenu:draw()
    g.setColor(transparentGrey)
    g.rectangle("fill", 0, 0, g.getWidth(), g.getHeight())

    g.setColor(brightGrey)
    local title = g.newText(bigAssFont, "Menu")
    g.draw(title, g.getWidth() / 2, g.getHeight() / 2, 0, scale, scale, title:getWidth() / 2, bh * 2, 0, 0)

    g.setColor(transparentGrey)

    local mx, my = love.mouse.getPosition()
    hot = mx > bx * 3 and mx < bx * 3 + bw and my > by * 3 and my < by * 3 + bh
    if hot then
        g.setColor(transparentGreyHighlight)
    end
    g.rectangle("fill", bx * 3, by * 3, bw, bh)
    g.setColor(transparentGrey)

    hot2 = mx > bx * 3 and mx < bx * 3 + bw and my > by * 4.5 and my < by * 4.5 + bh
    if hot2 then
        g.setColor(transparentGreyHighlight)
    end
    g.rectangle("fill", bx * 3, by * 4.5, bw, bh)

    g.setColor(brightGrey)
    local startText = g.newText(font, "Start Game")
    g.draw(
        startText, g.getWidth() / 2, g.getHeight() / 2, 0, scale, scale, startText:getWidth() / 2,
        startText:getHeight() / 2 + bh / 2
    )

    local quitText = g.newText(font, "Exit to Menu")
    g.draw(
        quitText, g.getWidth() / 2, g.getHeight() / 2, 0, scale, scale, quitText:getWidth() / 2,
        quitText:getHeight() / 2 + bh / 2 - by * 1.5
    )
end

function GameMenu:click(mx, my)
    if hot then
        gamestate = 1
    end
    if hot2 then
        love.event.quit('restart')
    end
end

return GameMenu
