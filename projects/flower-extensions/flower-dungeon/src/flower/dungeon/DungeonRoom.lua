--------------------------------------------------------------------------------
-- @type DungeonRoom
-- ダンジョンの部屋クラスです.
-- 部屋の位置・大きさを保持します.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local DungeonRect = require "flower.dungeon.DungeonRect"

-- class
local DungeonRoom = class(DungeonRect)

---
-- コンストラクタ
function DungeonRoom:init(area, x, y, width, height)
    DungeonRoom.__super.init(self, x, y, width, height)
    self.area = area
    self.roads = {}
end

---
-- 部屋と繋がる通路を追加します.
function DungeonRoom:addRoad(road)
    table.insert(self.roads, road)
end

return DungeonRoom