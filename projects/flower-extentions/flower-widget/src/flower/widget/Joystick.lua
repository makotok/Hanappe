----------------------------------------------------------------------------------------------------
-- It is a virtual Joystick.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Image = require "flower.Image"
local InputMgr = require "flower.InputMgr"
local KeyCode = require "flower.KeyCode"
local UIEvent = require "flower.widget.UIEvent"
local UIComponent = require "flower.widget.UIComponent"

-- class
local Joystick = class(UIComponent)

--- Direction of the stick
Joystick.STICK_CENTER = "center"

--- Direction of the stick
Joystick.STICK_LEFT = "left"

--- Direction of the stick
Joystick.STICK_TOP = "top"

--- Direction of the stick
Joystick.STICK_RIGHT = "right"

--- Direction of the stick
Joystick.STICK_BOTTOM = "bottom"

--- Mode of the stick
Joystick.MODE_ANALOG = "analog"

--- Mode of the stick
Joystick.MODE_DIGITAL = "digital"

Joystick.DIRECTION_TO_KEY_CODE_MAP = {
    left = KeyCode.KEY_LEFT,
    top = KeyCode.KEY_UP,
    right = KeyCode.KEY_RIGHT,
    bottom = KeyCode.KEY_DOWN,
}

--- The ratio of the center
Joystick.RANGE_OF_CENTER_RATE = 0.5

--- Style: baseTexture
Joystick.STYLE_BASE_TEXTURE = "baseTexture"

--- Style: knobTexture
Joystick.STYLE_KNOB_TEXTURE = "knobTexture"

---
-- Initializes the internal variables.
function Joystick:_initInternal()
    Joystick.__super._initInternal(self)
    self._themeName = "Joystick"
    self._touchIndex = nil
    self._rangeOfCenterRate = Joystick.RANGE_OF_CENTER_RATE
    self._stickMode = Joystick.MODE_ANALOG
    self._changedEvent = UIEvent(UIEvent.STICK_CHANGED)
    self._keyInputDispatchEnabled = false
    self._keyEvent = nil
end

