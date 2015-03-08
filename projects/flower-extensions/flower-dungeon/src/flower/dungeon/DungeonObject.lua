--------------------------------------------------------------------------------
-- @type DungeonObject
-- ダンジョンに配置される動的オブジェクトクラスです.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local DungeonRect = require "flower.dungeon.DungeonRect"

-- class
local DungeonObject = class(DungeonRect)

---
-- コンストラクタ
function DungeonObject:init(src, x, y)
    DungeonObject.__super.init(self, x, y, 1, 1)
    self.objectNo = assert(src.objectNo)
    self.objectType = assert(src.objectType)
    self.width = assert(src.width)
    self.height = assert(src.height)
    self.source = src
    table.copy(src, self)
end

return DungeonObject