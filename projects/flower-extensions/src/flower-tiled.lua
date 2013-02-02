----------------------------------------------------------------------------------------------------
-- It is a library to display Tiled Map Editor.
--
-- @author Makoto
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table
local Group = flower.Group
local MapImage = flower.MapImage
local MovieClip = flower.MovieClip
local ClassFactory = flower.ClassFactory

-- class
local TileMap
local Tileset
local TileLayer
local TileObject
local TileObjectGroup
local TileLayerRendererFactory
local TileObjectRendererFactory
local TMXReader
--local TMXWriter --TOOD:Quite cumbersome.

----------------------------------------------------------------------------------------------------
-- TMXMap
-- @class table
-- @name TMXMap
----------------------------------------------------------------------------------------------------
TileMap = class(Group)
M.TileMap = TileMap

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function TileMap:init()
    Group.init(self)
    self.version = 0
    self.orientation = ""
    self.mapWidth = 0
    self.mapHeight = 0
    self.tileWidth = 0
    self.tileHeight = 0
    self.layers = {}
    self.tilesets = {}
    self.properties = {}
    self.resourceDirectory = ""
    self.tilesetFactory = ClassFactory(Tileset)
    self.layerFactory = ClassFactory(TileLayer)
    self.objectGroupFactory = ClassFactory(TileObjectGroup)
end

function TileMap:loadMapfile(mapfile)
    self:loadMapData(dofile(mapfile))
end

function TileMap:loadMapData(data)
    self.mapData = data
    self.version = data.version
    self.luaversion = data.luaversion
    self.orientation = data.orientation
    self.mapWidth = data.width
    self.mapHeight = data.height
    self.tileWidth = data.tilewidth
    self.tileHeight = data.tileheight
    
    self:setSize(self.mapWidth * self.tileWidth, self.mapHeight * self.tileHeight)
    self:createTilesets(data.tilesets)
    self:createLayers(data.layers)
end

function TileMap:saveMapData()
    local data = self.data or {}
    seld.data = data
    data.version = self.version
    data.luaversion = self.luaversion
    data.orientation = self.orientation
    data.width = self.mapWidth
    data.height = self.mapHeight
end

function TileMap:setResourceDirectory(path)
    self.resourceDirectory = path
end

function TileMap:createTilesets(tilesetDatas)
    for i, tilesetData in ipairs(tilesetDatas) do
        local tileset = self.tilesetFactory:newInstance(self)
        tileset:loadData(tilesetData)
        self:addTileset(tileset)
    end
end

function TileMap:createLayers(layerDatas)
    for i, layerData in ipairs(layerDatas) do
        local layer = self:newLayerInstance(layerData)
        layer:loadData(layerData)
        self:addLayer(layer)
    end
end

function TileMap:newLayerInstance(layerData)
    if layerData.type == "tilelayer" then
        return self.layerFactory:newInstance(self)
    elseif layerData.type == "objectgroup" then
        return self.objectGroupFactory:newInstance(self)
    else
        error("Un supported type!!")
    end
end

--------------------------------------------------------------------------------
-- Add a layer.
-- @param layer layer.
--------------------------------------------------------------------------------
function TileMap:getLayers()
    return self.layers
end

--------------------------------------------------------------------------------
-- Add a layer.
-- @param layer layer.
--------------------------------------------------------------------------------
function TileMap:addLayer(layer)
    table.insert(self.layers, layer)
    self:addChild(layer)
end

--------------------------------------------------------------------------------
-- Remove a layer.
--------------------------------------------------------------------------------
function TileMap:removeLayer(layer)
    table.removeElement(self.layers, layer)
    self:removeChild(layer)
end

--------------------------------------------------------------------------------
-- Finds and returns the layer.
-- @param name Find name.
--------------------------------------------------------------------------------
function TileMap:findLayerByName(name)
    for i, v in ipairs(self.layers) do
        if v.name == name then
            return v
        end
    end
end

--------------------------------------------------------------------------------
-- Add the tile set.
-- @param tileset tileset.
--------------------------------------------------------------------------------
function TileMap:addTileset(tileset)
    table.insertElement(self.tilesets, tileset)
