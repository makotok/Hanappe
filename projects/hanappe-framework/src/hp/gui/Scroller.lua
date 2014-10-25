----------------------------------------------------------------
-- This class will scroll according to the size of the parent.
-- By a parent View, and typically in the range can scroll the screen.
-- TODO:I moved just by touch. It is necessary to have a little margin.
----------------------------------------------------------------

-- import
local table             = require "hp/lang/table"
local class             = require "hp/lang/class"
local Layer             = require "hp/display/Layer"
local Event             = require "hp/event/Event"
local Component         = require "hp/gui/Component"
local Executors         = require "hp/util/Executors"
local math              = require "hp/lang/math"

-- class
local super             = Component
local M                 = class(Component)

-- Computes attenuation as a function of distance.
-- @param distance Distance
-- @return distance^(-2/3)
local function attenuation(distance)
    distance = distance == 0 and 1 or math.pow(distance, 0.667)
    return 1 / distance
end

--------------------------------------------------------------------------------
-- Initializes the internal variables.
--------------------------------------------------------------------------------
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
    self._touchMoved = false
    self._themeName = "Scroller"
    self._disposed = false

    self._scrollToAnimation = nil
    self._hBounceEnabled = true
    self._vBounceEnabled = true
    
    Executors.callLoop(self.enterFrame, self)
end

--------------------------------------------------------------------------------
-- Update frame.
--------------------------------------------------------------------------------
function M:enterFrame()
    if self._disposed then
        return true
    end
    self:updateScroll()
end

--------------------------------------------------------------------------------
-- Update of the scroll processing.
--------------------------------------------------------------------------------
function M:updateScroll()
    self._touchMoved = false
    if self:isTouching() then
        return
    end

    if not self:isScrolling() then
        -- If we're not scrolling, not animating and are O.B., initiate scrollTo()
        if not self:isAnimating() then
            local left, top = self:getPos()
            if self:isPositionOutOfBounds(left, top) then
                local clippedLeft, clippedTop = self:clipScrollPosition(left, top)
                self:scrollTo(clippedLeft, clippedTop, 0.5, MOAIEaseType.SOFT_EASE_IN)
            end
        end

        return
    end
    
    local scrollX, scrollY = self:getScrollingForce()
    local rate = (1 - self:getFriction())

    -- Increase the attenuation when we're out of bounds
    local left, top = self:getPos()
    if self:isPositionOutOfBounds(left, top) then
        rate = 0.35 * rate
    end

    self:addLoc(scrollX, scrollY, 0)
    self:setScrollingForce(scrollX * rate, scrollY * rate)
    self:ajustScrollPosition()
end

--------------------------------------------------------------------------------
-- Also changes the size of the scroll container when layout update.
--------------------------------------------------------------------------------
function M:updateLayout()
    super.updateLayout(self)
    self:ajustScrollSize()
end

--------------------------------------------------------------------------------
-- Sets whether to automatically update the scroll range.
-- @param value auto resizing
--------------------------------------------------------------------------------
function M:setAutoResizing(value)
    self._autoResizing = value
end

--------------------------------------------------------------------------------
-- Returns whether to automatically update the scroll range.
-- @return auto resizing
--------------------------------------------------------------------------------
function M:isAutoResizing()
    return self._autoResizing
end

--------------------------------------------------------------------------------
-- Sets whether the horizontal scroll is enabled.
-- @param value horizontal scroll enabled
--------------------------------------------------------------------------------
function M:setHScrollEnabled(value)
    self._hScrollEnabled = value
end

--------------------------------------------------------------------------------
-- Returns whether the horizontal scroll is enabled.
-- @return horizontal scroll enabled
--------------------------------------------------------------------------------
function M:isHScrollEnabled()
    return self._hScrollEnabled
end

--------------------------------------------------------------------------------
-- Sets whether the vertical scroll is enabled.
-- @param value vertical scroll enabled
--------------------------------------------------------------------------------
function M:setVScrollEnabled(value)
    self._vScrollEnabled = value
end

--------------------------------------------------------------------------------
-- Returns whether the vertical scroll is enabled.
-- @return vertical scroll enabled
--------------------------------------------------------------------------------
function M:isVScrollEnabled()
    return self._vScrollEnabled
end

