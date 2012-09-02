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
local M                     = class(Layer)
local super                 = Layer
local MOAILayerInterface    = MOAILayer.getInterfaceTable()

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
-- コンストラクタです.
--------------------------------------------------------------------------------
function M:init(params)
    super.init(self)
    self:initInternal()
    self:initView()
    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- 内部変数の初期化を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    self.__internal.children = {}
    self.__internal.enabled = true
    self.__internal.destroyed = false
end

--------------------------------------------------------------------------------
-- Viewの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initView()
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
        self.scene:removeEventListener("destroy", self.destroyHandler, self)
        self.scene:removeEventListener("touchDown", self.touchDownHandler, self)
        self.scene:removeEventListener("touchUp", self.touchUpHandler, self)
        self.scene:removeEventListener("touchMove", self.touchMoveHandler, self)
        self.scene:removeEventListener("touchCancel", self.touchCancelHandler, self)
        self.scene:removeEventListener("keyDown", self.keyDownHandler, self)
        self.scene:removeEventListener("keyUp", self.keyUpHandler, self)
        self.scene:removeChild(self)
    end
    
    self.scene = scene
    
    if self.scene then
        self.scene:addEventListener("touchDown", self.touchDownHandler, self)
        self.scene:addEventListener("touchUp", self.touchUpHandler, self)
        self.scene:addEventListener("touchMove", self.touchMoveHandler, self)
        self.scene:addEventListener("touchCancel", self.touchCancelHandler, self)
        self.scene:addEventListener("keyDown", self.keyDownHandler, self)
        self.scene:addEventListener("keyUp", self.keyUpHandler, self)
        self.scene:addChild(self)
    end
end

--------------------------------------------------------------------------------
-- 子オブジェクトをクリアします.
--------------------------------------------------------------------------------
function M:clear()
    for i, v in ipairs(self:getChildren()) do
        v:setLayer(nil)
    end
    self.__internal.children = {}
    
    MOAILayerInterface.clear(self)
end

--------------------------------------------------------------------------------
-- 子オブジェクト達を返します.
--------------------------------------------------------------------------------
function M:getChildren()
    return self.__internal.children
end

--------------------------------------------------------------------------------
-- 子オブジェクト達を設定します.
--------------------------------------------------------------------------------
function M:setChildren(children)
    self:clear()
    self:addChildren(children)
end

--------------------------------------------------------------------------------
-- 子オブジェクトを追加します.
--------------------------------------------------------------------------------
function M:addChildren(children)
    for i, child in ipairs(children) do
        self:addChild(child)
    end
end

--------------------------------------------------------------------------------
-- 子オブジェクトを追加します.
--------------------------------------------------------------------------------
function M:addChild(child)
    local children = self:getChildren()
    
    if table.insertElement(children, child) then
        child:setLayer(self)
    end
    
end

--------------------------------------------------------------------------------
-- 子オブジェクトを削除します.
--------------------------------------------------------------------------------
function M:removeChild(child)
    local children = self:getChildren()
    
    if table.removeElement(children, child) then
        child:setLayer(nil)
    end
end

--------------------------------------------------------------------------------
-- Viewが有効かどうか設定します.
--------------------------------------------------------------------------------
function M:setEnabled(value)
    if self:isEnabled() ~= value then
        self.__internal.enabled = value
        self:dispatchEvent("enabledChanged")
    end
end

--------------------------------------------------------------------------------
-- Viewが有効かどうか返します.
--------------------------------------------------------------------------------
function M:isEnabled()
    return self.__internal.enabled
end

--------------------------------------------------------------------------------
-- フレーム更新時のイベントリスナです.
--------------------------------------------------------------------------------
function M:enterFrame()
    if self.__internal.destroyed then
        return true
    end
    for i, child in ipairs(self:getChildren()) do
        if child.updateComponent then
            child:updateComponent()
        end
    end
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:destroyHandler(e)
    local ce = table.copy(e, Event("destroy"))
    internalEventHandler(self, ce)
    
    self.__internal.destroyed = true
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_DOWN))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_UP))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_MOVE))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
    local ce = table.copy(e, Event(Event.TOUCH_CANCEL))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- キーを押下した時のイベントリスナです.
--------------------------------------------------------------------------------
function M:keyDownHandler(e)
    local ce = table.copy(e, Event(Event.KEY_DOWN))
    internalEventHandler(self, ce)
end

--------------------------------------------------------------------------------
-- キーを押下した時のイベントリスナです.
--------------------------------------------------------------------------------
function M:keyUpHandler(e)
    local ce = table.copy(e, Event(Event.KEY_UP))
    internalEventHandler(self, ce)
end

return M