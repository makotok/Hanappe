module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)

    -- To make a difference by Filter.    
    -- label1(MOAITexture.GL_LINEAR)
    label1 = flower.Label("ABCD あいうえ")
    label1:setPiv(-label1:getWidth() / 2, -label1:getHeight() / 2, 0)
    label1:setPos(0, 0)
    label1:setLayer(layer)
    label1:setFont(flower.getFont(nil, nil, nil, nil, MOAITexture.GL_LINEAR))
    
    -- label2(MOAITexture.GL_NEAREST)
    label2 = flower.Label("ABCD あいうえ")
    label2:setPiv(-label2:getWidth() / 2, -label2:getHeight() / 2, 0)
    label2:setPos(0, label1:getBottom() + label1:getHeight())
    label2:setLayer(layer)
    label2:setFont(flower.getFont(nil, nil, nil, nil, MOAITexture.GL_NEAREST))

    -- label3(Config.FONT_FILTER)
    label3 = flower.Label("ABCD あいうえ")
    label3:setPiv(-label2:getWidth() / 2, -label2:getHeight() / 2, 0)
    label3:setPos(0, label2:getBottom() + label2:getHeight())
    label3:setLayer(layer)    
end

function onStart(e)
    label1:moveScl( 1, 1, 0, 3 )
    label2:moveScl( 1, 1, 0, 3 )
    label3:moveScl( 1, 1, 0, 3 )
end