end

--------------------------------------------------------------------------------
-- Remove the tile set.
--------------------------------------------------------------------------------
function TileMap:removeTileset(tileset)
    return table.removeElement(self.tilesets, tileset)
end

--------------------------------------------------------------------------------
-- Remove the tile set.
--------------------------------------------------------------------------------
function TileMap:removeTilesetAt(index)
    return table.remove(self.tilesets, index)
end

--------------------------------------------------------------------------------
-- Finds and returns the tileset from the specified gid.
-- @param gid
-- @return TMXTileset
--------------------------------------------------------------------------------
function TileMap:findTilesetByGid(gid)
    for i = #self.tilesets, 1, -1 do
        local tileset = self.tilesets[i]
        if gid >= tileset.firstgid then
            return tileset
        end
    end 
end

--------------------------------------------------------------------------------
-- Returns the property with the specified key.
--------------------------------------------------------------------------------
function TileMap:getProperty(key)
    return self.properties[key]
end

TileLayer = class(Group)
M.TileLayer = TileLayer

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function TileLayer:init(tileMap)
    Group.init(self)
    self.tileMap = assert(tileMap)
    self.type = "tilelayer"
    self.name = ""
    self.mapWidth = 0
    self.mapHeight = 0
    self.opacity = 0
    self.properties = {}
    self.tiles = {}
    self.tilesetToRendererMap = {}
    self.rendererFactory = TileLayerRendererFactory()
end

function TileLayer:loadData(data)
    self.data = data
    self.name = data.name
    self.mapWidth = data.width
    self.mapHeight = data.height
    self.opacity = data.opacity
    self.tiles = data.data
    self.properties = data.properties
    
    self:setPos(data.x, data.y)
    self:setVisible(data.visible)
    
    self:removeRenderers()
    self:createRenderers()
end

function TileLayer:saveData()
    local data = self.data or {}
    self.data = data
    data.name = self.name
    data.name = self.name
    self.x = self:getLeft()
    self.y = self:getTop()
    data.width = self.mapWidth
    data.height = self.mapHeight
    data.opacity = self.opacity
    data.encoding = "Lua"
    data.data = self.tiles
    data.visible = self:getVisible()
    data.properties = data.properties
    return data
end

function TileLayer:removeRenderers()
    self:removeChildren()
end

--------------------------------------------------------------------------------
-- Display to generate a tile layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function TileLayer:createRenderers()
    local tilesets = self:getRenderableTilesets()
    
    for key, tileset in pairs(tilesets) do
        if tileset.texture then
            local renderer = self:createRenderer(tileset)
            self:addChild(renderer)
        end
    end
end

--------------------------------------------------------------------------------
-- To generate the object on which to draw the layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function TileLayer:createRenderer(tileset)
    return self.rendererFactory:newInstance(self, tileset)
end

--------------------------------------------------------------------------------
-- To generate a list of tile set that is used by a given layer.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function TileLayer:getRenderableTilesets()
    local tilesets = {}
    for i, gid in ipairs(self.tiles) do
        local tileset = self.tileMap:findTilesetByGid(gid)
        if tileset and not tilesets[tileset.name] then
            tileset:loadTexture()
            tilesets[tileset.name] = tileset
        end
    end
    return tilesets
end

--------------------------------------------------------------------------------
-- Returns the property.
-- @param key key.
-- @return value.
--------------------------------------------------------------------------------
function TileLayer:getProperty(key)
    return self.properties[key]
end

--------------------------------------------------------------------------------
-- Returns the gid of the specified position. <br>
-- If is out of range, return nil.
-- @param x potision of x.
-- @param y potision of y.
-- @return gid.
--------------------------------------------------------------------------------
function TileLayer:getGid(x, y)
    if not self:checkBounds(x, y) then
        return nil
    end
    return self.tiles[(y - 1) * self.mapWidth + x]
end

