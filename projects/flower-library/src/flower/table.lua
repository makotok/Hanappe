----------------------------------------------------------------------------------------------------
-- The next group of functions extends the default lua table implementation
-- to include some additional useful methods.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------
local table = setmetatable({}, {__index = _G.table})

---
-- Returns the position found by searching for a matching value from an array.
-- @param array table array
-- @param value Search value
-- @return the index number if the value is found, or 0 if not found.
function table.indexOf(array, value)
    for i, v in ipairs(array) do
        if v == value then
            return i
        end
    end
    return 0
end

---
-- Same as indexOf, only for key values (slower)
-- Author:Nenad Katic
function table.keyOf(src, val)
    for k, v in pairs(src) do
        if v == val then
            return k
        end
    end
    return nil
end

---
-- Copy the table shallowly (i.e. do not create recursive copies of values)
-- @param src copy
-- @param dest (option)Destination
-- @return dest
function table.copy(src, dest)
    dest = dest or {}
    for i, v in pairs(src) do
        dest[i] = v
    end
    return dest
end

---
-- Copy the table deeply (i.e. create recursive copies of values)
-- @param src copy
-- @param dest (option)Destination
-- @return dest
function table.deepCopy(src, dest)
    dest = dest or {}
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = table.deepCopy(v)
        else
            dest[k] = v
        end
    end
    return dest
end

---
-- Adds an element to the table if and only if the value did not already exist.
-- @param t table
-- @param o element
-- @return If it already exists, returns false. If it did not previously exist, returns true.
function table.insertIfAbsent(t, o)
    if table.indexOf(t, o) > 0 then
        return false
    end
    t[#t + 1] = o
    return true
end

---
-- Adds an element to the table.
-- @param t table
-- @param o element
-- @return true
function table.insertElement(t, o)
    t[#t + 1] = o
    return true
end

---
-- Removes the element from the table.
-- If the element existed, then returns its index value.
-- If the element did not previously exist, then return 0.
-- @param t table
-- @param o element
-- @return index
function table.removeElement(t, o)
    local i = table.indexOf(t, o)
    if i > 0 then
        table.remove(t, i)
    end
    return i
end

return table