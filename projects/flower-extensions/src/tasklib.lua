----------------------------------------------------------------------------------------------------
-- Task System Library.
--
-- @author Makoto
-- @release V2.1.6
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local Event = flower.Event
local EventDispatcher = flower.EventDispatcher
local ClassFactory = flower.ClassFactory
local PropertyUtils = flower.PropertyUtils

-- classes
local Task
local TaskContext
local TaskEvent
local TaskMonitor
local TaskExecutor
local BaseCommand
local CommandEvent
local CommandExecutor
local CommandGroup
local EchoCommand
local WaitCommand
local AbortCommand
local FunctionCommand
local SetContextCommand

----------------------------------------------------------------------------------------------------
-- @type Task
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
Task = class(EventDispatcher)
M.Task = Task

---
-- Constructor.
function Task:init(properties)
    Task.__super.init(self)
    self:initInternal()
    self:setProperties(properties)
end

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

----------------------------------------------------------------------------------------------------
-- @type TaskContext
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
TaskContext = class()
M.TaskContext = TaskContext

function TaskContext:init(task, params)
    self.task = assert(task)
    self.params = params or {}
    self.status = 0
    self.currentCommand = nil
    self.abortCommand = nil
end

function TaskContext:getParam(key)
    return self.params[key]
end

function TaskContext:setParam(key, value)
    self.params[key] = value
end

function TaskContext:putParams(params)
    for k, v in pairs(params) do
        self.params[k] = v
    end
end

----------------------------------------------------------------------------------------------------
-- @type TaskEvent
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
TaskEvent = class(Event)
M.TaskEvent = TaskEvent

TaskEvent.TASK_START = "taskStart"

TaskEvent.TASK_END = "taskEnd"

TaskEvent.TASK_CANCEL = "taskCancel"

TaskEvent.TASK_ABORT = "taskAbort"

----------------------------------------------------------------------------------------------------
-- @type TaskMonitor
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
TaskMonitor = class()
M.TaskMonitor = TaskMonitor

TaskMonitor.POLICY_KILL = "kill"

TaskMonitor.POLICY_WAIT = "wait"

TaskMonitor.POLICY_CONCRRENT = "concrrent"

---
-- TODO:LDoc
function TaskMonitor:init(policy)
    self.policy = policy or TaskMonitor.POLICY_KILL
    self.runningCount = 0
end

---
-- TODO:LDoc
function TaskMonitor:isRunning()
    return self.runningCount > 0
end

---
-- TODO:LDoc
function TaskMonitor:isExecutable()
    if self.policy == TaskMonitor.POLICY_KILL then
        return self.runningCount == 0
    end

    return true
end

---
-- TODO:LDoc
function TaskMonitor:onTaskExecute(context)
    self.runningCount = self.runningCount + 1
end

---
-- TODO:LDoc
function TaskMonitor:onTaskStart(context)
    if self.policy == TaskMonitor.POLICY_WAIT then
        -- TODO:実装
    end
end

---
-- TODO:LDoc
function TaskMonitor:onTaskEnd(context)
    self.runningCount = self.runningCount - 1
end

----------------------------------------------------------------------------------------------------
-- @type TaskExecutor
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
TaskExecutor = class(EventDispatcher)
M.TaskExecutor = TaskExecutor

---
-- TODO:LDoc
function TaskExecutor:init()
    TaskExecutor.__super.init(self)
end

---
-- TODO:LDoc
function TaskExecutor.getInstance()
    if not TaskExecutor.INSTANCE then
        TaskExecutor.INSTANCE = TaskExecutor()
    end
    return TaskExecutor.INSTANCE
end

---
-- TODO:LDoc
function TaskExecutor:execute(task, params)
    local context = self:_createContext(task, params)

    if task.monitor then
        if task.monitor:isExecutable() then
            task.monitor:onTaskExecute(context)
        else
            self:dispatchTaskEvent(TaskEvent.TASK_CANCEL, task, context)
            return false
        end
    end

    flower.callOnce(function()
        self:_executeInternal(task, context)
    end)

    return true
