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
local Image = flower.Image

-- class
local ImageButton
local Joystick
local ListView

----------------------------------------------------------------------------------------------------
-- Button
-- @class table
-- @name Button
----------------------------------------------------------------------------------------------------
ImageButton = class(Image)
ImageButton.EVENT_CLICK = "click"

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

function ImageButton:setButtonDown(idx)
    self.touchDownIdx = idx
    self:setScl(1.2, 1.2, 1)
end

function ImageButton:setButtonUp()
    self.touchDownIdx = nil
    self:setScl(1, 1, 1)
end

function ImageButton:onTouchDown(e)
    if self:isButtonDown() then
        return
    end
    self:setButtonDown(e.idx)
end

function ImageButton:onTouchUp(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:setButtonUp()
    self:dispatchEvent(ImageButton.EVENT_CLICK)
end

function ImageButton:onTouchMove(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    if not self:inside(e.wx, e.wy, 0) then
        self:setButtonUp()
    end
end

function ImageButton:onTouchCancel(e)
    if self.touchDownIdx ~= e.idx then
        return
    end
    self:setButtonUp()
end


----------------------------------------------------------------------------------------------------
-- Joystick
-- @class table
-- @name Joystick
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


function Joystick:init()
    Group.init(self)
    self._touchDownFlag = false
    self._rangeOfCenterRate = M.RANGE_OF_CENTER_RATE
    self._stickMode = M.MODE_ANALOG
    self._changedEvent = Event(M.EVENT_STICK_CHANGED)
    self._themeName = "Joystick"
end

function Joystick:createChildren()
    local baseSkin = self:getStyle("baseSkin")
    local knobSkin = self:getStyle("knobSkin")
    
    self._baseSprite = Sprite {texture = baseSkin, left = 0, top = 0}
    self._knobSprite = Sprite {texture = knobSkin, left = 0, top = 0}
    
    self:addChild(self._baseSprite)
    self:addChild(self._knobSprite)

    self:setSize(self._baseSprite:getSize())
    self:setCenterKnob()
end

function Joystick:updateDisplay()

    self._baseSprite:setColor(unpack(self:getStyle("baseColor")))
    self._baseSprite:setTexture(self:getStyle("baseSkin"))

    self._knobSprite:setColor(unpack(self:getStyle("knobColor")))
    self._knobSprite:setTexture(self:getStyle("knobSkin"))
    
    self:setSize(self._baseSprite:getSize())
end

function Joystick:updateKnob(x, y)
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

function Joystick:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobSprite:setLoc(cx, cy, 0)
end

function Joystick:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

function Joystick:getKnobNewLoc(x, y)
    if self:getStickMode() == M.MODE_ANALOG then
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

function Joystick:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

function Joystick:getStickDirection()
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
 
function Joystick:getStickMode()
    return self._stickMode
end

function Joystick:setStickMode(value)
    self._stickMode = value
end

function Joystick:setOnStickChanged(func)
    self:setEventListener(M.EVENT_STICK_CHANGED, func)
end

function Joystick:onTouchDown(e)
    if self._touchDownFlag then
        return
    end

    local mx, my = self:worldToModel(e.x, e.y, 0)
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
    
    local wx, wy = e.x, e.y
    local mx, my = self:worldToModel(wx, wy, 0)
    self:updateKnob(mx, my)
end

function Joystick:onTouchCancel(e)
    self._touchDownFlag = false
    self:setCenterKnob()
end

return M
