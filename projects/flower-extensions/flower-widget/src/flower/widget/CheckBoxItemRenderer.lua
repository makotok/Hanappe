----------------------------------------------------------------------------------------------------
-- This is the base class of the item renderer.
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
local CheckBox = require "flower.widget.CheckBox"
local BaseItemRenderer = require "flower.widget.BaseItemRenderer"

-- class
local CheckBoxItemRenderer = class(BaseItemRenderer)

---
-- Initialize a variables
function CheckBoxItemRenderer:_initInternal()
    CheckBoxItemRenderer.__super._initInternal(self)
    self._themeName = "CheckBoxItemRenderer"
    self._checkBox = nil
    self._labelField = nil
    self._selectedField = nil
end

---
-- Create the renderer objects.
function CheckBoxItemRenderer:_createRenderers()
    CheckBoxItemRenderer.__super._createRenderers(self)
    self:_createCheckBox()
end

---
-- Create the checkBox.
function CheckBoxItemRenderer:_createCheckBox()
    if self._checkBox then
        return
    end
    self._checkBox = CheckBox {
        themeName = self:getThemeName(),
        parent = self,
        onSelectedChanged = function(e)
            self:onSelectedChanged(e)
        end,
    }
end

---
-- Update the checkBox.
function CheckBoxItemRenderer:_updateCheckBox()
    self._checkBox:setSize(self:getSize())

    if self._data then
        if self._labelField then
            local text = self._data[self._labelField]
            text = type(text) == "string" and text or tostring(text)
            self._checkBox:setText(text)
        end

        if self._selectedField then
            self._checkBox:setSelected(self._data[self._selectedField])
        end
    end
end

---
-- Update the Display objects.
function CheckBoxItemRenderer:updateDisplay()
    CheckBoxItemRenderer.__super.updateDisplay(self)
    self:_updateCheckBox()
end

---
-- Sets the label field of data.
-- @param labelField field of data.
function CheckBoxItemRenderer:setLabelField(labelField)
    if self._labelField ~= labelField then
        self._labelField = labelField
        self:invalidateDisplay()
    end    
end

---
-- Sets the selected field of data.
-- @param selectedField field of data.
function CheckBoxItemRenderer:setSelectedField(selectedField)
    if self._selectedField ~= selectedField then
        self._selectedField = selectedField
        self:invalidateDisplay()
    end    
end

function CheckBoxItemRenderer:onSelectedChanged(e)
    if self._data and self._selectedField then
        self._data[self._selectedField] = e.data
    end
end

return CheckBoxItemRenderer
