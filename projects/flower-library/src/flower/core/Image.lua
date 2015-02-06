----------------------------------------------------------------------------------------------------
-- Class to display a simple texture.
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local Config = require "flower.core.Config"
local DisplayObject = require "flower.core.DisplayObject"
local Resources = require "flower.core.Resources"
local DeckMgr = require "flower.core.DeckMgr"

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

    self:setTexture(texture)

    if width or height then
        local tw, th = self.texture:getSize()
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