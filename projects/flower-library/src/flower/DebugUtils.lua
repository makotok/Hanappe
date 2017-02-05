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
-- Shows the MOAIEnvironment properties.
function DebugUtils.showMOAIEnvInfos()
    local moaiEnvInfos = {}
    for k, v in pairs(MOAIEnvironment) do
        if type(v) ~= "function" and type(v) ~= "table" then
            local envInfo = k .. " : " .. tostring(v)
            table.insert(moaiEnvInfos, envInfo)
        end
    end

    table.sort(moaiEnvInfos)
    Logger.debug("----- MOAIEnvironment Properties -----\n" .. table.concat(moaiEnvInfos, "\n"))
    return moaiEnvInfos
end

---
-- Shows the flower properties.
function DebugUtils.showFlowerInfos()
    local infos = {}
    local localFlower = flower or require "flower"
    for k, v in pairs(localFlower) do
        if type(v) ~= "function" and type(v) ~= "table" then
            local envInfo = k .. " : " .. tostring(v)
            table.insert(infos, envInfo)
        end
    end

    table.sort(infos)
    Logger.debug("----- Flower Properties -----\n" .. table.concat(infos, "\n"))
    return infos
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