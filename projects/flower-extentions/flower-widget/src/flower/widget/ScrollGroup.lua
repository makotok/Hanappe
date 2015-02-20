----------------------------------------------------------------------------------------------------
-- Scrollable Group class.
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local math = require "flower.math"
local Executors = require "flower.Executors"
local NineImage = require "flower.NineImage"
local Graphics = require "flower.Graphics"
local UIEvent = require "flower.widget.UIEvent"
local UIGroup = require "flower.widget.UIGroup"

-- class
local ScrollGroup = class(UIGroup)

--- Style: friction
ScrollGroup.STYLE_FRICTION = "friction"

--- Style: scrollPolicy
ScrollGroup.STYLE_SCROLL_POLICY = "scrollPolicy"

--- Style: bouncePolicy
ScrollGroup.STYLE_BOUNCE_POLICY = "bouncePolicy"

--- Style: scrollForceBounds
ScrollGroup.STYLE_SCROLL_FORCE_LIMITS = "scrollForceLimits"

--- Style: verticalScrollBarColor
ScrollGroup.STYLE_VERTICAL_SCROLL_BAR_COLOR = "verticalScrollBarColor"

--- Style: verticalScrollBarTexture
ScrollGroup.STYLE_VERTICAL_SCROLL_BAR_TEXTURE = "verticalScrollBarTexture"

--- Style: horizontalScrollBarTexture
ScrollGroup.STYLE_HORIZONTAL_SCROLL_BAR_COLOR = "horizontalScrollBarColor"

--- Style: horizontalScrollBarTexture
ScrollGroup.STYLE_HORIZONTAL_SCROLL_BAR_TEXTURE = "horizontalScrollBarTexture"

---
-- Initializes the internal variables.
function ScrollGroup:_initInternal()
    ScrollGroup.__super._initInternal(self)
    self._themeName = "ScrollGroup"
    self._scrollForceX = 0
    self._scrollForceY = 0
    self._contentGroup = nil
    self._contentBackground = nil
    self._looper = nil
    self._touchDownIndex = nil
    self._touchScrolledFlg = false
    self._touchStartX = nil
    self._touchStartY = nil
    self._touchLastX = nil
    self._touchLastY = nil
    self._scrollToAnim = nil
    self._scrollBarHideAction = nil
    self._verticalScrollBar = nil
    self._horizontalScrollBar = nil

    self:setScissorContent(true)
end

---
-- Performing the initialization processing of the event listener.
function ScrollGroup:_initEventListeners()
    ScrollGroup.__super._initEventListeners(self)
    self:addEventListener(UIEvent.TOUCH_DOWN, self.onTouchDown, self, -20)
    self:addEventListener(UIEvent.TOUCH_UP, self.onTouchUp, self, -20)
    self:addEventListener(UIEvent.TOUCH_MOVE, self.onTouchMove, self, -20)
    self:addEventListener(UIEvent.TOUCH_CANCEL, self.onTouchCancel, self, -20)
end

---
-- Performing the initialization processing of the component.
function ScrollGroup:_createChildren()
    self:_createContentBackground()
    self:_createContentGroup()
    self:_createScrollBar()
end

function ScrollGroup:_createContentBackground()
    self._contentBackground = Graphics(self:getSize())
    self._contentBackground._excludeLayout = true
end

function ScrollGroup:_createContentGroup()
    self._contentGroup = UIGroup()
    self._contentGroup:setSize(self:getSize())
    self._contentGroup:addChild(self._contentBackground)
    self:addChild(self._contentGroup)
end

---
-- Create the scrollBar
function ScrollGroup:_createScrollBar()
    self._verticalScrollBar = NineImage(self:getStyle(ScrollGroup.STYLE_VERTICAL_SCROLL_BAR_TEXTURE))
    self._horizontalScrollBar = NineImage(self:getStyle(ScrollGroup.STYLE_HORIZONTAL_SCROLL_BAR_TEXTURE))

    self._verticalScrollBar:setVisible(false)
    self._horizontalScrollBar:setVisible(false)

    self:addChild(self._verticalScrollBar)
    self:addChild(self._horizontalScrollBar)
end

---
-- Update the scroll size.
function ScrollGroup:_updateScrollSize()
    local width, height = 0, 0
    local minWidth, minHeight = self:getSize()
    
    for i, child in ipairs(self._contentGroup:getChildren()) do
        if not child._excludeLayout then
            width  = math.max(width, child:getRight())
            height = math.max(height, child:getBottom())
        end
    end

    width = width >= minWidth and width or minWidth
    height = height >= minHeight and height or minHeight

    self._contentGroup:setSize(width, height)
    self._contentBackground:setSize(width, height)
