local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local TextureDrawable = require("hp/display/TextureDrawable")

--------------------------------------------------------------------------------
-- 複数のシートを切り替えて描画するクラスです.<br>
-- シート情報を設定して、シートアニメーションを行う事が簡単にできます.<br>
-- @class table
-- @name SpriteSheet
--------------------------------------------------------------------------------
local M = class(DisplayObject, TextureDrawable)

--------------------------------------------------------------------------------
-- SpriteSheetインスタンスを生成して返します.<br>
-- @param params 生成するためのパラメータ<br>
-- paramsに設定できるパラメータ:<br>
--     texture = テクスチャのパスもしくはMOAITextureインスタンス.<br>
--     sheets = sheet情報.setSheets関数を参照.<br>
--     sheetAnims = animation情報.setSheetAnims関数を参照.<br>
--     left = 左原点の座標.<br>
--     top = 上原点の座標.<br>
--     layer = MOAILayerを設定.<br>
-- @return インスタンス
--------------------------------------------------------------------------------
function M:new(params)
    -- asserts
    assert(params, "params is nil!")
    assert(params.texture, "texture is nil!")

    -- prop, deck
    local prop = MOAIProp.new()
    table.copy(self, prop)
    local deck = MOAIGfxQuadDeck2D.new()
    prop:setDeck(deck)
    prop.deck = deck
    prop.animTable = {}
    prop.currentAnim = nil
    prop.sheetSize = 0

    -- set params
    prop:copyParams(params)
    
    return prop
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
    if params.sheetAnims then
        self:setSheetAnims(params.sheetAnims)
    end
    
    DisplayObject.copyParams(self, params)
end

--------------------------------------------------------------------------------
-- タイル形式のシートデータを生成して設定します.
-- シート毎の余白などを設定可能です.
-- @param tileWidth タイルの幅
-- @param tileHeight タイルの高さ
-- @param tileX X方向のタイル数(option)
-- @param tileY Y方向のタイル数(option)
-- @param spacing シート毎の余白(option)
-- @param margin シートの開始位置の余白(option)
--------------------------------------------------------------------------------
function M:setTiledSheets(tileWidth, tileHeight, tileX, tileY, spacing, margin)
    assert(tileWidth)
    assert(tileHeight)
    
    spacing = spacing or 0
    margin = margin or 0
    
    local tw, th = self.texture:getSize()
    tileX = tileX or math.floor((tw - margin) / (tileWidth + spacing))
    tileY = tileY or math.floor((th - margin) / (tileHeight + spacing))

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
-- シートデータを設定します.<br>
-- シートデータは以下の形式に乗っ取ってください.<br>
-- {x = x座標の開始位置, y = y座標の開始位置, width = 幅, height = 高さ}
-- @param sheets シートデータ
--------------------------------------------------------------------------------
function M:setSheets(sheets)
    if not self.texture then
        return
    end
    
    local tw, th = self.texture:getSize()
    self.deck:reserve(#sheets)
    self.sheetSize = #sheets
    for i, sheet in ipairs(sheets) do
        local xMin, yMin = sheet.x, sheet.y
        local xMax = sheet.x + sheet.width
        local yMax = sheet.y + sheet.height
        self.deck:setRect(i, -sheet.width / 2, -sheet.height / 2, sheet.width / 2, sheet.height / 2)
        self.deck:setUVRect(i, xMin / tw, yMin / th, xMax / tw, yMax / th)
    end
end

--------------------------------------------------------------------------------
-- 複数のアニメーションデータを設定します.
--------------------------------------------------------------------------------
function M:setSheetAnims(sheetAnims)
    for i, v in ipairs(sheetAnims) do
        local name = v.name or i
        self:setSheetAnim(name, v.indexes, v.sec, v.mode)
    end
end

--------------------------------------------------------------------------------
-- アニメーションデータを設定します.
--------------------------------------------------------------------------------
function M:setSheetAnim(name, indexes, sec, mode)
    local curve = MOAIAnimCurve.new()
    local anim = MOAIAnim:new()

    curve:reserveKeys(#indexes)
    for i = 1, #indexes do
        curve:setKey(i, sec * (i - 1), indexes[i], MOAIEaseType.FLAT )
    end

    local mode = mode or MOAITimer.LOOP
    anim:reserveLinks(1)
    anim:setMode(mode)
    anim:setLink(1, curve, self, MOAIProp.ATTR_INDEX )
    anim:setCurve(curve)
    
    self.animTable[name] = anim
end

--------------------------------------------------------------------------------
-- 指定した名前のアニメーションデータを返します.
--------------------------------------------------------------------------------
function M:getSheetAnim(name)
    return self.animTable[name]
end

--------------------------------------------------------------------------------
-- アニメーションを開始します.
--------------------------------------------------------------------------------
function M:playAnim(name)
    local currentAnim = self.currentAnim
    local animTable = self.animTable
    
    if currentAnim and currentAnim:isBusy() then
        currentAnim:stop()
    end
    if animTable[name] then
        currentAnim = animTable[name]
        self.currentAnim = currentAnim
    end
    if currentAnim then
        currentAnim:start()
    end
end

--------------------------------------------------------------------------------
-- アニメーションを停止します.
--------------------------------------------------------------------------------
function M:stopAnim()
    if self.currentAnim then
        self.currentAnim:stop()
    end
end

--------------------------------------------------------------------------------
-- 指定した名前がカレントアニメーションかどうか判定します.
--------------------------------------------------------------------------------
function M:isCurrentAnim(name)
    return self.currentAnim == self.animTable[name]
end

return M