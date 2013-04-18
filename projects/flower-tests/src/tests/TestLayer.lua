
-- import
local table = flower.table

-- target
local Layer = flower.Layer

-- test case
local TestLayer = {}
_G.TestLayer = TestLayer

function TestLayer:setUp()
    self.layer = Layer()
end

function TestLayer:tearDown()

end

function TestLayer:test1_touchEnabled()
    local layer = self.layer
    
    assertEquals(layer.touchEnabled, false)
    assertEquals(layer.touchHandler, nil)

    layer:setTouchEnabled(true)
    assertEquals(layer.touchEnabled, true)
    assertEquals(layer.touchHandler ~= nil, true)

    layer:setTouchEnabled(false)
    assertEquals(layer.touchEnabled, false)
    assertEquals(layer.touchHandler ~= nil, true)
end

function TestLayer:test2_scene()
    local scene = flower.Scene()
    local layer = self.layer
    
    assertEquals(layer.scene, nil)

    layer:setScene(scene)
    assertEquals(layer.scene, scene)
    assertEquals(table.indexOf(scene.children, layer), 1)

    layer:setScene(nil)
    assertEquals(layer.scene, nil)
    assertEquals(table.indexOf(scene.children, layer), 0)
end

