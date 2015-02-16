----------------------------------------------------------------------------------------------------
-- Task System Library.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- module
local tasklib = {}

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- Task Class.
-- @see flower.tasklib.Task
tasklib.Task = require "flower.tasklib.Task"

---
-- TaskContext Class.
-- @see flower.tasklib.TaskContext
tasklib.TaskContext = require "flower.tasklib.TaskContext"

---
-- TaskEvent Class.
-- @see flower.tasklib.TaskEvent
tasklib.TaskEvent = require "flower.tasklib.TaskEvent"

---
-- TaskMonitor Class.
-- @see flower.tasklib.TaskMonitor
tasklib.TaskMonitor = require "flower.tasklib.TaskMonitor"

---
-- TaskExecutor Class.
-- @see flower.tasklib.TaskExecutor
tasklib.TaskExecutor = require "flower.tasklib.TaskExecutor"

---
-- BaseCommand Class.
-- @see flower.tasklib.BaseCommand
tasklib.BaseCommand = require "flower.tasklib.BaseCommand"

---
-- CommandEvent Class.
-- @see flower.tasklib.CommandEvent
tasklib.CommandEvent = require "flower.tasklib.CommandEvent"

---
-- CommandExecutor Class.
-- @see flower.tasklib.CommandExecutor
tasklib.CommandExecutor = require "flower.tasklib.CommandExecutor"

---
-- CommandGroup Class.
-- @see flower.tasklib.CommandGroup
tasklib.CommandGroup = require "flower.tasklib.CommandGroup"

---
-- EchoCommand Class.
-- @see flower.tasklib.EchoCommand
tasklib.EchoCommand = require "flower.tasklib.EchoCommand"

---
-- AbortCommand Class.
-- @see flower.tasklib.AbortCommand
tasklib.AbortCommand = require "flower.tasklib.AbortCommand"

---
-- FunctionCommand Class.
-- @see flower.tasklib.FunctionCommand
tasklib.FunctionCommand = require "flower.tasklib.FunctionCommand"

---
-- SetContextCommand Class.
-- @see flower.tasklib.SetContextCommand
tasklib.SetContextCommand = require "flower.tasklib.SetContextCommand"

return tasklib