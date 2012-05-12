--------------------------------------------------------------------------------
-- ウィジットオブジェクトのファクトリークラスです.<br>
-- 各クラスをimportすると名前衝突する場合があるので、こちらを使用することもできます.
-- @class table
-- @name WidgetFactory
--------------------------------------------------------------------------------
local M = {}

local View
local Button
local RadioButton
local Joystick
local CheckBox
local ListView
local TextView

function M.createView(...)
    View = View or require("hp/widget/View")
    return View:new(...)
end

function M.createButton(...)
    Button = Button or require("hp/widget/Button")
    return Button:new(...)
end

function M.createRadioButton(...)
    RadioButton = RadioButton or require("hp/widget/RadioButton")
    return RadioButton:new(...)
end

function M.createJoystick(...)
    Joystick = Joystick or require("hp/widget/Joystick")
    return Joystick:new(...)
end


return M