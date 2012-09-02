--------------------------------------------------------------------------------
-- This module defines a class external publication. <br>
-- Class is not defined in this module is basically an internal class. <br>
-- <br>
--
-- Do not use this module, is okay to require individually. <br>
-- You can select the class you want to use. <br>
-- @auther Makoto
-- @class table
-- @name Managers
--------------------------------------------------------------------------------

local M = {}

M.SceneManager    = require "hp/manager/SceneManager"
M.InputManager    = require "hp/manager/InputManager"
M.ResourceManager = require "hp/manager/ResourceManager"
M.TextureManager  = require "hp/manager/TextureManager"
M.FontManager     = require "hp/manager/FontManager"
M.ShaderManager   = require "hp/manager/ShaderManager"
M.SoundManager    = require "hp/manager/SoundManager"

return M
