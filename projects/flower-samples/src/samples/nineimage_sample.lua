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

end
