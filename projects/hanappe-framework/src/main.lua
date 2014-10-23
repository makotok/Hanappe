-- import
local modules = require "modules"
local config = require "config"

-- start and open
Application:start(config)
SceneManager:openScene(config.mainScene)
