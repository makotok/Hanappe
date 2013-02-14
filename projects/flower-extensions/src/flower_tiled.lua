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

----------------------------------------------------------------------------------------------------
-- @type TileMap
-- 
-- Class that displays the map data created by Tiled Map Editor.
----------------------------------------------------------------------------------------------------
TileMap = class(Group)
M.TileMap = TileMap

-- Events
TileMap.EVENT_LOADED_DATA = "loadedData"
TileMap.EVENT_SAVED_DATA = "savedData"

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
    self.mapLayers = {}
    self.tilesets = {}
    self.properties = {}
    self.resourceDirectory = ""
    self.tilesetFactory = ClassFactory(Tileset)
    self.layerFactory = ClassFactory(TileLayer)
    self.layerRendererFactory = TileLayerRendererFactory()
    self.objectGroupFactory = ClassFactory(TileObjectGroup)
    self.objectFactory = ClassFactory(TileObject)
    self.objectRendererFactory = TileObjectRendererFactory()
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
    self:createMapLayers(data.layers)
    
    self:dispatchEvent(TileMap.EVENT_LOADED_DATA, data)
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
    for i, layer in ipairs(self.mapLayers) do
        table.insertElement(data.layers, layer:saveData())
    end

    self:dispatchEvent(TileMap.EVENT_SAVED_DATA, data)

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
-- Create a layers on the map from the given data's.
-- @param layerDatas layer data's
--------------------------------------------------------------------------------
function TileMap:createMapLayers(layerDatas)
    local mapLayers = {}
    for i, layerData in ipairs(layerDatas) do
        table.insertElement(mapLayers, self:createMapLayer(layerData))
    end
    return mapLayers
end

--------------------------------------------------------------------------------
-- Create a layer on the map from the given data.
-- @param layerDatas layer data
--------------------------------------------------------------------------------
function TileMap:createMapLayer(layerData)
    local mapLayer

    if layerData.type == "tilelayer" then
        mapLayer = self.layerFactory:newInstance(self)
    elseif layerData.type == "objectgroup" then
        mapLayer = self.objectGroupFactory:newInstance(self)
    else
        error("Un supported type!!")
    end

    mapLayer:loadData(layerData)
    self:addMapLayer(mapLayer)
    return mapLayer
end

--------------------------------------------------------------------------------
-- Returns the layers on the map.
-- You must not be edited on this table.
-- @return layers.
--------------------------------------------------------------------------------
function TileMap:getMapLayers()
    return self.mapLayers
end

--------------------------------------------------------------------------------
-- Add the layer.
-- Also be added to the rendering list.
-- @param layer layer.
--------------------------------------------------------------------------------
function TileMap:addMapLayer(layer)
    if self:addChild(layer) then
        table.insert(self.mapLayers, layer)
    end
end

--------------------------------------------------------------------------------
-- Remove the layer.
-- @param layer layer
--------------------------------------------------------------------------------
function TileMap:removeMapLayer(layer)
    table.removeElement(self.mapLayers, layer)
    self:removeChild(layer)
end

--------------------------------------------------------------------------------
-- Remove all the layers.
--------------------------------------------------------------------------------
function TileMap:removeMapLayers()
    local mapLayer = self.mapLayers[1]
    while mapLayer do
        self.removeMapLayer(mapLayer)
        mapLayer = self.mapLayers[1]
    end
end

--------------------------------------------------------------------------------
-- Finds and returns the layer.
-- @param name The name of the layer
--------------------------------------------------------------------------------
function TileMap:findMapLayerByName(name)
    for i, v in ipairs(self.mapLayers) do
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
-- @param tileset Tileset
--------------------------------------------------------------------------------
function TileMap:removeTileset(tileset)
    table.removeElement(self.tilesets, tileset)
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
-- You can also be dynamically added to create a TileLayer.
--
-- @class table
-- @name TileLayer
----------------------------------------------------------------------------------------------------
TileLayer = class(Group)
M.TileLayer = TileLayer

--------------------------------------------------------------------------------
-- The constructor.
-- @param tileMap TileMap
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
    self.rendererFactory = tileMap.layerRendererFactory
end

