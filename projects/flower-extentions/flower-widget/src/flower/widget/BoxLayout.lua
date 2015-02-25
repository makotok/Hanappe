--------------------------------------------------------------------------------
-- This is the class that sets the layout of the box.
--
-- @author Makoto
-- @release V3.0.0
--------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Logger = require "flower.Logger"
local UILayout = require "flower.widget.UILayout"

-- class
local BoxLayout = class(UILayout)

--- Horizotal Align: left
BoxLayout.HORIZONTAL_LEFT = "left"

--- Horizotal Align: center
BoxLayout.HORIZONTAL_CENTER = "center"

--- Horizotal Align: right
BoxLayout.HORIZONTAL_RIGHT = "right"

--- Vertical Align: top
BoxLayout.VERTICAL_TOP = "top"

--- Vertical Align: center
BoxLayout.VERTICAL_CENTER = "center"

--- Vertical Align: bottom
BoxLayout.VERTICAL_BOTTOM = "bottom"

--- Layout Direction: vertical
BoxLayout.DIRECTION_VERTICAL = "vertical"

--- Layout Direction: horizontal
BoxLayout.DIRECTION_HORIZONTAL = "horizontal"

--- Layout Policy: none
BoxLayout.LAYOUT_POLICY_NONE = "none"

--- Layout Policy: fitContent
BoxLayout.LAYOUT_POLICY_FIT_CONTENT = "fitContent"

--- Layout Policy: fillParent
BoxLayout.LAYOUT_POLICY_FILL_PARENT = "fillParent"

---
-- Initializes the internal variables.
function BoxLayout:_initInternal()
    self._horizontalAlign = BoxLayout.HORIZONTAL_LEFT
    self._horizontalGap = 0
    self._verticalAlign = BoxLayout.VERTICAL_TOP
    self._verticalGap = 0
    self._paddingTop = 0
    self._paddingBottom = 0
    self._paddingLeft = 0
    self._paddingRight = 0
    self._direction = BoxLayout.DIRECTION_VERTICAL
    self._layoutPolicy = {BoxLayout.LAYOUT_POLICY_FIT_CONTENT, BoxLayout.LAYOUT_POLICY_FIT_CONTENT}
end

---
-- Update the layout.
-- @param parent parent
function BoxLayout:update(parent)
    if self._direction == BoxLayout.DIRECTION_VERTICAL then
        self:updateVertical(parent)
    elseif self._direction == BoxLayout.DIRECTION_HORIZONTAL then
        self:updateHorizotal(parent)
    else
        Logger.warn("Illegal direction pattern !", self._direction)
    end
end

---
-- Sets the position of an objects in the vertical direction.
-- @param parent
function BoxLayout:updateVertical(parent)
    local children = parent.children
    local childrenWidth, childrenHeight = self:calcVerticalLayoutSize(children)

    local hPolicy, vPolicy = unpack(self._layoutPolicy)
    local parentWidth, parentHeight = parent:getSize()
    parentWidth = hPolicy == BoxLayout.LAYOUT_POLICY_FIT_CONTENT and math.max(parentWidth, childrenWidth) or parentWidth
    parentHeight =  vPolicy == BoxLayout.LAYOUT_POLICY_FIT_CONTENT and math.max(parentHeight, childrenHeight) or parentHeight

    if hPolicy ~= BoxLayout.LAYOUT_POLICY_NONE or vPolicy ~= BoxLayout.LAYOUT_POLICY_NONE then
        parent:setSize(parentWidth, parentHeight)
    end

    local childY = self:calcChildY(parentHeight, childrenHeight)
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local childWidth, childHeight = child:getSize()
            local childX = self:calcChildX(parentWidth, childWidth)
            child:setPos(childX, childY)
            childY = childY + childHeight + self._verticalGap
        end
    end
end

---
-- Sets the position of an objects in the horizontal direction.
-- @param parent
function BoxLayout:updateHorizotal(parent)
    local children = parent.children
    local childrenWidth, childrenHeight = self:calcHorizotalLayoutSize(children)

    local hPolicy, vPolicy = unpack(self._layoutPolicy)
    local parentWidth, parentHeight = parent:getSize()
    parentWidth = hPolicy == BoxLayout.LAYOUT_POLICY_FIT_CONTENT and math.max(parentWidth, childrenWidth) or parentWidth
    parentHeight =  vPolicy == BoxLayout.LAYOUT_POLICY_FIT_CONTENT and math.max(parentHeight, childrenHeight) or parentHeight

    if hPolicy ~= BoxLayout.LAYOUT_POLICY_NONE or vPolicy ~= BoxLayout.LAYOUT_POLICY_NONE then
        parent:setSize(parentWidth, parentHeight)
    end

    local childX = self:calcChildX(parentWidth, childrenWidth)
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local childWidth, childHeight = child:getSize()
            local childY = self:calcChildY(parentHeight, childHeight)
            child:setPos(childX, childY)
            childX = childX + childWidth + self._horizontalGap
        end
    end
