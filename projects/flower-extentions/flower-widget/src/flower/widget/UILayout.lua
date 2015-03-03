----------------------------------------------------------------------------------------------------
-- This is a class to set the layout of UIComponent.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local PropertyUtils = require "flower.PropertyUtils"

-- class
local UILayout = class()

---
-- Constructor.
function UILayout:init(params)
    self:_initInternal()
    self:setProperties(params)
end

---
-- Initialize the internal variables.
function UILayout:_initInternal()

end

---
-- Update the layout.
-- @param parent parent component.
function UILayout:update(parent)

end

---
-- Sets the properties.
-- @param properties properties
function UILayout:setProperties(properties)
    if properties then
        PropertyUtils.setProperties(self, properties, true)
    end
end

return UILayout