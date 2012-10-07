module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}

    mapsprite = MapSprite {texture = "numbers.png", layer = layer, left = 0, top = 0}
    mapsprite:setMapSize(8, 8, 32, 32)
    mapsprite:setMapSheets(32, 32, 8, 8)
    mapsprite:setRows({
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8}})
end
