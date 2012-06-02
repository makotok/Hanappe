module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})
    
    textbox1 = TextLabel({text = "hello world!", width = Application.screenWidth, height = 25, layer = layer})
    textbox1:setLeft(0)
    textbox1:setTop(0)
    
    textbox2 = TextLabel({text = "こんにちわ世界!", width = Application.screenWidth, height = 25, layer = layer})
    textbox2:setLeft(0)
    textbox2:setTop(textbox1:getHeight() + textbox1:getLeft())
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToLeft"})
end

