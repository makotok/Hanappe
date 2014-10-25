module(..., package.seeall)

function onCreate(params)
    layer = Layer {
        scene = scene,
        touchEnabled = true,
    }

    group = Group {
        name = "group",
        layer = layer,
    }
    
    sprite1 = Sprite {
        name = "sprite1",
        texture = "cathead.png",
        pos = {0, 0},
        parent = group,
    }

    sprite2 = Sprite {
        name = "sprite2",
        texture = "cathead.png",
        pos = {sprite1:getRight(), 0},
        parent = group,
    }

    group:addEventListener("touchDown", group_onTouchDown)
    group:addEventListener("touchUp", group_onTouchUp)
    group:addEventListener("touchMove", group_onTouchMove)
    group:addEventListener("touchCancel", group_onTouchCancel)

    sprite1:addEventListener("touchDown", sprite1_onTouchDown)
    sprite1:addEventListener("touchUp", sprite1_onTouchUp)
    sprite1:addEventListener("touchMove", sprite1_onTouchMove)
    sprite1:addEventListener("touchCancel", sprite1_onTouchCancel)
end

--------------------------------------------------------------------------------

function group_onTouchDown(e)
    printTouchEvent(e)
end

function group_onTouchUp(e)
    printTouchEvent(e)
end

function group_onTouchMove(e)
    printTouchEvent(e)
end

function group_onTouchCancel(e)
    printTouchEvent(e)
end

--------------------------------------------------------------------------------

function sprite1_onTouchDown(e)
    printTouchEvent(e)
end

function sprite1_onTouchUp(e)
    printTouchEvent(e)
end

function sprite1_onTouchMove(e)
    printTouchEvent(e)
end

function sprite1_onTouchCancel(e)
    printTouchEvent(e)
end

--------------------------------------------------------------------------------
function onTouchDown(e)
    printSceneTouchEvent(e)
end

function onTouchUp(e)
    printSceneTouchEvent(e)
end

function onTouchMove(e)
    printSceneTouchEvent(e)
end

function onTouchCancel(e)
    printSceneTouchEvent(e)
end

--------------------------------------------------------------------------------

function printTouchEvent(e)
    print("----------------------------------------")
    print("type     = ", e.type)
    print("name     = ", e.target.name)
    print("idx      = ", e.idx)
    print("tapCount = ", e.tapCount)
    print("x        = ", e.x)           -- MEMO:Position of Layer.
    print("y        = ", e.y)           -- MEMO:Position of Layer.
    print("moveX    = ", e.moveX)       -- MEMO:Position of Layer.
    print("moveY    = ", e.moveY)       -- MEMO:Position of Layer.
    print("screenX  = ", e.screenX)
    print("screenY  = ", e.screenY)
end

function printSceneTouchEvent(e)
    print("----------------------------------------")
    print("type     = ", e.type)
    print("name     = ", e.target.name)
    print("idx      = ", e.idx)
    print("tapCount = ", e.tapCount)
    print("x        = ", e.x)           -- MEMO:Position of Screen.
    print("y        = ", e.y)           -- MEMO:Position of Screen.
    print("moveX    = ", e.moveX)       -- MEMO:Position of Screen.
    print("moveY    = ", e.moveY)       -- MEMO:Position of Screen.
end