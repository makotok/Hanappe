----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Event = require "flower.core.Event"
local EventDispatcher = require "flower.core.EventDispatcher"
local CommandGroup = require "flower.tasklib.CommandGroup"
local TaskExecutor = require "flower.tasklib.TaskExecutor"
local TaskMonitor = require "flower.tasklib.TaskMonitor"
local PropertyUtils = require "flower.util.PropertyUtils"

-- class
local Task = class(EventDispatcher)

---
-- Constructor.
function Task:init(properties)
    Task.__super.init(self)
    self:initInternal()
    self:setProperties(properties)
end

---
-- TODO:LDoc
function Task:initInternal(properties)
    self.commandGroup = CommandGroup()
    self.monitor = TaskMonitor()
    self.executor = TaskExecutor.getInstance()
end

---
-- TODO:LDoc
function Task:execute(params)
    return self.executor:execute(self, params)
end

---
-- Set the commands
-- @param value commands
function Task:setCommands(value)
    self.commandGroup:setCommands(value)
end

---
-- Set the abortCommands
-- @param value abortCommands
function Task:setAborts(value)
    self.commandGroup:setAborts(value)
end

---
-- Set the monitor
-- @param value monitor
function Task:setMonitor(value)
    self.monitor = value
end

---
-- Set the 'taskStart' event listener.
-- @param func event listener
function Task:setOnTaskStart(func)
    self:setEventListener("taskStart", func)
end

---
-- Set the 'taskAbort' event listener.
-- @param func event listener
function Task:setOnTaskAbort(func)
    self:setEventListener("taskAbort", func)
end

---
-- Set the 'taskEnd' event listener.
-- @param func event listener
function Task:setOnTaskEnd(func)
    self:setEventListener("taskEnd", func)
end

---
-- Set the 'taskCancel' event listener.
-- @param func event listener
function Task:setOnTaskCancel(func)
    self:setEventListener("taskCancel", func)
end

---
-- Sets the properties
-- @param properties properties
function Task:setProperties(properties)
    if properties then
        PropertyUtils.setProperties(self, properties, true)
    end
end

return Task