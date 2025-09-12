trees = {}

function createTree()
    local treeList = map1.layers["Trees"].objects
    for i, obj in ipairs(treeList) do
        local tree = {}
        tree.x = obj.x
        tree.y = obj.y
        tree.scale = 5
        tree.image = g.newImage("assets/Plant1.png")
        tree.width, tree.height = tree.image:getDimensions()
        tree.oy = tree.height*tree.scale

        function tree:draw()
            g.draw(self.image, self.x, self.y, nil, self.scale, self.scale, self.width/2, self.height*0.82)
        end
        table.insert(trees, tree)
    end
end

function getTreeDrawables()
    return trees
end