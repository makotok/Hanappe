--------------------------------------------------------------------------------
-- ダンジョンの通路クラスです.
-- 通路の点の繋がりを保持します.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"

-- class
local DungeonRoad = class()

---
-- コンストラクタ
function DungeonRoad:init(points)
    self.points = assert(points)
end

return DungeonRoad