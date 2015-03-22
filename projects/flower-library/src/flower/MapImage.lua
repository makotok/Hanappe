----------------------------------------------------------------------------------------------------
-- Class that loads a tiled map of images (see MOAIGrid).
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.SheetImage.html">SheetImage</a><l/i>
-- </ul>
--
-- <h4>See:</h4>
-- <ul>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_grid.html">MOAIGrid</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Resources = require "flower.Resources"
local SheetImage = require "flower.SheetImage"

-- class
local MapImage = class(SheetImage)

---
-- Constructor.
-- @param texture Texture path, or texture
-- @param gridWidth (option) The size of the grid
-- @param gridHeight (option) The size of the grid
-- @param tileWidth (option) The size of the tile
-- @param tileHeight (option) The size of the tile
-- @param spacing (option) The spacing of the tile
-- @param margin (option) The margin of the tile
function MapImage:init(texture, gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    MapImage.__super.init(self, texture)

    self.grid = MOAIGrid.new()
    self:setGrid(self.grid)

    if gridWidth and gridHeight and tileWidth and tileHeight then
        self:setMapSize(gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    end
end

---
-- Sets the size of the map grid.
-- @param gridWidth The size of the grid
-- @param gridHeight The size of the grid
-- @param tileWidth The size of the tile
-- @param tileHeight The size of the tile
-- @param spacing (option) The spacing of the tile
-- @param margin (option) The margin of the tile
function MapImage:setMapSize(gridWidth, gridHeight, tileWidth, tileHeight, spacing, margin)
    self.grid:setSize(gridWidth, gridHeight, tileWidth, tileHeight)
    self:setTileSize(tileWidth, tileHeight, spacing, margin)
end

---
-- Sets the map data by rows.
-- @param rows Multiple rows of data.
function MapImage:setRows(rows)
    for i, row in ipairs(rows) do
        self:setRow(i, unpack(row))
    end
end

---
-- Sets the map row data.
-- @param ... rows of data.
function MapImage:setRow(...)
    self.grid:setRow(...)
end

---
-- Sets the map value.
-- @param x x position of the grid
-- @param y y position of the grid
-- @param value tile value.
function MapImage:setTile(x, y, value)
    self.grid:setTile(x, y, value)
end

---
-- Returns the map value.
-- @param x x position of the grid
-- @param y y position of the grid
-- @return tile value.
function MapImage:getTile(x, y)
    return self.grid:getTile(x, y)
end

---
-- Sets the repeat flag.
-- @param repeatX
-- @param repeatY
function MapImage:setRepeat(repeatX, repeatY)
    self.grid:setRepeat(repeatX, repeatY)
end

return MapImage