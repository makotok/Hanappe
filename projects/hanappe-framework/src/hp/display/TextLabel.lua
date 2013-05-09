--------------------------------------------------------------------------------
-- This is a class to draw the text.
-- See MOAITextBox.<br>
-- Base Classes => DisplayObject, Resizable
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
M.DEFAULT_CHARCODES             = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,:;!?()&/-"
M.DEFAULT_TEXT_SIZE             = 24
M.DEFAULT_COLOR                 = {1, 1, 1, 1}

M.HORIZOTAL_ALIGNS = {
    left    = MOAITextBox.LEFT_JUSTIFY,
    center  = MOAITextBox.CENTER_JUSTIFY,
    right   = MOAITextBox.RIGHT_JUSTIFY,
}

M.VERTICAL_ALIGNS = {
    top     = MOAITextBox.LEFT_JUSTIFY,
    center  = MOAITextBox.CENTER_JUSTIFY,
    bottom  = MOAITextBox.RIGHT_JUSTIFY,
}

--- Max width for fit size.
M.MAX_FIT_WIDTH = 10000000

--- Max height for fit size.
M.MAX_FIT_HEIGHT = 10000000

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
-- Set the text size.
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
-- Set the text size.
-- @param points size.
-- @param dpi (deprecated)Resolution.
--------------------------------------------------------------------------------
function M:setTextSize(points, dpi)
    self._textSizePoints = points
    self._textSizeDpi = dpi
    MOAITextBoxInterface.setTextSize(self, points, dpi)
end

--------------------------------------------------------------------------------
-- Returns the text size.
-- @return points, dpi
--------------------------------------------------------------------------------
function M:getTextSize()
    return self._textSizePoints, self._textSizeDpi
end

--------------------------------------------------------------------------------
-- Set the text.
-- @param text text.
--------------------------------------------------------------------------------
function M:setText(text)
    self:setString(text)
end

--------------------------------------------------------------------------------
-- Set the font.
-- @param font font.
--------------------------------------------------------------------------------
function M:setFont(font)
    if type(font) == "string" then
        font = FontManager:request(font, self._textSizePoints or M.DEFAULT_TEXT_SIZE, M.DEFAULT_CHARCODES, self._textSizeDpi)
    end
    MOAITextBoxInterface.setFont(self, font)
end

--------------------------------------------------------------------------------
-- Set the Alignments.
--------------------------------------------------------------------------------
function M:setAlign(horizotalAlign, verticalAlign)
    local h, v = M.HORIZOTAL_ALIGNS[horizotalAlign], M.VERTICAL_ALIGNS[verticalAlign]
    self:setAlignment(h, v)
end

--------------------------------------------------------------------------------
-- Sets the fit size.
-- @param lenfth (Option)Length of the text.
--------------------------------------------------------------------------------
function M:fitSize(length)
    self:setRect(0, 0, M.MAX_FIT_WIDTH, M.MAX_FIT_HEIGHT)
    
    length = length or 1000000
    local padding = 2
    local left, top, right, bottom = self:getStringBounds(1, length)
    local width, height = right - left + padding, bottom - top + padding
    width = width % 2 == 0 and width or width + 1
    height = height % 2 == 0 and height or height + 1

    self:setSize(width, height)
end

--------------------------------------------------------------------------------
-- Sets the fit height.
-- @param lenfth (Option)Length of the text.
--------------------------------------------------------------------------------
function M:fitHeight(length)
    local w, h, d = self:getDims()
    self:setRect(0, 0, w, M.MAX_FIT_HEIGHT)
    
    length = length or 1000000
    local padding = 2
    local left, top, right, bottom = self:getStringBounds(1, length)
    local width, height = right - left + padding, bottom - top + padding
    width = width % 2 == 0 and width or width + 1
    height = height % 2 == 0 and height or height + 1

    self:setHeight(height)
end

return M