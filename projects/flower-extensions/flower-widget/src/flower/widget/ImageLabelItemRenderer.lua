----------------------------------------------------------------------------------------------------
-- This is the base class of the item renderer.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.LabelItemRenderer.html">LabelItemRenderer</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local Image = require "flower.Image"
local UILabel = require "flower.widget.UILabel"
local UILayout = require "flower.widget.UILayout"
local LabelItemRenderer = require "flower.widget.LabelItemRenderer"
local BoxLayout = require "flower.widget.BoxLayout"

-- class
local ImageLabelItemRenderer = class(LabelItemRenderer)

---
-- Initialize a variables
function ImageLabelItemRenderer:_initInternal()
    ImageLabelItemRenderer.__super._initInternal(self)
    self._themeName = "ImageLabelItemRenderer"
    self._image = nil
    self._imageField = nil
    self._imageSize = nil
    self._textLabel = nil
end

---
-- Create the renderer objects.
function ImageLabelItemRenderer:_createRenderers()
    self:_createImage()
    ImageLabelItemRenderer.__super._createRenderers(self)
end

---
-- Create the image.
function ImageLabelItemRenderer:_createImage()
    if self._image then
        return
    end
    self._image = Image()
    self:addChild(self._image)
end

---
-- Update the image.
function ImageLabelItemRenderer:_updateImage()
    if not self._dataIndex then
        return
    end

    self._image:setVisible(self._data ~= nil)

    if self._data then
        if self._imageField and self._data[self._imageField] then
            self._image:setTexture(self._data[self._imageField])
        end
        if self._imageSize and #self._imageSize == 2 then
            self._image:setSize(unpack(self._imageSize))
        end

        self._image:setPos(5, (self:getHeight() - self._image:getHeight()) / 2)
    end
end

---
-- Update the textLabel.
function ImageLabelItemRenderer:_updateTextLabel()
    if not self._dataIndex then
        return
    end

    ImageLabelItemRenderer.__super._updateTextLabel(self)

    self._textLabel:setLeft(self._image:getRight())
    self._textLabel:setWidth(self:getWidth() - self._image:getWidth())
end

---
-- Update the Display objects.
function ImageLabelItemRenderer:updateDisplay()
    self:_updateImage()
    ImageLabelItemRenderer.__super.updateDisplay(self)
end

---
-- Sets the image field of the data.
-- @param imageField field of the image.
function ImageLabelItemRenderer:setImageField(imageField)
    if self._imageField ~= imageField then
        self._imageField = imageField
        self:invalidateDisplay()
    end
end

---
-- Sets the size of the image.
-- @param width Width of the image.
-- @param height Hidth of the image.
function ImageLabelItemRenderer:setImageSize(width, height)
    local oldW, oldH = self._imageSize and unpack(self._imageSize)
    if oldW ~= width or oldH ~= height then
        self._imageSize = {width, height}
        self:invalidateDisplay()
    end
end

return ImageLabelItemRenderer
