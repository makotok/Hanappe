--------------------------------------------------------------------------------
-- Class is a objectgroup of TMXMap.
--------------------------------------------------------------------------------

local table = require "hp/lang/table"
local class = require "hp/lang/class"

local M = class()

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(tmxMap)
    self.type = "objectgroup"
    self.name = ""
    self.width = 0
    self.height = 0
    self.tmxMap = tmxMap
    self.objects = {}
    self.properties = {}
end

--------------------------------------------------------------------------------
-- Add the object.
--------------------------------------------------------------------------------
function M:addObject(object)
    return table.insertElement(self.objects, object)
end

--------------------------------------------------------------------------------
-- Remove the object.
--------------------------------------------------------------------------------
function M:removeObject(object)
    return table.removeElement(self.objects, object)
end

--------------------------------------------------------------------------------
-- Returns the property.
-- @param key key.
-- @return value.
--------------------------------------------------------------------------------
function M:getProperty(key)
    return self.properties[key]
end

return M
