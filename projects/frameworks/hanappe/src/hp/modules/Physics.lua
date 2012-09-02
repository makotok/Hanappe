--------------------------------------------------------------------------------
-- This module defines a class external publication. <br>
-- Class is not defined in this module is basically an internal class. <br>
-- <br>
--
-- Do not use this module, is okay to require individually. <br>
-- You can select the class you want to use. <br>
-- @auther Makoto
-- @class table
-- @name Physics
--------------------------------------------------------------------------------

local M = {}

M.PhysicsWorld      = require "hp/physics/PhysicsWorld"
M.PhysicsBody       = require "hp/physics/PhysicsBody"
M.PhysicsFixture    = require "hp/physics/PhysicsFixture"

return M