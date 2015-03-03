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
local TextAlign = require "flower.widget.TextAlign"
local UIComponent = require "flower.widget.UIComponent"

-- class
local UILabel = class(UIComponent)

--- Style: fontName
UILabel.STYLE_FONT_NAME = "fontName"

--- Style: textSize
UILabel.STYLE_TEXT_SIZE = "textSize"

--- Style: textColor
UILabel.STYLE_TEXT_COLOR = "textColor"

--- Style: textSize
UILabel.STYLE_TEXT_ALIGN = "textAlign"

--- Style: textPadding
UILabel.STYLE_TEXT_PADDING = "textPadding"

--- Style: textResizePolicy
UILabel.STYLE_TEXT_RESIZE_POLICY = "textResizePolicy"

--- textResizePolicy : none
UILabel.RESIZE_POLICY_NONE = "none"

--- textResizePolicy : auto
UILabel.RESIZE_POLICY_AUTO = "auto"

---
-- Initialize a variables
function UILabel:_initInternal()
    UILabel.__super._initInternal(self)
    self._focusEnabled = false
    self._themeName = "UILabel"
    self._text = ""
    self._textLabel = nil
end

---
-- Create a children object.
function UILabel:_createChildren()
    UILabel.__super._createChildren(self)

    self._textLabel = Label(self._text)
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
end

---
-- Update the UILabel.
function UILabel:_updateLabel()
    self._textLabel:setString(self:getText())
    self._textLabel:setTextSize(self:getTextSize())
    self._textLabel:setColor(self:getTextColor())
    self._textLabel:setAlignment(self:getAlignment())
    self._textLabel:setFont(self:getFont())
end

---
-- Update the UILabel size.
function UILabel:_updateLabelSize()
    local widthPolicy, heightPolicy = self:getTextResizePolicy()
    local padLeft, padTop, padRight, padBottom = self:getTextPadding()

    if widthPolicy == "auto" and heightPolicy == "auto" then
        self:fitSize()
    elseif heightPolicy == "auto" then
        self:fitHeight()
    elseif widthPolicy == "auto" then
        self:fitWidth()
    elseif self:getWidth() == 0 and self:getHeight() == 0 then
        self:fitSize()
    else
        local textWidth = self:getWidth() - padLeft - padRight
        local textHeight = self:getHeight() - padTop - padBottom
        self._textLabel:setSize(textWidth, textHeight)
        self._textLabel:setPos(padLeft, padTop)
    end
end

---
-- Update the display objects.
function UILabel:updateDisplay()
    UILabel.__super.updateDisplay(self)
    self:_updateLabel()
    self:_updateLabelSize()
end

---
-- Sets the fit size.
-- @param length (Option)Length of the text.
-- @param maxWidth (Option)maxWidth of the text.
-- @param maxHeight (Option)maxHeight of the text.
-- @param padding (Option)padding of the text.
function UILabel:fitSize(length, maxWidth, maxHeight, padding)
    self._textLabel:fitSize(length, maxWidth, maxHeight, padding)

    local textWidth, textHeight = self:getLabel():getSize()
    local padLeft, padTop, padRight, padBottom = self:getTextPadding()
    local width, height = textWidth + padLeft + padRight, textHeight + padTop + padBottom

    self._textLabel:setPos(padLeft, padTop)
    self:setSize(width, height)
end

---
-- Sets the fit height.
-- @param length (Option)Length of the text.
-- @param maxHeight (Option)maxHeight of the text.
-- @param padding (Option)padding of the text.
function UILabel:fitHeight(length, maxHeight, padding)
    self:fitSize(length, self:getLabel():getWidth(), maxHeight, padding) 
end

---
-- Sets the fit height.
-- @param length (Option)Length of the text.
-- @param maxWidth (Option)maxWidth of the text.
-- @param padding (Option)padding of the text.
function UILabel:fitWidth(length, maxWidth, padding)
    self:fitSize(length, maxWidth, self:getLabel():getHeight(), padding) 
end

---
-- Return the label.
-- @return label
function UILabel:getLabel()
    return self._textLabel
end

