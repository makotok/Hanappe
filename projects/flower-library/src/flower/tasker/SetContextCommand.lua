----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local BaseCommand = require "flower.tasker.BaseCommand"

-- class
local SetContextCommand = class(BaseCommand)

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

---
-- TODO:LDoc
function SetContextCommand:setParams(value)
    self.params = value
end

return SetContextCommand