end

---
-- Update the vertical scroll bar.
function ScrollGroup:_updateScrollBar()
    local vBar = self._verticalScrollBar
    local hBar = self._horizontalScrollBar

    local width, height = self:getSize()
    local contentW, contentH = self._contentGroup:getSize()
    local contentX, contentY = self._contentGroup:getPos()
    local maxContentX, maxContentY = math.max(0, contentW - width), math.max(0, contentH - height)

    local hBarW = math.floor(math.max(width / contentW * width, hBar.displayWidth))
    local hBarH = hBar:getHeight()
    local hBarX = math.floor(-contentX / maxContentX * (width - hBarW))
    local hBarY = height - hBarH

    local vBarW = vBar:getWidth()
    local vBarH = math.floor(math.max(height / contentH * height, vBar.displayHeight))
    local vBarX = width - vBarW
    local vBarY = math.floor(-contentY / maxContentY * (height - vBarH))

    hBar:setSize(hBarW, hBarH)
    hBar:setPos(hBarX, hBarY)
    vBar:setSize(vBarW, vBarH)
    vBar:setPos(vBarX, vBarY)
end

---
-- Show scroll bars.
function ScrollGroup:_showScrollBar()
    if self._scrollBarHideAction then
        self._scrollBarHideAction:stop()
        self._scrollBarHideAction = nil
    end

    local maxX, maxY = self:getMaxScrollPosition()

    self._horizontalScrollBar:setVisible(maxX > 0)
    self._horizontalScrollBar:setColor(unpack(self:getStyle(ScrollGroup.STYLE_HORIZONTAL_SCROLL_BAR_COLOR)))

    self._verticalScrollBar:setVisible(maxY > 0)
    self._verticalScrollBar:setColor(unpack(self:getStyle(ScrollGroup.STYLE_VERTICAL_SCROLL_BAR_COLOR)))
end

---
-- Hide scroll bars.
function ScrollGroup:_hideScrollBar()
    if not self._scrollBarHideAction then
        local action1 = self._verticalScrollBar:seekColor(0, 0, 0, 0, 1)
        local action2 = self._horizontalScrollBar:seekColor(0, 0, 0, 0, 1)

        self._scrollBarHideAction = MOAIAction.new()
        self._scrollBarHideAction:addChild(action1)
        self._scrollBarHideAction:addChild(action2)
        self._scrollBarHideAction:setListener(MOAIAction.EVENT_STOP, function() self:onStopScrollBarHideAction() end )
        self._scrollBarHideAction:start()
    end
end

---
-- Update of the scroll processing.
function ScrollGroup:_updateScrollPosition()
    if self:isTouching() then
        self:_hideScrollBar()
        self:_stopLooper()
        return
    end
    if self:isScrollAnimating() then
        return
    end
    if not self:isScrolling() then

        local left, top = self:getScrollPosition()
        if self:isPositionOutOfBounds(left, top) then
            local clippedLeft, clippedTop = self:clipScrollPosition(left, top)
            self:scrollTo(clippedLeft, clippedTop, 0.5, MOAIEaseType.SOFT_EASE_IN)
        else
            self:_hideScrollBar()
            self:_stopLooper()
        end
        return
    end

    local left, top = self:getScrollPosition()
    local scrollX, scrollY = self:getScrollForceVec()
    local rateX, rateY = (1 - self:getFriction()), (1 - self:getFriction())
    local hBounceEnabled, vBounceEnabled = self:getBouncePolicy()

    rateX = self:isPositionOutOfHorizontal(left) and rateX * 0.35 or rateX
    rateY = self:isPositionOutOfVertical(top) and rateY * 0.35 or rateY

    self:addScrollPosition(scrollX, scrollY)
    self:setScrollForceVec(scrollX * rateX, scrollY * rateY)

    self:_ajustScrollPosition()
end

---
-- Adjusted so as to fall within the scope of the scroll.
function ScrollGroup:_ajustScrollPosition()
    local hBounceEnabled, vBounceEnabled = self:getBouncePolicy()
    local scrollX, scrollY = self:getScrollPosition()
    local clipX, clipY = self:clipScrollPosition(scrollX, scrollY)
    local forceX, forceY = self:getScrollForceVec()

    -- Clips the new position when bouncing is disabled
    if not hBounceEnabled and self:isPositionOutOfHorizontal(scrollX) then
        forceX = 0
        scrollX = clipX
        
    end
    if not vBounceEnabled and self:isPositionOutOfVertical(scrollY) then
        forceY = 0
        scrollY = clipY
    end

    self:setScrollPosition(scrollX, scrollY)
    self:setScrollForceVec(forceX, forceY)
