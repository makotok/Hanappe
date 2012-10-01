module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}
    
    -- simple impl
    textbox1 = TextLabel {
        text = "hello world!",
        size = {layer:getViewWidth(), 30},
        pos = {0, 0},
        layer = layer,
    }
    
    -- It supports an empty constructor.
    textbox2 = TextLabel()
    textbox2:setText("empty constructor.")
    textbox2:setLayer(layer)
    textbox2:setSize(layer:getViewWidth(), 30)
    textbox2:setPos(0, textbox1:getBottom())
    textbox2:setFont("arial-rounded")
    
    -- If the first argument string, and the text parameters.
    textbox3 = TextLabel("テキスト")
    textbox3:setLayer(layer)
    textbox3:setSize(layer:getViewWidth(), 30)
    textbox3:setPos(0, textbox2:getBottom())
    textbox3:setRGBA(100, 100, 100, 1)
    textbox3:setFont("VL-PGothic")
end

function onTouchDown(e)
    SceneManager:closeScene({animation = "slideToLeft"})
end

