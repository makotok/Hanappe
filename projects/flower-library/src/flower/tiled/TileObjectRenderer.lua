----------------------------------------------------------------------------------------------------
-- This class is the renderer to draw TileObject.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.core.MovieClip.html">MovieClip</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local MovieClip = require "flower.core.MovieClip"

-- class
local TileObjectRenderer = class(MovieClip)

---
-- Constructor.
-- @param tileObject TileObject
function TileObjectRenderer:init(tileObject)
    local tileMap = tileObject.tileMap
    local tileset = tileMap:findTilesetByGid(tileObject.gid)
    local texture = tileset:loadTexture()
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    TileObjectRenderer.__super.init(self, texture)

    self.tileMap = tileMap
    self.tileObject = tileObject
    self.tileset = tileset
    self.gid = tileObject.gid
    self:setTileSize(tileWidth, tileHeight, spacing, margin)
    self:setIndex(tileset:getTileIndexByGid(self.gid))
    self:setPos(0, -self:getHeight())
    self:setPriority(self:getPriority())
end

---
-- Set the gid.
-- Draw a tile corresponding to the gid.
-- @param gid gid
function TileObjectRenderer:setGid(gid)
    if self.gid == gid then
        return
    end

    local tileset = self.tileMap:findTilesetByGid(gid)
    if tileset ~= self.tileset then
        local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
        local spacing, margin = tileset.spacing, tileset.margin
        self.tileset = tileset
        self:setTexture(tileset:loadTexture())
        self:setTileSize(tileWidth, tileHeight, spacing, margin)
    end

    self.gid = gid
    self:setIndex(tileset:getTileIndexByGid(gid))
end

---
-- Returns the gid.
-- @return gid
function TileObjectRenderer:getGid()
    return self.gid
end

return TileObjectRenderer