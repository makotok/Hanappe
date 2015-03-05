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

--- Event: create
Event.CREATE                = "create"

--- Event: open
Event.OPEN                  = "open"

--- Event: close
Event.CLOSE                 = "close"

--- Event: openComplete
Event.OPEN_COMPLETE         = "openComplete"

--- Event: closeComplete
Event.CLOSE_COMPLETE        = "closeComplete"

--- Event: start
Event.START                 = "start"

--- Event: stop
Event.STOP                  = "stop"

--- Event: update
Event.UPDATE                = "update"

--- Event: down
Event.DOWN                  = "down"

--- Event: up
Event.UP                    = "up"

--- Event: move
Event.MOVE                  = "move"

--- Event: click
Event.CLICK                 = "click"

--- Event: cancel
Event.CANCEL                = "cancel"

--- Event: keyDown
Event.KEY_DOWN              = "keyDown"

--- Event: keyUp
Event.KEY_UP                = "keyUp"

--- Event: complete
Event.COMPLETE              = "complete"

--- Event: touchDown
Event.TOUCH_DOWN            = "touchDown"

--- Event: touchUp
Event.TOUCH_UP              = "touchUp"

--- Event: touchMove
Event.TOUCH_MOVE            = "touchMove"

--- Event: touchCancel
Event.TOUCH_CANCEL          = "touchCancel"

--- Event: mouseClick
Event.MOUSE_CLICK           = "mouseClick"

--- Event: mouseRightClick
Event.MOUSE_RIGHT_CLICK     = "mouseRightClick"

--- Event: mouseMiddleClick
Event.MOUSE_MIDDLE_CLICK    = "mouseMiddleClick"

--- Event: mouseWheel
Event.MOUSE_WHEEL           = "mouseWheel"

--- Event: mouseMove
Event.MOUSE_MOVE            = "mouseMove"

--- Event: mouseOver
Event.MOUSE_OVER            = "mouseOver"

--- Event: mouseOut
Event.MOUSE_OUT             = "mouseOut"

--- Event: enterFrame
Event.ENTER_FRAME           = "enterFrame"

--- Event: resize
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