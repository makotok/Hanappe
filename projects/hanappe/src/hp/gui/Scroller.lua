----------------------------------------------------------------
-- 親のサイズに合わせてスクロールするクラスです.<br>
-- @class table
-- @name Scroller
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Layer             = require "hp/display/Layer"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"
local Executors         = require "hp/util/Executors"

-- class
local super             = Component
local M                 = class(Component)

----------------------------------------------------------------
-- コンストラクタです.
----------------------------------------------------------------
function M:initInternal(params)
    super.initInternal(self, params)
    self._autoResizing = true
    self._friction = 0.1
    self._hScrollEnabled = true
    self._vScrollEnabled = true
    self._scrollingForceX = 0
    self._scrollingForceY = 0
    self._maxScrollingForceX = 100
    self._maxScrollingForceY = 100
    self._minScrollingForceX = 0.1
    self._minScrollingForceY = 0.1
    self._touchDownFlag = false
    self._touchDownIndex = nil
    self._themeName = "Scroller"
    
    Executors.callLoop(self.enterFrame, self)
end

--------------------------------------------------------------------------------
-- スクロール更新処理を行います.
--------------------------------------------------------------------------------
function M:enterFrame()
    self:updateScroll()
end

--------------------------------------------------------------------------------
-- スクロール更新処理を行います.
--------------------------------------------------------------------------------
function M:updateScroll()
    if not self:isScrolling() then
        return
    end
    
    if self:isTouching() then
        self:ajustScrollPosition()
        return
    end

    local scrollX, scrollY = self:getScrollingForce()
    local rate = (1 - self:getFriction())
    
    self:addLoc(scrollX, scrollY, 0)
    self:setScrollingForce(scrollX * rate, scrollY * rate)
    self:ajustScrollPosition()
end

--------------------------------------------------------------------------------
-- レイアウト更新時にスクロールコンテナのサイズも変更します.
--------------------------------------------------------------------------------
function M:updateLayout()
    super.updateLayout(self)
    self:ajustScrollSize()
end

--------------------------------------------------------------------------------
-- スクロールサイズをchildrenの範囲に自動的に調整するか設定します.
--------------------------------------------------------------------------------
function M:setAutoResizing(value)
    self._autoResizing = value
end

--------------------------------------------------------------------------------
-- スクロールサイズをchildrenの範囲に自動的に調整するか返します.
--------------------------------------------------------------------------------
function M:isAutoResizing()
    return self._autoResizing
end

--------------------------------------------------------------------------------
-- 水平方向のスクロールが行えるかどうか設定します.
--------------------------------------------------------------------------------
function M:setHScrollEnabled(value)
    self._hScrollEnabled = value
end

--------------------------------------------------------------------------------
-- 水平方向のスクロールが行えるかどうか設定します.
--------------------------------------------------------------------------------
function M:isHScrollEnabled()
    return self._hScrollEnabled
end

--------------------------------------------------------------------------------
-- 垂直方向のスクロールが行えるかどうか設定します.
--------------------------------------------------------------------------------
function M:setVScrollEnabled(value)
    self._vScrollEnabled = value
end

--------------------------------------------------------------------------------
-- 垂直方向のスクロールが行えるかどうか返します.
--------------------------------------------------------------------------------
function M:isVScrollEnabled()
    return self._vScrollEnabled
end

--------------------------------------------------------------------------------
-- スクロール時の摩擦係数を設定します.
--------------------------------------------------------------------------------
function M:setFriction(value)
    self._friction = value
end

--------------------------------------------------------------------------------
-- スクロール時の摩擦係数を返します.
--------------------------------------------------------------------------------
function M:getFriction()
    return self._friction
end

--------------------------------------------------------------------------------
-- スクロール中かどうか返します.
--------------------------------------------------------------------------------
function M:isScrolling()
    return self._scrollingForceX ~= 0 or self._scrollingForceY ~= 0
end

