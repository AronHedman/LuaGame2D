local Score = {}
local score = 0
local timer = 0


function Score:load()

end

function Score:update(dt)
    timer = timer + dt
    if timer > 1 then
        score = score + 1
        timer = timer - 1
    end
end

function Score:draw()
    local scoreString = "Score: " .. score

    g.print(scoreString, 10, 10)
end

return Score
