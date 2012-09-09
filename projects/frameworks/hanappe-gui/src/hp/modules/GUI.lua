--------------------------------------------------------------------------------
-- This module defines a class external publication. <br>
-- Class is not defined in this module is basically an internal class. <br>
-- <br>
--
-- Do not use this module, is okay to require individually. <br>
-- You can select the class you want to use. <br>
-- @auther Makoto
-- @class table
-- @name GUI
--------------------------------------------------------------------------------

local M = {}

M.View              = require "hp/gui/view/View"

M.Component         = require "hp/gui/component/Component"
M.Button            = require "hp/gui/component/Button"
--M.RadioButton       = require "hp/gui/component/RadioButton"
--M.RadioGroup        = require "hp/gui/component/RadioGroup"
M.Joystick          = require "hp/gui/component/Joystick"
M.Panel             = require "hp/gui/component/Panel"
--M.MessageBox        = require "hp/gui/component/MessageBox"

M.BoxLayout         = require "hp/gui/layout/BoxLayout"
M.VBoxLayout        = require "hp/gui/layout/VBoxLayout"
M.HBoxLayout        = require "hp/gui/layout/HBoxLayout"

M.Theme             = require "hp/gui/theme/Theme"

return M