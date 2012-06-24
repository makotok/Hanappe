local Layer = require("hp/display/Layer")
local Application = require("hp/core/Application")

local M = {}

------------------------------------------------------------
function M:setUp()
end

function M:test1()
    local layer = Layer:new()
    local x, y, z = layer:getLoc()
    
    assertEquals(layer:getWidth(), Application.screenWidth)
    assertEquals(layer:getHeight(), Application.screenHeight)
    assertEquals(layer.screenWidth, Application.screenWidth)
    assertEquals(layer.screenHeight, Application.screenHeight)
    assertEquals(layer.viewWidth, Application.viewWidth)
    assertEquals(layer.viewHeight, Application.viewHeight)
    assertEquals(layer:getLeft(), 0)
    assertEquals(layer:getTop(), 0)
    assertEquals(x, 0)
    assertEquals(y, 0)
    assertEquals(z, 0)
end

function M:test2()
    local layer = Layer:new({width = 100, height = 101, viewWidth = 102, viewHeight = 103})
    layer:setLeft(1)
    layer:setTop(2)
    
    assertEquals(layer.screenWidth, 100)
    assertEquals(layer.screenHeight, 101)
    assertEquals(layer.viewWidth, 102)
    assertEquals(layer.viewHeight, 103)
    assertEquals(layer:getLeft(), 1)
    assertEquals(layer:getTop(), 2)
end

------------------------------------------------------------

return M