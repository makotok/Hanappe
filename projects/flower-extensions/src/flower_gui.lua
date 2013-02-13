----------------------------------------------------------------------------------------------------
-- GUI Library.
-- TODO:実装
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
-- ImageButton
----------------------------------------------------------------------------------------------------
ImageButton = class(Image)
M.ImageButton = ImageButton

--- Click Event
ImageButton.EVENT_CLICK = "click"

--- Button down Event
ImageButton.EVENT_BUTTON_DOWN = "buttonDown"

--- Button up Event
ImageButton.EVENT_BUTTON_UP = "buttonUp"

function ImageButton:init(texture)
    Image.init(self, texture)
    
    self.touchDownIdx = nil
    
    self:addEventListener(Event.TOUCH_DOWN, self.onTouchDown, self)
    self:addEventListener(Event.TOUCH_UP, self.onTouchUp, self)
    self:addEventListener(Event.TOUCH_MOVE, self.onTouchMove, self)
    self:addEventListener(Event.TOUCH_CANCEL, self.onTouchCancel, self)
end

function ImageButton:isButtonDown()
    return self.touchDownIdx ~= nil
end

function ImageButton:doButtonDown(idx)
    self.touchDownIdx = idx
    self:setScl(1.2, 1.2, 1)
    
    self:dispatchEvent(ImageButton.EVENT_BUTTON_DOWN)
end

function ImageButton:doButtonUp()
    self.touchDownIdx = nil
    self:setScl(1, 1, 1)
    
    self:dispatchEvent(ImageButton.EVENT_BUTTON_UP)
end

function ImageButton:onTouchDown(e)
    if self:isButtonDown() then
        return
    end
    self:doButtonDown(e.idx)
end

function ImageButton:onTouchUp(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:doButtonUp()
    self:dispatchEvent(ImageButton.EVENT_CLICK)
end

function ImageButton:onTouchMove(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    if not self:inside(e.wx, e.wy, 0) then
        self:doButtonUp()
    end
end

function ImageButton:onTouchCancel(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:doButtonUp()
end


----------------------------------------------------------------------------------------------------
-- @type Joystick
-- Joystick
----------------------------------------------------------------------------------------------------
Joystick = class(Group)
M.Joystick = Joystick

-- Events
Joystick.EVENT_STICK_CHANGED   = "stickChanged"

-- constraints
Joystick.STICK_CENTER          = "center"
Joystick.STICK_LEFT            = "left"
Joystick.STICK_TOP             = "top"
Joystick.STICK_RIGHT           = "right"
Joystick.STICK_BOTTOM          = "bottom"
Joystick.MODE_ANALOG           = "analog"
Joystick.MODE_DIGITAL          = "digital"
Joystick.RANGE_OF_CENTER_RATE  = 0.5
Joystick.DEFAULT_BASE_TEXTURE  = "gui/joystick_base.png"
Joystick.DEFAULT_KNOB_TEXTURE  = "gui/joystick_knob.png"


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

function Joystick:initChildren()
    self._baseImage = Image(self._baseTexture)
    self._knobImage = Image(self._knobTexture)
    
    self:addChild(self._baseImage)
    self:addChild(self._knobImage)

    self:setSize(self._baseImage:getSize())
    self:setCenterKnob()
end

function Joystick:initEventListeners()
    self:addEventListener("touchDown", self.onTouchDown, self)
    self:addEventListener("touchUp", self.onTouchUp, self)
    self:addEventListener("touchMove", self.onTouchMove, self)
    self:addEventListener("touchCancel", self.onTouchCancel, self)
end

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

function Joystick:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobImage:setLoc(cx, cy, 0)
end

function Joystick:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

function Joystick:getKnobNewLoc(x, y)
    if self:getStickMode() == Joystick.MODE_ANALOG then
        return self:getKnobNewLocForAnalog(x, y)
    else
        return self:getKnobNewLocForDigital(x, y)
    end
end

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

function Joystick:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

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
 
function Joystick:getStickMode()
    return self._stickMode
end

function Joystick:setStickMode(value)
    self._stickMode = value
end

function Joystick:onTouchDown(e)
    if self._touchDownFlag then
        return
    end

    local mx, my = self:worldToModel(e.wx, e.wy, 0)
    self._touchDownFlag = true
    self._touchIndex = e.idx
    self:updateKnob(mx, my)
end

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

function Joystick:onTouchCancel(e)
    self._touchDownFlag = false
    self:setCenterKnob()
end

return M
