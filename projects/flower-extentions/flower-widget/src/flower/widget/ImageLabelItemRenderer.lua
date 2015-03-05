----------------------------------------------------------------------------------------------------
-- This is the base class of the item renderer.
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
    self:_createLayout()
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
-- Create the default layout.
function ImageLabelItemRenderer:_createLayout()
    if self._layout then
        return
    end
    self:setLayout(BoxLayout {
        direction = "horizontal",
        align = {"left", "center"},
        layoutPolicy = {"none", "none"},
        padding = self:getStyle("layoutPadding"),
    })
end

---
-- Update the image.
function ImageLabelItemRenderer:_updateImage()
    self._image:setVisible(self._data ~= nil)

    if self._data then
        if self._imageField and self._data[self._imageField] then
            self._image:setTexture(self._data[self._imageField])
        end
        if self._imageSize and #self._imageSize == 2 then
            self._image:setSize(unpack(self._imageSize))
        end
    end
end

---
-- Update the Display objects.
function ImageLabelItemRenderer:updateDisplay()
    ImageLabelItemRenderer.__super.updateDisplay(self)
    self:_updateImage()
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
    self._imageSize = {width, height}
    self:invalidateDisplay()
end

return ImageLabelItemRenderer
