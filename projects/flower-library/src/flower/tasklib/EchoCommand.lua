----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local BaseCommand = require "flower.tasklib.BaseCommand"
local CommandExecutor = require "flower.tasklib.CommandExecutor"

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