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
local M = class(Panel)

local super = Panel

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    params = params or self:getDefaultTheme()
    
    local paddingLeft = params.paddingLeft or 10
    local paddingTop = params.paddingTop or 10
    local paddingRight = params.paddingRight or 10
    local paddingBottom = params.paddingBottom or 10
    
    self.textLabel = TextLabel:new({text = params.text, textSize = params.fontSize})
    self:setPadding(paddingLeft, paddingTop, paddingRight, paddingBottom)
    self:addChild(self.textLabel)
end

--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:getDefaultTheme()
    return WidgetManager:getDefaultTheme()["MessageBox"]
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
    
    print("text:", tWidth, tHeight)
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
    self:setPrivate("paddingLeft", left)
    self:setPrivate("paddingTop", top)
    self:setPrivate("paddingRight", right)
    self:setPrivate("paddingBottom", bottom)
    self:updateTextLabel()
end

--------------------------------------------------------------------------------
-- テキストラベルの余白を返します.
--------------------------------------------------------------------------------
function M:getPadding()
    return
        self:getPrivate("paddingLeft"),
        self:getPrivate("paddingTop"),
        self:getPrivate("paddingRight"),
        self:getPrivate("paddingBottom")
end
--------------------------------------------------------------------------------
-- サイズ変更時に子の大きさも変更します.
--------------------------------------------------------------------------------
function M:onResize(e)
    super.onResize(self, e)
    self:updateTextLabel()
end

return M