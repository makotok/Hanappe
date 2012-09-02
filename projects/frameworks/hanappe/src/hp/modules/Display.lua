--------------------------------------------------------------------------------
-- This module defines a class external publication. <br>
-- Class is not defined in this module is basically an internal class. <br>
-- <br>
--
-- Do not use this module, is okay to require individually. <br>
-- You can select the class you want to use. <br>
-- @auther Makoto
-- @class table
-- @name classes
--------------------------------------------------------------------------------

local M = {}

M.Application       = require "hp/core/Application"

M.Layer             = require "hp/display/Layer"
M.Sprite            = require "hp/display/Sprite"
M.SpriteSheet       = require "hp/display/SpriteSheet"
M.MapSprite         = require "hp/display/MapSprite"
M.Graphics          = require "hp/display/Graphics"
M.Group             = require "hp/display/Group"
M.TextLabel         = require "hp/display/TextLabel"
M.NinePatch         = require "hp/display/NinePatch"
M.Mesh              = require "hp/display/Mesh"
M.Animation         = require "hp/display/Animation"
M.Particles         = require "hp/display/Particles"

return M