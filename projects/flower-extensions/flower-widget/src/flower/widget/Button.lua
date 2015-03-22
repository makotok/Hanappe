----------------------------------------------------------------------------------------------------
-- This class is an image that can be pressed.
-- It is a simple button.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.UIComponent.html">UIComponent</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local NineImage = require "flower.NineImage"
local Label = require "flower.Label"
local UIEvent = require "flower.widget.UIEvent"
local UIComponent = require "flower.widget.UIComponent"
local TextAlign = require "flower.widget.TextAlign"
local Resources = require "flower.Resources"

-- class
local Button = class(UIComponent)

--- Style: normalTexture
Button.STYLE_NORMAL_TEXTURE = "normalTexture"

--- Style: selectedTexture
Button.STYLE_SELECTED_TEXTURE = "selectedTexture"

--- Style: disabledTexture
Button.STYLE_DISABLED_TEXTURE = "disabledTexture"

--- Style: fontName
Button.STYLE_FONT_NAME = "fontName"

--- Style: textSize
Button.STYLE_TEXT_SIZE = "textSize"

--- Style: textColor
Button.STYLE_TEXT_COLOR = "textColor"

--- Style: textAlign
Button.STYLE_TEXT_ALIGN = "textAlign"

--- Style: textPadding
Button.STYLE_TEXT_PADDING = "textPadding"

--- Event: selectedChanged
Button.EVENT_SELECTED_CHANGED = UIEvent.SELECTED_CHANGED

--- Event: down
Button.EVENT_DOWN = UIEvent.DOWN

--- Event: up
Button.EVENT_UP = UIEvent.DOWN

--- Event: click
Button.EVENT_CLICK = UIEvent.CLICK

--- Event: cancel
Button.EVENT_CANCEL = UIEvent.CANCEL

---
-- Initializes the internal variables.
function Button:_initInternal()
    Button.__super._initInternal(self)
    self._themeName = "Button"
    self._touchDownIdx = nil
    self._buttonImage = nil
    self._text = ""
    self._textLabel = nil
    self._selected = false
    self._toggle = false
end

