--------------------------------------------------------------------------------
-- This is a class to draw the sheet switching. <br>
-- Sheet can be defined in any shape. <br>
-- <br>
-- Base Classes => DisplayObject, TextureDrawable<br>
--------------------------------------------------------------------------------

-- import
local table                     = require "hp/lang/table"
local class                     = require "hp/lang/class"
local DisplayObject             = require "hp/display/DisplayObject"
local TextureDrawable           = require "hp/display/TextureDrawable"

-- class
local M                         = class(DisplayObject, TextureDrawable)

--------------------------------------------------------------------------------
-- The constructor.<br>
-- @param params (option)Parameter is set to Object.<br>
-- params:<br>
--     texture:Path of the texture. Or, MOAITexture instance.<br>
--     sheets:See setSheets function.<br>
--     sheetAnims = See setSheetAnims function.<br>
-- @return instance
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}
    params = type(params) == "string" and {texture = params} or params

    local deck = MOAIGfxQuadDeck2D.new()
    self:setDeck(deck)
    self.deck = deck
    self.animTable = {}
    self.currentAnim = nil
    self.sheetSize = 0

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Set the sheet data in the form of tiles.
-- @param tileWidth The width of the tile.
-- @param tileHeight The height of the tile.
-- @param tileX (option)number of tiles in the x-direction.
-- @param tileY (option)number of tiles in the y-direction.
-- @param spacing (option)Spaces between tiles.
-- @param margin (option)Margins of the Start position
--------------------------------------------------------------------------------
function M:setTiledSheets(tileWidth, tileHeight, tileX, tileY, spacing, margin)
    assert(self.texture)
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
-- Sets the tile size.
-- @param tileX number of tiles in the x-direction.
-- @param tileY number of tiles in the y-direction.
--------------------------------------------------------------------------------
function M:setTileSize(tileX, tileY)
    assert(self.texture)
    
    local tw, th = self.texture:getSize()
    local w, h = tw / tileX, th / tileY
    self:setTiledSheets(w, h, tileX, tileY)
end

--------------------------------------------------------------------------------
-- Set the data sheet.<br>
-- Sheet in accordance with the following format: Please.<br>
-- {x = Start position, y = Start position, width = The width of the sheet, height = The height of the sheet} <br>
-- TODO:Setting of the flip.
-- @param sheets sheet data
--------------------------------------------------------------------------------
function M:setSheets(sheets)
    assert(self.texture)
    
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
-- Set the data to move the key frame animations.<br>
-- See M:setSheetAnim function.<br>
-- @param sheetAnims table is set to setSheetAnim.
--------------------------------------------------------------------------------
function M:setSheetAnims(sheetAnims)
    for i, v in ipairs(sheetAnims) do
        local name = v.name or i
        self:setSheetAnim(name, v.indexes, v.sec, v.mode)
    end
end

--------------------------------------------------------------------------------
-- Set the data to move the key frame animation.<br>
-- @param name Animation name.
-- @param indexes Key sequence.
-- @param sec Seconds to move the key.
-- @param mode (option)Mode is set to MOAIAnim.(The default is MOAITimer.LOOP)
--------------------------------------------------------------------------------
function M:setSheetAnim(name, indexes, sec, mode)
    local curve = MOAIAnimCurve.new()
    local anim = MOAIAnim.new()

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
-- Returns the animation data with the specified name.
-- @param name Animation name.
-- @return MOAIAnim instance
--------------------------------------------------------------------------------
function M:getSheetAnim(name)
    return self.animTable[name]
end

--------------------------------------------------------------------------------
-- Start the animation.
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
-- Stop the animation.
--------------------------------------------------------------------------------
function M:stopAnim()
    if self.currentAnim then
        self.currentAnim:stop()
    end
end

--------------------------------------------------------------------------------
-- Check the current animation with the specified name.<br>
-- @param name Animation name.
-- @return If the current animation is true.
--------------------------------------------------------------------------------
function M:isCurrentAnim(name)
    return self.currentAnim == self.animTable[name]
end

return M