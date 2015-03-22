----------------------------------------------------------------------------------------------------
-- Item renderer to display the label.
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
local UILabel = require "flower.widget.UILabel"
local BaseItemRenderer = require "flower.widget.BaseItemRenderer"

-- class
local LabelItemRenderer = class(BaseItemRenderer)

---
-- Initialize a variables
function LabelItemRenderer:_initInternal()
    LabelItemRenderer.__super._initInternal(self)
    self._themeName = "LabelItemRenderer"
    self._labelField = nil
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
    if self._textLabel then
        return
    end
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
        local text = self._labelField and self._data[self._labelField] or self._data
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

---
-- Sets the label field of data.
-- @param labelField field of data.
function LabelItemRenderer:setLabelField(labelField)
    if self._labelField ~= labelField then
        self._labelField = labelField
        self:invalidateDisplay()
    end    
end

return LabelItemRenderer
