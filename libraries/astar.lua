-- ======================================================================
-- Copyright (c) 2012 RapidFire Studio Limited
-- All Rights Reserved.
-- http://www.rapidfirestudio.com

-- Permission is hereby granted, free of charge, to any person obtaining
-- a copy of this software and associated documentation files (the
-- "Software"), to deal in the Software without restriction, including
-- without limitation the rights to use, copy, modify, merge, publish,
-- distribute, sublicense, and/or sell copies of the Software, and to
-- permit persons to whom the Software is furnished to do so, subject to
-- the following conditions:

-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
-- MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
-- IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
-- CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
-- TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
-- SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-- ======================================================================

-------------------------------------
---Modifications made by Aron
-------------------------------------

local walkableNodesGID = { --11, list of walkable tile GIDs
    1, 2, 3, 10, 11, 12, 14, 19, 20, 21, 23
}

nodeTable = {}                    -- O(n), all nodes, for looping through
nodeByXY = {}                     -- O(1), looking up specific coordinates, [y][x], shared references to nodeTable so only one needs to be updated to affect both.

local function gidIsWalkable(gid) --gid = global index (här, gid i STI är något annat, kanske Graphical Index för att veta vilken tile image den läser från, osäker...)
    if not gid or gid == 0 then return false end
    --if #walkableNodesGID == 0 then return true end --temp to enable all tiles
    for _, id in ipairs(walkableNodesGID) do
        if gid == id then return true end
    end
    return false
end


local function objectOnTile(tile, layer, tx, ty)
    if not tile then return false end

    local objects = map1.objects

    -- Get tile pixel position from STI
    local tileX, tileY = map1:getLayerTilePosition(layer, tile, tx, ty)
    local tileX1 = tileX
    local tileY1 = tileY
    local tileX2 = tileX + tile.width
    local tileY2 = tileY + tile.height

    for _, obj in pairs(objects) do
        local objX1 = obj.x
        local objY1 = obj.y
        local objX2 = obj.x + (obj.width or 0)
        local objY2 = obj.y + (obj.height or 0)

        -- Simple AABB collision detection
        if not (
                tileX2 <= objX1 or
                tileX1 >= objX2 or
                tileY2 <= objY1 or
                tileY1 >= objY2
            ) then
            return false
        end
    end

    return true
end

function updateWalkableNodes()
    local layer = map1.layers["Ground"]
    if not layer or layer.type ~= "tilelayer" then return end

    nodeTable = {} --empties the table
    nodeByXY = {}

    for y = 1, layer.height do
        nodeByXY[y] = nodeByXY[y] or {}
        for x = 1, layer.width do
            local tile = layer.data[y][x]      --or nil
            local gid = tile and tile.gid or 0 --STI will default to 0 if no tile sprite as well
            --GID is shared across tiles with the same tile sprite, not unique per tile instance.
            -- "tile and"-check due to the "or nil" on line above, otherwise it throws annoying error that doesnt really afect anything...

            local walkable = false
            if tile and tile.properties.walkable ~= nil then
                walkable = tile.properties.walkable --if tile already has walkable property
            else
                walkable = gidIsWalkable(gid)
                walkable = walkable and objectOnTile(tile, layer, x, y)
                --else check if walkable based on gid and if colliding with objects
            end

            local node = { --Create a node to use for pathfinding
                x = x,     --tile coordinates
                y = y,
                gid = gid,
                walkable = walkable
            }

            table.insert(nodeTable, node)
            nodeByXY[y][x] = node
        end
    end
end

function drawWalkableNodes()
    if not nodeTable then return end
    local tw, th = map1.tilewidth, map1.tileheight
    local layer = map1.layers["Ground"]
    local r = math.max(2, math.floor(math.min(tw, th) * 0.1))

    for _, n in ipairs(nodeTable) do
        if n.walkable then love.graphics.setColor(1, 1, 1, 1) else love.graphics.setColor(1, 0, 0, 1) end
        local cx = (n.x - 1) * tw + layer.x + tw / 2
        local cy = (n.y - 1) * th + layer.y + th / 2
        love.graphics.circle("fill", cx, cy, r)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

