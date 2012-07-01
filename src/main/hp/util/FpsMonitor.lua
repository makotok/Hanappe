--------------------------------------------------------------------------------
-- FPSを観測する為のクラスです.
--
-- @class table
-- @name FpsMonitor
--------------------------------------------------------------------------------

local class = require("hp/lang/class")
local Logger = require("hp/util/Logger")

local M = class()

---------------------------------------
--- コンストラクタです
---------------------------------------
function M:init(sec, onFPS)
    self._sec = sec
    self._onFPS = onFPS
    self._running = false
    
    self.timer = MOAITimer.new()
    self.timer:setMode(MOAITimer.LOOP)
    self.timer:setSpan(self._sec)
    self.timer:setListener(MOAITimer.EVENT_TIMER_LOOP, function() self:onTimer() end)

end

function M:onTimer()
    Logger.debug("FpsMonitor:onTimer", "FPS:" .. MOAISim.getPerformance())
    if self._onFPS then
        self._onFPS()
    end
end

function M:play()
    self.timer:start()
    return self
end

function M:stop()
    self.timer:stop()
end

return M