local table = require("hp/lang/table")
local class = require("hp/lang/class")
local NinePatch = require("hp/display/NinePatch")
local Event = require("hp/event/Event")
local Widget = require("hp/widget/Widget")
local WidgetManager = require("hp/manager/WidgetManager")

----------------------------------------------------------------
-- スクロールバー共通クラスです.<br>
-- @class table
-- @name ScrollBarBase
----------------------------------------------------------------
local M = class(Widget)

local super = Widget

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    
    params = params or self:getDefaultTheme()
    assert(params.skin)
    
    self.skin = params.skin
    
    self.background = NinePatch:new({texture = self.skin})
    self.background:setLeft(0)
    self.background:setTop(0)
    
    self:addChild(self.background)
    self:setSize(self.background:getWidth(), self.background:getHeight())

    self:addEventListener("resize", self.onResize, self)
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:getDefaultTheme()
    return WidgetManager:getDefaultTheme()["ScrollBar"]
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:onResize(e)
    self.background:setSize(e.newWidth, e.newHeight)
end

return M