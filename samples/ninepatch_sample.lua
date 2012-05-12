module(..., package.seeall)

function onCreate(params)
    layer = Layer:new({scene = scene})

    -- TODO:mosi sdk 1.0 r3 のバグ
    -- 垂直方向のストレッチが上手くいかない.
    -- MOAISurfaceDeck2Dで、nativeHeightを参照すべき箇所が、nativeWidthを参照しているので、おかしくなる
    -- 次のバージョンでは修正されるでしょう
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
