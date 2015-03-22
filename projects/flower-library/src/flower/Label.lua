----------------------------------------------------------------------------------------------------
-- Label for text display.
-- Based on MOAITextBox.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.DisplayObject.html">DisplayObject</a><l/i>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_text_box.html">MOAITextBox</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Config = require "flower.Config"
local Resources = require "flower.Resources"
local DisplayObject = require "flower.DisplayObject"
local Font = require "flower.Font"

-- class
local Label = class(DisplayObject)
Label.__index = MOAITextBox.getInterfaceTable()
Label.__moai_class = MOAITextBox

---
-- Constructor.
-- @param text Text
-- @param width (option)Width
-- @param height (option)Height
-- @param font (option) ont path, or Font object
-- @param textSize (option) TextSize
function Label:init(text, width, height, font, textSize)
    Label.__super.init(self)

    self.highQualityEnabled = Config.LABEL_HIGH_QUALITY_ENABLED
    self.contentScale = self.highQualityEnabled and Config.VIEW_SCALE or 1
    self.textSize = textSize or Config.FONT_POINTS

    self:setFont(font)
    self:setSize(width or 10, height or 10)
    self:setTextSize(self.textSize)
    self:setTextScale(1 / self.contentScale)
    self:setString(text)
    self:setYFlip(Config.VIEWPORT_YFLIP)

    if not width or not height then
        self:fitSize(#text)
    end
end

---
-- Sets the size.
-- @param width Width
-- @param height Height
function Label:setSize(width, height)
    -- TODO:In order to bug occurs V1.6, always be set in the center.
    local left, top = self:getPos()
    self:setRect(math.floor(-width / 2), math.floor(-height / 2), math.floor(width / 2), math.floor(height / 2))
    self:setPos(left, top)
end

---
-- Sets the text size.
-- @param points points
-- @param dpi (Option)dpi
function Label:setTextSize(points, dpi)
    dpi = dpi or Config.FONT_DPI
    self.textSize = (points * dpi) / Config.FONT_DPI

    Label.__index.setTextSize(self, self.textSize * self.contentScale)
end

---
-- Sets the text scale.
-- @param scale scale
function Label:setTextScale(scale)
    local style = self:affirmStyle ()
    style:setScale(scale)
end

---
-- Sets the high quality of the drawing of the string.
-- This setting is meaningful when the scale of the Viewport does not match the screen.
-- @param enabled Set true to the high quality
-- @param contentScale (Option)Scale of the Viewport, which label is displayed.
function Label:setHighQuality(enabled, contentScale)
    contentScale = contentScale or M.viewScale
    self.highQualityEnabled = enabled
    self.contentScale = self.highQualityEnabled and contentScale or 1

    local style = self:affirmStyle ()
    style:setScale(self.contentScale)
    self:setTextSize(self.textSize)
end

-- V1.6 code compatibility of V1.5.
if MOAITextLabel then
    function Label:getStringBounds(index, length)
        local xMin, yMin, xMax, yMax = self:getTextBounds(index, length)
        if xMin == nil or yMin == nil or xMax == nil or yMax == nil then
            return xMin, yMin, xMax, yMax
        end

        local w2, h2 = math.floor(self:getWidth() / 2), math.floor(self:getHeight() / 2)
        xMin = xMin + w2
        yMin = yMin + h2
        xMax = xMax + w2
        yMax = yMax + h2
        return xMin, yMin, xMax, yMax
    end
end

---
-- Set the font.
-- @param font font or font path.
function Label:setFont(font)
    font = Resources.getFont(font, nil, self.textSize * self.contentScale)
    Label.__index.setFont(self, font)
end

---
-- Sets the fit size.
-- @param length (Option)Length of the text.
-- @param maxWidth (Option)maxWidth of the text.
-- @param maxHeight (Option)maxHeight of the text.
-- @param padding (Option)padding of the text.
function Label:fitSize(length, maxWidth, maxHeight, padding)
    length = length or Config.LABEL_MAX_FIT_LENGTH
    maxWidth = maxWidth or Config.LABEL_MAX_FIT_WIDTH
    maxHeight = maxHeight or Config.LABEL_MAX_FIT_HEIGHT
    padding = padding or Config.LABEL_FIT_PADDING

    self:setSize(maxWidth, maxHeight)
    local left, top, right, bottom = self:getStringBounds(1, length)
    left, top, right, bottom = left or 0, top or 0, right or 0, bottom or 0
    local width, height = right - left + padding, bottom - top + padding

    self:setSize(width, height)
end

---
-- Sets the fit height.
-- @param length (Option)Length of the text.
-- @param maxHeight (Option)maxHeight of the text.
-- @param padding (Option)padding of the text.
function Label:fitHeight(length, maxHeight, padding)
    self:fitSize(length, self:getWidth(), maxHeight, padding)
end

---
-- Sets the fit height.
-- @param length (Option)Length of the text.
-- @param maxWidth (Option)maxWidth of the text.
-- @param padding (Option)padding of the text.
function Label:fitWidth(length, maxWidth, padding)
    self:fitSize(length, maxWidth, self:getHeight(), padding)
end

return Label