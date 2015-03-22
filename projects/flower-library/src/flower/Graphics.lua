----------------------------------------------------------------------------------------------------
-- The DisplayObject that has graphics capabilities.
-- You can call in the method chain MOAIDraw.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.DrawableObject.html">DrawableObject</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Config = require "flower.Config"
local DrawableObject = require "flower.DrawableObject"

-- class
local Graphics = class(DrawableObject)

-- const
Graphics.DEFAULT_STEPS = 32

---
-- The constructor.
function Graphics:init(width, height)
    Graphics.__super.init(self, width, height)
    self.commands = {}
end

---
-- This is the function called when drawing.
-- @param index index of DrawCallback.
-- @param xOff xOff of DrawCallback.
-- @param yOff yOff of DrawCallback.
-- @param xFlip xFlip of DrawCallback.
-- @param yFlip yFlip of the Prop.
function Graphics:onDraw(index, xOff, yOff, xFlip, yFlip)
    if #self.commands == 0 then
        return
    end
    
    MOAIGfxDevice.setPenColor(self:getColor())
    MOAIGfxDevice.setPenWidth(1)
    MOAIGfxDevice.setPointSize(1)
    for i, func in ipairs(self.commands) do
        func(self)
    end
end

---
-- Draw a circle.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param r Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
function Graphics:drawCircle(x, y, r, steps)
    steps = steps or Graphics.DEFAULT_STEPS
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

---
-- Draw an ellipse.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param xRad Radius.(Not in diameter.)
-- @param yRad Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
function Graphics:drawEllipse(x, y, xRad, yRad, steps)
    steps = steps or Graphics.DEFAULT_STEPS
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

---
-- Draws a line.
-- @param ... Position of the points(x0, y0).
-- @return self
function Graphics:drawLine(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.drawLine(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

---
-- Draws a point.
-- @param ... Position of the points(x0, y0).
-- @return self
function Graphics:drawPoints(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.drawPoints(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

---
-- Draw a ray.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param dx Direction.
-- @param dy Direction.
-- @return self
function Graphics:drawRay(x, y, dx, dy)
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

---
-- Draw a rectangle.
-- @param x0 Position of the left.
-- @param y0 Position of the top.
-- @param x1 Position of the right.
-- @param y1 Position of the bottom
-- @return self
function Graphics:drawRect(x0, y0, x1, y1)
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

---
-- Draw a callback.
-- @param callback callback function.
-- @return self
function Graphics:drawCallback(callback)
    table.insert(self.commands, callback)
    return self
end

---
-- Fill the circle.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param r Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
function Graphics:fillCircle(x, y, r, steps)
    steps = steps or Graphics.DEFAULT_STEPS
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

---
-- Fill an ellipse.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param xRad Radius.(Not in diameter.)
-- @param yRad Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
function Graphics:fillEllipse(x, y, xRad, yRad, steps)
    steps = steps or Graphics.DEFAULT_STEPS
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

---
-- Fills the triangle.
-- @param ... Position of the points(x0, y0).
-- @return self
function Graphics:fillFan(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.fillFan(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

---
-- Fill a rectangle.
-- @param x0 Position of the left.
-- @param y0 Position of the top.
-- @param x1 Position of the right.
-- @param y1 Position of the bottom.
-- @return self
function Graphics:fillRect(x0, y0, x1, y1)
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

---
-- Sets the color of the pen.
-- Will be reflected in the drawing functions.
-- @param r red
-- @param g green
-- @param b blue
-- @param a alpha
-- @return self
function Graphics:setPenColor(r, g, b, a)
    a = a or 1
    local command = function(self)
        local red, green, blue, alpha = self:getColor()
        red = r * red
        green = g * green
        blue = b * blue
        alpha = a * alpha
        MOAIGfxDevice.setPenColor(red, green, blue, alpha)
    end
    table.insert(self.commands, command)
    return self
end

---
-- Set the size of the pen that you specify.
-- Will be reflected in the drawing functions.
-- @param width width
-- @return self
function Graphics:setPenWidth(width)
    local command = function(self)
        MOAIGfxDevice.setPenWidth(width)
    end
    table.insert(self.commands, command)
    return self
end

---
-- Set the size of the specified point.
-- Will be reflected in the drawing functions.
-- @param size
-- @return self
function Graphics:setPointSize(size)
    local command = function(self)
        MOAIGfxDevice.setPointSize(size)
    end
    table.insert(self.commands, command)
    return self
end

---
-- Clears the drawing operations.
-- @return self
function Graphics:clear()
    self.commands = {}
    return self
end

return Graphics