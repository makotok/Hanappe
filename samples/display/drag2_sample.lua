module(..., package.seeall)

local touchingProp

function onCreate(params)
    layer = Layer()
    layer:setScene(scene)

    sprite1 = Sprite({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0})
    sprite1:setSize(64, 64)

    sprite2 = Sprite({texture = "samples/assets/cathead.png", layer = layer, left = 64, top = 0})
    sprite2:setSize(64, 64)

    sprite3 = Sprite({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 64})
    sprite3:setSize(64, 64)
end

function onTouchDown(e)
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    touchingProp = layer:getPartition():propForPoint(wx, wy, 0)
    
    if touchingProp then
        if touchingProp.action then
            touchingProp.action:stop()
        end
        touchingProp.action = touchingProp:seekScl(2, 2, 1, 0.5)
    end
end

function onTouchMove(e)
    if touchingProp then
        local vscaleX, vscaleY = layer:getViewScale()
        local moveX, moveY = e.moveX / vscaleX, e.moveY / vscaleY
        touchingProp:addLoc(moveX, moveY, 0)
    end
end

function onTouchUp(e)
    if touchingProp then
        touchingProp.action:stop()
        touchingProp:seekScl(1, 1, 1, 0.5)
        touchingProp = nil
    end
end
