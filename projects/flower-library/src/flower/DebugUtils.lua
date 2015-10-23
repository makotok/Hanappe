----------------------------------------------------------------------------------------------------
-- It is a debug utility class.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local Logger = require "flower.Logger"

-- class
local DebugUtils = {}

---
-- Shows debug lines of the MOAIProps.
function DebugUtils.showDebugLines()
    MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX, 1, 1, 1, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_LAYOUT, 1, 0, 0, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_BASELINES, 1, 1, 0, 0, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.TEXT_BOX_GLYPHS, 1, 0, 0, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_MODEL_BOUNDS, 2, 1, 1, 1 )
    MOAIDebugLines.setStyle ( MOAIDebugLines.PROP_WORLD_BOUNDS, 2, 0.75, 0.75, 0.75 )    
end

---
-- Shows the performance log.
-- @param span Span of timer.
function DebugUtils.startPerformanceLog(span)
    span = span or 5
    local timer = MOAITimer.new()
    timer:setMode(MOAITimer.LOOP)
    timer:setSpan(span)
    timer:setListener(MOAITimer.EVENT_TIMER_LOOP,
        function()
            Logger.debug("FPS", MOAISim.getPerformance())
            Logger.debug("Draw:", MOAIRenderMgr.getPerformanceDrawCount())
        end)
    timer:start()
end

return DebugUtils