--------------------------------------------------------------------------------
-- Load the layer data.
-- @param data layer data
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Save the layer data.
-- @return layer data
--------------------------------------------------------------------------------
function TileLayer:saveData()
    local data = self.data or {}
    self.data = data
    data.name = self.name
    data.name = self.name
    data.x = self:getLeft()
    data.y = self:getTop()
    data.width = self.mapWidth
    data.height = self.mapHeight
    data.opacity = self.opacity
    data.encoding = "Lua"
    data.data = self.tiles
    data.visible = self:getVisible()
    data.properties = data.properties
    return data
end

--------------------------------------------------------------------------------
-- Create a renderer.
-- There is no need to call directly basically.
-- @return layer data
--------------------------------------------------------------------------------
function TileLayer:createRenderer()
    if not self.renderer then
        self.renderer = self.rendererFactory:newInstance(self)
        self:addChild(self.renderer)
        return self.renderer
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
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @return gid.
--------------------------------------------------------------------------------
function TileLayer:getGid(x, y)
    if not self:checkBounds(x, y) then
        return nil
    end
    return self.tiles[y * self.mapWidth + x + 1]
end

--------------------------------------------------------------------------------
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @param gid global id.
--------------------------------------------------------------------------------
function TileLayer:setGid(x, y, gid)
    if not self:checkBounds(x, y) then
        error("Index out of bounds!")
    end
    self.tiles[y * self.mapWidth + x + 1] = gid

    self:createRenderer()
    self.renderer:setGid(x, y, gid)
end

--------------------------------------------------------------------------------
-- Tests whether the position is within the range specified.
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @return True if in the range.
--------------------------------------------------------------------------------
function TileLayer:checkBounds(x, y)
    if x < 0 or self.mapWidth <= x then
        return false
    end
    if y < 0 or self.mapHeight <= y then
        return false
    end
    return true
end

----------------------------------------------------------------------------------------------------
-- @type Tileset
-- 
-- This class holds information about the tile set.
----------------------------------------------------------------------------------------------------
Tileset = class()
M.Tileset = Tileset

--------------------------------------------------------------------------------
-- The constructor.
-- @param tileMap TileMap
--------------------------------------------------------------------------------
function Tileset:init(tileMap)
    self.tileMap = assert(tileMap)
    self.name = ""
    self.firstgid = 0
    self.tileWidth = 0
    self.tileHeight = 0
    self.tileOffsetX = 0
    self.tileOffsetY = 0
    self.spacing = 0
    self.margin = 0
    self.image = ""
    self.imageWidth = 0
    self.imageHeight = 0
    self.tiles = {}
    self.properties = {}
end

--------------------------------------------------------------------------------
-- Load the tileset data.
-- @param data tileset data
--------------------------------------------------------------------------------
function Tileset:loadData(data)
    self.name = data.name
    self.firstgid = data.firstgid
    self.tileWidth = data.tilewidth
    self.tileHeight = data.tileheight
    self.tileOffsetX = data.tileoffsetx or 0 -- TODO: Dummy. Tile Map Editor Bug?
    self.tileOffsetY = data.tileoffsety or 0 -- TODO: Dummy. Tile Map Editor Bug?
    self.spacing = data.spacing
    self.margin = data.margin
    self.image = data.image
    self.imageWidth = data.imagewidth
    self.imageHeight = data.imageheight
    self.tiles = data.tiles
    self.properties = data.properties
end

--------------------------------------------------------------------------------
-- Save the tileset data.
-- @return tileset data
--------------------------------------------------------------------------------
function Tileset:saveData()
    local data = self.data or {}
    self.data = data
    data.name = self.name
    data.firstgid = self.firstgid
    data.tilewidth = self.tileWidth
    data.tileheight = self.tileHeight
    data.tileoffsetx = self.tileOffsetX
    data.tileoffsety = self.tileOffsetY
    data.spacing = self.spacing
    data.margin = self.margin
    data.image = self.image
    data.imagewidth = self.imageWidth
    data.imageheight = self.imageHeight
    data.tiles = self.tiles
    data.properties = self.properties
    return data
end

