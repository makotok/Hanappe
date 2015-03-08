----------------------------------------------------------------------------------------------------
-- This is a class to manage the layout of the widget.
-- Please get an instance from the widget module.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Logger = require "flower.Logger"
local EventDispatcher = require "flower.EventDispatcher"
local Executors = require "flower.Executors"
local UIEvent = require "flower.widget.UIEvent"

-- class
local LayoutMgr = class(EventDispatcher)

-- static variables
local INSTANCE = nil

---
-- Return the singlton instance.
function LayoutMgr.getInstance()
    if not INSTANCE then
        INSTANCE = LayoutMgr()
    end
    return INSTANCE
end

---
-- Constructor.
function LayoutMgr:init()
    LayoutMgr.__super.init(self)
    self._invalidateDisplayQueue = {}
    self._invalidateLayoutQueue = {}
    self._invalidating = false
end

---
-- Invalidate the display of the component.
-- @param component component
function LayoutMgr:invalidateDisplay(component)
    table.insertElement(self._invalidateDisplayQueue, component)

    if not self._invalidating then
        Executors.callOnce(self.validateAll, self)
        self._invalidating = true
    end
end

---
-- Invalidate the layout of the component.
-- @param component component
function LayoutMgr:invalidateLayout(component)
    table.insertElement(self._invalidateLayoutQueue, component)

    if not self._invalidating then
        Executors.callOnce(self.validateAll, self)
        self._invalidating = true
    end
end

---
-- Validate the all components.
function LayoutMgr:validateAll()
    self:validateDisplay()
    self:validateLayout()

    if #self._invalidateDisplayQueue > 0 or #self._invalidateLayoutQueue > 0 then
        self:validateAll()
        return
    end

    self._invalidating = false
    self:dispatchEvent(UIEvent.COMPLETE)
    Logger.debug("LayoutMgr:validateAll complete")
end

---
-- Validate the display of the all components.
function LayoutMgr:validateDisplay()
    if #self._invalidateDisplayQueue == 0 then
        return
    end

    local validateCount = 0
    local component = table.remove(self._invalidateDisplayQueue, 1)
    while component do
        component:validateDisplay()
        component = table.remove(self._invalidateDisplayQueue, 1)
        validateCount = validateCount + 1
    end
    Logger.debug("LayoutMgr:validateDisplay count=" .. validateCount)
end

---
-- Validate the layout of the all components.
function LayoutMgr:validateLayout()
    if #self._invalidateLayoutQueue == 0 then
        return
    end
    
    local validateCount = 0
    local component = table.remove(self._invalidateLayoutQueue, 1)
    while component do
        component:validateLayout()
        component = table.remove(self._invalidateLayoutQueue, 1)
        validateCount = validateCount + 1
    end
    Logger.debug("LayoutMgr:validateLayout count=" .. validateCount)
end

return LayoutMgr