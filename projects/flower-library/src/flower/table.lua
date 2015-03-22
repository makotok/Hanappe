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

function table.isEmpty(t)
    if next(t) == nil then
        return true
    end
    return false
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

---
-- Inserts a given value through BinaryInsert into the table sorted by [, comp].
-- 
-- If 'comp' is given, then it must be a function that receives
-- two table elements, and returns true when the first is less
-- than the second, e.g. comp = function(a, b) return a > b end,
-- will give a sorted table, with the biggest value on position 1.
-- [, comp] behaves as in table.sort(table, value [, comp])
-- returns the index where 'value' was inserted
--
-- @param t table
-- @param value value
-- @param fcomp Compare function
-- @return index where 'value' was inserted
function table.bininsert(t, value, fcomp)
    -- Initialise compare function
    local fcomp = fcomp or function( a,b ) return a < b end
    --  Initialise numbers
    local iStart,iEnd,iMid,iState = 1,#t,1,0
    -- Get insert position
    while iStart <= iEnd do
        -- calculate middle
        iMid = math.floor( (iStart+iEnd)/2 )
        -- compare
        if fcomp( value,t[iMid] ) then
            iEnd,iState = iMid - 1,0
        else
            iStart,iState = iMid + 1,1
        end
    end
    table.insert( t,(iMid+iState),value )
    return (iMid+iState)
end

return table