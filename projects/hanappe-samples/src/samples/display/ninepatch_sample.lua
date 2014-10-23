module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}

    ninePatch = NinePatch {texture = "btn_up.png", layer = layer}
    ninePatch:setSize(100, 100)
    ninePatch:setLeft(0)
    ninePatch:setTop(0)
    
    ninePatch = NinePatch {texture = "panel.png", layer = layer}
    ninePatch:setSize(100, 80)
    ninePatch:setLeft(0)
    ninePatch:setTop(110)

    -- If the first argument string, and the texture parameters.
    ninePatch = NinePatch("panel.png")
    ninePatch:setSize(100, 80)
    ninePatch:setPos(0, 200)
    ninePatch:setLayer(layer)

end
