----------------------------------------------------------------------------------------------------
-- It is the only class to display the panel.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.widget.UIComponent.html">UIComponent</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local NineImage = require "flower.NineImage"
local UIEvent = require "flower.widget.UIEvent"
local UIComponent = require "flower.widget.UIComponent"

-- class
local Panel = class(UIComponent)

--- Style: backgroundTexture
Panel.STYLE_BACKGROUND_TEXTURE = "backgroundTexture"

--- Style: backgroundVisible
Panel.STYLE_BACKGROUND_VISIBLE = "backgroundVisible"

---
-- Initializes the internal variables.
function Panel:_initInternal()
    Panel.__super._initInternal(self)
    self._themeName = "Panel"
end

---
-- Create a children object.
function Panel:_createChildren()
    Panel.__super._createChildren(self)
    self:_createBackgroundImage()
end

---
-- Create an image of the background
function Panel:_createBackgroundImage()
    if self._backgroundImage then
        return
    end

    local texture = self:getBackgroundTexture()
    self._backgroundImage = NineImage(texture)
    self:addChild(self._backgroundImage)
end

---
-- Update the backgroundImage.
function Panel:_updateBackgroundImage()
    self._backgroundImage:setImage(self:getBackgroundTexture())
    self._backgroundImage:setSize(self:getSize())
    self._backgroundImage:setVisible(self:getBackgroundVisible())
end

---
-- Update the display objects.
function Panel:updateDisplay()
    Panel.__super.updateDisplay(self)
    self:_updateBackgroundImage()
end

---
-- Sets the background texture path.
-- @param texture background texture path
function Panel:setBackgroundTexture(texture)
    self:setStyle(Panel.STYLE_BACKGROUND_TEXTURE, texture)
    self:invalidate()
end

---
-- Returns the background texture path.
-- @param texture background texture path
function Panel:getBackgroundTexture()
    return self:getStyle(Panel.STYLE_BACKGROUND_TEXTURE)
end

---
-- Set the visible of the background.
-- @param visible visible
function Panel:setBackgroundVisible(visible)
    self:setStyle(Panel.STYLE_BACKGROUND_VISIBLE, visible)
    self:invalidate()
end

---
-- Returns the visible of the background.
-- @return visible
function Panel:getBackgroundVisible()
    local visible = self:getStyle(Panel.STYLE_BACKGROUND_VISIBLE)
    if visible ~= nil then
        return visible
    end
    return true
end

---
-- Returns the content rect from backgroundImage.
-- @return xMin
-- @return yMin
-- @return xMax
-- @return yMax
function Panel:getContentRect()
    return self._backgroundImage:getContentRect()
end

---
-- Returns the content padding from backgroundImage.
-- @return paddingLeft
-- @return paddingTop
-- @return paddingRight
-- @return paddingBottom
function Panel:getContentPadding()
    return self._backgroundImage:getContentPadding()
end

return Panel