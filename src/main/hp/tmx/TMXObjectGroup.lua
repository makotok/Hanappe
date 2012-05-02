local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- TMXMapのObjectGroupです.
--
-- @class table
-- @name TMXObjectGroup
--------------------------------------------------------------------------------
local M = class()

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(tmxMap)
    self.name = ""
    self.width = 0
    self.height = 0
    self.tmxMap = tmxMap
    self.objects = {}
    self.properties = {}
end

---------------------------------------
-- オブジェクトを追加します.
---------------------------------------
function M:addObject(object)
    table.insert(self.objects, object)
end

---------------------------------------
-- プロパティを返します.
---------------------------------------
function M:getProperty(key)
    return self.properties[key]
end

return M
