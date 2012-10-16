module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}
    
    g1 = Graphics {width = 100, height = 50, left = 0, top = 0, layer = layer}
    g1:setPenColor(1, 0, 0, 1):fillRoundRect(0, 0, 100, 50, 10, 10)
    g1:setPenColor(0, 1, 0, 1):drawRoundRect(0, 0, 100, 50, 10, 10)

    g2 = Graphics {width = 100, height = 50, left = 10, top = 10, layer = layer}
    g2:setPenColor(0.5, 0.5, 1.0, 0.5):fillRoundRect(0, 0, 100, 50, 25, 25)
    g2:setPenWidth(3):setPenColor(0.5, 1.0, 0.5, 0.5):drawRoundRect(0, 0, 100, 50, 25, 25)

    g3 = Graphics {width = 100, height = 50, left = 0, top = 60, layer = layer}
    g3:setPenColor(0.5, 0.5, 1.0, 0.5):fillRoundRect(0, 0, 100, 50)
    g3:setPenColor(0.5, 1.0, 0.5, 0.5):drawRoundRect(0, 0, 100, 50)

    g4 = Graphics {width = 100, height = 50, left = 100, top = 60, layer = layer}
    g4:setPenColor(1.0, 0.5, 0.5, 1.0):fillRoundRect(0, 0, 100, 50)

    g5 = Graphics {width = 100, height = 50, left = 200, top = 60, layer = layer}
    g5:setPenColor(0.5, 1.0, 0.5, 1.0):drawRoundRect(0, 0, 100, 50)

    g6 = Graphics {width = 100, height = 50, left = 0, top = 110, layer = layer}
    g6:setPenWidth(2):setPenColor(0.5, 0.5, 1.0, 0.5):drawRoundRect(0, 0, 100, 50, 5, 5)
    g6:setPiv(0, 0, 0)
    g6:setPos(0, 110)
    
    g7 = Graphics {width = 100, height = 50, left = 100, top = 110, layer = layer}
    g7:setPenColor(0.5, 0.5, 1.0, 0.5):fillRoundRect(0, 0, 100, 50, 10, 10)

end

function onStart()
    g5:moveLoc(0, 200, 0, 5)
    g6:moveScl(4, 4, 0, 3)
    g7:moveLoc(100, 100, 0, 3)
end
