----------------------------------------------------------------------------------------------------
-- @type class
--
-- This implements object-oriented style classes in Lua, including multiple inheritance.
-- This particular variation of class implementation copies the base class
-- functions into this class, which improves speed over other implementations
-- in return for slightly larger class tables.  Please note that the inherited
-- class members are therefore cached and subsequent changes to a superclass
-- may not be reflected in your subclasses.
----------------------------------------------------------------------------------------------------

-- import
local table = require("flower.lang.table")

-- class
local class = {}
setmetatable(class, class)

---
-- This allows you to define a class by calling 'class' as a function,
-- specifying the superclasses as a list.  For example:
-- mynewclass = class(superclass1, superclass2)
-- @param ... Base class list.
-- @return class
function class:__call(...)
    local clazz = table.copy(self)
    local bases = {...}
    for i = #bases, 1, -1 do
        table.copy(bases[i], clazz)
    end
    clazz.__class = clazz
    clazz.__super = bases[1]
    clazz.__call = function(self, ...)
        return self:__new(...)
    end
    clazz.__interface = {__index = clazz}
    setmetatable(clazz.__interface, clazz.__interface)
    return setmetatable(clazz, clazz)
end

---
-- Generic constructor function for classes.
-- Note that __new() will call init() if it is available in the class.
-- @return Instance
function class:__new(...)
    local obj = self:__object_factory()

    if obj.init then
        obj:init(...)
    end

    return obj
end

---
-- Returns the new object.
-- @return object
function class:__object_factory()
    local moai_class = self.__moai_class

    if moai_class then
        local obj = moai_class.new()
        obj:setInterface(self.__interface)
        return obj
    end

    return setmetatable({}, self.__interface)
end

return class