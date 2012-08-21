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

-- core
M.Application    = require("hp/core/Application")

-- display
M.Layer          = require("hp/display/Layer")
M.Sprite         = require("hp/display/Sprite")
M.SpriteSheet    = require("hp/display/SpriteSheet")
M.MapSprite      = require("hp/display/MapSprite")
M.Graphics       = require("hp/display/Graphics")
M.Group          = require("hp/display/Group")
M.TextLabel      = require("hp/display/TextLabel")
M.NinePatch      = require("hp/display/NinePatch")
M.Mesh           = require("hp/display/Mesh")
M.Animation      = require("hp/display/Animation")
M.Particles      = require("hp/display/Particles")

-- manager
M.SceneManager   = require("hp/manager/SceneManager")
M.InputManager   = require("hp/manager/InputManager")
M.TextureManager = require("hp/manager/TextureManager")
M.FontManager    = require("hp/manager/FontManager")
M.WidgetManager  = require("hp/manager/WidgetManager")
M.ShaderManager  = require("hp/manager/ShaderManager")
M.SoundManager   = require("hp/manager/SoundManager")

-- tmx
M.TMXLayer       = require("hp/tmx/TMXLayer")
M.TMXMap         = require("hp/tmx/TMXMap")
M.TMXMapLoader   = require("hp/tmx/TMXMapLoader")
M.TMXMapView     = require("hp/tmx/TMXMapView")
M.TMXObject      = require("hp/tmx/TMXObject")
M.TMXObjectGroup = require("hp/tmx/TMXObjectGroup")
M.TMXTileset     = require("hp/tmx/TMXTileset")

-- widget
M.View           = require("hp/widget/View")
M.ScrollView     = require("hp/widget/ScrollView")
M.Widget         = require("hp/widget/Widget")
M.Button         = require("hp/widget/Button")
M.RadioButton    = require("hp/widget/RadioButton")
M.RadioGroup     = require("hp/widget/RadioGroup")
M.Panel          = require("hp/widget/Panel")
M.MessageBox     = require("hp/widget/MessageBox")
M.Joystick       = require("hp/widget/Joystick")

-- physics
M.PhysicsWorld   = require("hp/physics/PhysicsWorld")
M.PhysicsBody    = require("hp/physics/PhysicsBody")
M.PhysicsFixture = require("hp/physics/PhysicsFixture")

-- rpg
M.RPGMapView     = require("hp/rpg/RPGMapView")
M.RPGSprite      = require("hp/rpg/RPGSprite")

--------------------------------------------------------------------------------
-- Import the class.
--------------------------------------------------------------------------------
function M.import(dest)
    for k, v in pairs(M) do
        if type(v) == "table" then
            dest[k] = v
        end
    end
    return dest
end

return M