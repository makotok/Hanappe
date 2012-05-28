--------------------------------------------------------------------------------
-- オブジェクトの比較を行うユーティリティクラスです.<br>
-- @class table
-- @name CompareUtil
--------------------------------------------------------------------------------
local M = {}

-- 定数
M.EQ = "EQ"
M.NE = "NE"
M.LT = "LT"
M.LE = "LE"
M.GT = "GT"
M.GE = "GE"

function M.compare(a, b, comp)
    comp = comp or M.EQ
    if type(comp) == "string" then
        comp = M["compare"] .. comp
    end
    return comp(a, b)
end

function M.compareEQ(a, b)
    return a == b
end

function M.compareNE(a, b)
    return a ~= b
end

function M.compareLT(a, b)
    return a < b
end

function M.compareLE(a, b)
    return a <= b
end

function M.compareGT(a, b)
    return a > b
end

function M.compareGE(a, b)
    return a >= b
end

return M