--------------------------------------------------------------------------------
-- イベントリスナーです.
-- ライブラリ内部で使用されます.
-- @class table
-- @name EventListener
--------------------------------------------------------------------------------
local M = {}
local I = {}

function M:new(eventType, callback, source, priority)
    local obj = {
        type = eventType,
        callback = callback,
        source = source,
        priority = priority and priority or 0
    }
    
    return setmetatable(obj, {__index = I})
end

function I:call(event)
    if self.source then
        self.callback(self.source, event)
    else
        self.callback(event)
    end
end

return M