--------------------------------------------------------------------------------
-- Sets the ability to bounce horizontally.
-- @param value horizontal bouncing enabled
--------------------------------------------------------------------------------
function M:setHBounceEnabled(value)
    self._hBounceEnabled = value
end

--------------------------------------------------------------------------------
-- Returns whether horizontal bouncing is enabled.
-- @return horizontal bouncing enabled
--------------------------------------------------------------------------------
function M:isHBouncelEnabled()
    return self._hBounceEnabled
end

--------------------------------------------------------------------------------
-- Sets the ability to bounce vertically.
-- @param value vertical bouncing enabled
--------------------------------------------------------------------------------
function M:setVBounceEnabled(value)
    self._vBounceEnabled = value
end

--------------------------------------------------------------------------------
-- Returns whether vertical bouncing is enabled.
-- @return vertical bouncing enabled
--------------------------------------------------------------------------------
function M:isVBounceEnabled()
    return self._vBounceEnabled
end

--------------------------------------------------------------------------------
-- Set the coefficient of friction at the time of scrolling.
-- @param value friction
--------------------------------------------------------------------------------
function M:setFriction(value)
    self._friction = value
end

--------------------------------------------------------------------------------
-- Returns the coefficient of friction at the time of scrolling.
-- @return friction
--------------------------------------------------------------------------------
function M:getFriction()
    return self._friction
end

--------------------------------------------------------------------------------
-- If this component is scrolling returns true.
-- @return scrolling
--------------------------------------------------------------------------------
function M:isScrolling()
    return self._scrollingForceX ~= 0 or self._scrollingForceY ~= 0
end

--------------------------------------------------------------------------------
-- Sets the force to scroll in one frame.
-- It does not make sense if you're touch.
-- @param x x force
-- @param y y force
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
-- Returns the force to scroll in one frame.
-- @return x force
-- @return y force
--------------------------------------------------------------------------------
function M:getScrollingForce()
    return self._scrollingForceX, self._scrollingForceY
end

--------------------------------------------------------------------------------
-- Sets the maximum force in one frame.
-- @param x x force
-- @param y y force
--------------------------------------------------------------------------------
function M:setMaxScrollingForce(x, y)
    self._maxScrollingForceX = x
    self._maxScrollingForceY = y
end

--------------------------------------------------------------------------------
-- Returns the maximum force in one frame.
-- @param x force
-- @param y force
--------------------------------------------------------------------------------
function M:getMaxScrollingForce()
    return self._maxScrollingForceX, self._maxScrollingForceY
end

--------------------------------------------------------------------------------
-- Sets the minimum force in one frame.
-- @param x x force
-- @param y y force
--------------------------------------------------------------------------------
function M:setMinScrollingForce(x, y)
    self._minScrollingForceX = x
    self._minScrollingForceY = y
end

--------------------------------------------------------------------------------
-- Returns the minimum force in one frame.
-- @param x force
-- @param y force
--------------------------------------------------------------------------------
function M:getMinScrollingForce()
    return self._minScrollingForceX, self._minScrollingForceY
end

--------------------------------------------------------------------------------
-- If the user has touched returns true.
-- @return If the user has touched returns true.
--------------------------------------------------------------------------------
function M:isTouching()
    return self._touchDownFlag
end

--------------------------------------------------------------------------------
-- Scroll to the specified location.
-- @param x position of the x
-- @param y position of the x
-- @param sec second
-- @param mode EaseType
-- @param callback (optional) allows callback notification when animation completes.
--------------------------------------------------------------------------------
function M:scrollTo(x, y, sec, mode, callback)
    mode = mode or MOAIEaseType.SHARP_EASE_IN
    local x, y = self:clipScrollPosition(x, y)
    self:stopAnimation()
    self._scrollToAnimation = Animation(self, sec, mode):seekLoc(x, y, 0)
    self._scrollToAnimation:play({onComplete = callback})
end

--------------------------------------------------------------------------------
-- Adjusted so as to fall within the scope of the scroll.
--------------------------------------------------------------------------------
function M:ajustScrollPosition()
    local left, top = self:getPos()

    -- Clips the new position when bouncing is disabled
    if not self:isHBouncelEnabled() then
        local _
        left, _ = self:clipScrollPosition(left, top)
    end
    if not self:isVBounceEnabled() then
        local _
        _, top = self:clipScrollPosition(left, top)
    end

    self:setPos(left, top)
end

