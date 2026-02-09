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

    inventory.slots[1] = Item:new(iron_axe)
    inventory.slots[17] = Item:new(iron_axe)

    tempInventory.slots[3] = Item:new(iron_axe)
    ------

    testmob = Testmob:initTestmob(400, 300)

    testmob.pathfinder.targetEnt = Player

    testmob2 = Testmob2:initTestmob(400, 700)

    testmob2.pathfinder.targetEnt = Player
    -------
    tempLoad()
end
