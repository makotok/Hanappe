----------------------------------------------------------------------------------------------------
-- The base class of the display object, adding several useful methods.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.EventDispatcher.html">EventDispatcher</a><l/i>
--   <li><a href="http://moaiforge.github.io/moai-sdk/api/latest/class_m_o_a_i_prop.html">MOAIProp</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Config = require "flower.Config"
local EventDispatcher = require "flower.EventDispatcher"

-- class
local DisplayObject = class(EventDispatcher)
DisplayObject.__index = MOAIProp.getInterfaceTable()
DisplayObject.__moai_class = MOAIProp

---
-- The constructor.
function DisplayObject:init()
    DisplayObject.__super.init(self)
    self.touchEnabled = true

    if Config.BLEND_MODE then
        self:setBlendMode(unpack(Config.BLEND_MODE))
    end
end

---
-- Returns the size.
-- If there is a function that returns a negative getDims.
-- getSize function always returns the size of the positive.
-- @return width, height, depth
function DisplayObject:getSize()
    local w, h, d = self:getDims()
    w = w or 0
    h = h or 0
    d = d or 0
    return math.abs(w), math.abs(h), math.abs(d)
end

---
-- Returns the width.
-- @return width
function DisplayObject:getWidth()
    local w, h, d = self:getSize()
    return w
end

---
-- Returns the height.
-- @return height
function DisplayObject:getHeight()
    local w, h, d = self:getSize()
    return h
end

---
-- Sets the position.
-- Without depending on the Pivot, move the top left corner as the origin.
-- @param left Left position
-- @param top Top position
function DisplayObject:setPos(left, top)
    local xMin, yMin, zMin, xMax, yMax, zMax = self:getBounds()
    xMin = math.min(xMin or 0, xMax or 0)
    yMin = math.min(yMin or 0, yMax or 0)

    local pivX, pivY, pivZ = self:getPiv()
    local locX, locY, locZ = self:getLoc()
    self:setLoc(left + pivX - xMin, top + pivY - yMin, locZ)
end

---
-- Returns the position.
-- @return Left
-- @return Top
function DisplayObject:getPos()
    local xMin, yMin, zMin, xMax, yMax, zMax = self:getBounds()
    xMin = math.min(xMin or 0, xMax or 0)
    yMin = math.min(yMin or 0, yMax or 0)

    local pivX, pivY, pivZ = self:getPiv()
    local locX, locY, locZ = self:getLoc()
    return locX - pivX + xMin, locY - pivY + yMin
end

---
-- Returns the left position.
-- @return left
function DisplayObject:getLeft()
    local left, top = self:getPos()
    return left
end

---
-- Set the left position.
-- @param value left position.
function DisplayObject:setLeft(value)
    local left, top = self:getPos()
    self:setPos(value, top)    
end

---
-- Returns the top position.
-- @return top
function DisplayObject:getTop()
    local left, top = self:getPos()
    return top
end

---
-- Set the top position.
-- @param value top position.
function DisplayObject:setTop(value)
    local left, top = self:getPos()
    self:setPos(left, value)    
end

---
-- Returns the right position.
-- @return right
function DisplayObject:getRight()
    local left, top = self:getPos()
    local width, height = self:getSize()
    return left + width
end

---
-- Set the right position.
-- @param value right position.
function DisplayObject:setRight(value)
    local left, top = self:getPos()
    self:setPos(value - self:getWidth(), top)    
end

---
-- Returns the bottom position.
-- @return bottom
function DisplayObject:getBottom()
    local left, top = self:getPos()
    local width, height = self:getSize()
    return top + height
end

---
-- Set the bottom position.
-- @param value bottom position.
function DisplayObject:setBottom(value)
    local left, top = self:getPos()
    self:setPos(left, value - self:getHeight())    
end

---
-- Returns the color.
-- @return red, green, blue, alpha
function DisplayObject:getColor()
    local r = self:getAttr(MOAIColor.ATTR_R_COL)
    local g = self:getAttr(MOAIColor.ATTR_G_COL)
    local b = self:getAttr(MOAIColor.ATTR_B_COL)
    local a = self:getAttr(MOAIColor.ATTR_A_COL)
    return r, g, b, a
end

---
-- Sets the piv (the anchor around which the object can 'pivot') to the object's center.
function DisplayObject:setPivToCenter()
    local w, h, d = self:getSize()
    local left, top = self:getPos()
    self:setPiv(w / 2, h / 2, 0)
    self:setPos(left, top)
end

---
-- Returns whether or not the object is currently visible or invisible.
-- @return visible
function DisplayObject:getVisible()
    return self:getAttr(MOAIProp.ATTR_VISIBLE) > 0
end

---
-- Sets the visibility.
-- TODO:I avoid the bug of display settings MOAIProp.(2013/05/20 last build)
-- @param visible visible
function DisplayObject:setVisible(visible)
    DisplayObject.__index.setVisible(self, visible)
    self:forceUpdate()
end

---
-- Sets the object's parent, inheriting its color and transform.
-- @param parent parent
function DisplayObject:setParent(parent)
    self.parent = parent

    self:clearAttrLink(MOAIColor.INHERIT_COLOR)
    self:clearAttrLink(MOAITransform.INHERIT_TRANSFORM)

    -- Conditions compatibility
    if MOAIProp.INHERIT_VISIBLE then
        self:clearAttrLink(MOAIProp.INHERIT_VISIBLE)
    end

    if parent then
        self:setAttrLink(MOAIColor.INHERIT_COLOR, parent, MOAIColor.COLOR_TRAIT)
        self:setAttrLink(MOAITransform.INHERIT_TRANSFORM, parent, MOAITransform.TRANSFORM_TRAIT)

        -- Conditions compatibility
        if MOAIProp.INHERIT_VISIBLE then
            self:setAttrLink(MOAIProp.INHERIT_VISIBLE, parent, MOAIProp.ATTR_VISIBLE)
        end
    end
end

---
-- Insert the DisplayObject's prop into a given Moai layer.
-- @param layer
function DisplayObject:setLayer(layer)
    if self.layer == layer then
        return
    end

    if self.layer then
        self.layer:removeProp(self)
    end

    self.layer = layer

    if self.layer then
        layer:insertProp(self)
    end
end

---
-- Set the scissor rect.
-- @param scissorRect scissorRect
function DisplayObject:setScissorRect(scissorRect)
    DisplayObject.__index.setScissorRect(self, scissorRect)
    self.scissorRect = scissorRect
end

---
-- Enables this object for touch events.
-- @param value enabled
function DisplayObject:setTouchEnabled(value)
    if self.touchEnabled == value then
        return
    end
    self.touchEnabled = value
end

---
-- Returns the enabled for touch events.
-- @return value enabled
function DisplayObject:isTouchEnabled()
    if self.parent then
        return self.parent:isTouchEnabled() and self.touchEnabled ~= false
    end
    return self.touchEnabled ~= false
end

return DisplayObject