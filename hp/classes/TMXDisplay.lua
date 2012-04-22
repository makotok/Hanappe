local Layer = require("hp/classes/Layer")
local MapSprite = require("hp/classes/MapSprite")
local SpriteSheet = require("hp/classes/SpriteSheet")
local TextureManager = require("hp/classes/TextureManager")

--------------------------------------------------------------------------------
-- タイルマップ形式のデータを保持するTMXMapクラスです.<br>
-- タイルマップエディタについては、以下を参照してください.<br>
-- http://www.mapeditor.org/
-- @class table
-- @name TMXMap
--------------------------------------------------------------------------------

local M = {}
local I = {}

--------------------------------------------------------------------------------
-- private functions
--------------------------------------------------------------------------------

local function loadTexture(tmxMap, tileset)
    if tileset then
        if not tileset.texture then
            local path = tmxMap.resourceDirectory .. tileset.image.source
            tileset.texture = TextureManager:request(path)
        end
    end
end

local function createDisplayTilesets(tmxMap, layer)
    local tilesets = {}
    for i, gid in ipairs(layer.tiles) do
        local tileset = tmxMap:findTilesetByGid(gid)
        if tileset then
            loadTexture(tmxMap, tileset)
            tilesets[tileset.name] = tileset
        end
    end
    return tilesets
end

local function createMapSprite(tmxMap, displayLayer, tileset)
    local mapWidth, mapHeight = tmxMap.width, tmxMap.height
    local mapLayer = displayLayer.mapLayer
    local texture = tileset.texture
    
    -- tile data
    local tw, th = texture:getSize()
    local spacing, margin = tileset.spacing, tileset.margin
    local tilewidth, tileheight = tileset.tilewidth, tileset.tileheight
    local tileCol = math.floor((tw + spacing) / tilewidth)
    local tileRow = math.floor((th + spacing) / tileheight)
    
    -- make sprite
    local mapSprite = MapSprite:new({texture = texture, layer = displayLayer})
    mapSprite:setMapSize(mapWidth, mapHeight, tilewidth, tileheight)
    mapSprite:setMapSheets(tilewidth, tileheight, tileCol, tileRow, spacing, margin)
    
    for y = 1, mapLayer.height do
        local rowData = {}
        for x = 1, mapLayer.width do
            local gid = mapLayer.tiles[(y - 1) * mapLayer.width + x]
            local tileNo = gid == 0 and gid or gid - tileset.firstgid + 1
            table.insert(rowData, tileNo)                        
        end
        mapSprite:setRow(y, unpack(rowData))
    end
    
    return mapSprite
end

local function createDisplayLayer(tmxMap, layer)
    local displayTilesets = createDisplayTilesets(tmxMap, layer)
    local displayLayer = Layer:new()
    displayLayer.mapLayer = layer
    
    for key, tileset in pairs(displayTilesets) do
        if tileset.texture then
            print("mapsprite")
            local mapSprite = createMapSprite(tmxMap, displayLayer, tileset)
        end
    end
    return displayLayer
end

local function createDisplayLayers(tmxMap)
    local displayLayers = {}
    for i, layer in ipairs(tmxMap.layers) do
        table.insert(displayLayers, createDisplayLayer(tmxMap, layer))
    end
    return displayLayers
end

local function createSpriteSheet(tmxMap, object)
    local gid = object.gid
    local tileset = tmxMap:findTilesetByGid(gid)
    loadTexture(tmxMap, tileset)

    local texture = tileset.texture
    local tw, th = texture:getSize()
    local spacing, margin = tileset.spacing, tileset.margin
    local tilewidth, tileheight = tileset.tilewidth, tileset.tileheight
    local tileCol = math.floor((tw + spacing) / tilewidth)
    local tileRow = math.floor((th + spacing) / tileheight)
    
    local spriteSheet = SpriteSheet:new({texture = texture})
    spriteSheet:setTiledSheets(tilewidth, tileheight, tileCol, tileRow)
    spriteSheet.mapObject = object
    spriteSheet:setLeft(object.x)
    spriteSheet:setTop(object.y)
    spriteSheet:setIndex(object.gid - tileset.firstgid + 1)
    
    for k, v in ipairs(object.properties) do
        print("sprite:", k)
    end
    if object.properties.sheetAnims then
        local sheetAnims = assert(loadstring("return {" .. object.properties.sheetAnims .. "}"))()
        print(sheetAnims)
        spriteSheet:setSheetAnims(sheetAnims)
    end
    if object.properties.playAnim then
        print(object.properties.playAnim)
        spriteSheet:playAnim(object.properties.playAnim)
    end
    
    return spriteSheet
end

local function createObjectLayers(tmxMap)
    local objectLayers = {}
    for i, objectgroup in ipairs(tmxMap.objectGroups) do
        local objectLayer = Layer:new()
        for j, object in ipairs(objectgroup.objects) do
            if object.gid and object.gid > 0 then
                local sprite = createSpriteSheet(tmxMap, object)
                objectLayer:insertProp(sprite)
            end
        end
        table.insert(objectLayers, objectLayer)
    end
    return objectLayers
end

local function createCamera()
    local camera = MOAICamera.new()
    camera:setOrtho(true)
    camera:setNearPlane(1)
    camera:setFarPlane(-1)
    return camera
end

--------------------------------------------------------------------------------
-- public functions
--------------------------------------------------------------------------------
function M:new(tmxMap)
    local obj = {}
    obj.tmxMap = tmxMap
    obj.camera = createCamera()
    obj.layers = createDisplayLayers(tmxMap)
    obj.objectLayers = createObjectLayers(tmxMap)
    
    for i, layer in ipairs(obj.layers) do
        layer:setCamera(obj.camera)
    end
    for i, layer in ipairs(obj.objectLayers) do
        layer:setCamera(obj.camera)
    end
    
    return setmetatable(obj, {__index = I})
end

function I:setScene(scene)
    
    for i, layer in ipairs(self.layers) do
        scene:addChild(layer)
    end
    for i, layer in ipairs(self.objectLayers) do
        scene:addChild(layer)
    end
end

return M