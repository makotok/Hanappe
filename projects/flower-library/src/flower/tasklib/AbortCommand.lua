----------------------------------------------------------------------------------------------------
-- TODO:LuaDoc
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local BaseCommand = require "flower.tasklib.BaseCommand"

-- class
local AbortCommand = class(BaseCommand)

---
-- TODO:LDoc
function AbortCommand:executeInternal(context)
    return 1
end

return AbortCommand