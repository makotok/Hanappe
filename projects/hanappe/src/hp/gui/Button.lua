----------------------------------------------------------------
-- ボタンウィジットクラスです.<br>
-- @class table
-- @name Button
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"

-- class define
local M                 = class(Component)
local super             = Component

-- States
M.STATE_NORMAL          = "normal"
M.STATE_SELECTED        = "selected"
M.STATE_OVER            = "over"
M.STATE_DISABLED        = "disabled"

-- Events
M.EVENT_CLICK           = "click"
M.EVENT_CANCEL          = "cancel"
M.EVENT_BUTTON_UP       = "buttonUp"
M.EVENT_BUTTON_DOWN     = "buttonDown"

--------------------------------------------------------------------------------
-- 内部変数の初期化処理を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._selected = false
    self._touching = false
    self._touchIndex = nil
    self._toggle = false
    self._themeName = "Button"
    self._skinResizable = true
    self._firstUpdated = false
end

--------------------------------------------------------------------------------
-- 子オブジェクトの生成処理を行います.
--------------------------------------------------------------------------------
function M:createChildren()
    local skinClass = self:getStyle("skinClass")
    self._skinClass = skinClass
    self._background = skinClass(self:getStyle("skin"))
    
    self._label = TextLabel()
    self._label:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
    self._label:setSize(self._background:getSize())

    self:addChild(self._background)
    self:addChild(self._label)

    self:setSize(self._background:getSize())
end

--------------------------------------------------------------------------------
-- 表示の更新を行います.
--------------------------------------------------------------------------------
function M:updateDisplay()
    local background = self._background
    background:setColor(unpack(self:getStyle("skinColor")))
    background:setTexture(self:getStyle("skin"))

    local label = self._label
    label:setColor(unpack(self:getStyle("textColor")))
    label:setTextSize(self:getStyle("textSize"))
    label:setFont(self:getStyle("font"))
    
    if not self._skinResizable then
        local tw, th = background.texture:getSize()
        self:setSize(tw, th)
    end
end

--------------------------------------------------------------------------------
-- ボタンの押下前の状態を設定します.
--------------------------------------------------------------------------------
function M:doUpButton()
    if not self:isSelected() then
        return
    end
    self._selected = false

    self:setCurrentState(M.STATE_NORMAL)
    self:dispatchEvent(M.EVENT_BUTTON_UP)
end

--------------------------------------------------------------------------------
-- ボタンの押下後の状態を設定します.
--------------------------------------------------------------------------------
function M:doDownButton()
    if self:isSelected() then
        return
    end
    self._selected = true
    
    self:setCurrentState(M.STATE_SELECTED)
    self:dispatchEvent(M.EVENT_BUTTON_DOWN)
end

--------------------------------------------------------------------------------
-- テキストを設定します.
--------------------------------------------------------------------------------
function M:setText(text)
    self._text = text
    self._label:setText(text)
end

--------------------------------------------------------------------------------
-- テキストを返します.
--------------------------------------------------------------------------------
function M:getText()
    return self._text
end

--------------------------------------------------------------------------------
-- トグルボタンかどうか設定します.
--------------------------------------------------------------------------------
function M:setToggle(value)
    self._toggle = value
end

--------------------------------------------------------------------------------
-- トグルボタンかどうか返します.
--------------------------------------------------------------------------------
function M:isToggle()
    return self._toggle
end

--------------------------------------------------------------------------------
-- ボタンを押下しているか返します.
--------------------------------------------------------------------------------
function M:isSelected()
    return self._selected
end

--------------------------------------------------------------------------------
-- スキンがリサイズ可能かどうか設定します.
-- falseに設定した場合、スキンテクスチャのサイズがそのままボタンのサイズに設定されます.
--------------------------------------------------------------------------------
function M:setSkinResizable(value)
    self._skinResizable = value
    if not self._skinResizable then
        self:invalidateDisplay()
    end
end

--------------------------------------------------------------------------------
-- ボタンを押下したときのイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnClick(func)
    self:setEventListener(M.EVENT_CLICK, func)
end

--------------------------------------------------------------------------------
-- ボタンを押下した直後のイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnButtonDown(func)
    self:setEventListener(M.EVENT_BUTTON_DOWN, func)
end

--------------------------------------------------------------------------------
-- ボタンを押下した直後のイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnButtonUp(func)
    self:setEventListener(M.EVENT_BUTTON_UP, func)
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self._touching then
        return
    end
    e:stop()
    
    self._touchIndex = e.idx
    self._touching = true
    
    if self:isToggle() and self:isButtonDown() then
        self:doUpButton()
    else
        self:doDownButton()
    end
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if e.idx ~= self._touchIndex then
        return
    end
    e:stop()
    
    if self._touching and not self:isToggle() then
        self._touching = false
        self._touchIndex = nil
        
        self:doUpButton()
        self:dispatchEvent(M.EVENT_CLICK)
    end
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if e.idx ~= self._touchIndex then
        return
    end
    e:stop()
    
    if self._touching and not self:hitTestWorld(e.x, e.y) then
        self._touching = false
        self._touchIndex = nil
        
        if not self:isToggle() then
            self:doUpButton()
            self:dispatchEvent(M.EVENT_CANCEL)
        end
    end
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
    if not self:isToggle() then
        self._touching = false
        self._touchIndex = nil
        
        self:doUpButton()
        self:dispatchEvent(M.EVENT_CANCEL)
    end
end

--------------------------------------------------------------------------------
-- リサイズ時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    local background = self._background
    background:setSize(self:getWidth(), self:getHeight())

    local textPadding = self:getStyle("textPadding")
    local paddingLeft, paddingTop, paddingRight, paddingBottom = unpack(textPadding)

    local label = self._label
    label:setSize(self:getWidth() - paddingLeft - paddingRight, self:getHeight() - paddingTop - paddingBottom)
    label:setPos(paddingLeft, paddingTop)
end

--------------------------------------------------------------------------------
-- 有効変更時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:enabledChangedHandler(e)
    if not self:isEnabled() then
        self._touching = false
        self._touchIndex = 0
    end
end

return M