----------------------------------------------------------------------------------------------------
-- Class to display a simple texture.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.DisplayObject.html">DisplayObject</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Config = require "flower.Config"
local DisplayObject = require "flower.DisplayObject"
local Resources = require "flower.Resources"
local DeckMgr = require "flower.DeckMgr"

-- class
local Image = class(DisplayObject)

---
-- Constructor.
-- @param texture Texture path, or texture.
-- @param width (option) Width of image.
-- @param height (option) Height of image.
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function Image:init(texture, width, height, flipX, flipY)
    Image.__super.init(self)

    if texture then
        self:setTexture(texture)
    end
    if width or height then
        local tw, th = texture and self.texture:getSize()
        tw = tw or 0
        th = th or 0
        self:setSize(width or tw, height or th)
    end
    if flipX or flipY then
        self:setFlip(flipX, flipY)
    end
end

---
-- Sets the size.
-- @param width Width of image.
-- @param height Height of image.
function Image:setSize(width, height)
    local flipX = self.deck and self.deck.flipX or false
    local flipY = self.deck and self.deck.flipY or false
    local deck = DeckMgr:getImageDeck(width, height, flipX, flipY)
    self:setDeck(deck)
    self:setPivToCenter()
end

---
-- Sets the texture.
-- @param texture Texture path, or texture
function Image:setTexture(texture)
    self.texture = Resources.getTexture(texture)
    Image.__index.setTexture(self, self.texture)
    local tw, th = self.texture:getSize()
    self:setSize(tw, th)
end

---
-- Sets the texture flip.
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function Image:setFlip(flipX, flipY)
    local width, height = self:getSize()
    local deck = DeckMgr:getImageDeck(width, height, flipX, flipY)
    self:setDeck(deck)
end

return Image