-------------------------------------

--module("astar", package.seeall) --dunno what this does, it was in the original

----------------------------------------------------------------
-- local variables
----------------------------------------------------------------

local INF = 1 / 0
local cachedPaths = nil

----------------------------------------------------------------
-- local functions
----------------------------------------------------------------

function dist(x1, y1, x2, y2)
    return math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2))
end

function dist_between(nodeA, nodeB)
    return dist(nodeA.x, nodeA.y, nodeB.x, nodeB.y)
end

function heuristic_cost_estimate(nodeA, nodeB)
    return dist(nodeA.x, nodeA.y, nodeB.x, nodeB.y)
end

function is_valid_node(node, neighbor)
    return true
end

function lowest_f_score(set, f_score)
    local lowest, bestNode = INF, nil
    for _, node in ipairs(set) do
        local score = f_score[node]
        if score < lowest then
            lowest, bestNode = score, node
        end
    end
    return bestNode
end

function neighbor_nodes(theNode, nodes)
    local neighbors = {}
    for _, node in ipairs(nodes) do
        if theNode ~= node and is_valid_node(theNode, node) then
            table.insert(neighbors, node)
        end
    end
    return neighbors
end

function not_in(set, theNode)
    for _, node in ipairs(set) do
        if node == theNode then return false end
    end
    return true
end

function remove_node(set, theNode)
    for i, node in ipairs(set) do
        if node == theNode then
            set[i] = set[#set]
            set[#set] = nil
            break
        end
    end
end

function unwind_path(flat_path, map, current_node)
    if map[current_node] then
        table.insert(flat_path, 1, map[current_node])
        return unwind_path(flat_path, map, map[current_node])
    else
        return flat_path
    end
end

----------------------------------------------------------------
-- pathfinding functions
----------------------------------------------------------------

function a_star(start, goal, nodes, valid_node_func)
    local closedset = {}
    local openset = { start }
    local came_from = {}

    if valid_node_func then is_valid_node = valid_node_func end

    local g_score, f_score = {}, {}
    g_score[start] = 0
    f_score[start] = g_score[start] + heuristic_cost_estimate(start, goal)

    while #openset > 0 do
        local current = lowest_f_score(openset, f_score)
        if current == goal then
            local path = unwind_path({}, came_from, goal)
            table.insert(path, goal)
            return path
        end

        remove_node(openset, current)
        table.insert(closedset, current)

        local neighbors = neighbor_nodes(current, nodes)
        for _, neighbor in ipairs(neighbors) do
            if not_in(closedset, neighbor) then
                local tentative_g_score = g_score[current] + dist_between(current, neighbor)

                if not_in(openset, neighbor) or tentative_g_score < g_score[neighbor] then
                    came_from[neighbor] = current
                    g_score[neighbor] = tentative_g_score
                    f_score[neighbor] = g_score[neighbor] + heuristic_cost_estimate(neighbor, goal)
                    if not_in(openset, neighbor) then
                        table.insert(openset, neighbor)
                    end
                end
            end
        end
    end
    return nil -- no valid path
end

----------------------------------------------------------------
-- exposed functions
----------------------------------------------------------------

function clear_cached_paths()
    cachedPaths = nil
end

function distance(x1, y1, x2, y2)
    return dist(x1, y1, x2, y2)
end

function path(start, goal, nodes, ignore_cache, valid_node_func)
    if not cachedPaths then cachedPaths = {} end
    if not cachedPaths[start] then
        cachedPaths[start] = {}
    elseif cachedPaths[start][goal] and not ignore_cache then
        return cachedPaths[start][goal]
    end

    local resPath = a_star(start, goal, nodes, valid_node_func)
    if not cachedPaths[start][goal] and not ignore_cache then
        cachedPaths[start][goal] = resPath
    end

    return resPath
end
