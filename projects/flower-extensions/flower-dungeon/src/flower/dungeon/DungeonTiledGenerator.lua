--------------------------------------------------------------------------------
-- @type DungeonTiledGenerator
-- ダンジョンマップデータからタイルマップデータを生成するクラスです.
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"

-- class
local DungeonTiledGenerator = class()

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
        gid = firstGid + item.iconNo,
        visible = true,
        properties = item.source,
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
        properties = object.source,
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

return DungeonTiledGenerator