end


---
-- Start looper.
function ScrollGroup:_startLooper()
    if not self._looper then
        self._looper = Executors.callLoop(self.onEnterFrame, self)
    end
end

---
-- Stop looper.
function ScrollGroup:_stopLooper()
    if self._looper then
        self._looper:stop()
        self._looper = nil
    end
end

---
-- Return the contentBackground
-- @return contentBackground
function ScrollGroup:getContentBackground()
    return self._contentBackground
end

---
-- Return the contentGroup
-- @return contentGroup
function ScrollGroup:getContentGroup()
    return self._contentGroup
end

---
-- Returns the contentGroup size.
-- @return width
-- @return height
function ScrollGroup:getContentSize()
    return self._contentGroup:getSize()
end

---
-- Add the content to contentGroup.
-- @param content
function ScrollGroup:addContent(content)
    self._contentGroup:addChild(content)
end

---
-- Add the content from contentGroup.
-- @param content
function ScrollGroup:removeContent(content)
    self._contentGroup:removeChild(content)
end

---
-- Add the content to contentGroup.
-- @param contents
function ScrollGroup:setContents(contents)
    self._contentGroup:removeChildren()
    self._contentGroup:addChild(self._contentBackground)
    self._contentGroup:addChildren(contents)
end

---
-- Also changes the size of the scroll container when layout update.
function ScrollGroup:updateLayout()
    ScrollGroup.__super.updateLayout(self)
    self:_updateScrollSize()
    self:_updateScrollBar()
end

---
-- Set the layout.
-- @param layout layout
function ScrollGroup:setLayout(layout)
    self._contentGroup:setLayout(layout)
end

---
-- Set the coefficient of friction at the time of scrolling.
-- @param value friction
function ScrollGroup:setFriction(value)
    self:setStyle(ScrollGroup.STYLE_FRICTION, value)
end

---
-- Returns the coefficient of friction at the time of scrolling.
-- @return friction
function ScrollGroup:getFriction()
    return self:getStyle(ScrollGroup.STYLE_FRICTION)
end

---
-- Sets the horizontal and vertical scroll enabled.
-- @param horizontal horizontal scroll is enabled.
-- @param vertical vertical scroll is enabled.
function ScrollGroup:setScrollPolicy(horizontal, vertical)
    if horizontal == nil then horizontal = true end
    if vertical == nil then vertical = true end

    self:setStyle(ScrollGroup.STYLE_SCROLL_POLICY, {horizontal, vertical})
end

---
-- Return the scroll policy.
-- @return horizontal scroll enabled.
-- @return vertical scroll enabled.
function ScrollGroup:getScrollPolicy()
    return unpack(self:getStyle(ScrollGroup.STYLE_SCROLL_POLICY))
end

---
-- Sets the horizontal and vertical bounce enabled.
-- @param horizontal horizontal scroll is enabled.
-- @param vertical vertical scroll is enabled.
function ScrollGroup:setBouncePolicy(horizontal, vertical)
    if horizontal == nil then horizontal = true end
    if vertical == nil then vertical = true end

    self:setStyle(ScrollGroup.STYLE_BOUNCE_POLICY, {horizontal, vertical})
end

---
-- Returns whether horizontal bouncing is enabled.
-- @return horizontal bouncing enabled
-- @return vertical bouncing enabled
function ScrollGroup:getBouncePolicy()
    return unpack(self:getStyle(ScrollGroup.STYLE_BOUNCE_POLICY))
end

---
-- If this component is scrolling returns true.
-- @return scrolling
function ScrollGroup:isScrolling()
    return self._scrollForceX ~= 0 or self._scrollForceY~= 0
end

---
-- Sets the scroll position.
-- @param x x-position.
-- @param y y-position.
function ScrollGroup:setScrollPosition(x, y)
    self._contentGroup:setPos(x, y)
end

---
-- Sets the scroll position.
-- @param x x-position.
-- @param y y-position.
function ScrollGroup:addScrollPosition(x, y)
    self._contentGroup:addLoc(x, y, 0)
end

---
-- Returns the scroll position.
-- @return x-position.
-- @return y-position.
function ScrollGroup:getScrollPosition()
    return self._contentGroup:getPos()
end

