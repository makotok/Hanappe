--------------------------------------------------------------------------------
-- NinePatch class is the scale is partially configured. <br>
-- When you set the size, scale will be reconfigured dynamically. <br>
-- Will help you build a widget. <br>
-- Base Classes => DisplayObject, TextureDrawable, Resizable <br>
--------------------------------------------------------------------------------

-- import
local table                     = require("hp/lang/table")
local class                     = require("hp/lang/class")
local DisplayObject             = require("hp/display/DisplayObject")
local Resizable                 = require("hp/display/Resizable")
local TextureDrawable           = require("hp/display/TextureDrawable")

-- class
local M                         = class(DisplayObject, TextureDrawable, Resizable)
local MOAIPropInterface         = MOAIProp.getInterfaceTable()

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
    
    self.setOrignScl = assert(MOAIPropInterface.setScl)
    self.getOrignScl = assert(MOAIPropInterface.getScl)
    self.seekOrignScl = assert(MOAIPropInterface.seekScl)
    
    self._width = 0
    self._height = 0
    self._sclX = 1
    self._sclY = 1
    self._sclZ = 1

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Sets the size.<br>
-- When you set the size, set by calculating the scale.
-- @param width width.
-- @param height height.
--------------------------------------------------------------------------------
function M:setSize(width, height)
    assert(self.texture)

    local tw, th = self.texture:getSize()
    local left, top = self:getPos()
    local sclX, sclY, sclZ = self:getScl()
    local bSclX, bSclY, bSclZ = width / tw, height / th, 1 -- TODO:sclZ
    local oSclX, oSclY, oSclZ = sclX * bSclX, sclY * bSclY, sclZ * bSclZ
    
    self._width = width
    self._height = height
    
    self.deck:setRect(-tw / 2, -th / 2, tw / 2, th / 2)
    self:setOrignScl(oSclX, oSclY, oSclZ)
    self:setPos(left, top)
end

--------------------------------------------------------------------------------
-- Sets the virtual scale.<br>
-- Value to be set will vary.<br>
-- TODO:Can not cope with if you want to move dynamically.
-- @param x scaleX.
-- @param y scaleY.
-- @param z scaleZ.
--------------------------------------------------------------------------------
function M:setScl(x, y, z)
    local internal = self:getInternal()
    internal.sclX = x
    internal.sclY = y
    internal.sclZ = z
    
    local sclX, sclY, sclZ = self:getOrignScl()
    sclX, sclY, sclZ = sclX * x, sclY * y, sclZ * z
    self:setOrignScl(sclX, sclY, sclZ)
end

--------------------------------------------------------------------------------
-- Returns a virtual scale.<br>
-- TODO:Can not cope with if you want to move dynamically.<br>
-- @return scaleX, scaleY, scaleZ.
--------------------------------------------------------------------------------
function M:getScl()
    return self._sclX, self._sclY, self._sclZ
end

--------------------------------------------------------------------------------
-- Seek a virtual scale.<br>
-- TODO:Does not work
-- @param x X of scale.
-- @param y Y of scale.
-- @param z Z of scale.
-- @param sec seconds.
-- @param mode MOAIEaseType.
-- @return MOAIEase
--------------------------------------------------------------------------------
function M:seekScl(x, y, z, sec, mode)
    local sclX, sclY, sclZ = self:getOrignScl()
    sclX, sclY, sclZ = sclX * x, sclY * y, sclZ * z
    return self:seekScl(sclX, sclY, sclZ, sec, mode)
end

--------------------------------------------------------------------------------
-- Sets the ratio of the columns.
-- @param col1 Fixed ratio of the column.
-- @param col2 Dynamic ratio of the column.
-- @param col3 Fixed ratio of the column.
--------------------------------------------------------------------------------
function M:setStretchColumns(col1, col2, col3)
    self.deck:setColumn ( 1, col1, false )
    self.deck:setColumn ( 2, col2, true )
    self.deck:setColumn ( 3, col3, false )
end

--------------------------------------------------------------------------------
-- Sets the ratio of the rows.
-- @param row1 Fixed ratio of the row.
-- @param row2 Dynamic ratio of the row.
-- @param row3 Fixed ratio of the row.
--------------------------------------------------------------------------------
function M:setStretchRows(row1, row2, row3)
    self.deck:setRow ( 1, row1, false )
    self.deck:setRow ( 2, row2, true )
    self.deck:setRow ( 3, row3, false )
end

--------------------------------------------------------------------------------
-- Returns the boundary position.
-- @return xMin, yMin, zMin, xMax, yMax, zMax
--------------------------------------------------------------------------------
function M:getBounds()
    local width, height = self._width, self._height
    local xMin, yMin, zMin = -width / 2, -height / 2, 0
    local xMax, yMax, zMax = width / 2, height / 2, 0
    return xMin, yMin, zMin, xMax, yMax, zMax
end


return M