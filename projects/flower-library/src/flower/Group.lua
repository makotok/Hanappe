----------------------------------------------------------------------------------------------------
-- A class to manage and control sets of DisplayObjects.
--
-- <h4>Extends:</h4>
-- <ul>
--   <li><a href="flower.DisplayObject.html">DisplayObject</a><l/i>
-- </ul>
--
-- @author Makoto
-- @release V3.0.0
----------------------------------------------------------------------------------------------------

-- import
local class = require "flower.class"
local table = require "flower.table"
local Config = require "flower.Config"
local DisplayObject = require "flower.DisplayObject"

-- class
local Group = class(DisplayObject)

---
-- The constructor.
-- @param layer (option)layer object
-- @param width (option)width
-- @param height (option)height
-- @see flower.DisplayObject
function Group:init(layer, width, height)
    Group.__super.init(self)

    self.children = {}
    self.isGroup = true
    self.layer = layer
    self.parentScissorRect = nil
    self.contentScissorRect = nil

    self:setSize(width or 0, height or 0)
    self:setPivToCenter()
end

---
-- Sets the size.
-- This is the size of a Group, rather than of the children.
-- @param width width
-- @param height height
function Group:setSize(width, height)
    self:setBounds(0, 0, 0, width, height, 0)
end

---
-- Sets the bounds.
-- This is the bounds of a Group, rather than of the children.
-- @param xMin xMin
-- @param yMin yMin
-- @param zMin zMin
-- @param xMax xMax
-- @param yMax yMax
-- @param zMax zMax
function Group:setBounds(xMin, yMin, zMin, xMax, yMax, zMax)
    Group.__index.setBounds(self, xMin, yMin, zMin, xMax, yMax, zMax)

    if self.contentScissorRect then
        self.contentScissorRect:setRect(xMin, yMin, xMax, yMax)
    end
end

---
-- Adds the specified child.
-- @param child DisplayObject
function Group:addChild(child)
    if table.insertIfAbsent(self.children, child) then
        child:setParent(self)

        if child.setLayer then
            child:setLayer(self.layer)
        elseif self.layer then
            self.layer:insertProp(child)
        end

        local scissorRect = self.contentScissorRect or self.parentScissorRect
        if scissorRect then
            if child.setParentScissorRect then
                child:setParentScissorRect(scissorRect)
            else
                child:setScissorRect(scissorRect)
            end
        end

        return true
    end
    return false
end

---
-- Removes a child.
-- @param child DisplayObject
-- @return True if removed.
function Group:removeChild(child)
    if table.removeElement(self.children, child) then
        child:setParent(nil)

        if child.setLayer then
            child:setLayer(nil)
        elseif self.layer then
            self.layer:removeProp(child)
        end

        local scissorRect = self.contentScissorRect or self.parentScissorRect
        if scissorRect then
            if child.setParentScissorRect then
                child:setParentScissorRect(nil)
            else
                child:setScissorRect(nil)
            end
        end

        return true
    end
    return false
end

---
-- Add the children.
function Group:addChildren(children)
    for i, child in ipairs(children) do
        self:addChild(child)
    end
end

---
-- Remove the children.
function Group:removeChildren()
    local children = table.copy(self.children)
    for i, child in ipairs(children) do
        self:removeChild(child)
    end
end

---
-- Set the children.
-- @param children
function Group:setChildren(children)
    self:removeChildren()
    self:addChildren(children)
end

---
-- Returns a child by name.
-- @param name child's name
-- @return child
function Group:getChildByName(name)
    for i, child in ipairs(self.children) do
        if child.name == name then
            return child
        end
        if child.isGroup and child.getChildByName ~= nil then
            local child2 = child:getChildByName(name)
            if child2 then
                return child2
            end
        end
    end
end

---
-- Sets the layer for this group to use.
-- @param layer MOAILayer object
function Group:setLayer(layer)
    if self.layer == layer then
        return
    end

    if self.layer then
        for i, v in ipairs(self.children) do
            if v.setLayer then
                v:setLayer(nil)
            else
                self.layer:removeProp(v)
            end
        end
    end

    self.layer = layer

    if self.layer then
        for i, v in ipairs(self.children) do
            if v.setLayer then
                v:setLayer(self.layer)
            else
                self.layer:insertProp(v)
            end
        end
    end
end

---
-- Sets the group's visibility.
-- Also sets the visibility of any children.
-- @param value visible
function Group:setVisible(value)
    DisplayObject.setVisible(self, value)

    -- Compatibility
    if not MOAIProp.INHERIT_VISIBLE then
        for i, v in ipairs(self.children) do
            v:setVisible(value)
        end
    end
end

---
-- Sets the group's priority.
-- Also sets the priority of any children.
-- @param priority priority
function Group:setPriority(priority)
    Group.__index.setPriority(self, priority)

    for i, v in ipairs(self.children) do
        v:setPriority(priority)
    end
end

---
-- Specify whether to scissor test the children.
-- @param scissorRect scissorRect
function Group:setScissorRect(scissorRect)
    Group.__index.setScissorRect(self, scissorRect)

    for i, child in ipairs(self.children) do
        if child.setParentScissorRect then
            child:setParentScissorRect(scissorRect)
        else
            child:setScissorRect(scissorRect)
        end
    end
end

function Group:setParentScissorRect(parentRect)
    self.parentScissorRect = parentRect

    if self.contentScissorRect then
        self.contentScissorRect:setScissorRect(self.parentScissorRect)
    else
        self:setScissorRect(self.parentScissorRect)
    end
end

---
-- Specify whether to scissor test the children.
-- If the group is moved, scissorRect to move.
-- @param enabled enabled
function Group:setScissorContent(enabled)
    if enabled then
        self.contentScissorRect = MOAIScissorRect.new()
        self.contentScissorRect:setRect(0, 0, self:getWidth(), self:getHeight())
        self.contentScissorRect:setScissorRect(self.parentScissorRect)
        self.contentScissorRect:setAttrLink(MOAITransform.INHERIT_TRANSFORM, self, MOAITransform.TRANSFORM_TRAIT)
        self:setScissorRect(self.contentScissorRect)
    else
        self.contentScissorRect = nil
        self:setScissorRect(self.parentScissorRect)
    end
end

return Group