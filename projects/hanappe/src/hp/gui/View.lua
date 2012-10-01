----------------------------------------------------------------
-- Widgetを格納するViewコンテナです.<br>
-- 全てのウィジットはViewに追加します.<br>
-- <br>
-- また、ViewにViewを追加する事もできます.<br>
-- その場合、自身の描画後に子のViewが描画されます.<br>
-- @class table
-- @name View
----------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local array                 = require "hp/lang/array"
local class                 = require "hp/lang/class"
local Layer                 = require "hp/display/Layer"
local Event                 = require "hp/event/Event"
local Executors             = require "hp/util/Executors"
local Component             = require "hp/gui/Component"
local ViewManager           = require "hp/manager/ViewManager"
local Executors             = require "hp/util/Executors"

-- class define
local super                 = Component
local M                     = class(super)

-- event cache
local EC_TOUCH_DOWN         = Event(Event.TOUCH_DOWN)
local EC_TOUCH_UP           = Event(Event.TOUCH_UP)
local EC_TOUCH_MOVE         = Event(Event.TOUCH_MOVE)
local EC_TOUCH_CANCEL       = Event(Event.TOUCH_CANCEL)

-- タッチ操作の内部処理です.
local function internalEventHandler(obj, e)
    
    local children = obj:getChildren()
    for i = #children, 1, -1 do
        local child = children[i]
        if child.isComponent and child:isEnabled() then
            if internalEventHandler(child, e) then
                return true
            end
        end
    end
    
    if obj.isComponent and obj:isEnabled() then
        obj:dispatchEvent(e)
    end
    return e.stoped
end

local function internalUpdateRenderPriority(obj, priority)
    obj:setPriority(priority)
    priority = priority + 1
    
    if obj.isGroup then
        local children = obj:getChildren()
        for i, child in ipairs(children) do
            priority = internalUpdateRenderPriority(child, priority)
        end
    end
    
    return priority
end

--------------------------------------------------------------------------------
-- 内部変数の初期化を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._priorityUpdateEnabled = true
end

--------------------------------------------------------------------------------
-- Viewの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initComponent(params)
    self:initLayer()
    super.initComponent(self, params)
    
    Executors.callLoop(self.enterFrame, self)
end

--------------------------------------------------------------------------------
-- View自身が元レイヤーを初期化します.
--------------------------------------------------------------------------------
function M:initLayer()
    local layer = Layer()
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    self:setLayer(layer)
    self:setSize(layer:getViewSize())
end

--------------------------------------------------------------------------------
-- シーンを設定します.
--------------------------------------------------------------------------------
function M:setScene(scene)
    if self.scene == scene then
        return
    end
    
    if self.scene then
        self.scene:removeEventListener("destroy", self.sceneDestroyHandler, self)
        self.scene:removeEventListener("touchDown", self.sceneTouchDownHandler, self)
        self.scene:removeEventListener("touchUp", self.sceneTouchUpHandler, self)
        self.scene:removeEventListener("touchMove", self.sceneTouchMoveHandler, self)
        self.scene:removeEventListener("touchCancel", self.sceneTouchCancelHandler, self)
        self.scene:removeChild(self:getLayer())
    end
    
    self.scene = scene
    
    if self.scene then
        self.scene:addEventListener("destroy", self.sceneDestroyHandler, self)
        self.scene:addEventListener("touchDown", self.sceneTouchDownHandler, self)
        self.scene:addEventListener("touchUp", self.sceneTouchUpHandler, self)
        self.scene:addEventListener("touchMove", self.sceneTouchMoveHandler, self)
        self.scene:addEventListener("touchCancel", self.sceneTouchCancelHandler, self)
        self.scene:addChild(self:getLayer())
    end
end

--------------------------------------------------------------------------------
-- フレーム単位の処理を行います.
--------------------------------------------------------------------------------
function M:enterFrame()
    if self._invalidFlag then
        self:updateComponent()
    end
end

--------------------------------------------------------------------------------
-- 描画順序を順番に行うように更新します.
--------------------------------------------------------------------------------
function M:updateLayout()
    super.updateLayout(self)
    if self._priorityUpdateEnabled then
        internalUpdateRenderPriority(self, 1)
    end
end

--------------------------------------------------------------------------------
-- 描画レイヤーテーブルを返します.
--------------------------------------------------------------------------------
function M:getRenderTable()
    return {self:getLayer()}
end

--------------------------------------------------------------------------------
-- 描画順序のプライオリティを自動的に更新するかどうか設定します.
-- パフォーマンスが問題になる場合に、手動でプライオリティを設定する事で、
-- パフォーマンスを向上させる事ができます.
--------------------------------------------------------------------------------
function M:setPriorityUpdateEnabled(value)
    self._priorityUpdateEnabled = value
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneDestroyHandler(e)
    self:dispose()
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchDownHandler(e)
    local ce = table.copy(e, EC_TOUCH_DOWN)
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchUpHandler(e)
    local ce = table.copy(e, EC_TOUCH_UP)
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchMoveHandler(e)
    local ce = table.copy(e, EC_TOUCH_MOVE)
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchCancelHandler(e)
    local ce = table.copy(e, EC_TOUCH_CANCEL)
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

return M