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
local Component             = require "hp/gui/component/Component"

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

--------------------------------------------------------------------------------
-- 内部変数の初期化を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._destroyed = false
end

--------------------------------------------------------------------------------
-- Viewの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initComponent()
    self._viewLayer = Layer()
    self._viewLayer:setParent(self)
    self:setLayer(self._viewLayer)
    self:setSize(self._viewLayer:getScreenSize())
    
    super.initComponent(self)
    
    Executors.callLoop(self.enterFrame, self)
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
        self.scene:removeChild(self)
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
        self.scene:addChild(self)
    end
end

--------------------------------------------------------------------------------
-- フレーム更新時のイベントリスナです.
--------------------------------------------------------------------------------
function M:enterFrame()
    if self._destroyed then
        return true
    end
    self:updateComponent()
end

--------------------------------------------------------------------------------
-- サイズ変更時にレイヤーのサイズも変更します.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    super.setSize(self, width, height)
    self._viewLayer:setScreenSize(width, height)
    self._viewLayer:setViewSize(width, height)
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
    
    self._destroyed = true
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchDownHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_DOWN))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchUpHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_UP))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchMoveHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_MOVE))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:sceneTouchCancelHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_CANCEL))
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