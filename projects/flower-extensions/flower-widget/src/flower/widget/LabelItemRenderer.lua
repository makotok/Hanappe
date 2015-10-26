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

--- Style: lineBreak
LabelItemRenderer.STYLE_LINE_BREAK = "lineBreak"

---
-- Initialize a variables
function LabelItemRenderer:_initInternal()
    LabelItemRenderer.__super._initInternal(self)
    self._themeName = "LabelItemRenderer"
    self._labelField = nil
    self._labelFunction = nil
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
    if not self._dataIndex then
        return
    end

    self._textLabel:setSize(self:getSize())
    self._textLabel:setVisible(self._data ~= nil)

    if self._data then
        local text = self:itemToLabel(self._data)
        if self._textLabel:getText() ~= text then
            self._textLabel:setText(text)
        end
    end

    if self:getLineBreak() then
        self._textLabel:fitHeight()

        if self._textLabel:getHeight() > self:getHostComponent():getRowHeight() then
            self:setRowHeight(self._textLabel:getHeight())
        else
            self:setRowHeight(nil)
            self._textLabel:setSize(self:getSize())
        end

    end
end

---
-- Update the display objects.
function LabelItemRenderer:updateDisplay()
    LabelItemRenderer.__super.updateDisplay(self)
    self:_updateTextLabel()
end

---
-- Returns the label text for item.
function LabelItemRenderer:itemToLabel(item)
    local label = self._labelField and item[self._labelField] or item

    if self._labelFunction and label  then
        label = self._labelFunction(label)
    end

    label = type(label) == "string" and label or tostring(label)
    return label
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

---
-- Sets the text align.
-- @param horizontalAlign horizontal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
function LabelItemRenderer:setTextAlign(horizontalAlign, verticalAlign)
    self._textLabel:setTextAlign(horizontalAlign, verticalAlign)
end


function LabelItemRenderer:setLabelFunction(value)
    if self._labelFunction ~= value then
        self._labelFunction = value
        self:invalidateDisplay()        
    end
end

function LabelItemRenderer:setLineBreak(value)
    if self:getLineBreak() ~= value then
        self:setStyle(LabelItemRenderer.STYLE_LINE_BREAK, value)
        self:invalidateDisplay()
    end
end

function LabelItemRenderer:getLineBreak()
    return self:getStyle(LabelItemRenderer.STYLE_LINE_BREAK)
end

return LabelItemRenderer
