-- requires
local config = require("config")
local Application = require("hp/Application")

-- application start
Application:appStart(config)

-- classes import
Application:importClasses(_G, "")

-- widget theme
WidgetManager:setDefaultThemes("assets/themes/basic/Themes")

-- If you are using the SceneManager.
SceneManager:openScene("samples/sample_main", {animation = "fade"})

-- If you do not want to use the SceneManager.
--[[
local layer = Layer()
local sprite1 = Sprite({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0})
--]]
