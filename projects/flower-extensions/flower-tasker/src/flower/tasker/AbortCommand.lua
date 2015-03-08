----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local BaseCommand = require "flower.tasker.BaseCommand"

-- class
local AbortCommand = class(BaseCommand)

---
-- TODO:LDoc
function AbortCommand:executeInternal(context)
    return 1
end

return AbortCommand