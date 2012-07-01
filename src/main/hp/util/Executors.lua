--------------------------------------------------------------------------------
-- This is a utility class to do a comparison of the object.<br>
-- @class table
-- @name Executors
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- 指定した関数を遅延実行します.<br>
-- @param func 対象の関数.
-- @param ... 関数に渡す引数.
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