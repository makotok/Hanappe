----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"

-- class
local TaskContext = class()

---
-- TODO:LDoc
function TaskContext:init(task, params)
    self.task = assert(task)
    self.params = params or {}
    self.status = 0
    self.currentCommand = nil
    self.abortCommand = nil
end

---
-- TODO:LDoc
function TaskContext:getParam(key)
    return self.params[key]
end

---
-- TODO:LDoc
function TaskContext:setParam(key, value)
    self.params[key] = value
end

---
-- TODO:LDoc
function TaskContext:putParams(params)
    for k, v in pairs(params) do
        self.params[k] = v
    end
end

return TaskContext