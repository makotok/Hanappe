----------------------------------------------------------------------------------------------------
-- Small library for bit operation.
-- 
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- class
local BitUtils = {}

---
-- Returns a numeric value of the specified bit.
function BitUtils.bit(p)
    return 2 ^ (p - 1)  -- 1-based indexing
end

function BitUtils.hasbit(x, p)
    return x % (p + p) >= p       
end

function BitUtils.setbit(x, p)
    return BitUtils.hasbit(x, p) and x or x + p
end

function BitUtils.clearbit(x, p)
    return BitUtils.hasbit(x, p) and x - p or x
end

return BitUtils