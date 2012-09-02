-- requires
local config    = require("config")
local classes   = require("hp/classes")

-- Classes global import.
classes.import(_G)

-- Application start.
Application:start(config)

-- If you are using the SceneManager.
SceneManager:openScene("game/splash_scene", {animation = "fade"})
