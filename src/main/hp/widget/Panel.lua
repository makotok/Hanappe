local table = require("hp/lang/table")
local class = require("hp/lang/class")
local NinePatch = require("hp/display/NinePatch")
local TextLabel = require("hp/display/TextLabel")
local Event = require("hp/event/Event")
local Widget = require("hp/widget/Widget")
local WidgetManager = require("hp/manager/WidgetManager")

----------------------------------------------------------------
-- パネルクラスです.<br>
-- 単純にパネルを表示するだけのものです.
-- @class table
-- @name Panel
----------------------------------------------------------------
local M = class(Widget)

local super = Widget

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    params = params or {}
    
    self:overrideTheme(self:getDefaultTheme())
    self:overrideTheme(params)
    local theme = self:getTheme()
    
    self.background = NinePatch:new({texture = theme.skin, width = theme.width, height = theme.height})
    self.background:setLeft(0)
    self.background:setTop(0)
    
    self:addChild(self.background)
    self:setSize(self.background:getWidth(), self.background:getHeight())

    self:addEventListener("resize", self.onResize, self)

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
function M:onResize(e)
    self.background:setSize(e.newWidth, e.newHeight)
end

return M