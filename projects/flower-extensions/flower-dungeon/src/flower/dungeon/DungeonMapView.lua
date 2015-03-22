--------------------------------------------------------------------------------
-- ダンジョンマップデータからタイルマップデータを生成するクラスです.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local DrawableObject = require "flower.DrawableObject"

-- class
local DungeonMapView = class(DrawableObject)

---
-- Constructor.
function DungeonMapView:init(dungeonMap)
    DungeonMapView.__super.init(self, dungeonMap.width, dungeonMap.height)
    self.dungeonMap = dungeonMap
    self.roomColor = MOAIColor.new()
    self.roadColor = MOAIColor.new()

    self.roomColor:setParent(self)
    self.roadColor:setParent(self)
    self.roomColor:setColor(0.5, 0.5, 0.5, 1)
    self.roadColor:setColor(0.5, 0.5, 0.5, 1)
end

function DungeonMapView:onDraw(index, xOff, yOff, xFlip, yFlip)
    self:_drawRooms()
    self:_drawRoads()
end

function DungeonMapView:_drawRooms()
    MOAIGfxDevice.setPenColor(self.roomColor:getColor())
    for i, room in ipairs(self.dungeonMap.rooms) do
        MOAIDraw.fillRect(room.x, room.y, room.x + room.width, room.y + room.height)
    end
end

function DungeonMapView:_drawRoads()
    MOAIGfxDevice.setPenColor(self.roadColor:getColor())
    MOAIGfxDevice.setPenWidth(1)
    for i, road in ipairs(self.dungeonMap.roads) do
        MOAIDraw.drawLine(unpack(road.points))
    end
end

return DungeonMapView