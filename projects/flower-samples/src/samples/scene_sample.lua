module(..., package.seeall)

--------------------------------------------------------------------------------
-- Classes
--------------------------------------------------------------------------------

CustomScene = flower.class(flower.Scene)

function CustomScene:createController(params)
    local controller = {}
    
    function controller.onCreate(e)
        local scene = e.target
        
        local layer = flower.Layer()
        layer:setScene(scene)
        layer:setTouchEnabled(true)
        
        local group = flower.Group(layer, 200, 30)
        group:setPos(scene:getWidth() / 2 - group:getWidth() / 2, scene:getHeight() / 2 - group:getHeight() / 2)
        
        local rect = flower.Rect(200, 30)
        rect:setColor(0, 0, 0.5, 1)
    
        local label = flower.Label("Custom Scene", 200, 30)
        label:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
        label:addEventListener("touchDown", controller.onTouchDown)
    
        group:addChild(rect)
        group:addChild(label)
    end
    
    function controller.onOpen(e)
        local data = e.data
        data.animation = "popIn"
    end
    
    function controller.onTouchDown(e)
        flower.openScene("ChildScene", {sceneFactory = flower.ClassFactory(ChildScene)})
    end
    
    return controller
end

ChildScene = flower.class(flower.Scene)

function ChildScene:createController(params)
    local controller = {}
    
    function controller.onCreate(e)
        local scene = e.target
        
        local layer = flower.Layer()
        layer:setScene(scene)
        layer:setTouchEnabled(true)
        
        local group = flower.Group(layer, 200, 30)
        group:setPos(scene:getWidth() / 2 - group:getWidth() / 2, scene:getHeight() / 2 - group:getHeight() / 2 - 50)
        
        local rect = flower.Rect(200, 30)
        rect:setColor(0, 0, 0.5, 1)
    
        local label = flower.Label("Close?", 200, 30)
        label:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
        label:addEventListener("touchDown", controller.onTouchDown)
    
        group:addChild(rect)
        group:addChild(label)
    end
    
    function controller.onOpen(e)
        local data = e.data
        data.animation = "popIn"
    end
    
    function controller.onTouchDown(e)
        flower.closeScene({animation = "popOut", backScene = "samples/scene_sample"})
        --flower.closeScene({animation = "popOut", backSceneCount = 2})
    end
    
    return controller
end
--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    print("Scene:onCreate")

    mainLayer = flower.Layer()
    mainLayer:setScene(scene)
    mainLayer:setTouchEnabled(true)

    image = flower.Image("cathead.png")
    image:setLayer(mainLayer)
    image:addEventListener("touchDown", image_onTouchDown)
end

function onOpen(e)
    print("Scene:onOpen")
end

function onClose(e)
    print("Scene:onClose")
end

function onStart(e)
    print("Scene:onStart")
end

function onStop(e)
    print("Scene:onStop")
end

function onUpdate(e)
    print("Scene:onUpdate")
end

function image_onTouchDown(e)
    flower.openScene("CustomScene", {sceneFactory = flower.ClassFactory(CustomScene)})
end
