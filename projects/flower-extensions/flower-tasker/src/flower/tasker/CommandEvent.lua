----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Event = require "flower.Event"

-- class
local CommandEvent = class(Event)

--- commandComplete
CommandEvent.COMMAND_COMPLETE = "commandComplete"

--- commandAbort
CommandEvent.COMMAND_ABORT = "commandAbort"

return CommandEvent