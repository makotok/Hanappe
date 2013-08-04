-- import
flower = require "flower"
tiled = require "tiled"
widget = require "widget"
themes = require "themes"
audio = require "audio"
config = require "config"

-- audio initialize
audio.init()

-- open window
flower.openWindow("Flower extensions")

-- open scene
flower.openScene("main_scene")
