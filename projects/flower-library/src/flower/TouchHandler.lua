----------------------------------------------------------------------------------------------------
-- Class to perform the handling of touch events emitted from a layer.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Event = require "flower.Event"

-- class
local TouchHandler = class()

-- Constraints
local TOUCH_EVENT = Event()

---
-- The constructor.
-- @param layer Layer object
function TouchHandler:init(layer)
    self.touchLayer = assert(layer)
    self.touchProps = {}

    layer:addEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    layer:addEventListener(Event.TOUCH_UP, self.onTouch, self)
    layer:addEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    layer:addEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
end

---
-- Event handler when you touch a layer.
-- @param e Event object
function TouchHandler:onTouch(e)
    if not self.touchLayer.touchEnabled then
        return
    end

    -- screen to world location.
    local prop = self:getTouchableProp(e)
    local prop2 = self.touchProps[e.idx]

    -- touch down prop
    if e.type == Event.TOUCH_DOWN then
        prop2 = nil
        self.touchProps[e.idx] = prop
    elseif e.type == Event.TOUCH_UP then
        self.touchProps[e.idx] = nil
    elseif e.type == Event.TOUCH_CANCEL then
        self.touchProps[e.idx] = nil
    end

    -- touch event
    local e2 = table.copy(e, TOUCH_EVENT)

    -- the active prop is the one reported from getTouchableProp,
    -- the "other" prop is the prop associated originally with this touch
    -- index. Used to make it easier to distinguish whether a touchUp
    -- event should be counted as a "click".
    e2.activeProp = prop
    e2.otherProp = prop2

    -- dispatch event
    if prop then
        e2.prop = prop
        self:dispatchTouchEvent(e2, prop)
    end
    if prop2 and prop2 ~= prop then
        e2.prop = prop2
        self:dispatchTouchEvent(e2, prop2)
    end
    if prop or prop2 then
        e:stop()
    end

    -- reset properties to free resources used in cached event
    e2.data = nil
    e2.prop = nil
    e2.activeProp = nil
    e2.otherProp = nil
    e2.target = nil
    e2:setListener(nil, nil)
end

---
-- Return the touchable Prop.
-- @param e Event object
function TouchHandler:getTouchableProp(e)
    local layer = self.touchLayer
    local partition = layer:getPartition()
    local sortMode = layer:getSortMode()
    local props = {partition:propListForPoint(e.wx, e.wy, 0, sortMode)}
    for i = #props, 1, -1 do
        local prop = props[i]
        if prop:getAttr(MOAIProp.ATTR_VISIBLE) > 0 then
            -- getScissorRect is part of a recent submitted change.
            local scissor = prop.getScissorRect and prop:getScissorRect() or prop.scissorRect
            if scissor then
                local sx, sy = scissor:worldToModel(e.wx, e.wy)
                local xMin, yMin, xMax, yMax = scissor:getRect()
                if sx > xMin and sx < xMax and sy > yMin and sy < yMax then
                    return prop
                end
            else
                return prop
            end
        end
    end
end

---
-- Fire touch handler events on a given object.
-- @param e Event object
-- @param o Display object
function TouchHandler:dispatchTouchEvent(e, o)
    local layer = self.touchLayer
    while o do
        if o.dispatchEvent then
            o:dispatchEvent(e)
        end
        if e.stopFlag then
            break
        end
        o = o.parent
    end
end

---
-- Remove the handler from the layer, and release resources.
function TouchHandler:dispose()
    local layer = self.touchLayer

    layer:removeEventListener(Event.TOUCH_DOWN, self.onTouch, self)
    layer:removeEventListener(Event.TOUCH_UP, self.onTouch, self)
    layer:removeEventListener(Event.TOUCH_MOVE, self.onTouch, self)
    layer:removeEventListener(Event.TOUCH_CANCEL, self.onTouch, self)
end

return TouchHandler