--------------------------------------------------------------------------------
-- Load the texture of the tile set that is specified.
-- @return texture
--------------------------------------------------------------------------------
function Tileset:loadTexture()
    if not self.texture then
        local path = self.tileMap.resourceDirectory .. self.image
        self.texture = flower.getTexture(path)
    end
    return self.texture
end

--------------------------------------------------------------------------------
-- Returns the tile index of the specified gid.
-- @param gid gid.
-- @return tile index.
--------------------------------------------------------------------------------
function Tileset:getTileIndexByGid(gid)
    return gid == 0 and 0 or gid - self.firstgid + 1
end


----------------------------------------------------------------------------------------------------
-- @type TileObject
-- 
-- This class holds information TileObject.
-- If you can see the tile, creating and showing a renderer.
----------------------------------------------------------------------------------------------------
TileObject = class(Group)
M.TileObject = TileObject

--------------------------------------------------------------------------------
-- The constructor.
-- @param tileMap TileMap
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
    self.rendererFactory = tileMap.objectRendererFactory
end

--------------------------------------------------------------------------------
-- Load the tile object data.
-- @param data tile object data
--------------------------------------------------------------------------------
function TileObject:loadData(data)
    self.data = data
    self.name = data.name
    self.type = data.type
    self.shape = data.shape
    self.gid = data.gid
    self.properties = data.properties

    self:setPosByAuto(data.x, data.y)
    self:setSize(data.width, data.height)
    self:createRenderer()    
end

--------------------------------------------------------------------------------
-- Save the tile object data.
-- @return tile object data
--------------------------------------------------------------------------------
function TileObject:saveData()
    local data = self.data or {}
    seld.data = data
    data.name = self.name
    data.type = self.type
    data.shape = self.shape
    data.x = self:getLeft()
    data.y = self:getTop()
    data.width = self:getWidth()
    data.height = self:getHeight()
    data.gid = self.gid
    data.visible = self:getVisible()
    data.properties = self.properties
    return data
end

--------------------------------------------------------------------------------
-- Create a renderer.
-- There is no need to call directly basically.
-- @return Tile object renderer
--------------------------------------------------------------------------------
function TileObject:createRenderer()
    if self.renderer then
        self:removeChild(self.renderer)
    end

    self.rendererFactory = self.rendererFactory
    self.renderer = self.rendererFactory:newInstance(self)

    if self.renderer then
        self:addChild(self.renderer)
    end
end

function TileObject:setPosByAuto(x, y)
    local tileMap = self.tileMap

    if tileMap:isOrthogonal() then
        self:setPos(x, y)
    elseif tileMap:isIsometric() then
        self:setIsoPos(x, y)
    end
end

function TileObject:setIsoPos(x, y)
    local posX = x - y
    local posY = (x + y) / 2
    posX = posX + self.tileMap.tileWidth / 2
    posY = posY + self.tileMap.tileHeight / 2
    self:setPos(posX, posY)
end

function TileObject:getIsoPos()
    local posX, posY = self:getPos()
    posX = posX - self.tileMap.tileWidth / 2
    posY = posY -self.tileMap.tileHeight / 2
    local y = posY - posX / 2
    local x = posX + y
    return x, y
end

function TileObject:getProperty(key)
    return self.properties[key]
end

----------------------------------------------------------------------------------------------------
-- @type TileObjectGroup
-- 
-- This class manages the TileObject.
----------------------------------------------------------------------------------------------------
TileObjectGroup = class(Group)
M.TileObjectGroup = TileObjectGroup

--------------------------------------------------------------------------------
-- The constructor.
-- @param tileMap TileMap
--------------------------------------------------------------------------------
function TileObjectGroup:init(tileMap)
    Group.init(self)
    self.type = "objectgroup"
    self.name = ""
    self.tileMap = assert(tileMap)
    self.objects = {}
    self.properties = {}
    self.objectFactory = tileMap.objectFactory
end

--------------------------------------------------------------------------------
-- Load the objectgroup data.
-- @param data objectgroup data
--------------------------------------------------------------------------------
function TileObjectGroup:loadData(data)
    self.name = data.name
    self.opacity = data.opacity
    self.properties = data.properties
    self.data = data

    self:setVisible(data.visible)
    self:createObjects(data.objects)
end

