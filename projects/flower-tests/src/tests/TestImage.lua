
-- test target
local Image = flower.Image

-- test case
local TestImage = {}
_G.TestImage = TestImage

function TestImage:setUp()
    self.prop = Image("cathead.png")
    self.prop:setPos(20, 30)
end

function TestImage:tearDown()

end

function TestImage:test1_size()
    local prop = self.prop
    local w, h, d
    
    w, h, d = prop:getSize()
    assertEquals(w, 128)
    assertEquals(prop:getWidth(), 128)
    assertEquals(h, 128)
    assertEquals(prop:getHeight(), 128)
    assertEquals(d, 0)

    prop:setSize(80, 90)
    w, h, d = prop:getSize()
    assertEquals(w, 80)
    assertEquals(prop:getWidth(), 80)
    assertEquals(h, 90)
    assertEquals(prop:getHeight(), 90)
    assertEquals(d, 0)
end

function TestImage:test2_texture()
    local prop = self.prop
    
    assertEquals(prop.texture, flower.getTexture("cathead.png"))
    
    prop:setTexture("numbers.png")
    assertEquals(prop.texture, flower.getTexture("numbers.png"))
    assertEquals(prop:getWidth(), 256)
    assertEquals(prop:getHeight(), 256)
end
