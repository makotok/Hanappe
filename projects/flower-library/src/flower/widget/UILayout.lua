----------------------------------------------------------------------------------------------------
-- @type UILayout
-- This is a class to set the layout of UIComponent.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local PropertyUtils = require "flower.util.PropertyUtils"

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