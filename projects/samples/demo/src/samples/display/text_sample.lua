module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}
    
    -- simple impl
    textbox1 = TextLabel {
        text = "hello world!",
        size = {layer:getViewWidth(), 25},
        pos = {0, 0},
        layer = layer,
    }
    
    -- It supports an empty constructor.
    textbox3 = TextLabel()
    textbox3:setText("empty constructor.")
    textbox3:setLayer(layer)
    textbox3:setSize(layer:getViewWidth(), 25)
    textbox3:setPos(0, textbox2:getBottom())
    
    -- If the first argument string, and the text parameters.
    textbox4 = TextLabel("テキスト")
    textbox4:setLayer(layer)
    textbox4:setSize(layer:getViewWidth(), 25)
    textbox4:setPos(0, textbox3:getBottom())
    textbox4:setRGBA(100, 100, 100, 1)
end

function onTouchDown(e)
    SceneManager:closeScene({animation = "slideToLeft"})
end

