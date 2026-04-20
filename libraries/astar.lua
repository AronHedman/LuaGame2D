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

local AStar = {}
AStar.__index = AStar

local INF = 1 / 0 -- infinity

-- Constructor
function AStar.new(map)
    local self = setmetatable({}, AStar)
    self.map = map            -- reference to STI map
    self.walkableNodesGID = { --11, list of walkable tile GIDs
        1, 2, 3, 10, 11, 12, 14, 19, 20, 21, 23
    }
    self.nodeTable = {}
    self.nodeByXY = {}

    self:updateNodes()

    return self
end

function AStar:gidIsWalkable(gid)
    if not gid or gid == 0 then return false end
    for _, id in ipairs(self.walkableNodesGID) do
        if gid == id then return true end
    end
    return false
end

function AStar:objectOnTile(tile, layer, tx, ty)
    if not tile then return false end
    local objects = self.map.objects or {}
    local tileX, tileY = self.map:getLayerTilePosition(layer, tile, tx, ty)
    local tileX1, tileY1 = tileX, tileY
    local tileX2, tileY2 = tileX + tile.width, tileY + tile.height

    for _, obj in pairs(objects) do
        local objX1 = obj.x
        local objY1 = obj.y
        local objX2 = obj.x + (obj.width or 0)
        local objY2 = obj.y + (obj.height or 0)

        if not (tileX2 <= objX1 or
                tileX1 >= objX2 or
                tileY2 <= objY1 or
                tileY1 >= objY2) then
            return false
        end
    end
    return true
end

function AStar:updateNodes()
    local layer = self.map.layers["Ground"]

    if not layer or layer.type ~= "tilelayer" then return end

    self.nodeTable = {}
    self.nodeByXY = {}

    for y = 1, layer.height do
        self.nodeByXY[y] = self.nodeByXY[y] or {}
        for x = 1, layer.width do
            local tile = layer.data[y][x]
            local gid = tile and tile.gid or 0
            local walkable = false
            if tile and tile.properties and tile.properties.walkable ~= nil then
                walkable = tile.properties.walkable
            else
                walkable = self:gidIsWalkable(gid) and self:objectOnTile(tile, layer, x, y)
            end

            local node = { x = x, y = y, gid = gid, walkable = walkable }
            table.insert(self.nodeTable, node)
            self.nodeByXY[y][x] = node
        end
    end
end

function AStar:drawWalkableNodes()
    if not self.nodeTable then return end
    local tw, th = self.map.tilewidth, self.map.tileheight
    local layer = self.map.layers["Ground"]
    local r = math.max(2, math.floor(math.min(tw, th) * 0.1))

    for _, n in ipairs(self.nodeTable) do
        if n.walkable then love.graphics.setColor(1, 1, 1, 1) else love.graphics.setColor(1, 0, 0, 1) end
        local cx = (n.x - 1) * tw + layer.x + tw / 2
        local cy = (n.y - 1) * th + layer.y + th / 2
        love.graphics.circle("fill", cx, cy, r)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function AStar:heuristic_cost_estimate(nodeA, nodeB)
    local dx = math.abs(nodeA.x - nodeB.x)
    local dy = math.abs(nodeA.y - nodeB.y)
    return 10 * (dx + dy) + (14 - 20) * math.min(dx, dy) --Manhattan geometry
end

-- Neighbor nodes (uses self.nodeByXY)
function AStar:neighbor_nodes(node)
    local neighbors = {}
    local x, y = node.x, node.y
    local function add(nx, ny, cost)
        local row = self.nodeByXY[ny]
        if not row then return end
        local n = row[nx]
        if n and n.walkable then
            table.insert(neighbors, { node = n, cost = cost })
        end
    end

    add(x + 1, y, 10) -- node X, y, movement cost
    add(x - 1, y, 10)
    add(x, y + 1, 10)
    add(x, y - 1, 10)


    -- diagonal checks to avoid cutting corners, checks if both adjacent sides are walkable and adjusts price
    -- cost 14, roughly sqrt(2)*10
    if self.nodeByXY[y] and self.nodeByXY[y][x + 1] and self.nodeByXY[y][x + 1].walkable
        and self.nodeByXY[y + 1] and self.nodeByXY[y + 1][x] and self.nodeByXY[y + 1][x].walkable then
        add(x + 1, y + 1, 14)
    end
    if self.nodeByXY[y] and self.nodeByXY[y][x - 1] and self.nodeByXY[y][x - 1].walkable
        and self.nodeByXY[y + 1] and self.nodeByXY[y + 1][x] and self.nodeByXY[y + 1][x].walkable then
        add(x - 1, y + 1, 14)
    end
    if self.nodeByXY[y] and self.nodeByXY[y][x + 1] and self.nodeByXY[y][x + 1].walkable
        and self.nodeByXY[y - 1] and self.nodeByXY[y - 1][x] and self.nodeByXY[y - 1][x].walkable then
        add(x + 1, y - 1, 14)
    end
    if self.nodeByXY[y] and self.nodeByXY[y][x - 1] and self.nodeByXY[y][x - 1].walkable
        and self.nodeByXY[y - 1] and self.nodeByXY[y - 1][x] and self.nodeByXY[y - 1][x].walkable then
        add(x - 1, y - 1, 14)
    end

    return neighbors
end

-------------------------------------------------------------------------------------

local function not_in(set, theNode)
    for _, v in ipairs(set) do if v == theNode then return false end end
    return true
end

local function remove_node(set, theNode)
    for i, n in ipairs(set) do
        if n == theNode then
            set[i] = set[#set]; set[#set] = nil; return
        end
    end
end

local function lowest_f_score(set, f_score)
    local lowest, best = INF, nil
    for _, node in ipairs(set) do
        local s = f_score[node] or INF
        if s < lowest then lowest, best = s, node end
    end
    return best
end

local function unwind_path(came_from, current)
    local path = {}
    while current and came_from[current] do
        table.insert(path, 1, came_from[current])
        current = came_from[current]
    end
    return path
end

-------------------------------------------------------------------------------------

function AStar:a_star(start, goal)
    if not start or not goal then return nil end

    local closedset = {}
    local openset = { start }
    local came_from = {}
    local g_score, f_score = {}, {}

    g_score[start] = 0
    f_score[start] = self:heuristic_cost_estimate(start, goal)

    while #openset > 0 do
        local current = lowest_f_score(openset, f_score)
        if current == goal then
            local path = unwind_path(came_from, goal)
            table.insert(path, goal)
            return path
        end

        remove_node(openset, current)
        table.insert(closedset, current)

        for _, step in ipairs(self:neighbor_nodes(current)) do
            local neighbor, cost = step.node, step.cost
            if not_in(closedset, neighbor) then
                local tentative_g = (g_score[current] or INF) +
                    cost -- g_score[current] is nil if current is not in openset, tentative_g is temprary g_cost storage variable
                if not_in(openset, neighbor) or tentative_g < (g_score[neighbor] or INF) then
                    came_from[neighbor] = current
                    g_score[neighbor] = tentative_g
                    f_score[neighbor] = g_score[neighbor] + self:heuristic_cost_estimate(neighbor, goal)
                    if not_in(openset, neighbor) then table.insert(openset, neighbor) end
                end
            end
        end
    end

    return nil
end

-- Exposed functions

function AStar:path(start, goal)
    local res = self:a_star(start, goal)
    return res
end

function AStar:coordToNodeByXY(x, y)
    local row = self.nodeByXY[y]
    if not row then return nil end
    local node = row[x]
    return node
end

function AStar:invalidate() -- call when map, tiles or objects change
    self:updateNodes()
end

return AStar
