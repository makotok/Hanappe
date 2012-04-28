--------------------------------------------------------------------------------
-- TMXMapのObjectGroupです.
--
-- @class table
-- @name TMXObject
--------------------------------------------------------------------------------
local M = {}

-- constraints
M.ATTRIBUTE_NAMES = {"name", "type", "x", "y", "width", "height", "gid"}

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:new()
    local obj = {
        name = "",
        type = "",
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        gid = nil,
        properties = {},
    }
    return obj
end

return M
