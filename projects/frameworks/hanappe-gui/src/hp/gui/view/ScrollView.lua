local table = require("hp/lang/table")
local class = require("hp/lang/class")
local Layer = require("hp/display/Layer")
local Event = require("hp/event/Event")
local View = require("hp/widget/View")

----------------------------------------------------------------
-- スクロールするViewです.<br>
-- スクロール範囲内で、ユーザ操作によりスクロールします.<br>
-- @class table
-- @name ScrollView
----------------------------------------------------------------
local M = class(View)

local super = View
local MOAILayerInterface = MOAILayer.getInterfaceTable()

----------------------------------------------------------------
-- コンストラクタです.
----------------------------------------------------------------
function M:init(params)
    super.init(self, params)
    
    local camera = self:createCamera()
    self:setCamera(camera)
    
    self.__internal.autoResizing = true
    self.__internal.scrollSizeChanged = true
    self.__internal.scrollWidth = 0
    self.__internal.scrollHeight = 0
    self.__internal.hScrollEnabled = true
    self.__internal.vScrollEnabled = true
    self.__internal.scrolling = false
    self.__internal.scrollingTotalX = 0
    self.__internal.scrollingTotalY = 0
    self.__internal.scrollingForceX = 0
    self.__internal.scrollingForceY = 0
    self.__internal.maxScrollingForceX = 100
    self.__internal.maxScrollingForceY = 100
    self.__internal.minScrollingForceX = 0.1
    self.__internal.minScrollingForceY = 0.1
    self.__internal.lastTouchX = 0
    self.__internal.lastTouchY = 0
    self.__internal.touchDownFlag = false

end

--------------------------------------------------------------------------------
-- 2Dカメラを生成します.
--------------------------------------------------------------------------------
function M:createCamera()
    local camera = MOAICamera.new()
    camera:setOrtho(true)
    camera:setNearPlane(1)
    camera:setFarPlane(-1)
    return camera
end

--------------------------------------------------------------------------------
-- カメラを設定します.
-- カメラが取得できるように内部変数にも確保します.
--------------------------------------------------------------------------------
function M:setCamera(camera)
    self.__internal.camera = camera
    MOAILayerInterface.setCamera(self, camera)
end

--------------------------------------------------------------------------------
-- カメラを返します.
--------------------------------------------------------------------------------
function M:getCamera()
    return self.__internal.camera
end

--------------------------------------------------------------------------------
-- スクロールサイズをchildrenの範囲に自動的に調整するか設定します.
--------------------------------------------------------------------------------
function M:setAutoResizing(value)
    self.__internal.autoResizing = value
end

--------------------------------------------------------------------------------
-- スクロールサイズをchildrenの範囲に自動的に調整するか返します.
--------------------------------------------------------------------------------
function M:isAutoResizing()
    return self.__internal.autoResizing
end

--------------------------------------------------------------------------------
-- 水平方向のスクロールサイズを設定します.
--------------------------------------------------------------------------------
function M:setScrollWidth(width)
    self:setScrollSize(width, self:getScrollHeight())
end

--------------------------------------------------------------------------------
-- 水平方向のスクロールサイズを返します.
--------------------------------------------------------------------------------
function M:getScrollWidth()
    return self.__internal.scrollWidth
end

--------------------------------------------------------------------------------
-- 垂直方向のスクロールサイズを設定します.
--------------------------------------------------------------------------------
function M:setScrollHeight(height)
    self:setScrollSize(self:getScrollWidth(), height)
end

--------------------------------------------------------------------------------
-- 水平方向のスクロールサイズを返します.
--------------------------------------------------------------------------------
function M:getScrollHeight()
    return self.__internal.scrollHeight
end

--------------------------------------------------------------------------------
-- スクロールサイズを設定します.
-- View以下のサイズに設定された場合、Viewサイズに設定されます.
--------------------------------------------------------------------------------
function M:setScrollSize(swidth, sheight)
    local width, height = self:getViewSize()
    swidth = swidth < width and width or swidth
    sheight = sheight < height and height or sheight
    
    self.__internal.scrollWidth = swidth
    self.__internal.scrollHeight = sheight
end

--------------------------------------------------------------------------------
-- スクロールサイズを返します.
--------------------------------------------------------------------------------
function M:getScrollSize()
    return self:getScrollWidth(), self:getScrollHeight()
end

--------------------------------------------------------------------------------
-- 水平方向のスクロールが行えるかどうか設定します.
--------------------------------------------------------------------------------
function M:setHScrollEnabled(value)
    self.__internal.hScrollEnabled = value
end

--------------------------------------------------------------------------------
-- 水平方向のスクロールが行えるかどうか設定します.
--------------------------------------------------------------------------------
function M:isHScrollEnabled()
    return self.__internal.hScrollEnabled
end

--------------------------------------------------------------------------------
-- 垂直方向のスクロールが行えるかどうか設定します.
--------------------------------------------------------------------------------
function M:setVScrollEnabled(value)
    self.__internal.vScrollEnabled = value
