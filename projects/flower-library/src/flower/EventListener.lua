----------------------------------------------------------------------------------------------------
-- A virtual superclass for EventListeners.
-- Classes which inherit from this class become able to receive events.
-- Currently intended for internal use only.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"

-- class
local EventListener = class()

---
-- The constructor.
-- @param eventType The type of event.
-- @param callback The callback function.
-- @param source The source.
-- @param priority The priority.
function EventListener:init(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority or 0
end

---
-- Call the event listener.
-- @param event Event
function EventListener:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

return EventListener