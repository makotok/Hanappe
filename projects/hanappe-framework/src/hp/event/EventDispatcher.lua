--------------------------------------------------------------------------------
-- This class is has a function of event notification.
-- 
--------------------------------------------------------------------------------

local class = require("hp/lang/class")
local Event = require("hp/event/Event")
local EventListener = require("hp/event/EventListener")

local M = class()

local EVENT_CACHE = {}

--------------------------------------------------------------------------------
-- The constructor.
-- @param eventType (option)The type of event.
--------------------------------------------------------------------------------
function M:init()
    self.eventlisteners = {}
end

--------------------------------------------------------------------------------
-- Adds an event listener. <br>
-- will now catch the events that are sent in the dispatchEvent. <br>
-- @param eventType Target event type.
-- @param callback The callback function.
-- @param source (option)The first argument passed to the callback function.
-- @param priority (option)Notification order.
--------------------------------------------------------------------------------
function M:addEventListener(eventType, callback, source, priority)
    assert(eventType)
    assert(callback)

    if self:hasEventListener(eventType, callback, source) then
        return false
    end

    local listener = EventListener(eventType, callback, source, priority)

    for i, v in ipairs(self.eventlisteners) do
        if listener.priority < v.priority then
            table.insert(self.eventlisteners, i, listener)
            return true
        end
    end

    table.insert(self.eventlisteners, listener)
    return true
end

--------------------------------------------------------------------------------
-- Removes an event listener.
--------------------------------------------------------------------------------
function M:removeEventListener(eventType, callback, source)
    assert(eventType)
    assert(callback)
    
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == eventType and obj.callback == callback and obj.source == source then
            table.remove(self.eventlisteners, key)
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Returns true if you have an event listener. <br>
-- @return Returns true if you have an event listener.
--------------------------------------------------------------------------------
function M:hasEventListener(eventType, callback, source)
    assert(eventType)
    
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == eventType then
            if callback or source then
                if obj.callback == callback and obj.source == source then
                    return true
                end
            else
                return true
            end
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- Dispatches the event.
--------------------------------------------------------------------------------
function M:dispatchEvent(event, data)
    local eventName = type(event) == "string" and event
    if eventName then
        event = EVENT_CACHE[eventName] or Event(eventName)
        EVENT_CACHE[eventName] = nil
    end
    
    assert(event.type)

    event.data = data or event.data
    event.stoped = false
    event.target = self.eventTarget or self
    
    for key, obj in ipairs(self.eventlisteners) do
        if obj.type == event.type then
            event:setListener(obj.callback, obj.source)
            obj:call(event)
            if event.stoped == true then
                break
            end
        end
    end
    
    if eventName then
        EVENT_CACHE[eventName] = event
    end
end

--------------------------------------------------------------------------------
-- Remove all event listeners.
--------------------------------------------------------------------------------
function M:clearEventListeners()
    self.eventlisteners = {}
end

return M