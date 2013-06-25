-- import
flower = require "flower"
tiled = require "tiled"
widget = require "widget"
themes = require "themes"
Resources = flower.Resources

-- Resources setting
Resources.addResourceDirectory("assets")

-- debug
--[[
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 1, 1, 1, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_LAYOUT, 1, 0, 0, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_BASELINES, 1, 1, 0, 0, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75 )
]]

-- Screen setting
local screenWidth = MOAIEnvironment.horizontalResolution or 320
local screenHeight = MOAIEnvironment.verticalResolution or 480
local screenDpi = MOAIEnvironment.screenDpi or 90
local viewScale = math.max(screenWidth, screenHeight) > 1024 and 2 or 1

-- MOAISim settings
MOAISim.setHistogramEnabled(true) -- debug
MOAISim.setStep(1 / 60)
MOAISim.clearLoopFlags()
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_ALLOW_BOOST)
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_LONG_DELAY)
MOAISim.setBoostThreshold(0)

-- open window
flower.openWindow("Flower extensions", screenWidth, screenHeight, viewScale)

-- open scene
flower.openScene("main_scene")

local timer = MOAITimer.new()
timer:setMode(MOAITimer.LOOP)
timer:setSpan(5)
timer:setListener(MOAITimer.EVENT_TIMER_LOOP,
    function()
        local fps = MOAISim.getPerformance()
        print("FPS:", fps)
        print("Draw:", MOAIRenderMgr.getPerformanceDrawCount())
    end)
timer:start()
