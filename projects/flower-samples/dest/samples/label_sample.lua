module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)
    
    -- label1
    label1 = flower.Label("Hello World!!", 200, 30)
    label1:setLayer(layer)
    
    -- label2
    label2 = flower.Label("Hello World!!", 200, 30, "arial-rounded.ttf")
    label2:setPos(0, label1:getBottom())
    label2:setLayer(layer)

    -- label3
    label3 = flower.Label("Hello World!!", 200, 40, "arial-rounded.ttf", 32)
    label3:setPos(0, label2:getBottom())
    label3:setLayer(layer)

    -- label4
    label4 = flower.Label("こんにちはモアイ！", 200, 30)
    label4:setPos(0, label3:getBottom())
    label4:setLayer(layer)
end
