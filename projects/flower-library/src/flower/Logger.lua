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
-- Outputs a info log.
-- @param ... messages
function Logger.info(...)
    Logger.log("INFO", ...)
end

---
-- Outputs a warn log.
-- @param ... messages
function Logger.warn(...)
    Logger.log("WARN", ...)
end

---
-- Outputs a error log.
-- @param ... messages
function Logger.error(...)
    Logger.log("ERROR", ...)
end

---
-- Outputs a debug log.
-- @param ... messages
function Logger.debug(...)
    Logger.log("DEBUG", ...)
end

---
-- Outputs a trace log.
-- @param ... messages
function Logger.trace(...)
    Logger.log("TRACE", ...)
end

---
-- Outputs a specified log.
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
-- Formats a messages.
-- You can change the format function.
-- @param logLevel log level.
-- @param ... messages
function Logger.format(logLevel, ...)
    return "[" .. logLevel .. "]", ...
end

---
-- Outputs a log.
-- You can change the outputLog function.
-- @param ... messages
function Logger.outputLog(...)
    print(...)
end

---
-- Prints a stack trace.
function Logger.outputTrace()
    Logger.outputLog(debug.traceback())
end

return Logger