--------------------------------------------------------------------------------
-- Sets gid of the specified position. <br>
-- If you set the position is out of range to error.
-- @param x potision of x.
-- @param y potision of y.
-- @param gid global id.
--------------------------------------------------------------------------------
function TileLayer:setGid(x, y, gid)
    if not self:checkBounds(x, y) then
        error("index out of bounds!")
    end
    self.tiles[(y - 1) * self.mapWidth + x] = gid

    local tileset = self.tileMap:findTilesetByGid(gid)
    local tileNo = tileset:getTileIndexByGid(gid)
    local renderer = self:findRendererByTileset(tileset) or self:createRenderer(tileset)
    renderer:setTile(x, y, tileNo)
    self:addChild()
end

function TileLayer:findRendererByTileset(tileset)
    for i, renderer in ipairs(self.children) do
        if renderer.tileset == tileset then
            return rendrer
        end
    end
end

--------------------------------------------------------------------------------
-- Tests whether the position is within the range specified.
-- @param x potision of x.
-- @param y potision of y.
-- @return True if in the range.
--------------------------------------------------------------------------------
function TileLayer:checkBounds(x, y)
    if x < 1 or self.mapWidth < x then
        return false
    end
    if y < 1 or self.mapHeight < y then
        return false
    end
    return true
end

----------------------------------------------------------------------------------------------------
-- Tileset
-- @class table
-- @name Tileset
----------------------------------------------------------------------------------------------------
Tileset = class()
M.Tileset = Tileset

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function Tileset:init(tileMap)
    self.tileMap = assert(tileMap)
    self.name = ""
    self.firstgid = 0
    self.tilewidth = 0
    self.tileheight = 0
    self.spacing = 0
    self.margin = 0
    self.image = ""
    self.imageWidth = 0
    self.imageHeight = 0
    self.tiles = {}
    self.properties = {}
end

function Tileset:loadData(data)
    self.name = data.name
    self.firstgid = data.firstgid
    self.tileWidth = data.tilewidth
    self.tileHeight = data.tileheight
    self.spacing = data.spacing
    self.margin = data.margin
    self.image = data.image
    self.imageWidth = data.imagewidth
    self.imageHeight = data.imageheight
    self.properties = self.properties
end

--------------------------------------------------------------------------------
-- Load the texture of the tile set that is specified.
-- Because of inheritance has been left for, please do not call from the outside.
--------------------------------------------------------------------------------
function Tileset:loadTexture()
    if not self.texture then
        local path = self.tileMap.resourceDirectory .. self.image
        self.texture = flower.getTexture(path)
    end
    return self.texture
end

--------------------------------------------------------------------------------
-- Returns the tile-index of the specified gid <br>
-- @param gid gid.
-- @return tile-index.
--------------------------------------------------------------------------------
function Tileset:getTileIndexByGid(gid)
    return gid == 0 and 0 or gid - self.firstgid + 1
end


----------------------------------------------------------------------------------------------------
-- TileObject
-- @class table
-- @name TileObject
----------------------------------------------------------------------------------------------------
TileObject = class(Group)
M.TileObject = TileObject

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function TileObject:init(tileMap)
    Group.init(self)
    self.tileMap = assert(tileMap)
    self.name = ""
    self.type = ""
    self.shape = ""
    self.gid = nil
    self.properties = {}
    self.renderer = nil
    self.rendererFactory = nil
end

function TileObject:loadData(data)
    self.data = data
    self.name = data.name
    self.type = data.type
    self.shape = data.shape
    self.gid = data.gid
    self.properties = data.properties
    
    self:setPos(data.x, data.y)
    self:setSize(data.width, data.height)
    self:createRenderer()
end

function TileObject:saveData()
    local data = self.data or {}
    seld.data = data
    data.name = self.name
    data.type = self.type
    data.shape = self.shape
    data.x = self:getLeft()
    data.y = self:getTop()
    data.width = self.gid and 0 or self:getWidth()
    data.height = self.gid and 0 or self:getHeight()
    data.gid = self.gid
    data.visible = self:getVisible()
    data.properties = self.properties
    return data
end

