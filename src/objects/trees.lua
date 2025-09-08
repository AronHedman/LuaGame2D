trees = {}

local scale = 5

function createTree()
    local treeList = map1.layers["Trees"].objects
    for i, obj in ipairs(treeList) do
        local tree = {}
        tree.x = obj.x
        tree.y = obj.y
        tree.image = g.newImage("assets/Plant1.png")
        tree.width, tree.height = tree.image:getDimensions()

        function tree:draw()
            g.draw(self.image, self.x, self.y - self.height*scale, nil, scale, scale)
        end
        table.insert(trees, tree)
    end
end

function getTreeDrawables()
    return trees
end