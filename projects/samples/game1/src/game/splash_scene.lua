module(..., package.seeall)

----------------------------------------------------------------
-- Event Handler
----------------------------------------------------------------
function onCreate(params)
    layer = Layer {scene = scene}
    
    -- title
    splashImage = Sprite {texture = "splash_moai.png", layer = layer, left = 0, top = 0}
    splashImage:setSize(layer:getViewWidth(), layer:getViewHeight())
end

function onStart()
    splash_anim = Animation():wait(3):play({onComplete = onSplashComplete})
end

function onSplashComplete()
    SceneManager:openNextScene("game/title_scene", {animation = "fade"})
end

function onResume()
end

function onPause()
end

function onStop()
end

function onDestroy()
end
