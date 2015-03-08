----------------------------------------------------------------------------------------------------
-- Custom events, that can be trigerred from animations. 
-- Add event listeners to the skeleton. Event type is event name in spine. 
----------------------------------------------------------------------------------------------------

-- imports
local class = require "flower.class"
local table = require "flower.table"
local Event = require "flower.Event"

-- class
local SpineEvent = class(Event)

---
-- Initializes event with spine data
-- @param name event name
-- @param eventData parameters table. Fields: (int, float, string)
function SpineEvent:init(name, eventData)
    SpineEvent.__super.init(self, name)

    self.name = name
    self._data = eventData
end

return SpineEvent