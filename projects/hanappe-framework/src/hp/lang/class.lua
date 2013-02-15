--------------------------------------------------------------------------------
-- Class that enable you to easily object-oriented. <br>
-- Provide the basic functionality of the class. <br>
-- <br>
-- class does not perform inheritance setmetatable. <br>
-- The inheritance by copying it to the table. <br>
-- Will consume a little more memory,
-- the performance does not deteriorate if the inheritance is deep. <br>
--------------------------------------------------------------------------------

local table = require("hp/lang/table")

local M = {}
setmetatable(M, M)

local function call(self, ...)
    return self:new(...)
end

--------------------------------------------------------------------------------
-- Class definition is a function.
-- @param ... Base class list.
-- @return class
--------------------------------------------------------------------------------
function M:__call(...)
    local class = table.copy(self)
    local bases = {...}
    for i = #bases, 1, -1 do
        table.copy(bases[i], class)
    end
    class.__call = call
    return setmetatable(class, class)
end

--------------------------------------------------------------------------------
-- Instance generating functions.<br>
-- The user can use this function.<br>
-- Calling this function, init function will be called internally.<br>
-- @return Instance
--------------------------------------------------------------------------------
function M:new(...)
    local obj = {__index = self}
    setmetatable(obj, obj)

    if obj.init then
        obj:init(...)
    end

    obj.new = nil
    obj.init = nil

    return obj
end

return M
