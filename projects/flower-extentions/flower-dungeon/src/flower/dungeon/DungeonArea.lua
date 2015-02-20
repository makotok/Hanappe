--------------------------------------------------------------------------------
-- @type DungeonArea
-- ダンジョン内の分割エリアクラスです.
-- 部屋を生成するためのエリアを定義します.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local DungeonRect = require "flower.dungeon.DungeonRect"
local DungeonRoom = require "flower.dungeon.DungeonRoom"

-- class
local DungeonArea = class(DungeonRect)

function DungeonArea:init(x, y, width, height)
    DungeonArea.__super.init(self, x, y, width, height)
    self.room = nil
end

function DungeonArea:split(verticalFlag)
    if verticalFlag then
        local newHeight = math.floor(self.height / 2)
        self.height = self.height - newHeight
        return self.__class(self.x, self.y + self.height, self.width, newHeight)
    else
        local newWidth = math.floor(self.width / 2)
        self.width = self.width - newWidth
        return self.__class(self.x + self.width, self.y, newWidth, self.height)
    end
end

function DungeonArea:createRoom(x, y, width, height)
    if self.room then
        return self.room
    end

    assert(self.x < x and x + width < self.x + self.width)
    assert(self.y < y and y + height < self.y + self.height)

    self.room = DungeonRoom(self, x, y, width, height)
    return self.room
end

return DungeonArea