local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local TextureDrawable = require("hp/display/TextureDrawable")
local Resizable = require("hp/display/Resizable")

--------------------------------------------------------------------------------
-- This is a class to draw the texture.<br>
-- Extends : DisplayObject, TextureDrawable, Resizable<br>
-- @class table
-- @name Sprite
--------------------------------------------------------------------------------
local M = class(DisplayObject, TextureDrawable, Resizable)

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}
    params = type(params) == "string" and {texture = params} or params
    
    local deck = MOAIGfxQuad2D.new()
    deck:setUVRect(0, 0, 1, 1)
    
    self:setDeck(deck)
    self.deck = deck

    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.<br>
--      (params:texture, width, height)
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.texture and self.setTexture then
        self:setTexture(params.texture)
    end
    if params.width and params.height then
        self:setSize(params.width, params.height)
    end

    DisplayObject.copyParams(self, params)
end

return M