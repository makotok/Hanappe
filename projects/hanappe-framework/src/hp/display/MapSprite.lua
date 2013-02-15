--------------------------------------------------------------------------------
-- This class draws the grid. <br>
-- Without the use of MOAITileDeck, use the MOAIGfxQuadDeck2D. <br>
-- Corresponding to the format can be flexibility. <br>
--------------------------------------------------------------------------------

-- import
local table                     = require "hp/lang/table"
local class                     = require "hp/lang/class"
local DisplayObject             = require "hp/display/DisplayObject"
local TextureDrawable           = require "hp/display/TextureDrawable"

-- class
local M                         = class(DisplayObject, TextureDrawable)

----------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
----------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)
    
    params = params or {}
    params = type(params) == "string" and {texture = params} or params

    local deck = MOAIGfxQuadDeck2D.new()
    local grid = MOAIGrid.new ()

    self:setDeck(deck)
    self:setGrid(grid)
    self.deck = deck
    self.grid = grid

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Sets the data to generate a sheet of tile form.
-- @param tileWidth Width of the tile.
-- @param tileHeight Height of the tile.
-- @param tileX number of tiles in the x-direction.
-- @param tileY number of tiles in the y-direction.
-- @param spacing (option)Space size of each tile.
-- @param margin (option)Margin of tile.
--------------------------------------------------------------------------------
function M:setMapSheets(tileWidth, tileHeight, tileX, tileY, spacing, margin)
    spacing = spacing or 0
    margin = margin or 0
    local sheets = {}
    for y = 1, tileY do
        for x = 1, tileX do
            local sx = (x - 1) * (tileWidth + spacing) + margin
            local sy = (y - 1) * (tileHeight + spacing) + margin
            table.insert(sheets, {x = sx, y = sy, width = tileWidth, height = tileHeight})
        end
    end
    self:setSheets(sheets)
end

--------------------------------------------------------------------------------
-- Sets the data sheet.
-- @param sheets Data sheet.
--------------------------------------------------------------------------------
function M:setSheets(sheets)
    assert(self.texture)
    
    local tw, th = self.texture:getSize()
    self.deck:reserve(#sheets)
    for i, sheet in ipairs(sheets) do
        local xMin, yMin = sheet.x, sheet.y
        local xMax = sheet.x + sheet.width
        local yMax = sheet.y + sheet.height
        self.deck:setUVRect(i, xMin / tw, yMin / th, xMax / tw, yMax / th)
    end
end

--------------------------------------------------------------------------------
-- Set the map size.
-- @param mapWidth Height of the map.
-- @param mapHeight Height of the map.
-- @param tileWidth Width of the tile.
-- @param tileHeight Height of the tile.
--------------------------------------------------------------------------------
function M:setMapSize(mapWidth, mapHeight, tileWidth, tileHeight)
    self.grid:setSize(mapWidth, mapHeight, tileWidth, tileHeight)
end

--------------------------------------------------------------------------------
-- Set the map data.
-- @param rows Multiple rows of data.
--------------------------------------------------------------------------------
function M:setRows(rows)
    for i, row in ipairs(rows) do
        self:setRow(i, table.unpack(row))
    end
end

--------------------------------------------------------------------------------
-- Set the map data.
-- @param ... rows of data.
--------------------------------------------------------------------------------
function M:setRow(...)
    self.grid:setRow(...)
end

--------------------------------------------------------------------------------
-- Set the map value.
-- @param x x.
-- @param y y.
-- @param value value.
--------------------------------------------------------------------------------
function M:setTile(x, y, value)
    self.grid:setTile(x, y, value)
end

--------------------------------------------------------------------------------
-- Set the repeat flag.
-- @param repeatX
-- @param repeatY
--------------------------------------------------------------------------------
function M:setRepeat(repeatX, repeatY)
    self.grid:setRepeat(repeatX, repeatY)
end

return M