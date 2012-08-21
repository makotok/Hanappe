--------------------------------------------------------------------------------
-- This class stores data in the form of map tiles. <br>
-- Applies to the Model class. <br>
-- <br>
-- Display function is not held. <br>
-- Use the TMXMapView. <br>
-- <br>
-- For tile map editor, please see below. <br>
-- http://www.mapeditor.org/ <br>
-- @class table
-- @name TMXMapAdapter
--------------------------------------------------------------------------------

local class = require "hp/lang/class"
local table = require "hp/lang/table"
local Event = require "hp/event/Event"
local EventDispatcher = require "hp/event/EventDispatcher"

local M = class(EventDispatcher)

M.EVENTS = {
    ADDED_LAYER = "addedLayer",
    ADDED_TILESET = "addedTileset",
    ADDED_OBJECT = "addedObject",
    ADDED_OBJECT_GROUP = "addedObjectGroup",
    REMOVED_LAYER = "removedLayer",
    REMOVED_TILESET = "removedTileset",
    REMOVED_OBJECT = "removedObject",
    REMOVED_OBJECT_GROUP = "removedObjectGroup",
    UPDATE_LAYER = "updateLayer",
    UPDATE_TILESET = "updateTileset",
    UPDATE_OBJECT = "updateObject",
    UPDATE_OBJECT_GROUP = "updateObjectGroup",
}

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(mapData)
    self.map = assert(mapData)
end

--------------------------------------------------------------------------------
-- Returns the TMXLayer list.
--------------------------------------------------------------------------------
function M:getLayers()
    return table.copy(self.map.layers)
end

--------------------------------------------------------------------------------
-- Add a layer.
-- @param layer layer.
--------------------------------------------------------------------------------
function M:addLayer(layer)
    if self.map:addLayer(layer) then
        local e = Event(M.EVENTS.ADDED_LAYER)
        e.layer = layer
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Remove a layer.
--------------------------------------------------------------------------------
function M:removeLayer(layer)
    if self.map:removeLayer(layer) then
        local e = Event(M.EVENTS.REMOVED_LAYER)
        e.layer = layer
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Add the tile set.
-- @param tileset tileset.
--------------------------------------------------------------------------------
function M:addTileset(tileset)
    if self.map:addTileset(tileset) then
        local e = Event(M.EVENTS.ADDED_TILESET)
        e.tileset = tileset
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Remove the tile set.
--------------------------------------------------------------------------------
function M:removeTileset(tileset)
    if self.map:removeTileset(tileset) then
        local e = Event(M.EVENTS.REMOVED_TILESET)
        e.tileset = tileset
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Add the ObjectGroup.
--------------------------------------------------------------------------------
function M:addObjectGroup(objectGroup)
    if self.map:addObjectGroup(objectGroup) then
        local e = Event(M.EVENTS.ADDED_TILESET)
        e.objectGroup = objectGroup
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Remove the ObjectGroup.
--------------------------------------------------------------------------------
function M:removeObjectGroup(objectGroup)
    if self.map:removeObjectGroup(objectGroup) then
        local e = Event(M.EVENTS.REMOVED_TILESET)
        e.objectGroup = objectGroup
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Add the Object by ObjectGroup.
--------------------------------------------------------------------------------
function M:addObjectByGroup(objectGroup, object)
    if table.indexOf(self.map.objectGroups, objectGroup) == 0 then
        return false
    end

    if objectGroup:addObject(object) then
        local e = Event(M.EVENTS.ADDED_OBJECT)
        e.objectGroup = objectGroup
        e.object = object
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Remove the Object by ObjectGroup.
--------------------------------------------------------------------------------
function M:removeObjectByGroup(objectGroup, object)
    if table.indexOf(self.map.objectGroups, objectGroup) == 0 then
        return false
    end

    if objectGroup:removeObject(object) then
        local e = Event(M.EVENTS.REMOVED_OBJECT)
        e.objectGroup = objectGroup
        e.object = object
        self:dispatchEvent(e)
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- Update the TMXLayer object.
-- @param layer layer.
--------------------------------------------------------------------------------
function M:updateLayer(layer)
    if table.indexOf(self.map.layers, layer) == 0 then
        return false
    end
    
    local e = Event(M.EVENTS.UPDATE_LAYER)
    e.objectGroup = objectGroup
    e.object = object
    self:dispatchEvent(e)
    return true
end

--------------------------------------------------------------------------------
-- Update the TMXTileset object.
-- @param tileset tileset.
--------------------------------------------------------------------------------
function M:updateTileset(tileset)

end

--------------------------------------------------------------------------------
-- Update the TMXObject object.
-- @param layer layer.
--------------------------------------------------------------------------------
function M:updateObject(object)

end

--------------------------------------------------------------------------------
-- Update the TMXMapObjectGroup object.
-- @param layer layer.
--------------------------------------------------------------------------------
function M:updateObjectGroup(objectGroup)

end


return M