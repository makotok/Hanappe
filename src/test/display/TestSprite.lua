local Sprite = require("hp/display/Sprite")

local M = {}

------------------------------------------------------------
function M:setUp()
end

function M:test1()
    local obj1 = Sprite:new({texture = "assets/cathead.png"})
    local obj2 = Sprite:new({texture = "assets/cathead.png", width = 16, height = 16})
    local obj3 = Sprite:new({texture = "assets/cathead.png", left = 10, top = 10})
    
    assertEquals(obj1:getWidth(), 128)
    assertEquals(obj1:getHeight(), 128)
    assertEquals(obj2:getWidth(), 16)
    assertEquals(obj2:getHeight(), 16)
    assertEquals(obj3:getLeft(), 10)
    assertEquals(obj3:getTop(), 10)
end

------------------------------------------------------------

return M