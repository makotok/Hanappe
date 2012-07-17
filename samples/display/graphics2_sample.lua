module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}
    
    -- Round rect
    g1 = Graphics {width = 100, height = 50, left = 10, top = 10, layer = layer}
    g1:setPenColor(1, 0, 0, 1):fillRoundRect(0, 0, 100, 50, 10, 10)
    g1:setPenColor(0, 1, 0, 1):drawRoundRect(0, 0, 100, 50, 10, 10)

    -- Round rect
    g2 = Graphics {width = 100, height = 50, left = 20, top = 20, layer = layer}
    g2:setPenColor(0.5, 0.5, 1.0, 0.5):fillRoundRect(0, 0, 100, 50, 25, 25)
    g2:setPenColor(0.5, 1.0, 0.5, 0.5):drawRoundRect(0, 0, 100, 50, 25, 25)

end

function onTouchDown()
    SceneManager:closeScene({animation = "fade"})
end