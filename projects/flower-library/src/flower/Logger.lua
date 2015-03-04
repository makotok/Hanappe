----------------------------------------------------------------------------------------------------
-- TODO:Ldoc
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------
local Logger = {}

Logger.LOG_LEVELS = {
    INFO = true,
    WARN = true,
    ERROR = true,
    DEBUG = true,
    TRACE = true,
}

Logger.TRACE_LEVELS = {
    INFO = false,
    WARN = false,
    ERROR = true,
    DEBUG = false,
    TRACE = true,
}

function Logger.info(...)
    Logger.log("INFO", ...)
end

function Logger.warn(...)
    Logger.log("WARN", ...)
end

function Logger.error(...)
    Logger.log("ERROR", ...)
end

function Logger.debug(...)
    Logger.log("DEBUG", ...)
end

function Logger.trace(...)
    Logger.log("TRACE", ...)
end

function Logger.log(logType, ...)
    if Logger.LOG_LEVELS[logType] then
        Logger.outputLog(Logger.format(logType, ...))
        
        if Logger.TRACE_LEVELS[logType] then
            Logger.outputTrace()
        end
    end
end

function Logger.format(logType, ...)
    return "[" .. logType .. "]", ...
end

function Logger.outputLog(...)
    print(...)
end

function Logger.outputTrace()
    print(debug.traceback())
end

return Logger