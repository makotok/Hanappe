--------------------------------------------------------------------------------
-- TMXMapのObjectGroupです.
--
-- @class table
-- @name TMXObjectGroup
--------------------------------------------------------------------------------
local M = {}
local I = {}

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:new(tmxMap)
    local obj = {
        name = "",
        width = 0,
        height = 0,
        tmxMap = tmxMap,
        objects = {},
        properties = {},
    }
    return setmetatable(obj, {__index = I})
end

---------------------------------------
-- オブジェクトを追加します.
---------------------------------------
function I:addObject(object)
    table.insert(self.objects, object)
end

---------------------------------------
-- プロパティを返します.
---------------------------------------
function I:getProperty(key)
    return self.properties[key]
end

return M
