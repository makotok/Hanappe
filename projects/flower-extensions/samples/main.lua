-- import
flower = require "flower"
tiled  = require "flower_tiled"
gui    = require "flower_gui"

-- Resource Setting
flower.Resources.addResourceDirectory("assets")

-- open window
flower.openWindow("Flower extensions", 320, 480)

-- open scene
flower.openScene("main_scene")