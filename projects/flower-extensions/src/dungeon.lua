----------------------------------------------------------------------------------------------------
-- ダンジョンを生成する為のライブラリです.
-- ダンジョンとは、以下の要素で構成されます.
--
-- * エリア : ダンジョンの分割エリア.
-- * 部屋 : 分割エリア内の部屋.
-- * 通路 : 部屋と部屋を繋ぐための道.
-- * アイテム : 静的に配置されるアイテムオブジェクト.
-- * オブジェクト : 動的に移動できるオブジェクト.
--
-- 上記の構成要素を特定のアルゴリズムで生成するライブラリを提供します.
----------------------------------------------------------------------------------------------------

-- module
local M = {}

-- import
local flower = require "flower"
local class = flower.class
local table = flower.table
local ClassFactory = flower.ClassFactory
local DrawableObject = flower.DrawableObject

-- classes
local Rectangle
local DungeonMap
local DungeonMapView
local DungeonMapGenerator
local DungeonTiledGenerator
local DungeonArea
local DungeonRoom
local DungeonRoad
local DungeonItem
local DungeonObject

-- initialize
math.randomseed(os.time())

--------------------------------------------------------------------------------
-- @type Rectangle
-- 位置とサイズを持つ二次元空間座標を表現するクラスです.
--------------------------------------------------------------------------------
Rectangle = class()
M.Rectangle = Rectangle

function Rectangle:init(x, y, width, height)
    self.x = x or 0
    self.y = y or 0
    self.width = width or 0
    self.height = height or 0
end

---
-- 指定した位置が空間座標内に含まれる場合にtrueを返します.
-- @param x X座標
-- @param y Y座標
-- @return 位置が空間座標内に含まれる場合はtrue
function Rectangle:contains(x, y)
    return self.x <= x and self.y <= y and x <= (self.x + self.width) and y <= (self.y + self.height)
end

---
-- 指定した位置が空間座標内に含まれる場合にtrueを返します.
-- @param x X座標
-- @param y Y座標
-- @return 位置が空間座標内に含まれる場合はtrue
function Rectangle:containsByRect(rect)
    return self:contains(rect.x, rect.y)
    or self:contains(rect.x + rect.width, rect.y)
    or self:contains(rect.x, rect.y + rect.height)
    or self:contains(rect.x + rect.width, rect.y + rect.height)
    or false
end

--------------------------------------------------------------------------------
-- @type DungeonMap
-- ダンジョンマップデータクラスです.
-- エリア、部屋、通路データを保持します.
--------------------------------------------------------------------------------
DungeonMap = class()
M.DungeonMap = DungeonMap

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

--------------------------------------------------------------------------------
-- @type DungeonMapView
-- ダンジョンマップデータからタイルマップデータを生成するクラスです.
--------------------------------------------------------------------------------
DungeonMapView = class(DrawableObject)
M.DungeonMapView = DungeonMapView

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


--------------------------------------------------------------------------------
-- @type DungeonGenerator
-- ダンジョンを構成するオブジェクトを生成するビルダークラスです.
-- シンプルにエリアを均等に二分割するアルゴリズムでダンジョンマップを生成します.
--------------------------------------------------------------------------------
DungeonMapGenerator = class()
M.DungeonMapGenerator = DungeonMapGenerator

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

    local roadAY = math.random(roomA.y, roomA.y + roomA.height - 1)
    local roadBY = math.random(roomB.y, roomB.y + roomB.height - 1)

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

    local roadAX = math.random(roomA.x, roomA.x + roomA.width - 1)
    local roadBX = math.random(roomB.x, roomB.x + roomB.width - 1)

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

--------------------------------------------------------------------------------
-- @type DungeonTiledGenerator
-- ダンジョンマップデータからタイルマップデータを生成するクラスです.
--------------------------------------------------------------------------------
DungeonTiledGenerator = class()
M.DungeonTiledGenerator = DungeonTiledGenerator

---
-- コンストラクタ.
function DungeonTiledGenerator:init(dungeonMap, params)
    self.dungeonMap = assert(dungeonMap)
    self.mapWidth = assert(self.dungeonMap.width)
    self.mapHeight = assert(self.dungeonMap.height)
    self.tileWidth = assert(params.tileWidth)
    self.tileHeight = assert(params.tileHeight)
    self.backgroundGid = assert(params.backgroundGid)
    self.floorGid = assert(params.floorGid)
    self.wallGid = assert(params.wallGid)
    self.collisionGid = assert(params.collisionGid)
    self.boundGids = assert(params.boundGids)
    self.cornerGids = assert(params.cornerGids)
    self.tilesetMaster = assert(params.tilesetMaster)

    self.lastGid = 0
    self.tilesets = {}
