--------------------------------------------------------------------------------
-- 表示オブジェクトの位置やサイズのレイアウトを更新する為のクラスです.
-- このクラスでは、Box形式のオブジェクトを水平、垂直方向に配置する事が可能です.
--------------------------------------------------------------------------------

-- import
local table                 = require "hp/lang/table"
local class                 = require "hp/lang/class"
local BaseLayout            = require "hp/layout/BaseLayout"

-- class
local super                 = BaseLayout
local M                     = class(super)

-- constraints
-- Horizotal Align
M.HORIZOTAL_LEFT            = "left"
M.HORIZOTAL_CENTER          = "center"
M.HORIZOTAL_RIGHT           = "right"

-- Vertical Align
M.VERTICAL_TOP              = "top"
M.VERTICAL_CENTER           = "center"
M.VERTICAL_BOTTOM           = "bottom"

-- Direction
M.DIRECTION_VERTICAL        = "vertical"
M.DIRECTION_HORIZOTAL       = "horizotal"

--------------------------------------------------------------------------------
-- 内部変数の初期化処理です.
--------------------------------------------------------------------------------
function M:initInternal(params)
    self._horizotalAlign = M.HORIZOTAL_LEFT
    self._horizotalGap = 5
    self._verticalAlign = M.VERTICAL_TOP
    self._verticalGap = 5
    self._paddingTop = 0
    self._paddingBottom = 0
    self._paddingLeft = 0
    self._paddingRight = 0
    self._direction = M.DIRECTION_VERTICAL
    self._parentResizable = true
end

--------------------------------------------------------------------------------
-- 指定した親コンポーネントのレイアウトを更新します.
--------------------------------------------------------------------------------
function M:update(parent)
    if self._direction == M.DIRECTION_VERTICAL then
        self:updateVertical(parent)
    elseif self._direction == M.DIRECTION_HORIZOTAL then
        self:updateHorizotal(parent)
    end
end

--------------------------------------------------------------------------------
-- 垂直方向に子オブジェクトを配置します.
--------------------------------------------------------------------------------
function M:updateVertical(parent)
    local children = parent:getChildren()
    local childrenWidth, childrenHeight = self:getVerticalLayoutSize(children)
    
    local parentWidth, parentHeight = parent:getSize()
    local parentWidth = parentWidth > childrenWidth and parentWidth or childrenWidth
    local parentHeight = parentHeight > childrenHeight and parentHeight or childrenHeight
    
    if self._parentResizable then
        parent:setSize(parentWidth, parentHeight)
    end
    
    local childY = self:getChildY(parentHeight, childrenHeight)
    for i, child in ipairs(children) do
        if child.isIncludeLayout == nil or child:isIncludeLayout() then
            local childWidth, childHeight = child:getSize()
            local childX = self:getChildX(parentWidth, childWidth)
            child:setPos(childX, childY)
            childY = childY + childHeight + self._verticalGap
        end
    end
end

--------------------------------------------------------------------------------
-- 水平方向に子オブジェクトを配置します.
--------------------------------------------------------------------------------
function M:updateHorizotal(parent)
    local children = parent:getChildren()
    local childrenWidth, childrenHeight = self:getHorizotalLayoutSize(children)

    local parentWidth, parentHeight = parent:getSize()
    local parentWidth = parentWidth > childrenWidth and parentWidth or childrenWidth
    local parentHeight = parentHeight > childrenHeight and parentHeight or childrenHeight
    
    if self._parentResizable then
        parent:setSize(parentWidth, parentHeight)
    end

    local childX = self:getChildX(parentWidth, childrenWidth)

    for i, child in ipairs(children) do
        if child.isIncludeLayout == nil or child:isIncludeLayout() then
            local childWidth, childHeight = child:getSize()
            local childY = self:getChildY(parentHeight, childHeight)
            child:setPos(childX, childY)
            childX = childX + childWidth + self._horizotalGap
        end
    end
end

--------------------------------------------------------------------------------
-- 上下左右の余白を設定します.
--------------------------------------------------------------------------------
function M:setPadding(left, top, right, bottom)
    self._paddingLeft = left or self._paddingTop
    self._paddingTop = top or self._paddingTop
    self._paddingRight = right or self._paddingRight
    self._paddingBottom = bottom or self._paddingBottom
