-- import
config = require "config"
flower = require "flower"
tiled = require "flower.tiled"
widget = require "flower.widget"
audio = require "flower.audio"
spine = require "flower.spine"
dungeon = require "flower.dungeon"
fsm = require "flower.fsm"
tasker = require "flower.tasker"

-- audio initialize
audio.init()

-- open window
flower.openWindow()

-- open scene
flower.openScene("main_scene")

-- show infos
flower.DebugUtils.showMOAIEnvInfos()
flower.DebugUtils.showFlowerInfos()