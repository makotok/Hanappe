module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    print("Scene:onCreate")

    mainLayer = flower.Layer()
    mainLayer:setScene(scene)

    image = flower.Image("cathead.png")
    image:setLayer(mainLayer)
end

function onOpen(e)
    print("Scene:onOpen")
end

function onClose(e)
    print("Scene:onClose")
end

function onStart(e)
    print("Scene:onStart")
end

function onStop(e)
    print("Scene:onStop")
end

function item_onTouchDown(e)

end
