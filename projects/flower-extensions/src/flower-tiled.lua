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
local SheetImage = flower.SheetImage
local MapImage = flower.MapImage
local MovieClip = flower.MovieClip
local ClassFactory = flower.ClassFactory

-- class
local TileMap
local Tileset
local TileLayer
local TileObject
local TileObjectGroup
local TileLayerRenderer
local IsometricLayerRenderer
local TileObjectRenderer
local TileLayerRendererFactory
local TileObjectRendererFactory
local TMXReader

----------------------------------------------------------------------------------------------------
-- Class that displays the map data created by Tiled Map Editor.
-- 
-- @class table
-- @name TileMap
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

--------------------------------------------------------------------------------
-- Load the map data from luefile.
-- @param luefile path.
--------------------------------------------------------------------------------
function TileMap:loadLueFile(luefile)
    self:loadMapData(dofile(luefile))
end

--------------------------------------------------------------------------------
-- Load the map data.
-- @param data mapdata.
--------------------------------------------------------------------------------
function TileMap:loadMapData(data)
    self.data = data
    self.version = data.version
    self.luaversion = data.luaversion
    self.orientation = data.orientation
    self.mapWidth = data.width
    self.mapHeight = data.height
    self.tileWidth = data.tilewidth
    self.tileHeight = data.tileheight
    self.properties = data.properties
    
    self:setSize(self.mapWidth * self.tileWidth, self.mapHeight * self.tileHeight)
    self:createTilesets(data.tilesets)
    self:createLayers(data.layers)
end

--------------------------------------------------------------------------------
-- Save the map data.
-- @return mapdata.
--------------------------------------------------------------------------------
function TileMap:saveMapData()
    local data = self.data or {}
    self.data = data
    data.version = self.version
    data.luaversion = self.luaversion
    data.orientation = self.orientation
    data.width = self.mapWidth
    data.height = self.mapHeight
    data.tilewidth = self.tileWidth
    data.tileheight = self.tileHeight
    data.properties = self.properties
    data.tilesets = {}
    data.layers = {}

    for i, tileset in ipairs(self.tilesets) do
        table.insertElement(data.tilesets, tileset:saveData())
    end
    for i, layer in ipairs(self.layers) do
        table.insertElement(data.layers, layer:saveData())
    end
    
    return data
end

--------------------------------------------------------------------------------
-- Update the order of the rendering.
-- If you are using a single layer,
-- you should update the drawing order in a timely manner.
-- @param priority Priority of start
--------------------------------------------------------------------------------
function TileMap:updateRenderOrder(priority)
    priority = priority or 1
    for i, child in ipairs(self.children) do
        if child.updateRenderOrder then
            priority = child:updateRenderOrder(priority) + 1
        else
            child:setPriority(priority)
            priority = priority + 1
        end
    end
end

--------------------------------------------------------------------------------
-- Set the directory to refer to the resource.
-- @param path resource directory
--------------------------------------------------------------------------------
function TileMap:setResourceDirectory(path)
    self.resourceDirectory = path
end

--------------------------------------------------------------------------------
-- Create a tilesets.
-- @param tilesetDatas tileset data's
--------------------------------------------------------------------------------
function TileMap:createTilesets(tilesetDatas)
    for i, tilesetData in ipairs(tilesetDatas) do
        local tileset = self.tilesetFactory:newInstance(self)
        tileset:loadData(tilesetData)
        self:addTileset(tileset)
    end
end

--------------------------------------------------------------------------------
-- Create a layers.
-- @param layerDatas layer data's
--------------------------------------------------------------------------------
function TileMap:createLayers(layerDatas)
    for i, layerData in ipairs(layerDatas) do
        local layer = self:createLayer(layerData)
        layer:loadData(layerData)
        self:addLayer(layer)
    end
end

--------------------------------------------------------------------------------
-- Create a layers.
-- @param layerDatas layer data's
--------------------------------------------------------------------------------
function TileMap:createLayer(layerData)
    if layerData.type == "tilelayer" then
        return self.layerFactory:newInstance(self)
    elseif layerData.type == "objectgroup" then
        return self.objectGroupFactory:newInstance(self)
    else
        error("Un supported type!!")
    end
end

--------------------------------------------------------------------------------
-- Return the layers.
-- You must not be edited on this table.
-- @return layers.
--------------------------------------------------------------------------------
function TileMap:getLayers()
    return self.layers
