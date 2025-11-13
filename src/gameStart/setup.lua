function setup()
    g = love.graphics
    p = love.physics
    k = love.keyboard

    require("src.globals")

    p.setMeter(64)                 --Set to one tile
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

    -----------------------------------------------------
    white = { 1, 1, 1, 1 }
    black = { 0, 0, 0, 1 }
    mainGrey = { 0.5, 0.5, 0.45, 1 }
    brightGrey = { 0.7, 0.7, 0.65, 1 }
    transparentGrey = { 0.3, 0.3, 0.3, 0.6 }
    transparentGreyHighlight = { 0.7, 0.7, 0.7, 0.3 }
    thickLine = 5 * scale
    mediumLine = 3 * scale
    thinLine = 1.5 * scale

    pi = math.pi

    -------------------------------------------------------
    require("src.player")

    require("src.objects.trees")

    require("src.input")

    require("src.functions.functions")
    require("src.functions.raycast")

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

    Raycast = require("src.functions.raycast")
    Pathfinder = require("src.entities.pathfinder.pathfinder")

    Testmob = require("src.entities.mob.testmob")

    require("src.temps.tempFunctions") -- loads the serialization functions
    require("src.temps.tempLoad")
    require("src.temps.tempUpdate")
    require("src.temps.tempDraw")
end
