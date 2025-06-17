function getCoords(entity)
    -- Returns the coordinates of the entity
    return {
        x = entity.body:getX(),
        y = entity.body:getY()
    }
end

function getTileCoords(entity)
    -- Returns the tile coordinates of the entity
    return {
        x = math.floor(entity.body:getX() / map1.tilewidth),
        y = math.floor(entity.body:getY() / map1.tileheight)
    }
end