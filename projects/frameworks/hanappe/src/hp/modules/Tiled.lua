--------------------------------------------------------------------------------
-- This module defines a class external publication. <br>
-- Class is not defined in this module is basically an internal class. <br>
-- <br>
--
-- Do not use this module, is okay to require individually. <br>
-- You can select the class you want to use. <br>
-- @auther Makoto
-- @class table
-- @name TMX
--------------------------------------------------------------------------------

local M = {}

M.TMXLayer          = require "hp/tmx/TMXLayer"
M.TMXMap            = require "hp/tmx/TMXMap"
M.TMXMapLoader      = require "hp/tmx/TMXMapLoader"
M.TMXMapView        = require "hp/tmx/TMXMapView"
M.TMXObject         = require "hp/tmx/TMXObject"
M.TMXObjectGroup    = require "hp/tmx/TMXObjectGroup"
M.TMXTileset        = require "hp/tmx/TMXTileset"

return M