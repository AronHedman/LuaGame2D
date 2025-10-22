function tempUpdate(dt)
    onesecprint()
end

local calls = 0
function onesecprint()
    calls = calls + 1
    if calls >= 60 then
        print(gamestate)
        calls = 0
    end
end
