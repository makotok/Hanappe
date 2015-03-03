----------------------------------------------------------------------------------------------------
-- Item renderer to display the label.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local UIComponent = require "flower.widget.UIComponent"
local UILabel = require "flower.widget.UILabel"
local BaseItemRenderer = require "flower.widget.BaseItemRenderer"

-- class
local LabelItemRenderer = class(BaseItemRenderer)

---
-- Initialize a variables
function LabelItemRenderer:_initInternal()
    LabelItemRenderer.__super._initInternal(self)
    self._themeName = "LabelItemRenderer"
end

---
-- Create the renderer objects.
function LabelItemRenderer:_createRenderers()
    LabelItemRenderer.__super._createRenderers(self)
    self:_createTextLabel()
end

---
-- Create the textLabel.
function LabelItemRenderer:_createTextLabel()
    self._textLabel = UILabel {
        themeName = self:getThemeName(),
        parent = self,
    }
end

---
-- Update the textLabel.
function LabelItemRenderer:_updateTextLabel()
    self._textLabel:setSize(self:getSize())
    self._textLabel:setVisible(self._data ~= nil)

    if self._data then
        local text = self._dataField and self._data[self._dataField] or self._data
        text = type(text) == "string" and text or tostring(text)
        self._textLabel:setText(text)
    end
end

---
-- Update the display objects.
function LabelItemRenderer:updateDisplay()
    LabelItemRenderer.__super.updateDisplay(self)
    self:_updateTextLabel()
end

return LabelItemRenderer
