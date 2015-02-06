----------------------------------------------------------------------------------------------------
-- This is a utility class for asynchronous (coroutine-style) execution.
----------------------------------------------------------------------------------------------------
local Executors = {}

---
-- Run the specified function in a loop in a coroutine, forever.
-- If there is a return value of a function of argument, the loop is terminated.
-- @param func Target function.
-- @param ... Arguments to be passed to the function.
-- @return MOAICoroutine object
function Executors.callLoop(func, ...)
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
    return thread
end

---
-- Run the specified function once, in a coroutine, immediately
-- (upon next coroutine.yield())
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAICoroutine object
function Executors.callOnce(func, ...)
    return Executors.callLaterFrame(0, func, ...)
end

---
-- Run the specified function once, in a coroutine, after a specified delay in frames.
-- @param frame Delay frame count.
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAICoroutine object
function Executors.callLaterFrame(frame, func, ...)
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
    return thread
end

---
-- Run the specified function once, in a coroutine, after a specified delay in seconds.
-- @param time Delay seconds.
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAITimer object
function Executors.callLaterTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setSpan(time)
    timer:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() func(unpack(args)) end)
    timer:start()
    return timer
end

---
-- Run the specified function in loop by a span time over and over again
-- @param time loop seconds.
-- @param func Target function.
-- @param ... Arguments.
-- @return MOAITimer object
function Executors.callLoopTime(time, func, ...)
    local args = {...}
    local timer = MOAITimer.new()
    timer:setMode(MOAITimer.LOOP)
    timer:setSpan(time) -- EVENT_TIMER_LOOP
    timer:setListener(MOAITimer.EVENT_TIMER_BEGIN_SPAN, function() func(unpack(args)) end)
    timer:start()
    return timer
end

return Executors