----------------------------------------------------------------------------------------------------
-- GUI Library.
--
-- @author Makoto
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table
local Event = flower.Event
local Image = flower.Image
local Group = flower.Group

-- class
local ImageButton
local Joystick
local ListView

----------------------------------------------------------------------------------------------------
-- @type ImageButton
-- This class is an image that can be pressed.
-- It is a simple button.
----------------------------------------------------------------------------------------------------
ImageButton = class(Image)
M.ImageButton = ImageButton

--- Click Event
ImageButton.EVENT_CLICK = "click"

--- Button down Event
ImageButton.EVENT_BUTTON_DOWN = "buttonDown"

--- Button up Event
ImageButton.EVENT_BUTTON_UP = "buttonUp"

--------------------------------------------------------------------------------
-- The constructor.
-- @param texture texture
--------------------------------------------------------------------------------
function ImageButton:init(texture)
    Image.init(self, texture)
    
    self.touchDownIdx = nil
    
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

--------------------------------------------------------------------------------
-- If the user presses the button returns True.
-- @return If the user presses the button returns True
--------------------------------------------------------------------------------
function ImageButton:isButtonDown()
    return self.touchDownIdx ~= nil
end

--------------------------------------------------------------------------------
-- Down the button.
-- There is no need to call directly to the basic.
-- @param idx Touch index
--------------------------------------------------------------------------------
function ImageButton:doButtonDown(idx)
    if self:isButtonDown() then
        return
    end
    
    self.touchDownIdx = idx
    self:setScl(1.2, 1.2, 1)
    
    self:dispatchEvent(ImageButton.EVENT_BUTTON_DOWN)
end

