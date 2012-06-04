local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local Resizable = require("hp/display/Resizable")
local FontManager = require("hp/manager/FontManager")

--------------------------------------------------------------------------------
-- This is a class to draw the text.<br>
-- See MOAITextBox.<br>
-- Extends : DisplayObject, Resizable<br>
-- @class table
-- @name TextLabel
--------------------------------------------------------------------------------
local M = class(DisplayObject, Resizable)

M.MOAI_CLASS = MOAITextBox

local interface = MOAITextBox.getInterfaceTable()

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}

    local font = FontManager:request(params.font)
    self:setFont(font)
    self:setTextSize(FontManager.config.textSize)
    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.<br>
--      (params:width, height, textSize, text)
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.width and params.height then
        self:setSize(params.width, params.height)
    end
    if params.textSize then
        self:setTextSize(params.textSize)
    end
    if params.text then
        self:setText(params.text)
    end
    DisplayObject.copyParams(self, params)
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
    self:setPrivate("textSizePoints", points)
    self:setPrivate("textSizeDpi", dpi)
    interface.setTextSize(self, points, dpi)
end

--------------------------------------------------------------------------------
-- Returns the text size.<br>
-- @return points, dpi
--------------------------------------------------------------------------------
function M:getTextSize()
    return self:getPrivate("textSizePoints"), self:getPrivate("textSizeDpi")
end

--------------------------------------------------------------------------------
-- Set the text.<br>
-- @param text text.
--------------------------------------------------------------------------------
function M:setText(text)
    self:setString(text)
end

--------------------------------------------------------------------------------
-- MOAITextBox does not work for the visible, and hide in a pseudo-alpha.<br>
-- TODO:Will be removed in MOAI SDK V1.2.
--------------------------------------------------------------------------------
function M:setVisible(value)
    local r, g, b, a = self:getColor()
    a = value and 1 or 0
    self:setColor(r, g, b, a)
    interface.setVisible(self, value)
end

return M