--------------------------------------------------------------------------------
-- Adjust the scroll size.
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
-- Computes the boundaries of the scroll area.
-- @return the min and max values of the scroll area
--------------------------------------------------------------------------------
function M:scrollBoundaries()
    local width, height = self:getSize()
    local parentWidth, parentHeight = self:getParent():getSize()
    local minX, minY = parentWidth - width, parentHeight - height
    local maxX, maxY = 0, 0

    return minX, minY, maxX, maxY
end

--------------------------------------------------------------------------------
-- Returns whether the input position is out of bounds.
-- @param left The x position
-- @param top The y position
-- @return boolean
--------------------------------------------------------------------------------
function M:isPositionOutOfBounds(left, top)
    local minX, minY, maxX, maxY = self:scrollBoundaries()

    return left < minX or left > maxX or top < minY or top > maxY
end

--------------------------------------------------------------------------------
-- Clips the input position to the size of the container
-- @param left The x position
-- @param top The y position
-- @return clipped left and top
--------------------------------------------------------------------------------
function M:clipScrollPosition(left, top)
    local minX, minY, maxX, maxY = self:scrollBoundaries()
    left = left < minX and minX or left
    left = left > maxX and maxX or left
    top  = top  < minY and minY or top
    top  = top  > maxY and maxY or top
    
    return left, top
end

--------------------------------------------------------------------------------
-- Returns whether the scrollTo animation is running.
-- @return boolean
--------------------------------------------------------------------------------
function M:isAnimating()
    return self._scrollToAnimation and self._scrollToAnimation:isRunning()
end

--------------------------------------------------------------------------------
-- Stops the scrollTo animation if it's running
-- @return none
--------------------------------------------------------------------------------
function M:stopAnimation()
    if self._scrollToAnimation then
        self._scrollToAnimation:stop()
        self._scrollToAnimation = nil
    end
end

--------------------------------------------------------------------------------
-- If you set a parent, you also change the scroll size.
-- @param value parent
--------------------------------------------------------------------------------
function M:setParent(value)
    super.setParent(self, value)
    self:ajustScrollSize()
end

--------------------------------------------------------------------------------
-- Dispose resourece.
--------------------------------------------------------------------------------
function M:dispose()
    super.dispose(self)
    self._disposed = true
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchDownHandler(e)
    if self._touchDownFlag then
        return
    end

    self._scrollingForceX = 0
    self._scrollingForceY = 0
    self._touchDownFlag = true
    self._touchDownIndex = e.idx

    -- User's input takes precedence over animation
    self:stopAnimation()
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchUpHandler(e)
    if self._touchDownIndex ~= e.idx then
        return
    end
    
    self._touchDownFlag = false
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchMoveHandler(e)
    if self._touchDownIndex ~= e.idx then
        return
    end
    if self._touchMoved then
        return
    end
    
    local scale = self:getLayer():getViewScale()
    local moveX, moveY = e.moveX, e.moveY
    self:setScrollingForce(moveX, moveY)
    
    moveX, moveY = self:getScrollingForce()

    -- Implements an elastic effect when we're dragging O.B.
    local minX, minY, maxX, maxY = self:scrollBoundaries()
    local left, top = self:getPos()
    local newLeft = left + moveX
    local newTop = top + moveY
    if newLeft < minX or newLeft > maxX then
        if not self:isHBouncelEnabled() then
            moveX = 0
        else
            local clippedLeft, clippedTop = self:clipScrollPosition(newLeft, newTop)
            local diff = math.distance(clippedLeft, clippedTop, newLeft, newTop)
            moveX = attenuation(diff) * moveX
        end
    end
    if newTop < minY or newTop > maxY then
        if not self:isVBounceEnabled() then
            moveY = 0
        else
            local clippedLeft, clippedTop = self:clipScrollPosition(newLeft, newTop)
            local diff = math.distance(clippedLeft, clippedTop, newLeft, newTop)
            moveY = attenuation(diff) * moveY
        end
    end

    self:addLoc(moveX, moveY, 0)
    self._touchMoved = true
end

--------------------------------------------------------------------------------
-- This event handler is called when you touch the component.
-- @param e touch event
--------------------------------------------------------------------------------
function M:touchCancelHandler(e)
    if self._touchDownIndex ~= e.idx then
        return
    end

    self._touchDownFlag = false
    self._touchDownIndex = nil
end

return M