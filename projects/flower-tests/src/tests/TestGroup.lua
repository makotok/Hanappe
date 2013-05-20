
-- test target
local Group = flower.Group

-- test case
local TestGroup = {}
_G.TestGroup = TestGroup

function TestGroup:setUp()
    self.group = Group()
    self.group:setSize(100, 100)
    
    self.prop = flower.Image("cathead.png")
    self.prop.name = "cathead"
    
    self.group:addChild(self.prop)
end

function TestGroup:tearDown()

end

function TestGroup:test1_size()
    local group = self.group
    local w, h, d
    
    self.group:setSize(100, 120)
    w, h, d = group:getSize()
    assertEquals(w, 100)
    assertEquals(group:getWidth(), 100)
    assertEquals(h, 120)
    assertEquals(group:getHeight(), 120)
    assertEquals(d, 0)
end

function TestGroup:test2_children()
    local group = self.group
    
    assertEquals(#group.children, 1)
    assertEquals(group.children[1], self.prop)
    assertEquals(group:getChildByName("cathead"), self.prop)
    
    group:removeChild(self.prop)
    assertEquals(#group.children, 0)
    assertEquals(group.children[1], nil)
    assertEquals(group:getChildByName("cathead"), nil)

    group:addChild(self.prop)
    group:removeChildren()
    assertEquals(#group.children, 0)
    assertEquals(group.children[1], nil)
    assertEquals(group:getChildByName("cathead"), nil)
end

function TestGroup:test3_visible()
    local group = self.group
    local prop = self.prop
    
    assertEquals(group:getVisible(), true)
    assertEquals(prop:getVisible(), true)
    
    group:setVisible(false)
    assertEquals(group:getVisible(), false)
    assertEquals(prop:getVisible(), false)

    group:setVisible(true)
    assertEquals(group:getVisible(), true)
    assertEquals(prop:getVisible(), true)

    prop:setVisible(false)
    assertEquals(group:getVisible(), true)
    assertEquals(prop:getVisible(), false)
end

function TestGroup:test4_layer()
    local layer = flower.Layer()
    local group = self.group
    local prop = self.prop
    
    assertEquals(group.layer, nil)
    assertEquals(prop.layer, nil)
    
    group:setLayer(layer)
    assertEquals(group.layer, layer)
    assertEquals(prop.layer, layer)

    group:setLayer(nil)
    assertEquals(group.layer, nil)
    assertEquals(prop.layer, nil)
end

function TestGroup:test5_priority()
    local group = self.group
    local prop = self.prop
    
    assertEquals(group:getPriority(), nil)
    assertEquals(prop:getPriority(), nil)
    
    group:setPriority(10)
    assertEquals(group:getPriority(), 10)
    assertEquals(prop:getPriority(), 10)
end

