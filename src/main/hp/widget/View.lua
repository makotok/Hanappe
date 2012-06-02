local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Application = require("hp/Application")
local Layer = require("hp/display/Layer")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local ThemeClient = require("hp/widget/ThemeClient")

----------------------------------------------------------------
-- Widgetを格納するViewコンテナです.<br>
-- 全てのウィジットはViewに追加します.<br>
-- <br>
-- また、ViewにViewを追加する事もできます.<br>
-- その場合、自身の描画後に子のViewが描画されます.<br>
-- @class table
-- @name View
----------------------------------------------------------------
local M = class(Layer, EventDispatcher, ThemeClient)
M.new = Layer.new

local super = Layer

----------------------------------------------------------------
-- コンストラクタです.
----------------------------------------------------------------
function M:init(params)
    Layer.init(self)
    EventDispatcher.init(self)
    ThemeClient.init(self)
    
    self:setPrivate("children", {})
    self:setPrivate("enabled", true)
end

--------------------------------------------------------------------------------
-- 画面上のサイズを設定します.
-- サイズを設定すると、Viewのサイズも設定されます.
--------------------------------------------------------------------------------
function M:setScreenSize(width, height)
    super.setScreenSize(self, width, height)
    --self.viewport:setSize(width, height)
end

--------------------------------------------------------------------------------
-- シーンを設定します.
-- 親のViewが存在する場合は、Sceneを設定するとよくないので無効化されます.
--------------------------------------------------------------------------------
function M:setScene(scene)
    if self:getParentView() then
        return
    end
    
    if self.scene then
        self.scene:removeEventListener("enterFrame", self.onEnterFrame, self)
        self.scene:removeEventListener("touchDown", self.onTouchDown, self)
        self.scene:removeEventListener("touchUp", self.onTouchUp, self)
        self.scene:removeEventListener("touchMove", self.onTouchMove, self)
        self.scene:removeEventListener("touchCancel", self.onTouchCancel, self)
        self.scene:removeChild(self)
    end
    
    self.scene = scene
    
    if self.scene then
        self.scene:addEventListener("enterFrame", self.onEnterFrame, self)
        self.scene:addEventListener("touchDown", self.onTouchDown, self)
        self.scene:addEventListener("touchUp", self.onTouchUp, self)
        self.scene:addEventListener("touchMove", self.onTouchMove, self)
        self.scene:addEventListener("touchCancel", self.onTouchCancel, self)
        self.scene:addChild(self)
    end
end

----------------------------------------------------------------
-- 描画テーブルを返します.
----------------------------------------------------------------
function M:getRenderTable()
    return {self}
end

----------------------------------------------------------------
-- 子オブジェクト達を返します.
----------------------------------------------------------------
function M:getChildren()
    return self:getPrivate("children")
end

----------------------------------------------------------------
-- 親のViewを返します.
----------------------------------------------------------------
function M:getParentView()
    return self:getPrivate("parentView")
end

----------------------------------------------------------------
-- 親のViewを設定します.
----------------------------------------------------------------
function M:setParentView(view)
    local parentView = self:getParentView()
    if parentView == view then
        return
    end
    
    if parentView then
        parentView:removeView(self)
    end
    
    self:setPrivate("parentView", view)
    parentView = view

    if parentView then
        parentView:addView(self)
    end
end

----------------------------------------------------------------
-- 子オブジェクトを追加します.
----------------------------------------------------------------
function M:addChild(child)
    local children = self:getChildren()
    local index = table.indexOf(children, child)
    if index > 0 then
        return
    end
    
    table.insert(children, child)
    if self.isWidgetClass then
        child:setParentView(self)
    elseif child.setLayer then
        child:setLayer(self)
    else
        self:insertProp(child)
    end
end

----------------------------------------------------------------
-- 子オブジェクトを削除します.
----------------------------------------------------------------
function M:removeChild(child)
    local children = self:getChildren()
    local index = table.indexOf(children, child)
    if index <= 0 then
        return
    end
    
    table.remove(children, index)
    child:setParentView(nil)
end

--------------------------------------------------------------------------------
-- Viewクラスかどうか返します.
-- 内部的な判定ロジックに使用されます.
--------------------------------------------------------------------------------
function M:isViewClass()
    return true
end

--------------------------------------------------------------------------------
-- Viewが有効かどうか設定します.
--------------------------------------------------------------------------------
function M:setEnabled(value)
    if self:isEnabled() ~= value then
        self:setPrivate("enabled", value)
        self:dispatchEvent(Event:new("enabledChanged"))
    end
end

--------------------------------------------------------------------------------
-- Viewが有効かどうか返します.
--------------------------------------------------------------------------------
function M:isEnabled()
    return self:getPrivate("enabled")
end

--------------------------------------------------------------------------------
-- フレーム更新時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onEnterFrame(e)
    for i, child in ipairs(self:getChildren()) do
        if child.onEnterFrame then
            child:onEnterFrame(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchDown(e)
    for i, child in ipairs(self:getChildren()) do
        if child.onTouchDown then
            child:onTouchDown(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchUp(e)
    for i, child in ipairs(self:getChildren()) do
        if child.onTouchUp then
            child:onTouchUp(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchMove(e)
    for i, child in ipairs(self:getChildren()) do
        if child.onTouchMove then
            child:onTouchMove(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchCancel(e)
    for i, child in ipairs(self:getChildren()) do
        if child.onTouchCancel then
            child:onTouchCancel(e)
        end
    end
end

return M