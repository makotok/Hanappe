module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}

    -- Can be set in the parameter of the argument.
    sprite1 = Sprite {texture = "cathead.png", layer = layer, left = 0, top = 0}
    
    -- Values ​​can be set later.
    sprite2 = Sprite {texture = "cathead.png", layer = layer}
    sprite2:setPos(0, sprite1:getBottom())
    
    -- Values ​​can be set later.
    sprite3 = Sprite {texture = "cathead.png"}
    sprite3:setLeft(0)
    sprite3:setTop(sprite2:getBottom())
    layer:insertProp(sprite3)

    -- It supports an empty constructor.
    sprite4 = Sprite()
    sprite4:setTexture("cathead.png")
    sprite4:setSize(64, 64)
    sprite4:setPos(0, sprite3:getBottom())
    sprite4:setLayer(layer)
    
    -- If the first argument string, and the texture parameters.
    sprite5 = Sprite("cathead.png")
    sprite5:setPos(sprite1:getRight() + 10, 0)
    sprite5:setLayer(layer)

    -- Resource look up.
    sprite6 = Sprite("cathead.png")
    sprite6:setPos(sprite1:getRight() + 10, sprite5:getBottom() + 10)
    sprite6:setLayer(layer)
end
