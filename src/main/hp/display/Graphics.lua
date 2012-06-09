local table = require("hp/lang/table")
local class = require("hp/lang/class")
local DisplayObject = require("hp/display/DisplayObject")
local Resizable = require("hp/display/Resizable")

--------------------------------------------------------------------------------
-- The DisplayObject that has graphics capabilities.<br>
-- You can call in the method chain MOAIDraw.<br>
-- See MOAIDraw.<br>
-- <br>
-- Extends -> DisplayObject, Resizable<br>
-- <code>
-- example)<br>
-- local g = Graphics({width = 100, height = 100})<br>
-- g:setPenColor(1, 0, 0, 1):fillRect():drawRect()<br>
-- g:setPenColor(0, 1, 0, 1):fillRect(25, 25, 50, 50):drawRect(25, 25, 50, 50)<br>
-- g:setLayer(layer)<br>
-- </code>
--
-- @class table
-- @name Graphics
--------------------------------------------------------------------------------
local M = class(DisplayObject, Resizable)

--------------------------------------------------------------------------------
-- The constructor.
-- @param params (option)Parameter is set to Object.<br>
--      (params:width, height)
--------------------------------------------------------------------------------
function M:init(params)
    DisplayObject.init(self)

    params = params or {}

    local deck = MOAIScriptDeck.new()
    self:setDeck(deck)
    self.deck = deck
    self.commands = {}

    deck:setDrawCallback(
        function(index, xOff, yOff, xFlip, yFlip)
            MOAIGfxDevice.setPenColor(self:getRed(), self:getGreen(), self:getBlue(), self:getAlpha())
            MOAIGfxDevice.setPenWidth(1)
            MOAIGfxDevice.setPointSize(1)
            for i, gfx in ipairs(self.commands) do
                gfx(self)
            end
        end
    )
    
    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Based on the parameters, and then call the function setter.
-- @param params Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.width and params.height then
        self:setSize(params.width, params.height)
    end
    DisplayObject.copyParams(self, params)
end

--------------------------------------------------------------------------------
-- Set the height and width.<br>
-- @param width width
-- @param height height
--------------------------------------------------------------------------------
function M:setSize(width, height)
    width = width or self:getWidth()
    height = height or self:getHeight()
    
    local left, top = self:getPos()
    self.deck:setRect(0, 0, width, height)
    self:setPiv(width / 2, height / 2, 0)
    self:setPos(left, top)
end


