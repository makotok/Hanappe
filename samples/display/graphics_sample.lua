module(..., package.seeall)

function onCreate(params)
    layer = Layer({scene = scene})
    
    -- Since one argument, the following method call is possible.
    g1 = Graphics {width = 50, height = 50, left = 10, top = 10, layer = layer}
    g1:setPenColor(1, 0, 0, 1):fillRect()
    g1:setPenColor(0, 1, 0, 1):drawRect()
    
    -- Supports the empty constructor.
    g2 = Graphics()
    g2:setSize(50, 50)
    g2:setLayer(layer)
    g2:setPos(g1:getRight() + 10, 10)
    g2:setPenColor(1, 0, 0, 1):drawLine(0, 0, 40, 40)
    
    -- Drawing operations will be cleared.
    g3 = Graphics({width = 50, height = 50, layer = layer})
    g3:setPenColor(1, 0, 0, 1):drawLine(0, 0, 40, 40):clear()
end

function onStart()
    g1:moveRot(0, 0, 45, 3)
    g2:moveRot(0, 0, 45, 3)    
end

function onTouchDown()
    SceneManager:closeScene({animation = "changeNow"})
end