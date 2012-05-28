--------------------------------------------------------------------------------
-- MOAIPropオブジェクトを操作するユーティリティクラスです.<br>
-- @class table
-- @name MOAIPropUtil
--------------------------------------------------------------------------------
local M = {}

--------------------------------------------------------------------------------
-- left座標を設定します.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- left座標を返します.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- right座標を設定します.
--------------------------------------------------------------------------------
function M.setRight(prop, right)
    local width = M.getWidth(prop)
    M.setLeft(prop, right - width)
end

--------------------------------------------------------------------------------
-- right座標を返します.
--------------------------------------------------------------------------------
function M.getRight(prop)
    local left = M.getLeft(prop)
    local width = M.getWidth(prop)
    return left + width
end

--------------------------------------------------------------------------------
-- top座標を設定します.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- top座標を返します.
--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
-- bottom座標を設定します.
--------------------------------------------------------------------------------
function M.setBottom(prop, bottom)
    local height = M.getHeight(prop)
    M.setTop(prop, bottom - height)
end

--------------------------------------------------------------------------------
-- bottom座標を返します.
--------------------------------------------------------------------------------
function M.getBottom(prop)
    local top = M.getTop(prop)
    local height = M.getHeight(prop)
    return top + height
end

--------------------------------------------------------------------------------
-- 左上原点の座標を設定します.
--------------------------------------------------------------------------------
function M.setPos(prop, left, top)
    M.setLeft(prop, left)
    M.setTop(prop, top)
end

--------------------------------------------------------------------------------
-- 左上原点の座標を返します.
--------------------------------------------------------------------------------
function M.getPos(prop)
    return M.getLeft(prop), M.getTop(prop)
end

--------------------------------------------------------------------------------
-- 2Dオブジェクトの幅を返します.
--------------------------------------------------------------------------------
function M.getWidth(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(xMax - xMin)
end

--------------------------------------------------------------------------------
-- 2Dオブジェクトの高さを返します.
--------------------------------------------------------------------------------
function M.getHeight(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(yMax - yMin)
end

--------------------------------------------------------------------------------
-- 2Dオブジェクトのサイズを返します.
--------------------------------------------------------------------------------
function M.getSize(prop)
    local xMin, yMin, zMin, xMax, yMax, zMax = prop:getBounds()
    return math.abs(xMax - xMin), math.abs(yMax - yMin)
end

--------------------------------------------------------------------------------
-- 色を返します.
--------------------------------------------------------------------------------
function M.getColor(prop)
    local r = prop:getAttr(MOAIColor.ATTR_R_COL)
    local g = prop:getAttr(MOAIColor.ATTR_G_COL)
    local b = prop:getAttr(MOAIColor.ATTR_B_COL)
    local a = prop:getAttr(MOAIColor.ATTR_A_COL)
    return r, g, b, a
end

--------------------------------------------------------------------------------
-- redを返します.
--------------------------------------------------------------------------------
function M.getRed(prop)
    local r = prop:getAttr(MOAIColor.ATTR_R_COL)
    return r
end

--------------------------------------------------------------------------------
-- greenを返します.
--------------------------------------------------------------------------------
function M.getGreen(prop)
    local g = prop:getAttr(MOAIColor.ATTR_G_COL)
    return g
end

--------------------------------------------------------------------------------
-- blueを返します.
--------------------------------------------------------------------------------
function M.getBlue(prop)
    local b = prop:getAttr(MOAIColor.ATTR_B_COL)
    return b
end

--------------------------------------------------------------------------------
-- alphaを返します.
--------------------------------------------------------------------------------
function M.getAlpha(prop)
    local a = prop:getAttr(MOAIColor.ATTR_A_COL)
    return a
end

--------------------------------------------------------------------------------
-- 表示します.
--------------------------------------------------------------------------------
function M.show(prop)
    prop:setVisible(true)
end

--------------------------------------------------------------------------------
-- 非表示にします.
--------------------------------------------------------------------------------
function M.hide(prop)
    prop:setVisible(false)
end

return M