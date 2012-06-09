module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})

    rect = MeshFactory.newRect(10, 10, 50, 50, {"#003300", "#CCFF00", 90})
    rect:setLayer(layer)

    local verticesForM = {
        { x = 0, y = 200 },
        { x = 50, y = 200 },
        { x = 50, y = 125 },
        { x = 100, y = 175 },
        { x = 150, y = 125 },
        { x = 150, y = 200 },
        { x = 200, y = 200 },
        { x = 200, y = 0 },
        { x = 100, y = 100},
        { x = 0, y = 0 }
    }
    local poly =  MeshFactory.createPolygon( verticesForM, {"#990000", "#FFFF00", 45} )
    poly:setScl(0.5, 0.5, 1)
    poly:setPos(100, 0)
    poly:setLayer(layer)

end

function onStart()
    rect:moveColor (-1, -1, -1, -1, 2)
    rect:moveRot(0, 0, 180, 2)
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToLeft"})
end

