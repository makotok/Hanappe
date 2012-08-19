local SpriteSheet = require("hp/display/SpriteSheet")

local M = {}

------------------------------------------------------------
function M:setUp()
end

function M:test1()
    local sprite = SpriteSheet:new({texture = "assets/actor.png"})

    sprite:setTiledSheets(32, 32)
    assertEquals(sprite.sheetSize, 3 * 4)
    
    sprite:setTiledSheets(32, 32, 3, 4)
    assertEquals(sprite.sheetSize, 3 * 4)
    
    sprite:setTiledSheets(32, 32, 3, 4, 0, 0)
    assertEquals(sprite.sheetSize, 3 * 4)
    
    sprite:setTiledSheets(32, 32, 3, 4, 1, 1)
    assertEquals(sprite.sheetSize, 3 * 4)

    sprite:setTiledSheets(32, 32, nil, nil, 1, 1)
    assertEquals(sprite.sheetSize, 2 * 3)
end

function M:test2()
    local sheetAnims = {
        {name = "walkDown", indexes = {2, 1, 2, 3, 2}, sec = 0.25},
        {name = "walkLeft", indexes = {5, 4, 5, 6, 5}, sec = 0.25},
        {name = "walkRight", indexes = {8, 7, 8, 9, 8}, sec = 0.25},
        {name = "walkUp", indexes = {11, 10, 11, 12, 11}, sec = 0.25},
    }
    
    local sprite = SpriteSheet:new({texture = "assets/actor.png"})
    sprite:setTiledSheets(32, 32)
    sprite:setSheetAnims(sheetAnims)
    
    assert(sprite:getSheetAnim("walkDown"))
    assert(sprite:getSheetAnim("NG") == nil)
    
end

------------------------------------------------------------

return M