function TileObject:createRenderer()
    if self.renderer then
        self:removeChild(self.renderer)
    end
    
    self.rendererFactory = self.rendererFactory or TileObjectRendererFactory()
    self.renderer = self.rendererFactory:newInstance(self)
    
    if self.renderer then
        self:addChild(self.renderer)
    end
end

----------------------------------------------------------------------------------------------------
-- TileObjectGroup
-- @class table
-- @name TileObjectGroup
----------------------------------------------------------------------------------------------------
TileObjectGroup = class(Group)
M.TileObjectGroup = TileObjectGroup

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function TileObjectGroup:init(tileMap)
    Group.init(self)
    self.type = "objectgroup"
    self.name = ""
    self.tileMap = assert(tileMap)
    self.objects = {}
    self.properties = {}
end

function TileObjectGroup:loadData(data)
    self.name = data.name
    self.opacity = data.opacity
    self.properties = data.properties
    self.data = data
    
    self:setVisible(data.visible)
    self:createObjects(data.objects)
end

function TileObjectGroup:saveData()
    local data = self.data
    data.type = self.type
    data.name = self.name
    data.visible = self:getVisible()
    data.opacity = self.opacity
    data.properties = self.properties
    data.objects = {}
    for i, object in ipairs(self.objects) do
        table.insertElement(data.objects, object:saveData())
    end
    return data
end

function TileObjectGroup:createObjects(objectDatas)
    for i, objectData in ipairs(objectDatas) do
        local object = TileObject(self.tileMap)
        object:loadData(objectData)
        self:addObject(object)
    end
end

--------------------------------------------------------------------------------
-- Add the object.
--------------------------------------------------------------------------------
function TileObjectGroup:addObject(object)
    table.insertElement(self.objects, object)
    self:addChild(object)
end

--------------------------------------------------------------------------------
-- Remove the object.
--------------------------------------------------------------------------------
function TileObjectGroup:removeObject(object)
    table.removeElement(self.objects, object)
    self:removeChild(object)
end

--------------------------------------------------------------------------------
-- Returns the property.
-- @param key key.
-- @return value.
--------------------------------------------------------------------------------
function TileObjectGroup:getProperty(key)
    return self.properties[key]
end

----------------------------------------------------------------------------------------------------
-- TileObjectRendererFactory
-- @class table
-- @name TileObjectRendererFactory
----------------------------------------------------------------------------------------------------
TileLayerRendererFactory = class()
M.TileLayerRendererFactory = TileLayerRendererFactory

function TileLayerRendererFactory:newInstance(layer, tileset)
    local texture = tileset.texture
    local tw, th = texture:getSize()

    local mapWidth, mapHeight = layer.mapWidth, layer.mapHeight
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    local mapImage = MapImage(texture, mapWidth, mapHeight, tileWidth, tileHeight, spacing, margin)
    mapImage.tileset = tileset
    
    local tileSize = mapImage.sheetSize
    local tiles = layer.tiles
    
    for y = 1, mapHeight do
        local rowData = {}
        for x = 1, mapWidth do
            local gid = layer:getGid(x, y)
            local tileNo = tileset:getTileIndexByGid(gid)
            tileNo = tileNo > tileSize and 0 or tileNo
            table.insertElement(rowData, tileNo)
        end
        mapImage:setRow(y, unpack(rowData))
    end
    
    return mapImage
end

----------------------------------------------------------------------------------------------------
-- TileObjectRendererFactory
-- @class table
-- @name TileObjectRendererFactory
----------------------------------------------------------------------------------------------------
TileObjectRendererFactory = class()
M.TileObjectRendererFactory = TileObjectRendererFactory

function TileObjectRendererFactory:newInstance(object)
    if not object.gid then
        return
    end
    
    local tileMap = object.tileMap
    local tileset = tileMap:findTilesetByGid(object.gid)
    local texture = tileset:loadTexture()
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin
    
    local movieClip = MovieClip(texture)
    movieClip:setTileSize(tileWidth, tileHeight, spacing, margin)
    movieClip:setIndex(object.gid - tileset.firstgid + 1)
    movieClip:setPos(0, -movieClip:getHeight())
    return movieClip
end

return M
