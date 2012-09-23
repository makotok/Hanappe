--------------------------------------------------------------------------------
-- ラジオボタンウィジットクラスです.<br>
-- @class table
-- @name RadioButton
--------------------------------------------------------------------------------
local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Event = require("hp/event/Event")
local Button = require("hp/widget/Button")
local Widget = require("hp/widget/Widget")

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
function M:setRadioButtonGroup(radioButtonGroup)
    if self._radioButtonGroup == radioButtonGroup then
        return
    end

    if self._radioButtonGroup then
        self._radioButtonGroup:removeChild(self)
    end
    
    self._radioButtonGroup = radioButtonGroup
    
    if self._radioButtonGroup then
        self._radioButtonGroup:addChild(self)
    end
end

----------------------------------------------------------------
-- ラジオボタンのグループを返します.
----------------------------------------------------------------
function M:getRadioButtonGroup()
    return self._radioButtonGroup
end

return M