-- requires
local Application = require("hp/Application")
local config = require("config")

-- application start
Application:appStart(config)

-- classes import
Application:importClasses(_G, "")

-- If you are using the SceneManager.
SceneManager:openScene("samples/sample_main", {animation = "fade"})

-- If you do not want to use the SceneManager.
--[[
local layer = Layer:new()
local sprite1 = Sprite:new({texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0})
--]]