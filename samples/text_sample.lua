module(..., package.seeall)

function onCreate()
    layer = Layer:new({scene = scene})
    
    textbox1 = TextLabel:new({text = "hello world!", width = Application.screenWidth, height = 25, layer = layer})
    textbox1:setLeft(0)
    textbox1:setTop(0)
    
    textbox2 = TextLabel:new({text = "こんにちわ世界!", width = Application.screenWidth, height = 25, layer = layer})
    textbox2:setLeft(0)
    textbox2:setTop(textbox1:getHeight() + textbox1:getLeft())
end
