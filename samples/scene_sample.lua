module(..., package.seeall)

function onCreate(params)
    layer = Layer:new({scene = scene})
    sprite1 = Sprite:new({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0})
end

function onStart(params)
    print("onStart()")
end

function onResume(params)
    print("onResume()")
end

function onPause()
    print("onPause()")
end

function onStop()
    print("onStop()")
end

function onDestroy()
    print("onDestroy()")
end

function onEnterFrame()
end

function onKeyDown(event)
    print("onKeyDown(event)")
end

function onKeyUp(event)
    print("onKeyUp(event)")
end

function onTouchDown(event)
    print("onTouchDown(event)")
end

function onTouchUp(event)
    print("onTouchUp(event)")
    SceneManager:closeScene({animation = "fade"})
end

function onTouchMove(event)
    print("onTouchMove(event)")
end