end

---
-- Calculates the x position of the child object.
-- @param parentWidth parent width.
-- @param childWidth child width.
-- @return x position.
function BoxLayout:calcChildX(parentWidth, childWidth)
    local diffWidth = parentWidth - childWidth

    local x = 0
    if self._horizontalAlign == BoxLayout.HORIZONTAL_LEFT then
        x = self._paddingLeft
    elseif self._horizontalAlign == BoxLayout.HORIZONTAL_CENTER then
        x = math.floor((diffWidth + self._paddingLeft - self._paddingRight) / 2)
    elseif self._horizontalAlign == BoxLayout.HORIZONTAL_RIGHT then
        x = diffWidth - self._paddingRight
    else
        error("Not found direction!")
    end
    return x
end

---
-- Calculates the y position of the child object.
-- @param parentHeight parent width.
-- @param childHeight child width.
-- @return y position.
function BoxLayout:calcChildY(parentHeight, childHeight)
    local diffHeight = parentHeight - childHeight

    local y = 0
    if self._verticalAlign == BoxLayout.VERTICAL_TOP then
        y = self._paddingTop
    elseif self._verticalAlign == BoxLayout.VERTICAL_CENTER then
        y = math.floor((diffHeight + self._paddingTop - self._paddingBottom) / 2)
    elseif self._verticalAlign == BoxLayout.VERTICAL_BOTTOM then
        y = diffHeight - self._paddingBottom
    else
        error("Not found direction!")
    end
    return y
end

---
-- Calculate the layout size in the vertical direction.
-- @param children children
-- @return layout width
-- @return layout height
function BoxLayout:calcVerticalLayoutSize(children)
    local width = self._paddingLeft + self._paddingRight
    local height = self._paddingTop + self._paddingBottom
    local count = 0
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local cWidth, cHeight = child:getSize()
            height = height + cHeight + self._verticalGap
            width = math.max(width, cWidth + self._paddingLeft + self._paddingRight)
            count = count + 1
        end
    end
    if count > 1 then
        height = height - self._verticalGap
    end
    return width, height
end

---
-- Calculate the layout size in the horizontal direction.
-- @param children children
-- @return layout width
-- @return layout height
function BoxLayout:calcHorizotalLayoutSize(children)
    local width = self._paddingLeft + self._paddingRight
    local height = self._paddingTop + self._paddingBottom
    local count = 0
    for i, child in ipairs(children) do
        if not child._excludeLayout then
            local cWidth, cHeight = child:getSize()
            width = width + cWidth + self._horizontalGap
            height = math.max(height, cHeight + self._paddingTop + self._paddingBottom)
            count = count + 1
        end
    end
    if count > 1 then
        width = width - self._horizontalGap
    end
    return width, height
end

---
-- Set the padding.
-- @param left left padding
-- @param top top padding
-- @param right right padding
-- @param bottom bottom padding
function BoxLayout:setPadding(left, top, right, bottom)
    self._paddingLeft = left or self._paddingTop
    self._paddingTop = top or self._paddingTop
    self._paddingRight = right or self._paddingRight
    self._paddingBottom = bottom or self._paddingBottom
end

---
-- Set the alignment.
-- @param horizontalAlign horizontal align
-- @param verticalAlign vertical align
function BoxLayout:setAlign(horizontalAlign, verticalAlign)
    self._horizontalAlign = horizontalAlign
    self._verticalAlign = verticalAlign
end

---
-- Set the direction.
-- @param direction direction("horizontal" or "vertical")
function BoxLayout:setDirection(direction)
    self._direction = direction == "horizotal" and "horizontal" or direction
end

---
-- Set the gap.
-- @param horizontalGap horizontal gap
-- @param verticalGap vertical gap
function BoxLayout:setGap(horizontalGap, verticalGap)
    self._horizontalGap = horizontalGap
    self._verticalGap = verticalGap
end

---
-- Set the layout policy.
-- @param horizontalPolicy horizontal policy
-- @param verticalPolicy vertical policy
function BoxLayout:setLayoutPolicy(horizontalPolicy, verticalPolicy)
    self._layoutPolicy = {horizontalPolicy or BoxLayout.LAYOUT_POLICY_NONE, verticalPolicy or BoxLayout.LAYOUT_POLICY_NONE}
end

return BoxLayout