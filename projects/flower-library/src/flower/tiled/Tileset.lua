----------------------------------------------------------------------------------------------------
-- This class holds information about the tile set.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Resources = require "flower.core.Resources"
local TileFlag = require "flower.tiled.TileFlag"

-- class
local Tileset = class()

---
-- The constructor.
-- @param tileMap TileMap
function Tileset:init(tileMap)
    self.tileMap = assert(tileMap)
    self.name = ""
    self.firstgid = 0
    self.tileWidth = 0
    self.tileHeight = 0
    self.tileOffsetX = 0
    self.tileOffsetY = 0
    self.spacing = 0
    self.margin = 0
    self.image = ""
    self.imageWidth = 0
    self.imageHeight = 0
    self.tiles = {}
    self.properties = {}
end

---
-- Load the tileset data.
-- @param data tileset data
function Tileset:loadData(data)
    self.name = data.name
    self.firstgid = data.firstgid
    self.tileWidth = data.tilewidth
    self.tileHeight = data.tileheight
    self.tileOffsetX = data.tileoffsetx or 0 -- TODO: Dummy. Tile Map Editor Bug?
    self.tileOffsetY = data.tileoffsety or 0 -- TODO: Dummy. Tile Map Editor Bug?
    self.spacing = data.spacing
    self.margin = data.margin
    self.image = data.image
    self.imageWidth = data.imagewidth
    self.imageHeight = data.imageheight
    self.tiles = data.tiles
    self.properties = data.properties

    self.tileSizeX = math.floor(self.imageWidth / self.tileWidth)
    self.tileSizeY = math.floor(self.imageHeight / self.tileHeight)
    self.tileSize = self.tileSizeX * self.tileSizeY
end

---
-- Save the tileset data.
-- @return tileset data
function Tileset:saveData()
    local data = self.data or {}
    self.data = data
    data.name = self.name
    data.firstgid = self.firstgid
    data.tilewidth = self.tileWidth
    data.tileheight = self.tileHeight
    data.tileoffsetx = self.tileOffsetX
    data.tileoffsety = self.tileOffsetY
    data.spacing = self.spacing
    data.margin = self.margin
    data.image = self.image
    data.imagewidth = self.imageWidth
    data.imageheight = self.imageHeight
    data.tiles = self.tiles
    data.properties = self.properties
    return data
end

---
-- Load the texture of the tile set that is specified.
-- @param filter texture filter
-- @return texture
function Tileset:loadTexture(filter)
    local path = self.tileMap.resourceDirectory .. self.image
    local texture = Resources.getTexture(path, filter)
    return texture
end

---
-- Returns the tile index of the specified gid.
-- @param gid gid.
-- @return If has gid return true.
function Tileset:hasTile(gid)
    gid = TileFlag.clearFlags(gid)
    return self.firstgid <= gid and gid < self.firstgid + self.tileSize
end

---
-- Returns the tile index of the specified gid.
-- @param gid gid.
-- @return tile index.
function Tileset:getTileIndexByGid(gid)
    gid = TileFlag.clearFlags(gid)
    return self:hasTile(gid) and gid - self.firstgid + 1 or 0
end

---
-- Returns the tile id of the specified gid.
-- @param gid gid.
-- @return tile id.
function Tileset:getTileIdByGid(gid)
    gid = TileFlag.clearFlags(gid)
    return self:hasTile(gid) and gid - self.firstgid or -1
end

---
-- Returns the size of the tile.
-- @return tile size.
function Tileset:getTileSize()
    return self.tileSize
end

---
-- Returns the tile of the specified id.(0 <= id <= max)
-- @param id tile id (0 <= id <= max)
-- @return tile
function Tileset:getTileById(id)
    for i, tile in ipairs(self.tiles) do
        if tile.id == id then
            return tile
        end
    end
end

---
-- Returns the tile property of the specified id.(0 <= id <= tileid max)
-- @param id tile id (0 <= id <= tileid max)
-- @return tile
function Tileset:getTileProperties(id)
    local tile = self:getTileById(id)
    if tile then
        return tile.properties
    end
end

---
-- Returns the tile property of the specified id.(0 <= id <= tileid max)
-- @param id tile id (0 <= id <= tileid max)
-- @param key key of the properties
-- @return property value
function Tileset:getTileProperty(id, key)
    local tile = self:getTileById(id)
    if tile and tile.properties then
        return tile.properties[key]
    end
end

return Tileset