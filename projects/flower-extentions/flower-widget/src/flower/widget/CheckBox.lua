----------------------------------------------------------------------------------------------------
-- This class is an checkbox.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local UIEvent = require "flower.widget.UIEvent"
local ImageButton = require "flower.widget.ImageButton"

-- class
local CheckBox = class(ImageButton)

---
-- Initializes the internal variables.
function CheckBox:_initInternal()
    CheckBox.__super._initInternal(self)
    self._themeName = "CheckBox"
    self._toggle = true
end

---
-- Update the buttonImage.
function CheckBox:updateButtonImage()
    local buttonImage = self._buttonImage
    buttonImage:setTexture(self:getImagePath())
end

---
-- Update the textLabel.
function CheckBox:updateTextLabel()
    CheckBox.__super.updateTextLabel(self)

    self._textLabel:fitWidth()
end

---
-- Returns the label content rect.
-- @return content rect
function CheckBox:getLabelContentRect()
    local buttonImage = self._buttonImage
    local textLabel = self._textLabel
    local left, top = buttonImage:getRight(), buttonImage:getTop()
    local right, bottom = left + textLabel:getWidth(), top + buttonImage:getHeight()
    return left, top, right, bottom
end

return CheckBox