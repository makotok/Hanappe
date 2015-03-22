----------------------------------------------------------------------------------------------------
-- This is a class to manage the focus of the widget.
-- Please get an instance from the widget module.
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
local class = require "flower.class"
local table = require "flower.table"
local UIEvent = require "flower.widget.UIEvent"
local EventDispatcher = require "flower.EventDispatcher"

-- class
local FocusMgr = class(EventDispatcher)

-- static variables
local INSTANCE = nil

---
-- Return the singlton instance.
function FocusMgr.getInstance()
    if not INSTANCE then
        INSTANCE = FocusMgr()
    end
    return INSTANCE
end

---
-- Constructor.
function FocusMgr:init()
    assert(INSTANCE == nil)
    FocusMgr.__super.init(self)
    self.focusObject = nil
end

---
-- Set the focus object.
-- @param object focus object.
function FocusMgr:setFocusObject(object)
    if self.focusObject == object then
        return
    end

    local oldFocusObject = self.focusObject
    self.focusObject = object

    if oldFocusObject then
        self:dispatchEvent(UIEvent.FOCUS_OUT, oldFocusObject)
        oldFocusObject:dispatchEvent(UIEvent.FOCUS_OUT)
    end
    if self.focusObject then
        self:dispatchEvent(UIEvent.FOCUS_IN, self.focusObject)
        self.focusObject:dispatchEvent(UIEvent.FOCUS_IN)
    end
end

---
-- Return the focus object.
-- @return focus object.
function FocusMgr:getFocusObject()
    return self.focusObject
end

return FocusMgr