----------------------------------------------------------------------------------------------------
-- This class is the renderer to draw Isometric view.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.core.Group.html">Group</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Group = require "flower.core.Group"
local SheetImage = require "flower.core.SheetImage"

-- class
local IsometricLayerRenderer = class(Group)

---
-- Constructor.
-- @param tileLayer Renderable tileLayer
function IsometricLayerRenderer:init(tileLayer)
    Group.init(self)
    self.tileLayer = assert(tileLayer)
    self.tileMap = tileLayer.tileMap
    self.renderers = {}

    self:createRenderers()
end

---
-- Create the tileset renderers.
function IsometricLayerRenderer:createRenderers()
    local tileMap = self.tileMap

    for y = 0, tileMap.mapHeight - 1 do
        for x = 0, tileMap.mapWidth - 1 do
            local gid = self.tileLayer:getGid(x, y)
            self:createRenderer(x, y, gid)
        end
    end
end

---
-- Create the tile renderer.
-- @param x x position
-- @param y y position
-- @param gid gid
-- @return renderer
function IsometricLayerRenderer:createRenderer(x, y, gid)
    if gid == 0 then
        return
    end

    local tileMap = self.tileMap
    local tileset = tileMap:findTilesetByGid(gid)
    local tileNo = tileset:getTileIndexByGid(gid)
    local texture = tileset:loadTexture(MOAITexture.GL_NEAREST)

    local tileLayer = self.tileLayer
    local mapWidth, mapHeight = tileLayer.mapWidth, tileLayer.mapHeight
    local tileWidth, tileHeight = tileset.tileWidth, tileset.tileHeight
    local spacing, margin = tileset.spacing, tileset.margin

    -- TODO:Flip, rotation not implemented.
    local renderer = SheetImage(texture)
    renderer:setPriority(self:getPriority())
    renderer:setIndex(tileNo)
    renderer:setTileSize(tileWidth, tileHeight, spacing, margin)

    local posX = x * (tileMap.tileWidth / 2) - y * (tileMap.tileWidth / 2)
    local posY = x * (tileMap.tileHeight / 2) + y * (tileMap.tileHeight / 2)
    posX = posX + tileset.tileOffsetX
    posY = posY + tileset.tileOffsetY + tileMap.tileHeight - tileHeight
    renderer:setPos(posX, posY)

    self:addChild(renderer)
    self.renderers[y * mapWidth + x + 1] = renderer
    
    return renderer
end

---
-- Sets gid of the specified position.
-- If you set the position is out of range to error.
-- @param x potision of x (0 ... mapWidth - 1)
-- @param y potision of y (0 ... mapHeight - 1)
-- @param gid global id.
function IsometricLayerRenderer:setGid(x, y, gid)
    local renderer = self:getRenderer(x, y)
    if renderer then
        self:removeChild(renderer)
        self.renderers[y * self.tileLayer.mapWidth + x + 1] = nil
    end

    self:createRenderer(x, y, gid)
end

---
-- Returns the renderer for the position.
-- @param x x position
-- @param y y position
-- @return renderer
function IsometricLayerRenderer:getRenderer(x, y)
    return self.renderers[y * self.tileLayer.mapWidth + x + 1]
end

return IsometricLayerRenderer