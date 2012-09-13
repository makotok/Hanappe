module(..., package.seeall)

--------------------------------------------------------------------------------
-- Create Scene
--------------------------------------------------------------------------------
function onCreate(params)
    mainLayer = Layer {
        scene = scene
    }
    
    helpLabel = TextLabel {
        text = "Hello help",
        pos = {10, 10},
        size = {mainLayer:getViewWidth() - 20, mainLayer:getViewHeight() - 20},
        layer = mainLayer,
    }
end

function onTouchDown(e)
    SceneManager:closeScene()
end