end

--------------------------------------------------------------------------------
-- 垂直方向のスクロールが行えるかどうか返します.
--------------------------------------------------------------------------------
function M:isVScrollEnabled()
    return self.__internal.vScrollEnabled
end

--------------------------------------------------------------------------------
-- スクロール時の摩擦係数を設定します.
--------------------------------------------------------------------------------
function M:setFriction(value)
    self.__internal.friction = value
end

--------------------------------------------------------------------------------
-- スクロール時の摩擦係数を返します.
--------------------------------------------------------------------------------
function M:getFriction()
    return self.__internal.friction
end

--------------------------------------------------------------------------------
-- スクロール中かどうか返します.
--------------------------------------------------------------------------------
function M:isScrolling()
    return self.__internal.scrolling
end

--------------------------------------------------------------------------------
-- 1フレームでスクロールする量を返します.
--------------------------------------------------------------------------------
function M:getScrollingForceX()
    return self.__internal.scrollingForceX
end

--------------------------------------------------------------------------------
-- 1フレームでスクロールする量を返します.
--------------------------------------------------------------------------------
function M:getScrollingForceY()
    return self.__internal.scrollingForceY
end

--------------------------------------------------------------------------------
-- 1フレームでスクロールする量を返します.
--------------------------------------------------------------------------------
function M:getScrollingForce()
    return self:getScrollingForceX(), self:getScrollingForceY()
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を設定します.
--------------------------------------------------------------------------------
function M:setMaxScrollingForceX(value)
    self.__internal.maxScrollingForceX = value
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を返します.
--------------------------------------------------------------------------------
function M:getMaxScrollingForceX()
    return self.__internal.maxScrollingForceX
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を設定します.
--------------------------------------------------------------------------------
function M:setMaxScrollingForceY(value)
    self.__internal.maxScrollingForceY = value
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を返します.
--------------------------------------------------------------------------------
function M:getMaxScrollingForceY()
    return self.__internal.maxScrollingForceY
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を設定します.
--------------------------------------------------------------------------------
function M:setMaxScrollingForce(x, y)
    self:setMaxScrollingForceX(x)
    self:setMaxScrollingForceY(y)
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最大量を返します.
--------------------------------------------------------------------------------
function M:getMaxScrollingForce()
    return self:getMaxScrollingForceX(), self:getMaxScrollingForceY()
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を設定します.
--------------------------------------------------------------------------------
function M:setMinScrollingForceX(value)
    self.__internal.minScrollingForceX = value
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を返します.
--------------------------------------------------------------------------------
function M:getMinScrollingForceX()
    return self.__internal.minScrollingForceX
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を設定します.
--------------------------------------------------------------------------------
function M:setMinScrollingForceY(value)
    self.__internal.minScrollingForceY = value
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を返します.
--------------------------------------------------------------------------------
function M:getMinScrollingForceY()
    return self.__internal.minScrollingForceY
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を設定します.
--------------------------------------------------------------------------------
function M:setMinScrollingForce(x, y)
    self:setMinScrollingForceX(x)
    self:setMinScrollingForceY(y)
end

--------------------------------------------------------------------------------
-- 1フレームでスクロール可能な最小量を返します.
--------------------------------------------------------------------------------
function M:getMinScrollingForce()
    return self:getMinScrollingForceX(), self:getMinScrollingForceY()
end

--------------------------------------------------------------------------------
-- 最後にタッチした場所を返します.
--------------------------------------------------------------------------------
function M:getLastTouchLoc()
    return self.__internal.lastTouchX, self.__internal.lastTouchY
end

--------------------------------------------------------------------------------
-- タッチ中かどうか返します.
--------------------------------------------------------------------------------
function M:isTouching()
    return self.__internal.touchDownFlag
end

--------------------------------------------------------------------------------
-- 左上原点でスクロール座標を設定します.
--------------------------------------------------------------------------------
function M:setScrollLoc(x, y)
    --TODO
end

--------------------------------------------------------------------------------
-- 指定した座標だけ、指定した時間で移動します.
-- 移動のロジックはmodeで指定できます.
-- modeには、MOAIEaseTypeの値を指定します.
--------------------------------------------------------------------------------
function M:moveScrollLoc(x, y, sec, mode)
    --TODO
end

--------------------------------------------------------------------------------
-- 指定した座標に、指定した時間で移動します.
-- 移動のロジックはmodeで指定できます.
-- modeには、MOAIEaseTypeの値を指定します.
--------------------------------------------------------------------------------
function M:seekScrollLoc(x, y, sec, mode)
    --TODO
end

--------------------------------------------------------------------------------
-- スクロールを停止します.
--------------------------------------------------------------------------------
function M:stopScroll()

end

