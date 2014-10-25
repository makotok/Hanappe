--------------------------------------------------------------------------------
-- The base class Event. <br>
-- Holds the data of the Event. <br>
--------------------------------------------------------------------------------

local class = require("hp/lang/class")

local M = class()

M.OPEN = "open"
M.CLOSE = "close"
M.ACTIVATE = "activate"
M.DEACTIVATE = "deactivate"
M.DOWN = "down"
M.UP = "up"
M.MOVE = "move"
M.CLICK = "click"
M.CANCEL = "cancel"
M.KEY_DOWN = "keyDown"
M.KEY_UP = "keyUp"
M.COMPLETE = "complete"
M.TOUCH_DOWN = "touchDown"
M.TOUCH_UP = "touchUp"
M.TOUCH_MOVE = "touchMove"
M.TOUCH_CANCEL = "touchCancel"
M.BUTTON_DOWN = "buttonDown"
M.BUTTON_UP = "buttonUp"
M.MOVE_STARTED = "moveStarted"
M.MOVE_FINISHED = "moveFinished"
M.MOVE_COLLISION = "moveCollision"
M.COLLISION = "collision"

M.PRIORITY_MIN = 0
M.PRIORITY_DEFAULT = 1000
M.PRIORITY_MAX = 10000000

--------------------------------------------------------------------------------
-- The constructor.
-- @param eventType (option)The type of event.
--------------------------------------------------------------------------------
function M:init(eventType)
    self.type = eventType
    self.stoped = false
end

--------------------------------------------------------------------------------
-- Sets the event listener by EventDispatcher. <br>
-- Please do not accessible from the outside.
--------------------------------------------------------------------------------
function M:setListener(callback, source)
    self.callback = callback
    self.source = source
end

--------------------------------------------------------------------------------
--Stop the propagation of the event.
--------------------------------------------------------------------------------
function M:stop()
    self.stoped = true
end

return M