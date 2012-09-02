local table = require("hp/lang/table")
local class = require("hp/lang/class")

--------------------------------------------------------------------------------
-- 表示オブジェクトの位置やサイズのレイアウトを更新する為のクラスです.
-- このクラスでは、Box形式のオブジェクトを水平、垂直方向に配置する事が可能です.
-- TODO:いまのところMOAIPropには対応していないので、MOAIPropUtilを使用して対応できるようにするべし
-- @class table
-- @name BoxLayout
--------------------------------------------------------------------------------
local M = class()

-- 定数
-- hAlign
M.H_LEFT = "left"
M.H_MIDDLE = "middle"
M.H_RIGHT = "right"

M.V_TOP = "top"
M.V_MIDDLE = "middle"
M.V_BOTTOM = "bottom"

M.DIRECTION_V = "vertical"
M.DIRECTION_H = "horizotal"

---------------------------------------
-- コンストラクタです
---------------------------------------
function M:init(params)
    self.hAlign = M.H_LEFT
    self.hGap = 5
    self.vAlign = M.V_TOP
    self.vGap = 5
    self.pTop = 5
    self.pBottom = 5
    self.pLeft = 5
    self.pRight = 5
    self.resizeParentEnabled = true
    self.direction = M.DIRECTION_V
    
    if params then
        table.copy(params, self)
    end
end

---------------------------------------
-- 上下左右の余白を設定します.
---------------------------------------
function M:setPadding(left, top, right, bottom)
    self.pLeft = left
    self.pTop = top
    self.pRight = right
    self.pBottom = bottom
end

---------------------------------------
-- 指定したGroupのレイアウトを更新します.
---------------------------------------
function M:update(group)
    if self.direction == M.DIRECTION_V then
        self:updateVertical(group)
    elseif self.direction == M.DIRECTION_H then
        self:updateHorizotal(group)
    end
end

---------------------------------------
-- 指定した四角形内に、
-- 垂直方向に子オブジェクトを配置します.
---------------------------------------
function M:updateVertical(parent)
    local children = parent:getChildren()
    local childrenWidth, childrenHeight = self:getVerticalLayoutSize(children)
    
    if self.resizeParentEnabled then
        parent:setSize(childrenWidth + self.pLeft + self.pRight, childrenHeight + self.pTop + self.pBottom)
    end
    
    local childY = self:getChildY(parent:getHeight(), childrenHeight)

    for i, child in ipairs(children) do
        local childWidth, childHeight = child:getSize()
        local childX = self:getChildX(parent:getWidth(), childrenWidth)
        child:setPos(childX, childY)
        childY = childY + childHeight + self.vGap
    end
    
end

---------------------------------------
-- 指定した四角形内に、
-- 水平方向に子オブジェクトを配置します.
---------------------------------------
function M:updateHorizotal(parent)
    local children = parent:getChildren()
    local childrenWidth, childrenHeight = self:getHorizotalLayoutSize(children)
    
    if self.resizeParentEnabled then
        parent:setSize(childrenWidth + self.pLeft + self.pRight, childrenHeight + self.pTop + self.pBottom)
    end
    
    local childX = self:getChildX(parent:getWidth(), childrenWidth)

    for i, child in ipairs(children) do
        local childWidth, childHeight = child:getSize()
        local childY = self:getChildY(parent:getHeight(), childrenHeight)
        child:setPos(childX, childY)
        childX = childX + childWidth + self.hGap
    end
    
end

---------------------------------------
-- 子オブジェクトのX座標を返します.
---------------------------------------
function M:getChildX(parentWidth, childWidth)
    -- サイズの計算
    local diffWidth = parentWidth - childWidth

    -- Horizotal
    local x
    if self.hAlign == M.H_LEFT then
        x = self.pLeft
    elseif self.hAlign == M.H_MIDDLE then
        x = math.floor((diffWidth + self.pLeft - self.pRight) / 2)
    elseif self.hAlign == M.H_RIGHT then
        x = diffWidth - self.pRight
    end

    return x
end

---------------------------------------
-- 子オブジェクトのY座標を返します.
---------------------------------------
function M:getChildY(parentHeight, childHeight)
    -- サイズの計算
    local diffHeight = parentHeight - childHeight

    -- Vertical
    local y
    if self.vAlign == M.V_TOP then
        y = self.pTop
    elseif self.vAlign == M.V_MIDDLE then
        y = math.floor((diffHeight + self.pTop - self.pBottom) / 2)
    elseif self.vAlign == M.V_BOTTOM then
        y = diffWidth - self.pBottom
    end

    return y
end

---------------------------------------
-- 垂直方向に子オブジェクトを配置した時の
-- 全体のレイアウトサイズを返します.
---------------------------------------
function M:getVerticalLayoutSize(children)
    local width = 0
    local height = 0
    for i, child in ipairs(children) do
        local cWidth, cHeight = child:getSize()
        height = height + cHeight + self.vGap
        width = math.max(width, cWidth)
    end
    if #children > 1 then
        height = height - self.vGap
    end
    return width, height
end

---------------------------------------
-- 水平方向に子オブジェクトを配置した時の
-- 全体のレイアウトサイズを返します.
---------------------------------------
function M:getHorizotalLayoutSize(children)
    local width = 0
    local height = 0
    for i, child in ipairs(children) do
        local cWidth, cHeight = child:getSize()
        width = width + cWidth + self.hGap
        height = math.max(height, cHeight)
    end
    if #children > 1 then
        width = width - self.hGap
    end
    return width, height
end

return M