---
-- Returns the max scroll position.
-- @return max x-position.
-- @return max y-position.
function ScrollGroup:getMaxScrollPosition()
    local scrollW, scrollH = self:getSize()
    local contentW, contentH = self._contentGroup:getSize()
    local maxScrollX, maxScrollY = math.max(0, contentW - scrollW), math.max(0, contentH - scrollH)
    return maxScrollX, maxScrollY
end

---
-- Sets the force to scroll in one frame.
-- It does not make sense if you're touch.
-- @param x x force
-- @param y y force
function ScrollGroup:setScrollForceVec(x, y)
    local hScrollEnabled, vScrollEnabled = self:getScrollPolicy()
    local minScrollX, minScrollY, maxScrollX, maxScrollY = self:getScrollForceLimits()
    local scrollX, scrollY = self:getScrollForceVec()
    
    scrollX = hScrollEnabled and x or 0
    scrollX = (-minScrollX < scrollX and scrollX < minScrollX) and 0 or scrollX
    scrollX = scrollX < -maxScrollX and -maxScrollX or scrollX
    scrollX = maxScrollX < scrollX  and  maxScrollX or scrollX

    scrollY = vScrollEnabled and y or 0
    scrollY = (-minScrollY < scrollY and scrollY < minScrollY) and 0 or scrollY
    scrollY = scrollY < -maxScrollY and -maxScrollY or scrollY
    scrollY = maxScrollY < scrollY  and  maxScrollY or scrollY
    
    self._scrollForceX = scrollX
    self._scrollForceY = scrollY
end

---
-- Returns the force to scroll in one frame.
-- @return x force
-- @return y force
function ScrollGroup:getScrollForceVec()
    return self._scrollForceX, self._scrollForceY
end

---
-- Sets the scroll force in one frame.
-- @param minX x force
-- @param minY y force
-- @param maxX x force
-- @param maxY y force
function ScrollGroup:setScrollForceLimits(minX, minY, maxX, maxY)
    self:setStyle(ScrollGroup.STYLE_SCROLL_FORCE_LIMITS, {minX, minY, maxX, maxY})
end

---
-- Returns the maximum force in one frame.
-- @param x force
-- @param y force
function ScrollGroup:getScrollForceLimits()
    return unpack(self:getStyle(ScrollGroup.STYLE_SCROLL_FORCE_LIMITS))
end

---
-- If the user has touched returns true.
-- @return If the user has touched returns true.
function ScrollGroup:isTouching()
    return self._touchDownIndex ~= nil
end

---
-- Scroll to the specified location.
-- @param x position of the x
-- @param y position of the x
-- @param sec second
-- @param mode EaseType
-- @param callback (optional) allows callback notification when animation completes.
function ScrollGroup:scrollTo(x, y, sec, mode, callback)
    local x, y = self:clipScrollPosition(x, y)
    local px, py, pz = self._contentGroup:getPiv()
    mode = mode or MOAIEaseType.SHARP_EASE_IN

    self:stopScrollAnimation()
    self._scrollToAnim = self._contentGroup:seekLoc(x + px, y + py, 0, sec, mode)
    self._scrollToAnim:setListener(MOAIAction.EVENT_STOP, function() self:onStopScrollAnimation() end )
end

---
-- Computes the boundaries of the scroll area.
-- @return the min and max values of the scroll area
function ScrollGroup:getScrollBounds()
    local childWidth, childHeight = self._contentGroup:getSize()
    local parentWidth, parentHeight = self:getSize()
    local minX, minY = parentWidth - childWidth, parentHeight - childHeight
    local maxX, maxY = 0, 0

    return minX, minY, maxX, maxY
end

---
-- Returns whether the input position is out of bounds.
-- @param left The x position
-- @param top The y position
-- @return boolean
function ScrollGroup:isPositionOutOfBounds(left, top)
    local minX, minY, maxX, maxY = self:getScrollBounds()

    return left < minX or left > maxX or top < minY or top > maxY
end

---
-- Returns whether the input position is out of bounds.
-- @param left The x position
-- @return boolean
function ScrollGroup:isPositionOutOfHorizontal(left)
    local minX, minY, maxX, maxY = self:getScrollBounds()

    return left < minX or left > maxX
end

---
-- Returns whether the input position is out of bounds.
-- @param left The x position
-- @return boolean
function ScrollGroup:isPositionOutOfVertical(top)
    local minX, minY, maxX, maxY = self:getScrollBounds()

    return top < minY or top > maxY
end

