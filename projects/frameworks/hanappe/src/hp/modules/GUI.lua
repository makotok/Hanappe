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

M.View              = require "hp/gui/View"
--M.TextView          = require "hp/gui/TextView"
--M.ScrollView        = require "hp/gui/ScrollView"
--M.ListView          = require "hp/gui/ListView"

M.Component         = require "hp/gui/Component"
M.Button            = require "hp/gui/Button"
--M.RadioButton       = require "hp/gui/RadioButton"
--M.RadioGroup        = require "hp/gui/RadioGroup"
M.Joystick          = require "hp/gui/Joystick"
M.Panel             = require "hp/gui/Panel"
M.MessageBox        = require "hp/gui/MessageBox"

M.Theme             = require "hp/gui/Theme"

M.BoxLayout         = require "hp/layout/BoxLayout"
M.VBoxLayout        = require "hp/layout/VBoxLayout"
M.HBoxLayout        = require "hp/layout/HBoxLayout"

return M