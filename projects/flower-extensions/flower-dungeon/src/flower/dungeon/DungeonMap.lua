--------------------------------------------------------------------------------
-- ダンジョンマップデータクラスです.
-- エリア、部屋、通路データを保持します.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"

-- class
local DungeonMap = class()

---
-- コンストラクタ
function DungeonMap:init(width, height)
    self.width = width
    self.height = height
    self.areas = {}
    self.rooms = {}
    self.roads = {}
    self.items = {}
    self.objects = {}
end

function DungeonMap:getMapSize()
    return self.width, self.height
end

---
-- エリアを設定します.
function DungeonMap:setAreas(areas)
    self.areas = assert(areas)
end

---
-- 部屋を設定します.
function DungeonMap:setRooms(rooms)
    self.rooms = assert(rooms)
end

---
-- 通路を設定します.
function DungeonMap:setRoads(roads)
    self.roads = assert(roads)
end

---
-- アイテムを設定します.
function DungeonMap:setItems(items)
    self.items = assert(items)
end

---
-- オブジェクトを設定します.
function DungeonMap:setObjects(objects)
    self.objects = assert(objects)
end

return DungeonMap