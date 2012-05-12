local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Layer = require("hp/display/Layer")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")

----------------------------------------------------------------
-- Widgetを格納するViewコンテナです.<br>
-- 全てのウィジットはViewに追加します.<br>
-- <br>
-- また、ViewにViewを追加する事もできます.<br>
-- その場合、自身の描画後に子のViewが描画されます.<br>
-- @class table
-- @name View
----------------------------------------------------------------
local M = class(Layer, EventDispatcher)

--------------------------------------------------------------------------------
-- インスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:new(params)
    local obj = Layer.new(self)
    EventDispatcher.init(obj)

    if obj.init then
        obj:init(params)
    end
    
    obj:includeFunctions()
    obj:excludeFunctions()

    return obj
end

----------------------------------------------------------------
-- コンストラクタです.
----------------------------------------------------------------
function M:init(params)
    self:setPrivate("children", {})
    self:setPrivate("views", {})
end

----------------------------------------------------------------
-- 使用する関数を追加します.
----------------------------------------------------------------
function M:includeFunctions()
end

----------------------------------------------------------------
-- 使用するべきでない関数を除外します.
----------------------------------------------------------------
function M:excludeFunctions()
    self.new = nil
    self.init = nil
    self.excludeFunctions = nil
end

--------------------------------------------------------------------------------
-- シーンを設定します.
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
    return {self, unpack(self:getViews())}
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
    assert(child.isWidgetClass, "Not Widget")
    
    local children = self:getChildren()
    local index = table.indexOf(children, child)
    if index > 0 then
        return
    end
    
    table.insert(children, child)
    child:setParentView(self)
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

----------------------------------------------------------------
-- 子のviewリストを返します.
----------------------------------------------------------------
function M:getViews()
    return self:getPrivate("views")
end

----------------------------------------------------------------
-- 子のviewを追加します.
----------------------------------------------------------------
function M:addView(view)
    assert(child.isViewClass, "Not view")
    
    local views = self:getViews()
    local index = table.indexOf(views, view)
    if index > 0 then
        return
    end
    
    table.insert(views, view)
    view:setAttrLink(MOAITransform.INHERIT_TRANSFORM, self, MOAITransform.TRANSFORM_TRAIT)
    view:setAttrLink(MOAIColor.INHERIT_COLOR, self, MOAIColor.COLOR_TRAIT)
    view:setParentView(self)
end

----------------------------------------------------------------
-- 子Viewを削除します.
----------------------------------------------------------------
function M:removeView(view)
    local views = self:getViews()
    local index = table.indexOf(views, child)
    if index <= 0 then
        return
    end
    
    table.remove(views, index)
    view:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)
    view:clearAttrLink(MOAIColor.INHERIT_COLOR)
    view:setParentView(nil)
end

--------------------------------------------------------------------------------
-- Viewクラスかどうか返します.
-- 内部的な判定ロジックに使用されます.
--------------------------------------------------------------------------------
function M:isViewClass()
    return true
end

--------------------------------------------------------------------------------
-- フレーム更新時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onEnterFrame(e)
    for i, child in ipairs(self:getChildren()) do
        child:onEnterFrame(e)
    end
    for i, view in ipairs(self:getViews()) do
        view:onEnterFrame(e)
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchDown(e)
    for i, child in ipairs(self:getChildren()) do
        child:onTouchDown(e)
    end
    for i, view in ipairs(self:getViews()) do
        view:onTouchDown(e)
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchUp(e)
    for i, child in ipairs(self:getChildren()) do
        child:onTouchUp(e)
    end
    for i, view in ipairs(self:getViews()) do
        view:onTouchUp(e)
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchMove(e)
    for i, child in ipairs(self:getChildren()) do
        child:onTouchMove(e)
    end
    for i, view in ipairs(self:getViews()) do
        view:onTouchMove(e)
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchCancel(e)
    for i, child in ipairs(self:getChildren()) do
        child:onTouchCancel(e)
    end
    for i, view in ipairs(self:getViews()) do
        view:onTouchCancel(e)
    end
end

return M