module(..., package.seeall)

local touchingProp

function onCreate(params)
    layer = Layer {
        scene = scene,
        touchEnabled = true,
    }
    
    for i = 1, 4 do
        local sprite = Sprite {texture = "cathead.png", layer = layer, pos = {(i - 1) * 64, 0}, size = {64, 64}}
        sprite:addEventListener("touchDown",     onSpriteTouchDown)
        sprite:addEventListener("touchUp",       onSpriteTouchUp)
        sprite:addEventListener("touchMove",     onSpriteTouchMove)
        sprite:addEventListener("touchCancel",   onSpriteTouchCancel)
    end
end

function onSpriteTouchDown(e)
    local prop = e.touchingProp
    if prop and not prop.touchDownFlag then
        if prop.action then
            prop.action:stop()
        end
        prop.touchDownFlag = true
        prop.action = prop:seekScl(2, 2, 1, 0.5)
    end
end

function onSpriteTouchUp(e)
    local prop = e.touchingProp
    if prop and prop.touchDownFlag then
        prop.touchDownFlag = false
        prop.action:stop()
        prop.action = prop:seekScl(1, 1, 1, 0.5)
    end
end

function onSpriteTouchMove(e)
    if e.touchingProp then
        e.touchingProp:addLoc(e.moveX, e.moveY, 0)
    end
end

function onSpriteTouchCancel(e)
    local prop = e.touchingProp
    if prop and prop.touchDownFlag then
        prop.touchDownFlag = false
        prop.action:stop()
        prop.action = prop:seekScl(1, 1, 1, 0.5)
    end
end

