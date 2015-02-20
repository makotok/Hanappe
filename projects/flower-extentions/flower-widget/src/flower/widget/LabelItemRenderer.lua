----------------------------------------------------------------------------------------------------
-- This is the base class of the item renderer.
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
-- Initialize a variables
function LabelItemRenderer:_createChildren()
    LabelItemRenderer.__super._createChildren(self)

    self._textLabel = UILabel {
        themeName = self:getThemeName(),
        parent = self,
    }
end

function LabelItemRenderer:updateDisplay()
    LabelItemRenderer.__super.updateDisplay(self)
    
    self._textLabel:setSize(self:getSize())
    if self._data then
        local text = self._dataField and self._data[self._dataField] or self._data
        text = type(text) == "string" and text or tostring(text)
        self._textLabel:setText(text)
    else
        self._textLabel:setText("")
    end
end

return LabelItemRenderer
