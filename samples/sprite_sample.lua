module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})

    sprite1 = Sprite({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0})

    -- MEMO:class.__call = class.new
    sprite2 = Sprite:new({texture = "samples/assets/cathead.png", layer = layer})
    sprite2:setLeft(0)
    sprite2:setTop(sprite1:getBottom())
    
    sprite3 = Sprite({texture = "samples/assets/cathead.png"})
    sprite3:setLeft(0)
    sprite3:setTop(sprite2:getBottom())
    layer:insertProp(sprite3)
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToBottom"})
end
