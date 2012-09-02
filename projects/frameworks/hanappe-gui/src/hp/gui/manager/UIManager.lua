--------------------------------------------------------------------------------
-- Componentの管理するマネージャです.
--------------------------------------------------------------------------------

-- import
local table         = require "hp/lang/table"
local Executors     = require "hp/util/Executors"
local FocusManager  = require "hp/gui/manager/FocusManager"

-- module
local M = {}

touchDownedComponents = {}

--------------------------------------------------------------------------------
-- private functions
--------------------------------------------------------------------------------

local function isComponent(obj)
    if not obj.instanceOf or not obj:instanceOf(Component) then
        return false
    end
    return true
end

local function isTouchDowned(obj)
    for i, v, in ipairs(touchDownedComponents) do
        if v == obj then
            return true
        end
    end
    return false
end

local function internalTouchCommon(obj, e, func)
    local children = obj:getChildren()
    for i = #children, 1, -1 do
        local child = children[i]
        if isComponent(child) then
            if func(child, e) then
                return true
            end
        end
    end
end

local function internalTouchDown(obj, e)
    internalTouchCommon(obj, e, internalTouchDown)
    
    if isComponent(obj) and obj:hitTestWorld(e.worldX, e.worldY) then
        if obj:isFocusEnabled() then
            FocusManager:setFocus(obj)
        end
        component:dispatchEvent(e)
        table.insertElement(touchDownedComponents, obj)
    end
    return e.stoped
end

local function internalTouchMove(obj, e)
    internalTouchCommon(obj, e, internalTouchMove)
    
    for i, v in ipairs(touchDownedComponents) do
        component:dispatchEvent(e)
    end
    return e.stoped
end

local function internalTouchUp(obj, e)
    internalTouchCommon(obj, e, internalTouchUp)
    
    if isComponent(obj) and (isTouchDowned(obj) or obj:hitTestWorld(e.worldX, e.worldY)) then
        component:dispatchEvent(e)
    end
    return e.stoped
end

--------------------------------------------------------------------------------
-- public functions
--------------------------------------------------------------------------------

function M

return M
