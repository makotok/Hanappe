local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Sprite = require("hp/display/Sprite")
local Group = require("hp/display/Group")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local Logger = require("hp/util/Logger")

----------------------------------------------------------------
-- ゲームの仮想ジョイスティックのウィジットクラスです.<br>
-- @class table
-- @name Sprite
----------------------------------------------------------------
local M = class(Group, EventDispatcher)

-- constraints
M.STICK_CENTER = "center"
M.STICK_LEFT = "left"
M.STICK_TOP = "top"
M.STICK_RIGHT = "right"
M.STICK_BOTTOM = "bottom"

M.MODE_ANALOG = 1
M.MODE_DIGITAL = 2

M.RANGE_OF_CENTER_RATE = 0.5

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:new(params)
    local obj = Group.new(self, params)
    EventDispatcher.init(obj)

    assert(params)
    assert(params.baseTexture)
    assert(params.knobTexture)

    local baseSprite = Sprite:new({texture = params.baseTexture, layer = params.layer, left = 0, top = 0})
    local knobSprite = Sprite:new({texture = params.knobTexture, layer = params.layer, left = 0, top = 0})
    
    obj.baseSprite = baseSprite
    obj.knobSprite = knobSprite
    
    obj:addChild(baseSprite)
    obj:addChild(knobSprite)
    
    obj.stickMode = params.stickMode or M.MODE_ANALOG
    obj.rangeOfCenterRate = M.RANGE_OF_CENTER_RATE
    obj.changedEvent = Event:new("stickChanged")
    
    obj:setWidth(baseSprite:getWidth())
    obj:setHeight(baseSprite:getHeight())
    obj:setCenterKnob()

    return obj
end

--------------------------------------------------------------------------------
-- レイヤーを設定します.
--------------------------------------------------------------------------------
function M:setLayer(layer)
    if not layer.partition then
        local partition = MOAIPartition.new()
        layer:setPartition(partition)
        layer.partition = partition
    end
    Group.setLayer(self, layer)
end

--------------------------------------------------------------------------------
-- シーンを設定します.
--------------------------------------------------------------------------------
function M:setScene(scene)
    if self.scene then
        self.scene:removeEventListener("touchDown", self.onSceneTouchDown, self)
        self.scene:removeEventListener("touchUp", self.onSceneTouchUp, self)
        self.scene:removeEventListener("touchMove", self.onSceneTouchMove, self)
        self.scene:removeEventListener("touchCancel", self.onSceneTouchCancel, self)
    end
    
    self.scene = scene
    
    if self.scene then
        self.scene:addEventListener("touchDown", self.onSceneTouchDown, self)
        self.scene:addEventListener("touchUp", self.onSceneTouchUp, self)
        self.scene:addEventListener("touchMove", self.onSceneTouchMove, self)
        self.scene:addEventListener("touchCancel", self.onSceneTouchCancel, self)
    end
end

--------------------------------------------------------------------------------
-- シーンをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onSceneTouchDown(e)
    local wx, wy = self.layer:wndToWorld(e.x, e.y, 0)
    local mx, my = self:worldToModel(wx, wy, 0)
    
    if 0 <= mx and mx <= self:getWidth() and 0 <= my and my <= self:getHeight() then
        self.touchDownFlag = true
        self:updateKnob(mx, my)
    end
end

--------------------------------------------------------------------------------
-- シーンをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onSceneTouchUp(e)
    if not self.touchDownFlag then
        return
    end

    self.touchDownFlag = false
    local cx, cy = self:getCenterLoc()
    self:updateKnob(cx, cy)
end

--------------------------------------------------------------------------------
-- シーンをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onSceneTouchMove(e)
    if not self.touchDownFlag then
        return
    end
    
    local wx, wy = self.layer:wndToWorld(e.x, e.y, 0)
    local mx, my = self:worldToModel(wx, wy, 0)
    self:updateKnob(mx, my)
end

--------------------------------------------------------------------------------
-- シーンをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onSceneTouchCancel(e)
    self.touchDownFlag = false
    self:setCenterKnob()
end

--------------------------------------------------------------------------------
-- knobSpriteの更新処理を行います.
--------------------------------------------------------------------------------
function M:updateKnob(x, y)
    local oldX, oldY = self.knobSprite:getLoc()
    local newX, newY = self:getKnobNewLoc(x, y)

    -- change loc
    if oldX ~= newX or oldY ~= newY then
        self.knobSprite:setLoc(newX, newY, 0)
    
        local event = self.changedEvent
        event.oldX, event.oldY = self:getKnobInputRate(oldX, oldY)
        event.newX, event.newY = self:getKnobInputRate(newX, newY)
        event.direction = self:getStickDirection()
        event.down = self.touchDownFlag
        self:dispatchEvent(event)
    end
end

--------------------------------------------------------------------------------
-- knobSpriteの座標を中心点に設定します.
--------------------------------------------------------------------------------
function M:setCenterKnob()
    local cx, cy = self:getWidth() / 2, self:getHeight() / 2
    self.knobSprite:setLoc(cx, cy, 0)
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
    if self.stickMode == M.MODE_ANALOG then
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
    local cRate = self.rangeOfCenterRate
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
    local x, y = self.knobSprite:getLoc()
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
    
return M