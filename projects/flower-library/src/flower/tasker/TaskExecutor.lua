----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Event = require "flower.core.Event"
local EventDispatcher = require "flower.core.EventDispatcher"
local TaskContext = require "flower.tasker.TaskContext"
local TaskEvent = require "flower.tasker.TaskEvent"

-- class
local TaskExecutor = class(EventDispatcher)

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

return TaskExecutor