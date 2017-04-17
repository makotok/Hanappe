--------------------------------------------------------------------------------
-- This class inherits the MOAILayer. <br>
-- Simplifies the generation of a set of size and layer. <br>
--------------------------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local Event                 = require "hp/event/Event"
local InputManager          = require "hp/manager/InputManager"

-- class define
local M                     = class()

-- event cache
local EVENT_TOUCH_DOWN      = Event(Event.TOUCH_DOWN)
local EVENT_TOUCH_UP        = Event(Event.TOUCH_UP)
local EVENT_TOUCH_MOVE      = Event(Event.TOUCH_MOVE)
local EVENT_TOUCH_CANCEL    = Event(Event.TOUCH_CANCEL)

-- For the given event, find the cached touch points that correspond based on the index.
-- @returns a point if in the cache, else nil
local function getPointByCache(self, event)
    for index, point in ipairs(self._touchPoints) do
        if point.idx == event.idx then
            return point
        end
    end
end

-- For the given event, retrieve a point datastructure. 
-- The point cache will first be checked, if none a new point will be created.
-- @returns a point corresponding to the provided event
local function getPointByEvent(self, event)
    local layer = self._touchLayer

    local point = getPointByCache(self, event) or {}
    point.idx = event.idx
    point.tapCount = event.tapCount
    point.oldX, point.oldY = point.x, point.y
    point.x, point.y = layer:wndToWorld(event.x, event.y, 0)
    point.screenX, point.screenY = event.x, event.y
    
    if point.oldX and point.oldY then
        point.moveX = point.x - point.oldX
        point.moveY = point.y - point.oldY
    else
        point.oldX, point.oldY = point.x, point.y
        point.moveX, point.moveY = 0, 0
    end
    
    return point
end

-- Recurse up the child-parent tree of the provided target object and dispatch the event provided.
local function eventHandle(self, event, target)
    local layer = self._touchLayer
    while target do
        if target.isTouchEnabled and not target:isTouchEnabled() then
            break
        end
        if target.dispatchEvent then
            target:dispatchEvent(event)
        end
        if target.getParent then
            target = target:getParent()
        else
            target = nil
        end
    end
end

