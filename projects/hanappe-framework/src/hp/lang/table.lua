--------------------------------------------------------------------------------
--
-- modules that extend functionality of the table.
--
--------------------------------------------------------------------------------

local M = {}
setmetatable(M, {__index = table})

-- Compatibility and implementation of Lua5.2 Lua5.1
if unpack then
    M.unpack = unpack
end

--------------------------------------------------------------------------------
-- Table decorate is useful for decorating objects
-- when using tables as classes.
-- @param src
-- @param arg1 - string=new key when string, needs arg2
-- @param arg2 - table=will extend all key/values     
--------------------------------------------------------------------------------
function M.decorate( src, arg1, arg2 )
    if not arg2 then
        if type(arg1)=="table" then
            for k,v in pairs( arg1 ) do
                if not src[k] then
                    src[k] = v
                elseif src[ k ] ~= v then
                    print( "ERROR (table.decorate): Extension failed because key "..k.." exists.") 
                end   
            end
        end
    elseif type(arg1)=="string" and type(arg2)=="function" then
        if not src[arg1] then
            src[arg1] = arg2
        elseif src[ arg1 ] ~= arg2 then
            print( "ERROR (table.decorate): Extension failed because key "..arg1.." exists.") 
        end      
    end
end

--------------------------------------------------------------------------------
-- table.override and table.extend are very similar, but are made different
-- routines so that they wouldn't be confused
-- Author:Nenad Katic<br>
--------------------------------------------------------------------------------
function M.extend( src, dest )
    for k,v in pairs( src) do
        if not dest[k] then
            dest[k] = v
        end
    end
end

--------------------------------------------------------------------------------
-- Copies and overrides properties from src to dest.<br>
-- If onlyExistingKeys is true, it *only* overrides the properties.<br>
-- Author:Nenad Katic<br>
--------------------------------------------------------------------------------
function M.override( src, dest, onlyExistingKeys )
    for k,v in pairs( src ) do
        if not onlyExistingKeys then
            dest[k] = v
        elseif dest[k] then
            -- override only existing keys if asked for
            dest[k] = v
        end
    end
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
-- Same as indexOf, only for key values (slower)
-- Author:Nenad Katic<br>
--------------------------------------------------------------------------------
function M.keyOf( src, val )
    for k, v in pairs( src ) do
        if v == val then
            return k
        end
    end
    return nil
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
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = M.deepCopy(v)
        else
            dest[k] = v
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
    M.remove(t, i)
    return i
end

return M
