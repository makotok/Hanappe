module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})
    
    textbox1 = TextLabel {
        text = "hello world!",
        width = layer:getViewWidth(),
        height = 25,
        left = 0,
        top = 0,
        layer = layer
    }
    
    textbox2 = TextLabel({text = "こんにちわ世界!", width = layer:getViewWidth(), height = 25, layer = layer})
    textbox2:setPos(0, textbox1:getBottom())

    textbox3 = TextLabel()
    textbox3:setText("empty constructor.")
    textbox3:setLayer(layer)
    textbox3:setSize(layer:getViewWidth(), 25)
    textbox3:setPos(0, textbox2:getBottom())
    
    print(textbox3:getSize())
end

function onTouchDown(e)
    SceneManager:closeScene({animation = "slideToLeft"})
end

