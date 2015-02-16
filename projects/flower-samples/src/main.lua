-- import
config = require "config"
flower = require "flower"
tiled = require "flower.tiled"
widget = require "flower.widget"
audio = require "flower.audio"
spine = require "flower.spine"
dungeon = require "flower.dungeon"
tasklib = require "flower.tasklib"

-- audio initialize
audio.init()

-- open window
flower.openWindow()

-- open scene
flower.openScene("main_scene")
