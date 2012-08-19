local Sprite = require("hp/display/Sprite")

local M = {}
------------------------------------------------------------
function M:setUp()
    
end

function M:test1()
    local obj = Sprite:new({texture = "assets/cathead.png"})
    
    obj:setLeft(1)
    assertEquals(obj:getLeft(), 1)
    
    obj:setTop(2)
    assertEquals(obj:getTop(), 2)

    obj:setRight(3)
    assertEquals(obj:getRight(), 3)

    obj:setBottom(4)
    assertEquals(obj:getBottom(), 4)

    assertEquals(obj:getWidth(), 128)
    assertEquals(obj:getHeight(), 128)
    
    obj:setColor(1, 1, 1, 1)
    assertEquals(obj:getRed(), 1)
    assertEquals(obj:getGreen(), 1)
    assertEquals(obj:getBlue(), 1)
    assertEquals(obj:getAlpha(), 1)
    
    --obj:setColor(0.1, 0.2, 0.3, 0.4)
    --assertEquals(obj:getRed(), 0.1)
    --assertEquals(obj:getGreen(), 0.2)
    --assertEquals(obj:getBlue(), 0.3)
    --assertEquals(obj:getAlpha(), 0.4)
end

------------------------------------------------------------

return M