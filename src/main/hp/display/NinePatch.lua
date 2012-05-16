local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local TextureDrawable = require("hp/display/TextureDrawable")

--------------------------------------------------------------------------------
-- 部分的に伸張が可能なNinePatchクラスです.<br>
-- 外部的な使用方法はSprite等とほとんど変わりませんが、
-- サイズを指定するとスケールが大きくなります.<br>
-- ウィジットの構築に役立ちます.<br>
-- @class table
-- @name NinePatch
--------------------------------------------------------------------------------
local M = class(DisplayObject, TextureDrawable)

local interface = MOAIProp.getInterfaceTable()

--------------------------------------------------------------------------------
-- Spriteインスタンスを生成して返します.
--------------------------------------------------------------------------------
function M:new(params)
    assert(params, "params is nil!")
    assert(params.texture, "texture is nil!")

    -- prop, deck
    local deck = MOAIStretchPatch2D.new()
    local prop = MOAIProp.new()
    table.copy(self, prop)
    prop:setDeck(deck)
    prop.deck = deck
    deck:reserveUVRects(1)
    deck:setUVRect(1, 0, 0, 1, 1)

    deck:reserveRows(3)
    deck:setRow(1, 1 / 3, false)
    deck:setRow(2, 1 / 3, true)
    deck:setRow(3, 1 / 3, false)
    
    deck:reserveColumns(3)
    deck:setColumn(1, 1 / 3, false)
    deck:setColumn(2, 1 / 3, true)
    deck:setColumn(3, 1 / 3, false)
    
    prop.setOrignScl = assert(interface.setScl)
    prop.getOrignScl = assert(interface.getScl)
    prop.seekOrignScl = assert(interface.seekScl)
    
    prop:setPrivate("width", 0)
    prop:setPrivate("height", 0)

    prop:copyParams(params)
    
    return prop
end

--------------------------------------------------------------------------------
-- パラメータテーブルの値を元に、各setter関数の引数にセットしてコールします.
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.texture and self.setTexture then
        self:setTexture(params.texture)
        self:setSize(self.texture:getSize())
    end
    if params.width and params.height then
        self:setSize(params.width, params.height)
    end

    DisplayObject.copyParams(self, params)
end

function M:setWidth(width)
    self:setSize(width, self:getHeight())
end

function M:setHeight(height)
    self:setSize(self:getWidth(), height)
end

--------------------------------------------------------------------------------
--サイズを設定します.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    local tw, th = self.texture:getSize()
    local left, top = self:getLeft(), self:getTop()
    local sclX, sclY, sclZ = self:getScl()
    local bSclX, bSclY, bSclZ = width / tw, height / th, 1 -- TODO:sclZ
    local oSclX, oSclY, oSclZ = sclX * bSclX, sclY * bSclY, sclZ * bSclZ
    
    self:setPrivate("width", width)
    self:setPrivate("height", height)
    
    self.deck:setRect(-tw / 2, -th / 2, tw / 2, th / 2)
    self:setOrignScl(oSclX, oSclY, oSclZ)
    self:setLeft(left)
    self:setTop(top)
end

--------------------------------------------------------------------------------
-- スケールを設定します.
--------------------------------------------------------------------------------
function M:setScl(x, y, z)
    local tw, th = self.texture:getSize()
    local width, height = self:getSize()
    local sclX, sclY, sclZ = self:getOrignScl()
    sclX, sclY, sclZ = sclX * x, sclY * y, sclZ * z
    self:setOrignScl(sclX, sclY, sclZ)
end

function M:getScl()
    -- TODO
    return 1, 1, 1
end

--------------------------------------------------------------------------------
-- 固定的な列の長さを設定します.
--------------------------------------------------------------------------------
function M:setStretchColumns(col1, col2, col3)
    self.deck:setColumn ( 1, col1, false )
    self.deck:setColumn ( 2, col2, true )
    self.deck:setColumn ( 3, col3, false )
end

--------------------------------------------------------------------------------
-- 固定的な行の長さを設定します.
--------------------------------------------------------------------------------
function M:setStretchRows(row1, row2, row3)
    self.deck:setRow ( 1, row1, false )
    self.deck:setRow ( 2, row2, true )
    self.deck:setRow ( 3, row3, false )
end

--------------------------------------------------------------------------------
-- 境界座標を返します.
--------------------------------------------------------------------------------
function M:getBounds()
    local width, height = self:getPrivate("width"), self:getPrivate("height")
    local xMin, yMin, zMin = -width / 2, -height / 2, 0
    local xMax, yMax, zMax = width / 2, height / 2, 0
    return xMin, yMin, zMin, xMax, yMax, zMax
end


return M