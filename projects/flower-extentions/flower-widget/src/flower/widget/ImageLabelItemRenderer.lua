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
local BaseItemRenderer = require "flower.widget.BaseItemRenderer"
local BoxLayout = require "flower.widget.BoxLayout"

-- class
local ImageLabelItemRenderer = class(BaseItemRenderer)

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
-- Initialize a variables
function ImageLabelItemRenderer:_createChildren()
    ImageLabelItemRenderer.__super._createChildren(self)

    self._image = Image()
    self:addChild(self._image)

    self._textLabel = UILabel {
        themeName = self:getThemeName(),
        parent = self,
    }

    self:setLayout(BoxLayout {
        direction = "horizontal",
        align = {"left", "center"},
        layoutPolicy = {"none", "none"},
    })
end

function ImageLabelItemRenderer:updateDisplay()
    ImageLabelItemRenderer.__super.updateDisplay(self)

    self._image:setVisible(self._data ~= nil)
    
    self._textLabel:setSize(self:getSize())
    self._textLabel:setVisible(self._data ~= nil)

    if self._data then
        if self._imageField and self._data[self._imageField] then
            self._image:setTexture(self._data[self._imageField])
        end
        if self._imageSize and #self._imageSize == 2 then
            self._image:setSize(unpack(self._imageSize))
        end

        local text = self._dataField and self._data[self._dataField] or self._data
        text = type(text) == "string" and text or tostring(text)
        self._textLabel:setText(text)
    end
end

---
-- Set the data field.
-- @param imageField field of image.
function ImageLabelItemRenderer:setImageField(imageField)
    if self._imageField ~= imageField then
        self._imageField = imageField
        self:invalidateDisplay()
    end
end

---
-- Set the data field.
-- @param dataField field of data.
function ImageLabelItemRenderer:setImageSize(width, height)
    self._imageSize = {width, height}
    self:invalidateDisplay()
end

return ImageLabelItemRenderer
