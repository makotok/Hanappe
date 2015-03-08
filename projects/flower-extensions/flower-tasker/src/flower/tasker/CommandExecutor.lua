----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Event = require "flower.Event"
local EventDispatcher = require "flower.EventDispatcher"
local PropertyUtils = require "flower.PropertyUtils"

-- class
local CommandExecutor = class(EventDispatcher)

---
-- TODO:LDoc
function CommandExecutor:init()
    CommandExecutor.__super.init(self)
end

---
-- TODO:LDoc
function CommandExecutor.getInstance()
    if not CommandExecutor.INSTANCE then
        CommandExecutor.INSTANCE = CommandExecutor()
    end
    return CommandExecutor.INSTANCE
end

---
-- TODO:LDoc
function CommandExecutor:execute(commands, context)
    if commands == nil or #commands == 0 then
        return context.status
    end

    for i, command in ipairs(commands) do
        context.currentCommand = command
        local status = command:execute(context)
        if status > 0 then
            return status
        end
    end
    return context.status
end

return CommandExecutor