end

function DungeonTiledGenerator:generate()
    self.lastGid = 0
    self.tilesets = self:_createTilesets()

    local layerData = self:_createTileLayerData()
    local collisionData = self:_createCollisionLayerData(layerData)
    local objects = self:_createTileObjects()

    local tileMapData = {
        version = "1.1",
        luaversion = "5.1",
        orientation = "orthogonal",
        width = self.mapWidth,
        height = self.mapHeight,
        tilewidth = self.tileWidth,
        tileheight = self.tileHeight,
        tilesets = self.tilesets,
        layers = {
            {
                type = "tilelayer",
                name = "Layer",
                x = 0,
                y = 0,
                width = self.mapWidth,
                height = self.mapHeight,
                visible = true,
                opacity = 1,
                properties = {},
                encoding = "lua",
                data = layerData,
            },
            {
                type = "tilelayer",
                name = "Collision",
                x = 0,
                y = 0,
                width = self.mapWidth,
                height = self.mapHeight,
                visible = true,
                opacity = 1,
                properties = {},
                encoding = "lua",
                data = collisionData,
            },
            {
                type = "objectgroup",
                name = "Object",
                visible = true,
                opacity = 1,
                properties = {},
                objects = objects,
            },
        }
    }

    return tileMapData
end

function DungeonTiledGenerator:_createTilesets()
    local tilesets = {}

    for i, master in ipairs(self.tilesetMaster) do
        tilesets[i] = self:_createTileset(master.name, master.image, master.tileWidth, master.tileHeight)
    end

    return tilesets
end

function DungeonTiledGenerator:_createTileset(name, imagePath, tileWidth, tileHeight)
    local firstGid = self.lastGid + 1
    local texture = flower.getTexture(imagePath)
    local textureW, textureH = texture:getSize()
    tileWidth = tileWidth or self.tileWidth
    tileHeight = tileHeight or self.tileHeight
    
    self.lastGid = self.lastGid + math.floor(textureW / tileWidth * textureH / tileHeight)

    return {
        name = name,
        firstgid = firstGid,
        tilewidth = tileWidth,
        tileheight = tileHeight,
        spacing = 0,
        margin = 0,
        image = imagePath,
        imagewidth = textureW,
        imageheight = textureH,
        properties = {},
        tiles = {}
    }
end

function DungeonTiledGenerator:_createTileLayerData()
    local data = {}
    self:_clearData(data, self.backgroundGid)
    self:_drawRooms(data)
    self:_drawRoads(data)
    self:_drawBounds(data)
    self:_drawCorners(data)

    return data
end

function DungeonTiledGenerator:_createCollisionLayerData(layerData)
    local data = {}
    self:_clearData(data, 0)
    self:_drawCollision(data, layerData)

    return data
end

---
-- タイルマップに配置するオブジェクトを生成します.
function DungeonTiledGenerator:_createTileObjects()
    local objects = {}

    for i, item in ipairs(self.dungeonMap.items) do
        table.insertElement(objects, self:_createTileItem(item))
    end
    for i, object in ipairs(self.dungeonMap.objects) do
        table.insertElement(objects, self:_createTileObject(object))
    end

    return objects
end

function DungeonTiledGenerator:_createTileItem(item)
    local firstGid = 769

    return {
        name = "",
        type = "Item",
        shape = "rectangle",
        x = item.x * self.tileWidth,
        y = item.y * self.tileHeight,
        width = 0,
        height = 0,
        gid = firstGid + item.itemNo,
        visible = true,
        properties = {dungeonItem = item},
    }
end

function DungeonTiledGenerator:_createTileObject(object)
    local tileset = self:_findTilesetByName(object.tileset)
    local firstGid = tileset.firstgid

    return {
        name = object.objectName,
        type = object.objectType,
        shape = "rectangle",
        x = object.x * self.tileWidth,
        y = object.y * self.tileHeight,
        width = 0,
        height = 0,
        gid = firstGid,
        visible = true,
        properties = {dungeonObject = object},
    }

end

