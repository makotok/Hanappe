--------------------------------------------------------------------------------
-- @type DungeonItem
-- ダンジョンに配置されるアイテムクラスです.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local DungeonRect = require "flower.dungeon.DungeonRect"

-- class
local DungeonItem = class(DungeonRect)

---
-- コンストラクタ
function DungeonItem:init(src, x, y)
    DungeonItem.__super.init(self, x, y, 1, 1)
    self.itemNo = assert(src.id)
    self.iconNo = assert(src.iconNo)
    self.source = src
    table.copy(src, self)
end

return DungeonItem