local table = require("hp/lang/table")
local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- ダンジョンの部屋です.
-- @class table
-- @name DungeonRoom
--------------------------------------------------------------------------------
local M = class()

--------------------------------------------------------------------------------
-- コンストラクタです.
--------------------------------------------------------------------------------
function M:init(mapData, x, y, width, height)
    self.mapData = mapData
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

--------------------------------------------------------------------------------
-- 指定した座標が衝突するか返します.
--------------------------------------------------------------------------------
function M:collisionAt(x, y)
    return self.x <= x and x < self.x + self.width
       and self.y <= y and y < self.y + self.height
end

--------------------------------------------------------------------------------
-- ダンジョン上での型を返します.
--------------------------------------------------------------------------------
function M:getType()
    return "Room"
end

function M:canCreateTopRoad()
    return self.range.y > 1
end

function M:canCreateTopRoad()
    return self.range.y == 1
end

return M