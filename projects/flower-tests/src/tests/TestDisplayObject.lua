
-- test target
local DisplayObject = flower.DisplayObject

-- test case
local TestDisplayObject = {}
_G.TestDisplayObject = TestDisplayObject

function TestDisplayObject:setUp()
    self.deck = MOAIGfxQuad2D.new()
    self.deck:setUVRect(0, 0, 1, 1)
    self.deck:setRect(0, 0, 100, 120)
    self.deck:setTexture("cathead.png")

    self.prop = DisplayObject()
    self.prop:setDeck(self.deck)
    self.prop:setPiv(50, 60)
    self.prop:setPos(20, 30)
end

function TestDisplayObject:tearDown()

end

function TestDisplayObject:test1_size()
    local w, h, d = self.prop:getSize()
    assertEquals(w, 100)
    assertEquals(self.prop:getWidth(), 100)
    assertEquals(h, 120)
    assertEquals(self.prop:getHeight(), 120)
    assertEquals(d, 0)

    self.prop:setBounds(0, 0, 0, 80, 90, 0)
    w, h, d = self.prop:getSize()
    assertEquals(w, 80)
    assertEquals(self.prop:getWidth(), 80)
    assertEquals(h, 90)
    assertEquals(self.prop:getHeight(), 90)
    assertEquals(d, 0)
end

function TestDisplayObject:test2_pos()
    local left, top = self.prop:getPos()
    local right, bottom = self.prop:getRight(), self.prop:getBottom()
    assertEquals(left, 20)
    assertEquals(top, 30)
    assertEquals(right, 20 + 100)
    assertEquals(bottom, 30 + 120)
    
    self.prop:setPos(30, 40)
    left, top = self.prop:getLeft(), self.prop:getTop()
    right, bottom = self.prop:getRight(), self.prop:getBottom()
    assertEquals(left, 30)
    assertEquals(top, 40)
    assertEquals(right, 30 + 100)
    assertEquals(bottom, 40 + 120)
end

function TestDisplayObject:test3_color()
    local r, g, b, a = self.prop:getColor()
    assertEquals(r, 1)
    assertEquals(g, 1)
    assertEquals(b, 1)
    assertEquals(a, 1)
    
    self.prop:setColor(1/256, 2/256, 3/256, 4/256)
    r, g, b, a = self.prop:getColor()
    assertEquals(r, 1/256)
    assertEquals(g, 2/256)
    assertEquals(b, 3/256)
    assertEquals(a, 4/256)
end

function TestDisplayObject:test4_visible()
    local visible = self.prop:getVisible()
    assertEquals(visible, true)
    
    self.prop:setVisible(false)
    visible = self.prop:getVisible()
    assertEquals(visible, false)
end

function TestDisplayObject:test5_layer()
    local layer = flower.Layer()
    local prop = self.prop
    
    assertEquals(prop.layer, nil)
    
    prop:setLayer(layer)
    assertEquals(prop.layer, layer)

    prop:setLayer(nil)
    assertEquals(prop.layer, nil)
end