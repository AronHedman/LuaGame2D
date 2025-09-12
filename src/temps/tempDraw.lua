function tempDraw()
    for i, obj in ipairs(drawables) do
        g.circle("fill", obj.x, obj.y, 5)
    end
end