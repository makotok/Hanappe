module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})

    sprite1 = Sprite({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0})

    sprite2 = Sprite({texture = "samples/assets/cathead.png", layer = layer})
    sprite2:setPos(0, sprite1:getBottom())
    
    sprite3 = Sprite({texture = "samples/assets/cathead.png"})
    sprite3:setLeft(0)
    sprite3:setTop(sprite2:getBottom())
    layer:insertProp(sprite3)

    sprite4 = Sprite()
    sprite4:setTexture("samples/assets/cathead.png")
    sprite4:setSize(64, 64)
    sprite4:setPos(0, sprite3:getBottom())
    sprite4:setLayer(layer)

    printProperties(sprite1)
    printProperties(sprite2)
    printProperties(sprite3)
    printProperties(sprite4)

end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToBottom"})
end

function printProperties(obj)
    -- DisplayObject base properties
    print("----- DisplayObject properties -----")
    print("width", obj:getWidth())
    print("height", obj:getHeight())
    print("size", obj:getSize())
    print("left", obj:getLeft())
    print("right", obj:getRight())
    print("top", obj:getTop())
    print("bottom", obj:getBottom())
    print("color", obj:getColor())
    print("red", obj:getRed())
    print("green", obj:getGreen())
    print("blue", obj:getBlue())
    print("alpha", obj:getAlpha())

end
