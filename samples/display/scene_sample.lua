module(..., package.seeall)

function onCreate(params)
    print("onCreate(params)")
    layer = Layer {scene = scene}
    sprite1 = Sprite {texture = "cathead.png", layer = layer, left = 0, top = 0}
end

function onStart()
    print("onStart()")
end

function onResume()
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
    --print("onEnterFrame()")
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
    SceneManager:closeScene({animation = "popOut"})
end

function onTouchMove(event)
    print("onTouchMove(event)")
end
