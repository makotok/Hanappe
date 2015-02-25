----------------------------------------------------------------------------------------------------
-- Factory that creates an instance of the Class.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local PropertyUtils = require "flower.PropertyUtils"

-- class
local ClassFactory = class()

---
-- Constructor.
-- @param generator (option)It is a class to be generated
-- @param properties (option)Properties that set on the object.
function ClassFactory:init(generator, properties)
    self.generator = generator
    self.properties = properties
    self.fieldAccess = false
end

---
-- Creates an object from generator.
-- @param ... arguments of generator
-- @return object
function ClassFactory:newInstance(...)
    local obj = self.generator(...)
    return self:copyPropertiesToObject(self.properties, obj, self.fieldAccess)
end

---
-- INTERNAL USE ONLY
function ClassFactory:copyPropertiesToObject(properties, obj, fieldAccess)
    if properties then
        PropertyUtils.setProperties(obj, properties, true)
    end
    return obj
end

return ClassFactory
