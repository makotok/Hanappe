----------------------------------------------------------------------------------------------------
-- TODO:Ldoc
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------
local Logger = {}

Logger.infoLogEnabled = true
Logger.warnLogEnabled = true
Logger.errorLogEnabled = true
Logger.debugLogEnabled = true

function Logger.info(...)
    if Logger.infoLogEnabled then
        Logger.outputLog("INFO", ...)
    end
end

function Logger.warn(...)
    if Logger.warnLogEnabled then
        Logger.outputLog("WARN", ...)
    end
end

function Logger.error(...)
    if Logger.errorLogEnabled then
        Logger.outputLog("ERROR", ...)
    end
end

function Logger.debug(...)
    if Logger.debugLogEnabled then
        Logger.outputLog("DEBUG", ...)
    end
end

function Logger.outputLog(logType, ...)
    print("[" .. logType .. "]", ...)
end

return Logger