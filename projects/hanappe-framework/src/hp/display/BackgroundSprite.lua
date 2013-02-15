--------------------------------------------------------------------------------
-- This class draws the grid. <br>
-- Without the use of MOAITileDeck, use the MOAIGfxQuadDeck2D. <br>
-- Corresponding to the format can be flexibility. <br>
--------------------------------------------------------------------------------

-- import
local table                     = require "hp/lang/table"
local class                     = require "hp/lang/class"
local MapSprite                 = require "hp/display/MapSprite"

-- class
local super                     = MapSprite
local M                         = class(super)

----------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
----------------------------------------------------------------
function M:init(params)
    super.init(self)
    self:setRepeat(true)

    self:copyParams(params)
end

function M:setTexture(texture)
    super.setTexture(self, texture)
    
    if self.texture then
        local w, h = self.texture:getSize()
        self:setMapSize(1, 1, w, h)
        self:setMapSheets(w, h, 1, 1)
        self:setTile(1, 1, 1)
    end
end

return M