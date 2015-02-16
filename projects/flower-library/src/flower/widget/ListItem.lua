----------------------------------------------------------------------------------------------------
-- It is the item class ListBox.
-- Used from the ListBox.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local KeyCode = require "flower.core.KeyCode"
local SheetImage = require "flower.core.SheetImage"
local UIEvent = require "flower.widget.UIEvent"
local TextBox = require "flower.widget.TextBox"

-- class
local ListItem = class(TextBox)

--- Style: iconVisible
ListItem.STYLE_ICON_VISIBLE = "iconVisible"

--- Style: iconTexture
ListItem.STYLE_ICON_TEXTURE = "iconTexture"

--- Style: iconTileSize
ListItem.STYLE_ICON_TILE_SIZE = "iconTileSize"

---
-- Initialize a variables
function ListItem:_initInternal()
    ListItem.__super._initInternal(self)
    self._themeName = "ListItem"
    self._data = nil
    self._dataIndex = nil
    self._focusEnabled = false
    self._selected = false
    self._iconImage = nil
    self._iconDataField = "iconNo"
end

---
-- Create the children.
function ListItem:_createChildren()
    self:_createIconImage()
    ListItem.__super._createChildren(self)
end

---
-- Create the iconImage.
function ListItem:_createIconImage()
    if self._iconImage then
        return
    end
    if not self:getStyle(ListItem.STYLE_ICON_TEXTURE) then
        return
    end

    self._iconImage = SheetImage(self:getStyle(ListItem.STYLE_ICON_TEXTURE))
    self._iconImage:setTileSize(unpack(self:getStyle(ListItem.STYLE_ICON_TILE_SIZE)))
    self._iconImage:setVisible(self:getStyle(ListItem.STYLE_ICON_TEXTURE) or false)
    self:addChild(self._iconImage)
end

---
-- Update the display.
function ListItem:updateDisplay()
    ListItem.__super.updateDisplay(self)

    if self._iconImage and self._iconImage:getIndex() > 0 then
        local textLabel = self._textLabel
        local textW, textH = textLabel:getSize()
        local textX, textY = textLabel:getPos()
        local padding = 5

        local icon = self._iconImage
        local iconW, iconH = icon:getSize()
        icon:setPos(textX, textY + math.floor((textH - iconH) / 2))

        textLabel:setSize(textW - iconW - padding, textH)
        textLabel:addLoc(iconW + padding, 0, 0)
    end
end

---
-- Set the data and rowIndex.
-- @param data data
-- @param dataIndex index of the data
function ListItem:setData(data, dataIndex)
    self._data = data
    self._dataIndex = dataIndex

    local textLabel = self._textLabel
    textLabel:setString(self:getText())

    if self._iconImage then
        self._iconImage:setIndex(self:getIconIndex())
    end

    self:invalidateDisplay()
end

---
-- Return the data.
-- @return data
function ListItem:getData()
    return self._data
end

---
-- Return the data index.
-- @return data index
function ListItem:getDataIndex()
    return self._dataIndex
end

---
-- Return the icon index.
-- @return icon index
function ListItem:getIconIndex()
    return self._data and self._data[self._iconDataField] or 0
end

---
-- Set the selected.
function ListItem:setSelected(selected)
    self._selected = selected
    self:setBackgroundVisible(selected)
end

---
-- Returns true if selected.
-- @return true if selected
function ListItem:isSelected()
    return self._selected
end

---
-- Returns the text.
-- @return text
function ListItem:getText()
    local data = self._data
    if data then
        local labelField = self:getLabelField()
        local text = labelField and data[labelField] or tostring(data)
        return text or ""
    else
        return ""
    end
end

---
-- Returns the labelField.
-- @return labelField
function ListItem:getLabelField()
    if self._listComponent then
        return self._listComponent:getLabelField()
    end
end

function ListItem:setListComponent(value)
    if self._listComponent ~= value then
        self._listComponent = value
        self:invalidate()
    end
end

function ListItem:getListComponent()
    return self._listComponent
end

---
-- Sets the icon visible.
function ListItem:setIconVisible(iconVisible)
    self:setStyle(ListItem.STYLE_ICON_VISIBLE)

    if self._iconImage then
        self._iconImage:setVisible(iconVisible)
    end

    self:invalidateDisplay()
end

return ListItem