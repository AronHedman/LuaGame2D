iron_axe = {
    id = "iron_axe",
    name = "Iron Axe",
    type = "axe",
    data = {
        durability = 100,
        damage = 2,
        attackSpeed = 0.5,
        toolEffectiveness = 10
    },
    sprite = ("assets/iron_axe.png"),
    components = {durabilityComponent, axeComponent, meleeComponent}
}