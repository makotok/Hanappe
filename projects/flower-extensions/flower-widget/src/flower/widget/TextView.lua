----------------------------------------------------------------------------------------------------
-- View class that displays a scrollable text.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.PanelView.html">PanelView</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Label = require "flower.Label"
local Resources = require "flower.Resources"
local UIEvent = require "flower.widget.UIEvent"
local PanelView = require "flower.widget.PanelView"
local TextAlign = require "flower.widget.TextAlign"

-- class
local TextView = class(PanelView)

--- Style: fontName
TextView.STYLE_FONT_NAME = "fontName"

--- Style: textSize
TextView.STYLE_TEXT_SIZE = "textSize"

--- Style: textColor
TextView.STYLE_TEXT_COLOR = "textColor"

--- Style: textSize
TextView.STYLE_TEXT_ALIGN = "textAlign"

---
-- Initializes the internal variables.
function TextView:_initInternal()
    TextView.__super._initInternal(self)
    self._themeName = "TextView"
    self._text = ""
    self._textLabel = nil
end

---
-- Create a children object.
function TextView:_createChildren()
    TextView.__super._createChildren(self)

    self._textLabel = Label(self._text, 100, 30)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addContent(self._textLabel)
end

---
-- Update the Text Label.
function TextView:_updateTextLabel()
    local textLabel = self._textLabel
    textLabel:setString(self:getText())
    textLabel:setTextSize(self:getTextSize())
    textLabel:setColor(self:getTextColor())
    textLabel:setAlignment(self:getAlignment())
    textLabel:setFont(self:getFont())
    textLabel:setSize(self:getScrollSize())
    textLabel:fitHeight()
end

---
-- Update the display objects.
function TextView:updateDisplay()
    TextView.__super.updateDisplay(self)
    self:_updateTextLabel()
end

---
-- Sets the text.
-- @param text text
function TextView:setText(text)
    self._text = text or ""
    self._textLabel:setString(self._text)
    self:invalidateDisplay()
end

---
-- Adds the text.
-- @param text text
function TextView:addText(text)
    self:setText(self._text .. text)
end

---
-- Returns the text.
-- @return text
function TextView:getText()
    return self._text
end

---
-- Sets the textSize.
-- @param textSize textSize
function TextView:setTextSize(textSize)
    self:setStyle(TextView.STYLE_TEXT_SIZE, textSize)
    self:invalidateDisplay()
end

---
-- Returns the textSize.
-- @return textSize
function TextView:getTextSize()
    return self:getStyle(TextView.STYLE_TEXT_SIZE)
end

---
-- Sets the fontName.
-- @param fontName fontName
function TextView:setFontName(fontName)
    self:setStyle(TextView.STYLE_FONT_NAME, fontName)
    self:invalidateDisplay()
end

---
-- Returns the font name.
-- @return font name
function TextView:getFontName()
    return self:getStyle(TextView.STYLE_FONT_NAME)
end

---
-- Returns the font.
-- @return font
function TextView:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

---
-- Sets the text align.
-- @param horizontalAlign horizontal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
function TextView:setTextAlign(horizontalAlign, verticalAlign)
    if horizontalAlign or verticalAlign then
        self:setStyle(TextView.STYLE_TEXT_ALIGN, {horizontalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(TextView.STYLE_TEXT_ALIGN, nil)
    end
    self._textLabel:setAlignment(self:getAlignment())
end

---
-- Returns the text align.
-- @return horizontal align(left, center, top)
-- @return vertical align(top, center, bottom)
function TextView:getTextAlign()
    return unpack(self:getStyle(TextView.STYLE_TEXT_ALIGN))
end

---
-- Returns the text align for MOAITextBox.
-- @return horizontal align
-- @return vertical align
function TextView:getAlignment()
    local h, v = self:getTextAlign()
    h = assert(TextAlign[h])
    v = assert(TextAlign[v])
    return h, v
end

---
-- Sets the text color.
-- @param red red(0 ... 1)
-- @param green green(0 ... 1)
-- @param blue blue(0 ... 1)
-- @param alpha alpha(0 ... 1)
function TextView:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(TextView.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(TextView.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

---
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
function TextView:getTextColor()
    return unpack(self:getStyle(TextView.STYLE_TEXT_COLOR))
end

return TextView