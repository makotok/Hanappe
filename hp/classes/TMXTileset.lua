--------------------------------------------------------------------------------
-- TMXMapのタイルセットクラスです.
--
-- @class table
-- @name TMXTileset
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
        firstgid = 0,
        tilewidth = 0,
        tileheight = 0,
        spacing = 0,
        margin = 0,
        image = {source = "", width = 0, height = 0},
        tiles = {},
        properties = {},
    }
    return setmetatable(obj, {__index = I})
end

---------------------------------------
-- gidからタイルインデックスを返します.
---------------------------------------
function I:getTileIndexByGid(gid)
    return gid - self.firstgid + 1
end

return M