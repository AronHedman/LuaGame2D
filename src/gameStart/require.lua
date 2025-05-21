function loadRequires()

    Object = require("libraries.classic")

    wf = require("libraries.windfield")
    world = wf.newWorld(0, 0, true)

    vector = require("libraries.hump-master.vector")

    anim8 = require("libraries.anim8")
    love.graphics.setDefaultFilter("nearest", "nearest")


    
    
    
    require("src.player")

    require("src.gameStart.setup")   

    require("src.input")
    require("src.functions")
    require("src.update")
    require("src.draw")


--Don't start until all mudules are loaded....
    setupGame()

end