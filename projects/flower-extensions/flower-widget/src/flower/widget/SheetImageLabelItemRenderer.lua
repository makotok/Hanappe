----------------------------------------------------------------------------------------------------
-- This is the base class of the item renderer.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local SheetImage = require "flower.SheetImage"
local LabelItemRenderer = require "flower.widget.LabelItemRenderer"

-- class
local SheetImageLabelItemRenderer = class(LabelItemRenderer)

--- Style: sheetTexture
SheetImageLabelItemRenderer.STYLE_SHEET_TEXTURE = "sheetTexture"

--- Style: sheetTileSize
SheetImageLabelItemRenderer.STYLE_SHEET_TILE_SIZE = "sheetTileSize"

---
-- Initialize a variables
function SheetImageLabelItemRenderer:_initInternal()
    SheetImageLabelItemRenderer.__super._initInternal(self)
    self._themeName = "SheetImageLabelItemRenderer"
    self._image = nil
    self._imageField = nil
    self._imageSize = nil
    self._textLabel = nil
end

---
-- Create the renderer objects.
function SheetImageLabelItemRenderer:_createRenderers()
    self:_createImage()
    SheetImageLabelItemRenderer.__super._createRenderers(self)
end

---
-- Create the image.
function SheetImageLabelItemRenderer:_createImage()
    if self._image then
        return
    end
    self._image = SheetImage(self:getSheetTexture())
    self._image:setTileSize(self:getSheetTileSize())
    self:addChild(self._image)
end

---
-- Update the image.
function SheetImageLabelItemRenderer:_updateImage()
    self._image:setVisible(self._data ~= nil)

    if self._data then
        if self._sheetIndexField and self._data[self._sheetIndexField] then
            self._image:setIndex(self._data[self._sheetIndexField])
        end

        self._image:setPos(5, (self:getHeight() - self._image:getHeight()) / 2)
    end
end

---
-- Update the textLabel.
function SheetImageLabelItemRenderer:_updateTextLabel()
    self._textLabel:setLeft(self._image:getRight())
    self._textLabel:setSize(self:getWidth() - self._image:getWidth(), self:getHeight())
    self._textLabel:setVisible(self._data ~= nil)

    if self._data then
        local text = self._labelField and self._data[self._labelField] or self._data
        text = type(text) == "string" and text or tostring(text)
        self._textLabel:setText(text)
    end
end

---
-- Update the Display objects.
function SheetImageLabelItemRenderer:updateDisplay()
    self:_updateImage()
    SheetImageLabelItemRenderer.__super.updateDisplay(self)
end

---
-- Sets the texture of the sheet.
-- @param sheetTexture texture.
function SheetImageLabelItemRenderer:setSheetTexture(sheetTexture)
    if self:getSheetTexture() ~= sheetTexture then
        self:setStyle(SheetImageLabelItemRenderer.STYLE_SHEET_TEXTURE, sheetTexture)
        self._image:setTexture(self:getSheetTexture())
    end
end

---
-- Returns the sheet texture.
-- @return Sheet texture.
function SheetImageLabelItemRenderer:getSheetTexture()
    return self:getStyle(SheetImageLabelItemRenderer.STYLE_SHEET_TEXTURE)
end

---
-- Sets the index field of the sheet.
-- @param sheetIndexField field of the sheet.
function SheetImageLabelItemRenderer:setSheetIndexField(sheetIndexField)
    if self._sheetIndexField ~= sheetIndexField then
        self._sheetIndexField = sheetIndexField
        self:invalidateDisplay()
    end
end

---
-- Sets the size of the sheet.
-- @param width Width of the sheet.
-- @param height Hidth of the sheet.
function SheetImageLabelItemRenderer:setSheetTileSize(width, height)
    local oldW, oldH = unpack(self:getStyle(SheetImageLabelItemRenderer.STYLE_SHEET_TILE_SIZE))
    if oldW ~= width or oldH ~= height then
        self:setStyle(SheetImageLabelItemRenderer.STYLE_SHEET_TILE_SIZE, {width or 0, height or 0})
        self._image:setTileSize(width, height)
    end
end

---
-- Sets the size of the sheet.
-- @return Width of the sheet.
-- @return Hidth of the sheet.
function SheetImageLabelItemRenderer:getSheetTileSize()
    return unpack(self:getStyle(SheetImageLabelItemRenderer.STYLE_SHEET_TILE_SIZE))
end

return SheetImageLabelItemRenderer