---------------------------------------
-- Draw a circle.<br>
-- @param x Model x
-- @param y Model y
-- @param r Radius
-- @param steps Number of points
-- @return self
---------------------------------------
function M:drawCircle(x, y, r, steps)
    steps = steps and steps or 360
    local command = function(self)
        if x and y and r and steps then
            MOAIDraw.drawCircle(x + r, y + r, r, steps)
        else
            local rw = math.min(self:getWidth(), self:getHeight()) / 2
            MOAIDraw.drawCircle(rw, rw, rw, 360)
        end
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Draw an ellipse.<br>
-- @param x Model x
-- @param y Model y
-- @param xRad Radius
-- @param yRad Radius
-- @param steps Number of points
-- @return self
---------------------------------------
function M:drawEllipse(x, y, xRad, yRad, steps)
    steps = steps and steps or 360
    local command = function(self)
        if x and y and xRad and yRad and steps then
            MOAIDraw.drawEllipse(x + xRad, y + yRad, xRad, yRad, steps)
        else
            local rw, rh = self:getWidth() / 2, self:getHeight() / 2
            MOAIDraw.drawEllipse(rw, rh, rw, rh, steps)
        end
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Draws a line.<br>
-- @param ... Coordinates of the point
-- @return self
---------------------------------------
function M:drawLine(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.drawLine(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Draws a point.
-- @param ... Coordinates of the point
-- @return self
---------------------------------------
function M:drawPoints(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.drawPoints(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Draw a ray.
-- @param x Model x
-- @param y Model y
-- @param dx Line length
-- @param dy Line length
-- @return self
---------------------------------------
function M:drawRay(x, y, dx, dy)
    local command = function(self)
        if x and y and dx and dy then
            MOAIDraw.drawRay(x, y, dx, dy)
        else
            MOAIDraw.drawRay(0, 0, self:getWidth(), self:getHeight())
        end
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Draw a rectangle.
-- @param x0 Model x0
-- @param y0 Model y0
-- @param x1 Model x1
-- @param y1 Model y1
-- @return self
---------------------------------------
function M:drawRect(x0, y0, x1, y1)
    local command = function(self)
        if x0 and y0 and x1 and y1 then
            MOAIDraw.drawRect(x0, y0, x1, y1)
        else
            MOAIDraw.drawRect(0, 0, self:getWidth(), self:getHeight())
        end
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Fill the circle.
-- @param x X of model
-- @param y Y of model
-- @param r Radius
-- @param steps Number of points
-- @return self
---------------------------------------
function M:fillCircle(x, y, r, steps)
    steps = steps or 360
    local command = function(self)
        if x and y and r and steps then
            MOAIDraw.fillCircle(x + r, y + r, r, steps)
        else
            local r = math.min(self:getWidth(), self:getHeight()) / 2
            MOAIDraw.fillCircle(r, r, r, steps)
        end
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Fill an ellipse.
-- @param x X of model
-- @param y Y of model
-- @param xRad Radius
-- @param yRad Radius
-- @param steps steps Number of points
-- @return self
---------------------------------------
function M:fillEllipse(x, y, xRad, yRad, steps)
    steps = steps or 360
    local command = function(self)
        if x and y and xRad and yRad then
            MOAIDraw.fillEllipse(x + xRad, y + yRad, xRad, yRad, steps)
        else
            local rw, rh = self:getWidth() / 2, self:getHeight() / 2
            MOAIDraw.fillEllipse(rw, rh, rw, rh, steps)
        end
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Fills the triangle.
-- @param ... point(x, y)
-- @return self
---------------------------------------
function M:fillFan(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.fillFan(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Fill a rectangle.
-- @param x0 X0 of model
-- @param y0 Y0 of model
-- @param x1 X1 of model
-- @param y1 Y1 of model
-- @return self
---------------------------------------
function M:fillRect(x0, y0, x1, y1)
    local command = function(self)
        if x0 and y0 and x1 and y1 then
            MOAIDraw.fillRect(x0, y0, x1, y1)
        else
            MOAIDraw.fillRect(0, 0, self:getWidth(), self:getHeight())
        end
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Sets the color of the pen.<br>
-- Will be reflected in the drawing functions.
-- @param r red
-- @param g green
-- @param b blue
-- @param a alpha
-- @return self
---------------------------------------
function M:setPenColor(r, g, b, a)
    a = a and a or 1
    local command = function(self)
        local red = r * self:getRed()
        local green = g * self:getGreen()
        local blue = b * self:getBlue()
        local alpha = a * self:getAlpha()
        MOAIGfxDevice.setPenColor(red, green, blue, alpha)
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Set the size of the pen that you specify.<br>
-- Will be reflected in the drawing functions.
-- @param width width
-- @return self
---------------------------------------
function M:setPenWidth(width)
    local command = function(self)
        MOAIGfxDevice.setPenWidth(width)
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Set the size of the specified point.<br>
-- Will be reflected in the drawing functions.
-- @param size
-- @return self
---------------------------------------
function M:setPointSize(size)
    local command = function(self)
        MOAIGfxDevice.setPointSize(size)
    end
    table.insert(self.commands, command)
    return self
end

---------------------------------------
-- Clears the drawing operations.
-- @return self
---------------------------------------
function M:clear()
    self.commands = {}
    return self
end

return M