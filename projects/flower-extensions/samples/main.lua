-- import
flower = require "flower"
tiled  = require "tiled"
gui    = require "gui"

-- setting
flower.Resources.addResourceDirectory("assets")
local screenWidth = MOAIEnvironment.horizontalResolution or 320
local screenHeight = MOAIEnvironment.verticalResolution or 480
local screenDpi = MOAIEnvironment.screenDpi or 120
local viewScale = math.floor(screenDpi / 240) + 1

-- open window
flower.openWindow("Flower extensions", screenWidth, screenHeight, viewScale)

-- open scene
flower.openScene("main_scene")