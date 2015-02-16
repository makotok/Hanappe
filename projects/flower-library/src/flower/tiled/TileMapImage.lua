----------------------------------------------------------------------------------------------------
-- MapImage an extension for the tile map.
-- In addition to the tiles typically includes tile diagonal.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.core.MapImage.html">MapImage</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local MapImage = require "flower.core.MapImage"
local TileSheetImage = require "flower.tiled.TileSheetImage"

-- class
local TileMapImage = class(MapImage)

---
-- Override to create a tile diagonal.
-- @param tileWidth The width of the tile
-- @param tileHeight The height of the tile
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
function TileMapImage:setTileSize(tileWidth, tileHeight, spacing, margin)
    TileSheetImage.setTileSize(self, tileWidth, tileHeight, spacing, margin)
end

return TileMapImage