trees = {}

function createTree()
    local treeList = map1.layers["Trees"].objects
    for i, obj in ipairs(treeList) do
        local tree = {}
        tree.x = obj.x
        tree.y = obj.y
        tree.scale = 5
        tree.image = g.newImage("assets/Plant1.png")
        tree.sWidth, tree.sHeight = tree.image:getDimensions()

        tree.cWidth, tree.cHeight = 12, 10

        tree.body = p.newBody(world, tree.x, tree.y, "static")
        tree.shape = p.newRectangleShape(tree.cWidth*tree.scale, tree.cHeight*tree.scale)
        tree.fixture = p.newFixture(tree.body, tree.shape)

        function tree:draw()
            g.draw(self.image, self.x, self.y, nil, self.scale, self.scale, self.sWidth/2, self.sHeight*0.82)
        end
        table.insert(trees, tree)
    end
end

function getTrees()
    return trees
end
