function loadRequires()

    g = love.graphics
    p = love.physics
    k = love.keyboard

    p.setMeter(64) --Set to one tile
    world = p.newWorld(0, 0, true) --No gravity no sleeping

    g.setDefaultFilter("nearest", "nearest")

    -----------------------------------------------

    Object = require("libraries.classic")
    
    vector = require("libraries.hump-master.vector")

    anim8 = require("libraries.anim8")
    
    require("src.player")

    require("src.input")
    require("src.functions")
    require("src.update")
    require("src.draw")


end