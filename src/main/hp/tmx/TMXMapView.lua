local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Layer = require("hp/display/Layer")
local MapSprite = require("hp/display/MapSprite")
local SpriteSheet = require("hp/display/SpriteSheet")
local TextureManager = require("hp/manager/TextureManager")

--------------------------------------------------------------------------------
-- TMXMapを描画するViewクラスです.<br>
-- @class table
-- @name TMXMapView
--------------------------------------------------------------------------------

local M = class()

--------------------------------------------------------------------------------
-- コンストラクタです.
-- この段階では表示オブジェクトは生成しません.
-- loadMap関数を使用する事で、表示オブジェクトを生成します.
--------------------------------------------------------------------------------
function M:init(resourceDirectory)
    self.resourceDirectory = assert(resourceDirectory)
end

--------------------------------------------------------------------------------
-- マップデータを読み込んで、表示オブジェクトを生成します.
--------------------------------------------------------------------------------
function M:loadMap(tmxMap)
    self.tmxMap = tmxMap
    self.camera = self:createCamera()
    self.layers = self:createDisplayLayers()
    self.objectLayers = self:createDisplayObjectLayers()
    
    for i, layer in ipairs(self.layers) do
        layer:setCamera(self.camera)
    end
    for i, layer in ipairs(self.objectLayers) do
        layer:setCamera(self.camera)
    end
end

--------------------------------------------------------------------------------
-- 指定されたタイルセットのテクスチャをロードします.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:loadTexture(tileset)
    local tmxMap = self.tmxMap
    if tileset then
        if not tileset.texture then
            local path = self.resourceDirectory .. tileset.image.source
            tileset.texture = TextureManager:request(path)
        end
    end
end

--------------------------------------------------------------------------------
-- 2Dカメラを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createCamera()
    local camera = MOAICamera.new()
    camera:setOrtho(true)
    camera:setNearPlane(1)
    camera:setFarPlane(-1)
    return camera
end


--------------------------------------------------------------------------------
-- 全ての表示タイルレイヤーを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createDisplayLayers()
    local tmxMap = self.tmxMap
    local displayLayers = {}
    for i, layer in ipairs(tmxMap.layers) do
        table.insert(displayLayers, self:createDisplayLayer(layer))
    end
    return displayLayers
end

--------------------------------------------------------------------------------
-- 表示タイルレイヤーを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createDisplayLayer(layer)
    local tmxMap = self.tmxMap
    local displayTilesets = self:createDisplayTilesets(layer)
    local displayLayer = Layer:new()
    displayLayer.mapLayer = layer
    
    for key, tileset in pairs(displayTilesets) do
        if tileset.texture then
            local mapSprite = self:createDisplayLayerRenderer(displayLayer, tileset)
        end
    end
    return displayLayer
end

--------------------------------------------------------------------------------
-- 実際に描画するオブジェクトをを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createDisplayLayerRenderer(displayLayer, tileset)
    local tmxMap = self.tmxMap
    local mapWidth, mapHeight = tmxMap.width, tmxMap.height
    local mapLayer = displayLayer.mapLayer
    local texture = tileset.texture
    
    -- tile data
    local tw, th = texture:getSize()
    local spacing, margin = tileset.spacing, tileset.margin
    local tilewidth, tileheight = tileset.tilewidth, tileset.tileheight
    local tileCol = math.floor((tw + spacing) / tilewidth)
    local tileRow = math.floor((th + spacing) / tileheight)
    local tileSize = tileCol * tileRow
    
    -- make sprite
    local mapSprite = MapSprite:new({texture = texture, layer = displayLayer})
    mapSprite:setMapSize(mapWidth, mapHeight, tilewidth, tileheight)
    mapSprite:setMapSheets(tilewidth, tileheight, tileCol, tileRow, spacing, margin)
    
    for y = 1, mapLayer.height do
        local rowData = {}
        for x = 1, mapLayer.width do
            local gid = mapLayer.tiles[(y - 1) * mapLayer.width + x]
            local tileNo = gid == 0 and gid or gid - tileset.firstgid + 1
            tileNo = tileNo > tileSize and 0 or tileNo
            table.insert(rowData, tileNo)
        end
        mapSprite:setRow(y, unpack(rowData))
    end
    
    return mapSprite
