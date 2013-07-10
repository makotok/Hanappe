----------------------------------------------------------------
-- This class is a general horizontal slider.
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Event             = require "hp/event/Event"
local Sprite            = require "hp/display/Sprite"
local Component         = require "hp/gui/Component"

-- class define
local M                 = class(Component)
local super             = Component

-- States
M.STATE_NORMAL          = "normal"
M.STATE_DISABLED        = "disabled"

-- Events
M.EVENT_SLIDER_BEGIN    = "sliderBeginChange"
M.EVENT_SLIDER_CHANGED  = "sliderChanged"
M.EVENT_SLIDER_END      = "sliderEndChange"

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._selected = false
    self._touching = false
    self._touchIndex = nil
    self._themeName = "Slider"
    self._beginChangeEvent = Event(M.EVENT_SLIDER_BEGIN)
    self._changedEvent = Event(M.EVENT_SLIDER_CHANGED)
    self._endChangeEvent = Event(M.EVENT_SLIDER_END)
    self._value = 0
    self._bounds = {min=0, max=1, span=1}
    self._accuracy = 0.1
end

--------------------------------------------------------------------------------
-- Create a child objects.
--------------------------------------------------------------------------------
function M:createChildren()
    self._background = NinePatch(self:getStyle("bg"))
    self._progress = NinePatch(self:getStyle("progress"))
    self._thumb = Sprite { texture = self:getStyle("thumb"), left = 0, top = 0 }

    self:addChild(self._background)
    self:addChild(self._progress)
    self:addChild(self._thumb)

    local _,bh = self._background:getSize()
    self:setSize(200, bh)

    self._thumb_width = self._thumb:getWidth()
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function M:updateDisplay()
    local background = self._background
    background:setColor(unpack(self:getStyle("color")))
    background:setTexture(self:getStyle("bg"))

    local progress = self._progress
    progress:setColor(unpack(self:getStyle("color")))
    progress:setTexture(self:getStyle("progress"))

    local thumb = self._thumb
    thumb:setColor(unpack(self:getStyle("color")))
    thumb:setTexture(self:getStyle("thumb"))

    local thumbLoc = self:_valueToLoc(self._value)
    thumb:setLoc(thumbLoc, self:getHeight() * 0.5)
    progress:setSize(thumbLoc + self._thumb_width * 0.5, self:getHeight())
end

function M:_valueToLoc(value)
    -- normalize value
    local v = (value - self._bounds.min) / self._bounds.span
    return self._thumb_width * 0.5 + (self:getWidth() - self._thumb_width) * v
end

function M:_locToValue(x)
    -- normalized
    local v = (x - self._thumb_width * 0.5) / (self:getWidth() - self._thumb_width)
    return self._bounds.min + v * self._bounds.span
end

--------------------------------------------------------------------------------
-- Sets the value (must be between 0 and 1).
-- @param value value
--------------------------------------------------------------------------------
function M:setValue(value)
    if value < self._bounds.min then
        value = self._bounds.min
    end
    if value > self._bounds.max then
        value = self._bounds.max
    end
    
    -- round to 4 decimal places = value
    value = math.floor(value * 10000) / 10000
    
    -- snap to accuracy
    local invsnap = 1 / self._accuracy
    value = math.floor(value * invsnap) / invsnap
    
    -- if value has not changed, abort
    if value == self._value then
        return
    end
    
    local old_value = self._value
    self._value = value
    self:_updateDrawables()
    
    local event = self._changedEvent
    event.oldValue = old_value
    event.value = self._value
    self:dispatchEvent(event)
end

function M:_updateDrawables()
    -- and indication we 're still initializing (called by resizeHandler)...
    if self._thumb_width == nil then
        return
    end
    
    local thumbLoc = self:_valueToLoc(self._value)
    self._thumb:setLoc(thumbLoc, self._background:getHeight() * 0.5)
    self._progress:setSize(thumbLoc + self._thumb_width * 0.5, self:getHeight())
end

--------------------------------------------------------------------------------
-- Returns the value.
-- @return value
--------------------------------------------------------------------------------
function M:getValue()
    return self._value
end

--------------------------------------------------------------------------------
-- Returns the accuracy.
-- @return accuracy
--------------------------------------------------------------------------------
function M:getAccuracy()
    return self._accuracy
end

--------------------------------------------------------------------------------
-- Returns the accuracy.
-- @param accuracy accuracy
--------------------------------------------------------------------------------
function M:setAccuracy(accuracy)
    self._accuracy = accuracy
    self:setValue(self._value)
end

--------------------------------------------------------------------------------
-- Returns the minimum and maximum values this slider can hold.
-- @return minimum and maximum values
--------------------------------------------------------------------------------
function M:getValueBounds()
    return self._bounds.min, self._bounds.max
end

--------------------------------------------------------------------------------
-- Returns the minimum and maximum values this slider can hold.
-- @param minMax table holding {min, max} values
--------------------------------------------------------------------------------
function M:setValueBounds(...)
    local minMax = {...}
    assert(#minMax >= 2)
    
    self._bounds.min = minMax[1]
    self._bounds.max = minMax[2]
    self._bounds.span = self._bounds.max - self._bounds.min
    self:setValue(self._value)
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user pushes the thumb.
-- @param func push event handler
--------------------------------------------------------------------------------
function M:setOnSliderBeginChange(func)
    self:setEventListener(M.EVENT_SLIDER_BEGIN, func)
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user moves the thumb.
-- @param func move event handler
--------------------------------------------------------------------------------
function M:setOnSliderChanged(func)
    self:setEventListener(M.EVENT_SLIDER_CHANGED, func)
end

--------------------------------------------------------------------------------
-- Set the event listener that is called when the user releases the thumb.
-- @param func release event handler
--------------------------------------------------------------------------------
function M:setOnSliderEndChange(func)
    self:setEventListener(M.EVENT_SLIDER_END, func)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- This event handler is called when touched.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self._touching then
        return
    end
    e:stop()

    if self._thumb:hitTestWorld(e.x, e.y) then
        self._touchIndex = e.idx
        self._touching = true

        local event = self._beginChangeEvent
        event.value = self._value
        self:dispatchEvent(event)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if e.idx ~= self._touchIndex then
        return
    end
    e:stop()

    self._touching = false
    self._touchIndex = nil

    local event = self._endChangeEvent
    event.value = self._value
    self:dispatchEvent(event)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if e.idx ~= self._touchIndex then
        return
    end
    e:stop()

    if self._touching then
        local mx, my = self:worldToModel(e.x, e.y, 0)
        local v = self:_locToValue(mx)
        self:setValue(v)
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
    if not self:isToggle() then
        self._touching = false
        self._touchIndex = nil
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when resizing.
-- @param e resize event
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    self._background:setSize(self:getWidth(), self:getHeight())
    self:_updateDrawables()
end

--------------------------------------------------------------------------------
-- This event handler is called when the enabled state changes.
-- @param e event
--------------------------------------------------------------------------------
function M:enabledChangedHandler(e)
    if not self:isEnabled() then
        self._touching = false
        self._touchIndex = 0
    end
end

return M