end

--------------------------------------------------------------------------------
-- Add the layer.
-- Also be added to the rendering list.
-- @param layer layer.
--------------------------------------------------------------------------------
function TileMap:addLayer(layer)
    table.insert(self.layers, layer)
    self:addChild(layer)
end

--------------------------------------------------------------------------------
-- Remove the layer.
-- @param layer layer
--------------------------------------------------------------------------------
function TileMap:removeLayer(layer)
    table.removeElement(self.layers, layer)
    self:removeChild(layer)
end

--------------------------------------------------------------------------------
-- Finds and returns the layer.
-- @param name The name of the layer
--------------------------------------------------------------------------------
function TileMap:findLayerByName(name)
    for i, v in ipairs(self.layers) do
        if v.name == name then
            return v
        end
    end
end

--------------------------------------------------------------------------------
-- Returns the tilesets.
-- @return tilesets
--------------------------------------------------------------------------------
function TileMap:getTilesets()
    return self.tilesets
end

--------------------------------------------------------------------------------
-- Add the tileset.
-- @param tileset tileset
--------------------------------------------------------------------------------
function TileMap:addTileset(tileset)
    table.insertElement(self.tilesets, tileset)
end

--------------------------------------------------------------------------------
-- Remove the tileset.
--------------------------------------------------------------------------------
function TileMap:removeTileset(tileset)
    return table.removeElement(self.tilesets, tileset)
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

--------------------------------------------------------------------------------
-- Returns the tile property with the specified gid.
--------------------------------------------------------------------------------
function TileMap:getTileProperty(gid)
    -- TODO
end

--------------------------------------------------------------------------------
-- TODO:Documents
--------------------------------------------------------------------------------
function TileMap:isOrthogonal()
    return self.orientation == "orthogonal"
end

--------------------------------------------------------------------------------
-- TODO:Documents
--------------------------------------------------------------------------------
function TileMap:isIsometric()
    return self.orientation == "isometric"
end

----------------------------------------------------------------------------------------------------
-- This class to display a tile layer.
-- Inherit from the Group class is the name of a class that layer.
-- 
-- @class table
-- @name TileLayer
----------------------------------------------------------------------------------------------------
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
    self.renderer = nil
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
    
    self:createRenderer()
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

function TileLayer:createRenderer()
    if not self.renderer then
        self.renderer = self.rendererFactory:newInstance(self)
        self:addChild(self.renderer)
    end
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
-- Returns the gid of the specified position.
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
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x.
-- @param y potision of y.
-- @param gid global id.
--------------------------------------------------------------------------------
function TileLayer:setGid(x, y, gid)
    if not self:checkBounds(x, y) then
        error("Index out of bounds!")
    end
    self.tiles[(y - 1) * self.mapWidth + x] = gid
    
    self:createRenderer()
    self.renderer:setGid(x, y, gid)
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
    self.tiles = data.tiles
    self.properties = data.properties
end

function Tileset:saveData()
    local data = self.data or {}
    self.data = data
    data.name = self.name
    data.firstgid = self.firstgid
    data.tilewidth = self.tileWidth
    data.tileheight = self.tileHeight
    data.spacing = self.spacing
    data.margin = self.margin
    data.image = self.image
    data.imagewidth = self.imageWidth
    data.imageheight = self.imageHeight
    data.tiles = self.tiles
    data.properties = self.properties
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

function TileObject:setMapPos(x, y)
    local tileMap = self.tileMap
    
    if tileMap:isOrthogonal() then
        self:setPos(x, y)
    elseif tileMap:isIsometric() then
        self:setIsometricPos(x, y)
    end
end

function TileObject:setIsometricPos(x, y)
    local posX = x - y
    local posY = x + y
    self:setPos(posX, posY)
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
-- TileLayerRenderer
-- @class table
-- @name TileObjectRendererFactory
----------------------------------------------------------------------------------------------------
TileLayerRenderer = class(Group)
M.TileLayerRenderer = TileLayerRenderer

--------------------------------------------------------------------------------
-- Constructor.
-- @param tileLayer Renderable tileLayer
--------------------------------------------------------------------------------
function TileLayerRenderer:init(tileLayer)
    Group.init(self)
    self.tileLayer = assert(tileLayer)
    self.tileMap = tileLayer.tileMap
    
    self:createRenderers()
