--------------------------------------------------------------------------------
-- The base class for all display objects. <br>
-- To inherit MOAIPropUtil, you can use the convenience function. <br>
-- To inherit EventDispatcher, you can use the event notification. <br>
-- <br>
-- Use the MOAIProp class. <br>
-- By changing the M.MOAI_CLASS, you can change to another class. <br>
-- See MOAIProp.<br>
-- Base Classes => EventDispatcher, MOAIPropUtil<br>
--------------------------------------------------------------------------------

-- import
local class                 = require "hp/lang/class"
local table                 = require "hp/lang/table"
local EventDispatcher       = require "hp/event/EventDispatcher"
local MOAIPropUtil          = require "hp/util/MOAIPropUtil"
local PropertyUtil          = require "hp/util/PropertyUtil"

-- class
local M                     = class(EventDispatcher, MOAIPropUtil)
local MOAIPropInterface     = MOAIProp.getInterfaceTable()

-- constraints
M.MOAI_CLASS                = MOAIProp
M.PRIORITY_PROPERTIES       = {
    "texture",
}

--------------------------------------------------------------------------------
-- Instance generating functions.<br>
-- Unlike an ordinary class, and based on the MOAI_CLASS.<br>
-- To inherit this function is not recommended.<br>
-- @param ... params.
-- @return instance.
--------------------------------------------------------------------------------
function M:new(...)
    local obj = self.MOAI_CLASS.new()
    table.copy(self, obj)

    EventDispatcher.init(obj)

    if obj.init then
        obj:init(...)
    end

    obj.new = nil
    obj.init = nil
    
    return obj
end

--------------------------------------------------------------------------------
-- The constructor.
--------------------------------------------------------------------------------
function M:init(...)
    self._touchEnabled = true
end

--------------------------------------------------------------------------------
-- Set the name.
-- @param name Object name.<br>
--------------------------------------------------------------------------------
function M:setName(name)
    self.name = name
end

--------------------------------------------------------------------------------
-- Returns the name.
-- @return Object name.
--------------------------------------------------------------------------------
function M:getName()
    return self.name
end

--------------------------------------------------------------------------------
-- Sets the parent.
-- @return parent object.
--------------------------------------------------------------------------------
function M:getParent()
    return self._parent
end

--------------------------------------------------------------------------------
-- Sets the parent.
-- @param parent parent
--------------------------------------------------------------------------------
function M:setParent(parent)
    if parent == self:getParent() then
        return
    end
    
    -- remove
    if self._parent and self._parent.isGroup then
        self._parent:removeChild(self)
    end
    
    -- set
    MOAIPropInterface.setParent(self, parent)
    self._parent = parent
    
    -- add
    if parent and parent.isGroup then
        parent:addChild(self)
    end
end

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.<br>
--------------------------------------------------------------------------------
function M:copyParams(params)
    if not params then
        return
    end

    -- copy priority properties
    local priorityParams = {}
    if self.PRIORITY_PROPERTIES then
        for i, v in ipairs(self.PRIORITY_PROPERTIES) do
            priorityParams[v] = params[v]
            params[v] = nil
        end
        PropertyUtil.setProperties(self, priorityParams, true)
    end
    
    -- priority properties
    PropertyUtil.setProperties(self, params, true)
    
    -- reset params
    if self.PRIORITY_PROPERTIES then
        for i, v in ipairs(self.PRIORITY_PROPERTIES) do
            params[v] = priorityParams[v]
        end
    end
end

--------------------------------------------------------------------------------
-- Set the MOAILayer instance.
--------------------------------------------------------------------------------
function M:setLayer(layer)
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

--------------------------------------------------------------------------------
-- Returns the MOAILayer.
--------------------------------------------------------------------------------
function M:getLayer()
    return self.layer
end

--------------------------------------------------------------------------------
-- Event Handler
--------------------------------------------------------------------------------
function M:getNestLevel()
    local parent = self:getParent()
    if parent and parent.getNestLevel then
        return parent:getNestLevel() + 1
    end
    return 1
end


--------------------------------------------------------------------------------
-- Sets the touch enabled.
-- @param value touch enabled.
--------------------------------------------------------------------------------
function M:setTouchEnabled(value)
    self._touchEnabled = value
end

--------------------------------------------------------------------------------
-- Sets the touch enabled.
-- @param value touch enabled.
--------------------------------------------------------------------------------
function M:isTouchEnabled()
    return self._touchEnabled
end

--------------------------------------------------------------------------------
-- Dispose resourece.
--------------------------------------------------------------------------------
function M:dispose()
    local parent = self:getParent()
    if parent and parent.isGroup then
        parent:removeChild(self)
    end
    
    self:setLayer(nil)
end

--------------------------------------------------------------------------------
-- If the object will collide with the screen, it returns true.<br>
-- TODO:If you are rotating, it will not work.
-- @param prop MOAIProp object
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestObject(prop)
    local worldX, worldY = prop:getWorldLoc()
    local x, y = prop:getLoc()
    local diffX, diffY = worldX - x, worldY - y

    local left, top = MOAIPropUtil.getLeft(prop) + diffX, MOAIPropUtil.getTop(prop) + diffY
    local right, bottom = MOAIPropUtil.getRight(prop) + diffX, MOAIPropUtil.getBottom(prop) + diffY
    
    if self:inside(left, top, 0) then
        return true
    end
    if self:inside(right, bottom, 0) then
        return true
    end
    if self:inside(left, bottom, 0) then
        return true
    end
    if self:inside(right, bottom, 0) then
        return true
    end
    return false
end

--------------------------------------------------------------------------------
-- If the object will collide with the screen, it returns true.<br>
-- @param screenX x of screen
-- @param screenY y of screen
-- @param screenZ (option)z of screen
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestScreen(screenX, screenY, screenZ)
    assert(self.layer)
    
    screenZ = screenZ or 0
    
    local worldX, worldY, worldZ = self.layer:wndToWorld(screenX, screenY, screenZ)
    return self:inside(worldX, worldY, worldZ)
end

--------------------------------------------------------------------------------
-- If the object will collide with the world, it returns true.<br>
-- @param worldX world x of layer
-- @param worldY world y of layer
-- @param worldZ (option)world z of layer
-- @return If the object is a true conflict
--------------------------------------------------------------------------------
function M:hitTestWorld(worldX, worldY, worldZ)
    worldZ = worldZ or 0
    return self:inside(worldX, worldY, worldZ)
end

return M