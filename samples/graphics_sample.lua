module(..., package.seeall)

function onCreate()
    layer = Layer:new({scene = scene})
    
    g1 = Graphics:new({width = 50, height = 50, layer = layer})
    g1:setLeft(10)
    g1:setTop(10)
    g1:setPenColor(1, 0, 0, 1):fillRect()
    g1:setPenColor(0, 1, 0, 1):drawRect()
    
    g2 = Graphics:new({width = 50, height = 50, layer = layer})
    g2:setLeft(g1:getRight() + 10)
    g2:setTop(10)
    g2:setPenColor(1, 0, 0, 1):drawLine(0, 0, 40, 40)
        
    g3 = Graphics:new({width = 50, height = 50, layer = layer})
    g3:setPenColor(1, 0, 0, 1):drawLine(0, 0, 40, 40):clear()
end

function onStart()
    g1:moveRot(0, 0, 45, 3)
    g2:moveRot(0, 0, 45, 3)    
end