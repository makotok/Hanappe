-- import
config = require "config"
flower = require "flower"
tiled = require "tiled"
widget = require "widget"
themes = require "themes"
audio = require "audio"
spine = require "spine"

-- audio initialize
audio.init()

-- open window
flower.openWindow()

-- open scene
flower.openScene("main_scene")
