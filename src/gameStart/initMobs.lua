function initMobs()
    testmob = Testmob:initTestmob(500, 500)

    testmob2 = Testmob2:initTestmob(400, 700)

    testmob3 = Testmob:initTestmob(800, 300)
    testmob3.pathfinder.targetEnt = Player

    testmob4 = Testmob2:initTestmob(400, 600, "aggressive")
    testmob4.pathfinder.targetEnt = Player

    testmob5 = Testmob2:initTestmob(800, 600, "aggressive")
    testmob5.pathfinder.targetEnt = Player

    testmob6 = Testmob2:initTestmob(400, 300, "skittish")
    testmob6.pathfinder.targetEnt = Player

    testmob7 = Testmob2:initTestmob(800, 400, "skittish")
    testmob7.pathfinder.targetEnt = Player

    --moreMobs()
end

function moreMobs()
    testmob8 = Testmob:initTestmob(400, 400)
    testmob8.pathfinder.targetEnt = Player

    testmob9 = Testmob:initTestmob(800, 500)
    testmob9.pathfinder.targetEnt = Player

    testmob10 = Testmob:initTestmob(400, 500)
    testmob10.pathfinder.targetEnt = Player

    testmob11 = Testmob:initTestmob(800, 700)
    testmob11.pathfinder.targetEnt = Player

    testmob12 = Testmob:initTestmob(400, 700)
    testmob12.pathfinder.targetEnt = Player

    testmob13 = Testmob:initTestmob(800, 800)
    testmob13.pathfinder.targetEnt = Player

    testmob14 = Testmob:initTestmob(400, 800)
    testmob14.pathfinder.targetEnt = Player

    testmob15 = Testmob:initTestmob(800, 900)
    testmob15.pathfinder.targetEnt = Player

    testmob16 = Testmob:initTestmob(400, 900)
    testmob16.pathfinder.targetEnt = Player

    testmob17 = Testmob:initTestmob(800, 1000)
    testmob17.pathfinder.targetEnt = Player

    testmob18 = Testmob:initTestmob(400, 1000)
    testmob18.pathfinder.targetEnt = Player

    testmob19 = Testmob:initTestmob(800, 1100)
    testmob19.pathfinder.targetEnt = Player

    testmob20 = Testmob:initTestmob(400, 1100)
    testmob20.pathfinder.targetEnt = Player
end
