----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local BaseCommand = require "flower.tasklib.BaseCommand"

-- class
local FunctionCommand = class(BaseCommand)

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

---
-- TODO:LDoc
function FunctionCommand:setCallback(value)
    self.callback = value
end

return FunctionCommand