---
-- Clips the input position to the size of the container
-- @param left The x position
-- @param top The y position
-- @return clipped left and top
function ScrollGroup:clipScrollPosition(left, top)
    local minX, minY, maxX, maxY = self:getScrollBounds()
    left = left < minX and minX or left
    left = left > maxX and maxX or left
    top  = top  < minY and minY or top
    top  = top  > maxY and maxY or top

    return left, top
end

---
-- Returns whether the scrollTo animation is running.
-- @return boolean
function ScrollGroup:isScrollAnimating()
    return self._scrollToAnim and self._scrollToAnim:isBusy()
end

---
-- Stops the scrollTo animation if it's running
-- @return none
function ScrollGroup:stopScrollAnimation()
    if self._scrollToAnim then
        self._scrollToAnim:stop()
        self._scrollToAnim = nil
    end
end

---
-- TODO:LDoc
function ScrollGroup:dispatchTouchCancelEvent()
    if not self.layer or not self.layer.touchHandler then
        return
    end

    local e = UIEvent(UIEvent.TOUCH_CANCEL)
    for k, prop in pairs(self.layer.touchHandler.touchProps) do
        e.idx = k
        while prop do
            if prop.dispatchEvent then
                e.prop = prop
                prop:dispatchEvent(e)
            end
            prop = prop.parent

            if prop == self then
                break
            end
        end
    end
end

function ScrollGroup:setOnScroll(func)
    self:setEventListener(UIEvent.SCROLL, func)
end

---
-- Update frame.
function ScrollGroup:onEnterFrame()
    self:_updateScrollPosition()
    self:_updateScrollBar()
    self:dispatchEvent(UIEvent.SCROLL)
end

---
-- Update frame.
function ScrollGroup:onStopScrollAnimation()
    self:stopScrollAnimation()
    self:_stopLooper()
    self:_hideScrollBar()
    self:_updateScrollBar()
end

function ScrollGroup:onStopScrollBarHideAction()
    self._scrollBarHideAction = nil
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollGroup:onTouchDown(e)
    if self:isTouching() then
        return
    end

    self._scrollForceX = 0
    self._scrollForceY = 0
    self._touchDownIndex = e.idx
    self._touchScrolledFlg = false
    self._touchStartX = e.wx
    self._touchStartY = e.wy
    self._touchLastX = e.wx
    self._touchLastY = e.wy

    self:_stopLooper()
    self:stopScrollAnimation()
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollGroup:onTouchUp(e)
    if self._touchDownIndex ~= e.idx then
        return
    end
    
    self._touchDownIndex = nil
    self._touchScrolledFlg = false
    self._touchStartX = nil
    self._touchStartY = nil
    self._touchLastX = nil
    self._touchLastY = nil

    self:_startLooper()
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollGroup:onTouchMove(e)
    if self._touchDownIndex ~= e.idx then
        return
    end
    if not self._touchScrolledFlg and math.abs(e.wx - self._touchStartX) < 20 and math.abs(e.wy - self._touchStartY) < 20 then
        self._touchLastX = e.wx
        self._touchLastY = e.wy
        return
    end
    if self._touchLastX == e.wx and self._touchLastY == e.wy then
        return
    end
    if not self._touchScrolledFlg then
        self:dispatchTouchCancelEvent()
        self._touchScrolledFlg = true
        self:_showScrollBar()
    end

    local moveX, moveY = e.wx - self._touchLastX , e.wy - self._touchLastY
    self:setScrollForceVec(moveX, moveY)
    moveX, moveY = self:getScrollForceVec()

    local minX, minY, maxX, maxY = self:getScrollBounds()
    local left, top = self:getScrollPosition()
    local newLeft, newTop = left + moveX, top + moveY

    local clippedLeft, clippedTop = self:clipScrollPosition(newLeft, newTop)
    local diff = math.distance(clippedLeft, clippedTop, newLeft, newTop)
    local hBounceEnabled, vBounceEnabled = self:getBouncePolicy()

    if hBounceEnabled and self:isPositionOutOfHorizontal(newLeft) then
        moveX = (math.attenuation(diff) * moveX)
    end
    if vBounceEnabled and self:isPositionOutOfVertical(newTop) then
        moveY = (math.attenuation(diff) * moveY)
    end

    self:addScrollPosition(moveX, moveY, 0)
    self:_updateScrollBar()
    self._touchLastX = e.wx
    self._touchLastY = e.wy

    self:_ajustScrollPosition()
end

---
-- This event handler is called when you touch the component.
-- @param e touch event
function ScrollGroup:onTouchCancel(e)
    self:onTouchUp(e)
end

return ScrollGroup