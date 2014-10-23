module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}

    sprite1 = Sprite {texture = "cathead.png", layer = layer, left = 0, top = 0}
    sprite1:setSize(64, 64)
end

function onTouchDown(e)
    if sprite1:hitTestScreen(e.x, e.y) then
        if sprite1.action then
            sprite1.action:stop()
        end
        sprite1.touching = true
        sprite1.action = sprite1:seekScl(2, 2, 1, 0.5)
    end
end

function onTouchMove(e)
    if sprite1.touching then
        local scale = layer:getViewScale()
        local moveX, moveY = e.moveX / scale, e.moveY / scale
        sprite1:addLoc(moveX, moveY, 0)
    end
end

function onTouchUp(e)
    if sprite1.touching then
        sprite1.action:stop()
        sprite1:seekScl(1, 1, 1, 0.5)
        sprite1.touching = false
    end
end