end

--------------------------------------------------------------------------------
-- 指定されたレイヤーが使用するタイルセットのリストを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createDisplayTilesets(layer)
    local tmxMap = self.tmxMap
    local tilesets = {}
    for i, gid in ipairs(layer.tiles) do
        local tileset = tmxMap:findTilesetByGid(gid)
        if tileset then
            self:loadTexture(tileset)
            tilesets[tileset.name] = tileset
        end
    end
    return tilesets
end

--------------------------------------------------------------------------------
-- オブジェクトレイヤーを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createDisplayObjectLayers()
    local objectLayers = {}
    for i, objectGroup in ipairs(self.tmxMap.objectGroups) do
        local objectLayer = self:createDisplayObjectLayer(objectGroup)
        table.insert(objectLayers, objectLayer)
    end
    return objectLayers
end

--------------------------------------------------------------------------------
-- オブジェクトグループから表示オブジェクトレイヤーを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createDisplayObjectLayer(objectGroup)
    local objectLayer = Layer:new()
    objectLayer.objects = {}
    for j, object in ipairs(objectGroup.objects) do
        if object.gid and object.gid > 0 then
            local displayObject = self:createDisplayObject(object)
            objectLayer:insertProp(displayObject)
            table.insert(objectLayer.objects, displayObject)
        end
    end
    return objectLayer
end

--------------------------------------------------------------------------------
-- オブジェクトデータから表示オブジェクトを生成します.
-- 継承の為に残していますので、外部からコールしないでください.
--------------------------------------------------------------------------------
function M:createDisplayObject(object)
    local tmxMap = self.tmxMap
    local gid = object.gid
    local tileset = tmxMap:findTilesetByGid(gid)
    self:loadTexture(tileset)

    local texture = tileset.texture
    local tw, th = texture:getSize()
    local spacing, margin = tileset.spacing, tileset.margin
    local tilewidth, tileheight = tileset.tilewidth, tileset.tileheight
    local tileCol = math.floor((tw + spacing) / tilewidth)
    local tileRow = math.floor((th + spacing) / tileheight)
    
    local sprite = SpriteSheet:new({texture = texture})
    sprite:setTiledSheets(tilewidth, tileheight, tileCol, tileRow)
    sprite.mapObject = object
    sprite:setLeft(object.x)
    sprite:setTop(object.y - sprite:getHeight())
    sprite:setIndex(object.gid - tileset.firstgid + 1)
    
    if object.properties.sheetAnims then
        local sheetAnims = assert(loadstring("return {" .. object.properties.sheetAnims .. "}"))()
        sprite:setSheetAnims(sheetAnims)
    end
    if object.properties.playAnim then
        sprite:playAnim(object.properties.playAnim)
    end
    
    return sprite
end

--------------------------------------------------------------------------------
-- Sceneを設定します.
-- Sceneに各レイヤーを追加します.
--------------------------------------------------------------------------------
function M:setScene(scene)
    
    for i, layer in ipairs(self.layers) do
        scene:addChild(layer)
    end
    for i, layer in ipairs(self.objectLayers) do
        scene:addChild(layer)
    end
end

--------------------------------------------------------------------------------
-- 名前からオブジェクトを検索して、最初に見つかったオブジェクトを返します.
-- 見つからない場合はnilを返します.
--------------------------------------------------------------------------------
function M:findObjectByName(name)
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if object.mapObject.name == name then
                return object
            end
        end
    end
end

--------------------------------------------------------------------------------
-- 名前からオブジェクトを検索して、見つかったオブジェクトを全て返します.
--------------------------------------------------------------------------------
function M:findObjectsByName(name)
    local objects = {}
    for i, objectLayer in ipairs(self.objectLayers) do
        for j, object in ipairs(objectLayer.objects) do
            if object.mapObject.name == name then
                table.insert(objects, object)
            end
        end
    end
    return objects
end

--------------------------------------------------------------------------------
-- 名前からレイヤーを検索して、見つかったレイヤーを返します.
--------------------------------------------------------------------------------
function M:findLayerByName(name)
    for i, layer in ipairs(self.layers) do
        if layer.mapLayer.name == name then
            return layer
        end
    end
end

return M