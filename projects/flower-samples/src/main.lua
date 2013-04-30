-- import
flower = require "flower"

-- setting
local screenWidth = MOAIEnvironment.horizontalResolution or 320
local screenHeight = MOAIEnvironment.verticalResolution or 480
local screenDpi = MOAIEnvironment.screenDpi or 120
local viewScale = math.floor(screenDpi / 240) + 1

-- MOAISim settings
MOAISim.setHistogramEnabled(true) -- debug
MOAISim.setStep(1 / 60)
MOAISim.clearLoopFlags()
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_ALLOW_BOOST)
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_LONG_DELAY)
MOAISim.setBoostThreshold(0)

-- open scene
flower.openWindow("Flower samples", screenWidth, screenHeight, viewScale)
flower.openScene("main_scene")