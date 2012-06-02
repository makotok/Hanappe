local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local TextureDrawable = require("hp/display/TextureDrawable")

--------------------------------------------------------------------------------
-- Gridを描画するモジュールです.<br>
-- 通常のMOAITileDeckとは異なり、marginやspacingの指定が可能です.
-- @class table
-- @name MapSprite
--------------------------------------------------------------------------------
local M = class(DisplayObject, TextureDrawable)

--------------------------------------------------------------------------------
-- インスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:init(params)
    assert(params, "params is nil!")
    assert(params.texture, "texture is nil!")

    local deck = MOAIGfxQuadDeck2D.new()
    local grid = MOAIGrid.new ()

    self:setDeck(deck)
    self:setGrid(grid)
    self.deck = deck
    self.grid = grid

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- パラメータを各プロパティにコピーします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.texture and self.setTexture then
        self:setTexture(params.texture)
    end
    if params.sheets then
        self:setSheets(params.sheets)
    end
    DisplayObject.copyParams(self, params)
end

--------------------------------------------------------------------------------
-- タイル形式のシートデータを生成して設定します.
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
-- シートデータを設定します.
--------------------------------------------------------------------------------
function M:setSheets(sheets)
    if not self.texture then
        return
    end
    
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
-- マップサイズを設定します.
--------------------------------------------------------------------------------
function M:setMapSize(mapWidth, mapHeight, tileWidth, tileHeight)
    self.grid:setSize(mapWidth, mapHeight, tileWidth, tileHeight)
end

--------------------------------------------------------------------------------
-- マップの行データを設定します.
--------------------------------------------------------------------------------
function M:setRows(rows)
    for i, row in ipairs(rows) do
        self:setRow(i, table.unpack(row))
    end
end

--------------------------------------------------------------------------------
-- マップの行データを設定します.
--------------------------------------------------------------------------------
function M:setRow(...)
    self.grid:setRow(...)
end

return M