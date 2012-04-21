--------------------------------------------------------------------------------
-- TMXMapのレイヤークラスです.
-- @class table
-- @name TMXLayer
--------------------------------------------------------------------------------
local M = {}
local I = {}

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:new(tmxMap)
    local obj = {
        tmxMap = tmxMap,
        name = "",
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        opacity = 0,
        visible = true,
        properties = {},
        tiles = {},
    }

    return setmetatable(obj, {__index = I})
end

---------------------------------------
-- プロパティを返します.
---------------------------------------
function I:getProperty(key)
    return self.properties[key]
end

return M