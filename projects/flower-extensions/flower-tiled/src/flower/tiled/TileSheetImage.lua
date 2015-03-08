----------------------------------------------------------------------------------------------------
-- SheetImage an extension for the tile map.
-- In addition to the tiles typically includes tile diagonal.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.SheetImage.html">SheetImage</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local SheetImage = require "flower.SheetImage"

-- class
local TileSheetImage = class(SheetImage)

---
-- Override to create a tile diagonal.
-- @param tileWidth The width of the tile
-- @param tileHeight The height of the tile
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
function TileSheetImage:setTileSize(tileWidth, tileHeight, spacing, margin)
    spacing = spacing or 0
    margin = margin or 0
    
    local tw, th = self.texture:getSize()
    local tileX = math.floor((tw - margin) / (tileWidth + spacing))
    local tileY = math.floor((th - margin) / (tileHeight + spacing))

    local deck = MOAIGfxQuadDeck2D.new()
    self:setDeck(deck)
    self.sheetSize = tileX * tileY
    self.reserveSize = self.sheetSize * 2
    deck:reserve(self.reserveSize)
    
    local i = 1
    for y = 1, tileY do
        for x = 1, tileX do
            local sx = (x - 1) * (tileWidth + spacing) + margin
            local sy = (y - 1) * (tileHeight + spacing) + margin
            local ux0 = sx / tw
            local uy0 = sy / th
            local ux1 = (sx + tileWidth) / tw
            local uy1 = (sy + tileHeight) / th

            if not self.grid then
                deck:setRect(i, 0, 0, tileWidth, tileHeight)
            end

            deck:setUVRect(i, ux0, uy0, ux1, uy1)
            deck:setUVQuad(i + self.sheetSize, ux1, uy0, ux1, uy1, ux0, uy1, ux0, uy0)
            i = i + 1
        end
    end
end

return TileSheetImage