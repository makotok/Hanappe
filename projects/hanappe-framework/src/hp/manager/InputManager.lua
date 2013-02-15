--------------------------------------------------------------------------------
-- To catch the operation of the screen, and sends the event. <br>
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")

local M = EventDispatcher()
local pointer = {x = 0, y = 0, down = false}
local keyboard = {key = 0, down = false}
local touchEventStack = {}

local TOUCH_EVENTS = {}
TOUCH_EVENTS[MOAITouchSensor.TOUCH_DOWN] = Event.TOUCH_DOWN
TOUCH_EVENTS[MOAITouchSensor.TOUCH_UP] = Event.TOUCH_UP
TOUCH_EVENTS[MOAITouchSensor.TOUCH_MOVE] = Event.TOUCH_MOVE
TOUCH_EVENTS[MOAITouchSensor.TOUCH_CANCEL] = Event.TOUCH_CANCEL

local function onTouch(eventType, idx, x, y, tapCount)
    -- event
    local event = touchEventStack[idx] or Event(TOUCH_EVENTS[eventType], M)
    local oldX, oldY = event.x, event.y
    event.type = TOUCH_EVENTS[eventType]
    event.idx = idx
    event.x = x
    event.y = y
    event.tapCount = tapCount
    
    if eventType == MOAITouchSensor.TOUCH_DOWN then
        touchEventStack[idx] = event
    elseif eventType == MOAITouchSensor.TOUCH_UP then
        touchEventStack[idx] = nil
    elseif eventType == MOAITouchSensor.TOUCH_MOVE then
        if oldX == nil or oldY == nil then
            return
        end
        event.moveX = event.x - oldX
        event.moveY = event.y - oldY
        touchEventStack[idx] = event
    elseif eventType == MOAITouchSensor.TOUCH_CANCEL then
        touchEventStack[idx] = nil
    end

    M:dispatchEvent(event)
end

local function onPointer(x, y)
    pointer.x = x
    pointer.y = y

    if pointer.down then
        onTouch(MOAITouchSensor.TOUCH_MOVE, 1, x, y, 1)
    end
end

local function onClick(down)
    pointer.down = down

    local eventType = nil
    if down then
        eventType = MOAITouchSensor.TOUCH_DOWN
    else
        eventType = MOAITouchSensor.TOUCH_UP
    end
    
    onTouch(eventType, 1, pointer.x, pointer.y, 1)
end

local function onKeyboard(key, down)
    keyboard.key = key
    keyboard.down = down
    
    local etype = down and Event.KEY_DOWN or Event.KEY_UP
    local event = Event:new(etype, M)
    event.key = key

    M:dispatchEvent(event)
end

--------------------------------------------------------------------------------
-- Initialize InputManager. <br>
-- Register a callback function for input operations.
--------------------------------------------------------------------------------
function M:initialize()
    -- コールバック関数の登録
    if MOAIInputMgr.device.pointer then
        -- mouse input
        MOAIInputMgr.device.pointer:setCallback(onPointer)
        MOAIInputMgr.device.mouseLeft:setCallback(onClick)
    else
        -- touch input
        MOAIInputMgr.device.touch:setCallback(onTouch)
    end

    -- keyboard input
    if MOAIInputMgr.device.keyboard then
        MOAIInputMgr.device.keyboard:setCallback(onKeyboard)
    end
end

function M:isKeyDown(key)
    if MOAIInputMgr.device.keyboard then
        return MOAIInputMgr.device.keyboard:keyIsDown(key)
    end
end

return M
