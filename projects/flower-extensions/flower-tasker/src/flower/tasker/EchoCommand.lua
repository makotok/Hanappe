----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local BaseCommand = require "flower.tasker.BaseCommand"
local CommandExecutor = require "flower.tasker.CommandExecutor"

-- class
local EchoCommand = class(BaseCommand)

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

---
-- TODO:LDoc
function EchoCommand:setMessage(value)
    self.message = value
end

return EchoCommand