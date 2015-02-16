----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Event = require "flower.core.Event"

-- class
local CommandEvent = class(Event)

--- commandComplete
CommandEvent.COMMAND_COMPLETE = "commandComplete"

--- commandAbort
CommandEvent.COMMAND_ABORT = "commandAbort"

return CommandEvent