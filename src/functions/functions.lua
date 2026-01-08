function getCoords(entity)
    -- Returns the coordinates of the entity
    return entity.body:getX(), entity.body:getY()
end

function getTileCoords(entity)
    -- Returns the tile coordinates of the entity
    local x = math.floor(entity.body:getX() / map1.tilewidth) + 1
    local y = math.floor(entity.body:getY() / map1.tileheight) + 1

    return x, y
end

function pixelToTile(x, y)
    local x = math.floor(x / map1.tilewidth) + 1
    local y = math.floor(y / map1.tileheight) + 1

    return x, y
end

function tileToPixel(tx, ty)
    local x = (tx - 1) * map1.tilewidth + map1.tilewidth / 2
    local y = (ty - 1) * map1.tileheight + map1.tileheight / 2

    return x, y
end

function distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dist = math.sqrt(dx ^ 2 + dy ^ 2)
    return dist --pixels
end

function calculateVecComponent(x1, y1, x2, y2)
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx ^ 2 + dy ^ 2)
    if len == 0 then return 0, 0 end
    if len > 1 then
        return dx / len, dy / len
    else
        return dx, dy
    end
end
