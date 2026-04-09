local Score = {}
local score = 0
local highscore = 0


function Score:load()
    if love.filesystem.getInfo("highscore.txt") then
        local contents, size = love.filesystem.read("highscore.txt")
        self.highscore = tonumber(contents) or 0
    else
        self.highscore = 0
    end
end

function Score:update(dt)

end

function Score:getHighscore()

end

function Score:setHighscore()

end
