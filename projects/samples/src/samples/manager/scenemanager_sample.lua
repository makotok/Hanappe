module(..., package.seeall)

--------------------------------------------------------------------------------

function animatePopupScene(currentScene, nextScene, params)
    return Animation():parallel(
        Animation(currentScene, 1)
            :setPos(0, 0):setVisible(true):seekColor(0.5, 0.5, 0.5, 1),
        Animation(nextScene, 0.5)
            :setPos(0, 0):setVisible(true):setColor(0, 0, 0, 0):seekColor(1, 1, 1, 1)
    )
end

--------------------------------------------------------------------------------

function onCreate(params)
    layer = Layer {scene = scene}
    sprite1 = Sprite {texture = "cathead.png", layer = layer, left = 0, top = 0}
    sprite2 = Sprite {texture = "cathead.png", layer = layer, left = 0, top = sprite1:getBottom()}
end

function onStart()
end

function onTouchDown(e)
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    local prop = layer:getPartition():propForPoint(wx, wy, 0)
    
    if prop == sprite1 then
        SceneManager:openScene("samples/manager/scenemanager2_sample", {animation = animatePopupScene})
    elseif prop == sprite2 then
        SceneManager:closeScene({animation = "fade"})
    end
end

