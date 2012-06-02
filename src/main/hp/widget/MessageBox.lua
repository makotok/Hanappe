local table = require("hp/lang/table")
local class = require("hp/lang/class")
local delegate = require("hp/lang/delegate")
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
    
    self.textLabel = TextLabel({text = theme.text, textSize = theme.textSize})
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
-- サイズを変更した場合に自動的に更新されます.
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
    return self.textLabel:spool()
end

--------------------------------------------------------------------------------
-- 次のページを表示します.
--------------------------------------------------------------------------------
function M:nextPage()
    return self.textLabel:nextPage()
end

--------------------------------------------------------------------------------
-- 次のページが存在するか返します.
--------------------------------------------------------------------------------
function M:more()
    return self.textLabel:more()
end

--------------------------------------------------------------------------------
-- メッセージの表示処理中かどうか返します.
--------------------------------------------------------------------------------
function M:isBusy()
    return self.textLabel:isBusy()
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

--------------------------------------------------------------------------------
-- 画面をタッチした時の処理を行います.
--------------------------------------------------------------------------------
function M:onTouchDown(e)
    if not self:isEnabled() then
        return
    end
    
    if self:hitTestScreen(e.x, e.y) then
        if self:isBusy() then
            -- TODO:スプール中のメッセージを全て
        elseif self:more() then
            self:nextPage()
            self:spool()
        else
            self:onMessageEnd()
        end
    end
end

--------------------------------------------------------------------------------
-- メッセージが終了した場合に呼ばれます.
--------------------------------------------------------------------------------
function M:onMessageEnd()
    self:hidePopup()
end

--------------------------------------------------------------------------------
-- ポップアップエフェクトでメッセージボックスを表示します.
--------------------------------------------------------------------------------
function M:showPopup()
    self:show()
    self:setCenterPiv()
    self.textLabel:setReveal(0)
    self:setScl(0, 0, 0)
    local action = self:seekScl(1, 1, 1, 0.5)
    action:setListener(MOAIAction.EVENT_STOP, function() self:spool() end)
end

--------------------------------------------------------------------------------
-- ポップアップエフェクトでメッセージボックスを非表示にします.
--------------------------------------------------------------------------------
function M:hidePopup()
    local action = self:seekScl(0, 0, 0, 0.5)
    action:setListener(MOAIAction.EVENT_STOP,
        function()
            self:hide()
            self:setScl(1, 1, 1)
        end
    )
end

return M