function DungeonTiledGenerator:_findTilesetByName(name)
    for i, tileset in ipairs(self.tilesets) do
        if tileset.name == name then
            return tileset
        end
    end
end

function DungeonTiledGenerator:_clearData(data, gid)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            table.insertElement(data, gid)
        end
    end
end

function DungeonTiledGenerator:_drawCollision(data, tileLayerData)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            if self:_isCollision(tileLayerData, x, y) then
                self:_drawTile(data, x, y, self.collisionGid)
            end
        end
    end
end

function DungeonTiledGenerator:_drawRooms(data)
    for i, room in ipairs(self.dungeonMap.rooms) do
        self:_drawRoom(data, room)
    end
end

function DungeonTiledGenerator:_drawRoom(data, room)
    for y = room.y, room.y + room.height - 1 do
        for x = room.x, room.x + room.width - 1 do
            if y == room.y then
                self:_drawTile(data, x, y, self.wallGid)
            else
                self:_drawTile(data, x, y, self.floorGid)
            end
        end
    end
end

function DungeonTiledGenerator:_drawRoads(data)
    for i, road in ipairs(self.dungeonMap.roads) do
        self:_drawRoad(data, road)
    end
end

function DungeonTiledGenerator:_drawRoad(data, road)
    for i = 1, #road.points - 2, 2 do
        local x1 = math.min(road.points[i + 0], road.points[i + 2])
        local y1 = math.min(road.points[i + 1], road.points[i + 3])
        local x2 = math.max(road.points[i + 0], road.points[i + 2])
        local y2 = math.max(road.points[i + 1], road.points[i + 3])

        for y = y1, y2 do
            for x = x1, x2 do
                local gid1 = self:_getGid(data, x, y - 1)
                if gid1 > 0 and gid1 == self.backgroundGid then
                    self:_drawTile(data, x, y - 1, self.wallGid)
                end
                self:_drawTile(data, x, y, self.floorGid)
            end
        end
    end
end

function DungeonTiledGenerator:_drawBounds(data)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            self:_drawBoundGid(data, x, y)
        end
    end
end

function DungeonTiledGenerator:_drawBoundGid(data, x, y)
    local bgid = self.backgroundGid
    local fgid = self.floorGid
    local wgid = self.wallGid
    local boundsGids = self.boundGids
    local x1y0 = self:_getGid(data, x - 0, y - 1)
    local x0y1 = self:_getGid(data, x - 1, y - 0)
    local x1y1 = self:_getGid(data, x - 0, y - 0)
    local x2y1 = self:_getGid(data, x + 1, y - 0)
    local x1y2 = self:_getGid(data, x - 0, y + 1)

    -- exclude condition
    if x1y1 ~= bgid then
        return
    end
    -- top-left
    if x0y1 == fgid and x1y0 == fgid and x2y1 ~= fgid and x1y2 ~= fgid then
        self:_drawTile(data, x, y, boundsGids[1])
    end
    -- top-center
    if x0y1 ~= fgid and x1y0 == fgid and x2y1 ~= fgid and x1y2 ~= fgid then
        self:_drawTile(data, x, y, boundsGids[2])
    end
    -- top-right
    if x0y1 ~= fgid and x1y0 == fgid and x2y1 == fgid and x1y2 ~= fgid then
        self:_drawTile(data, x, y, boundsGids[3])
    end
    -- center-left
    if (x0y1 == fgid or x0y1 == wgid) and x1y0 ~= fgid and x2y1 ~= fgid and x1y2 ~= fgid then
        self:_drawTile(data, x, y, boundsGids[4])
    end
    -- center-right
    if x0y1 ~= fgid and x1y0 ~= fgid and (x2y1 == fgid or x2y1 == wgid) and x1y2 ~= fgid then
        self:_drawTile(data, x, y, boundsGids[6])
    end
    -- bottom-left
    if x0y1 == fgid and x1y0 ~= fgid and x2y1 ~= fgid and x1y2 == wgid then
        self:_drawTile(data, x, y, boundsGids[7])
    end
    -- bottom-center
    if x0y1 ~= fgid and x1y0 ~= fgid and x2y1 ~= fgid and x1y2 == wgid then
        self:_drawTile(data, x, y, boundsGids[8])
    end
    -- bottom-right
    if x0y1 ~= fgid and x1y0 ~= fgid and x2y1 == fgid and x1y2 == wgid then
        self:_drawTile(data, x, y, boundsGids[9])
    end
