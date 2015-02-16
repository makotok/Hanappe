----------------------------------------------------------------------------------------------------
-- This class is an SheetImage that can be pressed.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local SheetImage = require "flower.core.SheetImage"
local UIEvent = require "flower.widget.UIEvent"
local Button = require "flower.widget.Button"

-- class
local SheetButton = class(Button)

--- Style: textureSheets
SheetButton.STYLE_TEXTURE_SHEETS = "textureSheets"

---
-- Initializes the internal variables.
function SheetButton:_initInternal()
    SheetButton.__super._initInternal(self)
    self._themeName = "SheetButton"
end

---
-- Create the buttonImage.
function SheetButton:_createButtonImage()
    if self._buttonImage then
        return
    end

    local textureSheets = assert(self:getStyle(SheetButton.STYLE_TEXTURE_SHEETS))
    self._buttonImage = SheetImage(textureSheets .. ".png")
    self._buttonImage:setTextureAtlas(textureSheets .. ".lua")
    self:addChild(self._buttonImage)
end

---
-- Update the buttonImage.
function SheetButton:updateButtonImage()
    local imagePath = assert(self:getImagePath())

    self._buttonImage:setIndexByName(imagePath)
    self:setSize(self._buttonImage:getSize())
end

---
-- Sets the sheet texture's file.
-- @param filename filename
function SheetButton:setTextureSheets(filename)
    self:setStyle(SheetButton.STYLE_TEXTURE_SHEETS, filename)
    self._buttonImage:setTextureAtlas(filename .. ".lua", filename .. ".png")
    self:updateButtonImage()
end

return SheetButton
