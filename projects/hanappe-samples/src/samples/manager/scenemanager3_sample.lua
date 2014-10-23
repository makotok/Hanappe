module(..., package.seeall)

--------------------------------------------------------------------------------

function onCreate(params)
    sceneLayer = Layer()
    sceneLayer:setScene(scene)
    sprite1 = Sprite {texture = "cathead.png", layer = sceneLayer, left = 32 * 2, top = 32 * 2}

    backgroundlayer = Layer()
    sprite2 = Sprite {texture = "cathead.png", layer = backgroundlayer, left = 32, top = 32}
    SceneManager:addBackgroundLayer(backgroundlayer)

    frontlayer = Layer()
    sprite3 = Sprite {texture = "cathead.png", layer = frontlayer, left = 32 * 3, top = 32 * 3}
    SceneManager:addFrontLayer(frontlayer)
end

function onTouchDown(e)
    SceneManager:removeBackgroundLayer(backgroundlayer)
    SceneManager:removeFrontLayer(frontlayer)
    SceneManager:closeScene({animation = "fade"})
end

