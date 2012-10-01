--------------------------------------------------------------------------------
-- Class that enable you to easily object-oriented. <br>
-- Provide the basic functionality of the class. <br>
-- <br>
-- class does not perform inheritance setmetatable. <br>
-- The inheritance by copying it to the table. <br>
-- Will consume a little more memory,
-- the performance does not deteriorate if the inheritance is deep. <br>
--
-- @auther Makoto
-- @class table
-- @name class
--------------------------------------------------------------------------------

local table = require("hp/lang/table")

local M = {}
setmetatable(M, M)

local function call(self, ...)
    return self:new(...)
end

--------------------------------------------------------------------------------
-- Class definition is a function.
-- @param ... Base class list.
-- @return class
--------------------------------------------------------------------------------
function M:__call(...)
    local class = table.copy(self)
    local bases = {...}
    for i = #bases, 1, -1 do
        table.copy(bases[i], class)
    end
    class.__call = call
    return setmetatable(class, class)
end

--------------------------------------------------------------------------------
-- Instance generating functions.<br>
-- The user can use this function.<br>
-- Calling this function, init function will be called internally.<br>
-- @return Instance
--------------------------------------------------------------------------------
function M:new(...)
    local obj = {__index = self}
    setmetatable(obj, obj)
    
    if obj.init then
        obj:init(...)
    end

    obj.new = nil
    obj.init = nil
    
    return obj
end



--------------------------------------------------------------------------------
-- modules that extend functionality of the math.
-- @class table
-- @name math
--------------------------------------------------------------------------------
local math = setmetatable({}, {__index = _G.math})

--------------------------------------------------------------------------------
-- Calculate the average of the values of the argument.
-- @param ... The number of variable-length argument
-- @return average
--------------------------------------------------------------------------------
function math.average(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total / #array
end

--------------------------------------------------------------------------------
-- Calculate the total values of the argument
-- @param ... The number of variable-length argument
-- @return total
--------------------------------------------------------------------------------
function math.sum(...)
    local total = 0
    local array = {...}
    for i, v in ipairs(array) do
        total = total + v
    end
    return total
end

--------------------------------------------------------------------------------
-- TODO
--------------------------------------------------------------------------------
function math.distance( x0, y0, x1, y1 )
    if not x1 then x1 = 0 end
    if not y1 then y1 = 0 end
    
    local dX = x1 - x0
    local dY = y1 - y0
    local dist = math.sqrt((dX * dX) + (dY * dY))
    return dist
end

--------------------------------------------------------------------------------
-- TODO
--------------------------------------------------------------------------------
function math.normalize( x, y )
    local d = math.distance( x, y )
    return x/d, y/d
end

--------------------------------------------------------------------------------
-- TODO
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- TODO
--------------------------------------------------------------------------------
function math.clamp( v, min, max )
    if v < min then
        v = min
    elseif v > max then
        v = max
    end
    return v
end


return M