---
-- Sets the text.
-- @param text text
function UILabel:setText(text)
    if self._text ~= text then
        self._text = text or ""
        self._textLabel:setString(self._text)
        self:invalidateDisplay()
    end
end

---
-- Adds the text.
-- @param text text
function UILabel:addText(text)
    self:setText(self._text .. text)
end

---
-- Returns the text.
-- @return text
function UILabel:getText()
    return self._text
end

---
-- Sets the size policy of label.
-- @param widthPolicy width policy
-- @param widthPolicy height policy
function UILabel:setTextResizePolicy(widthPolicy, heightPolicy)
    local oldWidthPolicy, oldHeightPolicy = self:getTextResizePolicy()
    if oldWidthPolicy ~= widthPolicy or oldHeightPolicy ~= heightPolicy then
        self:setStyle(UILabel.STYLE_TEXT_RESIZE_POLICY, {widthPolicy or "none", heightPolicy or "none"})
        self:invalidateDisplay()
    end
end

---
-- Returns the size policy of label.
-- @return width policy
-- @return height policy
function UILabel:getTextResizePolicy()
    return unpack(self:getStyle(UILabel.STYLE_TEXT_RESIZE_POLICY))
end

---
-- Sets the textSize.
-- @param textSize textSize
function UILabel:setTextSize(textSize)
    if self:getTextSize() ~= textSize then
        self:setStyle(UILabel.STYLE_TEXT_SIZE, textSize)
        self:invalidateDisplay()
    end
end

---
-- Returns the textSize.
-- @return textSize
function UILabel:getTextSize()
    return self:getStyle(UILabel.STYLE_TEXT_SIZE)
end

---
-- Sets the fontName.
-- @param fontName fontName
function UILabel:setFontName(fontName)
    if self:getFontName() ~= fontName then
        self:setStyle(UILabel.STYLE_FONT_NAME, fontName)
        self:invalidateDisplay()
    end
end

---
-- Returns the font name.
-- @return font name
function UILabel:getFontName()
    return self:getStyle(UILabel.STYLE_FONT_NAME)
end

---
-- Returns the font.
-- @return font
function UILabel:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

---
-- Sets the text align.
-- @param horizontalAlign horizontal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
function UILabel:setTextAlign(horizontalAlign, verticalAlign)
    local oldH, oldV = self:getTextAlign()
    if horizontalAlign or verticalAlign then
        self:setStyle(UILabel.STYLE_TEXT_ALIGN, {horizontalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(UILabel.STYLE_TEXT_ALIGN, nil)
    end
    local newH, newV = self:getTextAlign()

    if oldH ~= newH or oldV ~= newV then
        self:invalidateDisplay()
    end
end

---
-- Returns the text align.
-- @return horizontal align(left, center, top)
-- @return vertical align(top, center, bottom)
function UILabel:getTextAlign()
    return unpack(self:getStyle(UILabel.STYLE_TEXT_ALIGN))
end

---
-- Returns the text align for MOAITextBox.
-- @return horizontal align
-- @return vertical align
function UILabel:getAlignment()
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
function UILabel:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(UILabel.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(UILabel.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

---
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
function UILabel:getTextColor()
    return unpack(self:getStyle(UILabel.STYLE_TEXT_COLOR))
end

---
-- Set textbox padding by label's setRect method, it will set 4 direction padding
-- @param left padding for left
-- @param top padding for top
-- @param right padding for right
-- @param bottom padding for bottom
function UILabel:setTextPadding(left, top, right, bottom)
    local oldL, oldT, oldR, oldB = self:getTextPadding()
    self:setStyle(UILabel.STYLE_TEXT_PADDING, {left or 0, top or 0, right or 0, bottom or 0})
    local newL, newT, newR, newB = self:getTextPadding()

    if oldL ~= newL or oldT ~= newT or oldR ~= newR or oldB ~= newB then
        self:invalidateDisplay()
    end
end

---
-- Returns the text padding.
-- @return padding for left
-- @return padding for top
-- @return padding for right
-- @return padding for bottom
function UILabel:getTextPadding()
    return unpack(self:getStyle(UILabel.STYLE_TEXT_PADDING))
end

return UILabel