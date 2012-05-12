local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Group = require("hp/display/Group")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local WidgetManager = require("hp/manager/WidgetManager")

--------------------------------------------------------------------------------
-- 全てのWidgetが継承すべきクラスです.<br>
-- ウィジットの基本となる機能を提供します.<br>
-- <br>
-- ウィジットを使用する場合の制約として、Sceneクラスを使用する必要があります.<br>
-- Scene上にウィジットを構築する事により、面倒な実装を回避できます.<br>
-- Scene上にウィジットを構築しない場合、イベントのトリガーを自前で行う必要があります.
-- @class table
-- @name Widget
--------------------------------------------------------------------------------
local M = class(Group, EventDispatcher)

--------------------------------------------------------------------------------
-- インスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:new(params)
    local obj = Group.new(self)
    EventDispatcher.init(obj)
    
    if obj.init then
        obj:init(params)
    end
    
    obj:includeFunctions()
    obj:excludeFunctions()

    return obj
end

--------------------------------------------------------------------------------
-- コンストラクタです.
-- Widgetクラスはこちらを使用すべきです.
--------------------------------------------------------------------------------
function M:init(params)
    self:setPrivateValue("enabled", true)
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
    self.setLayer = nil
    self.excludeFunctions = nil
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
-- フレーム更新時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onEnterFrame(e)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchDown(e)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchUp(e)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchMove(e)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchCancel(e)
end

    
return M