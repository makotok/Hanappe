-- import
local flower = require "flower"
local Resources = flower.Resources

-- module
local M = {}

--------------------------------------------------------------------------------
-- Settings
--------------------------------------------------------------------------------

-- Resources setting
Resources.addResourceDirectory("assets")

-- Screen Size.
-- Please you set free.
M.screenWidth = MOAIEnvironment.horizontalResolution or 320
M.screenHeight = MOAIEnvironment.verticalResolution or 480
M.viewScale = math.floor(math.max(math.min(M.screenWidth / 320, M.screenHeight / 480), 1))

-- MOAISim settings
MOAISim.setStep(1 / 60)
MOAISim.clearLoopFlags()
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_ALLOW_BOOST)
MOAISim.setLoopFlags(MOAISim.SIM_LOOP_LONG_DELAY)
MOAISim.setBoostThreshold(0)

--------------------------------------------------------------------------------
-- Debug code
--------------------------------------------------------------------------------

-- MOAISim settings
MOAISim.setHistogramEnabled(true) -- debug

-- Prop debug
--[[
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 1, 1, 1, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_LAYOUT, 1, 0, 0, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_BASELINES, 1, 1, 0, 0, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75 )
]]

-- Performance measurement.
local timer = MOAITimer.new()
timer:setMode(MOAITimer.LOOP)
timer:setSpan(5)
timer:setListener(MOAITimer.EVENT_TIMER_LOOP,
    function()
        print("-------------------------------------------")
        print("FPS:", MOAISim.getPerformance())
        print("Draw:", MOAIRenderMgr.getPerformanceDrawCount())
        MOAISim.forceGarbageCollection()
        MOAISim.reportHistogram()
    end)
timer:start()


return M
