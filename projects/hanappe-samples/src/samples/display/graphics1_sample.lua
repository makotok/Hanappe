module(..., package.seeall)

function onCreate(params)
    layer = Layer {scene = scene}
    
    -- Rect
    g1 = Graphics {width = 50, height = 50, left = 10, top = 10, layer = layer}
    g1:setPenColor(1, 0, 0, 1):fillRect()
    g1:setPenColor(0, 1, 0, 1):drawRect()
    
    -- Line
    g2 = Graphics()
    g2:setSize(50, 50)
    g2:setLayer(layer)
    g2:setPos(g1:getRight() + 10, 10)
    g2:setPenColor(1, 0, 0, 1):drawLine(0, 0, 40, 40)
    
    -- Circle
    g3 = Graphics {width = 100, height = 50, left = 10, top = g2:getBottom() + 10, layer = layer}
    g3:setPenColor(1, 0, 0, 1):fillCircle()
    g3:setPenColor(0, 1, 0, 1):fillCircle(10, 10, 10, 5)
    g3:setPenColor(1, 1, 0, 1):drawCircle()
    g3:setPenColor(0, 1, 1, 1):drawCircle(20, 20, 10, 5)
    
    -- Ellipse
    g4 = Graphics {width = 100, height = 50, left = 10, top = g3:getBottom() + 10, layer = layer}
    g4:setPenColor(1, 0, 0, 1):fillEllipse()
    g4:setPenColor(0, 1, 0, 1):fillEllipse(10, 10, 10, 15, 5)
    g4:setPenColor(1, 1, 0, 1):drawEllipse()
    g4:setPenColor(0, 1, 1, 1):drawEllipse(20, 20, 10, 15, 5)
    
    -- Ray
    g5 = Graphics {width = 100, height = 50, left = 10, top = g4:getBottom() + 10, layer = layer}
    g5:setPenColor(1, 0, 0, 1):drawRay(0, 0, 1, 0):drawRay(0, 0, 0, 1):drawRay(0, 0, 1, 1)
    
    -- Clear
    g6 = Graphics {width = 50, height = 50, layer = layer}
    g6:setPenColor(1, 0, 0, 1):drawLine(0, 0, 40, 40):clear()
end

function onStart()
    g1:moveRot(0, 0, 45, 3)
    g2:moveRot(0, 0, 45, 3)    
end
