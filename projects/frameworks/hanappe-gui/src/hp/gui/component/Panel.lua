--------------------------------------------------------------------------------
-- パネルクラスです.<br>
-- @class table
-- @name Panel
--------------------------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local NinePatch         = require "hp/display/NinePatch"
local TextLabel         = require "hp/display/TextLabel"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/component/Component"

-- class define
local M = class(Component)
local super = Component

----------------------------------------------------------------
-- 子コンポーネントを生成します.
----------------------------------------------------------------
function M:createChildren()
    self.__internal.background = NinePatch()
    
    self:addChild(self.__internal.background)
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:getThemeName()
    return "Panel"
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    self.__internal.background:setSize(e.newWidth, e.newHeight)
end

return M