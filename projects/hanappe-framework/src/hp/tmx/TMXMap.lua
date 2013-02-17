--------------------------------------------------------------------------------
-- This class stores data in the form of map tiles.
-- Applies to the Model class.
-- 
-- Display function is not held.
-- Use the TMXMapView.
-- 
-- For tile map editor, please see below.
-- http://www.mapeditor.org/
-- 
--------------------------------------------------------------------------------

local class = require("hp/lang/class")
local table = require("hp/lang/table")

local M = class()

-- constraints
M.ATTRIBUTE_NAMES = {
    "version", "orientation", "width", "height", "tilewidth", "tileheight"
}

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init()
    self.version = 0
    self.orientation = ""
    self.width = 0
    self.height = 0
    self.tilewidth = 0
    self.tileheight = 0
    self.allLayers = {}
    self.layers = {}
    self.tilesets = {}
    self.objectGroups = {}
    self.properties = {}
end

--------------------------------------------------------------------------------
-- The information on the standard output TMXMap.
--------------------------------------------------------------------------------
function M:printDebug()
    -- header
    print("<TMXMap>")
    
    -- attributes
    for i, attr in ipairs(self.ATTRIBUTE_NAMES) do
        local value = self[attr]
        value = value and value or ""
        print(attr .. " = " .. value)
    end
    print("</TMXMap>")

end

--------------------------------------------------------------------------------
-- Add a layer.
-- @param layer layer.
--------------------------------------------------------------------------------
function M:addLayer(layer)
    table.insert(self.allLayers, layer)
    table.insert(self.layers, layer)
end

--------------------------------------------------------------------------------
-- Remove a layer.
-- @param layer layer.
--------------------------------------------------------------------------------
function M:removeLayer(layer)
    table.removeElement(self.allLayers, layer)
    return table.removeElement(self.layers, layer)
end

--------------------------------------------------------------------------------
-- Remove a layer.
-- @param index index.
--------------------------------------------------------------------------------
function M:removeLayerAt(index)
    table.removeElement(self.allLayers, self.layers[index])
    return table.remove(self.layers, index)
end

--------------------------------------------------------------------------------
-- Finds and returns the layer.
-- @param name Find name.
--------------------------------------------------------------------------------
function M:findLayerByName(name)
    for i, v in ipairs(self.layers) do
        if v.name == name then
            return v
        end
    end
    return nil
end

--------------------------------------------------------------------------------
-- Add the tile set.
-- @param tileset tileset.
--------------------------------------------------------------------------------
function M:addTileset(tileset)
    table.insert(self.tilesets, tileset)
end

--------------------------------------------------------------------------------
-- Remove the tile set.
-- @param tileset tileset.
--------------------------------------------------------------------------------
function M:removeTileset(tileset)
    return table.removeElement(self.tilesets, tileset)
end

--------------------------------------------------------------------------------
-- Remove the tile set.
-- @param index index
--------------------------------------------------------------------------------
function M:removeTilesetAt(index)
    return table.remove(self.tilesets, index)
end

--------------------------------------------------------------------------------
-- Finds and returns the tileset from the specified gid.
-- @param gid gid
-- @return TMXTileset
--------------------------------------------------------------------------------
function M:findTilesetByGid(gid)
    local matchTileset = nil
    for i, tileset in ipairs(self.tilesets) do
        if gid >= tileset.firstgid then
            matchTileset = tileset
        end
    end
    return matchTileset
end

--------------------------------------------------------------------------------
-- Add the ObjectGroup.
-- @param objectGroup objectGroup
--------------------------------------------------------------------------------
function M:addObjectGroup(objectGroup)
    table.insert(self.allLayers, objectGroup)
    table.insert(self.objectGroups, objectGroup)
end

--------------------------------------------------------------------------------
-- Remove the ObjectGroup.
-- @param objectGroup objectGroup
--------------------------------------------------------------------------------
function M:removeObjectGroup(objectGroup)
    table.removeElement(self.allLayers, objectGroup)
    return table.removeElement(self.objectGroups, objectGroup)
end

--------------------------------------------------------------------------------
-- Remove the ObjectGroup.
-- @param index index
--------------------------------------------------------------------------------
function M:removeObjectGroupAt(index)
    table.removeElement(self.allLayers, self.objectGroups[index])
    return table.remove(self.objectGroups, index)
end

--------------------------------------------------------------------------------
-- Returns the property with the specified key.
-- @param key property key
--------------------------------------------------------------------------------
function M:getProperty(key)
    return self.properties[key]
end

--------------------------------------------------------------------------------
-- Returns the property of the tile that corresponds to the specified gid.
-- @param gid gid
-- @param key property key
-- @return tile property
--------------------------------------------------------------------------------
function M:getTileProperty(gid, key)
    local properties = self:getTileProperties(gid)
    if properties then
        return properties[key]
    end
end

--------------------------------------------------------------------------------
-- Returns the properties of the tile that corresponds to the specified gid.
-- @param gid gid
-- @return tile properties
--------------------------------------------------------------------------------
function M:getTileProperties(gid)
    for i, tileset in ipairs(self.tilesets) do
        local tileId = tileset:getTileIndexByGid(gid)
        if tileset.tiles[tileId] then
            return tileset.tiles[tileId].properties
        end
    end
end


return M