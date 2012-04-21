----------------------------------------------------------------
-- MOAIPropオブジェクトを操作するユーティリティクラスです.<br>
-- @class table
-- @name MOAIPropUtil
----------------------------------------------------------------
local M = {}

----------------------------------------------------------------
function M.setLeft(prop, left)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        xMin = math.min(xMin, xMax)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    prop:setLoc(left + pivX - xMin, locY, locZ)
end

----------------------------------------------------------------
function M.getLeft(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        xMin = math.min(xMin, xMax)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    return locX - pivX + xMin
end

----------------------------------------------------------------
function M.setRight(prop, right)
    local width = M.getWidth(prop)
    M.setLeft(prop, right - width)
end

----------------------------------------------------------------
function M.getRight(prop)
    local left = M.getLeft(prop)
    local width = M.getWidth(prop)
    return left + width
end

----------------------------------------------------------------
function M.setTop(prop, top)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        yMin = math.min(yMin, yMax)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    prop:setLoc(locX, top + pivY - yMin, locZ)
end

----------------------------------------------------------------
function M.getTop(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = 0, 0, 0, 0, 0, 0
    if prop.getBounds then
        xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
        yMin = math.min(yMin, yMax)
    end
    
    local pivX, pivY, pivZ = prop:getPiv()
    local locX, locY, locZ = prop:getLoc()
    return locY - pivY + yMin
end

----------------------------------------------------------------
function M.setBottom(prop, bottom)
    local height = M.getHeight(prop)
    M.setTop(prop, bottom - height)
end

----------------------------------------------------------------
function M.getBottom(prop)
    local top = M.getTop(prop)
    local height = M.getHeight(prop)
    return top + height
end

----------------------------------------------------------------
function M.getWidth(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(xMax - xMin)
end

----------------------------------------------------------------
function M.getHeight(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(yMax - yMin)
end

----------------------------------------------------------------
function M.getColor(prop)
    local r = prop:getAttr(MOAIColor.ATTR_R_COL)
    local g = prop:getAttr(MOAIColor.ATTR_G_COL)
    local b = prop:getAttr(MOAIColor.ATTR_B_COL)
    local a = prop:getAttr(MOAIColor.ATTR_A_COL)
    return r, g, b, a
end

----------------------------------------------------------------
function M.getRed(prop)
    local r = prop:getAttr(MOAIColor.ATTR_R_COL)
    return r
end

----------------------------------------------------------------
function M.getGreen(prop)
    local g = prop:getAttr(MOAIColor.ATTR_G_COL)
    return g
end

----------------------------------------------------------------
function M.getBlue(prop)
    local b = prop:getAttr(MOAIColor.ATTR_B_COL)
    return b
end

----------------------------------------------------------------
function M.getAlpha(prop)
    local a = prop:getAttr(MOAIColor.ATTR_A_COL)
    return a
end

return M