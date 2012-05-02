local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- イベントリスナーです.
-- ライブラリ内部で使用されます.
-- @class table
-- @name EventListener
--------------------------------------------------------------------------------
local M = class()

function M:init(eventType, callback, source, priority)
    self.type = eventType
    self.callback = callback
    self.source = source
    self.priority = priority and priority or 0
end

function M:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

return M
