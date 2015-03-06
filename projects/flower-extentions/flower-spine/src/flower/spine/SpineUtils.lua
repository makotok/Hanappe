---
-- Internal helper functions
--

-- class
local SpineUtils = {}

---
-- Wraps the angle.
-- @param angle
-- @return Wrapped angle.
function SpineUtils.wrapAngle(angle)
    while angle > 180 do
        angle = angle - 360
    end
    while angle < -180 do
        angle = angle + 360
    end
    return angle
end

function SpineUtils.genBezierKeys(numkeys, cx1, cy1, cx2, cy2)
    local subdiv_step = 1 / numkeys
    local subdiv_step2 = subdiv_step * subdiv_step
    local subdiv_step3 = subdiv_step2 * subdiv_step
    local pre1 = 3 * subdiv_step
    local pre2 = 3 * subdiv_step2
    local pre4 = 6 * subdiv_step2
    local pre5 = 6 * subdiv_step3
    local tmp1x = -cx1 * 2 + cx2
    local tmp1y = -cy1 * 2 + cy2
    local tmp2x = (cx1 - cx2) * 3 + 1
    local tmp2y = (cy1 - cy2) * 3 + 1
    local curves = {}
    dfx = cx1 * pre1 + tmp1x * pre2 + tmp2x * subdiv_step3
    dfy = cy1 * pre1 + tmp1y * pre2 + tmp2y * subdiv_step3
    ddfx = tmp1x * pre4 + tmp2x * pre5
    ddfy = tmp1y * pre4 + tmp2y * pre5
    dddfx = tmp2x * pre5
    dddfy = tmp2y * pre5

    local res = {}

    local x = dfx
    local y = dfy

    res[1] = {0, 0}
    for i = 2, numkeys-1 do
        res[i] = {x, y}

        dfx = dfx + ddfx
        dfy = dfy + ddfy
        ddfx = ddfx + dddfx
        ddfy = ddfy + dddfy
        x = x + dfx
        y = y + dfy
    end
    res[numkeys] = {1, 1}

    return res
end

-- premultiply alpha
function SpineUtils.hexToRGBA(color)
    local a = tonumber(color:sub(7, 8), 16) / 255
    return  a * tonumber(color:sub(1, 2), 16) / 255,
            a * tonumber(color:sub(3, 4), 16) / 255,
            a * tonumber(color:sub(5, 6), 16) / 255,
            a
end

function SpineUtils.split(str, pat)
    local t = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t,cap)
        end
        last_end = e+1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

function SpineUtils.length(haystack)
    local count = 0
    for _ in pairs(haystack) do count = count + 1 end
    return count
end

function SpineUtils.trim(text)
    return text:gsub("^%s*(.-)%s*$", "%1")
end

function SpineUtils.getPath(str)
    return str:match("(.*/)")
end

function SpineUtils.getExtension(str)
    return str:match("(.[^.]+)$")
end

return SpineUtils