-- requires
local config    = require("config")
local classes   = require("hp/classes")

-- Classes import.
-- If you hate to be imported into the global,
-- Please to require the necessary classes.
classes.import(_G)

-- Application start.
Application:start(config)

-- If you are using the SceneManager.
SceneManager:openScene("samples/sample_main", {animation = "fade"})

-- If you do not want to use the SceneManager.
--[[
local layer = Layer()
local sprite1 = Sprite {texture = "samples/assets/cathead.png", layer = layer, left = 0, top = 0}
--]]
