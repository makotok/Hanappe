-- import
local config        = require "config"
local global        = require "global"
local Application   = require "hp/core/Application"
local SceneManager  = require "hp/manager/SceneManager"

-- Application start.
Application:start(config)

-- If you are using the SceneManager.
SceneManager:openScene(config.mainScene)
