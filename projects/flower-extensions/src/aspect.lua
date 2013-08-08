----------------------------------------------------------------------------------------------------
-- Library to support the aspect-oriented.
--
-- @author Makoto
-- @release V2.1.2
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class

-- classes
local Interceptor

----------------------------------------------------------------------------------------------------
-- @type Interceptor
--
-- This is a class to add another process will intercept function of the table.
----------------------------------------------------------------------------------------------------
Interceptor = class()
M.Interceptor = Interceptor

---
-- Constructor.
-- @param targets target tables
-- @param filter String to filter function
function Interceptor:init(targets, filter)
    for key, target in pairs(targets) do
        if type(target) == "table" then
            self:intercept(target, filter)
        end
    end
end

---
-- To intercept a function present in the target table, to add a different action.
-- @param target target table
-- @param filterPattern filter pattern.
function Interceptor:intercept(target, filterPattern)
    for key, value in pairs(target) do
        if type(value) == "function" then
            if not filterPattern or key:match(filterPattern) then
                local context = {
                    target = target,
                    func = value,
                    name = key,
                }
                target[key] = function(...)
                    return self:invoke(context, ...)
                end
            end
        end
    end
end

---
-- Processing at the beginning.
-- @param context target context.
-- @param ... args
function Interceptor:invoke(context, ...)
    self:beginProcess(context, ...)
    local returnValues = {context.func(...)}
    self:endProcess(context, ...)
    return unpack(returnValues)
end

---
-- Processing at the beginning.
-- @param context target context.
-- @param ... args
function Interceptor:beginProcess(context, ...)
end

---
-- Processing at the end.
-- @param context target context.
-- @param ... args
function Interceptor:endProcess(context, ...)
end

return M
