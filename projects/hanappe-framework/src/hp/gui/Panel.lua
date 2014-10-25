--------------------------------------------------------------------------------
-- This is a simple panel.
--------------------------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local NinePatch         = require "hp/display/NinePatch"
local TextLabel         = require "hp/display/TextLabel"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"

-- class define
local M                 = class(Component)
local super             = Component

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
function M:initInternal()
    super.initInternal(self)
    self._themeName = "Panel"
end

--------------------------------------------------------------------------------
-- Create a child objects.
--------------------------------------------------------------------------------
function M:createChildren()
    local backgroundSkinClass = self:getStyle("backgroundSkinClass")
    self._background = backgroundSkinClass()
    self._background:setTexture(self:getStyle("backgroundSkin"))
    self:addChild(self._background)
end

--------------------------------------------------------------------------------
-- Update the display.
--------------------------------------------------------------------------------
function M:updateDisplay()
    local background = self._background
    background:setColor(unpack(self:getStyle("backgroundColor")))
    background:setTexture(self:getStyle("backgroundSkin"))
end

--------------------------------------------------------------------------------
-- This event handler is called when resizing.
-- @param e resize event
--------------------------------------------------------------------------------
function M:resizeHandler(e)
    self._background:setSize(e.newWidth, e.newHeight)
end

return M