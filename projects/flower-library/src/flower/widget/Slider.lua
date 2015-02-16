----------------------------------------------------------------------------------------------------
-- This class is an slider that can be pressed and dragged.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Image = require "flower.core.Image"
local NineImage = require "flower.core.NineImage"
local UIEvent = require "flower.widget.UIEvent"
local UIComponent = require "flower.widget.UIComponent"

-- class
local Slider = class(UIComponent)

--- Style: backgroundTexture
Slider.STYLE_BACKGROUND_TEXTURE = "backgroundTexture"

--- Style: progressTexture
Slider.STYLE_PROGRESS_TEXTURE = "progressTexture"

--- Style: thumbTexture
Slider.STYLE_THUMB_TEXTURE = "thumbTexture"

---
-- Initializes the internal variables.
function Slider:_initInternal()
    Slider.__super._initInternal(self)
    self._themeName = "Slider"
    self._touchDownIdx = nil
    self._backgroundImage = nil
    self._progressImage = nil
    self._thumbImage = nil
    self._minValue = 0.0
    self._maxValue = 1.0
    self._currValue = 0.4
end

---
-- Initializes the event listener.
function Slider:_initEventListeners()
    Slider.__super._initEventListeners(self)
    self:addEventListener(UIEvent.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(UIEvent.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(UIEvent.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(UIEvent.TOUCH_CANCEL, self.onTouchCancel, self)
end

---
-- Create children.
function Slider:_createChildren()
    Slider.__super._createChildren(self)
    self:_createBackgroundImage()
    self:_createProgressImage()
    self:_createThumbImage()
end

---
-- Create the backgroundImage.
function Slider:_createBackgroundImage()
    if self._backgroundImage then
        return
    end
    self._backgroundImage = NineImage(self:getStyle(Slider.STYLE_BACKGROUND_TEXTURE))
    self:addChild(self._backgroundImage)
end

---
-- Create the progressImage.
function Slider:_createProgressImage()
    if self._progressImage then
        return
    end
    self._progressImage = NineImage(self:getStyle(Slider.STYLE_PROGRESS_TEXTURE))
    self:addChild(self._progressImage)
end

---
-- Create the progressImage.
function Slider:_createThumbImage()
    if self._thumbImage then
        return
    end
    self._thumbImage = Image(self:getStyle(Slider.STYLE_THUMB_TEXTURE))
    self:addChild(self._thumbImage)
end

---
-- Update the display.
function Slider:updateDisplay()
    Slider.__super.updateDisplay(self)
    self:updateBackgroundImage()
    self:updateProgressImage()
end

---
-- Update the backgroundImage.
function Slider:updateBackgroundImage()
    local width = self:getWidth()
    local height = self._backgroundImage:getHeight()
    self._backgroundImage:setSize(width, height)
end

---
-- Update the progressImage.
function Slider:updateProgressImage()
    local width = self:getWidth()
    local height = self._progressImage:getHeight()
    self._progressImage:setSize(width * (self._currValue / self._maxValue), height)
    self._thumbImage:setLoc(width * (self._currValue / self._maxValue), height / 2)
end

---
-- Set the value of the current.
-- @param value value of the current
function Slider:setValue(value)
    if self._currValue == value then
        return
    end

    self._currValue = value
    self:updateProgressImage()
    self:dispatchEvent(UIEvent.VALUE_CHANGED, self._currValue)
end

---
-- Return the value of the current.
-- @return value of the current
function Slider:getValue()
    return self._currValue
end

---
-- Sets the background texture.
-- @param texture texture
function Slider:setBackgroundTexture(texture)
    self:setStyle(Slider.STYLE_BACKGROUND_TEXTURE, texture)
    self._backgroundImage:setImage(self:getStyle(Slider.STYLE_BACKGROUND_TEXTURE))
end

---
-- Sets the progress texture.
-- @param texture texture
function Slider:setProgressTexture(texture)
    self:setStyle(Slider.STYLE_PROGRESS_TEXTURE, texture)
    self._progressImage:setImage(self:getStyle(Slider.STYLE_PROGRESS_TEXTURE))
end

---
-- Sets the thumb texture.
-- @param texture texture
function Slider:setThumbTexture(texture)
    self:setStyle(Slider.STYLE_THUMB_TEXTURE, texture)
    self._thumbImage:setTexture(self:getStyle(Slider.STYLE_THUMB_TEXTURE))
end

---
-- Set the event listener that is called when the user click the Slider.
-- @param func click event handler
function Slider:setOnValueChanged(func)
    self:setEventListener(UIEvent.VALUE_CHANGED, func)
end

---
-- Down the Slider.
-- There is no need to call directly to the basic.
-- @param worldX Touch worldX
function Slider:doSlide(worldX)
    local width = self:getWidth()
    local left = self:getLeft()
    local modelX = worldX - left

    modelX = math.min(modelX, width)
    modelX = math.max(modelX, 0)
    self:setValue(modelX / width)
end

---
-- This event handler is called when you touch the Slider.
-- @param e Touch Event
function Slider:onTouchDown(e)
    if self._touchDownIdx then
        return
    end

    self._touchDownIdx = e.idx
    self:doSlide(e.wx)
end

---
-- This event handler is called when the Slider is released.
-- @param e Touch Event
function Slider:onTouchUp(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil
    self:doSlide(e.wx)
end

---
-- This event handler is called when you move on the Slider.
-- @param e Touch Event
function Slider:onTouchMove(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    if self:inside(e.wx, e.wy, 0) then
        self:doSlide(e.wx)
    end
end

---
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
function Slider:onTouchCancel(e)
    if self._touchDownIdx ~= e.idx then
        return
    end
    self._touchDownIdx = nil
    self:doSlide(e.wx)
end

return Slider