end

--------------------------------------------------------------------------------
-- Create the tileset renderers.
--------------------------------------------------------------------------------
function TileLayerRenderer:createRenderers()
    local tilesets = self:getRenderableTilesets()
    
    for key, tileset in pairs(tilesets) do
        if tileset.texture then
            local renderer = self:createRenderer(tileset)
            self:addChild(renderer)
        end
    end
end

--------------------------------------------------------------------------------
-- Create the tileset renderer.
-- @param tileset tileset
--------------------------------------------------------------------------------
function TileLayerRenderer:createRenderer(tileset)
    local texture = tileset.texture
    local tw, th = texture:getSize()

    local tileLayer = self.tileLayer
    local mapWidth, mapHeight = tileLayer.mapWidth, tileLayer.mapHeight
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    local mapImage = MapImage(texture, mapWidth, mapHeight, tileWidth, tileHeight, spacing, margin)
    mapImage.tileset = tileset
    
    local tileSize = mapImage.sheetSize
    local tiles = tileLayer.tiles
    
    for y = 1, mapHeight do
        local rowData = {}
        for x = 1, mapWidth do
            local gid = tileLayer:getGid(x, y)
            local tileNo = tileset:getTileIndexByGid(gid)
            tileNo = tileNo > tileSize and 0 or tileNo
            table.insertElement(rowData, tileNo)
        end
        mapImage:setRow(y, unpack(rowData))
    end
    return mapImage
end

--------------------------------------------------------------------------------
-- Returns the renderable tilesets.
-- @return renderable tilesets
--------------------------------------------------------------------------------
function TileLayerRenderer:getRenderableTilesets()
    local tileLayer = self.tileLayer
    local tileMap = tileLayer.tileMap
    local tilesets = {}
    for i, gid in ipairs(tileLayer.tiles) do
        local tileset = tileMap:findTilesetByGid(gid)
        if tileset and not tilesets[tileset.name] then
            tileset:loadTexture()
            tilesets[tileset.name] = tileset
        end
    end
    return tilesets
end

--------------------------------------------------------------------------------
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x.
-- @param y potision of y.
-- @param gid global id.
--------------------------------------------------------------------------------
function TileLayerRenderer:setGid(x, y, gid)
    local tileset = self.tileMap:findTilesetByGid(gid)
    local tileNo = tileset:getTileIndexByGid(gid)
    local renderer = self:findRendererByTileset(tileset) or self:createRenderer(tileset)
    renderer:setTile(x, y, tileNo)
    self:addChild(renderer)
end

--------------------------------------------------------------------------------
-- Returns the renderer for the tileset.
-- @param tileset tileset
-- @return renderer
--------------------------------------------------------------------------------
function TileLayerRenderer:findRendererByTileset(tileset)
    for i, renderer in ipairs(self.children) do
        if renderer.tileset == tileset then
            return rendrer
        end
    end
end


----------------------------------------------------------------------------------------------------
-- IsometricLayerRenderer
-- @class table
-- @name TileObjectRendererFactory
----------------------------------------------------------------------------------------------------
IsometricLayerRenderer = class(Group)
M.IsometricLayerRenderer = IsometricLayerRenderer

--------------------------------------------------------------------------------
-- Constructor.
-- @param tileLayer Renderable tileLayer
--------------------------------------------------------------------------------
function IsometricLayerRenderer:init(tileLayer)
    Group.init(self)
    self.tileLayer = assert(tileLayer)
    self.tileMap = tileLayer.tileMap
    self.renderers = {}
    self.deckCache = {}
    
    self:createRenderers()
end

--------------------------------------------------------------------------------
-- Create the tileset renderers.
--------------------------------------------------------------------------------
function IsometricLayerRenderer:createRenderers()
    local tileMap = self.tileMap
    
    for y = 1, tileMap.mapHeight do
        for x = 1, tileMap.mapWidth do
            local gid = self.tileLayer:getGid(x, y)
            self:createRenderer(x, y, gid)
        end
    end
end

