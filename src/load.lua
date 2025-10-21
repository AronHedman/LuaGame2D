function load()
    --load stuff
    require("src.gameStart.setup")
    setup()
    Player:load()

    inventories = {}
    
    inventory = Inventory:new{
        rows = 4,
        hasHotbar = true,
        type = "player"
    }
    inventories["player"] = inventory


    ----temp 
    tempInventory = Inventory:new{
        rows = 5,
        cols = 4,
        hasHotbar = false,
        type = "chest"
    }
    inventories["temp"] = tempInventory

    ------
    
    
    tempLoad()
end
