module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})

    rect = MeshFactory.newRect(10, 10, 50, 50, {"#003300", "#CCFF00", 90})
    layer:insertProp(rect)
end

function onStart()
    rect:moveColor (-1, -1, -1, -1, 2)
    rect:moveRot(0, 0, 180, 2)
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToLeft"})
end