--------------------------------------------------------------------------------
-- Create the tileset renderer.
-- @param tileset tileset
--------------------------------------------------------------------------------
function IsometricLayerRenderer:createRenderer(x, y, gid)
    if gid == 0 then
        return
    end

    local tileMap = self.tileMap
    local tileset = tileMap:findTilesetByGid(gid)
    local tileNo = tileset:getTileIndexByGid(gid)
    local texture = tileset:loadTexture()

    local tileLayer = self.tileLayer
    local mapWidth, mapHeight = tileLayer.mapWidth, tileLayer.mapHeight
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    local image = SheetImage(texture)
    image:setIndex(tileNo)
    
    local deck = self.deckCache[tileset]
    if not deck then
        image:setTileSize(tileWidth, tileHeight, spacing, margin)
        deck = image.deck
        self.deckCache[tileset] = deck
    end
    image:setDeck(deck)
    
    posX = (x - 1) * (tileMap.tileWidth / 2) - (y - 1) * (tileMap.tileWidth / 2)
    posY = (x - 1) * (tileMap.tileHeight / 2) + (y - 1) * (tileMap.tileHeight / 2)
    image:setPos(posX, posY)
    
    self:addChild(image)
    self.renderers[(y - 1) * mapWidth + x] = image
end

--------------------------------------------------------------------------------
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x.
-- @param y potision of y.
-- @param gid global id.
--------------------------------------------------------------------------------
function IsometricLayerRenderer:setGid(x, y, gid)
    local renderer = self:getRenderer(x, y)
    if renderer then
        self:removeChild(renderer)
        self.renderers[(y - 1) * self.tileLayer.mapWidth + x] = nil
    end
    
    self:createRenderer(x, y, gid)
end

--------------------------------------------------------------------------------
-- Returns the renderer for the tileset.
-- @param tileset tileset
-- @return renderer
--------------------------------------------------------------------------------
function IsometricLayerRenderer:getRenderer(x, y)
    return self.renderers[(y - 1) * self.tileLayer.mapWidth + x]
end

----------------------------------------------------------------------------------------------------
-- TileLayerRendererFactory
-- @class table
-- @name TileLayerRendererFactory
----------------------------------------------------------------------------------------------------
TileLayerRendererFactory = class()
M.TileLayerRendererFactory = TileLayerRendererFactory

function TileLayerRendererFactory:newInstance(layer)
    local tileMap = layer.tileMap
    
    if tileMap:isOrthogonal() then
        return TileLayerRenderer(layer)
    elseif tileMap:isIsometric() then
        return IsometricLayerRenderer(layer)
    else
        error("Unsupported orientation!!")
    end
end

----------------------------------------------------------------------------------------------------
-- TileObjectRenderer
-- @class table
-- @name TileObjectRenderer
----------------------------------------------------------------------------------------------------
TileObjectRenderer = class(MovieClip)
M.TileObjectRenderer = TileObjectRenderer

function TileObjectRenderer:init(tileObject)
    local tileMap = tileObject.tileMap
    local tileset = tileMap:findTilesetByGid(tileObject.gid)
    local texture = tileset:loadTexture()
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    MovieClip.init(self, texture)
    
    self.tileMap = tileMap
    self.tileObject = tileObject
    self.tileset = tileset
    self.gid = tileObject.gid
    self:setTileSize(tileWidth, tileHeight, spacing, margin)
    self:setIndex(tileset:getTileIndexByGid(self.gid))
    self:setPos(0, -self:getHeight())
end

function TileObjectRenderer:setGid(gid)
    if self.gid == gid then
        return
    end

    local tileset = self.tileMap:findTilesetByGid(gid)
    if tileset ~= self.tileset then
        local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
        local spacing, margin = tileset.spacing, tileset.margin
        self.tileset = tileset
        self:setTexture(tileset:loadTexture())
        self:setTileSize(tileWidth, tileHeight, spacing, margin)
    end
    
    self.gid = gid
    self:setIndex(tileset:getTileIndexByGid(gid))
end

function TileObjectRenderer:getGid()
    return self.gid
end

----------------------------------------------------------------------------------------------------
-- TileObjectRendererFactory
-- @class table
-- @name TileObjectRendererFactory
----------------------------------------------------------------------------------------------------
TileObjectRendererFactory = class()
M.TileObjectRendererFactory = TileObjectRendererFactory

function TileObjectRendererFactory:newInstance(tileObject)
    if not tileObject.gid or tileObject.gid == 0 then
        return
    end
    
    return TileObjectRenderer(tileObject)
end

return M
