local table = require("hp/lang/table")
local class = require("hp/lang/class")
local NinePatch = require("hp/display/NinePatch")
local TextLabel = require("hp/display/TextLabel")
local Event = require("hp/event/Event")
local Widget = require("hp/widget/Widget")
local WidgetManager = require("hp/manager/WidgetManager")

----------------------------------------------------------------
-- パネル内にメッセージを表示するウィジットです.<br>
-- まだ色々機能が足りない.
-- TODO:選択すると、次のメッセージを表示するようにしたい.
-- TODO:RPGでよくあるメッセージボックス機能
-- @class table
-- @name MessageBox
----------------------------------------------------------------
local M = class(Panel)

local super = Panel

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    local theme = self:getTheme()
    
    self.textLabel = TextLabel({text = theme.text, textSize = theme.fontSize})
    self:updateTextLabel()
    self:addChild(self.textLabel)
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:getThemeName()
    return "MessageBox"
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
-- テキストラベルの余白を設定します.
--------------------------------------------------------------------------------
function M:setPadding(left, top, right, bottom)
    self:setStyle("paddingLeft", left)
    self:setStyle("paddingTop", top)
    self:setStyle("paddingRight", right)
    self:setStyle("paddingBottom", bottom)
    self:updateTextLabel()
end

--------------------------------------------------------------------------------
-- テキストラベルの余白を返します.
--------------------------------------------------------------------------------
function M:getPadding()
    return
        self:getStyle("paddingLeft"),
        self:getStyle("paddingTop"),
        self:getStyle("paddingRight"),
        self:getStyle("paddingBottom")
end
--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:onResize(e)
    super.onResize(self, e)
    self:updateTextLabel()
end

return M