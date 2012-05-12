local TMXMapLoader = require("hp/tmx/TMXMapLoader")

local M = {}

------------------------------------------------------------
function M:setUp()
end

function M:test1()
    local mapLoader = TMXMapLoader:new()
    local mapData = mapLoader:loadFile("assets/map_plane.tmx")
    self:commonAssertEquals(mapData)
end

function M:test2()
    local mapLoader = TMXMapLoader:new()
    local mapData = mapLoader:loadFile("assets/map_csv.tmx")
    self:commonAssertEquals(mapData)
end

function M:test3()
    local mapLoader = TMXMapLoader:new()
    local mapData = mapLoader:loadFile("assets/map_base64.tmx")
    self:commonAssertEquals(mapData)
end

function M:test4()
    local mapLoader = TMXMapLoader:new()
    local mapData = mapLoader:loadFile("assets/map_base64_gzip.tmx")
    self:commonAssertEquals(mapData)
end

function M:test5()
    local mapLoader = TMXMapLoader:new()
    local mapData = mapLoader:loadFile("assets/map_base64_zlib.tmx")
    self:commonAssertEquals(mapData)
end

function M:commonAssertEquals(mapData)
    assertEquals(mapData.version, 1)
    assertEquals(mapData.orientation, "orthogonal")
    assertEquals(mapData.width, 50)
    assertEquals(mapData.height, 50)
    assertEquals(mapData.tilewidth, 32)
    assertEquals(mapData.tileheight, 32)
    assertEquals(mapData.tileheight, 32)
    assertEquals(#mapData.layers, 4)
    assertEquals(#mapData.tilesets, 13)
    assertEquals(#mapData.objectGroups, 1)

    local layer = mapData.layers[1]
    assertEquals(layer.name, "Layer1")
    assertEquals(layer.width, mapData.width)
    assertEquals(layer.height, mapData.height)
    assertEquals(layer.visible, 1)
    assertEquals(#layer.tiles, mapData.width * mapData.height)
    
    local layer = mapData.layers[3]
    assertEquals(layer.name, "Collision")
    assertEquals(layer.visible, 0)
    
    local objectGroup = mapData.objectGroups[1]
    assertEquals(objectGroup.width, 50)
    assertEquals(objectGroup.height, 50)
    assertEquals(#objectGroup.objects, 10)
end

------------------------------------------------------------

return M