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

function pixelToTile(x, y)
    return {
        x = math.floor(x / map1.tilewidth),
        y = math.floor(y / map1.tileheight)
    }
end

--function calculateVec(x1, y1, x2, y2)
--local angle = math.atan((y2 - y1) / (x2 - x1))
--end
