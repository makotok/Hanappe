----------------------------------------------------------------
-- Modules to perform additional functions by delegation. <br>
----------------------------------------------------------------
local M = {}

local function call(self, dest, src, funcName)
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