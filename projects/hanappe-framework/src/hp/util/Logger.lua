--------------------------------------------------------------------------------
-- This class is for log output.
--------------------------------------------------------------------------------

local M = {}

-- Constraints
M.LEVEL_NONE = 0
M.LEVEL_INFO = 1
M.LEVEL_WARN = 2
M.LEVEL_ERROR = 3
M.LEVEL_DEBUG = 4

--------------------------------------------------------------------------------
-- A table to select whether to output the log.
--------------------------------------------------------------------------------
M.selector = {}
M.selector[M.LEVEL_INFO] = true
M.selector[M.LEVEL_WARN] = true
M.selector[M.LEVEL_ERROR] = true
M.selector[M.LEVEL_DEBUG] = true

--------------------------------------------------------------------------------
-- This is the log target.
-- Is the target output to the console.
--------------------------------------------------------------------------------
M.CONSOLE_TARGET = function(...)
   print(...)
end

--------------------------------------------------------------------------------
-- This is the log target.
--------------------------------------------------------------------------------
M.logTarget = M.CONSOLE_TARGET

--------------------------------------------------------------------------------
-- The normal log output.
--------------------------------------------------------------------------------
function M.info(...)
    if M.selector[M.LEVEL_INFO] then
        M.logTarget("[info]", ...)
    end
end

--------------------------------------------------------------------------------
-- The warning log output.
--------------------------------------------------------------------------------
function M.warn(...)
    if M.selector[M.LEVEL_WARN] then
        M.logTarget("[warn]", ...)
    end
end

--------------------------------------------------------------------------------
-- The error log output.
--------------------------------------------------------------------------------
function M.error(...)
    if M.selector[M.LEVEL_ERROR] then
        M.logTarget("[error]", ...)
    end
end

--------------------------------------------------------------------------------
-- The debug log output.
--------------------------------------------------------------------------------
function M.debug(...)
    if M.selector[M.LEVEL_DEBUG] then
        M.logTarget("[debug]", ...)
    end
end

return M