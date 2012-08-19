local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Event = require("hp/event/Event")
local Button = require("hp/widget/Button")
local Widget = require("hp/widget/Widget")

----------------------------------------------------------------
-- ラジオボタンウィジットクラスです.<br>
-- @class table
-- @name RadioButton
----------------------------------------------------------------
local super = Button
local M = class(super)

----------------------------------------------------------------
-- インスタンスを生成して返します.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    self.textLabel:setLeft(self.background:getRight())
    self:setToggle(true)
    
    self:addEventListener(Event.BUTTON_DOWN, self.onRadioButtonDown, self)
end

----------------------------------------------------------------
-- テーマ名を返します.
----------------------------------------------------------------
function M:getThemeName()
    return "RadioButton"
end

--------------------------------------------------------------------------------
-- ボタンの押下後のイベントハンドラです.
--------------------------------------------------------------------------------
function M:onTouchDown(e)
    if not self:isEnabled() then
        return
    end
    
    if self:hitTestScreen(e.x, e.y) then
        self.buttonTouching = true
        self:setButtonDownState()
    end
end

--------------------------------------------------------------------------------
-- ボタンの押下後のイベントハンドラです.
--------------------------------------------------------------------------------
function M:onRadioButtonDown(e)
    if self:getRadioGroup() then
        self:getRadioGroup():setSelectedItem(self)
    end
end

----------------------------------------------------------------
-- ラジオボタンが選択済かどうか返します.
----------------------------------------------------------------
function M:isSelected()
    return self.buttonDownFlag
end

----------------------------------------------------------------
-- ラジオボタンが選択済かどうか設定します.
----------------------------------------------------------------
function M:setSelected(value)
    if value then
        self:setButtonDownState()
    else
        self:setButtonUpState()
    end
end

----------------------------------------------------------------
-- ラジオボタンのグループを設定します.
----------------------------------------------------------------
function M:setRadioGroup(radioGroup)
    if self:getRadioGroup() == radioGroup then
        return
    end

    if self:getRadioGroup() then
        local group = self:getRadioGroup()
        group:removeChild(self)
    end
    self:setPrivate("radioGroup", radioGroup)
    if self:getRadioGroup() then
        local group = self:getRadioGroup()
        group:addChild(self)
    end
end

----------------------------------------------------------------
-- ラジオボタンのグループを返します.
----------------------------------------------------------------
function M:getRadioGroup()
    return self:getPrivate("radioGroup")
end

return M