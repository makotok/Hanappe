--------------------------------------------------------------------------------
-- This is a utility class to execute.<br>
-- @class table
-- @name Executors
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Run the specified function delay.<br>
-- @param func Target function.
-- @param ... Argument.
--------------------------------------------------------------------------------
function M.callLater(func, ...)
    local thread = MOAICoroutine.new()
    local args = {...}
    thread:run(
        function()
            func(unpack(args))
        end
    )
end

return M