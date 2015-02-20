----------------------------------------------------------------------------------------------------
-- This singleton class manages all input events (touch, key, cursor).
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.EventDispatcher.html">EventDispatcher</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Config = require "flower.Config"
local Event = require "flower.Event"
local EventDispatcher = require "flower.EventDispatcher"

-- class
local InputMgr = EventDispatcher()

-- Sensors
local pointerSensor = MOAIInputMgr.device.pointer
local mouseLeftSensor = MOAIInputMgr.device.mouseLeft
local mouseRightSensor = MOAIInputMgr.device.mouseRight
local mouseMiddleSensor = MOAIInputMgr.device.mouseMiddle
local mouseWheelSensor = MOAIInputMgr.device.mouseWheel
local touchSensor = MOAIInputMgr.device.touch
local keyboardSensor = MOAIInputMgr.device.keyboard

-- Touch Event
local TOUCH_EVENT = Event()

-- Keyboard Event
local KEYBOARD_EVENT = Event()

-- Mouse Event
local MOUSE_EVENT = Event()

-- Mouse Wheel Event
local MOUSE_WHEEL_EVENT = Event()

-- Touch Event Kinds
local TOUCH_EVENT_KINDS = {
    [MOAITouchSensor.TOUCH_DOWN]    = Event.TOUCH_DOWN,
    [MOAITouchSensor.TOUCH_UP]      = Event.TOUCH_UP,
    [MOAITouchSensor.TOUCH_MOVE]    = Event.TOUCH_MOVE,
    [MOAITouchSensor.TOUCH_CANCEL]  = Event.TOUCH_CANCEL,
}

-- mouse pointer data
InputMgr.pointer = {x = 0, y = 0, leftDown = false, rightDown = false, middleDown = false}

---
-- Initialize.
-- Called by openWindow function.
function InputMgr:initialize()

    -- Touch Handler
    local onTouch = function(eventType, idx, x, y, tapCount)
        local event = TOUCH_EVENT
        event.type = TOUCH_EVENT_KINDS[eventType]
        event.idx = idx
        event.x = x
        event.y = y
        event.tapCount = tapCount

        self:dispatchEvent(event)
    end

    -- Mouse Pointer Handler
    local onPointer = function(x, y)
        self.pointer.x = x
        self.pointer.y = y

        -- touch event
        if Config.TOUCH_EVENT_ENABLED and self.pointer.leftDown then
            onTouch(MOAITouchSensor.TOUCH_MOVE, 1, x, y, 1)
        end

        -- mouse event
        if Config.MOUSE_EVENT_ENABLED then
            local event = MOUSE_EVENT
            event.type = Event.MOUSE_MOVE
            event.leftDown = self.pointer.leftDown
            event.rightDown = self.pointer.rightDown
            event.middleDown = self.pointer.middleDown
            event.x = x
            event.y = y
            self:dispatchEvent(event)
        end
    end

    -- Mouse left click handler
    local onLeftClick = function(down)
        self.pointer.leftDown = down

        -- touch event
        if Config.TOUCH_EVENT_ENABLED then
            local eventType = down and MOAITouchSensor.TOUCH_DOWN or MOAITouchSensor.TOUCH_UP
            onTouch(eventType, 1, self.pointer.x, self.pointer.y, 1)
        end

        -- mouse event
        if Config.MOUSE_EVENT_ENABLED then
            local event = MOUSE_EVENT
            event.type = Event.MOUSE_CLICK
            event.x = self.pointer.x
            event.y = self.pointer.y
            event.down = down
            self:dispatchEvent(event)
        end
    end

    -- Mouse right Click Handler
    local onRightClick = function(down)
        self.pointer.rightDown = down

        -- mouse event
        if Config.MOUSE_EVENT_ENABLED then
            local event = MOUSE_EVENT
            event.type = Event.MOUSE_RIGHT_CLICK
            event.x = self.pointer.x
            event.y = self.pointer.y
            event.down = down
            self:dispatchEvent(event)
        end
    end

    -- Middle Click Handler
    local onMiddleClick = function(down)
        self.pointer.middleDown = down

        -- mouse event
        if Config.MOUSE_EVENT_ENABLED then
            local event = MOUSE_EVENT
            event.type = Event.MOUSE_MIDDLE_CLICK
            event.x = self.pointer.x
            event.y = self.pointer.y
            event.down = down
            self:dispatchEvent(event)
        end
    end

    -- Mouse Wheel Handler
    local onMouseWheel = function(yDelta)

        -- mouse event
        if Config.MOUSE_EVENT_ENABLED then
            local event = MOUSE_WHEEL_EVENT
            event.type = Event.MOUSE_WHEEL
            event.yDelta = yDelta
            event.x = self.pointer.x
            event.y = self.pointer.y
            self:dispatchEvent(event)
        end
    end

    -- Keyboard Handler
    local onKeyboard = function(key, down)
        local event = KEYBOARD_EVENT
        event.type = down and Event.KEY_DOWN or Event.KEY_UP
        event.key = key
        event.down = down

        self:dispatchEvent(event)
    end

    -- mouse input
    if pointerSensor then
        pointerSensor:setCallback(onPointer)
    end
    if mouseLeftSensor then
        mouseLeftSensor:setCallback(onLeftClick)
    end
    if mouseRightSensor then
        mouseRightSensor:setCallback(onRightClick)
    end
    if mouseMiddleSensor then
        mouseMiddleSensor:setCallback(onMiddleClick)
    end
    if mouseWheelSensor then
        mouseWheelSensor:setCallback(onMouseWheel)
    end
    -- touch input
    if touchSensor then
        touchSensor:setCallback(onTouch)
    end

    -- keyboard input
    if keyboardSensor then
        keyboardSensor:setCallback(onKeyboard)
    end
end

---
-- If the user has pressed a key returns true.
-- @param key Key code
-- @return true is a key is down.
function InputMgr:keyIsDown(key)
    if keyboardSensor then
        return keyboardSensor:keyIsDown(key)
    end
end

---
-- Returns true if you are down on the left side of the mouse.
-- @return true or false
function InputMgr:isMouseLeftDown()
    return InputMgr.pointer.leftDown
end

---
-- Returns true if you are down on the middle side of the mouse.
-- @return true or false
function InputMgr:isMouseMiddleDown()
    return InputMgr.pointer.middleDown
end

---
-- Returns true if you are down on the left side of the mouse.
-- @return true or false
function InputMgr:isMouseRightDown()
    return InputMgr.pointer.rightDown
end

---
-- Returns the position of the mouse
-- @return x-position, y-position
function InputMgr:getMousePoint()
    return InputMgr.pointer.x, InputMgr.pointer.y
end

---
-- Checks to see if the touch status is currently down.
-- @param idx Index of touch to check.
-- @return isDown
function InputMgr:isTouchDown(idx)
    if touchSensor then
        return touchSensor:isDown(idx)
    end
end

---
-- Checks to see if there are currently touches being made on the screen.
-- @return hasTouches
function InputMgr:hasTouches()
    if touchSensor then
        return touchSensor:hasTouches()
    end
end

---
-- Returns the touch data with the specified ID.
-- @param idx The ID of the touch.
-- @return x, y, tapCount
function InputMgr:getTouch(idx)
    if touchSensor then
        return touchSensor:getTouch(idx)
    end
end

---
-- Returns the IDs of all of the touches currently occurring (for use with getTouch).
-- @return idx1, idx2, ..., idxN
function InputMgr:getActiveTouches()
    if touchSensor then
        return touchSensor:getActiveTouches()
    end
end

InputMgr:initialize()

return InputMgr
