----------------------------------------------------------------------------------------------------
-- @type NineImage
--
-- This class displays the NinePatch of Android.
-- The following restrictions exist.
-- In many cases, to solve by wrapping it in Group class.
--
-- <ol>
--   <li>setPiv function does not work.</li>
--   <li>Scale should not be set directly.<li>
-- </ol>
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local Resources = require "flower.core.Resources"
local DisplayObject = require "flower.core.DisplayObject"
local DeckMgr = require "flower.core.DeckMgr"
local Logger = require "flower.core.Logger"

-- class
local NineImage = class(DisplayObject)

---
-- Constructor.
-- @param imagePath File path NinePach.
-- @param width (option) Width of image.
-- @param height (option) Height of image.
function NineImage:init(imagePath, width, height)
    NineImage.__super.init(self)
    self._scaledWidth = nil
    self._scaledHeight = nil

    self:setImage(imagePath, width, height)
    if not width or not height then
        self:setSize(width or self.displayWidth, height or self.displayHeight)
    end
end

---
-- Set the NineImageDeck.
-- @param imagePath File path or NineImageDeck.
-- @param width (option) Width of image.
-- @param height (option) Height of image.
function NineImage:setImage(imagePath, width, height)
    local deck = imagePath
    if type(deck) == "string" then
        deck = DeckMgr:getNineImageDeck(imagePath)
    end

    local orgWidth, orgHeight = self:getSize()
    width = width or orgWidth
    height = height or orgHeight

    self:setDeck(deck)
    self.displayWidth = deck.displayWidth
    self.displayHeight = deck.displayHeight
    self.contentPadding = deck.contentPadding

    self:setSize(width, height)
end

---
-- Set the scale to match the size.
-- Is set as the size artificially.
-- @param width Width of image.
-- @param height Height of image.
function NineImage:setSize(width, height)
    local iw, ih = self.displayWidth, self.displayHeight
    local left, top = self:getPos()
    local sclX, sclY, sclZ = width / iw, height / ih, 1

    self._scaledWidth = width
    self._scaledHeight = height
    self:setScl(sclX, sclY, sclZ)
end

---
-- Returns the dummey dimensions.
-- @return sacled width
-- @return scaled height
-- @return 0
function NineImage:getDims()
    return self._scaledWidth, self._scaledHeight, 0
end

---
-- Returns the dummey bounds.
-- @return xMin(0)
-- @return yMin(0)
-- @return zMin(0)
-- @return xMax(sacled width)
-- @return yMax(scaled height)
-- @return 0
function NineImage:getBounds()
    return 0, 0, 0, self._scaledWidth, self._scaledHeight, 0
end

---
-- Unsupported pivot.
function NineImage:setPiv(xPiv, yPiv, zPiv)
    Logger.warn("Unsupported!")
end

---
-- Returns the content rect from NinePatch.
-- @return xMin
-- @return yMin
-- @return xMax
-- @return yMax
function NineImage:getContentRect()
    local width, height = self:getSize()
    local padding = self.contentPadding
    local xMin = padding[1]
    local yMin = padding[2]
    local xMax = width - padding[3]
    local yMax = height - padding[4]
    return xMin, yMin, xMax, yMax
end

---
-- Returns the content padding from NinePatch.
-- @return paddingLeft
-- @return paddingTop
-- @return paddingRight
-- @return paddingBottom
function NineImage:getContentPadding()
    local padding = self.contentPadding
    return unpack(padding)
end

return NineImage