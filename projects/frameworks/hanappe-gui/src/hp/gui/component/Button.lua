----------------------------------------------------------------
-- ボタンウィジットクラスです.<br>
-- @class table
-- @name Button
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/component/Component"

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
M.EVENT_UP              = "up"
M.EVENT_DOWN            = "down"

--------------------------------------------------------------------------------
-- 内部変数の初期化処理を行います.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self.__internal.selected = false
    self.__internal.touching = false
    self.__internal.touchIndex = nil
    self.__internal.toggle = false
    self.__internal.themeName = "Button"
end

--------------------------------------------------------------------------------
-- 子オブジェクトの生成処理を行います.
--------------------------------------------------------------------------------
function M:createChildren()
    local skinClass = self:getStyle("skinClass")
    self.__internal.skinClass = skinClass
    self.__internal.background = skinClass(self:getStyle("skin"))
    
    self.__internal.label = TextLabel()
    self.__internal.label:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
    self.__internal.label:setSize(self.__internal.background:getSize())

    self:addChild(self.__internal.background)
    self:addChild(self.__internal.label)

    self:setSize(self.__internal.background:getSize())
end

--------------------------------------------------------------------------------
-- スタイルの更新を行います.
--------------------------------------------------------------------------------
function M:updateStyles()
    local skinClass = self:getStyle("skinClass")
    if self.__internal.skinClass ~= skinClass then
        self.__internal.skinClass = skinClass
        self.__internal.background = skinClass()
        self.__internal.background:setSize(self:getWidth(), self:getHeight())
    end

    local background = self.__internal.background
    background:setColor(unpack(self:getStyle("color")))
    background:setTexture(self:getStyle("skin"))

    local label = self.__internal.label
    label:setColor(unpack(self:getStyle("textColor")))
    label:setTextSize(self:getStyle("textSize"))
    label:setFont(self:getStyle("font"))
end

--------------------------------------------------------------------------------
-- ボタンの押下前の状態を設定します.
--------------------------------------------------------------------------------
function M:doUpButton()
    if not self:isSelected() then
        return
    end
    self.__internal.selected = false
    
    self:setCurrentState(M.STATE_NORMAL)
    self:dispatchEvent(M.EVENT_UP)
end

--------------------------------------------------------------------------------
-- ボタンの押下後の状態を設定します.
--------------------------------------------------------------------------------
function M:doDownButton()
    if self:isSelected() then
        return
    end
    self.__internal.selected = true
    
    self:setCurrentState(M.STATE_SELECTED)
    self:dispatchEvent(M.EVENT_DOWN)
end

--------------------------------------------------------------------------------
-- テキストを設定します.
--------------------------------------------------------------------------------
function M:setText(text)
    self.__internal.text = text
    self.__internal.label:setText(text)
end

--------------------------------------------------------------------------------
-- テキストを返します.
--------------------------------------------------------------------------------
function M:getText()
    return self.__internal.text
end

--------------------------------------------------------------------------------
-- トグルボタンかどうか設定します.
--------------------------------------------------------------------------------
function M:setToggle(value)
    self.__internal.toggle = value
end

--------------------------------------------------------------------------------
-- トグルボタンかどうか返します.
--------------------------------------------------------------------------------
function M:isToggle()
    return self.__internal.toggle
end

--------------------------------------------------------------------------------
-- ボタンを押下しているか返します.
--------------------------------------------------------------------------------
function M:isSelected()
    return self.__internal.selected
end

--------------------------------------------------------------------------------
-- ボタンを押下したときのイベントリスナを設定します.
--------------------------------------------------------------------------------
function M:setOnClick(value)
    if self.__internal.onClick == value then
        return
    end
    if self.__internal.onClick then
        self:removeEventListener(M.EVENT_CLICK, self.__internal.onClick)
    end

    self.__internal.onClick = value
    
    if self.__internal.onClick then
        self:addEventListener(M.EVENT_CLICK, self.__internal.onClick)
    end
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    print("touch!")
    if self.__internal.touching then
        return
    end
    
    if self:hitTestScreen(e.x, e.y) then
        self.__internal.touchIndex = e.idx
        self.__internal.touching = true
        
        if self:isToggle() and self:isButtonDown() then
            self:doUpButton()
        else
            self:doDownButton()
        end
    end
    
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if e.idx ~= self.__internal.touchIndex then
        return
    end
    
    if self.__internal.touching and not self:isToggle() then
        self.__internal.touching = false
        self.__internal.touchIndex = nil
        
        self:doUpButton()
        self:dispatchEvent(M.EVENT_CLICK)
    end
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if e.idx ~= self.__internal.touchIndex then
        return
    end

    if self.__internal.touching and not self:hitTestScreen(e.x, e.y) then
        self.__internal.touching = false
        self.__internal.touchIndex = nil
        
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
        self.__internal.touching = false
        self.__internal.touchIndex = nil
        
        self:doUpButton()
        self:dispatchEvent("cancel")
    end
end

--------------------------------------------------------------------------------
-- リサイズ時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    local background = self.__internal.background
    background:setSize(self:getWidth(), self:getHeight())

    local label = self.__internal.label
    label:setSize(self:getWidth(), self:getHeight())
end

--------------------------------------------------------------------------------
-- ステート変更時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:stateChangedHandler(e)
    -- self:updaateStyles()
end

--------------------------------------------------------------------------------
-- 有効変更時のイベントハンドラです.
--------------------------------------------------------------------------------
function M:enabledChangedHandler(e)
    if not self:isEnabled() then
        self.__internal.touching = false
        self.__internal.touchIndex = 0
    end
end

return M