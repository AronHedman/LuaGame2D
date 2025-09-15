colliders = {}

function createCollision()
    for _, obj in ipairs(map1.layers["Collision"].objects) do
        local body = p.newBody(world, obj.x + obj.width/2, obj.y + obj.height/2, "static")
        local shape = p.newRectangleShape(obj.width, obj.height)
        local fixture = p.newFixture(body, shape)
        table.insert(colliders, body)
    end
end

function getColliders()
    return colliders
end