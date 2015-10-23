----------------------------------------------------------------------------------------------------
-- This is the base class of the item renderer.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Graphics = require "flower.Graphics"
local UIComponent = require "flower.widget.UIComponent"

-- class
local BaseItemRenderer = class(UIComponent)

--- Style: backgroundColor
BaseItemRenderer.STYLE_BACKGROUND_COLOR = "backgroundColor"

--- Style: backgroundPressedColor
BaseItemRenderer.STYLE_BACKGROUND_PRESSED_COLOR = "backgroundPressedColor"

--- Style: backgroundSelectedColor
BaseItemRenderer.STYLE_BACKGROUND_SELECTED_COLOR = "backgroundSelectedColor"

--- Style: bottomBorderColor
BaseItemRenderer.STYLE_BOTTOM_BORDER_COLOR = "bottomBorderColor"

--- Style: rightBorderColor
BaseItemRenderer.STYLE_RIGHT_BORDER_COLOR = "rightBorderColor"

--- Style: rowHeight
BaseItemRenderer.STYLE_ROW_HEIGHT = "rowHeight"

---
-- Initialize a variables
function BaseItemRenderer:_initInternal()
    BaseItemRenderer.__super._initInternal(self)
    self.isRenderer = true
    self._data = nil
    self._dataIndex = nil
    self._rowIndex = nil
    self._columnIndex = nil
    self._hostComponent = nil
    self._focusEnabled = false
    self._selected = false
    self._pressed = false
    self._background = nil
    self._rowHeightField = nil
end

---
-- Create the children.
function BaseItemRenderer:_createChildren()
    BaseItemRenderer.__super._createChildren(self)
    self:_createBackground()
    self:_createRenderers()
end

---
-- Create the background objects.
function BaseItemRenderer:_createBackground()
    if self._background then
        return
    end
    self._background = Graphics(self:getSize())
    self._background._excludeLayout = true
    self:addChild(self._background)
end

---
-- Create the renderer objects.
function BaseItemRenderer:_createRenderers()

end

---
-- Update the background objects.
function BaseItemRenderer:_updateBackground()
    if not self._dataIndex then
        return
    end

    local width, height = self:getSize()
    self._background:setSize(width, height)
    self._background:clear()

    -- draw background
    if self:isBackgroundVisible() then
        self._background:setPenColor(self:getBackgroundColor()):fillRect(0, 0, width, height)
    end

    -- draw bottom border
    if self:isBottomBorderVisible() then
        self._background:setPenColor(self:getBottomBorderColor()):drawLine(0, height, width, height)
    end
    
    -- draw right border
    if self:isRightBorderVisible() then
        self._background:setPenColor(self:getRightBorderColor()):drawLine(width, 0, width, height)
    end
end

---
-- Update the display objects.
function BaseItemRenderer:updateDisplay()
    self:setHeight(self:getRowHeight())

    BaseItemRenderer.__super.updateDisplay(self)
    self:_updateBackground()
end

---
-- Set the data.
-- @param data data
function BaseItemRenderer:setData(data)
    if self._data ~= data then
        self._data = data
        self:invalidateDisplay()
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
        self:invalidateDisplay()
    end
end

---
-- Return the row height.
-- @return row height
function BaseItemRenderer:getRowHeight()
    if self._data and self._rowHeightField and self._data[self._rowHeightField] then
        return self._data[self._rowHeightField]
    end
    if self:getStyle(BaseItemRenderer.STYLE_ROW_HEIGHT) ~= nil then
        return self:getStyle(BaseItemRenderer.STYLE_ROW_HEIGHT)
    end
    if self._hostComponent then
        return self._hostComponent:getRowHeight()
    end
    return 0
end

---
-- Set the row height.
-- @param value row height.
function BaseItemRenderer:setRowHeight(value)
    if self:getRowHeight() ~= value then
        self:setStyle(BaseItemRenderer.STYLE_ROW_HEIGHT, value)
        self:invalidateLayout()
    end
end

---
-- Set the rowHeightField.
-- @param value rowHeightField.
function BaseItemRenderer:setRowHeightField(value)
    if self._rowHeightField ~= value then
        self._rowHeightField = value
        self:invalidate()
    end
end

---
-- Return the rowHeightField.
-- @return rowHeightField
function BaseItemRenderer:getRowHeightField()
    return self._rowHeightField
end

---
-- Set the row index.
-- @param value row index.
function BaseItemRenderer:setRowIndex(value)
    if self._rowIndex ~= value then
        self._rowIndex = value
        self:invalidateDisplay()
    end
end

---
-- Return the row index.
-- @return row index.
function BaseItemRenderer:getRowIndex()
    return self._rowIndex
end

---
-- Set the column index.
-- @param value column index.
function BaseItemRenderer:setColumnIndex(value)
    if self._columnIndex ~= value then
        self._columnIndex = value
        self:invalidateDisplay()
    end
end

---
-- Return the column index.
-- @return column index.
function BaseItemRenderer:getColumnIndex()
    return self._columnIndex
end

---
-- Set the host component with the renderer.
-- @param component component.
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

---
-- Returns the background color.
-- @return Red
-- @return Green
-- @return Blue
-- @return Alpha
function BaseItemRenderer:getBackgroundColor()
    if self._pressed then
        return unpack(self:getStyle(BaseItemRenderer.STYLE_BACKGROUND_PRESSED_COLOR))
    end
    if self._selected then
        return unpack(self:getStyle(BaseItemRenderer.STYLE_BACKGROUND_SELECTED_COLOR))
    end
    return unpack(self:getStyle(BaseItemRenderer.STYLE_BACKGROUND_COLOR))
end

---
-- Returns the bottom border color.
-- @return Red
-- @return Green
-- @return Blue
-- @return Alpha
function BaseItemRenderer:getBottomBorderColor()
    return unpack(self:getStyle(BaseItemRenderer.STYLE_BOTTOM_BORDER_COLOR))
end

---
-- Returns the right border color.
-- @return Red
-- @return Green
-- @return Blue
-- @return Alpha
function BaseItemRenderer:getRightBorderColor()
    return unpack(self:getStyle(BaseItemRenderer.STYLE_RIGHT_BORDER_COLOR))
end

---
-- Returns the background visible.
-- @return True if display the background
function BaseItemRenderer:isBackgroundVisible()
    local r, g, b, a = self:getBackgroundColor()
    return r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0
end

---
-- Returns the bottom border visible.
-- @return True if display the bottom border.
function BaseItemRenderer:isBottomBorderVisible()
    local r, g, b, a = self:getBottomBorderColor()
    return r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0
end

---
-- Returns the right border visible.
-- @return True if display the bottom border.
function BaseItemRenderer:isRightBorderVisible()
    local r, g, b, a = self:getRightBorderColor()
    local hostComponent = self:getHostComponent()
    local visible = hostComponent and self:getColumnIndex() < hostComponent:getColumnCount()
    return visible and (r ~= 0 or g ~= 0 or b ~= 0 or a ~= 0)
end

---
-- Sets the pressed.
-- @param pressed pressed
function BaseItemRenderer:setPressed(pressed)
    if self._pressed ~= pressed then
        self._pressed = pressed
        self:invalidateDisplay()
    end
end

---
-- Sets the selected.
-- @param selected selected
function BaseItemRenderer:setSelected(selected)
    if self._selected ~= selected then
        self._selected = selected
        self:invalidateDisplay()
    end
end

return BaseItemRenderer