--------------------------------------------------------------------------------
-- Up the button.
-- There is no need to call directly to the basic.
-- @param idx Touch index
--------------------------------------------------------------------------------
function ImageButton:doButtonUp()
    if not self:isButtonDown() then
        return
    end

    self.touchDownIdx = nil
    self:setScl(1, 1, 1)
    
    self:dispatchEvent(ImageButton.EVENT_BUTTON_UP)
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ImageButton:onTouchDown(e)
    if self:isButtonDown() then
        return
    end
    self:doButtonDown(e.idx)
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ImageButton:onTouchUp(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:doButtonUp()
    self:dispatchEvent(ImageButton.EVENT_CLICK)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ImageButton:onTouchMove(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    if not self:inside(e.wx, e.wy, 0) then
        self:doButtonUp()
    end
end

--------------------------------------------------------------------------------
-- This event handler is called when you cancel the touch.
-- @param e Touch Event
--------------------------------------------------------------------------------
function ImageButton:onTouchCancel(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:doButtonUp()
end


----------------------------------------------------------------------------------------------------
-- @type Joystick
-- It is a virtual Joystick.
----------------------------------------------------------------------------------------------------
Joystick = class(Group)
M.Joystick = Joystick

--- Event type when you change the position of the stick
Joystick.EVENT_STICK_CHANGED   = "stickChanged"

--- Direction of the stick
Joystick.STICK_CENTER          = "center"

--- Direction of the stick
Joystick.STICK_LEFT            = "left"

--- Direction of the stick
Joystick.STICK_TOP             = "top"

--- Direction of the stick
Joystick.STICK_RIGHT           = "right"

--- Direction of the stick
Joystick.STICK_BOTTOM          = "bottom"

--- Mode of the stick
Joystick.MODE_ANALOG           = "analog"

--- Mode of the stick
Joystick.MODE_DIGITAL          = "digital"

--- The ratio of the center
Joystick.RANGE_OF_CENTER_RATE  = 0.5

--- Default texture
Joystick.DEFAULT_BASE_TEXTURE  = "gui/joystick_base.png"

--- Default texture
Joystick.DEFAULT_KNOB_TEXTURE  = "gui/joystick_knob.png"

--------------------------------------------------------------------------------
-- The constructor.
-- @param baseTexture Joystick base texture
-- @param knobTexture Joystick knob texture
--------------------------------------------------------------------------------
function Joystick:init(baseTexture, knobTexture)
    Group.init(self)
    self._touchDownFlag = false
    self._rangeOfCenterRate = Joystick.RANGE_OF_CENTER_RATE
    self._stickMode = Joystick.MODE_ANALOG
    self._changedEvent = Event(Joystick.EVENT_STICK_CHANGED)
    self._baseTexture = baseTexture or Joystick.DEFAULT_BASE_TEXTURE
    self._knobTexture = knobTexture or Joystick.DEFAULT_KNOB_TEXTURE
    
    self:initChildren()
    self:initEventListeners()
end

--------------------------------------------------------------------------------
-- Initialize child objects that make up the Joystick.
-- You must not be called directly.
--------------------------------------------------------------------------------
function Joystick:initChildren()
    self._baseImage = Image(self._baseTexture)
    self._knobImage = Image(self._knobTexture)
    
    self:addChild(self._baseImage)
    self:addChild(self._knobImage)

    self:setSize(self._baseImage:getSize())
    self:setCenterKnob()
end

--------------------------------------------------------------------------------
-- Initializes the event listener.
-- You must not be called directly.
--------------------------------------------------------------------------------
function Joystick:initEventListeners()
    self:addEventListener("touchDown", self.onTouchDown, self)
    self:addEventListener("touchUp", self.onTouchUp, self)
    self:addEventListener("touchMove", self.onTouchMove, self)
    self:addEventListener("touchCancel", self.onTouchCancel, self)
end

--------------------------------------------------------------------------------
-- To update the position of the knob.
-- @param x The x-position of the knob
-- @param y The y-position of the knob
--------------------------------------------------------------------------------
function Joystick:updateKnob(x, y)
    local oldX, oldY = self._knobImage:getLoc()
    local newX, newY = self:getKnobNewLoc(x, y)

    if oldX ~= newX or oldY ~= newY then
        self._knobImage:setLoc(newX, newY, 0)
    
        local e = self._changedEvent
        e.oldX, e.oldY = self:getKnobInputRate(oldX, oldY)
        e.newX, e.newY = self:getKnobInputRate(newX, newY)
        e.direction = self:getStickDirection()
        e.down = self._touchDownFlag
        self:dispatchEvent(e)
    end
end

--------------------------------------------------------------------------------
-- Set the position of the center of the knob.
--------------------------------------------------------------------------------
function Joystick:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobImage:setLoc(cx, cy, 0)
end

--------------------------------------------------------------------------------
-- Returns the position of the center of the whole.
-- Does not depend on the Pivot.
-- @return Center x-position
-- @return Center y-position
--------------------------------------------------------------------------------
function Joystick:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

--------------------------------------------------------------------------------
-- Returns the position that matches the mode of the stick.
-- @param x X-position of the model
-- @param y Y-position of the model
-- @return adjusted x-position
-- @return adjusted y-position
--------------------------------------------------------------------------------
function Joystick:getKnobNewLoc(x, y)
    if self:getStickMode() == Joystick.MODE_ANALOG then
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
function Joystick:getKnobNewLocForAnalog(x, y)
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
function Joystick:getKnobNewLocForDigital(x, y)
    local cx, cy = self:getCenterLoc()
    local rx, ry = (x - cx), (y - cy)
    local radian = math.atan2(math.abs(ry), math.abs(rx))
    local minX, minY = 0, 0
    local maxX, maxY = self:getSize()
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
function Joystick:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

--------------------------------------------------------------------------------
-- Returns the direction of the stick.
-- @return direction
--------------------------------------------------------------------------------
function Joystick:getStickDirection()
    local x, y = self._knobImage:getLoc()
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
function Joystick:getStickMode()
    return self._stickMode
end

--------------------------------------------------------------------------------
-- Set the mode of the stick.
-- @param mode mode("analog" or "digital")
--------------------------------------------------------------------------------
function Joystick:setStickMode(mode)
    self._stickMode = mode
end

--------------------------------------------------------------------------------
-- This event handler is called when touched.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchDown(e)
    if self._touchDownFlag then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self._touchDownFlag = true
    self._touchIndex = e.idx
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- This event handler is called when the button is released.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchUp(e)
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
function Joystick:onTouchMove(e)
    if not self._touchDownFlag then
        return
    end
    if e.idx ~= self._touchIndex then
        return
    end
    
    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- This event handler is called when you move on the button.
-- @param e Touch Event
--------------------------------------------------------------------------------
function Joystick:onTouchCancel(e)
    self._touchDownFlag = false
    self:setCenterKnob()
end

return M
