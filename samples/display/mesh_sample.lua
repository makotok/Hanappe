module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})

    rect = MeshFactory.newRect(10, 10, 50, 50, {"#003300", "#CCFF00", 90})
    layer:insertProp(rect)

    color = MOAIColor.new ()
    color:setParent(scene)
    rect.shader:setAttrLink ( 2, color, MOAIColor.COLOR_TRAIT )

    print(rect:getSize())
    print(rect:getSize())
end

function onStart()
    color:moveColor ( -1, -1, -1, -1, 1.5 )
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToLeft"})
end

