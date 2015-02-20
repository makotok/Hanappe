----------------------------------------------------------------------------------------------------
-- A class for events, which are communicated to, and handled by, event handlers
-- Holds the data of the Event.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"

-- class
local Event = class()

-- Constraints
Event.CREATE                = "create"
Event.OPEN                  = "open"
Event.CLOSE                 = "close"
Event.OPEN_COMPLETE         = "openComplete"
Event.CLOSE_COMPLETE        = "closeComplete"
Event.START                 = "start"
Event.STOP                  = "stop"
Event.UPDATE                = "update"
Event.DOWN                  = "down"
Event.UP                    = "up"
Event.MOVE                  = "move"
Event.CLICK                 = "click"
Event.CANCEL                = "cancel"
Event.KEY_DOWN              = "keyDown"
Event.KEY_UP                = "keyUp"
Event.COMPLETE              = "complete"
Event.TOUCH_DOWN            = "touchDown"
Event.TOUCH_UP              = "touchUp"
Event.TOUCH_MOVE            = "touchMove"
Event.TOUCH_CANCEL          = "touchCancel"
Event.MOUSE_CLICK           = "mouseClick"
Event.MOUSE_RIGHT_CLICK     = "mouseRightClick"
Event.MOUSE_MIDDLE_CLICK    = "mouseMiddleClick"
Event.MOUSE_WHEEL           = "mouseWheel"
Event.MOUSE_MOVE            = "mouseMove"
Event.MOUSE_OVER            = "mouseOver"
Event.MOUSE_OUT             = "mouseOut"
Event.ENTER_FRAME           = "enterFrame"
Event.RESIZE                = "resize"

---
-- Event's constructor.
-- @param eventType (option)The type of event.
function Event:init(eventType)
    self.type = eventType
    self.stopFlag = false
end

---
-- INTERNAL USE ONLY -- Sets the event listener via EventDispatcher.
-- @param callback callback function
-- @param source source object.
function Event:setListener(callback, source)
    self.callback = callback
    self.source = source
end

---
-- Stop the propagation of the event.
function Event:stop()
    self.stopFlag = true
end

return Event