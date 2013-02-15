--------------------------------------------------------------------------------
-- The DisplayObject that has graphics capabilities. <br>
-- You can call in the method chain MOAIDraw. <br>
-- See MOAIDraw. <br>
-- <br>
-- Base Classes => DisplayObject, Resizable<br>
-- <code>
-- example)<br>
-- local g = Graphics({width = 100, height = 100})<br>
-- g:setPenColor(1, 0, 0, 1):fillRect():drawRect()<br>
-- g:setPenColor(0, 1, 0, 1):fillRect(25, 25, 50, 50):drawRect(25, 25, 50, 50)<br>
-- g:setLayer(layer)<br>
-- </code>
--------------------------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local DisplayObject         = require "hp/display/DisplayObject"
local Resizable             = require "hp/display/Resizable"

-- class
local M                     = class(DisplayObject, Resizable)

-- constraints
M.ADJUST_OFFSET             = 0.01
M.DEFAULT_STEPS             = 32

--------------------------------------------------------------------------------
-- private. <br>
-- Outputs the vertex data is specified.
--------------------------------------------------------------------------------
local function writeBuffers(verts, ...)
    for i, v in ipairs({...}) do
        table.insert(verts, v)
    end
end

--------------------------------------------------------------------------------
-- private. <br>
-- To create a line in the corner.
--------------------------------------------------------------------------------
local function writeCornerLines(verts, cx, cy, rw, rh, angle0, angle1, steps)
    local step = (angle1 - angle0) / steps
    for angle = angle0, angle1, step do
        local radian = angle / 180 * math.pi
        local x, y = math.cos(radian) * rw + cx, -math.sin(radian) * rh + cy
        writeBuffers(verts, x, y)
    end
end

--------------------------------------------------------------------------------
-- private. <br>
-- Create the vertex data to draw a rectangle with rounded corners.
--------------------------------------------------------------------------------
local function createRoundRectDrawData(x0, y0, x1, y1, rw, rh, steps)
    local offset = M.ADJUST_OFFSET
    
    if rw == 0 or rh == 0 then
        return {x0 + offset, y0 + offset, x0 + offset, y1, x1, y1, x1, y0 + offset, x0, y0}
    end
    
    local vertexs = {}
    
    -- x0, y0
    writeBuffers(vertexs, x0 + offset, y0 + rh)
    writeBuffers(vertexs, x0 + offset, y1 - rh)
    writeCornerLines(vertexs, x0 + rw + offset, y1 - rh, rw, rh, 180, 270, steps)

    -- x0, y1
    writeBuffers(vertexs, x0 + rw, y1)
    writeBuffers(vertexs, x1 - rw, y1)
    writeCornerLines(vertexs, x1 - rw, y1 - rh, rw, rh, 270, 360, steps)

    -- x1, y1
    writeBuffers(vertexs, x1, y1 - rh)
    writeBuffers(vertexs, x1, y0 + rh)
    writeCornerLines(vertexs, x1 - rw, y0 + rh + offset, rw, rh, 0, 90, steps)

    -- x1, y0
    writeBuffers(vertexs, x1 - rw, y0 + offset)
    writeBuffers(vertexs, x0 + rw, y0 + offset)
    writeCornerLines(vertexs, x0 + rw + offset, y0 + rh + offset, rw, rh, 90, 180, steps)
    
    return vertexs
end

--------------------------------------------------------------------------------
-- private. <br>
-- Create the vertex data to fill the corners.
--------------------------------------------------------------------------------
local function createCornerFans(cx, cy, rw, rh, angle0, angle1, steps)
    local verts = {}
    local step = (angle1 - angle0) / steps
    writeBuffers(verts, cx, cy)
    for angle = angle0, angle1, step do
        local radian = angle / 180 * math.pi
        local x, y = math.cos(radian) * rw + cx, -math.sin(radian) * rh + cy
        writeBuffers(verts, x, y)
    end
    return verts
end

--------------------------------------------------------------------------------
-- private. <br>
-- Create the vertex data to fill a rectangle with rounded corners.
--------------------------------------------------------------------------------
local function createRoundRectFillData(x0, y0, x1, y1, rw, rh, steps)
    if rw == 0 or rh == 0 then
        return {{x0, y0, x1, y0, x1, y1, x0, y1}}
    end

    local fans = {}
    -- rects
    writeBuffers(fans, {x0 + rw, y0, x1 - rw, y0, x1 - rw, y1, x0 + rw, y1})
    writeBuffers(fans, {x0, y0 + rh, x0 + rw, y0 + rh, x0 + rw, y1 - rh, x0, y1 - rh})
    writeBuffers(fans, {x1 - rw, y0 + rh, x1, y0 + rh, x1, y1 - rh, x1 - rw, y1 - rh})
    
    -- fans
    writeBuffers(fans, createCornerFans(x0 + rw, y0 + rh, rw, rh,  90, 180, steps))
    writeBuffers(fans, createCornerFans(x1 - rw, y0 + rh, rw, rh,   0,  90, steps))
    writeBuffers(fans, createCornerFans(x1 - rw, y1 - rh, rw, rh, 270, 360, steps))
    writeBuffers(fans, createCornerFans(x0 + rw, y1 - rh, rw, rh, 180, 270, steps))
    
    return fans
