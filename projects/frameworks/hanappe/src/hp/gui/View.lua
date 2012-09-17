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

-- class define
local M                     = class(Component)
local super                 = Component

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
    self._viewLayer = nil
    self._rootView = false
end

--------------------------------------------------------------------------------
-- Viewの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initComponent(params)
    self:initViewLayer()
    super.initComponent(self, params)
end

--------------------------------------------------------------------------------
-- View自身が元レイヤーを初期化します.
--------------------------------------------------------------------------------
function M:initViewLayer()
    self._viewLayer = Layer()
    self._viewLayer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    self:setLayer(self._viewLayer)
    self:setSize(self._viewLayer:getViewSize())
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
        self.scene:removeEventListener("keyDown", self.sceneKeyDownHandler, self)
        self.scene:removeEventListener("keyUp", self.sceneKeyUpHandler, self)
        self.scene:removeChild(self._viewLayer)
        self._rootView = false
        
        ViewManager:removeRootView(self)
    end
    
    self.scene = scene
    
    if self.scene then
        self.scene:addEventListener("destroy", self.sceneDestroyHandler, self)
        self.scene:addEventListener("touchDown", self.sceneTouchDownHandler, self)
        self.scene:addEventListener("touchUp", self.sceneTouchUpHandler, self)
        self.scene:addEventListener("touchMove", self.sceneTouchMoveHandler, self)
        self.scene:addEventListener("touchCancel", self.sceneTouchCancelHandler, self)
        self.scene:addEventListener("keyDown", self.sceneKeyDownHandler, self)
        self.scene:addEventListener("keyUp", self.sceneKeyUpHandler, self)
        self.scene:addChild(self._viewLayer)
        self._rootView = true
        
        ViewManager:addRootView(self)
    end
end

--------------------------------------------------------------------------------
-- 描画順序を順番に行うように更新します.
--------------------------------------------------------------------------------
function M:updateLayout()
    super.updateLayout(self)
    internalUpdateRenderPriority(self, 1)
end

--------------------------------------------------------------------------------
-- 描画レイヤーテーブルを返します.
--------------------------------------------------------------------------------
function M:getRenderTable()
    return {self:getLayer()}
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneDestroyHandler(e)
    local ce = table.copy(e, Event("destroy"))
    internalEventHandler(self, ce)
    
    ViewManager:removeRootView(self)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchDownHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_DOWN))
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchUpHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_UP))
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchMoveHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_MOVE))
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchCancelHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_CANCEL))
    ce.worldX, ce.worldY = self:getLayer():wndToWorld(e.x, e.y, e.z)
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- キーを押下した時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneKeyDownHandler(e)
    local ce = table.copy(e, Event(Event.KEY_DOWN))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- キーを押下した時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneKeyUpHandler(e)
    local ce = table.copy(e, Event(Event.KEY_UP))
    internalEventHandler(self, ce)
end

return M