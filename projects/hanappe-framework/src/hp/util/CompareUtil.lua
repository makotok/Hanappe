--------------------------------------------------------------------------------
-- This is a utility class to do a comparison of the object.<br>
--------------------------------------------------------------------------------
local M = {}

-- Constant
M.EQ = "EQ"
M.NE = "NE"
M.LT = "LT"
M.LE = "LE"
M.GT = "GT"
M.GE = "GE"

--------------------------------------------------------------------------------
-- Compare the b and a.<br>
-- Sets the comparison function as an argument.<br>
-- @param a Target.
-- @param b Target.
-- @param comp Function or a string constant.
-- @return True if the comparison result is matched.
--------------------------------------------------------------------------------
function M.compare(a, b, comp)
    comp = comp or M.EQ
    if type(comp) == "string" then
        comp = M["compare"] .. comp
    end
    return comp(a, b)
end

--------------------------------------------------------------------------------
-- Compare the b and a.<br>
-- @param a Target.
-- @param b Target.
-- @return True if equal.
--------------------------------------------------------------------------------
function M.compareEQ(a, b)
    return a == b
end

--------------------------------------------------------------------------------
-- Compare the b and a.<br>
-- @param a Target.
-- @param b Target.
-- @return True if not equal.
--------------------------------------------------------------------------------
function M.compareNE(a, b)
    return a ~= b
end

--------------------------------------------------------------------------------
-- Compare the b and a.<br>
-- @param a Target.
-- @param b Target.
-- @return True if less than.
--------------------------------------------------------------------------------
function M.compareLT(a, b)
    return a < b
end

--------------------------------------------------------------------------------
-- Compare the b and a.<br>
-- @param a Target.
-- @param b Target.
-- @return True if less than or equal.
--------------------------------------------------------------------------------
function M.compareLE(a, b)
    return a <= b
end

--------------------------------------------------------------------------------
-- Compare the b and a.<br>
-- @param a Target.
-- @param b Target.
-- @return True if greater than.
--------------------------------------------------------------------------------
function M.compareGT(a, b)
    return a > b
end

--------------------------------------------------------------------------------
-- Compare the b and a.<br>
-- @param a Target.
-- @param b Target.
-- @return True if greater than or equal.
--------------------------------------------------------------------------------
function M.compareGE(a, b)
    return a >= b
end

return M