--------------------------------------------------------------------------------
-- Save the objectgroup data.
-- @return objectgroup data
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Create a TileObjects from the data.
-- @param objectDatas object datas
-- @return TileObject list
--------------------------------------------------------------------------------
function TileObjectGroup:createObjects(objectDatas)
    local objects = {}
    for i, objectData in ipairs(objectDatas) do
        table.insertElement(objects, self:createObject(objectData))
    end
    return objects
end

--------------------------------------------------------------------------------
-- Create a TileObject from the data.
-- @param objectData object data
-- @return TileObject
--------------------------------------------------------------------------------
function TileObjectGroup:createObject(objectData)
    local tileObject = self.objectFactory:newInstance(self.tileMap)
    tileObject:loadData(objectData)
    self:addObject(tileObject)
    return tileObject
end

--------------------------------------------------------------------------------
-- Add a TileObject.
-- @param object TileObject
--------------------------------------------------------------------------------
function TileObjectGroup:addObject(object)
    if self:addChild(object) then
        table.insertElement(self.objects, object)
    end
end

--------------------------------------------------------------------------------
-- Returns a TileObjects.
-- @return objects
--------------------------------------------------------------------------------
function TileObjectGroup:getObjects()
    return self.objects
end

--------------------------------------------------------------------------------
-- Find a TileObjects.
-- @return objects
--------------------------------------------------------------------------------
function TileObjectGroup:findObjectByName(name)
    for i, object in ipairs(self.objects) do
        if object.name == name then
            return object
        end
    end
end

--------------------------------------------------------------------------------
-- Remove a TileObject.
-- @param object TileObject
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
-- @type TileLayerRenderer
-- 
-- Renderer class is used to draw a tile layer.
-- Generated through the TileLayerRendererFactory.
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
    self.tilesetToRendererMap = {}

    self:createRenderers()
end

--------------------------------------------------------------------------------
-- Create the tileset renderers.
--------------------------------------------------------------------------------
function TileLayerRenderer:createRenderers()
    local tilesets = self:getRenderableTilesets()

    for key, tileset in pairs(tilesets) do
        if tileset.texture then
            self:createRenderer(tileset)
        end
    end
end

--------------------------------------------------------------------------------
-- Create the tileset renderer.
-- @param tileset tileset
-- @return tileset renderer
--------------------------------------------------------------------------------
function TileLayerRenderer:createRenderer(tileset)
    if self.tilesetToRendererMap[tileset] then
        return
    end
    
    local texture = tileset.texture
    local tw, th = texture:getSize()

    local tileLayer = self.tileLayer
    local mapWidth, mapHeight = tileLayer.mapWidth, tileLayer.mapHeight
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    local renderer = MapImage(texture, mapWidth, mapHeight, tileWidth, tileHeight, spacing, margin)
    renderer.tileset = tileset
    self.tilesetToRendererMap[tileset] = renderer

    local tileSize = renderer.sheetSize
    local tiles = tileLayer.tiles

    for y = 0, mapHeight - 1 do
        local rowData = {}
        for x = 0, mapWidth - 1 do
            local gid = tileLayer:getGid(x, y)
            local tileNo = tileset:getTileIndexByGid(gid)
            tileNo = tileNo > tileSize and 0 or tileNo
            table.insertElement(rowData, tileNo)
        end
        renderer:setRow(y, unpack(rowData))
    end
    
    self:addChild(renderer)
    return renderer
end

--------------------------------------------------------------------------------
-- Remove the tileset renderer.
-- @param renderer renderer
--------------------------------------------------------------------------------
function TileLayerRenderer:removeRenderer(renderer)
    if self.tilesetToRendererMap[renderer.tileset] then
        self:removeChild(renderer)
        self.tilesetToRendererMap[renderer.tileset] = nil
    end
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
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @param gid global id.
--------------------------------------------------------------------------------
function TileLayerRenderer:setGid(x, y, gid)
    local tileset = self.tileMap:findTilesetByGid(gid)
    local tileNo = tileset:getTileIndexByGid(gid)
    local renderer = self:getRendererByTileset(tileset) or self:createRenderer(tileset)
    renderer:setTile(x, y, tileNo)
    self:addChild(renderer)
end

