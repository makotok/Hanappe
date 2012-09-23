--------------------------------------------------------------------------------
-- This module defines a class external publication. <br>
-- Class is not defined in this module is basically an internal class. <br>
-- <br>
--
-- Do not use this module, is okay to require individually. <br>
-- You can select the class you want to use. <br>
-- @auther Makoto
-- @class table
-- @name Flower
--------------------------------------------------------------------------------

local M = {}

M.Application           = require "hp/core/Application"

M.Layer                 = require "hp/display/Layer"
M.Sprite                = require "hp/display/Sprite"
M.SpriteSheet           = require "hp/display/SpriteSheet"
M.MapSprite             = require "hp/display/MapSprite"
M.Graphics              = require "hp/display/Graphics"
M.Group                 = require "hp/display/Group"
M.TextLabel             = require "hp/display/TextLabel"
M.NinePatch             = require "hp/display/NinePatch"
M.Mesh                  = require "hp/display/Mesh"
M.Animation             = require "hp/display/Animation"
M.Particles             = require "hp/display/Particles"

M.View                  = require "hp/gui/View"
--M.TextView              = require "hp/gui/TextView"
--M.ScrollView            = require "hp/gui/ScrollView"
--M.ListView              = require "hp/gui/ListView"
M.Component             = require "hp/gui/Component"
M.Button                = require "hp/gui/Button"
--M.RadioButton           = require "hp/gui/RadioButton"
--M.RadioGroup            = require "hp/gui/RadioGroup"
M.Joystick              = require "hp/gui/Joystick"
M.Panel                 = require "hp/gui/Panel"
M.MessageBox            = require "hp/gui/MessageBox"
M.Scroller              = require "hp/gui/Scroller"

M.BoxLayout             = require "hp/layout/BoxLayout"
M.VBoxLayout            = require "hp/layout/VBoxLayout"
M.HBoxLayout            = require "hp/layout/HBoxLayout"

M.SceneManager          = require "hp/manager/SceneManager"
M.InputManager          = require "hp/manager/InputManager"
M.ResourceManager       = require "hp/manager/ResourceManager"
M.TextureManager        = require "hp/manager/TextureManager"
M.FontManager           = require "hp/manager/FontManager"
M.ShaderManager         = require "hp/manager/ShaderManager"
M.SoundManager          = require "hp/manager/SoundManager"

M.PhysicsWorld          = require "hp/physics/PhysicsWorld"
M.PhysicsBody           = require "hp/physics/PhysicsBody"
M.PhysicsFixture        = require "hp/physics/PhysicsFixture"

M.TMXLayer              = require "hp/tmx/TMXLayer"
M.TMXMap                = require "hp/tmx/TMXMap"
M.TMXMapLoader          = require "hp/tmx/TMXMapLoader"
M.TMXMapView            = require "hp/tmx/TMXMapView"
M.TMXObject             = require "hp/tmx/TMXObject"
M.TMXObjectGroup        = require "hp/tmx/TMXObjectGroup"
M.TMXTileset            = require "hp/tmx/TMXTileset"

return M