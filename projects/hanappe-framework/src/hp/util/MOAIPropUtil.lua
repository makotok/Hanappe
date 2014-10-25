--------------------------------------------------------------------------------
-- This is a utility class for MOAIProp.<br>
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- Sets the position of the left.
-- @param prop MOAIProp instance.
-- @param left Position of the left.
--------------------------------------------------------------------------------
function M.setLeft(prop, left)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        xMin = math.min(xMin or 0, xMax or 0)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    prop:setLoc(left + pivX - xMin, locY, locZ)
end

--------------------------------------------------------------------------------
-- Returns the position of the left.
-- @param prop MOAIProp instance.
-- @return Position of the left.
--------------------------------------------------------------------------------
function M.getLeft(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        xMin = math.min(xMin or 0, xMax or 0)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    return locX - pivX + xMin
end

--------------------------------------------------------------------------------
-- Sets the position of the right.
-- @param prop MOAIProp instance.
-- @param right Position of the right.
--------------------------------------------------------------------------------
function M.setRight(prop, right)
    local width = M.getWidth(prop)
    M.setLeft(prop, right - width)
end

--------------------------------------------------------------------------------
-- Returns the position of the right.
-- @param prop MOAIProp instance.
-- @return Position of the right.
--------------------------------------------------------------------------------
function M.getRight(prop)
    local left = M.getLeft(prop)
    local width = M.getWidth(prop)
    return left + width
end

--------------------------------------------------------------------------------
-- Sets the position of the top.
-- @param prop MOAIProp instance.
-- @param top Position of the top.
--------------------------------------------------------------------------------
function M.setTop(prop, top)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        yMin = math.min(yMin or 0, yMax or 0)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    prop:setLoc(locX, top + pivY - yMin, locZ)
end

--------------------------------------------------------------------------------
-- Returns the position of the top.
-- @param prop MOAIProp instance.
-- @return Position of the top.
--------------------------------------------------------------------------------
function M.getTop(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        yMin = math.min(yMin or 0, yMax or 0)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    return locY - pivY + yMin
end

--------------------------------------------------------------------------------
-- Sets the position of the bottom.
-- @param prop MOAIProp instance.
-- @param bottom Position of the bottom.
--------------------------------------------------------------------------------
function M.setBottom(prop, bottom)
    local height = M.getHeight(prop)
    M.setTop(prop, bottom - height)
end

--------------------------------------------------------------------------------
-- Returns the position of the bottom.
-- @param prop MOAIProp instance.
-- @return Position of the bottom.
--------------------------------------------------------------------------------
function M.getBottom(prop)
    local top = M.getTop(prop)
    local height = M.getHeight(prop)
    return top + height
end

--------------------------------------------------------------------------------
-- Sets the position of the left and top.
-- @param prop MOAIProp
-- @param left Position of the left.
-- @param top Position of the top.
--------------------------------------------------------------------------------
function M.setPos(prop, left, top)
    M.setLeft(prop, left)
    M.setTop(prop, top)
end

--------------------------------------------------------------------------------
-- Returns the position of the center.
-- @param prop MOAIProp instance.
-- @return centerX
-- @return centerY
--------------------------------------------------------------------------------
function M.getCenterPos(prop)
    local left, top = M.getPos(prop)
    local w, h = M.getSize(prop)
    return left + w / 2, top + h / 2
end

--------------------------------------------------------------------------------
-- Sets the position of the centeX and centerY.
-- @param prop MOAIProp
-- @param x Position of the centerX.
-- @param y Position of the centerY.
--------------------------------------------------------------------------------
function M.setCenterPos(prop, x, y)
    local w, h = M.getSize(prop)
    M.setPos(prop, x - w / 2, y - h / 2)
end

--------------------------------------------------------------------------------
-- Returns the position of the left and top.
-- @param prop MOAIProp instance.
-- @return Position of the left and top.
--------------------------------------------------------------------------------
function M.getPos(prop)
    return M.getLeft(prop), M.getTop(prop)
end

--------------------------------------------------------------------------------
-- Returns the width.
-- @param prop MOAIProp instance.
-- @return width
--------------------------------------------------------------------------------
function M.getWidth(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(xMax - xMin)
end

--------------------------------------------------------------------------------
-- Returns the height.
-- @param prop MOAIProp instance.
-- @return height
--------------------------------------------------------------------------------
function M.getHeight(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(yMax - yMin)
end

--------------------------------------------------------------------------------
-- Returns the width and height.
-- @param prop MOAIProp instance.
-- @return width
-- @return height
--------------------------------------------------------------------------------
function M.getSize(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(xMax - xMin), math.abs(yMax - yMin)
end

--------------------------------------------------------------------------------
-- Returns the color.
-- @param prop MOAIProp instance.
-- @return red
-- @return green
-- @return blue
-- @return alpha
--------------------------------------------------------------------------------
function M.getColor(prop)
    local r = prop:getAttr(MOAIColor.ATTR_R_COL)
    local g = prop:getAttr(MOAIColor.ATTR_G_COL)
    local b = prop:getAttr(MOAIColor.ATTR_B_COL)
    local a = prop:getAttr(MOAIColor.ATTR_A_COL)
    return r, g, b, a
end

--------------------------------------------------------------------------------
-- Returns the red.
-- @param prop MOAIProp instance.
-- @return red
--------------------------------------------------------------------------------
function M.getRed(prop)
    local r = prop:getAttr(MOAIColor.ATTR_R_COL)
    return r
end

--------------------------------------------------------------------------------
-- Sets the red.
-- @param prop MOAIProp instance.
-- @param red red value
--------------------------------------------------------------------------------
function M.setRed(prop, red)
    prop:setAttr(MOAIColor.ATTR_R_COL, red)
end

--------------------------------------------------------------------------------
-- Returns the green.
-- @param prop MOAIProp instance.
-- @return green
--------------------------------------------------------------------------------
function M.getGreen(prop)
    local g = prop:getAttr(MOAIColor.ATTR_G_COL)
    return g
end

--------------------------------------------------------------------------------
-- Sets the green.
-- @param prop MOAIProp instance.
-- @param green green value
--------------------------------------------------------------------------------
function M.setGreen(prop, green)
    prop:setAttr(MOAIColor.ATTR_G_COL, green)
end

--------------------------------------------------------------------------------
-- Returns the blue.
-- @param prop MOAIProp instance.
-- @return blue
--------------------------------------------------------------------------------
function M.getBlue(prop)
    local b = prop:getAttr(MOAIColor.ATTR_B_COL)
    return b
end

--------------------------------------------------------------------------------
-- Sets the blue.
-- @param prop MOAIProp instance.
-- @param blue blue value
--------------------------------------------------------------------------------
function M.setBlue(prop, blue)
    prop:setAttr(MOAIColor.ATTR_B_COL, blue)
end

--------------------------------------------------------------------------------
-- Returns the alpha.
-- @param prop MOAIProp instance.
-- @return alpha
--------------------------------------------------------------------------------
function M.getAlpha(prop)
    local a = prop:getAttr(MOAIColor.ATTR_A_COL)
    return a
end

--------------------------------------------------------------------------------
-- Sets the alpha.
-- @param prop MOAIProp instance.
-- @param a alpha value
--------------------------------------------------------------------------------
function M.setAlpha(prop, a)
    prop:setAttr(MOAIColor.ATTR_A_COL, a)
end

--------------------------------------------------------------------------------
-- Sets the color by RGB255 format.
-- @param prop MOAIProp instance.
-- @param r Red(0-255).
-- @param g Green(0-255).
-- @param b Blue(0-255).
--------------------------------------------------------------------------------
function M.setRGB(prop, r, g, b)
    local a = MOAIPropUtil.getAlpha(prop)
    prop:setColor(r / 255, g / 255, b / 255, a)
end

--------------------------------------------------------------------------------
-- Sets the color by RGBA255 format.
-- @param prop MOAIProp instance.
-- @param r Red(0-255).
-- @param g Green(0-255).
-- @param b Blue(0-255).
-- @param a Alpha(0-1).
--------------------------------------------------------------------------------
function M.setRGBA(prop, r, g, b, a)
    a = a or MOAIPropUtil.getAlpha(prop)
    prop:setColor(r / 255, g / 255, b / 255, a)
end

--------------------------------------------------------------------------------
-- Returns the visible.
-- @param prop MOAIProp instance.
-- @return visible
--------------------------------------------------------------------------------
function M.getVisible(prop)
    return prop:getAttr(MOAIProp.ATTR_VISIBLE)
end

return M