--------------------------------------------------------------------------------
-- フレーム更新時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onEnterFrame(e)
    if not self:isEnabled() then
        return
    end
    if self.__internal.scrollSizeChanged then
        self.__internal.scrollSizeChanged = false
        self:updateScrollSizeForChildren()
    end
    
    self:onScrollStep()
    
    super.onEnterFrame(self, e)
end

--------------------------------------------------------------------------------
-- スクロールサイズを子の範囲に更新します.
--------------------------------------------------------------------------------
function M:updateScrollSizeForChildren()
    local xMin, yMin, xMax, yMax = 0, 0, 0, 0
    for i, child in ipairs(self:getChildren()) do
        xMax = math.max(xMax, child:getRight())
        yMax = math.max(yMax, child:getBottom())
    end
    local width, height = xMax - xMin, yMax - yMin
    self:setScrollSize(width, height)
end

--------------------------------------------------------------------------------
-- ステップ毎のスクロール処理です.
-- TODO:リファクタリング
--------------------------------------------------------------------------------
function M:onScrollStep()
    -- タッチ中の場合、タッチで移動した量にセット
    if self:isTouching() then
        local totalX, totalY = self.__internal.scrollingTotalX, self.__internal.scrollingTotalY
        self.__internal.scrollingForceX = totalX
        self.__internal.scrollingForceY = totalY
    end
    
    if self:isScrolling() then
        local maxScrollX, maxScrollY = self:getMaxScrollingForce()
        local minScrollX, minScrollY = self:getMinScrollingForce()
        local scrollX, scrollY = self:getScrollingForce()
        
        scrollX = (-minScrollX < scrollX and scrollX < minScrollX) and 0 or scrollX
        scrollY = (-minScrollY < scrollY and scrollY < minScrollY) and 0 or scrollY

        scrollX = scrollX < -maxScrollX and -maxScrollX or scrollX
        scrollX = maxScrollX < scrollX  and  maxScrollX or scrollX
        scrollY = scrollY < -maxScrollY and -maxScrollY or scrollY
        scrollY = maxScrollY < scrollY  and  maxScrollY or scrollY
        
        local camera = self:getCamera()
        camera:addLoc(scrollX, scrollY)
        
        self:ajustScrollLoc()
        
        if not self:isTouching() then
            local rate = (1 - self:getFriction())
            scrollX = scrollX * rate
            scrollY = scrollY * rate
        end

        self.__internal.scrollingForceX = scrollX
        self.__internal.scrollingForceY = scrollY
        
        if scrollX == 0 and scrollY == 0 then
            self.__internal.scrolling = false
        end
    end

    self.__internal.scrollingTotalX = 0
    self.__internal.scrollingTotalY = 0
end

--------------------------------------------------------------------------------
-- スクロールがView内に収まるようにします.
-- TODO:範囲外に飛び出たときにスクロールが戻るアニメーションがほしい
--------------------------------------------------------------------------------
function M:ajustScrollLoc()
    local camera = self:getCamera()
    local scrollX, scrollY = camera:getLoc()
    local width, height = self:getViewSize()
    local scrollWidth, scrollHeight = self:getScrollSize()
    local maxX, maxY = scrollWidth - width, scrollHeight - height
        
    scrollX = scrollX < 0 and 0 or scrollX
    scrollY = scrollY < 0 and 0 or scrollY
    scrollX = scrollX > maxX and maxX or scrollX
    scrollY = scrollY > maxY and maxY or scrollY
    
    camera:setLoc(scrollX, scrollY, 0)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchDown(e)
    if not self:isEnabled() then
        return
    end
    
    local worldX, worldY = e.x, e.y
    self.__internal.lastTouchX = worldX
    self.__internal.lastTouchY = worldY
    self.__internal.scrollingTotalX = 0
    self.__internal.scrollingTotalY = 0
    self.__internal.touchDownFlag = true
    
    super.onTouchDown(self, e)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchUp(e)
    if not self:isEnabled() then
        return
    end

    self.__internaltouchDownFlag = false
    self.__internalscrolling = true
    
    super.onTouchUp(self, e)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchMove(e)
    if not self:isEnabled() then
        return
    end
    
    local scaleX, scaleY = self:getViewScale()
    local moveX, moveY = -e.moveX / scaleX, -e.moveY / scaleY
    
    moveX = self:isHScrollEnabled() and moveX or 0
    moveY = self:isVScrollEnabled() and moveY or 0
    
    local totalX, totalY = self.__internal.scrollingTotalX + moveX, self.__internal.scrollingTotalY + moveY

    self.__internal.lastTouchX = worldX
    self.__internal.lastTouchY = worldY
    self.__internal.scrolling = true
    self.__internal.scrollingTotalX = totalX
    self.__internal.scrollingTotalY = totalY
    
    super.onTouchMove(self, e)
end

--------------------------------------------------------------------------------
-- タッチした時のイベントリスナです.
--------------------------------------------------------------------------------
function M:onTouchCancel(e)
    super.onTouchCancel(self, e)
end

return M