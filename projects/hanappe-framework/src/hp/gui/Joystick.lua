--------------------------------------------------------------------------------
-- Joystick is a virtual controller.
--------------------------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Sprite            = require "hp/display/Sprite"
local Group             = require "hp/display/Group"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"

-- class define
local M                 = class(Component)
local super             = Component

-- Events
M.EVENT_STICK_CHANGED   = "stickChanged"

-- constraints
M.STICK_CENTER          = "center"
M.STICK_LEFT            = "left"
M.STICK_TOP             = "top"
M.STICK_RIGHT           = "right"
M.STICK_BOTTOM          = "bottom"

M.MODE_ANALOG           = "analog"
M.MODE_DIGITAL          = "digital"

M.RANGE_OF_CENTER_RATE  = 0.5

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._touchDownFlag = false
    self._rangeOfCenterRate = M.RANGE_OF_CENTER_RATE
    self._stickMode = M.MODE_ANALOG
    self._changedEvent = Event(M.EVENT_STICK_CHANGED)
    self._themeName = "Joystick"
end

--------------------------------------------------------------------------------
-- Create a child objects.
--------------------------------------------------------------------------------
function M:createChildren()
    local baseSkin = self:getStyle("baseSkin")
    local knobSkin = self:getStyle("knobSkin")
    
    self._baseSprite = Sprite {texture = baseSkin, left = 0, top = 0}
    self._knobSprite = Sprite {texture = knobSkin, left = 0, top = 0}
    
    self:addChild(self._baseSprite)
    self:addChild(self._knobSprite)

    self:setSize(self._baseSprite:getSize())
    self:setCenterKnob()
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function M:updateDisplay()

    self._baseSprite:setColor(unpack(self:getStyle("baseColor")))
    self._baseSprite:setTexture(self:getStyle("baseSkin"))

    self._knobSprite:setColor(unpack(self:getStyle("knobColor")))
    self._knobSprite:setTexture(self:getStyle("knobSkin"))
    
    self:setSize(self._baseSprite:getSize())
end

--------------------------------------------------------------------------------
-- To update the position of the knob.
-- @param x The x-position of the knob
-- @param y The y-position of the knob
--------------------------------------------------------------------------------
function M:updateKnob(x, y)
    local oldX, oldY = self._knobSprite:getLoc()
    local newX, newY = self:getKnobNewLoc(x, y)

    -- change loc
    if oldX ~= newX or oldY ~= newY then
        self._knobSprite:setLoc(newX, newY, 0)
    
        local event = self._changedEvent
        event.oldX, event.oldY = self:getKnobInputRate(oldX, oldY)
        event.newX, event.newY = self:getKnobInputRate(newX, newY)
        event.direction = self:getStickDirection()
        event.down = self._touchDownFlag
        self:dispatchEvent(event)
    end
end

--------------------------------------------------------------------------------
-- Set the position of the center of the knob.
--------------------------------------------------------------------------------
function M:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobSprite:setLoc(cx, cy, 0)
end

--------------------------------------------------------------------------------
-- Returns the position of the center of the whole.
-- Does not depend on the Pivot.
-- @return Center x-position
-- @return Center y-position
--------------------------------------------------------------------------------
function M:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

--------------------------------------------------------------------------------
-- Returns the position that matches the mode of the stick.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
--------------------------------------------------------------------------------
function M:getKnobNewLoc(x, y)
    if self:getStickMode() == M.MODE_ANALOG then
        return self:getKnobNewLocForAnalog(x, y)
    else
        return self:getKnobNewLocForDigital(x, y)
    end
end

--------------------------------------------------------------------------------
-- Returns the position to match the analog mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
--------------------------------------------------------------------------------
function M:getKnobNewLocForAnalog(x, y)
    local cx, cy = self:getCenterLoc()
    local rx, ry = (x - cx), (y - cy)
    local radian = math.atan2(math.abs(ry), math.abs(rx))
    local maxX, maxY =  math.cos(radian) * cx + cx,  math.sin(radian) * cy + cy
    local minX, minY = -math.cos(radian) * cx + cx, -math.sin(radian) * cy + cy
    
    x = x < minX and minX or x
    x = x > maxX and maxX or x
    y = y < minY and minY or y
    y = y > maxY and maxY or y
    
    return x, y
end

--------------------------------------------------------------------------------
-- Returns the position to match the digital mode.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
--------------------------------------------------------------------------------
function M:getKnobNewLocForDigital(x, y)
    local cx, cy = self:getCenterLoc()
    local rx, ry = (x - cx), (y - cy)
    local radian = math.atan2(math.abs(ry), math.abs(rx))
    local minX, minY = 0, 0
    local maxX, maxY = self:getWidth(), self:getHeight()
    local cRate = self._rangeOfCenterRate
    local cMinX, cMinY = cx - cx * cRate, cy - cy * cRate
    local cMaxX, cMaxY = cx + cx * cRate, cy + cy * cRate
    
    if cMinX < x and x < cMaxX and cMinY < y and y < cMaxY then
        x = cx
        y = cy
    elseif math.cos(radian) > math.sin(radian) then
        x = x < cx and minX or maxX
        y = cy
    else
        x = cx
        y = y < cy and minY or maxY
    end
    return x, y
end

--------------------------------------------------------------------------------
-- Returns the percentage of input.
-- @param x X-position
-- @param y Y-position
-- @return X-ratio(-1 <= x <= 1)
-- @return Y-ratio(-1 <= y <= 1)
--------------------------------------------------------------------------------
function M:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

--------------------------------------------------------------------------------
-- Returns the direction of the stick.
-- @return direction
--------------------------------------------------------------------------------
function M:getStickDirection()
    local x, y = self._knobSprite:getLoc()
    local cx, cy = self:getCenterLoc()
    local radian = math.atan2(math.abs(x - cx), math.abs(y - cy))

    local dir
    if x == cx and y == cy then
        dir = M.STICK_CENTER
    elseif math.cos(radian) < math.sin(radian) then
        dir = x < cx and M.STICK_LEFT or M.STICK_RIGHT
    else
        dir = y < cy and M.STICK_TOP or M.STICK_BOTTOM
    end
    return dir
end
 
--------------------------------------------------------------------------------
-- Returns the stick mode
-- @return stick mode
--------------------------------------------------------------------------------
function M:getStickMode()
    return self._stickMode
end

--------------------------------------------------------------------------------
-- Set the mode of the stick.
-- @param mode mode("analog" or "digital")
--------------------------------------------------------------------------------
function M:setStickMode(value)
    self._stickMode = value
end

--------------------------------------------------------------------------------
-- This event handler is called when touched.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:setOnStickChanged(func)
    self:setEventListener(M.EVENT_STICK_CHANGED, func)
end

--------------------------------------------------------------------------------
-- Event Handler.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- This event handler is called when touched.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self._touchDownFlag then
        return
    end

    local mx, my = self:worldToModel(e.x, e.y, 0)
    self._touchDownFlag = true
    self._touchIndex = e.idx
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if not self._touchDownFlag then
        return
    end
    if e.idx ~= self._touchIndex then
        return
    end

    self._touchDownFlag = false
    local cx, cy = self:getCenterLoc()
    self:updateKnob(cx, cy)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if not self._touchDownFlag then
        return
    end
    if e.idx ~= self._touchIndex then
        return
    end
    
    local wx, wy = e.x, e.y
    local mx, my = self:worldToModel(wx, wy, 0)
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
    self._touchDownFlag = false
    self:setCenterKnob()
end
   
return M