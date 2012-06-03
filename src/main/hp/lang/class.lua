local table = require("hp/lang/table")

--------------------------------------------------------------------------------
-- Class that enable you to easily object-oriented.<br>
-- Provide the basic functionality of the class.<br>
-- <br>
-- class does not perform inheritance setmetatable.<br>
-- The inheritance by copying it to the table.<br>
-- Will consume a little more memory,
-- the performance does not deteriorate if the inheritance is deep.<br>
-- @class table
-- @name class
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Returns a list of variables that are private from metatable.<br>
-- Encapsulates the variables in a pseudo manner.<br>
-- Since this function intended to be used internally, please do not reference user.
-- @return mt.__privates
--------------------------------------------------------------------------------
function M:getPrivates()
    local mt = getmetatable(self)
    mt.__privates = mt.__privates or {}
    return mt.__privates
end

--------------------------------------------------------------------------------
-- Returns the private variable.<br>
-- Encapsulates the variables in a pseudo manner.<br>
-- Since this function intended to be used internally, please do not reference user.
-- @param name Private variable name
-- @return Private variable
--------------------------------------------------------------------------------
function M:getPrivate(name)
    local mt = getmetatable(self)
    mt.__privates = mt.__privates or {}
    return mt.__privates[name]
end

--------------------------------------------------------------------------------
-- Set the private variable.<br>
-- Encapsulates the variables in a pseudo manner.<br>
-- Since this function intended to be used internally, please do not reference user.
-- @param name Private variable name
-- @return value Private variable
--------------------------------------------------------------------------------
function M:setPrivate(name, value)
    local mt = getmetatable(self)
    mt.__privates = mt.__privates or {}
    mt.__privates[name] = value
end

return M
