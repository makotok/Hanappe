----------------------------------------------------------------------------------------------------
-- Simple logger class.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------
local Logger = {}

--- Log level.
Logger.LOG_LEVELS = {
    INFO = true,
    WARN = true,
    ERROR = true,
    DEBUG = true,
    TRACE = true,
}

--- Trace level.
Logger.TRACE_LEVELS = {
    INFO = false,
    WARN = false,
    ERROR = true,
    DEBUG = false,
    TRACE = true,
}

---
-- Output the INFO level log.
-- @param ... messages
function Logger.info(...)
    Logger.log("INFO", ...)
end

---
-- Output the WARN level log.
-- @param ... messages
function Logger.warn(...)
    Logger.log("WARN", ...)
end

---
-- Output the ERROR level log.
-- @param ... messages
function Logger.error(...)
    Logger.log("ERROR", ...)
end

---
-- Output the DEBUG level log.
-- @param ... messages
function Logger.debug(...)
    Logger.log("DEBUG", ...)
end

---
-- Output the TRACE level log.
-- @param ... messages
function Logger.trace(...)
    Logger.log("TRACE", ...)
end

---
-- Output the log.
-- @param logLevel target log level.
-- @param ... messages
function Logger.log(logLevel, ...)
    if Logger.LOG_LEVELS[logLevel] then
        Logger.outputLog(Logger.format(logLevel, ...))

        if Logger.TRACE_LEVELS[logLevel] then
            Logger.outputTrace()
        end
    end
end

---
-- This is the format function of the message.
-- You can change the format by overwriting.
-- @param logLevel log level.
-- @param ... messages
function Logger.format(logLevel, ...)
    return "[" .. logLevel .. "]", ...
end

---
-- It is actually processing to output a log.
-- It is possible to override this function, you can change the output destination.
-- @param logLevel log level.
-- @param ... messages
function Logger.outputLog(...)
    print(...)
end

---
-- print a stack trace
function Logger.outputTrace()
    Logger.outputLog(debug.traceback())
end

return Logger