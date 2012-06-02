local table = require("hp/lang/table")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")

----------------------------------------------------------------
-- 画面の操作をキャッチして、イベントを発出するクラスです.
-- タッチ、キーボードの操作が該当します
-- @class table
-- @name InputManager
----------------------------------------------------------------

local M = EventDispatcher:new()
local pointer = {x = 0, y = 0, down = false}
local keyboard = {key = 0, down = false}
local touchEventStack = {}

local TOUCH_EVENTS = {}
TOUCH_EVENTS[MOAITouchSensor.TOUCH_DOWN] = Event.TOUCH_DOWN
TOUCH_EVENTS[MOAITouchSensor.TOUCH_UP] = Event.TOUCH_UP
TOUCH_EVENTS[MOAITouchSensor.TOUCH_MOVE] = Event.TOUCH_MOVE
TOUCH_EVENTS[MOAITouchSensor.TOUCH_CANCEL] = Event.TOUCH_CANCEL

----------------------------------------------------------------
-- タッチ処理
----------------------------------------------------------------
local function onTouch(eventType, idx, x, y, tapCount)
    -- event
    local event = Event(TOUCH_EVENTS[eventType], M)
    event.idx = idx
    event.x = x
    event.y = y
    event.moveX = 0
    event.moveY = 0
    event.tapCount = tapCount
    
    if eventType == MOAITouchSensor.TOUCH_DOWN then
        touchEventStack[idx] = event
    elseif eventType == MOAITouchSensor.TOUCH_UP then
        touchEventStack[idx] = nil
    elseif eventType == MOAITouchSensor.TOUCH_MOVE then
        local oldEvent = touchEventStack[idx]
        event.moveX = event.x - oldEvent.x
        event.moveY = event.y - oldEvent.y
        touchEventStack[idx] = event
    elseif eventType == MOAITouchSensor.TOUCH_CANCEL then
        touchEventStack[idx] = nil
    end

    M:dispatchEvent(event)
end

----------------------------------------------------------------
-- ポインター処理
----------------------------------------------------------------
local function onPointer(x, y)
    pointer.x = x
    pointer.y = y

    if pointer.down then
        onTouch(MOAITouchSensor.TOUCH_MOVE, 1, x, y, 1)
    end
end

---------------------------------------
-- マウスクリック処理
---------------------------------------
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

---------------------------------------
-- キーボード入力時のイベント処理です.
---------------------------------------
local function onKeyboard(key, down)
    keyboard.key = key
    keyboard.down = down
    
    local etype = down and Event.KEY_DOWN or Event.KEY_UP
    local event = Event:new(etype, M)
    event.key = key

    M:dispatchEvent(event)
end

---------------------------------------
-- 初期化処理です
---------------------------------------
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

return M
