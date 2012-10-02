--------------------------------------------------------------------------------
-- This class inherits the MOAILayer. <br>
-- Simplifies the generation of a set of size and layer. <br>
--
-- @auther Makoto
-- @class table
-- @name Layer
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

--
local function getPointByCache(self, e)
    for i, p in ipairs(self._touchPoints) do
        if p.idx == e.idx then
            return p
        end
    end
end

-- 
local function getPointByEvent(self, e)
    local layer = self._touchLayer

    local p = getPointByCache(self, e) or {}
    p.idx = e.idx
    p.tapCount = e.tapCount
    p.oldX, p.oldY = p.x, p.y
    p.x, p.y = layer:wndToWorld(e.x, e.y, 0)
    p.screenX, p.screenY = e.x, e.y
    
    if p.oldX and p.oldY then
        p.moveX = p.x - p.oldX
        p.moveY = p.y - p.oldY
    else
        p.oldX, p.oldY = p.x, p.y
        p.moveX, p.moveY = 0, 0
    end
    
    return p
end

local function eventHandle(self, e, o)
    local layer = self._touchLayer
    while o do
        if o.dispatchEvent then
            o:dispatchEvent(e)
        end
        if o.getParent then
            o = o:getParent()
        else
            o = nil
        end
    end
end

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:init(layer)
    self._touchLayer        = assert(layer)
    self._touchPoints       = {}
    self._scene             = nil
    self:setScene(self._touchLayer:getScene())
end

--------------------------------------------------------------------------------
-- イベントリスナの待ち受けを開始します.
--------------------------------------------------------------------------------
function M:setScene(scene)
    if self._scene == scene then
        return
    end
    
    if self._scene then
        self._scene:removeEventListener(Event.TOUCH_DOWN, self.touchDownHandler, self)
        self._scene:removeEventListener(Event.TOUCH_UP, self.touchUpHandler, self)
        self._scene:removeEventListener(Event.TOUCH_MOVE, self.touchMoveHandler, self)
        self._scene:removeEventListener(Event.TOUCH_CANCEL, self.touchCancelHandler, self)
    end
    
    self._scene = scene
    
    if self._scene then
        self._scene:addEventListener(Event.TOUCH_DOWN, self.touchDownHandler, self)
        self._scene:addEventListener(Event.TOUCH_UP, self.touchUpHandler, self)
        self._scene:addEventListener(Event.TOUCH_MOVE, self.touchMoveHandler, self)
        self._scene:addEventListener(Event.TOUCH_CANCEL, self.touchCancelHandler, self)
    end

end

--------------------------------------------------------------------------------
-- タッチした時のイベント処理を行います.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    local layer = self._touchLayer

    local p = getPointByEvent(self, e)
    p.touchingProp = layer:getPartition():propForPoint(p.x, p.y, 0)
    table.insertElement(self._touchPoints, p)
    
    local te = table.copy(p, EVENT_TOUCH_DOWN)
    te.points = self._touchPoints

    if p.touchingProp then
        eventHandle(self, te, p.touchingProp)
    end
end

----------------------------------------------------------------
-- タッチした時のイベント処理を行います.
----------------------------------------------------------------
function M:touchUpHandler(e)
    local layer = self._touchLayer

    local p = getPointByEvent(self, e)
    local te = table.copy(p, EVENT_TOUCH_UP)
    
    if p.touchingProp then
        eventHandle(self, te, p.touchingProp)
    end
    
    local o = layer:getPartition():propForPoint(p.x, p.y, 0)
    if o and o ~= p.touchingProp then
        eventHandle(self, te, o)
    end
    
    table.removeElement(self._touchPoints, p)
end

----------------------------------------------------------------
-- タッチした時のイベント処理を行います.
----------------------------------------------------------------
function M:touchMoveHandler(e)
    local layer = self._touchLayer

    local p = getPointByEvent(self, e)
    local te = table.copy(p, EVENT_TOUCH_MOVE)
    
    if p.touchingProp then
        eventHandle(self, te, p.touchingProp)
    end
    
    local o = layer:getPartition():propForPoint(p.x, p.y, 0)
    if o and o ~= p.touchingProp then
        eventHandle(self, te, o)
    end
end

----------------------------------------------------------------
-- タッチした時のイベント処理を行います.
----------------------------------------------------------------
function M:touchCancelHandler(e)
    local layer = self._touchLayer

    local p = getPointByEvent(self, e)
    local te = table.copy(p, EVENT_TOUCH_CANCEL)
    
    if p.touchingProp then
        eventHandle(self, te, p.touchingProp)
    end
    
    local o = layer:propForPoint(p.x, p.y, 0)
    if o and o ~= p.touchingProp then
        eventHandle(self, te, o)
    end
    
    table.removeElement(self._touchPoints, p)
end

return M