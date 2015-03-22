module(..., package.seeall)

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

function onCreate(e)
    layer = flower.Layer()
    scene:addChild(layer)
    
    graphics1 = flower.Graphics(100, 100)
    graphics1:setPenColor(1, 0, 0, 1):fillRect(0, 0, 100, 100)
    graphics1:setPenColor(0, 1, 0, 1):drawRect(0, 0, 100, 100)
    graphics1:setPenColor(0, 0, 1, 1):fillRect(10, 20, 20, 30)
    graphics1:setLayer(layer)
    
end
