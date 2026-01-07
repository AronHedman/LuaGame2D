function tempUpdate(dt)
    onesecprint()
end

local calls = 0
function onesecprint()
    calls = calls + 1
    if calls >= 60 then
        print(gamestate)

        -- print(collectgarbage("count"))
        calls = 0
    end
end
