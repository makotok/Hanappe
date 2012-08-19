--------------------------------------------------------------------------------
-- Class is a objectgroup of TMXMap.
--
-- @class table
-- @name TMXObjectGroup
--------------------------------------------------------------------------------

local class = require("hp/lang/class")

local M = class()

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(tmxMap)
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
    table.insert(self.objects, object)
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
