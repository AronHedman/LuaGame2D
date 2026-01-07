function tempUpdate(dt)
    onesecprint()
end

local calls = 0
function onesecprint()
    calls = calls + 1
    if calls >= 60 then
        print(gamestate)

        --local tile = map1.getTileProperties("Ground", 1, 1)
        print(tile)

        -- print(collectgarbage("count"))
        calls = 0
    end
end