---
-- @private
-- Initializes the event listener.
function Button:_initEventListeners()
    Button.__super._initEventListeners(self)
    self:addEventListener(UIEvent.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(UIEvent.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(UIEvent.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(UIEvent.TOUCH_CANCEL, self.onTouchCancel, self)
    self:addEventListener(UIEvent.SELECTED_CHANGED, self.onSelectedChanged, self)
end

---
-- Create children.
function Button:_createChildren()
    Button.__super._createChildren(self)

    self:_createButtonImage()
    self:_createTextLabel()

    if self._buttonImage then
        self:setSize(self._buttonImage:getSize())
    end
end

---
-- Create the buttonImage.
function Button:_createButtonImage()
    if self._buttonImage then
        return
    end
    local imagePath = assert(self:getImagePath())
    self._buttonImage = NineImage(imagePath)
    self:addChild(self._buttonImage)
end

---
-- Create the textLabel.
function Button:_createTextLabel()
    if self._textLabel then
        return
    end
    self._textLabel = Label(self._text)
    self:addChild(self._textLabel)
end

---
-- Update the display.
function Button:updateDisplay()
    self:updateButtonImage()
    self:updateTextLabel()
end

---
-- Update the buttonImage.
function Button:updateButtonImage()
    local buttonImage = self._buttonImage
    buttonImage:setImage(self:getImagePath())
    buttonImage:setSize(self:getSize())
end

---
-- Update the buttonImage.
function Button:updateTextLabel()
    if not self._textLabel then
        return
    end

    local textLabel = self._textLabel
    local text = self:getText()
    local xMin, yMin, xMax, yMax = self:getLabelContentRect()
    local textWidth, textHeight = xMax - xMin, yMax - yMin
    textLabel:setSize(textWidth, textHeight)
    textLabel:setPos(xMin, yMin)
    textLabel:setString(text)
    textLabel:setReveal(text and #text or 0)
    textLabel:setTextSize(self:getTextSize())
    textLabel:setColor(self:getTextColor())
    textLabel:setAlignment(self:getAlignment())
    textLabel:setFont(self:getFont())
end

---
-- Returns the image path.
-- @return imageDeck
function Button:getImagePath()
    if not self:isEnabled() then
        return self:getStyle(Button.STYLE_DISABLED_TEXTURE)
    elseif self:isSelected() then
        return self:getStyle(Button.STYLE_SELECTED_TEXTURE)
    else
        return self:getStyle(Button.STYLE_NORMAL_TEXTURE)
    end
end

---
-- Returns the label content rect.
-- @return content rect
function Button:getLabelContentRect()
    local buttonImage = self._buttonImage
    local paddingLeft, paddingTop, paddingRight, paddingBottom = self:getTextPadding()
    if buttonImage.getContentRect then
        local xMin, yMin, xMax, yMax = buttonImage:getContentRect()
        return xMin + paddingLeft, yMin + paddingTop, xMax - paddingRight, yMax - paddingBottom
    else
        local xMin, yMin, xMax, yMax = 0, 0, buttonImage:getSize()
        return xMin + paddingLeft, yMin + paddingTop, xMax - paddingRight, yMax - paddingBottom
    end
end

---
-- If the selected the button returns True.
-- @return If the selected the button returns True
function Button:isSelected()
    return self._selected
end

---
-- Sets the selected.
-- @param selected selected
function Button:setSelected(selected)
    if self._selected == selected then
        return
    end

    self._selected = selected
    self:updateButtonImage()
    self:dispatchEvent(UIEvent.SELECTED_CHANGED, selected)
end

---
-- Sets the toggle.
-- @param toggle toggle
function Button:setToggle(toggle)
    self._toggle = toggle
end

---
-- Returns the toggle.
-- @return toggle
function Button:isToggle()
    return self._toggle
end

---
-- Sets the normal texture.
-- @param texture texture
function Button:setNormalTexture(texture)
    self:setStyle(Button.STYLE_NORMAL_TEXTURE, texture)
    self:invalidateDisplay()
end

---
-- Sets the selected texture.
-- @param texture texture
function Button:setSelectedTexture(texture)
    self:setStyle(Button.STYLE_SELECTED_TEXTURE, texture)
    self:invalidateDisplay()
end

---
-- Sets the selected texture.
-- @param texture texture
function Button:setDisabledTexture(texture)
    self:setStyle(Button.STYLE_DISABLED_TEXTURE, texture)
    self:invalidateDisplay()
end

---
-- Sets the text.
-- @param text text
function Button:setText(text)
    self._text = text
    self._textLabel:setString(text)
    self._textLabel:setReveal(self._text and #self._text or 0)
end

---
-- Returns the text.
-- @return text
function Button:getText()
    return self._text
end

---
-- Sets the textSize.
-- @param textSize textSize
function Button:setTextSize(textSize)
    self:setStyle(Button.STYLE_TEXT_SIZE, textSize)
    self._textLabel:setTextSize(self:getTextSize())
end

---
-- Sets the textSize.
-- @param textSize textSize
function Button:getTextSize()
    return self:getStyle(Button.STYLE_TEXT_SIZE)
end

---
-- Sets the fontName.
-- @param fontName fontName
function Button:setFontName(fontName)
    self:setStyle(Button.STYLE_FONT_NAME, fontName)
    self._textLabel:setFont(self:getFont())
end

---
-- Sets the textSize.
-- @param textSize textSize
function Button:getFontName()
    return self:getStyle(Button.STYLE_FONT_NAME)
end

---
-- Returns the font.
-- @return font
function Button:getFont()
    local fontName = self:getFontName()
    local font = Resources.getFont(fontName, nil, self:getTextSize())
    return font
end

---
-- Sets the text align.
-- @param horizontalAlign horizontal align(left, center, top)
-- @param verticalAlign vertical align(top, center, bottom)
function Button:setTextAlign(horizontalAlign, verticalAlign)
    if horizontalAlign or verticalAlign then
        self:setStyle(Button.STYLE_TEXT_ALIGN, {horizontalAlign or "center", verticalAlign or "center"})
    else
        self:setStyle(Button.STYLE_TEXT_ALIGN, nil)
    end
    self._textLabel:setAlignment(self:getAlignment())
end

---
-- Returns the text align.
-- @return horizontal align(left, center, top)
-- @return vertical align(top, center, bottom)
function Button:getTextAlign()
    return unpack(self:getStyle(Button.STYLE_TEXT_ALIGN))
end

---
-- Returns the text align for MOAITextBox.
-- @return horizontal align
-- @return vertical align
function Button:getAlignment()
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
function Button:setTextColor(red, green, blue, alpha)
    if red == nil and green == nil and blue == nil and alpha == nil then
        self:setStyle(Button.STYLE_TEXT_COLOR, nil)
    else
        self:setStyle(Button.STYLE_TEXT_COLOR, {red or 0, green or 0, blue or 0, alpha or 0})
    end
    self._textLabel:setColor(self:getTextColor())
end

---
-- Returns the text color.
-- @return red(0 ... 1)
-- @return green(0 ... 1)
-- @return blue(0 ... 1)
-- @return alpha(0 ... 1)
function Button:getTextColor()
    return unpack(self:getStyle(Button.STYLE_TEXT_COLOR))
end

---
-- Sets the text padding.
-- @param paddingLeft padding left
-- @param paddingTop padding top
-- @param paddingRight padding right
-- @param paddingBottom padding bottom
function Button:setTextPadding(paddingLeft, paddingTop, paddingRight, paddingBottom)
    local style = {paddingLeft or 0, paddingTop or 0, paddingRight or 0, paddingBottom or 0}
    self:setStyle(Button.STYLE_TEXT_PADDING, style)
    if self._initialized then
        self:updateTextLabel()
    end
end

---
-- Returns the text padding.
-- @return paddingLeft
-- @return paddingTop
-- @return paddingRight
-- @return paddingBottom
function Button:getTextPadding()
    local padding = self:getStyle(Button.STYLE_TEXT_PADDING)
    if padding then
        return unpack(padding)
    end
    return 0, 0, 0, 0
end

---
-- Set the event listener that is called when the user click the button.
-- @param func click event handler
function Button:setOnClick(func)
    self:setEventListener(UIEvent.CLICK, func)
end

---
-- Set the event listener that is called when the user pressed the button.
-- @param func button down event handler
function Button:setOnDown(func)
    self:setEventListener(UIEvent.DOWN, func)
end

---
-- Set the event listener that is called when the user released the button.
-- @param func button up event handler
function Button:setOnUp(func)
    self:setEventListener(UIEvent.UP, func)
end

---
-- Set the event listener that is called when selected changed.
-- @param func selected changed event handler
function Button:setOnSelectedChanged(func)
    self:setEventListener(UIEvent.SELECTED_CHANGED, func)
end

---
-- This event handler is called when enabled Changed.
-- @param e Touch Event
function Button:onEnabledChanged(e)
    Button.__super.onEnabledChanged(self, e)
    self:updateButtonImage()

    if not self:isEnabled() and not self:isToggle() then
        self:setSelected(false)
    end
end

---
-- This event handler is called when selected changed.
-- @param e Touch Event
function Button:onSelectedChanged(e)
    if self:isSelected() then
        self:dispatchEvent(UIEvent.DOWN)
    else
        self:dispatchEvent(UIEvent.UP)
    end
end

---
-- This event handler is called when you touch the button.
-- @param e Touch Event
function Button:onTouchDown(e)
    if self._touchDownIdx ~= nil then
        return
    end
    self._touchDownIdx = e.idx

    if self:isToggle() then
        self._buttonImage:setColor(0.8, 0.8, 0.8, 1)
        return
    end

    if not self:isToggle() then
        self:setSelected(true)
    end
end

---
-- This event handler is called when the button is released.
-- @param e Touch Event
function Button:onTouchUp(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil

    if self:isToggle() then
        if self:inside(e.wx, e.wy, 0) then
            self:setSelected(not self:isSelected())
        end
        self._buttonImage:setColor(1, 1, 1, 1)
        return
    end

    if self:isSelected() then
        self:setSelected(false)
        self:dispatchEvent(UIEvent.CLICK)
    else
        self:dispatchEvent(UIEvent.CANCEL)
    end
end

---
-- This event handler is called when you move on the button.
-- @param e Touch Event
function Button:onTouchMove(e)
    if self._touchDownIdx ~= e.idx then
        return
    end

    if self:isToggle() then
        return
    end

    self:setSelected(self:inside(e.wx, e.wy, 0))

end

---
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
function Button:onTouchCancel(e)
    if self._touchDownIdx ~= e.idx then
        return
    end

    self._touchDownIdx = nil

    if self:isToggle() then
        self._buttonImage:setColor(1, 1, 1, 1)
        return
    end

    self:setSelected(false)
    self:dispatchEvent(UIEvent.CANCEL)
end

return Button