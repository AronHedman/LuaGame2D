function load()
    --load stuff
    require("src.gameStart.setup")
    setup()
    Player:load()

    inventories = {}

    inventory = Inventory:new {
        rows = 4,
        hasHotbar = true,
        type = "player"
    }
    inventories["player"] = inventory


    ----temp
    tempInventory = Inventory:new {
        rows = 5,
        cols = 4,
        hasHotbar = false,
        type = "chest"
    }
    inventories["temp"] = tempInventory
    ------

    testmob = Testmob:initTestmob(500, 500)

    testmob.pathfinder.targetEnt = Player

    --testmob12 = Testmob:initTestmob(800, 300)
    --testmob12.pathfinder.targetEnt = Player

    --testmob13 = Testmob:initTestmob(400, 600)
    --testmob13.pathfinder.targetEnt = Player

    --testmob14 = Testmob:initTestmob(800, 600)
    --testmob14.pathfinder.targetEnt = Player

    testmob2 = Testmob2:initTestmob(400, 700)

    testmob2.pathfinder.targetEnt = Player
    -------
    tempLoad()
end
