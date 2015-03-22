module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)
    
    -- label1
    label1 = flower.Label("Hello World!!")
    label1:setLayer(layer)
    
    -- label2
    label2 = flower.Label("Hello World!!", 200, 40, "arial-rounded.ttf")
    label2:setPos(0, label1:getBottom())
    label2:setLayer(layer)

    -- label3
    label3 = flower.Label("こんにちわこんにちわこんにちわこんにちわ", 150, 40, "VL-PGothic.ttf", 32)
    label3:setPos(0, label2:getBottom())
    label3:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    label3:fitHeight()
    label3:setLayer(layer)

    -- label4
    label4 = flower.Label("こんにちはモアイ！\n改行もOK\n自動でサイズ設定")
    label4:setPos(0, label3:getBottom())
    label4:setLayer(layer)
    
    -- bitmap font
    local bitmapFont = MOAIFont.new ()
    bitmapFont:loadFromBMFont ( 'CopperPlateGothic.fnt' )
    label5 = flower.Label("Hello BitmapFont!", 300, 100, bitmapFont, 32)
    label5:setShader(MOAIShaderMgr.getShader(MOAIShaderMgr.DECK2D_SHADER))
    label5:setPos(0, label4:getBottom())
    label5:setLayer(layer)
end
