--------------------------------------------------------------------------------
-- modules that extend functionality of the math.
-- @class table
-- @name math
--------------------------------------------------------------------------------
local gmath = math
local math = {}
setmetatable(math, {__index = gmath})

---------------------------------------
-- Calculate the average of the values of the argument.
-- @param ... The number of variable-length argument
-- @return average
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
-- Calculate the total values of the argument
-- @param ... The number of variable-length argument
-- @return total
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
