--------------------------------------------------------------------------------
-- This class is an event listener.
-- Framework will be used internally.
--------------------------------------------------------------------------------

local class = require("hp/lang/class")
local Event = require("hp/event/Event")

local M = class()

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority and priority or Event.PRIORITY_DEFAULT
end

--------------------------------------------------------------------------------
-- Call source function
--------------------------------------------------------------------------------
function M:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

return M
