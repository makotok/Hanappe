----------------------------------------------------------------------------------------------------
-- Class that displays the map data created by Tiled Map Editor.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.Group.html">Group</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local ClassFactory = require "flower.ClassFactory"
local Group = require "flower.Group"
local Resources = require "flower.Resources"
local BitUtils = require "flower.BitUtils"
local TileFlag = require "flower.tiled.TileFlag"
local TileMapImage = require "flower.tiled.TileMapImage"
local Tileset = require "flower.tiled.Tileset"
local TileLayer = require "flower.tiled.TileLayer"
local TileLayerRendererFactory = require "flower.tiled.TileLayerRendererFactory"
local TileObjectGroup = require "flower.tiled.TileObjectGroup"
local TileObject = require "flower.tiled.TileObject"
local TileObjectRendererFactory = require "flower.tiled.TileObjectRendererFactory"

-- class
local TileMap = class(Group)

-- Events
TileMap.EVENT_LOADED_DATA = "loadedData"
TileMap.EVENT_SAVED_DATA = "savedData"

-- Priority Margin
TileMap.PRIORITY_MARGIN = 10000

---
-- The constructor.
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

---
-- Load the map data from luefile.
-- @param luefile path.
function TileMap:loadLueFile(luefile)
    self:loadMapData(Resources.dofile(luefile))
end

---
-- Load the map data.
-- @param data mapdata.
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
    
    self:updateRenderOrder()
end

---
-- Save the map data.
-- @return mapdata.
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

---
-- Clear the map data.
function TileMap:clearMapData()
    self:removeChildren()

    self.data = {}
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
end

---
-- Update the order of the rendering.
-- If you are using a single layer,
-- you should update the drawing order in a timely manner.
-- @param priority Priority of start
-- @param margin Priority margin
function TileMap:updateRenderOrder(priority, margin)
    priority = priority or 1
    margin = margin or TileMap.PRIORITY_MARGIN
    for i, child in ipairs(self.children) do
        if child.updateRenderOrder then
            child:updateRenderOrder(priority)
        else
            child:setPriority(priority)
        end
        priority = priority + margin
    end
end

---
-- Set the directory to refer to the resource.
-- @param path resource directory
function TileMap:setResourceDirectory(path)
    self.resourceDirectory = path
end

---
-- Create a tilesets.
-- @param tilesetDatas tileset data's
function TileMap:createTilesets(tilesetDatas)
    for i, tilesetData in ipairs(tilesetDatas) do
        local tileset = self.tilesetFactory:newInstance(self)
        tileset:loadData(tilesetData)
        self:addTileset(tileset)
    end
end

---
-- Create a layers on the map from the given data's.
-- @param layerDatas layer data's
function TileMap:createMapLayers(layerDatas)
    local mapLayers = {}
    for i, layerData in ipairs(layerDatas) do
        table.insertElement(mapLayers, self:createMapLayer(layerData))
    end
    return mapLayers
end

---
-- Create a layer on the map from the given data.
-- @param layerData layer data
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

---
-- Returns the layers on the map.
-- You must not be edited on this table.
-- @return layers.
function TileMap:getMapLayers()
    return self.mapLayers
end

---
-- Add the layer.
-- Also be added to the rendering list.
-- @param layer layer.
function TileMap:addMapLayer(layer)
    if self:addChild(layer) then
        table.insert(self.mapLayers, layer)
    end
end

---
-- Remove the layer.
-- @param layer layer
function TileMap:removeMapLayer(layer)
    table.removeElement(self.mapLayers, layer)
    self:removeChild(layer)
end

---
-- Remove all the layers.
function TileMap:removeMapLayers()
    local mapLayer = self.mapLayers[1]
    while mapLayer do
        self.removeMapLayer(mapLayer)
        mapLayer = self.mapLayers[1]
    end
end

---
-- Finds and returns the layer.
-- @param name The name of the layer
function TileMap:findMapLayerByName(name)
    for i, v in ipairs(self.mapLayers) do
        if v.name == name then
            return v
        end
    end
end

---
-- Returns the tilesets.
-- @return tilesets
function TileMap:getTilesets()
    return self.tilesets
end

---
-- Add the tileset.
-- @param tileset tileset
function TileMap:addTileset(tileset)
    table.insertElement(self.tilesets, tileset)
end

---
-- Remove the tileset.
-- @param tileset Tileset
function TileMap:removeTileset(tileset)
    table.removeElement(self.tilesets, tileset)
end

---
-- Finds and returns the tileset from the specified gid.
-- @param gid gid
-- @return TMXTileset
function TileMap:findTilesetByGid(gid)
    gid = TileFlag.clearFlags(gid)
    for i = #self.tilesets, 1, -1 do
        local tileset = self.tilesets[i]
        if tileset:hasTile(gid) then
            return tileset
        end
    end
end

---
-- Returns the property with the specified key.
-- @param key property key
-- @return property value
function TileMap:getProperty(key)
    return self.properties[key]
end

---
-- Returns the property.
-- @param key key.
-- @return value.
function TileMap:getPropertyAsNumber(key)
    local value = self:getProperty(key)
    if value then
        return tonumber(value)
    end
end

---
-- Returns the tile property with the specified gid.
-- @param gid tile gid
-- @param key key of the properties
-- @return property value
function TileMap:getTileProperty(gid, key)
    local tileset = self:findTilesetByGid(gid)
    if tileset then
        local tileId = tileset:getTileIdByGid(gid)
        if tileset and tileId then
            return tileset:getTileProperty(tileId, key)
        end
    end
end

---
-- Returns the tile properties with the specified gid.
-- @param gid tile gid
-- @return tile property value
function TileMap:getTileProperties(gid)
    local tileset = self:findTilesetByGid(gid)
    if tileset then
        local tileId = tileset:getTileIdByGid(gid)
        if tileset and tileId then
            return tileset:getTileProperties(tileId)
        end
    end
end

---
-- Returns true if the orientation is orthogonal.
-- @return True if the orientation is orthogonal.
function TileMap:isOrthogonal()
    return self.orientation == "orthogonal"
end

---
-- Returns true if the orientation is isometric.
-- @return True if the orientation is isometric.
function TileMap:isIsometric()
    return self.orientation == "isometric"
end

return TileMap