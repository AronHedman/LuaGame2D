function setup()

    g = love.graphics
    p = love.physics
    k = love.keyboard

    p.setMeter(64) --Set to one tile
    world = p.newWorld(0, 0, true) --No gravity no sleeping

    g.setDefaultFilter("nearest", "nearest")

    -----------------------------------------------
    
    vector = require("libraries.hump-master.vector")

    anim8 = require("libraries.anim8")

    -----------------------------------------------------

    sti = require("libraries.sti")

    map1 = sti("assets/maps/Testmap1.lua") --Testmap

    -----------------------------------------------------

    camera = require("libraries.hump-master.camera")
    cam = camera()

    -------------------------------------------------------
    require("src.player")

    require("src.objects.trees")
    

    require("src.input")
    require("src.functions")

    require("src.debugger")

    require("src.update")
    require("src.draw")

    require("src.colliders.colliders")
    createCollision() --/////////////////

    require("src.itemSystem.itemClass")
    require("src.itemSystem.components.components")
    require("src.itemSystem.items.tools")

    require("src.UI")

    require("src.inventory")

    require("src.temps.tempFunctions") -- loads the serialization functions
    require("src.temps.tempLoad")
    require("src.temps.tempUpdate")
    require("src.temps.tempDraw")


end