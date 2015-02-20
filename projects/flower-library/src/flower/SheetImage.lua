----------------------------------------------------------------------------------------------------
-- Class that displays an image from a sheet of images, supporting TexturePacker's format.
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
local Resources = require "flower.Resources"
local DisplayObject = require "flower.DisplayObject"
local DeckMgr = require "flower.DeckMgr"

-- class
local SheetImage = class(DisplayObject)

---
-- Constructor.
-- @param texture Texture path, or texture
-- @param sizeX (option) The size of the sheet
-- @param sizeY (option) The size of the sheet
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function SheetImage:init(texture, sizeX, sizeY, spacing, margin, flipX, flipY)
    SheetImage.__super.init(self)

    self:setTexture(texture)
    self.sheetSize = 0
    self.sheetNames = {}

    if sizeX and sizeY then
        self:setSheetSize(sizeX, sizeY, spacing, margin, flipX, flipY)
    end
end

---
-- Sets the texture.
-- @param texture Texture path, or texture
function SheetImage:setTexture(texture)
    self.texture = Resources.getTexture(texture)
    SheetImage.__index.setTexture(self, self.texture)
end

---
-- Parses TexturePacker atlases and sets up the texture as a deck of images in the atlas.
-- @param atlas Texture atlas
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function SheetImage:setTextureAtlas(atlas, flipX, flipY)
    local deck = DeckMgr:getAtlasDeck(atlas, flipX, flipY)
    self:setDeck(deck)
    self.sheetSize = #deck.frames
    self.sheetNames = deck.names
end

---
-- Sets the size of the sheet (for quad-tiled texture atlas sheets).
-- @param sizeX The size of the sheet
-- @param sizeY The size of the sheet
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function SheetImage:setSheetSize(sizeX, sizeY, spacing, margin, flipX, flipY)
    spacing = spacing or 0
    margin = margin or 0
    local tw, th = self.texture:getSize()
    local tileW = math.floor((tw - margin - spacing * sizeX) / sizeX)
    local tileH = math.floor((th - margin - spacing * sizeY) / sizeY)
    self:setTileSize(tileW, tileH, spacing, margin, flipX, flipY)
end

---
-- Sets the sheet depending on the size of the tile.
-- @param tileWidth The width of the tile
-- @param tileHeight The height of the tile
-- @param spacing (option)Spacing of the tiles
-- @param margin (option)Margin of the sheet
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function SheetImage:setTileSize(tileWidth, tileHeight, spacing, margin, flipX, flipY)
    local tw, th = self.texture:getSize()
    local gridFlag = self.grid and true or false
    local deck = DeckMgr:getTileImageDeck(tw, th, tileWidth, tileHeight, spacing or 0, margin or 0, gridFlag, flipX, flipY)
    self:setDeck(deck)
    self.sheetSize = deck.sheetSize
    self.sheetNames = {}
end

---
-- Sets the texture flip.
-- @param flipX (option)flipX
-- @param flipY (option)flipY
function SheetImage:setFlip(flipX, flipY)
    local deck = self:getDeck()
    deck = DeckMgr:getTileImageDeck(deck.textureWidth, deck.textureHeight, deck.tileWidth, deck.tileHeight,
        deck.spacing, deck.margin, deck.gridFlag, flipX, flipY)
    self:setDeck(deck)
end

---
-- Sets the sheet's image index via a given subtexture name (for TexturePacker).
-- @param name Sheet name.
function SheetImage:setIndexByName(name)
    if type(name) == "string" then
        local index = self.sheetNames[name] or self:getIndex()
        self:setIndex(index)
    elseif type(name) == "number" then
        self:setIndex(index)
    end
end

return SheetImage