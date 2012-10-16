-- import
flower = require "flower"

-- open window
flower.openWindow("Flower samples", 320, 480)

-- layer
layer = flower.Layer()
MOAISim.pushRenderPass(layer)

-- image
image = flower.Image("cathead.png")
layer:insertProp(image)

-- sheet image
sheetImage1 = flower.SheetImage("actor.png", 3, 4)
sheetImage1:setIndex(1)
sheetImage1:setPos(0, image:getBottom())
layer:insertProp(sheetImage1)

-- map image
mapImage = flower.MapImage("numbers.png", 5, 3, 32, 32)
mapImage:setRows {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9},
}
layer:insertProp(mapImage)

-- textbox
textbox = flower.Label("こんにちは世界", 200, 50)
textbox:setPos(0, sheetImage1:getBottom())
layer:insertProp(textbox)

-- rect
rect = flower.Rect(50, 50)
rect:setPos(0, textbox:getBottom())
layer:insertProp(rect)
