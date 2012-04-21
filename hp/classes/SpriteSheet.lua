local table = require("hp/lang/table")
local MOAIPropUtil = require("hp/classes/MOAIPropUtil")
local TextureManager = require("hp/classes/TextureManager")

----------------------------------------------------------------
-- 描画オブジェクトを生成するモジュールです.<br>
-- オブジェクトの生成を簡単に行う事ができるようになります。
-- @class table
-- @name display
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
    if params.sheetAnims then
        prop:setSheetAnims(params.sheetAnims)
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

    -- prop, deck
    local prop = MOAIProp.new()
    local deck = MOAIGfxQuadDeck2D.new()
    prop:setDeck(deck)
    prop.deck = deck
    prop.animTable = {}
    prop.currentAnim = nil

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
function I:setTiledSheets(tileWidth, tileHeight, tileX, tileY, spacing, margin)
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
        self.deck:setRect(i, -sheet.width / 2, -sheet.height / 2, sheet.width / 2, sheet.height / 2)
        self.deck:setUVRect(i, xMin / tw, yMin / th, xMax / tw, yMax / th)
    end
end

----------------------------------------------------------------
-- 複数のアニメーションデータを設定します.
----------------------------------------------------------------
function I:setSheetAnims(sheetAnims)
    for i, v in ipairs(sheetAnims) do
        local name = v.name or i
        self:setSheetAnim(name, v.indexes, v.sec, v.mode)
    end
end

----------------------------------------------------------------
-- アニメーションデータを設定します.
----------------------------------------------------------------
function I:setSheetAnim(name, indexes, sec, mode)
    local curve = MOAIAnimCurve.new()
    local anim = MOAIAnim:new()

    curve:reserveKeys(#indexes)
    for i = 1, #indexes do
        curve:setKey(i, sec * (i - 1), indexes[i], MOAIEaseType.FLAT )
    end

    local mode = mode or MOAITimer.LOOP
    anim:reserveLinks(1)
    anim:setMode(mode)
    anim:setLink(1, curve, self, MOAIProp2D.ATTR_INDEX )
    anim:setCurve(curve)
    
    self.animTable[name] = anim
end

----------------------------------------------------------------
-- 指定した名前のアニメーションデータを返します.
----------------------------------------------------------------
function I:getSheetAnim(name)
    return self.animTable[name]
end

----------------------------------------------------------------
-- アニメーションを開始します.
----------------------------------------------------------------
function I:playAnim(name)
    local currentAnim = self.currentAnim
    local animTable = self.animTable
    
    if currentAnim and currentAnim:isBusy() then
        currentAnim:stop()
    end
    if animTable[name] then
        currentAnim = animTable[name]
    end
    if currentAnim then
        currentAnim:start()
    end
end

----------------------------------------------------------------
-- アニメーションを停止します.
----------------------------------------------------------------
function I:stopAnim()
    if self.currentAnim then
        self.currentAnim:stop()
    end
end

return M