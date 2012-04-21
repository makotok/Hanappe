module(..., package.seeall)

function onCreate()
    layer = Layer:new({scene = scene})

    mapsprite = MapSprite:new({texture = "samples/assets/numbers.png", layer = layer, left = 0, top = 0})
    mapsprite:setMapSize(8, 8, 32, 32)
    mapsprite:setMapSheets(32, 32, 8, 8)
    mapsprite:setLeft(0)
    mapsprite:setTop(0)
    mapsprite:setRows({
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8},
        {1, 2, 3, 4, 5, 6, 7, 8}})
        
    print(mapsprite:getBounds())
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToRight"})
end

