--------------------------------------------------------------------------------
-- @type DungeonGenerator
-- ダンジョンを構成するオブジェクトを生成するビルダークラスです.
-- シンプルにエリアを均等に二分割するアルゴリズムでダンジョンマップを生成します.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local DungeonMap = require "flower.dungeon.DungeonMap"
local DungeonArea = require "flower.dungeon.DungeonArea"
local DungeonRoom = require "flower.dungeon.DungeonRoom"
local DungeonRoad = require "flower.dungeon.DungeonRoad"
local DungeonItem = require "flower.dungeon.DungeonItem"
local DungeonObject = require "flower.dungeon.DungeonObject"

-- class
local DungeonMapGenerator = class()

---
-- コンストラクタ.
-- @param params 動作パラメータ.任意の引数をとる事ができる.
function DungeonMapGenerator:init(params)
    self.width = params.mapWidth or 100
    self.height = params.mapHeight or 100
    self.areaSizeX = params.areaSizeX or 3
    self.areaSizeY = params.areaSizeY or 3
    self.roomPadding = params.roomPadding or 10
    self.playerId = 1
    self.itemMaster = assert(params.itemMaster)
    self.objectMaster = assert(params.objectMaster)

end

---
-- ダンジョンマップを生成します.
-- ダンジョンを生成するデータは事前に設定済である前提とします.
-- @return ダンジョンマップ
function DungeonMapGenerator:generate()
    local map = DungeonMap(self.width, self.height)
    self:_createAreas(map)
    self:_createRooms(map)
    self:_createRoads(map)
    self:_createItems(map)
    self:_createObjects(map)
    return map
end

function DungeonMapGenerator:_createAreas(map)
    local areas = {}
    local areaW = math.floor(self.width / self.areaSizeY)
    local areaH = math.floor(self.height / self.areaSizeX)

    for y = 1, self.areaSizeY do
        for x = 1, self.areaSizeX do
            local area = DungeonArea((x - 1) * areaW, (y - 1) * areaH, areaW, areaH)
            table.insert(areas, area)
        end
    end

    map:setAreas(areas)
end

function DungeonMapGenerator:_createRooms(map)
    local areas = map.areas
    local rooms = {}
    local padding = 3

    for i, area in ipairs(areas) do
        local roomW = math.random(math.floor(area.width / 3), area.width - padding * 2)
        local roomH = math.random(math.floor(area.height / 3), area.height - padding * 2)
        local roomX = area.x + math.random(padding, area.width - roomW - padding)
        local roomY = area.y + math.random(padding, area.height - roomH - padding)

        local room = area:createRoom(roomX, roomY, roomW, roomH)
        table.insert(rooms, room)
    end

    map:setRooms(rooms)
end

function DungeonMapGenerator:_createRoads(map)
    local roads = {}
    local areas = map.areas

    -- create horizontal roads
    for y = 1, self.areaSizeY do
        for x = 1, self.areaSizeX - 1 do
            local leftArea = areas[(y - 1) * self.areaSizeY + x]
            local rightArea = areas[(y - 1) * self.areaSizeY + x + 1]
            local road = self:_createHorizontalRoad(leftArea, rightArea)
            table.insert(roads, road)
        end
    end

    -- create vertical roads
    for y = 1, self.areaSizeY - 1 do
        for x = 1, self.areaSizeX do
            local topArea = areas[(y - 1) * self.areaSizeY + x]
            local bottomArea = areas[(y) * self.areaSizeY + x]
            local road = self:_createVerticalRoad(topArea, bottomArea)
            table.insert(roads, road)
        end
    end

    map:setRoads(roads)
end

function DungeonMapGenerator:_createHorizontalRoad(areaA, areaB)
    local roomA = areaA.room
    local roomB = areaB.room

    local roadAY = math.random(roomA.y + 1, roomA.y + roomA.height - 1)
    local roadBY = math.random(roomB.y + 1, roomB.y + roomB.height - 1)

    local road = DungeonRoad {
        roomA.x + roomA.width, roadAY,
        areaA.x + areaA.width, roadAY,
        areaA.x + areaA.width, roadBY,
        roomB.x, roadBY,
    }

    roomA:addRoad(road)
    roomB:addRoad(road)

    return road
end

function DungeonMapGenerator:_createVerticalRoad(areaA, areaB)
    local roomA = areaA.room
    local roomB = areaB.room

    local roadAX = math.random(roomA.x + 1, roomA.x + roomA.width - 1)
    local roadBX = math.random(roomB.x + 1, roomB.x + roomB.width - 1)

    local road = DungeonRoad {
        roadAX, roomA.y + roomA.height,
        roadAX, areaA.y + areaA.height,
        roadBX, areaA.y + areaA.height,
        roadBX, roomB.y,
    }

    roomA:addRoad(road)
    roomB:addRoad(road)

    return road
end

function DungeonMapGenerator:_createItems(map)
    local items = {}

    for i, room in ipairs(map.rooms) do
        local size = math.random(0, 3)

        if size > 0 then
            for i = 1, size do
                local item = self:_createItem(room)
                table.insertElement(items, item)
            end
        end
    end

    map:setItems(items)
end

function DungeonMapGenerator:_createItem(room)
    local x = math.random(room.x + 1, room.x + room.width - 1)
    local y = math.random(room.y + 1, room.y + room.height - 1)
    local src = self.itemMaster[math.random(1, #self.itemMaster)]

    return DungeonItem(src, x, y)
end

function DungeonMapGenerator:_createObjects(map)
    local objects = {}

    local room = map.rooms[math.random(1, #map.rooms)]
    local playerSrc = self.objectMaster[self.playerId]
    local playerObj = self:_createObject(playerSrc, room)
    table.insertElement(objects, playerObj)

    for i, room in ipairs(map.rooms) do
        local size = math.random(0, 3)

        if size > 0 then
            for i = 1, size do
                local src = self.objectMaster[math.random(1, #self.objectMaster)]
                local obj = self:_createObject(src, room)
                table.insertElement(objects, obj)
            end
        end
    end

    map:setObjects(objects)
end

function DungeonMapGenerator:_createObject(src, room)
    local x = math.random(room.x + 1, room.x + room.width - 1)
    local y = math.random(room.y + 1, room.y + room.height - 1)

    return DungeonObject(src, x, y)
end

return DungeonMapGenerator