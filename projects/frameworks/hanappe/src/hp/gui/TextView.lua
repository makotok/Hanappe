local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Layer = require("hp/display/Layer")
local Event = require("hp/event/Event")
local EventDispatcher = require("hp/event/EventDispatcher")
local ScrollView = require("hp/widget/ScrollView")
local WidgetManager = require("hp/manager/WidgetManager")

----------------------------------------------------------------
-- テキストをスクロールして表示するViewクラスです.<br>
-- TODO:まだ実装中
-- @class table
-- @name TextView
----------------------------------------------------------------
local M = class(ScrollView)

local super = ScrollView

----------------------------------------------------------------
-- コンストラクタです.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    params = params or {}
    
    self:overrideTheme(self:getDefaultTheme())
    self:overrideTheme(params)
    local theme = self:getTheme()
    
    self.textLabel = TextLabel({text = theme.text, textSize = theme.fontSize})
    self:updateTextLabel()
    self:addChild(self.textLabel)
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:getThemeName()
    return "TextView"
end

--------------------------------------------------------------------------------
-- テキストラベルの状態を更新します.
--------------------------------------------------------------------------------
function M:updateTextLabel()
    local pLeft, pTop, pRight, pBottom = self:getPadding()
    local tWidth = self:getWidth() - pLeft - pRight
    local tHeight = self:getHeight() - pTop - pBottom
    
    self.textLabel:setSize(tWidth, tHeight)
    self.textLabel:setPos(pLeft, pTop)
end

--------------------------------------------------------------------------------
-- テキストをスプールします.
--------------------------------------------------------------------------------
function M:spool()
    self.textLabel:spool()
end

--------------------------------------------------------------------------------
-- テキストを設定します.
--------------------------------------------------------------------------------
function M:setText(text)
    self.textLabel:setString(text)
end

--------------------------------------------------------------------------------
-- テキストの色を設定します.
--------------------------------------------------------------------------------
function M:setTextColor(r, g, b, a)
    self.textLabel:setColor(r, g, b, a)
end

--------------------------------------------------------------------------------
-- テキストサイズを設定します.
--------------------------------------------------------------------------------
function M:setTextSize(points, dpi)
    self.textLabel:setTextSize(points, dpi)
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:onResize(e)
    super.onResize(self, e)
    self:updateTextLabel()
end

return M