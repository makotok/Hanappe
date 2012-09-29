--------------------------------------------------------------------------------
-- This is a class to draw the text.<br>
-- See MOAITextBox.<br>
-- Base Classes => DisplayObject, Resizable<br>
--
-- @auther Makoto
-- @class table
-- @name TextLabel
--------------------------------------------------------------------------------

-- import
local table                     = require("hp/lang/table")
local class                     = require("hp/lang/class")
local DisplayObject             = require("hp/display/DisplayObject")
local Resizable                 = require("hp/display/Resizable")
local FontManager               = require("hp/manager/FontManager")

-- class
local M                         = class(DisplayObject, Resizable)
local MOAITextBoxInterface      = MOAITextBox.getInterfaceTable()
M.MOAI_CLASS                    = MOAITextBox

-- constraints
M.DEFAULT_FONT                  = "fonts/VL-PGothic.ttf"
M.DEFAULT_TEXT_SIZE             = 24
M.DEFAULT_COLOR                 = {1, 1, 1, 1}

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}
    params = type(params) == "string" and {text = params} or params

    self:setFont(M.DEFAULT_FONT)
    self:setTextSize(M.DEFAULT_TEXT_SIZE)
    self:setColor(unpack(M.DEFAULT_COLOR))
    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Set the text size.<br>
-- @param width
-- @param height
--------------------------------------------------------------------------------
function M:setSize(width, height)
    width = width or self:getWidth()
    height = height or self:getHeight()
    
    local left, top = self:getPos()
    self:setRect(-width / 2, -height / 2, width / 2, height / 2)
    self:setPos(left, top)
end

--------------------------------------------------------------------------------
-- Set the text size.<br>
-- @param points size.
-- @param dpi (deprecated)Resolution.
--------------------------------------------------------------------------------
function M:setTextSize(points, dpi)
    self._textSizePoints = points
    self._textSizeDpi = dpi
    MOAITextBoxInterface.setTextSize(self, points, dpi)
end

--------------------------------------------------------------------------------
-- Returns the text size.<br>
-- @return points, dpi
--------------------------------------------------------------------------------
function M:getTextSize()
    return self._textSizePoints, self._textSizeDpi
end

--------------------------------------------------------------------------------
-- Set the text.<br>
-- @param text text.
--------------------------------------------------------------------------------
function M:setText(text)
    self:setString(text)
end

--------------------------------------------------------------------------------
-- Set the font.<br>
-- @param font font.
--------------------------------------------------------------------------------
function M:setFont(font)
    if type(font) == "string" then
        font = FontManager:request(font)
    end
    MOAITextBoxInterface.setFont(self, font)
end
--------------------------------------------------------------------------------
-- MOAITextBox does not work for the visible, and hide in a pseudo-alpha.<br>
-- TODO:Will be removed in MOAI SDK V1.2.
--------------------------------------------------------------------------------
function M:setVisible(value)
    local r, g, b, a = self:getColor()
    a = value and 1 or 0
    self:setColor(r, g, b, a)
    MOAITextBoxInterface.setVisible(self, value)
end

return M