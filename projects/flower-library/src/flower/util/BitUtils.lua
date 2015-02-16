----------------------------------------------------------------------------------------------------
-- Small library for bit operation.
----------------------------------------------------------------------------------------------------
local BitUtils = {}

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