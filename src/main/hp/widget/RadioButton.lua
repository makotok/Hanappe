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
    self.toggle = true
    
    self:addEventListener(Event.BUTTON_DOWN, self.onRadioButtonDown, self, Event.PRIORITY_DEFAULT - 10)
end

----------------------------------------------------------------
-- 使用するべきでない関数を除外します.
----------------------------------------------------------------
function M:excludeFunctions()
    super.excludeFunctions(self)
end

--------------------------------------------------------------------------------
-- ボタンの押下後のイベントハンドラです.
--------------------------------------------------------------------------------
function M:onRadioButtonDown()
    if self.radioGroup then
        self.radioGroup:setSelectedButton(self)
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
    self.radioGroup = radioGroup
end

return M