--------------------------------------------------------------------------------
-- Returns the renderer for the tileset.
-- @param tileset tileset
-- @return renderer
--------------------------------------------------------------------------------
function TileLayerRenderer:getRendererByTileset(tileset)
    return self.tilesetToRendererMap[tileset]
end


----------------------------------------------------------------------------------------------------
-- @type IsometricLayerRenderer
-- 
-- This class is the renderer to draw Isometric view.
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

    for y = 0, tileMap.mapHeight - 1 do
        for x = 0, tileMap.mapWidth - 1 do
            local gid = self.tileLayer:getGid(x, y)
            self:createRenderer(x, y, gid)
        end
    end
end

--------------------------------------------------------------------------------
-- Create the tile renderer.
-- @param x x position
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

    local renderer = SheetImage(texture)
    renderer:setIndex(tileNo)

    local deck = self.deckCache[tileset]
    if not deck then
        renderer:setTileSize(tileWidth, tileHeight, spacing, margin)
        deck = renderer.deck
        self.deckCache[tileset] = deck
    end
    renderer:setDeck(deck)

    local posX = x * (tileMap.tileWidth / 2) - y * (tileMap.tileWidth / 2)
    local posY = x * (tileMap.tileHeight / 2) + y * (tileMap.tileHeight / 2)
    posX = posX + tileset.tileOffsetX
    posY = posY + tileset.tileOffsetY + tileMap.tileHeight - tileHeight
    renderer:setPos(posX, posY)

    self:addChild(renderer)
    self.renderers[y * mapWidth + x + 1] = renderer
    
    return renderer
end

--------------------------------------------------------------------------------
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x (0 ... mapWidth - 1)
-- @param y potision of y (0 ... mapHeight - 1)
-- @param gid global id.
--------------------------------------------------------------------------------
function IsometricLayerRenderer:setGid(x, y, gid)
    local renderer = self:getRenderer(x, y)
    if renderer then
        self:removeChild(renderer)
        self.renderers[y * self.tileLayer.mapWidth + x + 1] = nil
    end

    self:createRenderer(x, y, gid)
end

--------------------------------------------------------------------------------
-- Returns the renderer for the position.
-- @param x x position
-- @param y y position
-- @return renderer
--------------------------------------------------------------------------------
function IsometricLayerRenderer:getRenderer(x, y)
    return self.renderers[y * self.tileLayer.mapWidth + x + 1]
end

----------------------------------------------------------------------------------------------------
-- @type TileLayerRendererFactory
-- 
-- It is a factory class for creating a renderer TileLayer.
-- Switch the class generated by the orientation.
----------------------------------------------------------------------------------------------------
TileLayerRendererFactory = class()
M.TileLayerRendererFactory = TileLayerRendererFactory

--------------------------------------------------------------------------------
-- Generate a renderer for the TileLayer.
-- @param layer TileLayer
-- @return TileLayerRenderer or IsometricLayerRenderer
--------------------------------------------------------------------------------
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
-- @type TileObjectRenderer
-- This class is the renderer to draw TileObject.
----------------------------------------------------------------------------------------------------
TileObjectRenderer = class(MovieClip)
M.TileObjectRenderer = TileObjectRenderer

--------------------------------------------------------------------------------
-- Constructor.
-- @param tileObject TileObject
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Set the gid.
-- Draw a tile corresponding to the gid.
-- @param gid gid
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Returns the gid.
-- @return gid
--------------------------------------------------------------------------------
function TileObjectRenderer:getGid()
    return self.gid
end

----------------------------------------------------------------------------------------------------
-- @type TileObjectRendererFactory
-- 
-- This class is a factory for generating TileObjectRenderer.
----------------------------------------------------------------------------------------------------
TileObjectRendererFactory = class()
M.TileObjectRendererFactory = TileObjectRendererFactory

--------------------------------------------------------------------------------
-- Generate the renderer to draw the TileObject.
-- If there is no gid, objects is not generated.
-- @param tileObject TileObject
-- @return TileObjectRenderer
--------------------------------------------------------------------------------
function TileObjectRendererFactory:newInstance(tileObject)
    if not tileObject.gid or tileObject.gid == 0 then
        return
    end

    return TileObjectRenderer(tileObject)
end

return M
