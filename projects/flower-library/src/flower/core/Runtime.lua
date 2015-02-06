----------------------------------------------------------------------------------------------------
-- @type Runtime
--
-- This is a utility class which starts immediately upon library load
-- and acts as the single handler for ENTER_FRAME events (which occur
-- whenever Moai yields control to the Lua subsystem on each frame).
----------------------------------------------------------------------------------------------------

-- import
local Event = require "flower.core.Event"
local EventDispatcher = require "flower.core.EventDispatcher"
local Executors = require "flower.core.Executors"

-- class
local Runtime = EventDispatcher()

-- initialize
function Runtime:initialize()
    Executors.callLoop(self.onEnterFrame)
end

---
-- Returns whether the mobile execution environment.
-- @return True in the case of mobile.
function Runtime.isMobile()
    local brand = MOAIEnvironment.osBrand
    return brand == 'Android' or brand == 'iOS'
end

---
-- Returns whether the desktop execution environment.
-- @return True in the case of desktop.
function Runtime.isDesktop()
    return not Runtime.isMobile()
end

-- enter frame
function Runtime.onEnterFrame()
    Runtime:dispatchEvent(Event.ENTER_FRAME)
end

Runtime:initialize()

return Runtime