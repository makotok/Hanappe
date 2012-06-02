local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Group = require("hp/display/Group")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local WidgetManager = require("hp/manager/WidgetManager")
local ThemeClient = require("hp/widget/ThemeClient")

--------------------------------------------------------------------------------
-- 全てのWidgetが継承すべきクラスです.<br>
-- ウィジットの基本となる機能を提供します.<br>
-- <br>
-- ウィジットはViewに追加して使用します.<br>
-- @class table
-- @name Widget
--------------------------------------------------------------------------------
local M = class(Group, EventDispatcher, ThemeClient)

--------------------------------------------------------------------------------
-- インスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:new(params)
    return Group.new(self, params)
end

--------------------------------------------------------------------------------
-- コンストラクタです.
-- Widgetクラスはこちらを使用すべきです.
--------------------------------------------------------------------------------
function M:init(params)
    Group.init(self)
    EventDispatcher.init(self)
    ThemeClient.init(self)
    
    self:setPrivate("enabled", true)
end

--------------------------------------------------------------------------------
-- レイヤーを設定します.
--------------------------------------------------------------------------------
function M:setParentView(view)
    local parentView = self:getParentView()
    if parentView == view then
        return
    end
    
    if parentView then
        parentView:removeChild(self)
    end
    
    self:setPrivate("parentView", view)
    parentView = view
    
    if parentView then
        parentView:addChild(self)
    end
    
    Group.setLayer(self, parentView)
end

--------------------------------------------------------------------------------
-- 親Viewを返します.
--------------------------------------------------------------------------------
function M:getParentView()
    return self:getPrivate("parentView")
end

--------------------------------------------------------------------------------
-- 指定した座標と子オブジェクトが衝突するか返します.
--------------------------------------------------------------------------------
function M:isHit(worldX, worldY, worldZ, child)
    local props = {self.layer.partition:propListForPoint(worldX, worldY, worldZ)}
    if table.indexOf(props, child) > 0 then
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- 子オブジェクトのいずれかが存在するか返します.
--------------------------------------------------------------------------------
function M:isHitForChildren(worldX, worldY, worldZ)
    local props = {self.layer.partition:propListForPoint(worldX, worldY, worldZ)}
    for i, prop in ipairs(props) do
        if table.indexOf(self.children, prop) > 0 then
            return true
        end
    end
    return false
end

--------------------------------------------------------------------------------
-- ウィジットクラスかどうか返します.
--------------------------------------------------------------------------------
function M:isWidgetClass()
    return true
end

--------------------------------------------------------------------------------
-- ウィジットが有効かどうか設定します.
--------------------------------------------------------------------------------
function M:setEnabled(value)
    if self:isEnabled() ~= value then
        self:setPrivate("enabled", value)
        self:dispatchEvent(Event:new("enabledChanged"))
    end
end

--------------------------------------------------------------------------------
-- ウィジットが有効かどうか返します.
--------------------------------------------------------------------------------
function M:isEnabled()
    return self:getPrivate("enabled")
end

--------------------------------------------------------------------------------
-- ウィジットにフォーカスをセットします.
-- focusManagerがロード済である必要があります.
--------------------------------------------------------------------------------
function M:setFocus()
    local focusManager = self:getFocusManager()
    if focusManager then
        focusManager:setFocusComponent(self)
    end
end

--------------------------------------------------------------------------------
-- フォーカスマネージャーを返します.
-- TODO:未実装
--------------------------------------------------------------------------------
function M:getFocusManager()
    return nil
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    local oldWidth, oldHeight =  self:getWidth(), self:getHeight()
    
    if oldWidth ~= width or oldHeight ~= height then
        self:setPrivate("width", width)
        self:setPrivate("height", height)
        
        local e = Event:new("resize")
        e.oldWidth, e.oldHeight = oldWidth, oldHeight
        e.newWidth, e.newHeight = width, height
        self:dispatchEvent(e)
    end
end

--------------------------------------------------------------------------------
-- フレーム更新時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onEnterFrame(e)
    for i, child in ipairs(self.children) do
        if child.onEnterFrame then
            child:onEnterFrame(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchDown(e)
    for i, child in ipairs(self.children) do
        if child.onTouchDown then
            child:onTouchDown(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchUp(e)
    for i, child in ipairs(self.children) do
        if child.onTouchUp then
            child:onTouchUp(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchMove(e)
    for i, child in ipairs(self.children) do
        if child.onTouchMove then
            child:onTouchMove(e)
        end
    end
end

--------------------------------------------------------------------------------
-- Sceneをタッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchCancel(e)
    for i, child in ipairs(self.children) do
        if child.onTouchCancel then
            child:onTouchCancel(e)
        end
    end
end
    
return M