--------------------------------------------------------------------------------
-- 1フレームでスクロールする量を設定します.
-- タッチ中の場合は無視されます.
--------------------------------------------------------------------------------
function M:setScrollingForce(x, y)
    self._scrollingForceX = self:isHScrollEnabled() and x or 0
    self._scrollingForceY = self:isVScrollEnabled() and y or 0

    local maxScrollX, maxScrollY = self:getMaxScrollingForce()
    local minScrollX, minScrollY = self:getMinScrollingForce()
    local scrollX, scrollY = self._scrollingForceX, self._scrollingForceY
    
    scrollX = (-minScrollX < scrollX and scrollX < minScrollX) and 0 or scrollX
    scrollY = (-minScrollY < scrollY and scrollY < minScrollY) and 0 or scrollY
    scrollX = scrollX < -maxScrollX and -maxScrollX or scrollX
    scrollX = maxScrollX < scrollX  and  maxScrollX or scrollX
    scrollY = scrollY < -maxScrollY and -maxScrollY or scrollY
    scrollY = maxScrollY < scrollY  and  maxScrollY or scrollY
    
    self._scrollingForceX = scrollX
    self._scrollingForceY = scrollY
end

--------------------------------------------------------------------------------
-- 1フレームでスクロールする量を返します.
--------------------------------------------------------------------------------
function M:getScrollingForce()
    return self._scrollingForceX, self._scrollingForceY
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を設定します.
--------------------------------------------------------------------------------
function M:setMaxScrollingForce(x, y)
    self._maxScrollingForceX = x
    self._maxScrollingForceY = y
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を返します.
--------------------------------------------------------------------------------
function M:getMaxScrollingForce()
    return self._maxScrollingForceX, self._maxScrollingForceY
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を設定します.
--------------------------------------------------------------------------------
function M:setMinScrollingForce(x, y)
    self._minScrollingForceX = x
    self._minScrollingForceY = y
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を返します.
--------------------------------------------------------------------------------
function M:getMinScrollingForce()
    return self._minScrollingForceX, self._minScrollingForceY
end

--------------------------------------------------------------------------------
-- タッチ中かどうか返します.
--------------------------------------------------------------------------------
function M:isTouching()
    return self._touchDownFlag
end

--------------------------------------------------------------------------------
-- 指定した座標だけ、指定した時間で移動します.
-- 移動のロジックはmodeで指定できます.
-- modeには、MOAIEaseTypeの値を指定します.
--------------------------------------------------------------------------------
function M:scrollTo(x, y, sec, mode)
end

--------------------------------------------------------------------------------
-- スクロールがView内に収まるようにします.
-- TODO:範囲外に飛び出たときにスクロールが戻るアニメーションがほしい
--------------------------------------------------------------------------------
function M:ajustScrollPosition()
    local left, top = self:getPos()
    local width, height = self:getSize()
    local parentWidth, parentHeight = self:getParent():getSize()
    local minX, minY = parentWidth - width, parentHeight - height
    local maxX, maxY = 0, 0
        
    left = left < minX and minX or left
    left = left > maxX and maxX or left
    top  = top  < minY and minY or top
    top  = top  > maxY and maxY or top
    
    self:setPos(left, top)
end

--------------------------------------------------------------------------------
-- スクロールコンテナを適切なサイズに変更します.
--------------------------------------------------------------------------------
function M:ajustScrollSize()
    if not self._autoResizing then
        return
    end
    
    local width, height = 0, 0
    local parent = self:getParent()
    local minWidth = parent and parent:getWidth() or 0
    local minHeight = parent and parent:getHeight() or 0
    
    for i, child in ipairs(self:getChildren()) do
       width  = math.max(width, child:getRight())
       height = math.max(height, child:getBottom())
    end
    width = width >= minWidth and width or minWidth
    height = height >= minHeight and height or minHeight
    
    self:setSize(width, height)
end

--------------------------------------------------------------------------------
-- 親を設定した際、スクロールサイズも変更するようにします.
--------------------------------------------------------------------------------
function M:setParent(value)
    super.setParent(self, value)
    self:ajustScrollSize()
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self._touchDownFlag then
        return
    end

    self._scrollingForceX = 0
    self._scrollingForceY = 0
    self._touchDownFlag = true
    self._touchDownIndex = e.idx
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if self._touchDownIndex ~= e.idx then
        return
    end
    
    self._touchDownFlag = false
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if self._touchDownIndex ~= e.idx then
        return
    end
    
    local scale = self:getLayer():getViewScale()
    local moveX, moveY = e.moveX, e.moveY
    self:setScrollingForce(moveX, moveY)
    
    moveX, moveY = self:getScrollingForce()
    self:addLoc(moveX, moveY, 0)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
    if self._touchDownIndex ~= e.idx then
        return
    end

    self._touchDownFlag = false
    self._touchDownIndex = nil
end

return M