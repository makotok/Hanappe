----------------------------------------------------------------------------------------------------
-- @type BaseCommand
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Event = require "flower.core.Event"
local EventDispatcher = require "flower.core.EventDispatcher"
local CommandEvent = require "flower.tasker.CommandEvent"
local PropertyUtils = require "flower.util.PropertyUtils"

-- class
local BaseCommand = class(EventDispatcher)

---
-- TODO:LDoc
function BaseCommand:init(properties)
    BaseCommand.__super.init(self)
    self:initInternal(properties)
    self:setProperties(properties)
end

---
-- TODO:LDoc
function BaseCommand:initInternal(properties)
    -- Nop
end

---
-- TODO:LDoc
function BaseCommand:execute(context)
    if not self:isExecutable(context) then
        return 0
    end

    local status = self:executeInternal(context)
    if status == 0 then
        self:dispatchEvent(CommandEvent.COMMAND_COMPLETE, context)
    else
        self:dispatchEvent(CommandEvent.COMMAND_ABORT, context)
    end

    return status or 0
end

function BaseCommand:isExecutable(context)
    if self.executeWhen ~= nil then
        local t = type(self.executeWhen)
        if t == "boolean" then
            return self.executeWhen
        elseif t == "function" then
            return self.executeWhen(context)
        else
            return self.executeWhen ~= nil
        end
    end
    return true
end

---
-- TODO:LDoc
function BaseCommand:executeInternal(context)
    -- Nop
end

---
-- Sets the properties
-- @param properties properties
function BaseCommand:setProperties(properties)
    if properties then
        PropertyUtils.setProperties(self, properties, true)
    end
end

---
-- TODO:LDoc
function BaseCommand:setExecuteWhen(value)
    self.executeWhen = value
end

return BaseCommand