-- Iterator that iterates over the list of props and strips off last nil element
local function props(propsList)
    local i = 0
    return function()
        i = i + 1
        if propsList[i] ~= nil then
            return i, propsList[i]
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor.
-- @param layer (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:init(layer)
    self._touchLayer        = assert(layer)
    self._touchPoints       = {}
    self._eventSource       = nil
    self._enabled           = true
end

--------------------------------------------------------------------------------
-- Set the source of the events.
-- Typically, this is an instance of a Scene
--------------------------------------------------------------------------------
function M:setEventSource(eventSource)
    if self._eventSource then
        self._eventSource:removeEventListener(Event.TOUCH_DOWN, self.touchDownHandler, self)
        self._eventSource:removeEventListener(Event.TOUCH_UP, self.touchUpHandler, self)
        self._eventSource:removeEventListener(Event.TOUCH_MOVE, self.touchMoveHandler, self)
        self._eventSource:removeEventListener(Event.TOUCH_CANCEL, self.touchCancelHandler, self)
    end
    
    self._eventSource = eventSource
    
    if self._eventSource then
        self._eventSource:addEventListener(Event.TOUCH_DOWN, self.touchDownHandler, self)
        self._eventSource:addEventListener(Event.TOUCH_UP, self.touchUpHandler, self)
        self._eventSource:addEventListener(Event.TOUCH_MOVE, self.touchMoveHandler, self)
        self._eventSource:addEventListener(Event.TOUCH_CANCEL, self.touchCancelHandler, self)
    end
end

--------------------------------------------------------------------------------
-- Remove the event source reference
--------------------------------------------------------------------------------
function M:dispose()
    self:setEventSource(nil)
end

--------------------------------------------------------------------------------
-- Set whether the touch processor is enabled or not.
--------------------------------------------------------------------------------
function M:setEnabled(value)
    self._enabled = value
end

--------------------------------------------------------------------------------
-- Determine if the processor is enabled.
-- @returns true if the processor is enabled, false otherwise.
--------------------------------------------------------------------------------
function M:isEnabled()
    return self._enabled
end

----------------------------------------------------------------------------------------------------------------------
-- Event handler for touch down events.  Touch down events do not have any prerequisite events.
-- @param event The event to handle
----------------------------------------------------------------------------------------------------------------------
function M:touchDownHandler(event)
    if not self:isEnabled() then
        return
    end
    
    local layer = self._touchLayer

    local point = getPointByEvent(self, event)
    local propsAtPoint = table.pack(layer:getPartition():propListForPoint(point.x, point.y, 0))
    table.insertElement(self._touchPoints, point)

    local touchEvent = table.copy(point, EVENT_TOUCH_DOWN)
    touchEvent.points = self._touchPoints

    for index, prop in props(propsAtPoint) do
        prop._touchDown = touchEvent
        self:dispatchEvent(touchEvent, event, prop)
    end
end

----------------------------------------------------------------------------------------------------------------------
-- Event handler for touch up events. Touch up events require a touch down event on the object before they can be 
-- registered.  A touch up event clears out the touch down state of an object.
-- @param event The event to handle
----------------------------------------------------------------------------------------------------------------------
function M:touchUpHandler(event)
    if not self:isEnabled() then
        return
    end

    local layer = self._touchLayer

    local point = getPointByEvent(self, event)
    local touchEvent = table.copy(point, EVENT_TOUCH_UP)
    local propsAtPoint = table.pack(layer:getPartition():propListForPoint(point.x, point.y, 0))

    for index, prop in props(propsAtPoint) do
        if prop._touchDown then
            prop._touchDown = nil
            self:dispatchEvent(touchEvent, event, prop)
        end
    end
    
    table.removeElement(self._touchPoints, point)
end

----------------------------------------------------------------------------------------------------------------------
-- Event handler for touch move events. Touch move events require a touch down event on the object before they can be 
-- registered.  If the touch is moved outside of the object, the object will receive a touch cancel event.
-- @param event The event to handle
----------------------------------------------------------------------------------------------------------------------
function M:touchMoveHandler(event)
    if not self:isEnabled() then
        return
    end

    local layer = self._touchLayer

    local point = getPointByEvent(self, event)
    local touchEvent = table.copy(point, EVENT_TOUCH_MOVE)
    point.props = point.props or {} -- Props affected by the event, used to keep track of touch cancels by moving off prop.
    local propsAtPoint = table.pack(layer:getPartition():propListForPoint(point.x, point.y, 0))

    for index, prop in props(propsAtPoint) do
        if prop._touchDown then
            table.insertElement(point.props, prop)
            self:dispatchEvent(touchEvent, event, prop)
        end
    end

    self:removePropsCancelledByMove(point.props, propsAtPoint, event)
end

-- Remove props from the event points if the user has moved their finger off of the prop.  The prop no longer
-- receives the move events and will receive a touch cancel event.
-- @param eventProps The props that are being tracked
-- @param currentProps The props that are under the touch currently
-- @param event The current event that is occurring.
function M:removePropsCancelledByMove(eventProps, currentProps, event)
    for index, prop in ipairs(eventProps) do
        if 0 == table.indexOf(currentProps, prop) then
            local cancelEvent = EVENT_TOUCH_CANCEL
            self:dispatchEvent(cancelEvent, event, prop)

            table.removeElement(eventProps, prop)
            prop._touchDown = nil
        end
    end
end
----------------------------------------------------------------------------------------------------------------------
-- Event handler for touch cancel events.  Cancel events can either occur because of application backgrounding (in iOS),
-- or because the user has moved their finger off the object during touch move. 
-- @param event The event to handle
----------------------------------------------------------------------------------------------------------------------
function M:touchCancelHandler(event)
    if not self:isEnabled() then
        return
    end

    local layer = self._touchLayer

    local point = getPointByEvent(self, event)
    local touchEvent = table.copy(point, EVENT_TOUCH_CANCEL)
    
    local propsAtPoint = table.pack(layer:getPartition():propListForPoint(point.x, point.y, 0))

    for index, prop in props(propsAtPoint) do
        self:dispatchEvent(touchEvent, event, prop)
    end
    
    table.removeElement(self._touchPoints, point)
end

-- Handle and dispatch the provided event.
-- @param touch event that represents the touch event occurring
-- @param event the Event object
-- @param prop The prop the event is occuring on.
function M:dispatchEvent(touchEvent, event, prop)
    eventHandle(self, touchEvent, prop)
    if not touchEvent.stoped then
        self._touchLayer:dispatchEvent(touchEvent)
    end
    if touchEvent.stoped then
        event:stop()
    end
end

return M
