----------------------------------------------------------------------------------------------------
-- This is the base class of the item renderer.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Graphics = require "flower.core.Graphics"
local UIComponent = require "flower.widget.UIComponent"

-- class
local BaseItemRenderer = class(UIComponent)

--- Style: backgroundColor
BaseItemRenderer.STYLE_BACKGROUND_COLOR = "backgroundColor"

--- Style: backgroundPressedColor
BaseItemRenderer.STYLE_BACKGROUND_PRESSED_COLOR = "backgroundPressedColor"

--- Style: backgroundSelectedColor
BaseItemRenderer.STYLE_BACKGROUND_SELECTED_COLOR = "backgroundSelectedColor"

---
-- Initialize a variables
function BaseItemRenderer:_initInternal()
    BaseItemRenderer.__super._initInternal(self)
    self.isRenderer = true
    self._data = nil
    self._dataIndex = nil
    self._hostComponent = nil
    self._focusEnabled = false
    self._selected = false
    self._pressed = false
    self._background = nil
end

---
-- Create the children.
function BaseItemRenderer:_createChildren()
    BaseItemRenderer.__super._createChildren(self)
    self:_createBackground()
end

---
-- Create the background objects.
function BaseItemRenderer:_createBackground()
    self._background = Graphics(self:getSize())
    self._background._excludeLayout = true
    self:addChild(self._background)
end

---
-- Update the background objects.
function BaseItemRenderer:_updateBackground()
    local width, height = self:getSize()
    self._background:setSize(width, height)
    self._background:clear()
    if self:isBackgroundVisible() then
        self._background:setPenColor(self:getBackgroundColor()):fillRect(0, 0, width, height)
    end
end

---
-- Update the display objects.
function BaseItemRenderer:updateDisplay()
    BaseItemRenderer.__super.updateDisplay(self)
    self:_updateBackground()
end

---
-- Set the data.
-- @param data data
function BaseItemRenderer:setData(data)
    if self._data ~= data then
        self._data = data
        self:invalidate()
    end
end

---
-- Return the data.
-- @return data
function BaseItemRenderer:getData()
    return self._data
end

---
-- Set the data index.
-- @param index index of data.
function BaseItemRenderer:setDataIndex(index)
    if self._dataIndex ~= index then
        self._dataIndex = index
        self:invalidate()
    end
end

---
-- Set the data field.
-- @param dataField field of data.
function BaseItemRenderer:setDataField(dataField)
    if self._dataField ~= dataField then
        self._dataField = dataField
        self:invalidate()
    end    
end

---
-- Set the host component with the renderer.
-- @param index index of data.
function BaseItemRenderer:setHostComponent(component)
    if self._hostComponent ~= component then
        self._hostComponent = component
        self:invalidate()
    end
end

---
-- Return the host component.
-- @return host component
function BaseItemRenderer:getHostComponent()
    return self._hostComponent
end

function BaseItemRenderer:getBackgroundColor()
    if self._pressed then
        return unpack(self:getStyle(BaseItemRenderer.STYLE_BACKGROUND_PRESSED_COLOR))
    end
    if self._selected then
        return unpack(self:getStyle(BaseItemRenderer.STYLE_BACKGROUND_SELECTED_COLOR))
    end
    return unpack(self:getStyle(BaseItemRenderer.STYLE_BACKGROUND_COLOR))
end

function BaseItemRenderer:isBackgroundVisible()
    local r, g, b, a = self:getBackgroundColor()
    return r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0
end

---
-- Set the pressed
-- @param pressed pressed
function BaseItemRenderer:setPressed(pressed)
    if self._pressed ~= pressed then
        self._pressed = pressed
        self:invalidateDisplay()
    end
end

---
-- Set the pressed
-- @param pressed pressed
function BaseItemRenderer:setSelected(selected)
    if self._selected ~= selected then
        self._selected = selected
        self:invalidateDisplay()
    end
end

return BaseItemRenderer