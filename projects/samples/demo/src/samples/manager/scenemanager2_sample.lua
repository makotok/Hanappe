module(..., package.seeall)

--------------------------------------------------------------------------------

function animatePopupScene(currentScene, nextScene, params)
    return Animation():parallel(
        Animation(currentScene, 0.5)
            :setPos(0, 0):setVisible(true):seekColor(0, 0, 0, 0),
        Animation(nextScene, 1)
            :setPos(0, 0):setVisible(true):seekColor(1, 1, 1, 1)
    )
end

--------------------------------------------------------------------------------

function onCreate(params)
    layer = Layer({scene = scene})
    sprite1 = Sprite({texture = "cathead.png", layer = layer, left = 32, top = 32})
end

function onStart()
end

function onTouchDown(e)
    SceneManager:closeScene({animation = animatePopupScene})
end