end

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
            if #self.commands == 0 then
                return
            end
            
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

--------------------------------------------------------------------------------
-- Draw a circle.<br>
-- @param x Position of the left.
-- @param y Position of the top.
-- @param r Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
--------------------------------------------------------------------------------
function M:drawCircle(x, y, r, steps)
    steps = steps or M.DEFAULT_STEPS
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

--------------------------------------------------------------------------------
-- Draw an ellipse.<br>
-- @param x Position of the left.
-- @param y Position of the top.
-- @param xRad Radius.(Not in diameter.)
-- @param yRad Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
--------------------------------------------------------------------------------
function M:drawEllipse(x, y, xRad, yRad, steps)
    steps = steps or M.DEFAULT_STEPS
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

--------------------------------------------------------------------------------
-- Draws a line.<br>
-- @param ... Position of the points(x0, y0).
-- @return self
--------------------------------------------------------------------------------
function M:drawLine(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.drawLine(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

--------------------------------------------------------------------------------
-- Draws a point.
-- @param ... Position of the points(x0, y0).
-- @return self
--------------------------------------------------------------------------------
function M:drawPoints(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.drawPoints(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

--------------------------------------------------------------------------------
-- Draw a ray.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param dx Direction.
-- @param dy Direction.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Draw a rectangle.
-- @param x0 Position of the left.
-- @param y0 Position of the top.
-- @param x1 Position of the right.
-- @param y1 Position of the bottom
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Draw a round rectangle.
-- @param x0 Position of the left.
-- @param y0 Position of the top.
-- @param x1 Position of the right.
-- @param y1 Position of the bottom.
-- @param rw The width of the Corner.
-- @param rh The height of the Corner.
-- @param steps Number of points.
-- @return self
--------------------------------------------------------------------------------
function M:drawRoundRect(x0, y0, x1, y1, rw, rh, steps)
    rw = rw or 0
    rh = rh or 0
    steps = steps or M.DEFAULT_STEPS / 4
    local vertexs = createRoundRectDrawData(x0, y0, x1, y1, rw, rh, steps)

    local command = function(self)
        MOAIDraw.drawLine(vertexs)
    end
    table.insert(self.commands, command)
    return self
end

--------------------------------------------------------------------------------
-- Fill the circle.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param r Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
--------------------------------------------------------------------------------
function M:fillCircle(x, y, r, steps)
    steps = steps or M.DEFAULT_STEPS
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

--------------------------------------------------------------------------------
-- Fill an ellipse.
-- @param x Position of the left.
-- @param y Position of the top.
-- @param xRad Radius.(Not in diameter.)
-- @param yRad Radius.(Not in diameter.)
-- @param steps Number of points.
-- @return self
--------------------------------------------------------------------------------
function M:fillEllipse(x, y, xRad, yRad, steps)
    steps = steps or M.DEFAULT_STEPS
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

--------------------------------------------------------------------------------
-- Fills the triangle.
-- @param ... Position of the points(x0, y0).
-- @return self
--------------------------------------------------------------------------------
function M:fillFan(...)
    local args = {...}
    local command = function(self)
        MOAIDraw.fillFan(unpack(args))
    end
    table.insert(self.commands, command)
    return self
end

--------------------------------------------------------------------------------
-- Fill a rectangle.
-- @param x0 Position of the left.
-- @param y0 Position of the top.
-- @param x1 Position of the right.
-- @param y1 Position of the bottom.
-- @return self
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- Fill a round rectangle.
-- @param x0 Position of the left.
-- @param y0 Position of the top.
-- @param x1 Position of the right.
-- @param y1 Position of the bottom.
-- @param rw The width of the Corner.
-- @param rh The height of the Corner.
-- @param steps Number of points.
-- @return self
--------------------------------------------------------------------------------
function M:fillRoundRect(x0, y0, x1, y1, rw, rh, steps)
    rw = rw or 0
    rh = rh or 0
    steps = steps or M.DEFAULT_STEPS / 4
    
    local fillDatas = createRoundRectFillData(x0, y0, x1, y1, rw, rh, steps)
    local command = function(self)
        for i, verts in ipairs(fillDatas) do
            MOAIDraw.fillFan(verts)
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
    a = a or 1
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