---
-- Initializes the event listener.
-- You must not be called directly.
function Joystick:_initEventListeners()
    Joystick.__super._initEventListeners(self)
    self:addEventListener(UIEvent.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(UIEvent.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(UIEvent.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(UIEvent.TOUCH_CANCEL, self.onTouchCancel, self)
end

---
-- Initialize child objects that make up the Joystick.
-- You must not be called directly.
function Joystick:_createChildren()
    Joystick.__super._createChildren(self)

    self._baseImage = Image(self:getStyle(Joystick.STYLE_BASE_TEXTURE))
    self._knobImage = Image(self:getStyle(Joystick.STYLE_KNOB_TEXTURE))

    self:addChild(self._baseImage)
    self:addChild(self._knobImage)

    self:setSize(self._baseImage:getSize())
    self:setCenterKnob()
end

---
-- Update the display.
function Joystick:updateDisplay()
    self._baseImage:setTexture(self:getStyle(Joystick.STYLE_BASE_TEXTURE))
    self._knobImage:setTexture(self:getStyle(Joystick.STYLE_KNOB_TEXTURE))
end

---
-- To update the position of the knob.
-- @param x The x-position of the knob
-- @param y The y-position of the knob
function Joystick:updateKnob(x, y)
    local oldX, oldY = self._knobImage:getLoc()
    local newX, newY = self:getKnobNewLoc(x, y)

    if oldX ~= newX or oldY ~= newY then
        self._knobImage:setLoc(newX, newY, 0)

        local e = self._changedEvent
        e.oldX, e.oldY = self:getKnobInputRate(oldX, oldY)
        e.newX, e.newY = self:getKnobInputRate(newX, newY)
        e.direction = self:getStickDirection()
        e.down = self._touchDownFlag
        self:dispatchEvent(e)

        if self._keyInputDispatchEnabled then
            self:dispatchKeyEvent(e.direction)
        end
    end
end

---
-- Set the position of the center of the knob.
function Joystick:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobImage:setLoc(cx, cy, 0)
end

---
-- Returns the position of the center of the whole.
-- Does not depend on the Pivot.
-- @return Center x-position
-- @return Center y-position
function Joystick:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

---
-- Returns the position that matches the mode of the stick.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
function Joystick:getKnobNewLoc(x, y)
    if self:getStickMode() == Joystick.MODE_ANALOG then
        return self:getKnobNewLocForAnalog(x, y)
    else
        return self:getKnobNewLocForDigital(x, y)
    end
end

---
-- Returns the position to match the analog mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
function Joystick:getKnobNewLocForAnalog(x, y)
    local cx, cy = self:getCenterLoc()
    local rx, ry = (x - cx), (y - cy)
    local radian = math.atan2(math.abs(ry), math.abs(rx))
    local maxX, maxY =  math.cos(radian) * cx + cx,  math.sin(radian) * cy + cy
    local minX, minY = -math.cos(radian) * cx + cx, -math.sin(radian) * cy + cy

    x = x < minX and minX or x
    x = x > maxX and maxX or x
    y = y < minY and minY or y
    y = y > maxY and maxY or y

    return x, y
end

---
-- Returns the position to match the digital mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
function Joystick:getKnobNewLocForDigital(x, y)
    local cx, cy = self:getCenterLoc()
    local rx, ry = (x - cx), (y - cy)
    local radian = math.atan2(math.abs(ry), math.abs(rx))
    local minX, minY = 0, 0
    local maxX, maxY = self:getSize()
    local cRate = self._rangeOfCenterRate
    local cMinX, cMinY = cx - cx * cRate, cy - cy * cRate
    local cMaxX, cMaxY = cx + cx * cRate, cy + cy * cRate

    if cMinX < x and x < cMaxX and cMinY < y and y < cMaxY then
        x = cx
        y = cy
    elseif math.cos(radian) > math.sin(radian) then
        x = x < cx and minX or maxX
        y = cy
    else
        x = cx
        y = y < cy and minY or maxY
    end
    return x, y
end

---
-- Returns the percentage of input.
-- @param x X-position
-- @param y Y-position
-- @return X-ratio(-1 <= x <= 1)
-- @return Y-ratio(-1 <= y <= 1)
function Joystick:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

---
-- Returns the direction of the stick.
-- @return direction
function Joystick:getStickDirection()
    local x, y = self._knobImage:getLoc()
    local cx, cy = self:getCenterLoc()
    local radian = math.atan2(math.abs(x - cx), math.abs(y - cy))

    local dir
    if x == cx and y == cy then
        dir = Joystick.STICK_CENTER
    elseif math.cos(radian) < math.sin(radian) then
        dir = x < cx and Joystick.STICK_LEFT or Joystick.STICK_RIGHT
    else
        dir = y < cy and Joystick.STICK_TOP or Joystick.STICK_BOTTOM
    end
    return dir
end

---
-- Returns the stick mode
-- @return stick mode
function Joystick:getStickMode()
    return self._stickMode
end

---
-- Set the mode of the stick.
-- @param mode mode("analog" or "digital")
function Joystick:setStickMode(mode)
    self._stickMode = mode
end

---
-- Set the keyInputDispatchEnabled
-- @param value true or false
function Joystick:setKeyInputDispatchEnabled(value)
    self._keyInputDispatchEnabled = value
end

---
-- Returns the touched.
-- @return stick mode
function Joystick:isTouchDown()
    return self._touchIndex ~= nil
end

function Joystick:dispatchKeyEvent(direction)
    local key = Joystick.DIRECTION_TO_KEY_CODE_MAP[direction]

    if self._keyEvent and self._keyEvent.key ~= key then
        self._keyEvent.type = UIEvent.KEY_UP
        self._keyEvent.down = false
        InputMgr:dispatchEvent(self._keyEvent)
    end

    if key then
        self._keyEvent = self._keyEvent or UIEvent()
        self._keyEvent.type = UIEvent.KEY_DOWN
        self._keyEvent.down = true
        self._keyEvent.key = key
        InputMgr:dispatchEvent(self._keyEvent)
    else
        self._keyEvent = nil
    end
end

---
-- Set the event listener that is called when the stick changed.
-- @param func stickChanged event handler
function Joystick:setOnStickChanged(func)
    self:setEventListener(UIEvent.STICK_CHANGED, func)
end

---
-- This event handler is called when touched.
-- @param e Touch Event
function Joystick:onTouchDown(e)
    if self:isTouchDown() then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self._touchIndex = e.idx
    self:updateKnob(mx, my)
end

---
-- This event handler is called when the button is released.
-- @param e Touch Event
function Joystick:onTouchUp(e)
    if e.idx ~= self._touchIndex then
        return
    end

    self._touchIndex = nil
    local cx, cy = self:getCenterLoc()
    self:updateKnob(cx, cy)
end

---
-- This event handler is called when you move on the button.
-- @param e Touch Event
function Joystick:onTouchMove(e)
    if e.idx ~= self._touchIndex then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self:updateKnob(mx, my)
end

---
-- This event handler is called when you move on the button.
-- @param e Touch Event
function Joystick:onTouchCancel(e)
    self._touchIndex = nil
    self:setCenterKnob()
end

return Joystick