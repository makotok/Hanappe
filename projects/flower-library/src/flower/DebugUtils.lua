----------------------------------------------------------------------------------------------------
-- It is a debug utility class.
----------------------------------------------------------------------------------------------------

-- import
local Logger = require "flower.Logger"

-- class
local DebugUtils = {}

function DebugUtils.showDebugLines()
    MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 1, 1, 1, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_LAYOUT, 1, 0, 0, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_BASELINES, 1, 1, 0, 0, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75 )    
end

function DebugUtils.startPerformanceLog(span)
    span = span or 5
    local timer = MOAITimer.new()
    timer:setMode(MOAITimer.LOOP)
    timer:setSpan(span)
    timer:setListener(MOAITimer.EVENT_TIMER_LOOP,
        function()
            Logger.debug("-------------------------------------------")
            Logger.debug("FPS", MOAISim.getPerformance())
            Logger.debug("Draw:", MOAIRenderMgr.getPerformanceDrawCount())
        end)
    timer:start()
end

return DebugUtils