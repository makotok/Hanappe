----------------------------------------------------------------------------------------------------
-- This class manages the TileObject.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.core.Group.html">Group</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Group = require "flower.core.Group"

-- class
local TileObjectGroup = class(Group)

---
-- The constructor.
-- @param tileMap TileMap
function TileObjectGroup:init(tileMap)
    TileObjectGroup.__super.init(self)
    self.type = "objectgroup"
    self.name = ""
    self.tileMap = assert(tileMap)
    self.objects = {}
    self.properties = {}
    self.objectFactory = tileMap.objectFactory
end

---
-- Load the objectgroup data.
-- @param data objectgroup data
function TileObjectGroup:loadData(data)
    self.name = data.name
    self.opacity = data.opacity
    self.properties = data.properties
    self.data = data

    self:createObjects(data.objects)
    if self:getVisible() ~= data.visible then
        self:setVisible(data.visible)
    end
end

---
-- Save the objectgroup data.
-- @return objectgroup data
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

---
-- Create a TileObjects from the data.
-- @param objectDatas object datas
-- @return TileObject list
function TileObjectGroup:createObjects(objectDatas)
    local objects = {}
    for i, objectData in ipairs(objectDatas) do
        table.insertElement(objects, self:createObject(objectData))
    end
    return objects
end

---
-- Create a TileObject from the data.
-- @param objectData object data
-- @return TileObject
function TileObjectGroup:createObject(objectData)
    local tileObject = self.objectFactory:newInstance(self.tileMap, objectData)
    tileObject:loadData(objectData)
    self:addObject(tileObject)
    return tileObject
end

---
-- Add a TileObject.
-- @param object TileObject
function TileObjectGroup:addObject(object)
    if self:addChild(object) then
        table.insertElement(self.objects, object)
    end
end

---
-- Returns a TileObjects.
-- @return objects
function TileObjectGroup:getObjects()
    return self.objects
end

---
-- Find a TileObject.
-- @param fieldName Name of the field.
-- @param fieldValue Value of the field.
-- @return object
function TileObjectGroup:findObject(fieldName, fieldValue)
    for i, object in ipairs(self.objects) do
        if object[fieldName] == fieldValue then
            return object
        end
    end
end

---
-- Find a TileObject by name.
-- @param name name
-- @return object
function TileObjectGroup:findObjectByName(name)
    return self:findObject("name", name)
end

---
-- Find a TileObject by type.
-- @param type type
-- @return object
function TileObjectGroup:findObjectByType(type)
    return self:findObject("type", type)
end

---
-- Find a TileObjects.
-- @param fieldName Name of the field.
-- @param fieldValue Value of the field.
-- @return objects
function TileObjectGroup:findObjects(fieldName, fieldValue)
    local list = {}
    for i, object in ipairs(self.objects) do
        if object[fieldName] == fieldValue then
            table.insertElement(list, object)
        end
    end
    return list
end

---
-- Find a TileObjects by name.
-- @param name name
-- @return objects
function TileObjectGroup:findObjectsByName(name)
    return self:findObjects("name", name)
end

---
-- Find a TileObjects.
-- @param type type
-- @return objects
function TileObjectGroup:findObjectsByType(type)
    return self:findObjects("type", type)
end

---
-- Remove a TileObject.
-- @param object TileObject
function TileObjectGroup:removeObject(object)
    table.removeElement(self.objects, object)
    self:removeChild(object)
end

---
-- Returns the property.
-- @param key key.
-- @return value.
function TileObjectGroup:getProperty(key)
    return self.properties[key]
end

---
-- Returns the property.
-- @param key key.
-- @return value.
function TileObjectGroup:getPropertyAsNumber(key)
    local value = self:getProperty(key)
    if value then
        return tonumber(value)
    end
end

return TileObjectGroup
