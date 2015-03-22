----------------------------------------------------------------------------------------------------
-- Renderer class is used to draw a tile layer.
-- Generated through the TileLayerRendererFactory.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.Group.html">Group</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Group = require "flower.Group"
local BitUtils = require "flower.BitUtils"
local TileMapImage = require "flower.tiled.TileMapImage"
local TileFlag = require "flower.tiled.TileFlag"

-- class
local TileLayerRenderer = class(Group)

---
-- Constructor.
-- @param tileLayer Renderable tileLayer
function TileLayerRenderer:init(tileLayer)
    TileLayerRenderer.__super.init(self)
    self.tileLayer = assert(tileLayer)
    self.tileMap = tileLayer.tileMap
    self.tilesetToRendererMap = {}

    self:createRenderers()
end

---
-- Create the tileset renderers.
function TileLayerRenderer:createRenderers()
    local tilesets = self:getRenderableTilesets()

    for key, tileset in pairs(tilesets) do
        self:createRenderer(tileset)
    end
end

---
-- Create the tileset renderer.
-- @param tileset tileset
-- @return tileset renderer
function TileLayerRenderer:createRenderer(tileset)
    if self.tilesetToRendererMap[tileset] then
        return
    end
    
    local texture = tileset:loadTexture(MOAITexture.GL_NEAREST)
    local tw, th = texture:getSize()

    local tileLayer = self.tileLayer
    local mapWidth, mapHeight = tileLayer.mapWidth, tileLayer.mapHeight
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    local renderer = TileMapImage(texture, mapWidth, mapHeight, tileWidth, tileHeight, spacing, margin)
    renderer:setPriority(self:getPriority())
    renderer.tileset = tileset
    self.tilesetToRendererMap[tileset] = renderer

    local tileSize = renderer.sheetSize
    local tiles = tileLayer.tiles

    for y = 0, mapHeight - 1 do
        local rowData = {}
        for x = 0, mapWidth - 1 do
            local gid = tileLayer:getGid(x, y)
            if gid > 0 then
                local tileNo = self:gidToTileNo(tileset, gid)
                table.insertElement(rowData, tileNo)
            else
                table.insertElement(rowData, 0)
            end
        end
        renderer:setRow(y + 1, unpack(rowData))
    end
    
    self:addChild(renderer)
    return renderer
end

---
-- Convert to tile value to draw the layer.
-- Use tile flag.
-- @param tileset tileset
-- @param gid gid
-- @return tileNo
function TileLayerRenderer:gidToTileNo(tileset, gid)
    local tileNo = tileset:getTileIndexByGid(gid)
    local tileSize = tileset:getTileSize()

    if tileNo == 0 then
        return tileNo
    end
    
    local flipH = BitUtils.hasbit(gid, TileFlag.FLIPPED_HORIZONTALLY_FLAG)
    local flipV = BitUtils.hasbit(gid, TileFlag.FLIPPED_VERTICALLY_FLAG)
    local flipD = BitUtils.hasbit(gid, TileFlag.FLIPPED_DIAGONALLY_FLAG)
    
    tileNo = flipH and tileNo + MOAIGridSpace.TILE_X_FLIP or tileNo
    tileNo = flipV and tileNo + MOAIGridSpace.TILE_Y_FLIP or tileNo
    tileNo = flipD and tileNo + tileSize or tileNo
    
    return tileNo
end

---
-- Remove the tileset renderer.
-- @param renderer renderer
function TileLayerRenderer:removeRenderer(renderer)
    if self.tilesetToRendererMap[renderer.tileset] then
        self:removeChild(renderer)
        self.tilesetToRendererMap[renderer.tileset] = nil
    end
end

---
-- Returns the renderable tilesets.
-- @return renderable tilesets
function TileLayerRenderer:getRenderableTilesets()
    local tileLayer = self.tileLayer
    local tileMap = tileLayer.tileMap
    local tilesets = {}
    for i, gid in ipairs(tileLayer.tiles) do
        local tileset = tileMap:findTilesetByGid(gid)
        if tileset and not tilesets[tileset.name] then
            tilesets[tileset.name] = tileset
        end
    end
    return tilesets
end

---
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
-- @param gid global id.
function TileLayerRenderer:setGid(x, y, gid)
    self:clearGid(x, y)
    
    if gid == 0 then
        return
    end
    
    local tileset = self.tileMap:findTilesetByGid(gid)
    local tileNo = self:gidToTileNo(tileset, gid)
    local renderer = self:getRendererByTileset(tileset) or self:createRenderer(tileset)
    renderer:setTile(x + 1, y + 1, tileNo)
end

---
-- Clear gid of the specified position.
-- @param x potision of x (0 <= x && x <= mapWidth)
-- @param y potision of y (0 <= y && y <= mapHeight)
function TileLayerRenderer:clearGid(x, y)
    for key, value in pairs(self.tilesetToRendererMap) do
        value:setTile(x + 1, y + 1, 0)
    end
end

---
-- Returns the renderer for the tileset.
-- @param tileset tileset
-- @return renderer
function TileLayerRenderer:getRendererByTileset(tileset)
    return self.tilesetToRendererMap[tileset]
end

return TileLayerRenderer
