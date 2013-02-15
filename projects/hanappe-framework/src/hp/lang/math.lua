--------------------------------------------------------------------------------
-- modules that extend functionality of the math.
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

function math.distance( x0, y0, x1, y1 )
    if not x1 then x1 = 0 end
    if not y1 then y1 = 0 end
    
    local dX = x1 - x0
    local dY = y1 - y0
    local dist = math.sqrt((dX * dX) + (dY * dY))
    return dist
end

function math.normalize( x, y )
    local d = math.distance( x, y )
    return x/d, y/d
end

function math.getAngle( a, b, c )
    local result
    if c then
        local ab, bc = { }, { }
        
        ab.x = b.x - a.x;
        ab.y = b.y - a.y;

        bc.x = b.x - c.x;
        bc.y = b.y - c.y;
        
        local angleAB   = math.atan2( ab.y, ab.x )
        local angleBC   = math.atan2( bc.y, bc.x )
        result = angleAB - angleBC
    else
        local ab = { }

        ab.x = b.x - a.x;
        ab.y = b.y - a.y;
        result = math.deg( math.atan2( ab.y, ab.x ) )

    end
    return  result
end

function math.clamp( v, min, max )
    if v < min then
        v = min
    elseif v > max then
        v = max
    end
    return v
end

return math
