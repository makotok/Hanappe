----------------------------------------------------------------------------------------------------
-- Scrollable UIView class.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.lang.class"
local table = require "flower.lang.table"
local UIEvent = require "flower.widget.UIEvent"
local UIView = require "flower.widget.UIView"
local ScrollGroup = require "flower.widget.ScrollGroup"

-- class
local ScrollView = class(UIView)

---
-- Initializes the internal variables.
function ScrollView:_initInternal()
    ScrollView.__super._initInternal(self)
    self._themeName = "ScrollView"
end

---
-- Performing the initialization processing of the component.
function ScrollView:_createChildren()
    self._scrollGroup = ScrollGroup {
        size = {self:getSize()},
        themeName = self._themeName,
    }

    self:addChild(self._scrollGroup)
end

---
-- Update the ScrollGroup bounds.
function ScrollView:_updateScrollBounds()
    self._scrollGroup:setSize(self:getSize())
    self._scrollGroup:setPos(0, 0)
end

---
-- Add the content to scrollGroup.
-- @param content
function ScrollView:addContent(content)
    self._scrollGroup:addContent(content)
end

---
-- Add the content from scrollGroup.
-- @param content
function ScrollView:removeContent(content)
    self._scrollGroup:removeContent(content)
end

---
-- Add the content from scrollGroup.
-- @param contents
function ScrollView:setContents(contents)
    self._scrollGroup:setContents(contents)
end

---
-- Return the scroll size.
-- @return scroll size
function ScrollView:getScrollSize()
    return self._scrollGroup:getSize()
end

---
-- Return the scrollGroup.
-- @return scrollGroup
function ScrollView:getScrollGroup()
    return self._scrollGroup
end

---
-- Set the layout.
-- @param layout layout
function ScrollView:setLayout(layout)
    self._scrollGroup:setLayout(layout)
end

---
-- Set the coefficient of friction at the time of scrolling.
-- @param value friction
function ScrollView:setFriction(value)
    self._scrollGroup:setFriction(value)
end

---
-- Returns the coefficient of friction at the time of scrolling.
-- @return friction
function ScrollView:getFriction()
    return self._scrollGroup:getFriction()
end

---
-- Sets the horizontal and vertical scroll enabled.
-- @param horizontal horizontal scroll is enabled.
-- @param vertical vertical scroll is enabled.
function ScrollView:setScrollPolicy(horizontal, vertical)
    self._scrollGroup:setScrollPolicy(horizontal, vertical)
end

---
-- Return the scroll policy.
-- @return horizontal scroll enabled.
-- @return vertical scroll enabled.
function ScrollView:getScrollPolicy()
    return self._scrollGroup:getScrollPolicy()
end

---
-- Sets the horizontal and vertical bounce enabled.
-- @param horizontal horizontal scroll is enabled.
-- @param vertical vertical scroll is enabled.
function ScrollView:setBouncePolicy(horizontal, vertical)
    self._scrollGroup:setBouncePolicy(horizontal, vertical)
end

---
-- Returns whether horizontal bouncing is enabled.
-- @return horizontal bouncing enabled
-- @return vertical bouncing enabled
function ScrollView:getBouncePolicy()
    return self._scrollGroup:getBouncePolicy()
end

---
-- Scroll to the specified location.
-- @param x position of the x
-- @param y position of the x
-- @param sec second
-- @param mode EaseType
-- @param callback (optional) allows callback notification when animation completes.
function ScrollView:scrollTo(x, y, sec, mode, callback)
    self._scrollGroup:scrollTo(x, y, sec, mode, callback)
end

---
-- This event handler is called when resize.
-- @param e Resize Event
function ScrollView:onResize(e)
    ScrollView.__super.onResize(self, e)
    self:_updateScrollBounds()
end

return ScrollView