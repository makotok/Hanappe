--------------------------------------------------------------------------------
-- tableの機能拡張したモジュールです.
-- @class table
-- @name table
--------------------------------------------------------------------------------
local gmath = math
local math = {}
setmetatable(math, {__index = gmath})

---------------------------------------
-- 引数の値の平均値を求めます
-- @param ... 可変長引数の数値
-- @return 平均値
---------------------------------------
function math.average(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total / #array
end

---------------------------------------
-- 引数の値の合計を求めます
-- @param ... 可変長引数の数値
-- @return 合計
---------------------------------------
function math.sum(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total
end

return math