end

---
-- TODO:LDoc
function TaskExecutor:dispatchTaskEvent(event, task, context)
    self:dispatchEvent(event, context)
    task:dispatchEvent(event, context)
end

---
-- TODO:LDoc
function TaskExecutor:_executeInternal(task, context)
    if task.monitor then
        task.monitor:onTaskStart(context)
    end

    self:dispatchTaskEvent(TaskEvent.TASK_START, task, context)

    context.status = task.commandGroup:execute(context)
    if context.status > 0 then
        self:dispatchTaskEvent(TaskEvent.TASK_ABORT, task, context)
    end

    if task.monitor then
        task.monitor:onTaskEnd(context)
    end

    self:dispatchTaskEvent(TaskEvent.TASK_END, task, context)
end

---
-- TODO:LDoc
function TaskExecutor:_createContext(task, params)
    return TaskContext(task, params)
end

----------------------------------------------------------------------------------------------------
-- @type CommandExecutor
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
CommandExecutor = class(EventDispatcher)
M.CommandExecutor = CommandExecutor

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

----------------------------------------------------------------------------------------------------
-- @type CommandEvent
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
CommandEvent = class(Event)
M.CommandEvent = CommandEvent

CommandEvent.COMMAND_COMPLETE = "commandComplete"

CommandEvent.COMMAND_ABORT = "commandAbort"

----------------------------------------------------------------------------------------------------
-- @type BaseCommand
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
BaseCommand = class(EventDispatcher)
M.BaseCommand = BaseCommand

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
-- 
function BaseCommand:setExecuteWhen(value)
    self.executeWhen = value
end

----------------------------------------------------------------------------------------------------
-- @type CommandGroup
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
CommandGroup = class(BaseCommand)
M.CommandGroup = CommandGroup

---
-- TODO:LDoc
function CommandGroup:initInternal(properties)
    self.commands = {}
    self.abortCommands = {}
    self.commandExecutor = CommandExecutor.getInstance()
end

---
-- TODO:LDoc
function CommandGroup:executeInternal(context)
    context.status = self.commandExecutor:execute(self.commands, context)
    if context.status > 0 then
        context.abortCommand = context.currentCommand
        self.commandExecutor:execute(self.abortCommands, context)
    end
    return context.status
end

function CommandGroup:setCommands(value)
    self.commands = value
end

function CommandGroup:setAborts(value)
    self.abortCommands = value
end

----------------------------------------------------------------------------------------------------
-- @type EchoCommand
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
EchoCommand = class(BaseCommand)
M.EchoCommand = EchoCommand

---
-- TODO:LDoc
function EchoCommand:initInternal(properties)
    self.message = nil
end

---
-- TODO:LDoc
function EchoCommand:executeInternal(context)
    print(self.message)
end

function EchoCommand:setMessage(value)
    self.message = value
end

----------------------------------------------------------------------------------------------------
-- @type AbortCommand
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
AbortCommand = class(BaseCommand)
M.AbortCommand = AbortCommand

---
-- TODO:LDoc
function AbortCommand:executeInternal(context)
    return 1
end

----------------------------------------------------------------------------------------------------
-- @type FunctionCommand
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
FunctionCommand = class(BaseCommand)
M.FunctionCommand = FunctionCommand

---
-- TODO:LDoc
function FunctionCommand:initInternal(properties)
    self.callback = nil
end

---
-- TODO:LDoc
function FunctionCommand:executeInternal(context)
    if self.callback then
        self.callback(context)
    end
end

function FunctionCommand:setCallback(value)
    self.callback = value
end

----------------------------------------------------------------------------------------------------
-- @type SetContextCommand
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------
SetContextCommand = class(BaseCommand)
M.SetContextCommand = SetContextCommand

---
-- TODO:LDoc
function SetContextCommand:initInternal(properties)
    self.params = nil
end

---
-- TODO:LDoc
function SetContextCommand:executeInternal(context)
    if self.params then
        context:putParams(self.params)
    end
end

function SetContextCommand:setParams(value)
    self.params = value
end

return M
