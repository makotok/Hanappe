-- import
local global        = require "global"
local config        = require "config"
local custom        = require "custom"
local Application   = require "hp/core/Application"
local SceneManager  = require "hp/manager/SceneManager"

-- Application start.
Application:start(config)

-- Scene open.
SceneManager:openScene(config.mainScene)
