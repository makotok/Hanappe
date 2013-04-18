
-- test target
local SheetImage = flower.SheetImage

-- test case
local TestSheetImage = {}
_G.TestSheetImage = TestSheetImage

function TestSheetImage:setUp()
    self.prop = SheetImage("actor.png")
end

function TestSheetImage:tearDown()

end

function TestSheetImage:test1_texture()
    local prop = self.prop
    
    assertEquals(prop.texture, flower.getTexture("actor.png"))
    
    prop:setTexture("numbers.png")
    assertEquals(prop.texture, flower.getTexture("numbers.png"))
end

function TestSheetImage:test2_textureAtlas()
    local prop = self.prop
    
    prop:setTextureAtlas("texturepack1.lua", "texturepack1.png")
    prop:setIndexByName("cathead")
end

function TestSheetImage:test3_sheetSize()
end

function TestSheetImage:test4_tileSize()
end
