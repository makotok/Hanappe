module(..., package.seeall)

function onCreate(params)
    layer = Layer:new({scene = scene})

    ninePatch = NinePatch:new({texture = "samples/assets/btn_up.png", layer = layer})
    ninePatch:setSize(100, 50)
    ninePatch:setLeft(0)
    ninePatch:setTop(0)
    
    sprite = Sprite:new({texture = "samples/assets/btn_up.png", layer = layer})
    sprite:setSize(100, 50)
    sprite:setLeft(0)
    sprite:setTop(51)

end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToBottom"})
end
