----------------------------------------------------------------
-- パネル内にメッセージを表示するウィジットです.<br>
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local NinePatch         = require "hp/display/NinePatch"
local TextLabel         = require "hp/display/TextLabel"
local Animation         = require "hp/display/Animation"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"
local Panel             = require "hp/gui/Panel"

-- class
local M                 = class(Panel)
local super             = Panel

-- Events
M.EVENT_MESSAGE_SHOW    = "messageShow"
M.EVENT_MESSAGE_END     = "messageEnd"
M.EVENT_MESSAGE_HIDE    = "messageHide"

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    
    self._themeName = "MessageBox"
    self._messageHideEnabled = true
    self._spoolingEnabled = true
    
    self._popInAnimation = Animation():parallel(
        Animation(self, 0.5):setScl(0.8, 0.8, 1):seekScl(1, 1, 1),
        Animation(self, 0.5):setColor(0, 0, 0, 0):seekColor(1, 1, 1, 1)
    )
    self._popOutAnimation = Animation():parallel(
        Animation(self, 0.5):seekScl(0.8, 0.8, 1),
        Animation(self, 0.5):seekColor(0, 0, 0, 0)
    )
end

----------------------------------------------------------------
-- 子オブジェクトの生成処理を行います..
----------------------------------------------------------------
function M:createChildren()
    super.createChildren(self)
    
    self._textLabel = TextLabel()
    self._textLabel:setWordBreak(MOAITextBox.WORD_BREAK_CHAR)
    self:addChild(self._textLabel)
    
    self:setColor(0, 0, 0, 0)
end

--------------------------------------------------------------------------------
-- テキストラベルの状態を更新します.
-- サイズを変更した場合に自動的に更新されます.
--------------------------------------------------------------------------------
function M:updateDisplay()
    super.updateDisplay(self)

    local pLeft, pTop, pRight, pBottom = unpack(self:getStyle("textPadding"))
    local tWidth = self:getWidth() - pLeft - pRight
    local tHeight = self:getHeight() - pTop - pBottom
    
    self._textLabel:setSize(tWidth, tHeight)
    self._textLabel:setPos(pLeft, pTop)
    self._textLabel:setColor(unpack(self:getStyle("textColor")))
    self._textLabel:setTextSize(self:getStyle("textSize"))
    self._textLabel:setFont(self:getStyle("font"))
end

--------------------------------------------------------------------------------
-- Turns spooling ON or OFF.
-- If self is currently spooling and enable is false, stop spooling and reveal 
-- entire page. 
-- @param enable Boolean for new state
-- @return none
-------------------------------------------------------------------------------
function M:spoolingEnabled(enable)
    self._spoolingEnabled = enable and true or false
    if self._spoolingEnabled == false and self:isBusy() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    end
end

--------------------------------------------------------------------------------
-- ポップアップエフェクトでメッセージボックスを表示します.
--------------------------------------------------------------------------------
function M:show()
    self:setVisible(true)
    self:setCenterPiv()
    self:setText(self:getText())

    if self._spoolingEnabled then
        self._textLabel:setReveal(0)
    end
    self._popInAnimation:play {onComplete =
        function()
            if self._spoolingEnabled then
                self:spool()
            end
            self:dispatchEvent(M.EVENT_MESSAGE_SHOW)
        end
    }
end

--------------------------------------------------------------------------------
-- ポップアップエフェクトでメッセージボックスを非表示にします.
--------------------------------------------------------------------------------
function M:hide()
    if self._popInAnimation:isRunning() then
        return
    end
    
    self._popOutAnimation:play {onComplete = 
        function()
            self:setVisible(false)
            self:dispatchEvent(M.EVENT_MESSAGE_HIDE)
        end
    }
end

--------------------------------------------------------------------------------
-- テキストをスプールします.
--------------------------------------------------------------------------------
function M:spool()
    self:spoolingEnabled(true)
    return self._textLabel:spool()
end

--------------------------------------------------------------------------------
-- 次のページを表示します.
--------------------------------------------------------------------------------
function M:nextPage()
    return self._textLabel:nextPage()
end

--------------------------------------------------------------------------------
-- 次のページが存在するか返します.
--------------------------------------------------------------------------------
function M:more()
    return self._textLabel:more()
end

--------------------------------------------------------------------------------
-- メッセージの表示処理中かどうか返します.
--------------------------------------------------------------------------------
function M:isBusy()
    return self._textLabel:isBusy()
end

--------------------------------------------------------------------------------
-- テキストを設定します.
--------------------------------------------------------------------------------
function M:setText(text)
    self._text = text
    self._textLabel:setText(text)
end

--------------------------------------------------------------------------------
-- テキストを返します.
--------------------------------------------------------------------------------
function M:getText()
    return self._text
end

--------------------------------------------------------------------------------
-- 通常時のテキストの色を設定します.
--------------------------------------------------------------------------------
function M:setTextColor(r, g, b, a)
    self:setStyle(M.STATE_NORMAL, "textColor", {r, g, b, a})
end

--------------------------------------------------------------------------------
-- テキストサイズを設定します.
--------------------------------------------------------------------------------
function M:setTextSize(points)
    self:setStyle(M.STATE_NORMAL, "textSize", points)
end

--------------------------------------------------------------------------------
-- メッセージボックスを表示した時のイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnMessageShow(func)
    self:setEventListener(M.EVENT_MESSAGE_SHOW, func)
end

--------------------------------------------------------------------------------
-- メッセージボックスを非表示にした時のイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnMessageHide(func)
    self:setEventListener(M.EVENT_MESSAGE_HIDE, func)
end

--------------------------------------------------------------------------------
-- メッセージが終わった時のイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnMessageEnd(func)
    self:setEventListener(M.EVENT_MESSAGE_END, func)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- 画面をタッチした時の処理を行います.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self:isBusy() then
        self._textLabel:stop()
        self._textLabel:revealAll()
    elseif self:more() then
        self:nextPage()
        if self._spoolingEnabled then
            self:spool()
        end
    else
        self:enterMessageEnd()
    end
end

--------------------------------------------------------------------------------
-- メッセージが終了した場合に呼ばれます.
--------------------------------------------------------------------------------
function M:enterMessageEnd()
    self:dispatchEvent(M.EVENT_MESSAGE_END)

    if self._messageHideEnabled then
        self:hide()
    end
end

return M