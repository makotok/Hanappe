--------------------------------------------------------------------------------
-- modules that extend functionality of the table.
-- @class table
-- @name table
--------------------------------------------------------------------------------
local M = {}
setmetatable(M, {__index = table})

-- Compatibility and implementation of Lua5.2 Lua5.1
if unpack then
    M.unpack = unpack
end

--------------------------------------------------------------------------------
-- Returns the position found by searching for a matching value from the array.
-- @param array table array
-- @param value Search value
-- @return If one is found the index. 0 if not found.
--------------------------------------------------------------------------------
function M.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

--------------------------------------------------------------------------------
-- The shallow copy of the table.
-- @param src copy
-- @param dest (option)Destination
-- @return dest
--------------------------------------------------------------------------------
function M.copy(src, dest)
    dest = dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end

--------------------------------------------------------------------------------
-- The deep copy of the table.
-- @param src copy
-- @param dest (option)Destination
-- @return dest
--------------------------------------------------------------------------------
function M.deepCopy(src, dest)
    dest = dest or {}
    for i, v in pairs(src) do
        if type(v) == "table" then
            dest[i] = {}
            M.deepCopy(v, dest[i])
        else
            dest[i] = v
        end
    end
    return dest
end

--------------------------------------------------------------------------------
-- Adds an element to the table.
-- If the element was present, the element will return false without the need for additional.
-- If the element does not exist, and returns true add an element.
-- @param t table
-- @param o element
-- @return If it already exists, false. If you add is true.
--------------------------------------------------------------------------------
function M.insertElement(t, o)
    if M.indexOf(t, o) > 0 then
        return false
    end
    M.insert(t, o)
    return true
end

--------------------------------------------------------------------------------
-- This removes the element from the table.
-- If you have successfully removed, it returns the index of the yuan.
-- If there is no element, it returns 0.
-- @param t table
-- @param o element
-- @return index
--------------------------------------------------------------------------------
function M.removeElement(t, o)
    local i = M.indexOf(t, o)
    if i == 0 then
        return 0
    end
    M.remove(t, o)
    return i
end

return M
