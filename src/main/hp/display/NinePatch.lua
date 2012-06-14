local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local Resizable = require("hp/display/Resizable")
local TextureDrawable = require("hp/display/TextureDrawable")

--------------------------------------------------------------------------------
-- NinePatch class is the scale is partially configured.<br>
-- When you set the size, scale will be reconfigured dynamically.<br>
-- Will help you build a widget.<br>
-- Extends : DisplayObject, TextureDrawable, Resizable<br>
-- @class table
-- @name NinePatch
--------------------------------------------------------------------------------
local M = class(DisplayObject, TextureDrawable, Resizable)

local interface = MOAIProp.getInterfaceTable()

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)
    
    params = params or {}
    params = type(params) == "string" and {texture = params} or params

    local deck = MOAIStretchPatch2D.new()
    self:setDeck(deck)
    self.deck = deck
    
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
    
    self.setOrignScl = assert(interface.setScl)
    self.getOrignScl = assert(interface.getScl)
    self.seekOrignScl = assert(interface.seekScl)
    
    self:setPrivate("width", 0)
    self:setPrivate("height", 0)
    self:setPrivate("sclX", 1)
    self:setPrivate("sclY", 1)
    self:setPrivate("sclZ", 1)

    self:copyParams(params)
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

--------------------------------------------------------------------------------
--サイズを設定します.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    assert(self.texture)

    local tw, th = self.texture:getSize()
    local left, top = self:getPos()
    local sclX, sclY, sclZ = self:getScl()
    local bSclX, bSclY, bSclZ = width / tw, height / th, 1 -- TODO:sclZ
    local oSclX, oSclY, oSclZ = sclX * bSclX, sclY * bSclY, sclZ * bSclZ
    
    self:setPrivate("width", width)
    self:setPrivate("height", height)
    
    self.deck:setRect(-tw / 2, -th / 2, tw / 2, th / 2)
    self:setOrignScl(oSclX, oSclY, oSclZ)
    self:setPos(left, top)
end

--------------------------------------------------------------------------------
-- スケールを設定します.
--------------------------------------------------------------------------------
function M:setScl(x, y, z)
    self:setPrivate("sclX", x)
    self:setPrivate("sclX", y)
    self:setPrivate("sclX", z)
    
    local sclX, sclY, sclZ = self:getOrignScl()
    sclX, sclY, sclZ = sclX * x, sclY * y, sclZ * z
    self:setOrignScl(sclX, sclY, sclZ)
end

--------------------------------------------------------------------------------
-- スケールを返します.
--------------------------------------------------------------------------------
function M:getScl()
    return self:getPrivate("sclX"), self:getPrivate("sclY"), self:getPrivate("sclZ")
end

--------------------------------------------------------------------------------
-- スケールを移動します.
-- TODO:おそらく上手くいかない。実装方法の検討が必要。
--------------------------------------------------------------------------------
function M:seekScl(x, y, z, sec, mode)
    local sclX, sclY, sclZ = self:getOrignScl()
    sclX, sclY, sclZ = sclX * x, sclY * y, sclZ * z
    return self:seekScl(sclX, sclY, sclZ, sec, mode)
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