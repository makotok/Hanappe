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
local View                  = require "hp/gui/view/View"

-- class define
local M                     = class(View)
local super                 = View

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
-- Viewの初期化処理を行います.
--------------------------------------------------------------------------------
function M:initComponent()
    self:setSize(Application.screenWidth, Application.screenHeight)
    
    super.initComponent(self)
    
    Executors.callLoop(self.enterFrame, self)
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
    return self:getChildren()
end

return M