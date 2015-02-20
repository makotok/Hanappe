----------------------------------------------------------------------------------------------------
-- Task System Library.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- module
local tasker = {}

----------------------------------------------------------------------------------------------------
-- Classes
-- @section Classes
----------------------------------------------------------------------------------------------------

---
-- Task Class.
-- @see flower.tasker.Task
tasker.Task = require "flower.tasker.Task"

---
-- TaskContext Class.
-- @see flower.tasker.TaskContext
tasker.TaskContext = require "flower.tasker.TaskContext"

---
-- TaskEvent Class.
-- @see flower.tasker.TaskEvent
tasker.TaskEvent = require "flower.tasker.TaskEvent"

---
-- TaskMonitor Class.
-- @see flower.tasker.TaskMonitor
tasker.TaskMonitor = require "flower.tasker.TaskMonitor"

---
-- TaskExecutor Class.
-- @see flower.tasker.TaskExecutor
tasker.TaskExecutor = require "flower.tasker.TaskExecutor"

---
-- BaseCommand Class.
-- @see flower.tasker.BaseCommand
tasker.BaseCommand = require "flower.tasker.BaseCommand"

---
-- CommandEvent Class.
-- @see flower.tasker.CommandEvent
tasker.CommandEvent = require "flower.tasker.CommandEvent"

---
-- CommandExecutor Class.
-- @see flower.tasker.CommandExecutor
tasker.CommandExecutor = require "flower.tasker.CommandExecutor"

---
-- CommandGroup Class.
-- @see flower.tasker.CommandGroup
tasker.CommandGroup = require "flower.tasker.CommandGroup"

---
-- EchoCommand Class.
-- @see flower.tasker.EchoCommand
tasker.EchoCommand = require "flower.tasker.EchoCommand"

---
-- AbortCommand Class.
-- @see flower.tasker.AbortCommand
tasker.AbortCommand = require "flower.tasker.AbortCommand"

---
-- FunctionCommand Class.
-- @see flower.tasker.FunctionCommand
tasker.FunctionCommand = require "flower.tasker.FunctionCommand"

---
-- SetContextCommand Class.
-- @see flower.tasker.SetContextCommand
tasker.SetContextCommand = require "flower.tasker.SetContextCommand"

return tasker