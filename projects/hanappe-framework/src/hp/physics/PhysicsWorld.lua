--------------------------------------------------------------------------------
-- Class that inherits from MOAIBox2DWorld. <br>
-- Has been prepared to create an object, a useful function.
--------------------------------------------------------------------------------

local table = require("hp/lang/table")
local class = require("hp/lang/class")
local EventDispatcher = require("hp/event/EventDispatcher")
local PhysicsBody = require("hp/physics/PhysicsBody")
local MOAIPropUtil = require("hp/util/MOAIPropUtil")

local M = class(EventDispatcher)
local Interface = MOAIBox2DWorld.getInterfaceTable()

--------------------------------------------------------------------------------
-- This is the default parameter set to MOAIBox2DWorld.
--------------------------------------------------------------------------------
M.DEFUALT_PARAMS = {
    gravity = {0, 10},
    unitsToMeters = 0.06,
}

--------------------------------------------------------------------------------
-- Constants representing the type of the Body.
--------------------------------------------------------------------------------
M.BODY_TYPES = {
    dynamic = MOAIBox2DBody.DYNAMIC,
    static = MOAIBox2DBody.STATIC,
    kinematic = MOAIBox2DBody.KINEMATIC
}

----------------------------------------------------------------
-- Instance generating functions.<br>
-- Unlike an ordinary class, and based on the MOAI_CLASS.<br>
-- To inherit this function is not recommended.<br>
-- @param ... params.
-- @return instance.
----------------------------------------------------------------
function M:new(...)
    local obj = MOAIBox2DWorld.new()
    table.copy(self, obj)
    
    if obj.init then
        obj:init(...)
    end
    
    obj.init = nil
    obj.new = nil
    
    return obj
end

--------------------------------------------------------------------------------
-- The constructor.
-- @param params 
--------------------------------------------------------------------------------
function M:init(params)
    params = params or M.DEFUALT_PARAMS
    self:copyParams(params)
end

--------------------------------------------------------------------------------
-- Set the parameter setter function.
-- @param params Parameter is set to Object.<br>
--      (params:gravity, unitsToMeters)
--------------------------------------------------------------------------------
function M:copyParams(params)
    if params.gravity then
        self:setGravity(unpack(params.gravity))
    end
    if params.unitsToMeters then
        self:setUnitsToMeters(params.unitsToMeters)
    end
end

--------------------------------------------------------------------------------
-- Create a Body based on MOAIProp.
-- @param prop MOAIProp instance.
-- @param bodyType The type of the Body.
-- @param ... physicsDatas. Data that was created in PhysicsEditor can be used.
-- @return PhysicsBody instance.
--------------------------------------------------------------------------------
function M:createBodyFromProp(prop, bodyType, ...)
    local params = {...}
    if #params == 0 then
        table.insert(params, {shape == "rectangle"})
    end
    
    local body = self:addBody(bodyType)
    local width, height = MOAIPropUtil.getSize(prop)
    local xMin, yMin, xMax, yMax = -width / 2, -height / 2, width / 2, height / 2
    
    for i, data in ipairs(params) do
        data = table.copy(data)
        data.shape = data.shape or "rectangle"
        if data.shape == "rectangle" then
            data.xMin = data.xMin or xMin
            data.yMin = data.yMin or yMin
            data.xMax = data.xMax or xMax
            data.yMax = data.yMax or yMax
        elseif data.shape == "circle" then
            data.radius = data.radius or width / 2
            data.center = data.center or {x = 0, y = 0}
        end
        body:addPhysicsData(data)
    end

    MOAIPropUtil.setPos(prop, xMin, yMin)
    prop:setParent(body)
    prop.body = body
    body.prop = prop
    
    body:resetMassData()
    return body
end

--------------------------------------------------------------------------------
-- To create a rectangle.
-- @return PhysicsBody instance.
--------------------------------------------------------------------------------
function M:createRect(left, top, width, height, params)
    params = params or {}
    
    local body = self:addBody(params.type)
    local fixture = body:addRect(0, 0, width, height)
    fixture:copyParams(params)
    
    body:setPos(left, top)
    body:resetMassData()
    return body
end

--------------------------------------------------------------------------------
-- Add the PhysicsBody object.
-- @param bodyType Can also be specified in the extended string.
-- @return PhysicsBody instance.
--------------------------------------------------------------------------------
function M:addBody(bodyType)
    bodyType = bodyType or "dynamic"
    bodyType = type(bodyType) == "string" and M.BODY_TYPES[bodyType] or bodyType
    return PhysicsBody(Interface.addBody(self, bodyType))
end


return M