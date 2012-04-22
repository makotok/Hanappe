----------------------------------------------------------------
-- 継承ではなく委譲による機能追加を行うモジュールです.<br>
-- @class table
-- @name delegate
----------------------------------------------------------------
local M = {}

function call(self, dest, src, funcName)
    if funcName then
        dest[funcName] = function(self, ...)
            return src[funcName](src, ...)
        end
        return
    end
    
    for k, v in pairs(src) do
        if type(v) == "function" then
            dest[k] = function(self, ...)
                return src[k](src, ...)
            end
        end
    end
end

setmetatable(M, {__call = call})

return M