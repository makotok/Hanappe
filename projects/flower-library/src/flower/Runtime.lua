----------------------------------------------------------------------------------------------------
-- This is a utility class which starts immediately upon library load
-- and acts as the single handler for ENTER_FRAME events (which occur
-- whenever Moai yields control to the Lua subsystem on each frame).
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
local Event = require "flower.Event"
local EventDispatcher = require "flower.EventDispatcher"
local Executors = require "flower.Executors"

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