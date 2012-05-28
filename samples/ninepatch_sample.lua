module(..., package.seeall)

function onCreate(params)
    layer = Layer:new({scene = scene})

    -- TODO:moai sdk 1.0 r3 のバグ
    -- 垂直方向のストレッチが上手くいかない.
    -- MOAIStrechDeck2Dで、nativeHeightを参照すべき箇所が、nativeWidthを参照しているので、おかしくなる
    -- 次のバージョンでは修正されるでしょう
    -- MEMO:moai sdk 1.1 r1 で修正されました。
    ninePatch = NinePatch:new({texture = "samples/assets/btn_up.png", layer = layer})
    ninePatch:setSize(100, 100)
    ninePatch:setLeft(0)
    ninePatch:setTop(0)
    
    ninePatch = NinePatch:new({texture = "assets/themes/basic/skins/panel.png", layer = layer})
    ninePatch:setSize(100, 80)
    ninePatch:setLeft(0)
    ninePatch:setTop(110)
end

function onTouchDown()
    SceneManager:closeScene({animation = "slideToBottom"})
end
