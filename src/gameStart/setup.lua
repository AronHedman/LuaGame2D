function setup()

    g = love.graphics
    p = love.physics
    k = love.keyboard

    p.setMeter(64) --Set to one tile
    world = p.newWorld(0, 0, true) --No gravity no sleeping

    g.setDefaultFilter("nearest", "nearest")

    -----------------------------------------------

    Object = require("libraries.classic")  -- enables OOP (sort of)
    
    vector = require("libraries.hump-master.vector")

    anim8 = require("libraries.anim8")

    -----------------------------------------------------

    sti = require("libraries.sti")
    
    map1 = sti("assets/maps/testmapwithobjectsv2.lua") --Testmap

    -----------------------------------------------------

    camera = require("libraries.hump-master.camera")
    cam = camera()

    
    require("src.player")

    require("src.input")
    require("src.functions")
    require("src.update")

    require("src.debugger")

    require("src.draw")


end