end

function DungeonTiledGenerator:_drawCorners(data)
    for y = 1, self.mapHeight do
        for x = 1, self.mapWidth do
            self:_drawCornerGid(data, x, y)
        end
    end
end

function DungeonTiledGenerator:_drawCornerGid(data, x, y)
    local bgid = self.backgroundGid
    local cornerGids = self.cornerGids
    local boundGids = self.boundGids
    local x1y0 = self:_getGid(data, x - 0, y - 1)
    local x0y1 = self:_getGid(data, x - 1, y - 0)
    local x1y1 = self:_getGid(data, x - 0, y - 0)
    local x2y1 = self:_getGid(data, x + 1, y - 0)
    local x1y2 = self:_getGid(data, x - 0, y + 1)

    -- exclude condition
    if x1y1 ~= bgid then
        return
    end
    -- top-left
    if (x1y0 == boundGids[4] or x1y0 == boundGids[1]) and (x0y1 == boundGids[2] or x0y1 == boundGids[1]) then
        self:_drawTile(data, x, y, cornerGids[1])
    end
    -- top-right
    if (x1y0 == boundGids[6] or x1y0 == boundGids[3]) and (x2y1 == boundGids[2] or x2y1 == boundGids[3]) then
        self:_drawTile(data, x, y, cornerGids[2])
    end
    -- bottom-left
    if (x1y2 == boundGids[4] or x1y2 == boundGids[7]) and (x0y1 == boundGids[8] or x0y1 == boundGids[7]) then
        self:_drawTile(data, x, y, cornerGids[3])
    end
    -- bottom-right
    if (x1y2 == boundGids[6] or x1y2 == boundGids[9]) and (x2y1 == boundGids[8] or x2y1 == boundGids[9]) then
        self:_drawTile(data, x, y, cornerGids[4])
    end
end

function DungeonTiledGenerator:_drawTile(data, x, y, gid)
    data[(y - 1) * self.mapWidth + x] = gid
end

function DungeonTiledGenerator:_getGid(data, x, y)
    if x <= 0 or self.mapWidth < x or y <= 0 or self.mapHeight < y then
        return 0
    end
    return data[(y - 1) * self.mapWidth + x]
end

function DungeonTiledGenerator:_isCollision(data, x, y)
    local gid = self:_getGid(data, x, y)
    return gid ~= self.floorGid
end

--------------------------------------------------------------------------------
-- @type DungeonArea
-- ダンジョン内の分割エリアクラスです.
-- 部屋を生成するためのエリアを定義します.
--------------------------------------------------------------------------------
DungeonArea = class(Rectangle)
M.DungeonArea = DungeonArea

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

--------------------------------------------------------------------------------
-- @type DungeonRoom
-- ダンジョンの部屋クラスです.
-- 部屋の位置・大きさを保持します.
--------------------------------------------------------------------------------
DungeonRoom = class(Rectangle)
M.DungeonRoom = DungeonRoom

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

--------------------------------------------------------------------------------
-- @type DungeonRoad
-- ダンジョンの通路クラスです.
-- 通路の点の繋がりを保持します.
--------------------------------------------------------------------------------
DungeonRoad = class()
M.DungeonRoad = DungeonRoad

---
-- コンストラクタ
function DungeonRoad:init(points)
    self.points = assert(points)
end

--------------------------------------------------------------------------------
-- @type DungeonItem
-- ダンジョンに配置されるアイテムクラスです.
--------------------------------------------------------------------------------
DungeonItem = class(Rectangle)
M.DungeonItem = DungeonItem

---
-- コンストラクタ
function DungeonItem:init(src, x, y)
    DungeonItem.__super.init(self, x, y, 1, 1)
    self.itemNo = assert(src.itemNo)
    table.copy(src, self)
end

--------------------------------------------------------------------------------
-- @type DungeonObject
-- ダンジョンに配置される動的オブジェクトクラスです.
--------------------------------------------------------------------------------
DungeonObject = class(Rectangle)
M.DungeonObject = DungeonObject

---
-- コンストラクタ
function DungeonObject:init(src, x, y)
    DungeonObject.__super.init(self, x, y, 1, 1)
    self.objectNo = assert(src.objectNo)
    self.objectType = assert(src.objectType)
    self.width = assert(src.width)
    self.height = assert(src.height)
    table.copy(src, self)
end

return M