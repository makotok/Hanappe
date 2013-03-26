module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)

    image1 = flower.NineImage("btn_default_normal_holo.9.png")
    image1:setLayer(layer)
    
    image2 = flower.NineImage("btn_default_normal_holo.9.png", 200, 100)
    image2:setPos(0, image1:getBottom() + 5)
    image2:setLayer(layer)

    image3 = flower.NineImage("btn_keyboard_key_fulltrans_normal_off.9.png", 100, 80)
    image3:setPos(0, image2:getBottom() + 5)
    image3:setLayer(layer)
    
    image4 = flower.NineImage("btn_keyboard_key_fulltrans_normal_off.9.png")
    image4:setImage("btn_default_normal_holo.9.png", 150, 100)
    image4:setPos(0, image3:getBottom() + 5)
    image4:setLayer(layer)

    printNineImageInfo(image1)
    printNineImageInfo(image2)
    printNineImageInfo(image3)
    printNineImageInfo(image4)
end

function printNineImageInfo(image)
    print("----------------------------------------")
    print("Size:", image:getSize())
    print("Bounds:", image:getBounds())
    print("Content:", image:getContentRect())
end