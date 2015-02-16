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
local Panel = require "flower.widget.Panel"
local ScrollView = require "flower.widget.ScrollView"

-- class
local PanelView = class(ScrollView)

---
-- Initializes the internal variables.
function PanelView:_initInternal()
    PanelView.__super._initInternal(self)
    self._themeName = "PanelView"
end

---
-- Performing the initialization processing of the component.
function PanelView:_createChildren()
    self._backgroundPanel = Panel {
        size = {self:getSize()},
        parent = self,
        themeName = self._themeName,
    }

    PanelView.__super._createChildren(self)
end

---
-- Update the ScrollGroup bounds.
function PanelView:_updateScrollBounds()
    if self:getBackgroundVisible() then
        self._backgroundPanel:setSize(self:getSize())
        self._backgroundPanel:validateDisplay()

        local xMin, yMin, xMax, yMax = self._backgroundPanel:getContentRect()
        self._scrollGroup:setSize(xMax - xMin, yMax - yMin)
        self._scrollGroup:setPos(xMin, yMin)
        return
    end

    PanelView.__super._updateScrollBounds(self)
end

---
-- Sets the background texture path.
-- @param texture background texture path
function PanelView:setBackgroundTexture(texture)
    self._backgroundPanel:setBackgroundTexture(texture)
    self:_updateScrollBounds()
end

---
-- Returns the background texture path.
-- @param texture background texture path
function PanelView:getBackgroundTexture()
    return self._backgroundPanel:getBackgroundTexture()
end

---
-- Set the visible of the background.
-- @param visible visible
function PanelView:setBackgroundVisible(visible)
    self._backgroundPanel:setBackgroundVisible(visible)
    self:_updateScrollBounds()
end

---
-- Returns the visible of the background.
-- @return visible
function PanelView:getBackgroundVisible()
    return self._backgroundPanel:getBackgroundVisible()
end

return PanelView