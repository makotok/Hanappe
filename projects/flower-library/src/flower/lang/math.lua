----------------------------------------------------------------------------------------------------
-- @type math
--
-- This set of functions extends the native lua 'math' function set with
-- additional useful methods.
----------------------------------------------------------------------------------------------------
local math = setmetatable({}, {__index = _G.math})

---
-- Calculate the average of the values of the argument.
-- @param ... a variable number of arguments, all of which should be numbers
-- @return average
function math.average(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total / #array
end

---
-- Calculate the total values of the argument
-- @param ... a variable number of arguments, all of which should be numbers
-- @return total
function math.sum(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total
end

---
-- Calculate the distance.
-- @param x0 Start position.
-- @param y0 Start position.
-- @param x1 (option)End position (note: default value is 0)
-- @param y1 (option)End position (note: default value is 0)
-- @return distance
function math.distance( x0, y0, x1, y1 )
    if not x1 then x1 = 0 end
    if not y1 then y1 = 0 end

    local dX = x1 - x0
    local dY = y1 - y0
    local dist = math.sqrt((dX * dX) + (dY * dY))
    return dist
end

---
-- Computes attenuation as a function of distance.
-- @param distance Distance
-- @return distance^(-2/3)
function math.attenuation(distance)
    distance = distance == 0 and 1 or math.pow(distance, 0.667)
    return 1 / distance
end

---
-- Get the normal vector
-- @param x
-- @param y
-- @return x/d, y/d
function math.normalize( x, y )
    local d = math.distance( x, y )
    return x/d, y/d
end

return math