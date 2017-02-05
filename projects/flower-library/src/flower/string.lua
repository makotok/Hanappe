----------------------------------------------------------------------------------------------------
-- The next group of functions extends the default lua string implementation
-- to include some additional useful methods.
--
-- @author Makoto
-- @release V3.0.2
----------------------------------------------------------------------------------------------------
local string = setmetatable({}, {__index = _G.string})

---
--  Return a filling in zeros at beginning.
--  Technically, this shouldn't really extend string class
--  because it doesn't operate on string (doesn't have a "self" )
function string.leftPad( s, l, p)
    s = type(s) == "string" and s or tostring(s)
    p = p or " "
    local sl = string.len(s)
    if sl < l then
        for i = 1, l - sl do
            s = p .. s
        end
    end
    return s
end

---
-- Splits string into a table of strings using delimiter.<br>
-- Usage: local table = a:split( ",", false )<br>
-- TODO:  Does not correspond to multi-byte.<br>
-- @param str string.
-- @param delim Delimiter.
-- @return Split the resulting table
function string.split( str, delim )

    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end

    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local lastPos = 1
    for part, pos in string.gfind(str, pat) do
        table.insert(result, part)
        lastPos = pos
    end
    table.insert(result, string.sub(str, lastPos))
    return result
end

return M
