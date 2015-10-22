----------------------------------------------------------------------------------------------------
-- Item renderer to display the widget.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.BaseItemRenderer.html">BaseItemRenderer</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local UIComponent = require "flower.widget.UIComponent"
local BoxLayout = require "flower.widget.BoxLayout"
local BaseItemRenderer = require "flower.widget.BaseItemRenderer"

-- class
local WidgetItemRenderer = class(BaseItemRenderer)

---
-- Initialize a variables
function WidgetItemRenderer:_initInternal()
    WidgetItemRenderer.__super._initInternal(self)
    self._themeName = "WidgetItemRenderer"
    self._widget = nil
    self._widgetField = nil
end

---
-- Replace the widget.
function WidgetItemRenderer:_replaceWidget()
    local widget = self:getWidgetFromData()
    if widget == self._widget then
        return
    end

    if self._widget then
        self:removeChild(self._widget)
    end

    self._widget = widget

    if self._widget then
        self:addChild(self._widget)
    end
end

---
-- Update the widget.
function WidgetItemRenderer:_updateWidget()
    if not self._widget then
        return
    end

    if self._widget:getLayout() and self._widget:getLayout():instanceOf(BoxLayout) then
        self._widget:getLayout():setLayoutPolicy("none", "none")
    end

    self._widget:setSize(self:getSize())
end

---
-- Update the display objects.
function WidgetItemRenderer:updateDisplay()
    WidgetItemRenderer.__super.updateDisplay(self)
    self:_replaceWidget()
    self:_updateWidget()
end

---
-- Sets the widget field of data.
-- @param value field of data.
function WidgetItemRenderer:setWidgetField(value)
    if self._widgetField ~= value then
        self._widgetField = value
        self:invalidateDisplay()
    end    
end

---
-- Return the widget of data.
-- @return Widget of data.
function WidgetItemRenderer:getWidgetFromData()
    local data = (self._data and self._widgetField) and self._data[self._widgetField] or self._data
    return data and data.isUIComponent and data or nil
end

return WidgetItemRenderer
