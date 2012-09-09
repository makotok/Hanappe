--------------------------------------------------------------------------------
-- ゲームの仮想ジョイスティックのウィジットクラスです.<br>
-- @class table
-- @name Joystick
--------------------------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Sprite            = require "hp/display/Sprite"
local Group             = require "hp/display/Group"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/component/Component"

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
-- 内部変数の初期化処理を行います.
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
-- 子オブジェクトの生成を行います.
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
-- スタイルの更新を行います.
--------------------------------------------------------------------------------
function M:updateStyles()

    self._baseSprite:setColor(unpack(self:getStyle("baseColor")))
    self._baseSprite:setTexture(self:getStyle("baseSkin"))

    self._knobSprite:setColor(unpack(self:getStyle("knobColor")))
    self._knobSprite:setTexture(self:getStyle("knobSkin"))
    
    self:setSize(self._baseSprite:getSize())
end

--------------------------------------------------------------------------------
-- knobSpriteの更新処理を行います.
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
-- knobSpriteの座標を中心点に設定します.
--------------------------------------------------------------------------------
function M:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self._knobSprite:setLoc(cx, cy, 0)
end

--------------------------------------------------------------------------------
-- Joystickの中心座標を計算して返します.
--------------------------------------------------------------------------------
function M:getCenterLoc()
    return self:getWidth() / 2, self:getHeight() / 2
end

--------------------------------------------------------------------------------
-- モード判定を行い、モードにあわせたknobのx, y座標を計算して返します.
--------------------------------------------------------------------------------
function M:getKnobNewLoc(x, y)
    if self:getStickMode() == M.MODE_ANALOG then
        return self:getKnobNewLocForAnalog(x, y)
    else
        return self:getKnobNewLocForDigital(x, y)
    end
end

--------------------------------------------------------------------------------
-- ANALOGモードのknobのx, y座標を計算して返します.
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
-- DIGITALモードのknobのx, y座標を計算して返します.
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
-- Knobの入力の比を返します.
--------------------------------------------------------------------------------
function M:getKnobInputRate(x, y)
    local cx, cy = self:getCenterLoc()
    local rateX, rateY = (x - cx) / cx, (y - cy) / cy
    return rateX, rateY
end

--------------------------------------------------------------------------------
-- Knobの入力の比を返します.
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
-- スティックの操作モードを返します.
--------------------------------------------------------------------------------
function M:getStickMode()
    return self._stickMode
end

--------------------------------------------------------------------------------
-- スティックの操作モードを設定します.
--------------------------------------------------------------------------------
function M:setStickMode(value)
    self._stickMode = value
end

--------------------------------------------------------------------------------
-- スティック変更時のイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnStickChanged(func)
    self:setEventListener(M.EVENT_STICK_CHANGED, func)
end

--------------------------------------------------------------------------------
-- Event Handler.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    local wx, wy = e.x, e.y
    local mx, my = self:worldToModel(wx, wy, 0)
    
    if 0 <= mx and mx <= self:getWidth() and 0 <= my and my <= self:getHeight() then
        self._touchDownFlag = true
        self:updateKnob(mx, my)
    end
end

--------------------------------------------------------------------------------
-- シーンをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if not self._touchDownFlag then
        return
    end

    self._touchDownFlag = false
    local cx, cy = self:getCenterLoc()
    self:updateKnob(cx, cy)
end

--------------------------------------------------------------------------------
-- シーンをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if not self._touchDownFlag then
        return
    end
    
    local layer = self:getLayer()
    local wx, wy = layer:wndToWorld(e.x, e.y, 0)
    local mx, my = self:worldToModel(wx, wy, 0)
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- シーンをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
    self._touchDownFlag = false
    self:setCenterKnob()
end

   
return M