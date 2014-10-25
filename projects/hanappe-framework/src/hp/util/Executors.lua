--------------------------------------------------------------------------------
-- This is a utility class to execute.
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Run the specified function looping 
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLoop(func, ...)
    local thread = MOAICoroutine.new()
    local args = {...}
    thread:run(
        function()
            while true do
                if func(unpack(args)) then
                    break
                end
                coroutine.yield()
            end
        end
    )
end

--------------------------------------------------------------------------------
-- Run the specified function delay. <br>
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLater(func, ...)
    M.callLaterFrame(0, func, ...)
end

--------------------------------------------------------------------------------
-- Run the specified function delay. <br>
-- @param frame Delay frame count.
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLaterFrame(frame, func, ...)
    local thread = MOAICoroutine.new()
    local args = {...}
    local count = 0
    thread:run(
        function()
            while count < frame do
                count = count + 1
                coroutine.yield()
            end
            func(unpack(args))
        end
    )
end

--------------------------------------------------------------------------------
-- Run the specified function delay. <br>
-- @param time Delay seconds.
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLaterTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setSpan(time)
    timer:setListener(MOAITimer.EVENT_STOP, function() func(unpack(args)) end)
    timer:start()
end

return M