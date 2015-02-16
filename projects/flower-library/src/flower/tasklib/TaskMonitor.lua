----------------------------------------------------------------------------------------------------
-- @type TaskMonitor
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"

-- class
local TaskMonitor = class()

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

return TaskMonitor