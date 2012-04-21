local table = require("hp/lang/table")
local MOAIPropUtil = require("hp/classes/MOAIPropUtil")
local TextureManager = require("hp/classes/TextureManager")

----------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name MapSprite
----------------------------------------------------------------
local M = {}
local I = {}

local function copyParams(prop, params)
    if params.texture then
        prop:setTexture(params.texture)
    end
    if params.sheets then
        prop:setSheets(params.sheets)
    end
    if params.left then
        prop:setLeft(params.left)
    end
    if params.top then
        prop:setTop(params.top)
    end
    if params.layer then
        params.layer:insertProp(prop)
    end
end

----------------------------------------------------------------
-- SpriteSheetインスタンスを生成して返します.
----------------------------------------------------------------
function M:new(params)
    -- asserts
    assert(params, "params is nil!")
    assert(params.texture, "texture is nil!")

    -- prop, deck, grid
    local prop = MOAIProp.new()
    local deck = MOAIGfxQuadDeck2D.new()
    local grid = MOAIGrid.new ()

    prop:setDeck(deck)
    prop:setGrid(grid)
    prop.deck = deck
    prop.grid = grid

    -- custom functions
    table.copy(MOAIPropUtil, prop)
    table.copy(I, prop)

    -- set params
    copyParams(prop, params)
    
    return prop
end

----------------------------------------------------------------
-- Textureを設定します.
----------------------------------------------------------------
function I:setTexture(texture)
    if not texture then
        self.texture = nil
        self.deck:setTexture(nil)
        return
    end
    if type(texture) == "string" then
        texture = TextureManager:request(texture)
    end
    self.texture = texture
    self.deck:setTexture(texture)
end

----------------------------------------------------------------
-- タイル形式のシートデータを生成して設定します.
----------------------------------------------------------------
function I:setMapSheets(tileWidth, tileHeight, tileX, tileY, spacing, margin)
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

----------------------------------------------------------------
-- シートデータを設定します.
----------------------------------------------------------------
function I:setSheets(sheets)
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

----------------------------------------------------------------
-- マップサイズを設定します.
----------------------------------------------------------------
function I:setMapSize(mapWidth, mapHeight, tileWidth, tileHeight)
    self.grid:setSize(mapWidth, mapHeight, tileWidth, tileHeight)
end

----------------------------------------------------------------
-- マップの行データを設定します.
----------------------------------------------------------------
function I:setRows(rows)
    for i, row in ipairs(rows) do
        self:setRow(i, table.unpack(row))
    end
end

----------------------------------------------------------------
-- マップの行データを設定します.
----------------------------------------------------------------
function I:setRow(...)
    self.grid:setRow(...)
end

return M