end

--------------------------------------------------------------------------------
-- 上下左右の余白を設定します.
--------------------------------------------------------------------------------
function M:getPadding()
    return self._paddingLeft, self._paddingTop, self._paddingRight, self._paddingBottom
end

--------------------------------------------------------------------------------
-- アラインを設定します.
--------------------------------------------------------------------------------
function M:setAlign(horizotalAlign, verticalAlign)
    self._horizotalAlign = horizotalAlign
    self._verticalAlign = verticalAlign
end

--------------------------------------------------------------------------------
-- アラインを返します.
--------------------------------------------------------------------------------
function M:getAlign()
    return self._horizotalAlign, self._verticalAlign
end

--------------------------------------------------------------------------------
-- コンポーネントを配置する方向を設定します.
--------------------------------------------------------------------------------
function M:setDirection(direction)
    self._direction = direction
end

--------------------------------------------------------------------------------
-- コンポーネントを配置する方向を返します.
--------------------------------------------------------------------------------
function M:getDirection()
    return self._direction
end

--------------------------------------------------------------------------------
-- コンポーネントの間隔を設定します.
--------------------------------------------------------------------------------
function M:setGap(horizotalGap, verticalGap)
    self._horizotalGap = horizotalGap
    self._verticalGap = verticalGap
end

--------------------------------------------------------------------------------
-- コンポーネントの間隔を返します..
--------------------------------------------------------------------------------
function M:getGap()
    return self._horizotalGap, self._verticalGap
end

--------------------------------------------------------------------------------
-- 子オブジェクトのX座標を返します.
--------------------------------------------------------------------------------
function M:getChildX(parentWidth, childWidth)
    local diffWidth = parentWidth - childWidth

    local x = 0
    if self._horizotalAlign == M.HORIZOTAL_LEFT then
        x = self._paddingLeft
    elseif self._horizotalAlign == M.HORIZOTAL_CENTER then
        x = math.floor((diffWidth + self._paddingLeft - self._paddingRight) / 2)
    elseif self._horizotalAlign == M.HORIZOTAL_RIGHT then
        x = diffWidth - self._paddingRight
    else
        error("Not found direction!")
    end
    return x
end

--------------------------------------------------------------------------------
-- 子オブジェクトのY座標を返します.
--------------------------------------------------------------------------------
function M:getChildY(parentHeight, childHeight)
    local diffHeight = parentHeight - childHeight

    local y = 0
    if self._verticalAlign == M.VERTICAL_TOP then
        y = self._paddingTop
    elseif self._verticalAlign == M.VERTICAL_CENTER then
        y = math.floor((diffHeight + self._paddingTop - self._paddingBottom) / 2)
    elseif self._verticalAlign == M.VERTICAL_BOTTOM then
        y = diffHeight - self._paddingBottom
    else
        error("Not found direction!")
    end
    return y
end

--------------------------------------------------------------------------------
-- 垂直方向に子オブジェクトを配置した時の
-- 全体のレイアウトサイズを返します.
--------------------------------------------------------------------------------
function M:getVerticalLayoutSize(children)
    local width = self._paddingLeft + self._paddingRight
    local height = self._paddingTop + self._paddingBottom
    local count = 0
    for i, child in ipairs(children) do
        if child.isIncludeLayout == nil or child:isIncludeLayout() then
            local cWidth, cHeight = child:getSize()
            height = height + cHeight + self._verticalGap
            width = math.max(width, cWidth)
            count = count + 1
        end
    end
    if count > 1 then
        height = height - self._verticalGap
    end
    return width, height
end

--------------------------------------------------------------------------------
-- 水平方向に子オブジェクトを配置した時の
-- 全体のレイアウトサイズを返します.
--------------------------------------------------------------------------------
function M:getHorizotalLayoutSize(children)
    local width = self._paddingLeft + self._paddingRight
    local height = self._paddingTop + self._paddingBottom
    local count = 0
    for i, child in ipairs(children) do
        if child.isIncludeLayout == nil or child:isIncludeLayout() then
            local cWidth, cHeight = child:getSize()
            width = width + cWidth + self._horizotalGap
            height = math.max(height, cHeight)
            count = count + 1
        end
    end
    if count > 1 then
        width = width - self._horizotalGap
    end
    return width, height
end

return M