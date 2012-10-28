module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onLoad(e)
    layer = flower.Layer()
    scene:addChild(layer)

    -- image1
    image1 = flower.Image("cathead.png")
    image1:setLayer(layer)
    
    -- image2
    image2 = flower.Image("cathead.png", 64, 64)
    image2:setPos(0, image1:getBottom())
    image2:setLayer(layer)
end

