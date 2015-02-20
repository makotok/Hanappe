----------------------------------------------------------------------------------------------------
-- It is a class that displays the text.
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
local Panel = require "flower.widget.Panel"
local TextAlign = require "flower.widget.TextAlign"

-- class
local TextBox = class(Panel)

--- Style: fontName
TextBox.STYLE_FONT_NAME = "fontName"

--- Style: textSize
TextBox.STYLE_TEXT_SIZE = "textSize"

--- Style: textColor
TextBox.STYLE_TEXT_COLOR = "textColor"

--- Style: textSize
TextBox.STYLE_TEXT_ALIGN = "textAlign"

--- Style: textPadding
TextBox.STYLE_TEXT_PADDING = "textPadding"

---
-- Initialize a variables
function TextBox:_initInternal()
    TextBox.__super._initInternal(self)
    self._themeName = "TextBox"
    self._text = ""
    self._textLabel = nil
end

---
-- Create a children object.
function TextBox:_createChildren()
    TextBox.__super._createChildren(self)

    self._textLabel = Label(self._text)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
end

---
-- Update the TextLabel.
function TextBox:_updateTextLabel()
    local textLabel = self._textLabel
    local xMin, yMin, xMax, yMax = self:getContentRect()
    local padLeft, padTop, padRight, padBottom = self:getTextPadding()
    local textWidth, textHeight = xMax - xMin - padLeft - padRight, yMax - yMin - padTop - padBottom
    textLabel:setSize(textWidth, textHeight)
    textLabel:setPos(xMin + padLeft, yMin + padTop)
    textLabel:setString(self:getText())
    textLabel:setTextSize(self:getTextSize())
    textLabel:setColor(self:getTextColor())
    textLabel:setAlignment(self:getAlignment())
    textLabel:setFont(self:getFont())
end

---
-- Update the display objects.
function TextBox:updateDisplay()
    TextBox.__super.updateDisplay(self)
    self:_updateTextLabel()
end

---
-- Sets the text.
-- @param text text
function TextBox:setText(text)
    self._text = text or ""
    self._textLabel:setString(self._text)
    self:invalidate()
end

---
-- Adds the text.
-- @param text text
function TextBox:addText(text)
    self:setText(self._text .. text)
end

---
-- Returns the text.
-- @return text
function TextBox:getText()
    return self._text
end

-- Returns the text length.
-- TODO:Tag escaping.
-- @return text length
function TextBox:getTextLength()
    return self._text and #self._text or 0
end

---
-- Sets the textSize.
-- @param textSize textSize
function TextBox:setTextSize(textSize)
    self:setStyle(TextBox.STYLE_TEXT_SIZE, textSize)
    self:invalidate()
end

---
-- Returns the textSize.
-- @return textSize
function TextBox:getTextSize()
    return self:getStyle(TextBox.STYLE_TEXT_SIZE)
end

---
-- Sets the fontName.
-- @param fontName fontName
function TextBox:setFontName(fontName)
    self:setStyle(TextBox.STYLE_FONT_NAME, fontName)
    self:invalidate()
end

---
-- Returns the font name.
-- @return font name
function TextBox:getFontName()
    return self:getStyle(TextBox.STYLE_FONT_NAME)
end

---
-- Returns the font.
-- @return font
function TextBox:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

---
-- Sets the text align.
-- @param horizontalAlign horizontal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
function TextBox:setTextAlign(horizontalAlign, verticalAlign)
    if horizontalAlign or verticalAlign then
        self:setStyle(TextBox.STYLE_TEXT_ALIGN, {horizontalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(TextBox.STYLE_TEXT_ALIGN, nil)
    end
    self:invalidate()
end

---
-- Returns the text align.
-- @return horizontal align(left, center, top)
-- @return vertical align(top, center, bottom)
function TextBox:getTextAlign()
    return unpack(self:getStyle(TextBox.STYLE_TEXT_ALIGN))
end

---
-- Returns the text align for MOAITextBox.
-- @return horizontal align
-- @return vertical align
function TextBox:getAlignment()
    local h, v = self:getTextAlign()
    h = assert(TextAlign[h])
    v = assert(TextAlign[v])
    return h, v
end

---
-- Sets the text align.
-- @param red red(0 ... 1)
-- @param green green(0 ... 1)
-- @param blue blue(0 ... 1)
-- @param alpha alpha(0 ... 1)
function TextBox:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(TextBox.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(TextBox.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

---
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
function TextBox:getTextColor()
    return unpack(self:getStyle(TextBox.STYLE_TEXT_COLOR))
end

---
-- Set textbox padding by label's setRect method, it will set 4 direction padding
-- @param left padding for left
-- @param top padding for top
-- @param right padding for right
-- @param bottom padding for bottom
function TextBox:setTextPadding(left, top, right, bottom)
    self:setStyle(TextBox.STYLE_TEXT_PADDING, {left or 0, top or 0, right or 0, bottom or 0})
    self:invalidate()
end

---
-- Returns the text padding.
-- @return padding for left
-- @return padding for top
-- @return padding for right
-- @return padding for bottom
function TextBox:getTextPadding()
    return unpack(self:getStyle(TextBox.STYLE_TEXT_PADDING))
end

return TextBox